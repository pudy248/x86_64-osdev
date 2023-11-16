#pragma once
#include <typedefs.h>

extern void longjmp(uint32_t ptr);
extern void longcall(uint32_t ptr, uint32_t argsize, ...);

void memcpy(void* dest, void* src, uint32_t size);
void memset(void* dest, char src, uint32_t size);

extern void cpu_id(uint32_t eax, void* output);
extern void enable_avx(void);
extern uint32_t get_cr_reg(char idx);
extern uint32_t set_cr_reg(char idx, uint32_t val);

extern uint8_t inb(uint16_t port);
extern uint16_t inw(uint16_t port);
extern uint32_t inl(uint16_t port);
extern void outb(uint16_t port, uint8_t data);
extern void outw(uint16_t port, uint16_t data);
extern void outl(uint16_t port, uint32_t data);
