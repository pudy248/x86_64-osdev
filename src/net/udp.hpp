#pragma once
#include <cstdint>
#include <kstddef.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <stl/vector.hpp>

struct udp_header {
	uint16_t src_port;
	uint16_t dst_port;
	uint16_t length;
	uint16_t checksum;
};

struct udp_info : ipv4_info {
	uint16_t src_port;
	uint16_t dst_port;
};
using udp_packet = packet<udp_info>;

struct udp_connection {
	uint16_t port;
	vector<udp_packet> packets;
};

using udp_conn_t = udp_connection*;
extern vector<udp_connection*> open_connections_udp;

udp_conn_t udp_accept(uint16_t port);
void udp_close(udp_conn_t conn);

bool udp_get(uint16_t port, udp_packet& out_packet);
bool udp_get(udp_conn_t conn, udp_packet& out_packet);
udp_packet udp_process(ipv4_packet p);
net_buffer_t udp_new(std::size_t data_size);
net_async_t udp_send(udp_packet packet);

void udp_forward(udp_packet p);

void udp_block(uint16_t port, bool is_blocked = true);