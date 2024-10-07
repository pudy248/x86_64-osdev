#pragma once
#include <cstdint>

void vga_text_init();
extern int vga_text_dimensions[2];
void vga_text_set_char(uint32_t x, uint32_t y, char c);
void vga_text_update();