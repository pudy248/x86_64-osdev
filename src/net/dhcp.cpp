#include <cstdint>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <net/arp.hpp>
#include <net/config.hpp>
#include <net/dhcp.hpp>
#include <net/net.hpp>
#include <net/udp.hpp>
#include <stl/view.hpp>

dhcp_lease active_lease;

constexpr static uint32_t COOKIE = 0x63538263;
constexpr const char* HOSTNAME = "KATEOS_DESKTOP";
constexpr const char* VENDOR = "KATEOS";

void dhcp_set_active(const dhcp_lease& l) {
	active_lease = l;
	net_update_ip(l.yiaddr);
	printf("[DHCP] New lease!\n"
		   "    IP address: %I\n"
		   "    Subnet Mask: %I\n"
		   "    Router: %I\n"
		   "    DNS Server: %I\n"
		   "    Duration: %isec\n",
		   active_lease.yiaddr, active_lease.subnet_mask, active_lease.router, active_lease.dns, active_lease.duration);
}

dhcp_lease dhcp_query(ipv4_t preferred_ip) {
lbl_discover:
	dhcp_packet p;
	uint32_t xid = rdtsc();
	timepoint t1 = timepoint::now();
	dhcp_discover(xid, preferred_ip);
	while (1) {
		if (dhcp_get(DHCP_CLIENT_PORT, xid, p)) { break; }
		if (timepoint::now() - t1 > units::seconds(5.)) goto lbl_discover;
	}
	dhcp_lease l = dhcp_parse_response(p, DHCP_MTYPE::OFFER);
	kfree(p.b.frame_begin);
lbl_request:
	timepoint t2 = timepoint::now();
	dhcp_request(xid, l);
	while (1) {
		if (dhcp_get(DHCP_CLIENT_PORT, xid, p)) { break; }
		if (timepoint::now() - t2 > units::seconds(1.)) goto lbl_request;
		if (timepoint::now() - t1 > units::seconds(5.)) goto lbl_discover;
	}
	arp_update(p.i.src_mac, p.i.src_ip);
	l = dhcp_parse_response(p, DHCP_MTYPE::ACK);
	kfree(p.b.frame_begin);
	l.established = timepoint::now();
	return l;
}

bool dhcp_get(uint16_t port, uint32_t xid, dhcp_packet& out_packet) {
	udp_packet p = {};
	if (!udp_get(port, p)) return false;
	dhcp_header* h = (dhcp_header*)p.b.data_begin;
	if (h->xid != xid) {
		udp_forward(p);
		return false;
	}
	out_packet = { { p.i, h }, p.b };
	return true;
}

bool dhcp_get(udp_conn_t conn, uint32_t xid, dhcp_packet& out_packet) {
	udp_packet p = {};
	if (!udp_get(conn, p)) return false;
	dhcp_header* h = (dhcp_header*)p.b.data_begin;
	if (h->xid != xid) {
		udp_forward(p);
		return false;
	}
	out_packet = { { p.i, h }, p.b };
	return true;
}

void dhcp_discover(uint32_t xid, ipv4_t preferred_ip) {
	if (DHCP_LOG) qprintf<128>("[DHCP] <XID %08x> Discover: Preferred IP %I.\n", xid, preferred_ip);
	net_buffer_t buf = udp_new(sizeof(dhcp_header) + 64);
	dhcp_header* dhcp = (dhcp_header*)buf.data_begin;
	dhcp->op = 1;
	dhcp->htype = HTYPE::ETH;
	dhcp->hlen = 6;
	dhcp->hops = 0;
	dhcp->xid = xid;
	dhcp->secs = 0;
	dhcp->flags = htons(0x8000); // Broadcast
	dhcp->ciaddr = 0;
	dhcp->yiaddr = 0;
	dhcp->siaddr = 0;
	dhcp->giaddr = 0;
	memcpy<1>(dhcp->chaddr, &global_mac, 6);
	bzero<1>(dhcp->padding, sizeof(dhcp->padding));
	dhcp->cookie = COOKIE;

	obinstream<> s{ (uint8_t*)(dhcp + 1) };
	write_tlv<uint8_t, false>({ DHCP_OPT::MESSAGE_TYPE, span<const uint8_t>({ DHCP_MTYPE::DISCOVER }) }, s);

	if (preferred_ip) write_tlv<uint8_t, false>({ DHCP_OPT::REQUEST_IP, span<uint8_t>((uint8_t*)&preferred_ip, 4) }, s);
	uint8_t cid[7] = { HTYPE::ETH };
	span(cid, 7).blit(span((uint8_t*)&global_mac, 6), 1);
	write_tlv<uint8_t, false>({ DHCP_OPT::CLIENT_IDENT, span(cid, 7) }, s);
	write_tlv<uint8_t, false>({ DHCP_OPT::HOST_NAME, rostring(HOSTNAME).reinterpret_as<uint8_t>() }, s);
	write_tlv<uint8_t, false>({ DHCP_OPT::VENDOR_IDENT, rostring(VENDOR).reinterpret_as<uint8_t>() }, s);

	uint8_t prl[] = {
		DHCP_OPT::SUBNET,	   DHCP_OPT::ROUTER,	 DHCP_OPT::NTP_SERVER,
		DHCP_OPT::DHCP_SERVER, DHCP_OPT::DNS_SERVER, DHCP_OPT::BROADCAST_ADDR,
	};
	write_tlv<uint8_t, false>({ DHCP_OPT::PRL, span(prl, sizeof(prl)) }, s);
	s.write((uint8_t)DHCP_OPT::END);
	//bzero<1>(s.begin(), ((uint8_t*)(dhcp + 1) + 64) - s.begin());
	udp_info npi;
	npi.dst_ip = 0xffffffff;
	npi.src_port = DHCP_CLIENT_PORT;
	npi.dst_port = DHCP_SERVER_PORT;
	udp_send({ npi, buf });
}

dhcp_lease dhcp_parse_response(dhcp_packet packet, uint8_t expected_mtype) {
	dhcp_header* dhcp = packet.i.header;
	dhcp_lease l;
	memcpy<1>(&l.chaddr, dhcp->chaddr, 6);
	l.yiaddr = dhcp->yiaddr;
	l.siaddr = dhcp->siaddr;

	ibinstream<> s{ (uint8_t*)(packet.b.data_begin) + sizeof(dhcp_header),
					(uint8_t*)(packet.b.data_begin) + packet.b.data_size };
	tlv_option_t<uint8_t, false> opt = {};
	do {
		opt = read_tlv<uint8_t, false>(s);
		switch (opt.opt) {
		case DHCP_OPT::SUBNET: l.subnet_mask = *(ipv4_t*)opt.value.begin(); break;
		case DHCP_OPT::ROUTER: l.router = *(ipv4_t*)opt.value.begin(); break;
		case DHCP_OPT::DNS_SERVER: l.dns = *(ipv4_t*)opt.value.begin(); break;
		case DHCP_OPT::DHCP_SERVER: l.server_ident = *(ipv4_t*)opt.value.begin(); break;
		case DHCP_OPT::MESSAGE_TYPE:
			if (opt.value[0] != expected_mtype) {
				qprintf<128>("[DHCP] Expected message type %i, got %i\n", expected_mtype, opt.value[0]);
				return {};
			}
		case DHCP_OPT::LEASE_TIME: l.duration.rep = htonl(*(uint32_t*)opt.value.begin()); break;
		default: break;
		}
	} while (opt.opt != DHCP_OPT::END);
	if (DHCP_LOG)
		qprintf<128>("[DHCP] <XID %08x> Response from %I: %s, IP address %I\n", dhcp->xid, l.server_ident,
					 expected_mtype == DHCP_MTYPE::OFFER ? "Offer" : "ACK", l.yiaddr);
	return l;
}

void dhcp_request(uint32_t xid, const dhcp_lease& offer) {
	if (DHCP_LOG)
		qprintf<128>("[DHCP] <XID %08x> Request to %I - Target IP %I.\n", xid, offer.server_ident, offer.yiaddr);
	net_buffer_t buf = udp_new(sizeof(dhcp_header) + 64);
	dhcp_header* dhcp = (dhcp_header*)buf.data_begin;
	dhcp->op = 1;
	dhcp->htype = HTYPE::ETH;
	dhcp->hlen = 6;
	dhcp->hops = 0;
	dhcp->xid = xid;
	dhcp->secs = 0;
	dhcp->flags = htons(0x8000); // Broadcast
	dhcp->ciaddr = 0;
	dhcp->yiaddr = 0;
	dhcp->siaddr = 0;
	dhcp->giaddr = 0;
	memcpy<1>(dhcp->chaddr, &global_mac, 6);
	//bzero<1>(dhcp->padding, sizeof(dhcp->padding));
	dhcp->cookie = COOKIE;

	obinstream<> s{ (uint8_t*)(dhcp + 1) };
	write_tlv<uint8_t, false>({ DHCP_OPT::MESSAGE_TYPE, span<const uint8_t>({ DHCP_MTYPE::REQUEST }) }, s);
	uint8_t cid[7] = { HTYPE::ETH };
	span(cid, 7).blit(span((uint8_t*)&global_mac, 6), 1);
	write_tlv<uint8_t, false>({ DHCP_OPT::CLIENT_IDENT, span(cid, 7) }, s);
	write_tlv<uint8_t, false>({ DHCP_OPT::REQUEST_IP, span<uint8_t>((uint8_t*)&offer.yiaddr, 4) }, s);
	write_tlv<uint8_t, false>({ DHCP_OPT::DHCP_SERVER, span<uint8_t>((uint8_t*)&offer.server_ident, 4) }, s);
	write_tlv<uint8_t, false>({ DHCP_OPT::HOST_NAME, rostring(HOSTNAME).reinterpret_as<uint8_t>() }, s);
	write_tlv<uint8_t, false>({ DHCP_OPT::VENDOR_IDENT, rostring(VENDOR).reinterpret_as<uint8_t>() }, s);

	uint8_t prl[] = {
		DHCP_OPT::SUBNET,	   DHCP_OPT::ROUTER,	 DHCP_OPT::NTP_SERVER,
		DHCP_OPT::DHCP_SERVER, DHCP_OPT::DNS_SERVER, DHCP_OPT::BROADCAST_ADDR,
	};
	write_tlv<uint8_t, false>({ DHCP_OPT::PRL, span(prl, sizeof(prl)) }, s);
	s.write((uint8_t)DHCP_OPT::END);
	//bzero<1>(s.begin(), ((uint8_t*)(dhcp + 1) + 64) - s.begin());
	udp_info npi;
	npi.dst_ip = 0xffffffff;
	npi.src_port = DHCP_CLIENT_PORT;
	npi.dst_port = DHCP_SERVER_PORT;
	udp_send({ npi, buf });
}