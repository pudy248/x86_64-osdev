#include <cstdint>
#include <sys/memory/paging.hpp>
#include <text/vga_terminal.hpp>

static uint16_t* const fb = (uint16_t*)0xb8000;
int vga_text_dimensions[2] = { 80, 25 };

void vga_text_init() {
	//mprotect(fb, 0x8000, 0, MAP_INITIALIZE);
	kmemset<4096>(fb, 0, 4096);
}
void vga_text_set_char(uint32_t x, uint32_t y, char c) { fb[80 * y + x] = c | 0x0f00; }
void vga_text_update() {}