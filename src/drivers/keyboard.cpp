#include <kstddefs.h>
#include <kstdlib.hpp>
#include <sys/idt.h>
#include <drivers/keyboard.h>

KeyboardBuffer keyboardInput = { 0, 0, 0, 0, 0, 0, {} };

void keyboard_irq() {
    uint8_t status = inb(0x64);
    if ((status & 1) == 0) return;
    uint8_t key = inb(0x60);
    keyboardInput.loopqueue[keyboardInput.pushIdx] = key;
    keyboardInput.pushIdx = (keyboardInput.pushIdx + 1) % 256;
}

uint8_t update_modifiers(uint8_t key) {
    if (key == 0xE0) {
        keyboardInput.e0 = 1;
        return 1;
    }
    if (keyboardInput.e0) {
        keyboardInput.e0 = 0;
        if (key == 0x2a) return 1;
    }

    uint8_t release = (key & 0x80) >> 7;
    uint8_t code = key & 0x7f;
    switch (code) {
        case 0x2a: keyboardInput.shift = !release; break;
        case 0x1d: keyboardInput.ctrl = !release; break;
        case 0x38: keyboardInput.alt = !release; break;
        default: return 0;
    }
    return 1;
}
