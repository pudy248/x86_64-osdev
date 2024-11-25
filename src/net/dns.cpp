#include <cstdint>
#include <kstring.hpp>
#include <net/config.hpp>
#include <net/dhcp.hpp>
#include <net/dns.hpp>
#include <net/net.hpp>
#include <net/udp.hpp>
#include <sys/ktime.hpp>

static string dns_name(ibinstream<>& s) {
	string name;
	while (uint8_t len = s.read_b<uint8_t>()) {
		if (name.size())
			name.append('.');
		span<const std::byte> frag = s.read_n(len);
		name.append((const char*)frag.begin(), len);
	}
	return name;
}

static string dns_compressed_name(ibinstream<>& s, dns_header* hdr) {
	uint8_t len = (uint8_t)*s.begin();
	if (len >= 0xc0) {
		s.read_b<uint8_t>();
		uint8_t off = s.read_b<uint8_t>();
		ibinstream<> s2{ (std::byte*)hdr + off };
		return dns_name(s2);
	}
	return dns_name(s);
}

static dns_question get_question(ibinstream<>& s, dns_header* hdr) {
	string name = dns_compressed_name(s, hdr);
	uint16_t type = s.read_b<uint16_t>();
	uint16_t cc = s.read_b<uint16_t>();
	return { name, type, cc };
}
static dns_answer get_answer(ibinstream<>& s, dns_header* hdr) {
	string name = dns_compressed_name(s, hdr);
	uint16_t type = htons(s.read_b<uint16_t>());
	uint16_t cc = htons(s.read_b<uint16_t>());
	uint32_t ttl = htonl(s.read_b<uint32_t>());
	uint16_t len = htons(s.read_b<uint16_t>());
	span<const std::byte> d{ s.read_n(len) };
	return { name, type, cc, ttl, d };
}

static void write_question(obinstream<>& s, dns_question q) {
	vector<rostring> v = rostring(q.name).split('.');
	for (rostring frag : v) {
		s.write_b(frag.size());
		s.write((std::byte*)frag.begin(), frag.size());
	}
	s.write_b<uint8_t>(0);
	s.write_b(htons(q.type));
	s.write_b(htons(q.class_code));
}

static bool dns_get(uint16_t xid, dns_packet& out_packet) {
	ipv4_packet p;
	if (!ipv4_get(p))
		return false;
	if (p.i.protocol != IPv4::PROTOCOL_UDP) {
		ipv4_forward(p);
		return false;
	}
	udp_packet p2 = udp_process(p);
	if (p2.i.src_port != DNS_PORT) {
		udp_forward(p2);
		return false;
	}
	dns_header* h = (dns_header*)p2.b.data_begin;
	if (h->xid != xid) {
		udp_forward(p2);
		return false;
	}
	out_packet = { { p2.i, h }, p2.b };
	return true;
}

ipv4_t dns_query(rostring domain) {
	net_buffer_t b = udp_new(sizeof(dns_header) + 96);
	dns_header* dns = (dns_header*)b.data_begin;
	dns->flags = htons(DNS_FMASK::RECURSIVE | DNS_FMASK::NON_AUTH);
	dns->n_quest = htons(1);
	dns->n_ans = 0;
	dns->n_auth_RR = 0;
	dns->n_addl_RR = 0;
	obinstream<> os{ (std::byte*)(dns + 1) };
	write_question(os, { domain, DNS_TYPE::A, DNS_CLASS_CODE::IN });
	udp_info npi;
	npi.dst_ip = active_lease.dns;
	npi.src_port = 12345;
	npi.dst_port = DNS_PORT;
retry:
	uint16_t xid = rdtsc();
	timepoint t1 = timepoint::now();
	dns->xid = xid;
	udp_send({ npi, b });
	if (DNS_LOG)
		qprintf<128>("[DNS] <XID %04x> Query: \"%S\" A IN\n", xid, &domain);

	dns_packet p;
	while (1) {
		if (dns_get(xid, p)) {
			break;
		}
		if (timepoint::now() - t1 > units::seconds(5.))
			goto retry;
	}
	dns_header* dns2 = p.i.header;
	if (DNS_LOG)
		qprintf<64>("[DNS] <XID %04x> Response: ", xid);
	ibinstream<> is{ (std::byte*)(dns2 + 1) };
	dns_question q;
	for (int i = 0; i < htons(dns2->n_quest); i++)
		q = get_question(is, dns2);
	for (int i = 0; i < htons(dns2->n_ans); i++) {
		dns_answer ans = get_answer(is, dns2);
		rostring aname = q.name;
		if (DNS_LOG)
			qprintf<128>("\"%S\" %I A IN\n", &aname, *(ipv4_t*)ans.data.begin());
		if (ans.type == DNS_TYPE::A && ans.class_code && DNS_CLASS_CODE::IN) {
			kfree(p.b.frame_begin);
			return *(ipv4_t*)ans.data.begin();
		}
	}
	if (DNS_LOG)
		qprintf<128>("\"%S\" NOT FOUND\n", &domain);
	kfree(p.b.frame_begin);
	return 0;
}
