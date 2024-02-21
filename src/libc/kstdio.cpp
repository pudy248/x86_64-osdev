#include <cstdint>
#include <kstdlib.hpp>
#include <kstdio.hpp>
#include <kcstring.h>
#include <sys/global.h>

console::console() {
    for (int i = 0; i < 80 * 25; i++)
        c[i] = 0x0f00;
}
void console::update_cursor() {
    int pos = cy * rect[2] + cx;
    outb(0x3D4, 0x0F);
    outb(0x3D5, (uint8_t) (pos & 0xFF));
    outb(0x3D4, 0x0E);
    outb(0x3D5, (uint8_t) ((pos >> 8) & 0xFF));
}
char console::get(int x, int y) {
    return c[80 * y + x];
}
void console::set(char ch, int x, int y) {
    c[80 * y + x] = 0x0f00 | ch;
}
void console::newline() {
    cy++;
    if (cy == rect[3] - rect[1]) {
        for (int y = rect[1]; y < rect[1] + rect[3] - 1; y++) {
            for (int x = rect[0]; x < rect[0] + rect[2]; x++) {
                set(get(x, y + 1), x, y);
            }
        }
        cy--;
    }
    for (int x = rect[0]; x < rect[0] + rect[2]; x++) {
        set(0, x, cy);
    }
    //Unix or Windows?
    cx = 0;
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

static void hexdump_impl(console& c, uint8_t* src, int size, bool reversed) {
    const char* hextable = "0123456789ABCDEF";
    for(int i = reversed ? size - 1 : 0; reversed ? i >= 0 : i < size; reversed ? i-- : i++) {
        c.putchar(hextable[src[i] >> 4]);
        c.putchar(hextable[src[i] & 0xf]);
        if (!((i + !reversed) & 3)) c.putchar(' ');
    }
}

void console::hexdump(void* src, uint32_t size) {
    hexdump_impl(*this, (uint8_t*)src, size, false);
    putstr("\n");
}
void console::hexdump_rev(void* src, uint32_t size, uint32_t swap_width) {
    for (uint32_t i = 0; i < size; i += swap_width)
        hexdump_impl(*this, (uint8_t*)((uint64_t)src + i), swap_width, true);
    putstr("\n");
}


void print(const char* str) {
    globals->vga_console.putstr(str);
}
void print(rostring str) {
    for (int i = 0; str.size(); i++) globals->vga_console.putchar(str[i]);
}

template <typename... Args> void printf(const char* fmt, Args... args) {
    string s = format(rostring(fmt), args...);
    globals->vga_console.putstr(s.c_str_this());
}
template <typename... Args> void printf(rostring fmt, Args... args) {
    string s = format(fmt, args...);
    globals->vga_console.putstr(s.c_str_this());
}
template <std::size_t N, typename... Args> void qprintf(const char* fmt, Args... args) {
    array<char, N> buf;
    buf.at(formats(buf, fmt, args...)) = 0;
    globals->vga_console.putstr(buf.begin());
}