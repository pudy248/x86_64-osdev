#pragma once
#include <cstdint>
#include <kstddefs.hpp>
#include <net/net.hpp>
#include <stl/vector.hpp>

namespace IPv4 {
enum IPv4_CONSTANTS {
	PROTOCOL_ICMP = 0x01,
	PROTOCOL_TCP = 0x06,
	PROTOCOL_UDP = 0x11,
	PROTOCOL_SMP = 0x79,
};
}

struct [[gnu::packed]] ipv4_header {
	uint8_t ver_ihl; // 4, 5
	uint8_t dscp; // 0
	uint16_t total_length; //20 + data
	uint16_t ident; //any
	uint16_t frag_offset; //0
	uint8_t ttl;
	uint8_t protocol;
	uint16_t checksum;
	ipv4_t src_ip;
	ipv4_t dst_ip;
};

struct ipv4_packet {
	ethernet_packet ethernet;
	uint8_t protocol;
	ipv4_t src;
	ipv4_t dst;
	net_buffer_t buf;
};

net_buffer_t ipv4_new(std::size_t data_size);
void ipv4_receive(ethernet_packet packet);
[[nodiscard]] net_async_t ipv4_send(ipv4_packet packet);
