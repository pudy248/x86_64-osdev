#pragma once
#include <typedefs.h>

extern uint32_t inb(uint32_t port);
extern void outb(uint32_t port, uint32_t data);
extern uint32_t rdtscp_low();
extern uint32_t rdtscp_high();
uint64_t rdtscp();

extern void memcpyl(void *dest, const void *src, uint32_t n);
extern void vsync();