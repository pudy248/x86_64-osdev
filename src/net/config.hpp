#pragma once

constexpr bool PROMISCUOUS = true;
constexpr bool PACKET_LOG = false;
constexpr bool PACKET_HEXDUMP = false;

constexpr bool ARP_LOG = false;
constexpr bool ARP_LOG_UPDATE = false;
constexpr int ARP_MAX_RETRIES = 1;

constexpr bool TCP_ENABLED = true;
constexpr bool TCP_LOG = false;
constexpr bool TCP_LOG_VERBOSE = false;

constexpr bool UDP_ENABLED = true;
constexpr bool UDP_LOG = false;

constexpr bool DHCP_LOG = true;
constexpr bool DHCP_AUTOQUERY = true;
constexpr bool DHCP_AUTORENEW = true;

constexpr bool DNS_LOG = true;