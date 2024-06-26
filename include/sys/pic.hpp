#pragma once
#include <cstdint>

#define MASTER_OFFSET 0x20
#define SLAVE_OFFSET 0x28

void pic_init(void);
extern "C" void pic_eoi(uint8_t irq);
uint16_t pic_get_irr(void);
uint16_t pic_get_isr(void);
