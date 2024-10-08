#pragma once
#include <cstdint>
#include <lib/allocators/heap.hpp>
#include <lib/allocators/mmap.hpp>
#include <lib/allocators/slab_pagemap.hpp>
#include <lib/allocators/waterline.hpp>
#include <lib/fat.hpp>
#include <stl/allocator.hpp>
#include <sys/fixed_global.hpp>
#include <sys/idt.hpp>
#include <sys/ktime.hpp>

struct global_data_t {
	class console* g_console;
	class text_layer* g_stdout;

	waterline_allocator global_waterline;
	heap_allocator global_heap;
	slab_pagemap<64, 64> global_pagemap;
	mmap_allocator global_mmap_alloc;
	vector<heap_tag, waterline_allocator> heap_allocations;
	bool tag_allocs;

	uint64_t elapsed_pits;
	double frequency;
	uint64_t reference_tsc;
	htimepoint reference_timepoint;

	struct pci_devices* pci;
	struct ahci_device* ahci;
	struct svga_device* svga;
	struct e1000_handle* e1000;
	fat_sys_data fat_data;
};

#define globals ((global_data_t*)fixed_globals->dynamic_globals)