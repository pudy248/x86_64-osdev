#include <inttypes.h>
#include <vesa.h>
#include <font8x16.h>
#include <kernel/exports.h>

void vesa_putchar(char c, int x0, int y0, int scale) {
    for (int y = 0; y < 16; y++) {
        uint8_t row = fontBitmap[16 * (c - 0x20) + y];
        for (int x = 0; x < 8;  x++) {
            if (row >> 7) {
                for (int x2 = 0; x2 < scale; x2++) {
                    for (int y2 = 0; y2 < scale; y2++) {
                        //set_pixel_rgb(x * scale + x0 + x2, y * scale + y0 + y2, 255, 255, 255);
                    }
                }
            }
            row <<= 1;
        }
    }
}
void vesa_putstr(char* c, int x0, int y0, int scale) {
    int x = x0;
    int y = y0;
    for (int i = 0; c[i] != 0; i++) {
        if (c[i] == '\n') {
            y += 16 * scale;
            x = x0;
        }
        else {
            vesa_putchar(c[i], x, y, scale);
            x += 8 * scale;
        }
    }
}
#define tmpStrAddr ((char*)0x60000)
void vesa_printf(int x, int y, char* format, ...) {
    vsprintf(tmpStrAddr + 0x1000, format, (uint8_t*)((uint32_t)&format + 4));
    vesa_putstr(tmpStrAddr + 0x1000, x, y, 2);
}
