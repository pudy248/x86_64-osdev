#include <cstdint>
#include <text/vga_console.hpp>

static uint16_t* const fb = (uint16_t*)0xb8000;
int vga_text_dimensions[2] = {80, 25};

void vga_text_init() {
    for (int y = 0; y < vga_text_dimensions[1]; y++)
        for (int x = 0; x < vga_text_dimensions[0]; x++)
            vga_text_set_char(x, y, 0);
}
char vga_text_get_char(uint32_t x, uint32_t y) {
    return fb[80 * y + x];
}
void vga_text_set_char(uint32_t x, uint32_t y, char c) {
    fb[80 * y + x] = c | 0x0f00;
}
void vga_text_update() {

}