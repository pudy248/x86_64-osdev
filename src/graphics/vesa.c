#include <vesa.h>
#include <typedefs.h>
#include <memory.h>
#include <assembly.h>

#include <serial_console.h>

#define bpp 3

void vesa_init() {
    screen = (uint8_t*)_framebuffer;
    pitch = _pitch;
    SCREEN_W = _screenW;
    SCREEN_H = _screenH;
    if((uint32_t)screen == 0) screen = (uint8_t*)0xE0000000;
    depthBuffer = (float*)(0x10000000);
    backBuffer = (uint8_t*)(0x20000000);
    serial_printf("initialized %ix%i screen at %x\r\n", SCREEN_W, SCREEN_H, screen);
}

void set_pixel_rgb(uint16_t x, uint16_t y, uint8_t r, uint8_t g, uint8_t b) {
    backBuffer[y * pitch + bpp * x] = b;
    backBuffer[y * pitch + bpp * x + 1] = g;
    backBuffer[y * pitch + bpp * x + 2] = r;
}

void set_pixel_rgbd(uint16_t x, uint16_t y, uint8_t r, uint8_t g, uint8_t b, float depth) {
    if(depthBuffer[(y * SCREEN_W + x)] < depth) return;
    else depthBuffer[(y * SCREEN_W + x)] = depth;
    set_pixel_rgb(x, y, r, g, b);
}

void set_pixel_32(uint16_t x, uint16_t y, uint32_t col) {
    uint8_t b = col & 0xff;
    uint8_t g = (col >> 8) & 0xff;
    uint8_t r = (col >> 16) & 0xff;
    set_pixel_rgb(x, y, r, g, b);
}

void clearscreen() {
    for(int i = 0; i < SCREEN_W * SCREEN_H; i++) depthBuffer[i] = 10000.0f;
    for(int i = 0; i < ((pitch * SCREEN_H) >> 2); i++) {
        ((uint32_t*)backBuffer)[i] = 0;
    }
}
void display() {
    memcpyl(screen, backBuffer, pitch * SCREEN_H);
}