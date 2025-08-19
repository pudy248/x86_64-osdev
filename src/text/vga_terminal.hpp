#pragma once
#include <cstdint>

constexpr static int vga_text_dimensions[2] = {80, 25};
void vga_text_init();
void vga_text_set_char(uint32_t x, uint32_t y, char c);
void vga_text_update();