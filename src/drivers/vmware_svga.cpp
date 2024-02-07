#include <cstdint>
#include <kstdlib.hpp>
#include <kstdio.hpp>
#include <drivers/pci.h>
#include <drivers/vmware_svga.h>

svga_device* svga_dev;
static bool enabled = false;

static uint32_t svga_read(uint32_t addr) {
    outl(svga_dev->pio_base, addr);
    return inl(svga_dev->pio_base + 1);
}
static void svga_write(uint32_t addr, uint32_t val) {
    outl(svga_dev->pio_base, addr);
    outl(svga_dev->pio_base + 1, val);
}

static uint32_t* svga_reserve(uint32_t size) {
    //uint32_t min = svga_dev->fifo[SVGA_FIFO::MIN];
    //uint32_t max = svga_dev->fifo[SVGA_FIFO::MAX];
    uint32_t next = svga_dev->fifo[SVGA_FIFO::NEXT_CMD];

    svga_dev->fifo[SVGA_FIFO::RESERVED] = size;
    return (uint32_t*)((uint64_t)svga_dev->fifo + next);
}
static void svga_commit() {
    uint32_t min = svga_dev->fifo[SVGA_FIFO::MIN];
    uint32_t max = svga_dev->fifo[SVGA_FIFO::MAX];
    uint32_t next = svga_dev->fifo[SVGA_FIFO::NEXT_CMD];
    uint32_t bytes = svga_dev->fifo[SVGA_FIFO::RESERVED];
    uint32_t nextnext = next + bytes;
    if (nextnext > max) nextnext = nextnext - max + min;
    svga_dev->fifo[SVGA_FIFO::NEXT_CMD] = nextnext;
    svga_dev->fifo[SVGA_FIFO::RESERVED] = 0;
}

void svga_init(pci_device svga_pci) {
    svga_dev = waterline_new<svga_device>(0x10);
    svga_dev->pio_base = (uint16_t)(svga_pci.bars[0] & 0xfffffffe);
    svga_dev->fb = (uint32_t*)(uint64_t)(svga_pci.bars[1] & 0xfffffff0);
    svga_dev->fifo = (volatile uint32_t*)(uint64_t)(svga_pci.bars[2] & 0xfffffff0);

    set_page_flags((void*)svga_dev->fb, PAGE_WT);
    set_page_flags((void*)svga_dev->fifo, PAGE_WT);
    pci_enable_mem(svga_pci.address);

    svga_write(SVGA_REG::ID, 2);
    if (svga_read(SVGA_REG::ID) != 2) svga_write(SVGA_REG::ID, 1);
    kassert(svga_read(SVGA_REG::ID), "VMware SVGA device too old!\r\n");

    svga_dev->fb_size = svga_read(SVGA_REG::FB_SIZE);
    svga_dev->fifo_size = svga_read(SVGA_REG::MEM_SIZE);
    svga_dev->vram_size = svga_read(SVGA_REG::VRAM_SIZE);

    svga_dev->fifo[SVGA_FIFO::MIN] = SVGA_FIFO::NUM_REGS * 4;
    svga_dev->fifo[SVGA_FIFO::MAX] = svga_dev->fifo_size;
    svga_dev->fifo[SVGA_FIFO::NEXT_CMD] = svga_dev->fifo[SVGA_FIFO::MIN];
    svga_dev->fifo[SVGA_FIFO::STOP] = svga_dev->fifo[SVGA_FIFO::MIN];
    svga_dev->fifo[SVGA_FIFO::RESERVED] = 0;

    svga_write(SVGA_REG::ENABLE, 1);
    enabled = true;
    svga_write(SVGA_REG::CONFIG_DONE, 1);

    svga_set_mode(640, 480, 32);
    //for (int i = 0; i < 640 * 480; i++) {
    //    svga_dev->fb[i] = 0xffff00ff;
    //}
    svga_update();
}

void svga_disable() {
    svga_write(SVGA_REG::ENABLE, 0);
    enabled = false;
}

void svga_set_mode(uint32_t width, uint32_t height, uint32_t bpp) {
    svga_dev->width = width;
    svga_dev->height = height;
    svga_write(SVGA_REG::WIDTH, width);
    svga_write(SVGA_REG::HEIGHT, height);
    svga_write(SVGA_REG::BPP, bpp);
    svga_dev->pitch = svga_read(SVGA_REG::BPL);
}

void svga_update(uint32_t x, uint32_t y, uint32_t w, uint32_t h) {
    if (!enabled) return;
    uint32_t* ptr = svga_reserve(20);
    ptr[0] = SVGA_CMD::UPDATE;
    ptr[1] = x;
    ptr[2] = y;
    ptr[3] = w;
    ptr[4] = h;
    svga_commit();
}
void svga_update() {
    svga_update(0, 0, svga_dev->width, svga_dev->height);
}