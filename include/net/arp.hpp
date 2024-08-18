#pragma once
#include <cstdint>
#include <kstddefs.hpp>
#include <net/net.hpp>
#include <stl/vector.hpp>

#define ARP_OP_REQUEST 0x0001
#define ARP_OP_RESPONSE 0x0002

#define ARP_TYPE_PROBE 0x01
#define ARP_TYPE_REPLY_PROBE 0x02
#define ARP_TYPE_REQUEST 0x03
#define ARP_TYPE_REPLY_REQUEST 0x04
#define ARP_TYPE_GRATUITOUS 0x05

#define ARP_HTYPE_ETH 0x0001
#define ARP_PTYPE_IPv4 0x0800

template <typename T> struct [[gnu::packed]] arp_header {
	uint16_t htype;
	uint16_t ptype;
	uint8_t hlen;
	uint8_t plen;
	uint16_t op;
	uint8_t selfMac[6];
	T selfIP;
	uint8_t targetMac[6];
	T targetIP;
};

struct arp_entry {
	mac_t mac;
	ipv4_t ip;
	arp_entry() = default;
	arp_entry(mac_t _mac, ipv4_t _ip)
		: mac(_mac)
		, ip(_ip) {}
};

extern vector<arp_entry> arp_table;

void arp_process(ethernet_packet packet);
int arp_send(uint16_t op, arp_entry self, arp_entry target);
void arp_announce(ipv4_t ip);

void arp_update(mac_t mac, ipv4_t ip);
ipv4_t arp_translate_mac(mac_t mac);
mac_t arp_translate_ip(ipv4_t ip);
