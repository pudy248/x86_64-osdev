#include <cstdint>
#include <kstdlib.hpp>
#include <kstdio.hpp>
#include <drivers/pci.hpp>
#include <drivers/vmware_svga.hpp>
#include <text/graphical_console.hpp>
#include <resources/ms_gothic_small.hpp>

int graphics_text_dimensions[2] = {120, 30}; //{240, 60};

static char* storage_buffer;

static void render_char(uint32_t px, uint32_t py, char c, int scale) {
    if (!c) c = ' ';
    for (int y = 0; y < fontDims[1]; y++) {
        uint32_t row = fontBitmap[fontDims[1] * (c - fontStart) + y];
        for (int x = fontDims[0] - 1; x >= 0; x--) {
            uint32_t c = row & 1 ? 0xffffffff : 0xff000000;
            for (int x2 = 0; x2 < scale; x2++) {
                for (int y2 = 0; y2 < scale; y2++) {
                    svga_set(px + x * scale + x2, py + y * scale + y2, c);
                }
            }
            row >>= 1;
        }
    }
}

void graphics_text_init() {
    pci_device* svga_pci = pci_match(PCI_CLASS::DISPLAY, PCI_SUBCLASS::DISPLAY_VGA);
    kassert(svga_pci, "No VGA display device detected!\r\n");
    svga_init(*svga_pci, graphics_text_dimensions[0] * 8, graphics_text_dimensions[1] * 16);
    
    storage_buffer = (char*)walloc(graphics_text_dimensions[0] * graphics_text_dimensions[1], 0x10);
    memset(storage_buffer, 0, graphics_text_dimensions[0] * graphics_text_dimensions[1]);

    for (int y = 0; y < graphics_text_dimensions[1]; y++)
        for (int x = 0; x < graphics_text_dimensions[0]; x++)
            graphics_text_set_char(x, y, 0);
}
char graphics_text_get_char(uint32_t x, uint32_t y) {
    return storage_buffer[graphics_text_dimensions[0] * y + x];
}
void graphics_text_set_char(uint32_t x, uint32_t y, char c) {
    storage_buffer[graphics_text_dimensions[0] * y + x] = c;
    render_char(x * 8, y * 16, c, 1);
}
void graphics_text_update() {
    svga_update();
}
