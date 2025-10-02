#pragma once
#include <cstdint>
#include <kstring.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <sys/ktime.hpp>

enum class ICMP_TYPE : uint8_t {
	ECHO_REPLY = 0,
	DESTINATION_UNREACHABLE = 3,
	ECHO_REQUEST = 8,
	TIME_EXCEEDED = 11,
};

struct [[gnu::packed]] icmp_header {
	ICMP_TYPE type;
	uint8_t code;
	uint16_t checksum;
	uint16_t ident;
	uint16_t seq;
};

struct icmp_info : ipv4_info {
	icmp_header icmp;
};
using icmp_packet = packet<icmp_info>;

net_async_t icmp_send(
	ipv4_t ip, ICMP_TYPE type = ICMP_TYPE::ECHO_REQUEST, uint8_t ttl = 64, rostring data = {}, rostring domain = {});
bool icmp_get(icmp_packet& out);

units::milliseconds ping(ipv4_t ip, uint8_t ttl = 64);
units::milliseconds ping(rostring domain, uint8_t ttl = 64);