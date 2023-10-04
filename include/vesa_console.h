#pragma once

void vesa_putchar(char c, int x, int y, int scalePow);
void vesa_putstr(char* c, int x, int y, int scalePow);
void vesa_printf(int x, int y, char* format, ...);