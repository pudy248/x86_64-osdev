#include <idt.h>
#include <assembly.h>
#include <console.h>

char shift = 0;
char ctrl = 0;
char alt = 0;

struct {
    int start;
    int length;
    const char* lowercase;
    const char* uppercase;
} spans[] = {
    {0x2, 0xC, "1234567890-=", "!@#$%^&*()_+"},
    {0x10, 0xD, "qwertyuiop[]", "QWERTYUIOP{}"},
    {0x1E, 0xC, "asdfghjkl;'`", "ASDFGHJKL:\"~"},
    {0X2B, 0xB, "\\zxcvbnm,./", "|ZXCVBNM<>?"},
    {0x39, 0x1, " ", " "},
};

char key_to_ascii(uint8_t key)
{
    for(int i = 0; i < 5; i++) {
        if(key >= spans[i].start && key < spans[i].start + spans[i].length) {
            if(shift)
                return spans[i].uppercase[key - spans[i].start];
            else
                return spans[i].lowercase[key - spans[i].start];
        }
    }
	return 0;
}

void handle_key() {
    uint8_t key = inb(0x60);
    uint8_t release = (key & 0x80) >> 7;
    uint8_t code = key & 0x7f;

    char ret = 1;
    switch(code) {
        case 0x2a: shift = !release; break;
        case 0x1d: ctrl = !release; break;
        case 0x38: alt = !release; break;
        default: ret = 0; break;
    }
    if(ret || release) return;
    else ret = 1;

    switch(code) {
        case 0xE:
            if(CURSOR_X == 0) {
                CURSOR_Y = CURSOR_Y - 1 > 0 ? CURSOR_Y - 1 : 0;
                CURSOR_X = CONSOLE_W - 1;
            }
            else CURSOR_X--;
            console[2 * (CURSOR_Y * CONSOLE_W + CURSOR_X)] = ' ';
            update_cursor();
            break;
        case 0xF:
            for(int i = 0; i < 4; i++) putchar(' ');
            update_cursor();
            break;
        case 0x1C:
            newline();
            break;
        case 0x48: //up
            CURSOR_Y = (CURSOR_Y + CONSOLE_H - 1) % CONSOLE_H;
            update_cursor();
            break;
        case 0x4B: //left
            CURSOR_X = (CURSOR_X + CONSOLE_W - 1) % CONSOLE_W;
            update_cursor();
            break;
        case 0x4D: //right
            CURSOR_X = (CURSOR_X + 1) % CONSOLE_W;
            update_cursor();
            break;
        case 0x50: //down
            CURSOR_Y = (CURSOR_Y + 1) % CONSOLE_H;
            update_cursor();
            break;
        case 0x45: //numlock
            break;
        default: ret = 0; break;
    }
    if(ret) return;

    if(key_to_ascii(code)) {
        putchar(key_to_ascii(code));
        update_cursor();
    }
    else {
        console_printf("[%x]", code);
    }
}