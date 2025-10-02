#pragma once
#include <cstddef>
#include <cstdint>
#include <kstddef.hpp>
#include <stl/deque.hpp>
#include <stl/optional.hpp>
#include <stl/stream.hpp>
#include <sys/ktime.hpp>
#include <type_traits>

using mac_t = uint64_t;
using mac_bits_t = uint8_t[6];
using ipv4_t = uint32_t;

constexpr mac_t MAC_BCAST = 0xffffffffffffULL;

enum class ETHERTYPE : uint16_t {
	IPv4 = 0x0800,
	ARP = 0x0806,
	IPv6 = 0x86DD,
};
namespace HTYPE {
enum HTYPE : uint8_t {
	ETH = 0x01,
};
}

extern union mac_union {
	mac_t as_int;
	mac_bits_t as_bits;
} global_mac;
extern ipv4_t global_ip;

constexpr ipv4_t new_ipv4(uint8_t a, uint8_t b, uint8_t c, uint8_t d) {
	return ((uint32_t)a << 0) | ((uint32_t)b << 8) | ((uint32_t)c << 16) | ((uint32_t)d << 24);
}
constexpr ipv4_t new_ipv4(uint8_t ip[4]) {
	return ((uint32_t)ip[0] << 0) | ((uint32_t)ip[1] << 8) | ((uint32_t)ip[2] << 16) | ((uint32_t)ip[3] << 24);
}
constexpr mac_t new_mac(uint8_t a, uint8_t b, uint8_t c, uint8_t d, uint8_t e, uint8_t f) {
	return ((uint64_t)a << 0) | ((uint64_t)b << 8) | ((uint64_t)c << 16) | ((uint64_t)d << 24) | ((uint64_t)e << 32) |
		   ((uint64_t)f << 40);
}
constexpr mac_t new_mac(uint8_t mac[6]) {
	return ((uint64_t)mac[0] << 0) | ((uint64_t)mac[1] << 8) | ((uint64_t)mac[2] << 16) | ((uint64_t)mac[3] << 24) |
		   ((uint64_t)mac[4] << 32) | ((uint64_t)mac[5] << 40);
}

constexpr uint16_t htons(uint16_t s) { return (((s >> 8) & 0xff) << 0) | (((s >> 0) & 0xff) << 8); }
template <typename T>
	requires std::is_enum_v<T> && std::same_as<std::underlying_type_t<T>, uint16_t>
constexpr T htons(T s) {
	return (T)htons((uint16_t)s);
}
constexpr uint32_t htonl(uint32_t s) {
	return (((s >> 24) & 0xff) << 0) | (((s >> 16) & 0xff) << 8) | (((s >> 8) & 0xff) << 16) |
		   (((s >> 0) & 0xff) << 24);
}
template <typename T>
	requires std::is_enum_v<T> && std::same_as<std::underlying_type_t<T>, uint32_t>
constexpr T htonl(T s) {
	return (T)htonl((uint32_t)s);
}
constexpr uint64_t htonq(uint64_t s) {
	return (((s >> 56) & 0xff) << 0) | (((s >> 48) & 0xff) << 8) | (((s >> 40) & 0xff) << 16) |
		   (((s >> 32) & 0xff) << 24) | (((s >> 24) & 0xff) << 32) | (((s >> 16) & 0xff) << 40) |
		   (((s >> 8) & 0xff) << 48) | (((s >> 0) & 0xff) << 56);
}
template <typename T>
	requires std::is_enum_v<T> && std::same_as<std::underlying_type_t<T>, uint64_t>
constexpr T htonq(T s) {
	return (T)htonq((uint64_t)s);
}

template <typename T, typename T2>
concept integral_or_enum = std::same_as<T, T2> || (std::is_enum_v<T> && std::same_as<std::underlying_type_t<T>, T2>);
struct net_buffer_t {
	pointer<std::byte, type_cast> frame_begin;
	pointer<std::byte, type_cast> data_begin;
	std::size_t data_size;
	bool free_on_send;
	net_buffer_t(std::size_t total_size)
		: frame_begin(kmalloc(total_size)), data_begin(frame_begin), data_size(total_size), free_on_send(true) {}
	net_buffer_t(
		pointer<std::byte, type_cast> frame_begin, pointer<std::byte, type_cast> data_begin, std::size_t data_size)
		: frame_begin(frame_begin), data_begin(data_begin), data_size(data_size), free_on_send(false) {}

	void increment(std::ptrdiff_t size) {
		data_begin += size;
		data_size -= size;
	}

	template <integral_or_enum<uint8_t> T>
	T read() {
		ibinstream s{data_begin, data_begin + data_size};
		T val = s.read_raw<T>();
		increment(sizeof(T));
		return val;
	}
	template <integral_or_enum<uint16_t> T>
	T read() {
		ibinstream s{data_begin, data_begin + data_size};
		T val = htons(s.read_raw<T>());
		increment(sizeof(T));
		return val;
	}
	template <integral_or_enum<uint32_t> T>
	T read() {
		ibinstream s{data_begin, data_begin + data_size};
		T val = htonl(s.read_raw<T>());
		increment(sizeof(T));
		return val;
	}
	template <integral_or_enum<uint64_t> T>
	T read() {
		ibinstream s{data_begin, data_begin + data_size};
		T val = htonq(s.read_raw<T>());
		increment(sizeof(T));
		return val;
	}
	template <>
	mac_t read<mac_t>() {
		ibinstream s{data_begin, data_begin + data_size};
		mac_t val = 0;
		s.read((std::byte*)&val, sizeof(mac_bits_t));
		increment(sizeof(mac_bits_t));
		return val;
	}
	template <>
	ipv4_t read<ipv4_t>() {
		ibinstream s{data_begin, data_begin + data_size};
		ipv4_t val = s.read_raw<ipv4_t>();
		increment(sizeof(ipv4_t));
		return val;
	}

	template <integral_or_enum<uint8_t> T>
	void write(const T& val) {
		increment(-sizeof(T));
		obinstream s{data_begin};
		s.write_raw<T>(val);
	}
	template <integral_or_enum<uint16_t> T>
	void write(const T& val) {
		increment(-sizeof(T));
		obinstream s{data_begin};
		s.write_raw<T>(htons(val));
	}
	template <integral_or_enum<uint32_t> T>
	void write(const T& val) {
		increment(-sizeof(T));
		obinstream s{data_begin};
		s.write_raw<T>(htonl(val));
	}
	template <integral_or_enum<uint64_t> T>
	void write(const T& val) {
		increment(-sizeof(T));
		obinstream s{data_begin};
		s.write_raw<T>(htonq(val));
	}
	template <>
	void write<mac_t>(const mac_t& val) {
		increment(-sizeof(mac_bits_t));
		obinstream s{data_begin};
		s.write((std::byte*)&val, sizeof(mac_bits_t));
	}
	template <>
	void write<ipv4_t>(const ipv4_t& val) {
		increment(-sizeof(ipv4_t));
		obinstream s{data_begin};
		s.write_raw<ipv4_t>(val);
	}
};
template <typename T>
struct packet {
	T i;
	net_buffer_t b;

	packet(const net_buffer_t& b) : i({}), b(b) {}
	packet(const T& i, const net_buffer_t& b) : i(i), b(b) {}
	packet(std::size_t data_size) : i({}), b(data_size) {}
};

template <typename ENUM, typename SIZE, bool INC_HDR_LEN>
struct tlv_option_t {
	ENUM opt;
	cbytespan value;
};

struct eth_info {
	timepoint timestamp;
	mac_t src_mac = global_mac.as_int;
	mac_t dst_mac;
	ETHERTYPE ethertype;
};
using eth_packet = packet<eth_info>;

void net_init();
void net_update_ip(ipv4_t ip);
extern bool eth_connected;

using net_async_t = int;

void ethernet_link();
void ethernet_recieve(net_buffer_t buf);

optional<eth_packet> eth_get();
eth_packet eth_read(net_buffer_t raw);
net_buffer_t eth_new(std::size_t data_size);
net_buffer_t eth_write(eth_packet packet);
net_async_t eth_send(eth_packet packet);

net_async_t net_send(net_buffer_t packet);
void net_forward(eth_packet p);
void net_fwdall();

void net_await(net_async_t handle);

uint64_t net_partial_checksum(const void* data, uint16_t len);
uint16_t net_checksum(const void* data, uint16_t len);
uint16_t net_checksum(uint64_t partial);

template <typename T, typename SZ, bool FL>
tlv_option_t<T, SZ, FL> read_tlv(ibinstream<>& s);
template <typename T, typename SZ, bool FL>
void write_tlv(const tlv_option_t<T, SZ, FL>& opt, obinstream<>& s);