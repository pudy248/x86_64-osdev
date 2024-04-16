#pragma once

typedef unsigned _BitInt(128) uint128_t;
typedef unsigned _BitInt(256) uint256_t;

#define abs(a) (a < 0 ? -a : a)
#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

#define asmv(...) __asm__ __volatile__(__VA_ARGS__)
