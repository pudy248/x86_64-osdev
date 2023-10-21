#include <console.h>
#include <assembly.h>
#include <string.h>

void console_init() {
    console = (char*)0xb8000;
    CONSOLE_W = 80;
    CONSOLE_H = 25;
    CURSOR_X = 0;
    CURSOR_Y = 0;
}

void update_cursor()
{
	uint16_t pos = CURSOR_Y * CONSOLE_W + CURSOR_X;

	outb(0x3D4, 0x0F);
	outb(0x3D5, (uint8_t) (pos & 0xFF));
	outb(0x3D4, 0x0E);
	outb(0x3D5, (uint8_t) ((pos >> 8) & 0xFF));
}

void putchar(char c) {
    int idx = CURSOR_Y * CONSOLE_W + CURSOR_X;
    console[2 * idx] = c;
    console[2 * idx + 1] = 0xf; 
    CURSOR_X++;
    if(CURSOR_X == CONSOLE_W) {
        newline();
    }
}

void clearconsole() {
    for(int i = 0; i < CONSOLE_W * CONSOLE_H; i++) ((uint16_t*)console)[i] = 0x0f00;
    CURSOR_X = 0;
    CURSOR_Y = 0;
    update_cursor();
}

void newline() {
    CURSOR_X = 0;
    if(CURSOR_Y == CONSOLE_H - 1) {
        for(int i = 0; i < 2 * CONSOLE_W * (CONSOLE_H - 1); i++) {
            console[i] = console[i + 2 * CONSOLE_W];
        }
    }
    else CURSOR_Y++;
    for(int i = CONSOLE_W * CURSOR_Y; i < CONSOLE_W * (CURSOR_Y + 1); i++)
        ((uint16_t*)console)[i] = 0x0f00;
    update_cursor();
}

int putstr(char* str) {
    uint16_t i = 0;
    while(str[i] != '\0') {
        if(str[i] == '\r') CURSOR_X = 0;
        else if(str[i] == '\n') newline();
        else putchar(str[i]);
        i++;
    }
    update_cursor();
    return i;
}

#define tmpStrAddr ((char*)0x60000)
void console_printf(char* format, ...) {
    vsprintf(tmpStrAddr + 0x1000, format, (uint8_t*)((uint32_t)&format + 4));
    putstr(tmpStrAddr + 0x1000);
}
