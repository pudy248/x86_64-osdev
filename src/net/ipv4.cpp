#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/arp.hpp>
#include <net/config.hpp>
#include <net/icmp.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <net/udp.hpp>

bool ipv4_get(ipv4_packet& out) {
	eth_packet p;
	if (!eth_get(p))
		return false;
	if (p.i.ethertype != ETHERTYPE::IPv4) {
		net_forward(p);
		return false;
	}
	out = ipv4_process(p);
	return true;
}

ipv4_packet ipv4_process(eth_packet p) {
	ipv4_header* ip = (ipv4_header*)p.b.data_begin;
	std::byte* data = p.b.data_begin + sizeof(ipv4_header);
	// std::size_t size = p.b.data_size - sizeof(ipv4_header);

	uint16_t expected_size = htons(ip->total_length) - sizeof(ipv4_header);
	uint16_t actual_size = p.b.data_size - sizeof(ipv4_header);

	if (expected_size > actual_size) {
		qprintf<128>("[IPv4] In packet from %I: Mismatch in ethernet and IP packet sizes! %i vs %i\n", ip->src_ip,
					 expected_size, actual_size);
		hexdump(ip, min(expected_size, actual_size));
		return {};
	}

	// printf("[IPv4] %I -> %I (%i/%i bytes)\n", ip->src_ip, ip->dst_ip, expected_size, actual_size);

	ipv4_info npi = (ipv4_info)p.i;
	npi.protocol = ip->protocol;
	npi.src_ip = ip->src_ip;
	npi.dst_ip = ip->dst_ip;
	npi.ttl = 64;
	return { npi, { p.b.frame_begin, data, expected_size } };
}

net_buffer_t ipv4_new(std::size_t data_size) {
	net_buffer_t buf = eth_new(data_size + sizeof(ipv4_header));
	return { buf.frame_begin, buf.data_begin + sizeof(ipv4_header), data_size };
}

int ipv4_send(ipv4_packet p) {
	ipv4_header* ip = (ipv4_header*)(p.b.data_begin - sizeof(ipv4_header));
	ip->ver_ihl = 0x45;
	ip->dscp = 0;
	ip->total_length = htons(20 + p.b.data_size);
	ip->ident = 0x100;
	ip->frag_offset = 0;
	ip->ttl = p.i.ttl ? p.i.ttl : 64;
	ip->protocol = p.i.protocol;
	ip->src_ip = p.i.src_ip;
	ip->dst_ip = p.i.dst_ip;
	ip->checksum = 0;
	ip->checksum = net_checksum(ip, (ip->ver_ihl & 0xf) << 2);

	eth_info eth;
	eth.ethertype = ETHERTYPE::IPv4;
	eth.src_mac = global_mac.as_int;
	eth.dst_mac = arp_translate_ip(p.i.dst_ip);
	net_buffer_t buf = { p.b.frame_begin, p.b.data_begin - sizeof(ipv4_header), p.b.data_size + sizeof(ipv4_header) };

	return eth_send({ eth, buf });
}

void ipv4_forward(ipv4_packet p) {
	switch (p.i.protocol) {
	case IPv4::PROTOCOL_TCP:
		if (TCP_ENABLED) {
			tcp_receive(p);
			return;
		}
		break;
	case IPv4::PROTOCOL_UDP:
		if (UDP_ENABLED) {
			udp_forward(udp_process(p));
			return;
		}
		break;
	default: break;
	}
	kfree(p.b.frame_begin);
}