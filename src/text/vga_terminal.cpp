#include <cstdint>
#include <sys/global.hpp>
#include <sys/memory/paging.hpp>
#include <text/vga_terminal.hpp>

void vga_text_init() { globals->vga_fb = mmap(0xb8000, 0x8000, MAP_INITIALIZE | MAP_PHYSICAL); }
void vga_text_set_char(uint32_t x, uint32_t y, char c) { globals->vga_fb[vga_text_dimensions[0] * y + x] = c | 0x0f00; }
void vga_text_update() {}