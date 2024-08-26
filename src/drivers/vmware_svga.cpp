#include <asm.hpp>
#include <cstdint>
#include <drivers/pci.hpp>
#include <drivers/vmware_svga.hpp>
#include <kassert.hpp>
#include <kstdlib.hpp>
#include <stl/view.hpp>
#include <sys/global.hpp>
#include <sys/memory/paging.hpp>

static bool enabled = false;

static uint32_t svga_read(uint32_t addr) {
	outl(globals->svga->pio_base, addr);
	return inl(globals->svga->pio_base + 1);
}
static void svga_write(uint32_t addr, uint32_t val) {
	outl(globals->svga->pio_base, addr);
	outl(globals->svga->pio_base + 1, val);
}

static void svga_fifo_write(span<uint32_t> arr) {
	disable_interrupts();
	globals->svga->fifo[SVGA_FIFO::RESERVED] = arr.size() << 2;
	uint32_t min = globals->svga->fifo[SVGA_FIFO::MIN];
	uint32_t max = globals->svga->fifo[SVGA_FIFO::MAX];
	uint32_t next = globals->svga->fifo[SVGA_FIFO::NEXT_CMD];
	for (uint32_t w : arr) {
		globals->svga->fifo[next >> 2] = w;
		next += 4;
		if (next == max) next = min;
	}
	globals->svga->fifo[SVGA_FIFO::NEXT_CMD] = next;
	globals->svga->fifo[SVGA_FIFO::RESERVED] = 0;
	enable_interrupts();
}

void svga_init(pci_device svga_pci, uint32_t w, uint32_t h) {
	globals->svga = waterline_new<svga_device>(0x10);
	globals->svga->pio_base = (uint16_t)(svga_pci.bars[0] & 0xfffffffe);
	globals->svga->fb = (uint32_t*)(uint64_t)(svga_pci.bars[1] & 0xfffffff0);
	globals->svga->fifo = (volatile uint32_t*)(uint64_t)(svga_pci.bars[2] & 0xfffffff0);

	pci_enable_mem(svga_pci.address);

	svga_write(SVGA_REG::ID, 2);
	if (svga_read(SVGA_REG::ID) != 2) svga_write(SVGA_REG::ID, 1);
	kassert(ALWAYS_ACTIVE, ERROR, svga_read(SVGA_REG::ID), "VMware SVGA device too old!\n");

	globals->svga->fb_size = svga_read(SVGA_REG::FB_SIZE);
	globals->svga->fifo_size = svga_read(SVGA_REG::MEM_SIZE);
	globals->svga->vram_size = svga_read(SVGA_REG::VRAM_SIZE);

	mprotect((void*)globals->svga->fb, globals->svga->fb_size, PAGE_WT,
			 MAP_PHYSICAL | MAP_INITIALIZE | MAP_NEW);
	mprotect((void*)globals->svga->fifo, globals->svga->fifo_size, PAGE_WT,
			 MAP_PHYSICAL | MAP_INITIALIZE | MAP_NEW);

	globals->svga->fifo[SVGA_FIFO::MIN] = SVGA_FIFO::NUM_REGS * 4;
	globals->svga->fifo[SVGA_FIFO::MAX] = globals->svga->fifo_size;
	globals->svga->fifo[SVGA_FIFO::NEXT_CMD] = globals->svga->fifo[SVGA_FIFO::MIN];
	globals->svga->fifo[SVGA_FIFO::STOP] = globals->svga->fifo[SVGA_FIFO::MIN];
	globals->svga->fifo[SVGA_FIFO::RESERVED] = 0;

	svga_write(SVGA_REG::ENABLE, 1);
	enabled = true;
	svga_write(SVGA_REG::CONFIG_DONE, 1);

	svga_set_mode(w, h, 32);
	for (uint32_t i = 0; i < w * h; i++) {
		globals->svga->fb[i] = 0xffff00ff;
		//globals->svga->fb[i] = 0xff000000;
	}
	svga_update();
}

void svga_disable() {
	svga_write(SVGA_REG::ENABLE, 0);
	enabled = false;
}

void svga_set_mode(uint32_t width, uint32_t height, uint32_t bpp) {
	globals->svga->width = width;
	globals->svga->height = height;
	svga_write(SVGA_REG::WIDTH, width);
	svga_write(SVGA_REG::HEIGHT, height);
	svga_write(SVGA_REG::BPP, bpp);
	globals->svga->pitch = svga_read(SVGA_REG::BPL);
}

void svga_update(uint32_t x, uint32_t y, uint32_t w, uint32_t h) {
	if (!enabled) return;
	array<uint32_t, 5> arr({ (uint32_t)SVGA_CMD::UPDATE, x, y, w, h });
	svga_fifo_write(arr);
}
void svga_update() { svga_update(0, 0, globals->svga->width, globals->svga->height); }

void svga_set(uint32_t x, uint32_t y, uint32_t color) {
	globals->svga->fb[y * globals->svga->width + x] = color;
}