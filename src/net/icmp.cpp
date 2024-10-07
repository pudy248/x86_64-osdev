#include <cstdint>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <net/config.hpp>
#include <net/dns.hpp>
#include <net/icmp.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>

net_async_t icmp_send(ipv4_t ip, uint8_t type, uint8_t ttl, rostring data, rostring domain) {
	if (domain.size())
		qprintf<128>("[ICMP] Pinging %S (%I) with %i bytes of data.\n", &domain, ip, data.size());
	else
		qprintf<128>("[ICMP] Pinging %I with %i bytes of data.\n", ip, data.size());

	net_buffer_t buf = ipv4_new(data.size() + sizeof(icmp_header));
	icmp_header* icmp = (icmp_header*)buf.data_begin;
	icmp->type = type;
	icmp->code = 0;
	icmp->checksum = 0;
	icmp->ident = rdtsc();
	icmp->seq = 0;
	memcpy(icmp + 1, data.begin(), data.size());
	icmp->checksum = net_checksum(icmp, data.size() + sizeof(icmp_header));

	ipv4_info npi;
	npi.protocol = IPv4::PROTOCOL_ICMP;
	npi.src_ip = global_ip;
	npi.dst_ip = ip;
	npi.ttl = ttl;

	return ipv4_send({ npi, buf });
}
bool icmp_get(icmp_packet& out) {
	ipv4_packet p;
	if (!ipv4_get(p)) return false;
	if (p.i.protocol != IPv4::PROTOCOL_ICMP) {
		ipv4_forward(p);
		return false;
	}

	icmp_header* icmp = (icmp_header*)p.b.data_begin;
	uint32_t size = p.b.data_size - sizeof(icmp_header);

	icmp_info npi = (icmp_info)p.i;
	npi.icmp = *icmp;
	out = { npi, { p.b.frame_begin, p.b.data_begin + sizeof(icmp_header), size } };
	return true;

	// switch (icmp->type) {
	// case ICMP_TYPE::ECHO_REPLY: qprintf<128>("[ICMP] Reply from %I with %i bytes of data.\n", p.i.src_ip, size); break;
	// case ICMP_TYPE::DESTINATION_UNREACHABLE: qprintf<128>("[ICMP] %I is unreachable.\n", p.i.src_ip); break;
	// default: qprintf<128>("[ICMP] %I gave an unknown response.\n", p.i.src_ip); break;
	// }
	// kfree(p.b.frame_begin);
}

units::milliseconds ping(ipv4_t ip, uint8_t ttl) {
retry:
	timepoint sent_time = timepoint::now();
	icmp_send(ip, ICMP_TYPE::ECHO_REQUEST, ttl, "KATEOS PING :3"_RO, {});
	icmp_packet p;
	while (1) {
		if (icmp_get(p)) break;
		if (timepoint::now() - sent_time > 3.) goto retry;
	}
	units::milliseconds diff = p.i.timestamp - sent_time;
	qprintf<128>("[ICMP] %I responded in %fms.\n", ip, diff.rep);
	kfree(p.b.frame_begin);
	return diff;
}

units::milliseconds ping(rostring domain, uint8_t ttl) {
	ipv4_t ip = dns_query(domain);
retry:
	timepoint sent_time = timepoint::now();
	icmp_send(ip, ICMP_TYPE::ECHO_REQUEST, ttl, "KATEOS PING :3"_RO, domain);
	icmp_packet p;
	while (1) {
		if (icmp_get(p)) break;
		if (timepoint::now() - sent_time > 3.) goto retry;
	}
	units::milliseconds diff = p.i.timestamp - sent_time;
	qprintf<128>("[ICMP] %S (%I) responded in %fms.\n", &domain, ip, diff.rep);
	kfree(p.b.frame_begin);
	return diff;
}