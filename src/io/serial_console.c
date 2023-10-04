#include <serial_console.h>
#include <string.h>
#include <assembly.h>

void serial_putchar(char c) {
    outb(0x3f8, c);
}

void serial_putstr(char* c) {
    for(int i = 0; c[i] != 0; i++) serial_putchar(c[i]);
}

#define tmpStrAddr ((char*)0x60000)
void serial_printf(char* format, ...) {
    vsprintf(tmpStrAddr + 0x1000, format, (uint8_t*)((uint32_t)&format + 4));
    serial_putstr(tmpStrAddr + 0x1000);
}