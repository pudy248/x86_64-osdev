#pragma once
#include <cstdint>
#include <kstddefs.hpp>
#include <net/net.hpp>
#include <stl/stream.hpp>
#include <stl/vector.hpp>
#include <stl/view.hpp>

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
using tcp_fragment = vector<uint8_t>;

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

	void listen(uint16_t port);
	void connect(ipv4_t ip, uint16_t src_port, uint16_t dst_port);
	tcp_async_t send(tcp_fragment&& p);
	void await_packet(std::size_t target_count);
	tcp_fragment recv();
	void close();
};

using tcp_conn_t = tcp_connection*;

template <> struct std::indirectly_readable_traits<struct tcp_input_iterator> {
public:
	using value_type = uint8_t;
};

struct tcp_input_iterator : iterator_crtp<tcp_input_iterator> {
private:
	bool in_bounds() const;
	void get_packet() const;
	tcp_fragment& cur_frag() const;

public:
	using value_type = uint8_t;
	using difference_type = std::ptrdiff_t;

	tcp_conn_t conn;
	std::size_t fragment_index;
	std::size_t fragment_offset;

	tcp_input_iterator() = default;
	tcp_input_iterator(tcp_conn_t conn);
	tcp_input_iterator(tcp_conn_t conn, std::size_t fragment_index,
					   std::size_t fragment_offset);
	uint8_t& operator*() const;
	tcp_input_iterator& operator+=(int);
	bool operator==(const tcp_input_iterator& other) const;
	void flush();
};
struct tcp_sentinel {
	tcp_conn_t conn;
	bool operator==(const tcp_input_iterator& other) const;
};
using tcp_istream = basic_istream<uint8_t, tcp_input_iterator, tcp_sentinel>;

extern vector<tcp_conn_t> open_connections;

net_buffer_t tcp_new(std::size_t data_size);
void tcp_receive(struct ipv4_packet packet);
net_async_t tcp_transmit(tcp_conn_t conn, tcp_packet packet);

tcp_conn_t tcp_create();
tcp_conn_t tcp_accept(uint16_t port);
void tcp_destroy(tcp_conn_t conn);

void tcp_await(tcp_async_t);