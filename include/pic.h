#pragma once
#include <typedefs.h>

#define MASTER_OFFSET 0x20
#define SLAVE_OFFSET 0x28

void pic_init();
void pic_eoi(uint8_t irq);
uint16_t pic_get_irr();
uint16_t pic_get_isr();
