#pragma once
#include <cstdint>
#include <net/net.hpp>
#include <net/udp.hpp>
#include <sys/ktime.hpp>

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
	CLIENT_DOMAIN_NAME = 0x51,
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

struct dhcp_info : udp_info {
	dhcp_header* header; // evil
};
using dhcp_packet = packet<dhcp_info>;

struct dhcp_lease {
	mac_t chaddr;
	ipv4_t yiaddr;
	ipv4_t siaddr;

	ipv4_t server_ident;
	ipv4_t subnet_mask;
	ipv4_t router;
	ipv4_t dns;

	timepoint established;
	unitsi::seconds duration;
};

extern dhcp_lease active_lease;

void dhcp_set_active(const dhcp_lease& l);
dhcp_lease dhcp_query(ipv4_t preferred_ip = 0);

bool dhcp_get(uint16_t port, uint32_t xid, dhcp_packet& out_packet);
bool dhcp_get(udp_conn_t conn, uint32_t xid, dhcp_packet& out_packet);
void dhcp_discover(uint32_t xid, ipv4_t preferred_ip);
void dhcp_request(uint32_t xid, const dhcp_lease& offer);
dhcp_lease dhcp_parse_response(dhcp_packet packet, uint8_t expected_mtype);