#pragma once
#include <cstdint>
#include <lib/allocators/heap.hpp>
#include <lib/allocators/pagemap.hpp>
#include <lib/allocators/waterline.hpp>
#include <lib/fat.hpp>
#include <stl/allocator.hpp>

struct global_data_t {
	class console* g_console;

	class waterline_allocator global_waterline;
	class heap_allocator global_heap;
	class slab_pagemap<64, 64> global_pagemap;

	void (*irq_fns[16])(void);
	volatile uint64_t elapsedPITs;

	struct pci_devices* pci;
	struct ahci_device* ahci;
	struct svga_device* svga;
	fat_sys_data fat_data;
};

#define globals ((global_data_t*)0x110000)