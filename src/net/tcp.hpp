#pragma once
#include <cstdint>
#include <drivers/register.hpp>
#include <kstddef.hpp>
#include <kstring.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <stl/iterator.hpp>
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
enum class TCP_OPTS : uint8_t {
	END = 0x00,
	NOP = 0x01,
	MSS = 0x02,
	SACK_PERM = 0x04,
	SACK = 0x05,
};
using tcp_tlv_t = tlv_option_t<TCP_OPTS, uint8_t, true>;

struct tcp_flags : data_reg<uint8_t> {
	int_bitmask(DATA_OFFSET, 0, 4);

	flag_bitmask(FIN, 8);
	flag_bitmask(SYN, 9);
	flag_bitmask(RST, 10);
	flag_bitmask(PSH, 11);
	flag_bitmask(ACK, 12);
	flag_bitmask(URG, 13);
	flag_bitmask(ECE, 14);
	flag_bitmask(CWR, 15);
};

struct [[gnu::packed]] tcp_header {
	uint16_t src_port;
	uint16_t dst_port;
	uint32_t seq_num;
	uint32_t ack_num;
	uint16_t flags;
	uint16_t window_size;
	uint16_t checksum;
	uint16_t urgent;
};

struct tcp_info : ipv4_info {
	uint16_t src_port;
	uint16_t dst_port;
	uint32_t seq_num;
	uint32_t ack_num;
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
	optional<tcp_fragment> get();
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
	using pure_input_iterator_interface::operator++;
	tcp_conn_t conn;

	tcp_input_iterator(tcp_conn_t conn);
	const char& operator*() const;
	tcp_input_iterator& operator++();
};
struct tcp_input_sentinel {
	constexpr bool operator==(const tcp_input_iterator& it) const;
};
using tcp_range = ranges::iter_range<tcp_input_iterator, tcp_input_sentinel>;

extern vector<tcp_conn_t> open_connections;

optional<ipv4_packet> ipv4_get();
tcp_packet tcp_read(eth_packet packet);
net_buffer_t tcp_new(std::size_t data_size);
// Delete and replace
void tcp_receive(ipv4_packet packet);
net_async_t tcp_transmit(tcp_conn_t conn, tcp_packet packet);

ipv4_packet tcp_write(tcp_conn_t conn, tcp_packet packet);
net_async_t tcp_send(ipv4_packet packet);

tcp_conn_t tcp_accept(uint16_t port);
tcp_conn_t tcp_connect(ipv4_t ip, uint16_t src_port, uint16_t dst_port);
void tcp_destroy(tcp_conn_t conn);

void tcp_await(tcp_async_t);

void tcp_send_span(tcp_conn_t conn, span<const char> data);
void tcp_send_zstr(tcp_conn_t conn, const char* data);