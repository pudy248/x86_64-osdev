#pragma once
struct alignas(16) uint128_t {
	_BitInt(128) v;
};
struct alignas(32) uint256_t {
	_BitInt(256) v;
};

template <typename A> constexpr A abs(A a) { return a < 0 ? -a : a; }
template <typename A, typename B> constexpr A min(A a, B b) { return a < b ? a : b; }
template <typename A, typename B> constexpr A max(A a, B b) { return a > b ? a : b; }

#define asmv(...) __asm__ __volatile__(__VA_ARGS__)
