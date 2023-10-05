#include <keyboard.h>
#include <vim.h>
#include <idt.h>
#include <assembly.h>
#include <console.h>

void handle_key() {
    uint8_t key = inb(0x60);
    if(key == 0xE0) key = inb(0x60);
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

    if(!buffer_handle_navigation(&globalBuffer, code))
        buffer_insert_char(&globalBuffer, code);

    buffer_display(&globalBuffer);
}