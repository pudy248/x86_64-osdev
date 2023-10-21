#pragma once
#include <typedefs.h>

#define BASIC_CONSOLE ((char*)0xb8000)
#define BASIC_CONSOLE_W 80
#define BASIC_CONSOLE_H 25

static uint8_t basic_cursor_x;
static uint8_t basic_cursor_y;

void basic_console_init(void);
void basic_setchari(char c, uint16_t index);
void basic_setcharp(char c, uint8_t x, uint8_t y);
void basic_putchar(char c);
void basic_putstr(char* s);
void basic_printf(char* format, ...);

void hexdump(uint32_t src, uint32_t size);
void hexdumprev(uint32_t src, uint32_t size);