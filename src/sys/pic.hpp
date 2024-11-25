#pragma once
#include <cstdint>

constexpr int MASTER_OFFSET = 0x20;
constexpr int SLAVE_OFFSET = 0x28;

void pic_init(void);
extern "C" void pic_eoi(uint8_t irq);
uint16_t pic_get_irr(void);
uint16_t pic_get_isr(void);
