#pragma once
struct alignas(16) uint128_t {
	_BitInt(128) v;
};
struct alignas(32) uint256_t {
	_BitInt(256) v;
};

constexpr auto abs(auto a) { return a < 0 ? -a : a; }
constexpr auto min(auto a, auto b) { return a < b ? a : b; }
constexpr auto max(auto a, auto b) { return a > b ? a : b; }

#define asmv(...) __asm__ __volatile__(__VA_ARGS__)
