#include "asm.hpp"
#include "kassert.hpp"
#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/arp.hpp>
#include <net/config.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <net/udp.hpp>

optional<ipv4_packet> ipv4_get() {
	auto opt = eth_get();
	if (!opt)
		return {};
	if (opt->i.ethertype != ETHERTYPE::IPv4) {
		net_forward(opt.get());
		return false;
	}
	return ipv4_read(opt.get());
}

ipv4_packet ipv4_read(eth_packet p) {
	ipv4_packet ip{(ipv4_info)p.i, p.b};
	ip.b.read<uint8_t>(); //ver_ihl
	ip.b.read<uint8_t>(); //dscp
	uint16_t expected_size = ip.b.read<uint16_t>() - 20;
	ip.b.read<uint16_t>(); //ident
	ip.b.read<uint16_t>(); //frag_offset
	ip.i.ttl = ip.b.read<uint8_t>();
	ip.i.protocol = ip.b.read<IPv4_PROTOCOL>();
	uint16_t checksum = ip.b.read<uint16_t>(); // check never
	ip.i.src_ip = ip.b.read<ipv4_t>();
	ip.i.dst_ip = ip.b.read<ipv4_t>();

	uint16_t actual_size = p.b.data_size - 20;

	if (expected_size > actual_size) {
		qprintf<128>("[IPv4] In packet from %I: Mismatch in ethernet and IP packet sizes! %i vs %i\n", ip.i.src_ip,
			expected_size, actual_size);
		//hexdump(p.b.data_begin, min(expected_size, actual_size));
		inf_wait();
		return ipv4_packet(0);
	}
	ip.b.data_size = expected_size;

	if (IPv4_LOG)
		printf("[IPv4] R %I -> %I (%i/%i bytes)\n", ip.i.src_ip, ip.i.dst_ip, expected_size, actual_size);

	return ip;
}

net_buffer_t ipv4_new(std::size_t data_size) {
	net_buffer_t buf = eth_new(data_size + 32);
	return {buf.frame_begin, buf.data_begin + 32, data_size};
}

eth_packet ipv4_write(ipv4_packet p) {
	uint16_t total_length = 20 + p.b.data_size;
	p.b.write<ipv4_t>(p.i.dst_ip);
	p.b.write<ipv4_t>(p.i.src_ip);
	p.b.write<uint16_t>(0); // checksum
	p.b.write<IPv4_PROTOCOL>(p.i.protocol);
	p.b.write<uint8_t>(p.i.ttl ? p.i.ttl : 64);
	p.b.write<uint16_t>(0); // frag
	p.b.write<uint16_t>(rdtsc());
	p.b.write<uint16_t>(total_length);
	p.b.write<uint8_t>(0); // dscp
	p.b.write<uint8_t>(0x45);

	if (IPv4_LOG)
		printf("[IPv4] S %I -> %I (%i bytes)\n", p.i.src_ip, p.i.dst_ip, total_length);

	((uint16_t*)p.b.data_begin)[5] = net_checksum(p.b.data_begin, 20);
	p.i.ethertype = ETHERTYPE::IPv4;
	p.i.src_mac = global_mac.as_int;
	p.i.dst_mac = arp_translate_ip(p.i.dst_ip);
	return {p.i, p.b};
}
net_async_t ipv4_send(ipv4_packet p) { return eth_send(ipv4_write(p)); }

void ipv4_forward(ipv4_packet p) {
	switch (p.i.protocol) {
	case IPv4_PROTOCOL::TCP:
		if (TCP_ENABLED) {
			tcp_receive(p);
			return;
		}
		break;
	case IPv4_PROTOCOL::UDP:
		if (UDP_ENABLED) {
			udp_forward(udp_read(p));
			return;
		}
		break;
	default: break;
	}
	//kfree(p.b.frame_begin);
}