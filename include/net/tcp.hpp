#pragma once
#include <cstdint>
#include <kstddefs.hpp>
#include <net/net.hpp>
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
constexpr bool valid(TCP_STATE s);
}

struct tcp_flags {
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
	alignas(2) tcp_flags flags;
	uint16_t window_size;
	uint16_t checksum;
	uint16_t urgent;
};

struct tcp_packet {
	uint16_t flags;
	net_buffer_t buf;
};
struct tcp_fragment_partial {
	uint32_t start_seq = 0;
	uint32_t end_seq = 0;
	vector<uint8_t> contents;
};
struct tcp_fragment {
	vector<uint8_t> data;
};

struct tcp_iterator_r {
	struct tcp_connection* conn;
};
struct tcp_iterator_w {
	struct tcp_connection* conn;
};

using tcp_async_t = tcp_connection*;

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
	vector<tcp_fragment> recieved_packets;

	tcp_connection() = default;

	void listen(uint16_t port);
	void connect(ipv4_t ip, uint16_t src_port, uint16_t dst_port);
	tcp_async_t send(tcp_fragment&& p);
	tcp_fragment recv();
	void close();
};

extern vector<tcp_connection*> open_connections;

net_buffer_t tcp_new(std::size_t data_size);
void tcp_receive(struct ipv4_packet packet);
net_async_t tcp_transmit(tcp_connection* conn, tcp_packet packet);

tcp_connection* tcp_create();
tcp_connection* tcp_accept(uint16_t port);
void tcp_destroy(tcp_connection* conn);

void tcp_await(tcp_async_t);