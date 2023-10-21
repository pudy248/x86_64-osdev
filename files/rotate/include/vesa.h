#pragma once
#include <typedefs.h>

struct vbe_mode_info_structure {
	uint16_t attributes;
	uint8_t window_a;
	uint8_t window_b;
	uint16_t granularity;
	uint16_t window_size;
	uint16_t segment_a;
	uint16_t segment_b;
	uint32_t win_func_ptr;
	uint16_t pitch;
	uint16_t width;
	uint16_t height;
	uint8_t w_char;
	uint8_t y_char;
	uint8_t planes;
	uint8_t bpp;
	uint8_t banks;
	uint8_t memory_model;
	uint8_t bank_size;
	uint8_t image_pages;
	uint8_t reserved0;
 
	uint8_t red_mask;
	uint8_t red_position;
	uint8_t green_mask;
	uint8_t green_position;
	uint8_t blue_mask;
	uint8_t blue_position;
	uint8_t reserved_mask;
	uint8_t reserved_position;
	uint8_t direct_color_attributes;
 
	uint32_t framebuffer;
	uint32_t off_screen_mem_off;
	uint16_t off_screen_mem_size;
	uint8_t reserved1[206];
} __attribute__ ((packed));


extern uint8_t* vesa_screen;
extern uint8_t* backBuffer;
extern float* depthBuffer;
extern uint16_t pitch;
extern uint16_t SCREEN_W;
extern uint16_t SCREEN_H;

void vesa_init(uint16_t mode);
void set_pixel_rgb(uint16_t x, uint16_t y, uint8_t r, uint8_t g, uint8_t b);
void set_pixel_rgbd(uint16_t x, uint16_t y, uint8_t r, uint8_t g, uint8_t b, float depth);
void set_pixel_32(uint16_t x, uint16_t y, uint32_t col);
void clearscreen(void);
void display(void);
extern void vsync(void);
