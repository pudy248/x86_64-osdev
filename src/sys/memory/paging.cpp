#include "paging.hpp"
#include "kstdio.hpp"
#include <asm.hpp>
#include <config.hpp>
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kstddef.hpp>
#include <kstdlib.hpp>
#include <lib/allocators/mmap.hpp>
#include <stl/pointer.hpp>
#include <sys/fixed_global.hpp>
#include <sys/memory/memory.hpp>
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

bool no_invariant_addresses;
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

struct free_list_entry {
	uint64_t addr;
	uint64_t size;
};
using free_list = vector<free_list_entry, mmap_allocator<free_list_entry>>;
static free_list& frame_list() { return ((free_list*)&fixed_globals->free_lists)[0]; }
static free_list& page_list() { return ((free_list*)&fixed_globals->free_lists)[1]; }

constexpr frame_table_entry::frame_table_entry(pointer<void, reinterpret> address) {
	p = 1;
	pad = 0;
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
		entry4 = frame_table_entry(alloc_frame(0x80000));
		pmmap(entry4.address(), 0x1000, TABLE_FLAGS, TABLE_MAP);
	}
	return *(frame_pdtp)invariant_mem_address(entry4.address());
}
frame_pdt frame_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx) {
	auto& entry3 = frame_get_or_initialize(pml4_idx)[pdpt_idx];
	if (!entry3.p) {
		entry3 = frame_table_entry(alloc_frame(0x80000));
		pmmap(entry3.address(), 0x1000, TABLE_FLAGS, TABLE_MAP);
	}
	return *(frame_pdtp)invariant_mem_address(entry3.address());
}
frame_table_t frame_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx, uint16_t pdt_idx) {
	auto& entry2 = frame_get_or_initialize(pml4_idx, pdpt_idx)[pdt_idx];
	if (!entry2.p) {
		entry2 = frame_table_entry(alloc_frame(0x80000));
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
		entry4 = page_t(alloc_frame(0x80000), TABLE_FLAGS ^ DEFAULT_PFLAGS);
		pmmap(entry4.address(), 0x1000, TABLE_FLAGS, TABLE_MAP);
	}
	return *(page_table_p)invariant_mem_address(entry4.address());
}
page_table_t page_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx) {
	auto& entry3 = page_get_or_initialize(pml4_idx)[pdpt_idx];
	if (!entry3.p) {
		entry3 = page_t(alloc_frame(0x80000), TABLE_FLAGS ^ DEFAULT_PFLAGS);
		pmmap(entry3.address(), 0x1000, TABLE_FLAGS, TABLE_MAP);
	}
	return *(page_table_p)invariant_mem_address(entry3.address());
}
page_table_t page_get_or_initialize(uint16_t pml4_idx, uint16_t pdpt_idx, uint16_t pdt_idx) {
	auto& entry2 = page_get_or_initialize(pml4_idx, pdpt_idx)[pdt_idx];
	if (!entry2.p) {
		entry2 = page_t(alloc_frame(0x80000), TABLE_FLAGS ^ DEFAULT_PFLAGS);
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

static void list_reserve(free_list& l, uint64_t page_idx, uint64_t page_count, bool allow_absent) {
	for (std::size_t i = 0; i < l.size(); i++) {
		if (page_idx > l[i].addr && page_idx + page_count <= l[i].addr + l[i].size) {
			if (page_idx + page_count == l[i].addr + l[i].size) {
				l[i].size -= page_count;
			} else {
				l.insert({page_idx + page_count, l[i].addr + l[i].size - page_idx - page_count}, i + 1);
				l[i].size = page_idx - l[i].addr;
			}
			return;
		} else if (page_idx == l[i].addr) {
			if (l[i].size == page_count)
				l.erase(i);
			else {
				l[i].size -= page_count;
				l[i].addr += page_count;
			}
			return;
		}
	}
	if (!allow_absent) {
		qprintf<80>("list_reserve failed: %08x %08x\n", page_idx, page_count);
		inf_wait();
	}
}
static pointer<void, reinterpret> list_find(free_list& l, uint64_t page_idx, uint64_t page_count) {
	for (std::size_t i = 0; i < l.size(); i++)
		if (page_idx > l[i].addr && page_idx + page_count <= l[i].addr + l[i].size)
			return page_idx << 12;
		else if (page_idx <= l[i].addr && page_count <= l[i].size)
			return l[i].addr << 12;
	inf_wait();
}
static void list_insert(free_list& l, uint64_t page_idx, uint64_t page_count) {
	int appended_idx = -1;
	for (std::size_t i = 0; i < l.size(); i++) {
		if (page_idx == l[i].addr + l[i].size) {
			l[i].size += page_count;
			appended_idx = i;
		} else if (page_idx + page_count == l[i].addr) {
			if (appended_idx == -1) {
				l[i].addr -= page_count;
				l[i].size += page_count;
				return;
			} else {
				l[appended_idx].size += l[i].size;
				l.erase(i);
				return;
			}
		}
	}
	if (appended_idx == -1)
		l.emplace_back(page_idx, page_count);
}
pointer<void, reinterpret> alloc_contiguous_frames(pointer<void, reinterpret> start, uint64_t size) {
	uint64_t page_idx = (uint64_t)start >> 12;
	if (!page_idx)
		page_idx = 1;
	uint64_t page_count = (size + ((uint64_t)start & 0xfff) + 0xfff) >> 12;
	uint64_t addr = (uint64_t)list_find(frame_list(), page_idx, page_count);
	list_reserve(frame_list(), addr >> 12, page_count, false);
	return addr;
}
pointer<void, reinterpret> alloc_contiguous_pages(pointer<void, reinterpret> start, uint64_t size) {
	uint64_t page_idx = (uint64_t)start >> 12;
	if (!page_idx)
		page_idx = 1;
	uint64_t page_count = (size + ((uint64_t)start & 0xfff) + 0xfff) >> 12;
	uint64_t addr = (uint64_t)list_find(page_list(), page_idx, page_count);
	list_reserve(page_list(), addr >> 12, page_count, false);
	return addr;
}
pointer<void, reinterpret> alloc_frame(pointer<void, reinterpret> start) { return alloc_contiguous_frames(start, 1); }
/*
static uint64_t page_alloc_counter;
pointer<void, reinterpret> alloc_frame(pointer<void, reinterpret> start) {
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
}*/
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
	if (~flags & FRAME_P)
		list_insert(frame_list(), (uint64_t)paddr >> 12, page_count);
	for (size_t i = 0; i < page_count; i++) {
		const uint64_t addr = ((uint64_t)paddr & ~0xfffllu) + (i << 12);
		frame_t& frame = resolve_frame(addr);
		if (!frame.p && (flags & FRAME_P)) {
			auto [pml4_idx, pdpt_idx, pdt_idx, pt_idx] = decompose_addr(addr);
			frame.p = true;
			fixed_globals->frames_allocated++;
			fixed_globals->frames_free--;
		} else if (frame.p && (~flags & FRAME_P)) {
			auto [pml4_idx, pdpt_idx, pdt_idx, pt_idx] = decompose_addr(addr);
			frame.p = false;
			frame.a = false;
			fixed_globals->frames_allocated--;
			fixed_globals->frames_free++;
		}
		frame.set_flags(flags);
		if (map & MAP_INITIALIZE)
			memset(invariant_mem_address((void*)addr), 0, 0x1000);
	}
	return;
}
uint16_t translate_pflags(uint16_t flags, int map) {
	flags ^= paging::DEFAULT_PFLAGS;
	if (map & MAP_READONLY)
		flags |= PAGE_RW;
	if (map & MAP_USER)
		flags |= PAGE_US;
	if (map & MAP_WRITETHROUGH)
		flags |= PAGE_WT;
	if (map & MAP_UNCACHEABLE)
		flags |= PAGE_UC;
	if (map & MAP_EXEC_DISABLE)
		flags |= PAGE_XD;
	return flags;
}
void vmmap(pointer<void, reinterpret> vaddr, size_t size, uint16_t flags, int map) {
	uint64_t page_count = (size + ((uint64_t)vaddr & 0xfff) + 0xfff) >> 12;
	flags = translate_pflags(flags, map);
	if (~flags & PAGE_P)
		list_insert(page_list(), (uint64_t)vaddr >> 12, page_count);
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
	invlpg(vaddr);
	return;
}
void vppair(pointer<void, reinterpret> vaddr, pointer<void, reinterpret> paddr) {
	page_t& pg = resolve_page(vaddr);
	kassert(ALWAYS_ACTIVE, ERROR, pg.p, "Virtual address not present in vppair.");
	kassert(ALWAYS_ACTIVE, ERROR, resolve_frame(paddr).p, "Physical address not present in vppair.");
	pg.addr = (uint64_t)paddr >> 12;
	invlpg(vaddr);
}
void mdirect_map(pointer<void, reinterpret> vaddr, pointer<void, reinterpret> paddr, size_t size, int map) {
	uint64_t page_count = (size + 0xfff) >> 12;
#ifdef KERNEL
	if constexpr (MMAP_LOG && false)
		printf("mdirect_map(%p-%p, %p-%p)\n", vaddr(), ptr_offset(vaddr, page_count << 12)(), paddr(),
			ptr_offset(paddr, page_count << 12)());
#endif

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
}

pointer<void, reinterpret> mmap(pointer<void, reinterpret> addr, size_t size, int map) {
#ifdef KERNEL
	if constexpr (MMAP_LOG)
		printf("mmap(%p, %p, %p)\n", addr(), size, map);
#endif

	uint64_t page_count = (size + ((uint64_t)addr & 0xfff) + 0xfff) >> 12;
	if (map & MAP_IDENTITY) {
		paging::list_reserve(paging::frame_list(), (uint64_t)addr >> 12, page_count, true);
		paging::list_reserve(paging::page_list(), (uint64_t)addr >> 12, page_count, true);
		paging::mdirect_map(addr, addr, size, map);
		return addr;
	}

	uint64_t vaddr = 0;
	uint64_t paddr = 0;

	if (map & MAP_PHYSICAL) {
		paddr = (uint64_t)addr;
		if (~map & MAP_CONTIGUOUS)
			list_reserve(paging::frame_list(), (uint64_t)paddr >> 12, page_count, !!(map & MAP_PINNED));
	} else
		vaddr = (uint64_t)addr;
	if ((~map & MAP_PINNED) || (map & MAP_PHYSICAL)) {
		vaddr = (uint64_t)paging::alloc_contiguous_pages(vaddr, size);
		if (map & MAP_CONTIGUOUS)
			paddr = (uint64_t)paging::alloc_contiguous_frames(paddr, size);
	} else if ((map & MAP_PINNED) && (~map & MAP_PHYSICAL))
		paging::list_reserve(paging::page_list(), (uint64_t)vaddr >> 12, page_count, false);

	if (paddr)
		paging::mdirect_map(vaddr, paddr, size, map);
	else
		for (size_t i = 0; i < page_count; i++)
			paging::mdirect_map(ptr_offset(vaddr, i << 12), paging::alloc_frame(nullptr), 0x1000, map);
	return vaddr;
}
pointer<void, reinterpret> mmap2(
	pointer<void, reinterpret> vaddr, pointer<void, reinterpret> paddr, size_t size, int map) {
#ifdef KERNEL
	if constexpr (MMAP_LOG)
		printf("mmap2(%p, %p, %p, %p)\n", vaddr(), paddr(), size, map);
#endif

	uint64_t page_count = (size + ((uint64_t)vaddr & 0xfff) + 0xfff) >> 12;
	paging::list_reserve(paging::frame_list(), (uint64_t)paddr >> 12, page_count, true);
	paging::list_reserve(paging::page_list(), (uint64_t)vaddr >> 12, page_count, true);
	paging::mdirect_map(vaddr, paddr, size, map);
	return vaddr;
}
void munmap(pointer<void, reinterpret> addr, size_t size) {
#ifdef KERNEL
	if constexpr (MMAP_LOG)
		printf("munmap(%p, %p)\n", addr(), size);
#endif
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
	int fflags = paging::resolve_frame(virt2phys(addr)).get_flags();
	int pflags = paging::resolve_page(addr).get_flags();
	if (fflags & FRAME_ALLOCATED)
		map |= MAP_ALLOCATED;
	if (fflags & FRAME_PERMANENT)
		map |= MAP_PERMANENT;
	if (fflags & FRAME_PINNED)
		map |= MAP_PINNED;
	if (pflags & PAGE_RW)
		map |= MAP_READONLY;
	if (pflags & PAGE_US)
		map |= MAP_USER;
	if (pflags & PAGE_WT)
		map |= MAP_WRITETHROUGH;
	if (pflags & PAGE_UC)
		map |= MAP_UNCACHEABLE;
	if (pflags & PAGE_XD)
		map |= MAP_EXEC_DISABLE;

	return map;
}
auto virt2phys(auto virt) -> decltype(virt) {
	kassert(ALWAYS_ACTIVE, ERROR, !((uint64_t)virt & 0xfff), "Virtual address not aligned.");
	decltype(virt) addr = (decltype(virt))paging::resolve_page(virt).address();
	return addr;
}

vector<page_span> fragmented_virt2phys(pointer<void, reinterpret> virt, uint64_t size) {
	kassert(ALWAYS_ACTIVE, ERROR, !((uint64_t)virt & 0xfff), "Virtual address not aligned.");

	vector<page_span> spans;
	uint64_t page_count = (size + ((uint64_t)virt & 0xfff) + 0xfff) >> 12;
	for (size_t i = 0; i < page_count; i++) {
		pointer<void, reinterpret> vaddr = (uint64_t)virt + (i << 12);
		uint64_t paddr = (uint64_t)virt2phys(vaddr);
		if (spans.size() && spans.back().addr == paddr)
			spans.back().size += 0x1000;
		else
			spans.emplace_back((uint64_t)paddr, 0x1000);
	}
	return spans;
}

void paging_init() {
	paging::no_invariant_addresses = true;
	fixed_globals->frames_allocated = 0;
	fixed_globals->pages_allocated = 0;
	fixed_globals->frames_free = 0;
	kbzero<4096>((void*)0x72000, 0x5000);
	fixed_globals->pml4_paddr = 0x72000;
	fixed_globals->fml4_paddr = 0x73000;
	paging::frame_list().unsafe_set((paging::free_list_entry*)0x75000, 0, 256);
	paging::page_list().unsafe_set((paging::free_list_entry*)0x76000, 0, 256);

	paging::page_list().emplace_back(0x1, 0x800000000);
	paging::page_list().emplace_back(0xffff801000000, 0x7ff000000);

	e820_t* mem = (e820_t*)0x6f000;
	while (mem->base || mem->length) {
		uint64_t begin = (mem->base + 0xfff) & ~0xfffllu;
		uint64_t end = (mem->base + mem->length) & ~0xfffllu;
		if (end > begin && end - begin > 0)
			paging::frame_list().emplace_back(begin >> 12, (end - begin) >> 12);
		mem++;
	}
	// Reserve first frame
	if (!paging::frame_list()[0].addr) {
		paging::frame_list()[0].addr++;
		paging::frame_list()[0].size--;
	}
	// For some reason not present in e820
	paging::frame_list().insert({0xb8, 0x8}, 1);

	// Create HH physical mapping
	paging::page_get_or_initialize()[256] = page_t(0x74000, PAGE_P | PAGE_RW);
	for (uintptr_t i = 0; i < 0x200; i++)
		paging::page_get_or_initialize(256)[i] = page_t(i << 30, PAGE_P | PAGE_RW | PAGE_SZ);

	mmap(0x1000, 0x40000, MAP_IDENTITY | MAP_PINNED); // Bootloader
	mmap(0x72000, 0x3000, MAP_IDENTITY | MAP_PINNED); // Paging structures
	mmap(0x75000, 0x2000, MAP_IDENTITY | MAP_ALLOCATED); // Free lists
	mmap(0x1f0000, 0x10000, MAP_IDENTITY | MAP_PINNED); // Stack

	write_cr3(fixed_globals->pml4_paddr);
	paging::no_invariant_addresses = false;
	fixed_globals->dynamic_globals = mmap(nullptr, 0x1000, MAP_INITIALIZE);
}