#pragma once
#include <kstddefs.h>
#include <drivers/pci.h>

namespace SVGA_REG { enum SVGA_REG {
    ID,
    ENABLE,
    WIDTH,
    HEIGHT,
    MAX_WIDTH,
    MAX_HEIGHT,
    DEPTH,
    BPP,
    PSEUDOCOLOR,
    RED_MASK,
    GREEN_MASK,
    BLUE_MASK,
    BPL,
    FB_START,
    FB_OFFSET,
    VRAM_SIZE,
    FB_SIZE,

    CAPABILITIES,
    MEM_START,
    MEM_SIZE,
    CONFIG_DONE,
    SYNC,
    BUSY,
    GUEST_ID,
    CURSOR_ID,
    CURSOR_X,
    CURSOR_Y,
    CURSOR_ON,
    SCRATCH_SIZE,
    MEM_REGS,
    NUM_DISPLAYS,
    PITCHLOCK,
    IRQ_MASK,
};}

namespace SVGA_FIFO { enum SVGA_FIFO {
    MIN,
    MAX,
    NEXT_CMD,
    STOP,
    RESERVED=14,
    NUM_REGS=512,
};}

namespace SVGA_CMD { enum SVGA_CMD {
    INVALID,
    UPDATE,
};}

struct svga_device {
    uint16_t pio_base;
    uint32_t* fb;
    volatile uint32_t* fifo;

    uint32_t vram_size;
    uint32_t fb_size;
    uint32_t fifo_size;

    uint32_t width;
    uint32_t height;
    uint32_t pitch;
};

extern svga_device* svga_dev;

void svga_init(pci_device svga_pci, uint32_t w, uint32_t h);
void svga_disable();
void svga_set_mode(uint32_t width, uint32_t height, uint32_t bpp);
void svga_update(uint32_t x, uint32_t y, uint32_t w, uint32_t h);
void svga_set(uint32_t x, uint32_t y, uint32_t color);
void svga_update();
