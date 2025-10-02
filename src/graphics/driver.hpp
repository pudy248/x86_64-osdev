#pragma once
#include "plane.hpp"
#include <stl/vector.hpp>

namespace gfx {
struct display_mode {
	uint32_t width;
	uint32_t height;
	uint32_t bpp;
	double refresh_rate;
};

void driver_init();
vector<display_mode> driver_get_modes();
void driver_modeset(const display_mode& mode);

buffer alloc_buffer(uint32_t width, uint32_t height);
void free_buffer(const gfx::buffer& buffer);
const gfx::buffer& get_framebuffer();

void update_display();
void update_display(const rect& rect);
}