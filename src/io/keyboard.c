#include <keyboard.h>
#include <vim.h>
#include <idt.h>
#include <assembly.h>
#include <console.h>

uint32_t f7_moon_runes = 0x0;

void handle_key() {
    uint8_t status = inb(0x64);
    if((status & 1) == 0) return;
    uint8_t key = inb(0x60);

    if(key == 0xE0) {
        e0_prefix = 1;
        return;
    }
    if(e0_prefix) {
        e0_prefix = 0;
        if(key == 0x2a) return;
    }

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
    ret = 1;
    int offset;
    switch(key) {
        case 0x3B:
            console_printf("\r\nthe kernel is %i bytes!", *(uint32_t*)0x800001F6);
            break;
        case 0x41:
            if(shift) offset = CONSOLE_W * CONSOLE_H;
            else offset = CONSOLE_W;
            if(alt) offset *= -1;
            f7_moon_runes += offset;
            for(int i = 0; i < CONSOLE_W * CONSOLE_H; i++) {
                console[2 * i] = *(char*)(f7_moon_runes + i);
            }
            break;
        case 0x42:
            console_printf("\r\nmoon rune offset: 0x%x", f7_moon_runes);
            break;
        case 0x43:
            console_printf("\r\nSHIFT: %i CTRL: %i ALT: %i", shift, ctrl, alt);
            break;
        default: ret = 0; break;
    }
    if(ret) return;

    if(!buffer_handle_navigation(&globalBuffer, code))
        buffer_insert_char(&globalBuffer, key);

    vsync();
    buffer_display(&globalBuffer);

}
