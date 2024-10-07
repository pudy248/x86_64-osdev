#pragma once
#include <cstdint>
#include <kstddef.hpp>
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

struct ipv4_header {
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
struct ipv4_pseudo_header {
	ipv4_t src_ip;
	ipv4_t dst_ip;
	uint8_t zeroes;
	uint8_t protocol;
	uint16_t transport_length;
};

struct ipv4_info : eth_info {
	uint8_t protocol;
	ipv4_t src_ip;
	ipv4_t dst_ip;
	uint8_t ttl;
};
using ipv4_packet = packet<ipv4_info>;

bool ipv4_get(ipv4_packet& out);
ipv4_packet ipv4_process(eth_packet packet);
net_buffer_t ipv4_new(std::size_t data_size);
net_async_t ipv4_send(ipv4_packet packet);

void ipv4_forward(ipv4_packet packet);