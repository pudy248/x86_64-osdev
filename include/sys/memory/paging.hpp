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
	MAP_NEW = 0x0002, // New allocation
	MAP_UNMAP = 0x0004, // Unmap an existing allocation.
	MAP_INITIALIZE = 0x0008, // Initialize mapped memory to 0.
	MAP_PHYSICAL = 0x0010, // Address is a physical address
	MAP_PERMANENT = 0x0020, // Cannot be unmapped.
	MAP_PINNED = 0x0040, // Cannot be moved or swapped.
	MAP_INFO_ONLY = 0x0080, // Do not write to the page table.
	MAP_ALLOC = 0x0100,

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

	void set_flags(uint16_t flags);
	uint16_t get_flags();

	page_t(void* address, uint16_t flags);
	void* address();
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
	uint16_t mmap_alloced : 1;

	void set_flags(uint16_t flags);
	uint16_t get_flags();
};

struct page_stat {
	uint16_t page_flags;
	uint16_t map_flags;
};

static inline void invlpg(void* m) { asmv("invlpg (%0)\n" : : "b"(m) : "memory"); }

void* virt2phys(void* virt);
void* phys2virt(void* phys);

void* mmap(void* addr, size_t size, uint16_t flags, int map);
void munmap(void* addr, size_t size);
void mprotect(void* addr, size_t size, uint16_t flags, int map);
page_stat mstat(void* addr);

void paging_init();
