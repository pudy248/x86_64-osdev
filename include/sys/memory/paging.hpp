#pragma once
#include <cstdint>
#include <kassert.hpp>
#include <stl/bitset.hpp>

enum PAGE_FLAGS {
	PAGE_P = 0x0001, // Present
	PAGE_RW = 0x0002, // Read/Write
	PAGE_US = 0x0004, // User/Supervisor
	PAGE_WT = 0x0008, // Write-through
	PAGE_UC = 0x0010, // Uncacheable
	PAGE_A = 0x0020, // Accessed
	PAGE_D = 0x0040, // Dirty
	PAGE_SZ = 0x0080, // Page size
	PAGE_G = 0x0100, // Global
	PAGE_PAT = 0x0200, // Page Attribute Table
	PAGE_XD = 0x0400, // Execute Disable
};
enum MMAP_FLAGS {
	MAP_EXISTS = 0x0001, // Internal frame info flag.
	MAP_INFO_ONLY = 0x0002, // Do not write to the page table.
	MAP_REMAP = 0x0004, // Remap an existing allocation.
	MAP_INITIALIZE = 0x0008, // Initialize mapped memory to 0.
	MAP_PHYSICAL = 0x0010, // Address is a physical address
	MAP_PERMANENT = 0x0020, // Cannot be unmapped.
	MAP_PINNED = 0x0040, // Cannot be moved or swapped.

	MAP_RESERVED = MAP_PHYSICAL | MAP_PERMANENT | MAP_PINNED
};

struct [[gnu::packed]] page_t {
	uint64_t p : 1;
	uint64_t rw : 1;
	uint64_t us : 1;
	uint64_t wt : 1;
	uint64_t uc : 1;
	uint64_t a : 1;
	uint64_t d : 1;
	uint64_t sz : 1;
	uint64_t g : 1;
	uint64_t avl : 3;
	uint64_t addr : 40;
	uint64_t avl2 : 7;
	uint64_t pk : 4;
	uint64_t xd : 1;

	void set_flags(uint16_t flags) {
		p = flags & PAGE_P;
		rw = flags & PAGE_RW;
		us = flags & PAGE_US;
		wt = flags & PAGE_WT;
		uc = flags & PAGE_UC;
		a = flags & PAGE_A;
		d = flags & PAGE_D;
		sz = flags & PAGE_SZ;
		g = flags & PAGE_G;
		xd = flags & PAGE_XD;
	}

	page_t(void* address, uint16_t flags) {
		kassert(DEBUG_ONLY, ERROR, !((uint64_t)address & 0xfff),
				"Attempted to use non-page-aligned address for page.");
		addr = (uint64_t)address >> 12;
		set_flags(flags);
		avl = 0;
		avl2 = 0;
		pk = 0;
	}
	void* address() { return (void*)(addr << 12); }
};

struct page_table {
	page_t entries[512];
	void* at(int index);
};
struct page_pdt {
	page_t entries[512];
	page_table* at(int index);
};
struct page_pdpt {
	page_t entries[512];
	page_pdt* at(int index);
};
struct page_pml4 {
	page_t entries[512];
	page_pdpt* at(int index);
};

struct frame_info {
	uint16_t p : 1;
	uint16_t permanent : 1;
	uint16_t pinned : 1;

	void set_flags(uint16_t flags) {
		p = flags & MAP_EXISTS;
		permanent = flags & MAP_PERMANENT;
		pinned = flags & MAP_PINNED;
	}
};

static inline void invlpg(void* m) { asmv("invlpg (%0)\n" : : "b"(m) : "memory"); }

void* virt2phys(void* virt);
void* phys2virt(void* phys);

void* mmap(void* addr, size_t size, uint16_t flags, int map);
void munmap(void* addr, size_t size);
void mprotect(void* addr, size_t size, uint16_t flags, int map);

void paging_init();
