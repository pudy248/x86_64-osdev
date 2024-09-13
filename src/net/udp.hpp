#pragma once
#include <cstdint>
#include <kstddefs.hpp>
#include <net/net.hpp>
#include <stl/vector.hpp>

struct udp_header {
    uint16_t src_port;
    uint16_t dst_port;
    uint16_t length;
    uint16_t checksum;
};

struct udp_packet {
    ipv4_t client_ip;
    uint16_t client_port;
    net_buffer_t buf;
};


struct udp_connection {
    uint16_t port;
    vector<udp_packet> packets;
};

using udp_conn_t = udp_connection*;
extern vector<udp_connection*> open_connections_udp;


udp_conn_t udp_accept(uint16_t port);
void udp_close(udp_conn_t conn);

net_buffer_t udp_new(std::size_t data_size);
void udp_receive(struct ipv4_packet packet);
net_async_t udp_send(udp_conn_t conn, udp_packet packet);
bool udp_get(udp_conn_t conn, udp_packet& out_packet);