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
	pointer<class console, nocopy, nofree> g_console;
	pointer<class text_layer, nocopy, nofree> g_stdout;

	waterline_allocator<void> global_waterline;
	heap_allocator<void> global_heap_alloc;
	slab_pagemap global_slab_alloc;
	mmap_allocator<void> global_mmap_alloc;
	vector<heap_tag, waterline_allocator<heap_tag>> heap_allocations;
	bool tag_allocs;

	uint64_t elapsed_pits;
	double frequency;
	uint64_t reference_tsc;
	htimepoint reference_timepoint;
	uint16_t* vga_fb;

	pointer<struct pci_devices, nocopy, nofree> pci;
	pointer<struct ahci_device, nocopy, nofree> ahci;
	pointer<struct svga_device, nocopy, nofree> svga;
	pointer<struct e1000_device, nocopy, nofree> e1000;
	pointer<struct ihd_gfx_device, nocopy, nofree> ihd_gfx;
	pointer<struct fat_sys_data, nocopy, nofree> fat32;
	pointer<struct filesystem, nocopy, nofree> fs;
};

#define globals ((global_data_t*)fixed_globals->dynamic_globals)