#pragma once
#include <cstdint>
#include <lib/allocators/heap.hpp>
#include <lib/allocators/mmap.hpp>
#include <lib/allocators/slab_pagemap.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/allocator.hpp>
#include <stl/pointer.hpp>
#include <sys/fixed_global.hpp>
#include <sys/idt.hpp>
#include <sys/ktime.hpp>

struct global_data_t {
	pointer<class console, unique, nofree> g_console;
	pointer<class text_layer, unique, nofree> g_stdout;

	waterline_allocator global_waterline;
	heap_allocator global_heap;
	slab_pagemap global_pagemap;
	mmap_allocator global_mmap_alloc;
	vector<heap_tag, waterline_allocator> heap_allocations;
	bool tag_allocs;

	uint64_t elapsed_pits;
	double frequency;
	uint64_t reference_tsc;
	htimepoint reference_timepoint;

	pointer<struct pci_devices, unique, nofree> pci;
	pointer<struct ahci_device, unique, nofree> ahci;
	pointer<struct svga_device, unique, nofree> svga;
	pointer<struct e1000_device, unique, nofree> e1000;
	pointer<struct fat_sys_data, unique, nofree> fat32;
	pointer<struct filesystem, unique, nofree> fs;
};

#define globals ((global_data_t*)fixed_globals->dynamic_globals)