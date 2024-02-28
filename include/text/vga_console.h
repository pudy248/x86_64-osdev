#pragma once
#include <cstdint>
#include <kstdlib.hpp>

void vga_text_init();
extern int vga_text_dimensions[2];
char vga_text_get_char(uint32_t x, uint32_t y);
void vga_text_set_char(uint32_t x, uint32_t y, char c);
void vga_text_update();