#pragma once
#include <cstdint>
#include <kstddefs.hpp>
#include <net/net.hpp>
#include <stl/vector.hpp>

#define IP_PROTOCOL_ICMP 0x01
#define IP_PROTOCOL_TCP 0x06
#define IP_PROTOCOL_UDP 0x11
#define IP_PROTOCOL_SMP 0x79

struct [[gnu::packed]] ip_header {
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

struct ip_packet {
	ethernet_packet ethernet;
	uint8_t protocol;
	ipv4_t src;
	ipv4_t dst;
	span<char> contents;
};

void ipv4_process(ethernet_packet packet);
int ipv4_send(ip_packet packet);
