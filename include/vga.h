#pragma once
#include "typedefs.h"
#include "assembly.h"

static char* screen = (char*)0xA0000;
static const short SCREEN_W = 320;
static const short SCREEN_H = 200;

void vga_init() {
    #define R_bpp 2
    #define G_bpp 3
    #define B_bpp 2

    outb(0x3C6, 0xFF);
    outb(0x3C8, 0);
    for (uint8_t i = 0; i < 255; i++) {
        outb(0x3C9, (((i >> (8 - R_bpp))           & ((2 << R_bpp) - 1)) * (256 >> (R_bpp + 2))));
        outb(0x3C9, (((i >> (8 - R_bpp - G_bpp))   & ((2 << G_bpp) - 1)) * (256 >> (G_bpp + 2))));
        outb(0x3C9, (((i >> 0)                     & ((2 << B_bpp) - 1)) * (256 >> (B_bpp + 2))));
    }
    outb(0x3C9, 0x3F);
    outb(0x3C9, 0x3F);
    outb(0x3C9, 0x3F);
}

void set_pixel(uint16_t x, uint16_t y, uint8_t color) {
    screen[y * SCREEN_W + x] = color;
}

void set_pixel_rgb(uint16_t x, uint16_t y, uint8_t r, uint8_t g, uint8_t b) {
    screen[y * SCREEN_W + x] = (r << (G_bpp + B_bpp)) + (g << B_bpp) + b;
}