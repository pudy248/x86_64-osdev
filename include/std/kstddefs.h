#pragma once

#define abs(a) (a < 0 ? -a : a)
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

#define a_noreturn    __attribute__((noreturn))
#define a_inline      inline
#define a_noinline    __attribute__((noinline))
#define a_forceinline __attribute__((forceinline))

#define a_restrict    __restrict__
#define a_aligned(a)  __attribute__((align_value(a)))
#define a_weak        __attribute__((weak))
#define a_packed      __attribute__((packed))
#define asmv(...)     __asm__ __volatile__(__VA_ARGS__)
