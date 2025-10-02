#pragma once
#include <cstdint>
#include <stl/bitset.hpp>
#include <stl/pointer.hpp>

enum MMAP_FLAGS {
	MAP_PHYSICAL = 0x0001, // Address is a physical address
	MAP_IDENTITY = 0x0002, // Address is an identity map
	MAP_PINNED = 0x0004, // Cannot be moved or swapped.
	MAP_INITIALIZE = 0x0008, // Initialize mapped memory to 0.
	MAP_PERMANENT = 0x0010, // Cannot be unmapped.
	MAP_CONTIGUOUS = 0x0020,

	MAP_READONLY = 0x0040,
	MAP_USER = 0x0080,
	MAP_EXEC_DISABLE = 0x0100,
	MAP_WRITETHROUGH = 0x0200,
	MAP_UNCACHEABLE = 0x0400,

	MAP_ALLOCATED = 0x8000, // Automatically allocated.

	MAP_KERNEL = MAP_PHYSICAL | MAP_PERMANENT | MAP_PINNED,
	MAP_RESERVED = MAP_KERNEL,
};

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
enum FRAME_FLAGS {
	FRAME_P = 0x0001,
	FRAME_RESERVED = 0x0002,
	FRAME_PERMANENT = 0x0004, // Cannot be unmapped.
	FRAME_PINNED = 0x0008, // Cannot be moved or swapped.
	FRAME_ALLOCATED = 0x0010, // Automatically allocated.
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

	constexpr void set_flags(uint16_t flags);
	constexpr uint16_t get_flags();

	constexpr page_t(pointer<void, reinterpret> address, uint16_t flags);
	constexpr pointer<void, reinterpret> address();
};

namespace paging {
using page_table_t = page_t (&)[512];
using page_table_p = page_t (*)[512];

struct frame_t {
	uint64_t p : 1;
	uint64_t a : 1;
	uint64_t reserved : 1;
	uint64_t permanent : 1;
	uint64_t pinned : 1;
	uint64_t mmap_alloced : 1;
	uint64_t pad : 58;

	constexpr void set_flags(uint16_t flags);
	constexpr uint16_t get_flags();
};

struct frame_table_entry {
	uint64_t p : 1;
	uint64_t pad : 23;
	uint64_t addr : 40;

	constexpr frame_table_entry(pointer<void, reinterpret> addressn);
	constexpr pointer<void, reinterpret> address();
};
using frame_pdt = frame_table_entry (&)[512];
using frame_pdtp = frame_table_entry (*)[512];
using frame_table_t = frame_t (&)[512];

extern bool no_invariant_addresses;
auto invariant_mem_address(auto addr) -> decltype(addr) {
	return no_invariant_addresses ? addr : (decltype(addr))((uintptr_t)addr | 0xffff800000000000);
}
pointer<void, reinterpret> alloc_contiguous_frames(pointer<void, reinterpret> start, uint64_t size);

// Allocate and modify frames. Also handles MAP_INITIALIZE
void pmmap(pointer<void, reinterpret> paddr, size_t size, uint16_t flags, int map);
// Allocate and modify pages
void vmmap(pointer<void, reinterpret> vaddr, size_t size, uint16_t flags, int map);
// Set page physical addresses
void vppair(pointer<void, reinterpret> vaddr, pointer<void, reinterpret> paddr);
void mdirect_map(pointer<void, reinterpret> vaddr, pointer<void, reinterpret> paddr, size_t size, int map);
}

static inline void invlpg(void* m) { asmv("invlpg (%0)\n" : : "b"(m) : "memory"); }

pointer<void, reinterpret> mmap(pointer<void, reinterpret> addr, size_t size, int map);
pointer<void, reinterpret> mmap2(
	pointer<void, reinterpret> vaddr, pointer<void, reinterpret> paddr, size_t size, int map);
void munmap(pointer<void, reinterpret> addr, size_t size);
void mprotect(pointer<void, reinterpret> addr, size_t size, int map);
int mstat(pointer<void, reinterpret> addr);
auto virt2phys(auto virt) -> decltype(virt);

struct page_span {
	uint64_t addr;
	uint64_t size;
};
vector<page_span> fragmented_virt2phys(pointer<void, reinterpret> virt, uint64_t size);

void paging_init();
