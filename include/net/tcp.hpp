#pragma once
#include <kstddefs.h>
#include <net/net.hpp>
#include <net/ipv4.hpp>
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
}

struct tcp_flags {
    uint16_t reserved:4;
    uint16_t data_offset:4;
    uint16_t fin:1;
    uint16_t syn:1;
    uint16_t rst:1;
    uint16_t psh:1;
    uint16_t ack:1;
    uint16_t urg:1;
    uint16_t ece:1;
    uint16_t cwr:1;
};

struct a_packed tcp_header {
    uint16_t src_port;
    uint16_t dst_port;
    uint32_t seq_num;
    uint32_t ack_num;
    tcp_flags flags;
    uint16_t window_size;
    uint16_t checksum;
    uint16_t urgent;
};

struct tcp_packet_partial {
    uint32_t start_seq = 0;
    uint32_t end_seq = 0;
    vector<char> contents;
};

struct tcp_packet {
    span<char> contents;
};

struct tcp_connection{
    ipv4_t cur_ip;
    ipv4_t cli_ip;
    uint16_t cur_port;
    uint16_t cli_port;

    uint32_t start_seq;
    uint32_t start_ack;
    uint32_t cur_seq;
    uint32_t cur_ack;
    
    int state;

    tcp_packet_partial partial;
    vector<tcp_packet> recieved_packets;

    tcp_connection() = default;

    void listen(uint16_t port) volatile;
    void connect(ipv4_t ip, uint16_t src_port, uint16_t dst_port) volatile;
    void send(tcp_packet p) volatile;
    tcp_packet recv() volatile;
    void close() volatile;
};

extern vector<tcp_connection*> open_connections;

void tcp_process(ip_packet packet);

volatile tcp_connection* tcp_create();
volatile tcp_connection* tcp_accept(uint16_t port);
void tcp_destroy(volatile tcp_connection* conn);