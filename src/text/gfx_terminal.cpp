#include "gfx_terminal.hpp"
#include <cstdint>
#include <drivers/ihd.hpp>
#include <drivers/pci.hpp>
#include <drivers/vmware_svga.hpp>
#include <kassert.hpp>
#include <resources/ms_gothic_small.hpp>
#include <sys/global.hpp>
#include <type_traits>

int graphics_text_dimensions[2] = {240, 60};

static void set_pix(uint32_t x, uint32_t y, uint32_t c) {
	if (globals->ihd_gfx)
		ihd_set_pix(x, y, c);
	else if (globals->svga)
		svga_set(x, y, c);
}
static std::pair<uint32_t, uint32_t> get_screen_dims() {
	if (globals->ihd_gfx)
		return {globals->ihd_gfx->buf.w, globals->ihd_gfx->buf.h};
	else if (globals->svga)
		return {globals->svga->width, globals->svga->height};
	else
		return {0, 0};
}

static void render_char(uint32_t px, uint32_t py, char c, int scale) {
	if (!c)
		c = ' ';
	if (c < fontStart)
		return;
	for (int y = 0; y < fontDims[1]; y++) {
		std::remove_reference_t<decltype(*fontBitmap)> row = fontBitmap[fontDims[1] * (c - fontStart) + y];
		for (int x = fontDims[0] - 1; x >= 0; x--) {
			uint32_t c2 = row & 1 ? 0xffffffff : 0xff000000;
			for (int x2 = 0; x2 < scale; x2++)
				for (int y2 = 0; y2 < scale; y2++)
					set_pix(px + x * scale + x2, py + y * scale + y2, c2);
			row >>= 1;
		}
	}
}

void graphics_text_init() {
	auto [w, h] = get_screen_dims();
	graphics_text_dimensions[0] = w / fontDims[0];
	graphics_text_dimensions[1] = h / fontDims[1];
	printf("graphics_text_dimensions %i %i\n", graphics_text_dimensions[0], graphics_text_dimensions[1]);
	for (int y = 0; y < graphics_text_dimensions[1]; y++)
		for (int x = 0; x < graphics_text_dimensions[0]; x++)
			graphics_text_set_char(x, y, 0);
}
void graphics_text_set_char(uint32_t x, uint32_t y, char c) { render_char(x * fontDims[0], y * fontDims[1], c, 1); }
void graphics_text_update() {
	if (globals->svga)
		svga_update();
}
