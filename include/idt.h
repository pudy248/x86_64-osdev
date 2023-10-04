#pragma once
#include <typedefs.h>

void idt_set(uint8_t index, uint32_t base, uint8_t flags);
void idt_init();
void handle_key();
extern void loadIDT(uint32_t idtptr);
extern void divErr();