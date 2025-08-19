#pragma once
#include <cstdint>

enum class E820_TYPE {
	USABLE = 1,
	RESERVED = 2,
	ACPI_RECLAIMABLE = 3,
	ACPI_NVS = 4,
	BAD = 5,
};

struct e820_t {
	uint64_t base;
	uint64_t length;
	E820_TYPE type;
	uint32_t acpi;
};

consteval unsigned long long operator""_KB(unsigned long long v) { return v << 10; }
consteval unsigned long long operator""_MB(unsigned long long v) { return v << 20; }
consteval unsigned long long operator""_GB(unsigned long long v) { return v << 30; }
consteval unsigned long long operator""_TB(unsigned long long v) { return v << 40; }