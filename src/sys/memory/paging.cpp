#include "kstddef.hpp"
#include <asm.hpp>
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kstdlib.hpp>
#include <stl/pointer.hpp>
#include <sys/fixed_global.hpp>
#include <sys/memory/memory.hpp>
#include <sys/memory/paging.hpp>
#include <tuple>

#define CHECK_PRESENT 1

constexpr void page_t::set_flags(uint16_t flags) {
	p = !!(flags & PAGE_P);
	rw = !!(flags & PAGE_RW);
	us = !!(flags & PAGE_US);
	wt = !!(flags & PAGE_WT);
	uc = !!(flags & PAGE_UC);
	a = !!(flags & PAGE_A);
	d = !!(flags & PAGE_D);
	sz = !!(flags & PAGE_SZ);
	g = !!(flags & PAGE_G);
	xd = !!(flags & PAGE_XD);
}
constexpr uint16_t page_t::get_flags() {
	uint16_t flags = 0;
	if (p)
		flags |= PAGE_P;
	if (rw)
		flags |= PAGE_RW;
	if (us)
		flags |= PAGE_US;
	if (wt)
		flags |= PAGE_WT;
	if (uc)
		flags |= PAGE_UC;
	if (a)
		flags |= PAGE_A;
	if (d)
		flags |= PAGE_D;
	if (sz)
		flags |= PAGE_SZ;
	if (g)
		flags |= PAGE_G;
	if (xd)
		flags |= PAGE_XD;
	return flags;
}
constexpr page_t::page_t(pointer<void, reinterpret> address, uint16_t flags) {
	kassert(DEBUG_ONLY, ERROR, !((uint64_t)address & 0xfff), "Attempted to use non-page-aligned address for page.");
	addr = (uint64_t)address >> 12;
	set_flags(flags);
	avl = 0;
	avl2 = 0;
	pk = 0;
}
constexpr pointer<void, reinterpret> page_t::address() { return addr << 12; }

namespace paging {
static pointer<void, reinterpret> alloc_frame_norecurse(pointer<void, reinterpret> start);
static pointer<void, reinterpret> alloc_frame(pointer<void, reinterpret> start);

constexpr std::tuple<uint16_t, uint16_t, uint16_t, uint16_t> decompose_addr(uint64_t addr) {
	uint16_t pml4 = (addr >> 39) & 0x1ff;
	uint16_t pml3 = (addr >> 30) & 0x1ff;
	uint16_t pml2 = (addr >> 21) & 0x1ff;
	uint16_t pml1 = (addr >> 12) & 0x1ff;
	return std::make_tuple(pml4, pml3, pml2, pml1);
}
constexpr uint64_t compose_addr(uint64_t pml4, uint64_t pml3, uint64_t pml2, uint64_t pml1) {
	return (pml4 << 39) | (pml3 << 30) | (pml2 << 21) | (pml1 << 12);
}

static bool no_invariant_addresses;
constexpr auto invariant_mem_address(auto addr) {
	return no_invariant_addresses ? addr : (decltype(addr))((uintptr_t)addr | 0xffff800000000000);
}
constexpr uintptr_t invariant_frame_address(uintptr_t addr, int level) {
	auto [pml4, pml3, pml2, pml1] = decompose_addr(addr);
	uintptr_t page_addr = 0xffff801000000000;
	if (level == 4)
		return page_addr;
	page_addr += 512 * (pml4 + 1);
	if (level == 3)
		return page_addr;
	page_addr += 512 * 512 * (pml3 + 1);
	if (level == 2)
		return page_addr;
	page_addr += 512 * 512 * 512 * (pml2 + 1);
	return page_addr;
}
constexpr uintptr_t invariant_page_address(uintptr_t addr, int level) {
	auto [pml4, pml3, pml2, pml1] = decompose_addr(addr);
	uintptr_t page_addr = 0xffff802000000000;
	if (level == 4)
		return page_addr;
	page_addr += 512 * (pml4 + 1);
	if (level == 3)
		return page_addr;
	page_addr += 512 * 512 * (pml3 + 1);
	if (level == 2)
		return page_addr;
	page_addr += 512 * 512 * 512 * (pml2 + 1);
	return page_addr;
}

constexpr frame_table_entry::frame_table_entry(pointer<void, reinterpret> address, int f, int n) {
	p = 1;
	pad = 0;
	free_children = f;
	null_children = n;
	addr = (uint64_t)address >> 12;
}
constexpr pointer<void, reinterpret> frame_table_entry::address() { return addr << 12; }

constexpr void frame_t::set_flags(uint16_t flags) {
	p = !!(flags & FRAME_P);
	reserved = !!(flags & FRAME_RESERVED);
	permanent = !!(flags & FRAME_PERMANENT);
	pinned = !!(flags & FRAME_PINNED);
	mmap_alloced = !!(flags & FRAME_ALLOCATED);
}
constexpr uint16_t frame_t::get_flags() {
	uint16_t flags = 0;
	if (p)
		flags |= FRAME_P;
	if (reserved)
		flags |= FRAME_RESERVED;
	if (permanent)
		flags |= FRAME_PERMANENT;
	if (pinned)
		flags |= FRAME_PINNED;
	if (mmap_alloced)
		flags |= FRAME_ALLOCATED;
	return flags;
}

constexpr uint16_t TABLE_FLAGS = 0;
constexpr uint16_t DEFAULT_PFLAGS = PAGE_P | PAGE_RW;
constexpr uint16_t DEFAULT_FFLAGS = FRAME_P;
constexpr uint32_t TABLE_MAP = MAP_INITIALIZE;

frame_pdt frame_get_or_initialize() { return (*(frame_pdtp)fixed_globals->fml4_paddr); }
frame_pdt frame_get_or_initialize(uint16_t pml4_idx) {
	auto& entry4 = frame_get_or_initialize()[pml4_idx];
	if (!entry4.p) {
		entry4 = frame_table_entry(alloc_frame_norecurse(nullptr), 0, 512);
		pmmap(entry4.address(), 0x1000, TABLE_FLAGS, TABLE_MAP);
	}
	return *(frame_pdtp)invariant_mem_address(entry4.address());
}
frame_pdt frame_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx) {
	auto& entry3 = frame_get_or_initialize(pml4_idx)[pdpt_idx];
	if (!entry3.p) {
		entry3 = frame_table_entry(alloc_frame_norecurse(nullptr), 0, 512);
		frame_get_or_initialize()[pml4_idx].null_children--;
		frame_get_or_initialize()[pml4_idx].free_children++;
		pmmap(entry3.address(), 0x1000, TABLE_FLAGS, TABLE_MAP);
	}
	return *(frame_pdtp)invariant_mem_address(entry3.address());
}
frame_table_t frame_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx, uint16_t pdt_idx) {
	auto& entry2 = frame_get_or_initialize(pml4_idx, pdpt_idx)[pdt_idx];
	if (!entry2.p) {
		entry2 = frame_table_entry(alloc_frame_norecurse(nullptr), 512, 0);
		frame_get_or_initialize(pml4_idx)[pdpt_idx].free_children++;
		frame_get_or_initialize(pml4_idx)[pdpt_idx].null_children--;
		pmmap(entry2.address(), 0x1000, 0, TABLE_MAP);
		fixed_globals->frames_free += 512;
	}
	return *(frame_t(*)[512])invariant_mem_address(entry2.address());
}
frame_t& frame_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx, uint16_t pdt_idx, uint16_t pt_idx) {
	return frame_get_or_initialize(pml4_idx, pdpt_idx, pdt_idx)[pt_idx];
}
frame_t& resolve_frame(pointer<void, reinterpret> addr) {
	auto [pml4_idx, pdpt_idx, pdt_idx, pt_idx] = decompose_addr((uint64_t)addr);
	return frame_get_or_initialize(pml4_idx, pdpt_idx, pdt_idx, pt_idx);
}

page_table_t page_get_or_initialize() { return (*(page_table_p)fixed_globals->pml4_paddr); }
page_table_t page_get_or_initialize(uint16_t pml4_idx) {
	auto& entry4 = page_get_or_initialize()[pml4_idx];
	if (!entry4.p) {
		entry4 = page_t(alloc_frame(nullptr), TABLE_FLAGS ^ DEFAULT_PFLAGS);
		pmmap(entry4.address(), 0x1000, TABLE_FLAGS, TABLE_MAP);
	}
	return *(page_table_p)invariant_mem_address(entry4.address());
}
page_table_t page_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx) {
	auto& entry3 = page_get_or_initialize(pml4_idx)[pdpt_idx];
	if (!entry3.p) {
		entry3 = page_t(alloc_frame(nullptr), TABLE_FLAGS ^ DEFAULT_PFLAGS);
		pmmap(entry3.address(), 0x1000, TABLE_FLAGS, TABLE_MAP);
	}
	return *(page_table_p)invariant_mem_address(entry3.address());
}
page_table_t page_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx, uint16_t pdt_idx) {
	auto& entry2 = page_get_or_initialize(pml4_idx, pdpt_idx)[pdt_idx];
	if (!entry2.p) {
		entry2 = page_t(alloc_frame(nullptr), TABLE_FLAGS ^ DEFAULT_PFLAGS);
		pmmap(entry2.address(), 0x1000, TABLE_FLAGS, TABLE_MAP);
	}
	return *(page_table_p)invariant_mem_address(entry2.address());
}
page_t& page_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx, uint16_t pdt_idx, uint16_t pt_idx) {
	return page_get_or_initialize(pml4_idx, pdpt_idx, pdt_idx)[pt_idx];
}
page_t& resolve_page(pointer<void, reinterpret> addr) {
	auto [pml4_idx, pdpt_idx, pdt_idx, pt_idx] = decompose_addr((uint64_t)addr);
	return page_get_or_initialize(pml4_idx, pdpt_idx, pdt_idx, pt_idx);
}

static uint64_t page_alloc_counter;
pointer<void, reinterpret> alloc_frame_norecurse(pointer<void, reinterpret> start) {
	if (page_alloc_counter) [[unlikely]] {
		kbzero<0x1000>((void*)page_alloc_counter, 0x1000);
		return (page_alloc_counter += 0x1000) - 0x1000;
	}
	auto [pml4_idx, pdpt_idx, pdt_idx, pt_idx] = decompose_addr((uint64_t)start);
	for (; pml4_idx < 512; pml4_idx++) {
		auto& entry = frame_get_or_initialize()[pml4_idx];
		if (!entry.p)
			return compose_addr(pml4_idx, 0, 0, 1);
		if (entry.free_children + entry.null_children > 0)
			break;
	}
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, pml4_idx < 512, "Out of frames (PML4)!");
	auto pdpt = frame_get_or_initialize(pml4_idx);
	for (; pdpt_idx < 512; pdpt_idx++) {
		auto& entry = pdpt[pdpt_idx];
		if (!entry.p)
			return compose_addr(pml4_idx, pdpt_idx, 0, 2);
		if (entry.free_children + entry.null_children > 0)
			break;
	}
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, pdpt_idx < 512, "Out of frames (PDPT)!");
	auto pdt = frame_get_or_initialize(pml4_idx, pdpt_idx);
	for (; pdt_idx < 512; pdt_idx++) {
		auto& entry = pdt[pdt_idx];
		if (!entry.p)
			return compose_addr(pml4_idx, pdpt_idx, pdt_idx, 3);
		if (entry.free_children + entry.null_children > 0)
			break;
	}
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, pdt_idx < 512, "Out of frames (PDT)!");
	auto pt = frame_get_or_initialize(pml4_idx, pdpt_idx, pdt_idx);
	for (; pt_idx < 512; pt_idx++) {
		auto& entry = pt[pt_idx];
		if (!entry.p && !entry.reserved && !entry.a) {
			entry.a = 1;
			break;
		}
	}
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, pt_idx < 512, "Out of frames (PT)!");
	return compose_addr(pml4_idx, pdpt_idx, pdt_idx, pt_idx);
}
pointer<void, reinterpret> alloc_frame(pointer<void, reinterpret> start) {
	if (page_alloc_counter) [[unlikely]] {
		kbzero<0x1000>((void*)page_alloc_counter, 0x1000);
		return (page_alloc_counter += 0x1000) - 0x1000;
	}
	auto [pml4_idx, pdpt_idx, pdt_idx, pt_idx] = decompose_addr((uint64_t)start);
	for (; pml4_idx < 512; pml4_idx++) {
		auto& entry = frame_get_or_initialize()[pml4_idx];
		if (!entry.p + entry.free_children + entry.null_children > 0)
			break;
	}
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, pml4_idx < 512, "Out of frames (PML4)!");
	auto pdpt = frame_get_or_initialize(pml4_idx);
	for (; pdpt_idx < 512; pdpt_idx++) {
		auto& entry = pdpt[pdpt_idx];
		if (!entry.p + entry.free_children + entry.null_children > 0)
			break;
	}
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, pdpt_idx < 512, "Out of frames (PDPT)!");
	auto pdt = frame_get_or_initialize(pml4_idx, pdpt_idx);
	for (; pdt_idx < 512; pdt_idx++) {
		auto& entry = pdt[pdt_idx];
		if (!entry.p + entry.free_children + entry.null_children > 0)
			break;
	}
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, pdt_idx < 512, "Out of frames (PDT)!");
	auto pt = frame_get_or_initialize(pml4_idx, pdpt_idx, pdt_idx);
	for (; pt_idx < 512; pt_idx++) {
		auto& entry = pt[pt_idx];
		if (!entry.p && !entry.reserved && !entry.a) {
			entry.a = 1;
			break;
		}
	}
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, pt_idx < 512, "Out of frames (PT)!");
	return compose_addr(pml4_idx, pdpt_idx, pdt_idx, pt_idx);
}
pointer<void, reinterpret> find_contiguous_pages(pointer<void, reinterpret> start, uint64_t size) {
	uint64_t page_idx = (uint64_t)start >> 12;
	if (!page_idx)
		page_idx = 1;
	uint64_t page_count = (size + ((uint64_t)start & 0xfff) + 0xfff) >> 12;
	for (;; page_idx++) {
		uint64_t i = page_idx + page_count - 1;
		for (; i >= page_idx; i--) {
			page_t& entry = page_get_or_initialize((i >> 27) & 0x1ff, (i >> 18) & 0x1ff, (i >> 9) & 0x1ff, i & 0x1ff);
			if (entry.p) {
				page_idx = i + 1;
				goto end;
			}
		}
		for (i = page_idx; i < page_idx + page_count; i++) {
			page_t& entry = page_get_or_initialize((i >> 27) & 0x1ff, (i >> 18) & 0x1ff, (i >> 9) & 0x1ff, i & 0x1ff);
			kassert(ALWAYS_ACTIVE, ERROR, !entry.p, "Virtual address already in use in find_contiguous_pages.");
		}
		return page_idx << 12;
end:
		continue;
	}
	inf_wait();
}
pointer<void, reinterpret> find_contiguous_frames(pointer<void, reinterpret> start, uint64_t size) {
	uint64_t page_idx = (uint64_t)start >> 12;
	uint64_t page_count = (size + ((uint64_t)start & 0xfff) + 0xfff) >> 12;
	for (;; page_idx++) {
		uint64_t i = page_idx + page_count - 1;
		for (; i >= page_idx; i--) {
			frame_t& entry = frame_get_or_initialize((i >> 27) & 0x1ff, (i >> 18) & 0x1ff, (i >> 9) & 0x1ff, i & 0x1ff);
			if (entry.p || entry.a) {
				page_idx = i + 1;
				goto end;
			}
		}
		for (i = page_idx; i < page_idx + page_count; i++) {
			frame_t& entry = frame_get_or_initialize((i >> 27) & 0x1ff, (i >> 18) & 0x1ff, (i >> 9) & 0x1ff, i & 0x1ff);
			kassert(ALWAYS_ACTIVE, ERROR, !entry.p, "Physical address already in use in find_contiguous_frames.");
		}
		return page_idx << 12;
end:
		continue;
	}
	inf_wait();
}
uint16_t translate_fflags(uint16_t flags, int map) {
	flags ^= paging::DEFAULT_FFLAGS;
	if (map & MAP_PERMANENT)
		flags |= FRAME_PERMANENT;
	if (map & MAP_PINNED)
		flags |= FRAME_PINNED;
	if (map & MAP_ALLOCATED)
		flags |= FRAME_ALLOCATED;
	return flags;
}
void pmmap(pointer<void, reinterpret> paddr, size_t size, uint16_t flags, int map) {
	uint64_t page_count = (size + ((uint64_t)paddr & 0xfff) + 0xfff) >> 12;
	flags = translate_fflags(flags, map);
	for (size_t i = 0; i < page_count; i++) {
		const uint64_t addr = ((uint64_t)paddr & ~0xfffllu) + (i << 12);
		frame_t& frame = resolve_frame(addr);
		if (!frame.p && (flags & FRAME_P)) {
			auto [pml4_idx, pdpt_idx, pdt_idx, pt_idx] = decompose_addr(addr);
			frame.p = true;
			fixed_globals->frames_allocated++;
			fixed_globals->frames_free--;
			frame_table_entry& f2 = frame_get_or_initialize(pml4_idx, pdpt_idx)[pdt_idx];
			f2.free_children--;
			if (!frame_get_or_initialize(pml4_idx, pdpt_idx)[pdt_idx].free_children) {
				frame_get_or_initialize(pml4_idx)[pdpt_idx].free_children--;
				if (!frame_get_or_initialize(pml4_idx)[pdpt_idx].free_children)
					frame_get_or_initialize()[pml4_idx].free_children--;
			}
		} else if (frame.p && (~flags & FRAME_P)) {
			auto [pml4_idx, pdpt_idx, pdt_idx, pt_idx] = decompose_addr((uint64_t)addr);
			frame.p = false;
			frame.a = false;
			fixed_globals->frames_allocated--;
			fixed_globals->frames_free++;
			if (!frame_get_or_initialize(pml4_idx, pdpt_idx)[pdt_idx].free_children) {
				if (!frame_get_or_initialize(pml4_idx)[pdpt_idx].free_children)
					frame_get_or_initialize()[pml4_idx].free_children++;
				frame_get_or_initialize(pml4_idx)[pdpt_idx].free_children++;
			}
			frame_get_or_initialize(pml4_idx, pdpt_idx)[pdt_idx].free_children++;
		}
		frame.set_flags(flags);
		if (map & MAP_INITIALIZE)
			memset(invariant_mem_address((void*)addr), 0, 0x1000);
	}
	return;
}
uint16_t translate_pflags(uint16_t flags, int map) {
	flags ^= paging::DEFAULT_PFLAGS;
	if (map & MAP_WRITETHROUGH)
		flags |= PAGE_WT;
	return flags;
}
void vmmap(pointer<void, reinterpret> vaddr, size_t size, uint16_t flags, int map) {
	uint64_t page_count = (size + ((uint64_t)vaddr & 0xfff) + 0xfff) >> 12;
	flags = translate_pflags(flags, map);
	for (size_t i = 0; i < page_count; i++) {
		const uint64_t addr = ((uint64_t)vaddr & ~0xfffllu) + (i << 12);
		page_t& page = resolve_page(addr);
		if (!page.p && (flags & PAGE_P)) {
			page.p = true;
			fixed_globals->pages_allocated++;
		} else if (page.p && (~flags & PAGE_P)) {
			page.p = false;
			page.addr = 0;
			fixed_globals->pages_allocated--;
		}
		page.set_flags(flags);
	}
	return;
}
void vppair(pointer<void, reinterpret> vaddr, pointer<void, reinterpret> paddr) {
	page_t& pg = resolve_page(vaddr);
	kassert(ALWAYS_ACTIVE, ERROR, pg.p, "Virtual address not present in vppair.");
	kassert(ALWAYS_ACTIVE, ERROR, resolve_frame(paddr).p, "Physical address not present in vppair.");
	pg.addr = (uint64_t)paddr >> 12;
}
}

pointer<void, reinterpret> mmap(pointer<void, reinterpret> addr, size_t size, int map) {
	if (map & MAP_IDENTITY) {
		mdirect_map(addr, addr, size, map);
		return addr;
	}

	uint64_t page_count = (size + ((uint64_t)addr & 0xfff) + 0xfff) >> 12;
	uint64_t vaddr = 0;
	uint64_t paddr = 0;

	if (map & MAP_PHYSICAL)
		paddr = (uint64_t)addr;
	else
		vaddr = (uint64_t)addr;
	if ((~map & MAP_PINNED) || (map & MAP_PHYSICAL)) {
		vaddr = (uint64_t)paging::find_contiguous_pages(vaddr, size);
		if (map & MAP_CONTIGUOUS)
			paddr = (uint64_t)paging::find_contiguous_frames(addr, size);
	}

	if (paddr)
		mdirect_map(vaddr, paddr, size, map);
	else
		for (size_t i = 0; i < page_count; i++)
			mdirect_map(ptr_offset(vaddr, i << 12), paging::alloc_frame(nullptr), 0x1000, map);

	return vaddr;
}
void mdirect_map(pointer<void, reinterpret> vaddr, pointer<void, reinterpret> paddr, size_t size, int map) {
	uint64_t page_count = (size + 0xfff) >> 12;

	for (size_t i = 0; i < page_count; i++) {
		kassert(ALWAYS_ACTIVE, ERROR, !paging::resolve_page(ptr_offset(vaddr, i << 12)).p,
			"Virtual address already in use in mmap.");
	}
	for (size_t i = 0; i < page_count; i++) {
		kassert(ALWAYS_ACTIVE, ERROR, !paging::resolve_frame(ptr_offset(paddr, i << 12)).p,
			"Physical address already in use in mmap.");
	}

	for (size_t i = 0; i < page_count; i++) {
		pointer<void, reinterpret> this_vaddr = ptr_offset(vaddr, i << 12);
		pointer<void, reinterpret> this_paddr = ptr_offset(paddr, i << 12);
		paging::pmmap(this_paddr, 0x1000, 0, map);
		paging::vmmap(this_vaddr, 0x1000, 0, map);
		paging::vppair(this_vaddr, this_paddr);
	}
}
void munmap(pointer<void, reinterpret> addr, size_t size) {
	uint64_t page_count = (size + ((uint64_t)addr & 0xfff) + 0xfff) >> 12;
	for (size_t i = 0; i < page_count; i++) {
		kassert(ALWAYS_ACTIVE, ERROR, paging::resolve_page(ptr_offset(addr, i << 12)).p,
			"Virtual address not present in munmap.");
	}
	for (size_t i = 0; i < page_count; i++) {
		pointer<void, reinterpret> vaddr = ptr_offset(addr, i << 12);
		pointer<void, reinterpret> paddr = virt2phys(vaddr);
		kassert(ALWAYS_ACTIVE, ERROR, paging::resolve_frame(paddr).p, "Physical address not present in munmap.");
		paging::pmmap(paddr, 0x1000, FRAME_P, 0);
		paging::vmmap(vaddr, 0x1000, PAGE_P, 0);
	}
}
void mprotect(pointer<void, reinterpret> addr, size_t size, uint16_t flags, int map) {
	uint64_t page_count = (size + ((uint64_t)addr & 0xfff) + 0xfff) >> 12;

	for (size_t i = 0; i < page_count; i++) {
		pointer<void, reinterpret> vaddr = (uint64_t)addr + (i << 12);
		pointer<void, reinterpret> paddr = virt2phys(vaddr);
		paging::pmmap(paddr, 0x1000, 0, map);
		paging::vmmap(vaddr, 0x1000, flags, map);
	}
}
int mstat(pointer<void, reinterpret> addr) {
	if ((uint64_t)addr & 0xfff)
		return 0;
	int map = 0;
	int fflags = paging::resolve_frame(addr).get_flags();
	int pflags = paging::resolve_page(addr).get_flags();
	if (fflags & FRAME_ALLOCATED)
		map |= MAP_ALLOCATED;
	if (fflags & FRAME_PERMANENT)
		map |= MAP_PERMANENT;
	if (fflags & FRAME_PINNED)
		map |= MAP_PINNED;
	if (pflags & PAGE_WT)
		map |= MAP_WRITETHROUGH;

	return map;
}
auto virt2phys(auto virt) -> decltype(virt) {
	kassert(ALWAYS_ACTIVE, ERROR, !((uint64_t)virt & 0xfff), "Virtual address not aligned.");
	decltype(virt) addr = paging::resolve_page(virt).address();
	return addr;
}

void paging_init() {
	paging::no_invariant_addresses = true;
	paging::page_alloc_counter = 0x77000;
	fixed_globals->frames_allocated = 0;
	fixed_globals->pages_allocated = 0;
	fixed_globals->frames_free = 0;
	fixed_globals->pml4_paddr = 0x72000;
	fixed_globals->fml4_paddr = 0x73000;
	kbzero<4096>((void*)0x72000, 0x5000);
	paging::frame_get_or_initialize()[0] = paging::frame_table_entry(0x74000, 0, 512);
	paging::page_get_or_initialize()[256] = page_t(0x75000, PAGE_P | PAGE_RW);
	//paging::page_get_or_initialize()[257] = page_t(0x76000, PAGE_P | PAGE_RW);

	for (uintptr_t i = 0; i < 0x200; i++)
		(*(paging::page_table_p)0x75000)[i] = page_t(i << 30, PAGE_P | PAGE_RW | PAGE_SZ);

	paging::pmmap(nullptr, 0x1000, FRAME_RESERVED, MAP_PHYSICAL | MAP_PINNED | MAP_PERMANENT);
	mmap(0x1000, 0x40000, MAP_IDENTITY | MAP_PINNED);
	mmap(0x72000, 0x5000, MAP_IDENTITY | MAP_PINNED);
	mmap(0x1f0000, 0x10000, MAP_IDENTITY | MAP_PINNED);

	e820_t* mem = (e820_t*)0x7000;
	//uintptr_t max_mem = 0;
	while (mem->base || mem->length) {
		if (mem->type == E820_TYPE::RESERVED || mem->type == E820_TYPE::BAD)
			paging::pmmap((uint64_t)mem->base, mem->length, FRAME_RESERVED, MAP_PHYSICAL | MAP_PINNED | MAP_PERMANENT);
		//if (mem->base + mem->length > max_mem)
		//	max_mem = mem->base + mem->length;
		mem++;
	}

	write_cr3(fixed_globals->pml4_paddr);
	paging::no_invariant_addresses = false;
	paging::page_alloc_counter = 0;
	fixed_globals->dynamic_globals = mmap(nullptr, 0x1000, MAP_INITIALIZE);
}