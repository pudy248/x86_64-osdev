#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/arp.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <stl/vector.hpp>

static void ip_checksum(ipv4_header* ip) {
	ip->checksum = 0;
	uint64_t sum = 0;
	uint16_t ip_len = (ip->ver_ihl & 0xf) << 2;
	uint16_t* ip_payload = (uint16_t*)ip;
	while (ip_len > 1) {
		sum += *ip_payload++;
		ip_len -= 2;
	}
	while (sum >> 16) { sum = (sum & 0xffff) + (sum >> 16); }
	sum = ~sum;
	ip->checksum = sum;
}

net_buffer_t ipv4_new(std::size_t data_size) {
	net_buffer_t buf = ethernet_new(data_size + sizeof(ipv4_header));
	return { buf.frame_begin, buf.data_begin + sizeof(ipv4_header), data_size };
}

void ipv4_receive(ethernet_packet packet) {
	ipv4_header* ip = (ipv4_header*)packet.buf.data_begin;
	uint8_t* data = packet.buf.data_begin + sizeof(ipv4_header);
	std::size_t size = packet.buf.data_size - sizeof(ipv4_header);

	uint16_t expected_size = htons(ip->total_length) - sizeof(ipv4_header);
	uint16_t actual_size = packet.buf.data_size - sizeof(ipv4_header);

	if (expected_size > actual_size) {
		qprintf<100>(
			"[IPv4] In packet from %I: Mismatch in ethernet and IP packet sizes! %i vs %i\n",
			ip->src_ip, expected_size, actual_size);
		return;
	}

	//printf("[IPv4] %I -> %I (%i/%i bytes)\n", ip->src_ip, ip->dst_ip, expected_size, actual_size);

	arp_update(packet.src, ip->src_ip);

	ipv4_packet new_packet = {
		packet, ip->protocol, ip->src_ip, ip->dst_ip, { packet.buf.frame_begin, data, size }
	};

	switch (ip->protocol) {
	case IPv4::PROTOCOL_TCP: tcp_receive(new_packet); break;
	//case IPv4::PROTOCOL_UDP: udp_receive(new_packet);  break;
	default: kfree(new_packet.buf.frame_begin);
	}
}

int ipv4_send(ipv4_packet packet) {
	ipv4_header* ip = (ipv4_header*)(packet.buf.data_begin - sizeof(ipv4_header));
	ip->ver_ihl = 0x45;
	ip->dscp = 0;
	ip->total_length = htons(20 + packet.buf.data_size);
	ip->ident = 0x100;
	ip->frag_offset = 0;
	ip->ttl = 64;
	ip->protocol = packet.protocol;
	ip->src_ip = packet.src;
	ip->dst_ip = packet.dst;
	ip_checksum(ip);

	ethernet_packet eth;
	eth.type = ETHERTYPE::IPv4;
	eth.src = global_mac;
	eth.dst = arp_translate_ip(packet.dst);
	eth.buf = { packet.buf.frame_begin, packet.buf.data_begin - sizeof(ipv4_header),
				packet.buf.data_size + sizeof(ipv4_header) };

	return ethernet_send(eth);
}
