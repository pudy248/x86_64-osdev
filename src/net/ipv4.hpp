#pragma once
#include <cstdint>
#include <kstddef.hpp>
#include <net/net.hpp>
#include <stl/optional.hpp>

enum class IPv4_PROTOCOL : uint8_t {
	ICMP = 0x01,
	TCP = 0x06,
	UDP = 0x11,
	SMP = 0x79,
};

struct ipv4_pseudo_header {
	ipv4_t src_ip;
	ipv4_t dst_ip;
	uint8_t zeroes;
	IPv4_PROTOCOL protocol;
	uint16_t transport_length;
};

struct ipv4_info : eth_info {
	IPv4_PROTOCOL protocol;
	ipv4_t src_ip;
	ipv4_t dst_ip;
	uint8_t ttl;
};
using ipv4_packet = packet<ipv4_info>;

optional<ipv4_packet> ipv4_get();
ipv4_packet ipv4_read(eth_packet packet);
net_buffer_t ipv4_new(std::size_t data_size);
eth_packet ipv4_write(ipv4_packet packet);
net_async_t ipv4_send(ipv4_packet packet);

void ipv4_forward(ipv4_packet packet);