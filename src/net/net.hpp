#pragma once
#include <kstddefs.hpp>
#include <stl/vector.hpp>
#include <sys/ktime.hpp>

typedef uint64_t mac_t;
typedef uint8_t mac_bits_t[6];
typedef uint32_t ipv4_t;
typedef uint16_t ethertype_t;

namespace ETHERTYPE {
enum ETHERTYPE : uint16_t {
	IPv4 = 0x0800,
	ARP = 0x0806,
	IPv6 = 0x86DD,
};
}
namespace HTYPE {
enum HTYPE : uint8_t {
	ETH = 0x01,
};
}

extern mac_t global_mac;
extern ipv4_t global_ip;

struct net_buffer_t {
	uint8_t* frame_begin;
	uint8_t* data_begin;
	std::size_t data_size;
};
template <typename T, bool FL>
struct tlv_option_t {
	T opt;
	span<const uint8_t> value;
};

struct [[gnu::packed]] ethernet_header {
	mac_bits_t dst;
	mac_bits_t src;
	ethertype_t type;
};

struct ethernet_packet {
	timepoint timestamp;
	mac_t src;
	mac_t dst;
	uint16_t type;
	net_buffer_t buf;
};

constexpr ipv4_t new_ipv4(uint8_t a, uint8_t b, uint8_t c, uint8_t d) {
	return ((uint32_t)a << 0) | ((uint32_t)b << 8) | ((uint32_t)c << 16) | ((uint32_t)d << 24);
}
constexpr ipv4_t new_ipv4(uint8_t ip[4]) {
	return ((uint32_t)ip[0] << 0) | ((uint32_t)ip[1] << 8) | ((uint32_t)ip[2] << 16) |
		   ((uint32_t)ip[3] << 24);
}
constexpr mac_t new_mac(uint8_t a, uint8_t b, uint8_t c, uint8_t d, uint8_t e, uint8_t f) {
	return ((uint64_t)a << 0) | ((uint64_t)b << 8) | ((uint64_t)c << 16) | ((uint64_t)d << 24) |
		   ((uint64_t)e << 32) | ((uint64_t)f << 40);
}
constexpr mac_t new_mac(uint8_t mac[6]) {
	return ((uint64_t)mac[0] << 0) | ((uint64_t)mac[1] << 8) | ((uint64_t)mac[2] << 16) |
		   ((uint64_t)mac[3] << 24) | ((uint64_t)mac[4] << 32) | ((uint64_t)mac[5] << 40);
}

constexpr uint16_t htons(uint16_t s) { return (((s >> 8) & 0xff) << 0) | (((s >> 0) & 0xff) << 8); }
constexpr uint32_t htonl(uint32_t s) {
	return (((s >> 24) & 0xff) << 0) | (((s >> 16) & 0xff) << 8) | (((s >> 8) & 0xff) << 16) |
		   (((s >> 0) & 0xff) << 24);
}
constexpr uint64_t htonq(uint64_t s) {
	return (((s >> 56) & 0xff) << 0) | (((s >> 48) & 0xff) << 8) | (((s >> 40) & 0xff) << 16) |
		   (((s >> 32) & 0xff) << 24) | (((s >> 24) & 0xff) << 32) | (((s >> 16) & 0xff) << 40) |
		   (((s >> 8) & 0xff) << 48) | (((s >> 0) & 0xff) << 56);
}

void net_init();

using net_async_t = int;

void ethernet_link();
void net_process();
void ethernet_recieve(net_buffer_t buf);
net_buffer_t ethernet_new(std::size_t data_size);
[[nodiscard]] net_async_t ethernet_send(ethernet_packet packet);
void net_await(net_async_t handle);
uint64_t net_partial_checksum(void* data, uint16_t len);
uint16_t net_checksum(void* data, uint16_t len);
uint16_t net_checksum(uint64_t partial);
void write_bufoff(void* obj, std::size_t sz, uint8_t* buf, std::size_t& off);
template <typename T, bool FL> tlv_option_t<T, FL> read_tlv(uint8_t* buf, std::size_t& off);
template <typename T, bool FL> void write_tlv(tlv_option_t<T, FL> opt, uint8_t* buf, std::size_t& off);