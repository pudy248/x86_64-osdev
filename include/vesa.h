#pragma once
#include <typedefs.h>

extern uint32_t _framebuffer;
extern uint16_t _pitch;
extern uint16_t _screenW;
extern uint16_t _screenH;
uint8_t* screen;
uint8_t* backBuffer;
float* depthBuffer;
uint16_t pitch;
uint16_t SCREEN_W;
uint16_t SCREEN_H;

void vesa_init();
void set_pixel_rgb(uint16_t x, uint16_t y, uint8_t r, uint8_t g, uint8_t b);
void set_pixel_rgbd(uint16_t x, uint16_t y, uint8_t r, uint8_t g, uint8_t b, float depth);
void set_pixel_32(uint16_t x, uint16_t y, uint32_t col);
void clearscreen();
void display();