#pragma once

#define abs(a) (a < 0 ? -a : a)
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

#define asmv(...)     __asm__ __volatile__(__VA_ARGS__)
