#pragma once
#include <cstdint>
#include <kstddefs.hpp>
#include <net/net.hpp>
#include <net/udp.hpp>

constexpr uint16_t DHCP_CLIENT_PORT = 68;
constexpr uint16_t DHCP_SERVER_PORT = 67;

namespace DHCP_OPT {
enum DHCP_OPT : uint8_t {
    SUBNET = 0x01,
    ROUTER = 0x03,
    DNS_SERVER = 0x06,
    HOST_NAME = 0x0c,
    BROADCAST_ADDR = 0x1c,
    NTP_SERVER = 0x2a,
    REQUEST_IP = 0x32,
    LEASE_TIME = 0x33,
    MESSAGE_TYPE = 0x35,
    DHCP_SERVER = 0x36,
    PRL = 0x37,
    VENDOR_IDENT = 0x3c,
    CLIENT_IDENT = 0x3d,
    END = 0xff,
};
}
namespace DHCP_MTYPE {
enum DHCP_MTYPE : uint8_t {
    DISCOVER = 0x01,
    OFFER = 0x02,
    REQUEST = 0x03,
    ACK = 0x05,
    RELEASE = 0x07,
};
}

struct dhcp_header {
    uint8_t op;
    uint8_t htype;
    uint8_t hlen;
    uint8_t hops;
    uint32_t xid;
    uint16_t secs;
    uint16_t flags;
    ipv4_t ciaddr;
    ipv4_t yiaddr;
    ipv4_t siaddr;
    ipv4_t giaddr;
    mac_bits_t chaddr;
    uint8_t padding[0xc8];
    uint32_t cookie;
};

extern ipv4_t dhcp_server;
extern ipv4_t dns_server;
extern ipv4_t subnet_mask;

void dhcp_discover(udp_conn_t conn, uint32_t xid);
void dhcp_request(udp_conn_t conn, uint32_t xid);
void dhcp_ack(udp_conn_t conn, uint32_t xid);