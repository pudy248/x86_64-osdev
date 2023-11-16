#pragma once
#include <typedefs.h>

void idt_set(uint8_t index, uint32_t base, uint8_t flags);
void idt_init(void);
//void handle_key();
extern void* idtptr;
extern void load_idt(void* idtptr);
