#pragma once
#include <typedefs.h>

char* console;
uint16_t CONSOLE_W;
uint16_t CONSOLE_H;

uint8_t CURSOR_X;
uint8_t CURSOR_Y;

void console_init();
void update_cursor();
void putchar(char c);
void clearconsole();
void newline();
int putstr(char* str);
void console_printf(char* format, ...);
