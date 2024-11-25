#pragma once
#include <cstdint>
#include <kstring.hpp>
#include <net/net.hpp>
#include <net/udp.hpp>
#include <stl/view.hpp>
#include <sys/ktime.hpp>

namespace DNS_TYPE {
enum DNS_TYPE : uint16_t {
	A = 1,
};
}
namespace DNS_CLASS_CODE {
enum DNS_CLASS_CODE : uint16_t {
	IN = 1,
};
}

namespace DNS_FMASK {
enum DNS_FMASK : uint16_t {
	RESPONSE = 0x8000,
	OPCODE = 0x7800,
	AUTHORITATIVE = 0x0400,
	TRUNCATED = 0x0200,
	RECURSIVE = 0x0100,
	RECURSION_AVAILABLE = 0x0080,
	AUTHENTICATED = 0x0020,
	NON_AUTH = 0x0010,
	REPLY = 0x000f,
};
}

constexpr uint16_t DNS_PORT = 53;

struct dns_header {
	uint16_t xid;
	uint16_t flags;
	uint16_t n_quest;
	uint16_t n_ans;
	uint16_t n_auth_RR;
	uint16_t n_addl_RR;
};
struct dns_info : udp_info {
	dns_header* header; // evil
};
using dns_packet = packet<dns_info>;

// for future reference
struct dns_question {
	string name;
	uint16_t type;
	uint16_t class_code;
};

struct dns_answer {
	string name;
	uint16_t type;
	uint16_t class_code;
	uint32_t ttl;
	span<const std::byte> data;
};

ipv4_t dns_query(rostring domain);