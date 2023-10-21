#pragma once
#include <typedefs.h>

void memset(void* dest, char src, uint32_t size);

extern void longjmp(uint32_t ptr);
extern void longcall(uint32_t ptr, uint32_t argsize, ...);

extern void memcpy(void* dest, void* src, uint32_t size);
extern uint32_t inb(uint32_t port);
extern uint32_t inw(uint32_t port);
extern uint32_t inl(uint32_t port);
extern void outb(uint32_t port, uint32_t data);
extern void outw(uint32_t port, uint32_t data);
extern void outl(uint32_t port, uint32_t data);
