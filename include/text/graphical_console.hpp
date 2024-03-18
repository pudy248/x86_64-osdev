#pragma once
#include <cstdint>

void graphics_text_init();
extern int graphics_text_dimensions[2];
char graphics_text_get_char(uint32_t x, uint32_t y);
void graphics_text_set_char(uint32_t x, uint32_t y, char c);
void graphics_text_update();