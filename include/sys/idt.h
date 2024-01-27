#pragma once
#include <cstdint>

void idt_set(uint8_t index, uint64_t base, uint8_t flags);
void irq_set(uint8_t index, void(*fn)(void));
void idt_init(void);
extern "C" void* idtptr;
extern "C" void load_idt(void* idtptr);
