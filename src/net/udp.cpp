#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/config.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/udp.hpp>
#include <sys/global.hpp>

vector<udp_conn_t> open_connections_udp;

vector<uint16_t> blocked_ports_udp = vector<uint16_t>({ 7423 });

void udp_block(uint16_t port, bool is_blocked) {
	if (is_blocked) {
		int idx = span(blocked_ports_udp).find(port);
		if (idx >= 0) blocked_ports_udp.erase(idx);
	} else {
		if (!span(blocked_ports_udp).contains(port)) blocked_ports_udp.append(port);
	}
}
udp_conn_t udp_accept(uint16_t port) {
	udp_conn_t conn = new udp_connection{ port, {} };
	open_connections_udp.append(conn);
	return conn;
}
void udp_close(udp_conn_t conn) {
	for (std::size_t i = 0; i < open_connections_udp.size(); i++) {
		if (open_connections_udp.at(i) == conn) {
			open_connections_udp.erase(i);
			return;
		}
	}
}

net_buffer_t udp_new(std::size_t data_size) {
	net_buffer_t buf = ipv4_new(data_size + sizeof(udp_header));
	return { buf.frame_begin, buf.data_begin + sizeof(udp_header), data_size };
}

udp_packet udp_process(ipv4_packet p) {
	udp_header* udp = (udp_header*)p.b.data_begin;
	uint8_t* data = p.b.data_begin + sizeof(udp_header);

	uint16_t expected_size = htons(udp->length);
	uint16_t actual_size = p.b.data_size;

	if (expected_size > actual_size) {
		qprintf<128>("[UDP] In packet from %I:%i->%i: Mismatch in ethernet and UDP packet sizes! %i vs %i\n",
					 p.i.src_ip, htons(udp->src_port), htons(udp->dst_port), expected_size, actual_size);
		return {};
	}

	udp_info npi = (udp_info)p.i;
	npi.src_port = htons(udp->src_port);
	npi.dst_port = htons(udp->dst_port);

	if (UDP_LOG)
		qprintf<128>("[UDP] Packet received from %I:%i to port %i.\n", p.i.src_ip, htons(npi.src_port),
					 htons(npi.dst_port));

	return { npi, { p.b.frame_begin, data, actual_size } };
}
net_async_t udp_send(udp_packet p) {
	udp_header* udp = (udp_header*)(p.b.data_begin - sizeof(udp_header));
	udp->dst_port = htons(p.i.dst_port);
	udp->src_port = htons(p.i.src_port);
	udp->length = htons(p.b.data_size + sizeof(udp_header));
	udp->checksum = 0;

	ipv4_info ip;
	ip.src_ip = global_ip;
	ip.dst_ip = p.i.dst_ip;
	ip.protocol = IPv4::PROTOCOL_UDP;

	ipv4_pseudo_header h{ ip.src_ip, ip.dst_ip, 0, ip.protocol, htons(p.b.data_size + sizeof(udp_header)) };
	udp->checksum = net_checksum(net_partial_checksum(&h, sizeof(h)) +
								 net_partial_checksum(udp, p.b.data_size + sizeof(udp_header)));

	net_buffer_t buf = { p.b.frame_begin, p.b.data_begin - sizeof(udp_header), p.b.data_size + sizeof(udp_header) };
	return ipv4_send({ ip, buf });
}

bool udp_get(uint16_t port, udp_packet& out) {
	ipv4_packet p;
	if (!ipv4_get(p)) return false;
	if (p.i.protocol != IPv4::PROTOCOL_UDP) {
		ipv4_forward(p);
		return false;
	}
	udp_packet p2 = udp_process(p);
	if (p2.i.dst_port != port) {
		udp_forward(p2);
		return false;
	}
	out = p2;
	return true;
}

bool udp_get(udp_conn_t conn, udp_packet& out) {
	if (conn->packets.size()) {
		out = conn->packets.at(0);
		conn->packets.erase(0);
		return true;
	} else
		return udp_get(conn->port, out);
}

void udp_forward(udp_packet p) {
	for (udp_conn_t c : open_connections_udp) {
		if (c->port == htons(p.i.dst_port)) {
			c->packets.append(p);
			return;
		}
	}
	kfree(p.b.frame_begin);
}