#include <typedefs.h>
#include <vesa.h>
#include <kernel16/exports.h>
#include <kernel/exports.h>

uint8_t* vesa_screen;
uint8_t* backBuffer;
float* depthBuffer;
uint16_t pitch;
uint16_t SCREEN_W;
uint16_t SCREEN_H;

#define bpp 3

void vesa_init(uint16_t mode) {
    struct vbe_mode_info_structure* info = (struct vbe_mode_info_structure*)0x1000;
    bios_int_regs regs = {0x4f01, 0, mode, 0, 0, (uint16_t)info, 0, 0};
    bios_interrupt(0x10, regs);
    regs = (bios_int_regs){0x4f02, 0x4000 | mode, 0, 0, 0, 0, 0, 0};
    bios_interrupt(0x10, regs);

    basic_printf("%ix%i\r\n", info->width, info->height);

    vesa_screen = (uint8_t*)info->framebuffer;
    pitch = info->pitch;
    SCREEN_W = info->width;
    SCREEN_H = info->height;
    depthBuffer = (float*)(0x10000000);
    backBuffer = (uint8_t*)((uint32_t)vesa_screen + bpp * pitch * SCREEN_H);
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

void memcpys(void* dest, void* src, uint32_t size) {
    for(uint32_t i = 0; i < size; i++) {
        ((uint8_t*)dest)[i] = ((uint8_t*)src)[i];
    }
}

void display() {
    memcpys(vesa_screen, backBuffer, pitch * SCREEN_H);
}
