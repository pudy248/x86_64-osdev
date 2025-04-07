#pragma once
#include "stl/iterator/iterator_interface.hpp"
#include <cstdint>
#include <kstddef.hpp>
#include <kstring.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <stl/ranges.hpp>
#include <stl/stream.hpp>
#include <stl/vector.hpp>

namespace TCP_STATE {
enum TCP_STATE {
	UNINITIALIZED,
	LISTENING,
	WAITING,
	SYN_SENT,
	SYNACK_SENT,
	ESTABLISHED,
	PSH_SENT,
	FIN_SENT,
	FINACK_SENT,
	CLOSED
};
constexpr bool valid(int s);
}
namespace TCP_OPTS {
enum TCP_OPTS {
	MSS = 0x02,
};
}

struct alignas(2) tcp_flags {
	uint16_t reserved : 4;
	uint16_t data_offset : 4;
	uint16_t fin : 1;
	uint16_t syn : 1;
	uint16_t rst : 1;
	uint16_t psh : 1;
	uint16_t ack : 1;
	uint16_t urg : 1;
	uint16_t ece : 1;
	uint16_t cwr : 1;

	tcp_flags(uint16_t f);
};

struct [[gnu::packed]] tcp_header {
	uint16_t src_port;
	uint16_t dst_port;
	uint32_t seq_num;
	uint32_t ack_num;
	tcp_flags flags;
	uint16_t window_size;
	uint16_t checksum;
	uint16_t urgent;
};

struct tcp_info : ipv4_info {
	uint16_t flags;
};
using tcp_packet = packet<tcp_info>;

struct tcp_fragment_partial {
	uint32_t start_seq = 0;
	uint32_t end_seq = 0;
	vector<char> contents;
};
using tcp_fragment = vector<char>;

using tcp_async_t = struct tcp_connection*;

struct tcp_connection {
	ipv4_t cur_ip;
	ipv4_t cli_ip;
	uint16_t cur_port;
	uint16_t cli_port;

	uint32_t start_seq;
	uint32_t start_ack;
	uint32_t cur_seq;
	uint32_t cur_ack;
	uint32_t cli_ack;

	int state;

	tcp_fragment_partial partial;
	std::size_t packet_offset;
	vector<tcp_fragment> received_packets;

	tcp_connection() = default;

	tcp_async_t send(tcp_fragment&& p);
	void await_packet(std::size_t target_count);
	tcp_fragment recv();
	void close();
};

using tcp_conn_t = tcp_connection*;

template <>
struct std::iterator_traits<struct tcp_input_iterator> {
public:
	using value_type = char;
	using difference_type = std::ptrdiff_t;
	using iterator_category = std::input_iterator_tag;
	using pointer = const char*;
	using reference = const char&;
};

struct tcp_input_iterator : public pure_input_iterator_interface<tcp_input_iterator, const char> {
public:
	using pure_input_iterator_interface::operator++;
	tcp_conn_t conn;

	tcp_input_iterator(tcp_conn_t conn);
	const char& operator*() const;
	tcp_input_iterator& operator++();
};

extern vector<tcp_conn_t> open_connections;

net_buffer_t tcp_new(std::size_t data_size);
void tcp_receive(ipv4_packet packet);
net_async_t tcp_transmit(tcp_conn_t conn, tcp_packet packet);

tcp_conn_t tcp_accept(uint16_t port);
tcp_conn_t tcp_connect(ipv4_t ip, uint16_t src_port, uint16_t dst_port);
void tcp_destroy(tcp_conn_t conn);

void tcp_await(tcp_async_t);