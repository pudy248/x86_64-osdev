#include <cstdint>
#include <kstdlib.hpp>
#include <kstdio.hpp>

console::console() {
    for (int i = 0; i < rect[2] * rect[3]; i++)
        c[i] = 0x0f00;
}
void console::update_cursor() {
    int pos = cy * rect[2] + cx;
    outb(0x3D4, 0x0F);
    outb(0x3D5, (uint8_t) (pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (uint8_t) ((pos >> 8) & 0xFF));
}
void console::set(char ch, int x, int y) {
    c[rect[2] * y + x] = 0x0f00 | ch;

}
void console::newline() {
    cy++;
    if (cy == rect[3] - rect[1]) {
        for (int y = rect[1]; y < rect[1] + rect[3] - 1; y++) {
            for (int x = rect[0]; x < rect[0] + rect[2]; x++) {
                c[y * rect[2] + x] = c[(y + 1) * rect[2] + x];
            }
        }
        cy--;
    }
    for (int x = rect[0]; x < rect[0] + rect[2]; x++) {
        c[cy * rect[2] + x] = 0;
    }
}
void console::putchar(char c) {
    if (!c) return;
    else if (c == '\r') cx = 0;
    else if (c == '\n') newline();
    else {
        set(c, cx, cy);
        cx++;
        if (cx == rect[0] + rect[2]) {
            cx = rect[0];
            newline();
        }
    }
}
void console::putstr(const char* s) {
    for (int i = 0; s[i]; i++) putchar(s[i]);
}
