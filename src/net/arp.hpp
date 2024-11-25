#pragma once
#include <cstdint>
#include <kstddef.hpp>
#include <net/net.hpp>
#include <stl/vector.hpp>

namespace ARP {
enum ARP_CONSTANTS {
	TYPE_PROBE = 1,
	TYPE_REPLY_PROBE,
	TYPE_REQUEST,
	TYPE_REPLY_REQUEST,
	TYPE_GRATUITOUS,
	PTYPE_IPv4 = 0x800
};
}

struct [[gnu::packed]] arp_header {
	uint16_t htype;
	uint16_t ptype;
	uint8_t hlen;
	uint8_t plen;
	uint16_t op;
	mac_bits_t selfMac;
	ipv4_t selfIP;
	mac_bits_t targetMac;
	ipv4_t targetIP;
};

struct arp_entry {
	mac_t mac;
	ipv4_t ip;
	arp_entry() = default;
	arp_entry(mac_t _mac, ipv4_t _ip) : mac(_mac), ip(_ip) {}
};

extern vector<arp_entry> arp_table;

void arp_process(eth_packet packet);
net_async_t arp_send(uint16_t op, arp_entry self, arp_entry target);

void arp_update(mac_t mac, ipv4_t ip);
ipv4_t arp_translate_mac(mac_t mac);
mac_t arp_translate_ip(ipv4_t ip);

net_async_t arp_whois(mac_t mac);
net_async_t arp_whois(ipv4_t ip);
net_async_t arp_announce(ipv4_t ip);
