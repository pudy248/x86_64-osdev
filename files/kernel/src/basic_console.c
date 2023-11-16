#include <basic_console.h>

uint8_t basic_cursor_x;
uint8_t basic_cursor_y;

void basic_console_init() {
    basic_cursor_x = 0;
    basic_cursor_y = 0;
    for(int i = 0; i < BASIC_CONSOLE_W * BASIC_CONSOLE_H; i++) ((uint16_t*)BASIC_CONSOLE)[i] = 0x0f00;
}
void basic_setchari(char c, uint16_t index) {
    BASIC_CONSOLE[2 * index] = c;
}
void basic_setcharp(char c, uint8_t x, uint8_t y) {
    BASIC_CONSOLE[2 * (y * BASIC_CONSOLE_W + x)] = c;
}
char basic_getcharp(uint8_t x, uint8_t y) {
    return BASIC_CONSOLE[2 * (y * BASIC_CONSOLE_W + x)];
}
static void newline() {
    basic_cursor_y++;
    if(basic_cursor_y == BASIC_CONSOLE_H) {
        for(int y = 0; y < BASIC_CONSOLE_H - 1; y++) {
            for(int x = 0; x < BASIC_CONSOLE_W; x++) {
                BASIC_CONSOLE[2 * (y * BASIC_CONSOLE_W + x)] = BASIC_CONSOLE[2 * ((y + 1) * BASIC_CONSOLE_W + x)];
            }
        }
        basic_cursor_y--;
    }
    for(int x = 0; x < BASIC_CONSOLE_W; x++) {
        BASIC_CONSOLE[2 * (basic_cursor_y * BASIC_CONSOLE_W + x)] = 0;
    }
}
void basic_putchar(char c) {
    if(c == '\r') basic_cursor_x = 0;
    else if(c == '\n') newline();
    else {
        basic_setcharp(c, basic_cursor_x, basic_cursor_y);
        basic_cursor_x++;
        if(basic_cursor_x == BASIC_CONSOLE_W) {
            basic_cursor_x = 0;
            newline();
        }
    }
}
void basic_putstr(char* s) {
    for(int i = 0; s[i] != 0; i++) basic_putchar(s[i]);
}

void hexdump(void* src, uint32_t size) {
    const char* hextable = "0123456789ABCDEF";
    for(uint32_t i = 0; i < size; i++) {
        basic_putchar(hextable[((uint8_t*)src)[i] >> 4]);
        basic_putchar(hextable[((uint8_t*)src)[i] & 0xf]);
    }
    basic_putstr("\r\n");
}
void hexdumprev(void* src, uint32_t size) {
    const char* hextable = "0123456789ABCDEF";
    for(int32_t i = (int)size - 1; i >= 0; i--) {
        basic_putchar(hextable[((uint8_t*)src)[i] >> 4]);
        basic_putchar(hextable[((uint8_t*)src)[i] & 0xf]);
    }
    basic_putstr("\r\n");
}

void bindump(void* src, uint32_t size) {
    for(uint32_t i = 0; i < size; i++) {
        uint8_t n = ((uint8_t*)src)[i];
        for(int j = 0; j < 8; j++) {
            if((n >> 7) & 1) basic_putchar('1');
            else basic_putchar('0');
            n <<= 1;
        }
        basic_putchar(' ');
    }
    basic_putstr("\r\n");
}
