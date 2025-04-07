#include <asm.hpp>
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <stl/pointer.hpp>
#include <sys/fixed_global.hpp>
#include <sys/memory/paging.hpp>

#define CHECK_PRESENT 1
#define __frame_info ((frame_info*)fixed_globals->frame_info_table)

void page_t::set_flags(uint16_t flags) {
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
uint16_t page_t::get_flags() {
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

page_t::page_t(pointer<void, reinterpret> address, uint16_t flags) {
	kassert(DEBUG_ONLY, ERROR, !((uint64_t)address & 0xfff), "Attempted to use non-page-aligned address for page.");
	addr = (uint64_t)address >> 12;
	set_flags(flags);
	avl = 0;
	avl2 = 0;
	pk = 0;
}
pointer<void, reinterpret> page_t::address() { return addr << 12; }

pointer<void, reinterpret> page_table::at(int index) {
	if (CHECK_PRESENT && !entries[index].p)
		inf_wait();
	return entries[index].address();
}
pointer<page_table> page_pdt::at(int index) {
	if (CHECK_PRESENT && !entries[index].p)
		inf_wait();
	return entries[index].address();
}
pointer<page_pdt> page_pdpt::at(int index) {
	if (CHECK_PRESENT && !entries[index].p)
		inf_wait();
	return entries[index].address();
}
pointer<page_pdpt> page_pml4::at(int index) {
	if (CHECK_PRESENT && !entries[index].p)
		inf_wait();
	return entries[index].address();
}

void frame_info::set_flags(uint16_t flags) {
	p = !!(flags & MAP_EXISTS);
	permanent = !!(flags & MAP_PERMANENT);
	pinned = !!(flags & MAP_PINNED);
	mmap_alloced = !!(flags & MAP_ALLOC);
}
uint16_t frame_info::get_flags() {
	uint16_t flags = 0;
	if (p)
		flags |= MAP_EXISTS;
	if (permanent)
		flags |= MAP_PERMANENT;
	if (pinned)
		flags |= MAP_PINNED;
	if (mmap_alloced)
		flags |= MAP_ALLOC;
	return flags;
}

struct page_resolution {
	pointer<page_t, reinterpret> ptr;
	int layer;
	// 0 = Memory
	// 1 = PTE
	// 2 = PDTE
	// 3 = PDPTE
	// 4 = PML4E
};
static page_resolution resolve_page(pointer<void, reinterpret> virtual_addr, int stop_level) {
	uint64_t addr(virtual_addr);
	uint64_t pml4_idx = (addr >> 39) & 0x1ff;
	uint64_t pdpt_idx = (addr >> 30) & 0x1ff;
	uint64_t pdt_idx = (addr >> 21) & 0x1ff;
	uint64_t pt_idx = (addr >> 12) & 0x1ff;
	pointer<page_t, reinterpret> page = &fixed_globals->pml4->entries[pml4_idx];
	if (!page->p || stop_level == 4)
		return { page, 4 };
	page = &fixed_globals->pml4->at(pml4_idx)->entries[pdpt_idx];
	if (!page->p || stop_level == 3)
		return { page, 3 };
	page = &fixed_globals->pml4->at(pml4_idx)->at(pdpt_idx)->entries[pdt_idx];
	if (!page->p || stop_level == 2)
		return { page, 2 };
	page = &fixed_globals->pml4->at(pml4_idx)->at(pdpt_idx)->at(pdt_idx)->entries[pt_idx];
	if (!page->p || stop_level == 1)
		return { page, 1 };
	return { page->address(), 0 };
}

static pointer<void, reinterpret> find_contiguous_frame(uint64_t start, size_t size) {
	uint64_t counter = 0;
	for (uint64_t i = start; i < 0x10000; i++) {
		if (!__frame_info[i].p) {
			counter++;
			if (counter == size)
				return (i - counter + 1) << 12;
		} else
			counter = 0;
	}
	kassert(UNMASKABLE, CATCH_FIRE, false, "OUT OF MEMORY");
	return nullptr;
}

constexpr int TABLE_FLAGS = PAGE_P | PAGE_RW;
constexpr int DEFAULT_FLAGS = PAGE_P | PAGE_RW;

pointer<void, reinterpret> virt2phys(pointer<void, reinterpret> virt) {
	page_resolution result = resolve_page(virt, 0);
	kassert(ALWAYS_ACTIVE, ERROR, !result.layer, "Virtual address not present in virt2phys.");
	return result.ptr;
}
pointer<void, reinterpret> phys2virt(pointer<void, reinterpret> phys) { return phys; }

static void map_page(pointer<void, reinterpret> physical_addr, int page_flags, bool counter) {
	page_resolution pr = resolve_page(physical_addr, 1);
	while (pr.layer > 1) {
		pointer<void, reinterpret> page_addr = find_contiguous_frame(0, 1);
		*pr.ptr = page_t(page_addr, TABLE_FLAGS);
		fixed_globals->mapped_pages = fixed_globals->mapped_pages + 1; //TODO: RMW, problem for later
		invlpg(page_addr);
		mprotect(page_addr, 0x1000, 0, MAP_NEW | MAP_PHYSICAL | MAP_INITIALIZE);
		pr = resolve_page(physical_addr, 1);
	}
	*pr.ptr = page_t(physical_addr, page_flags);
	if (counter) {
		if (page_flags & MAP_NEW)
			fixed_globals->mapped_pages = fixed_globals->mapped_pages + 1;
		if (page_flags & MAP_UNMAP)
			fixed_globals->mapped_pages = fixed_globals->mapped_pages - 1;
	}
	invlpg(physical_addr);
}

pointer<void, reinterpret> mmap(pointer<void, reinterpret> addr, size_t size, uint16_t flags, int map) {
	size_t page_count = (size + 0xfff) >> 12;
	if (!(map & MAP_PINNED))
		addr = find_contiguous_frame((uint64_t)addr >> 12, page_count);
	mprotect(addr, size, flags, map | MAP_NEW);
	return addr;
}
void munmap(pointer<void, reinterpret> addr, size_t size) { mprotect(addr, size, DEFAULT_FLAGS, MAP_UNMAP); }
void mprotect(pointer<void, reinterpret> addr, size_t size, uint16_t flags, int map) {
	if constexpr (false) {
		if (~map & MAP_PHYSICAL)
			addr = virt2phys(addr);
	}

	size_t page_count = (size + 0xfff) >> 12;
	for (size_t i = 0; i < page_count; i++) {
		frame_info& fi = __frame_info[((uint64_t)addr >> 12) + i];
		if ((map & MAP_UNMAP) && !fi.p) {
			errorf<32>("%08x\n", (uint64_t)addr + 0x1000 * i);
			kassert(DEBUG_ONLY, WARNING, false, "Attempted to unmap non-present page.");
		} else if ((map & MAP_NEW) && fi.p) {
			errorf<32>("%08x\n", (uint64_t)addr + 0x1000 * i);
			kassert(DEBUG_ONLY, WARNING, false, "Attempted to map new present page.");
		} else if (!(map & MAP_NEW) && !fi.p) {
			errorf<32>("%08x\n", (uint64_t)addr + 0x1000 * i);
			kassert(DEBUG_ONLY, WARNING, false, "Attempted to modify non-present page.");
		}

		kassert(DEBUG_ONLY, WARNING, !fi.permanent || !(map & MAP_UNMAP), "Attempted to unmap permanent allocation.");

		fi.set_flags(map | (map & MAP_UNMAP ? 0 : MAP_EXISTS));
	}
	if (~map & MAP_INFO_ONLY)
		for (size_t i = 0; i < page_count; i++)
			map_page((uint64_t)addr + (i << 12), (flags ^ DEFAULT_FLAGS) | PAGE_RW, !(map & MAP_NONEXISTENT));

	if (map & MAP_INITIALIZE)
		kbzero<4096>(addr, size);
}
page_stat mstat(pointer<void, reinterpret> addr) {
	if ((uint64_t)addr & 0xfff)
		return {};
	frame_info& fi = __frame_info[((uint64_t)addr >> 12)];
	pointer<page_t> pt = resolve_page(addr, 1).ptr;
	return { pt->get_flags(), fi.get_flags() };
}

void paging_init() {
	fixed_globals->pml4 = 0x61000;
	fixed_globals->pml4->entries[0] = page_t(0x62000, TABLE_FLAGS);
	fixed_globals->pml4->at(0)->entries[0] = page_t(0x63000, TABLE_FLAGS);
	fixed_globals->pml4->at(0)->at(0)->entries[0] = page_t(0x64000, TABLE_FLAGS);
	fixed_globals->frame_info_table = 0x65000;
	fixed_globals->mapped_pages = 0;
	kbzero<4096>(fixed_globals->frame_info_table, 0x1000);

	mprotect(nullptr, 0x20000, 0, MAP_INFO_ONLY | MAP_PHYSICAL | MAP_NEW | MAP_NONEXISTENT);
	mprotect(nullptr, 0x20000, 0, MAP_RESERVED);
	mprotect(0x60000, 0x5000, 0, MAP_KERNEL | MAP_NEW);
	mprotect(0x65000, 0x1000, 0, MAP_PHYSICAL | MAP_NEW);
	mprotect(0xA0000, 0x70000, 0, MAP_RESERVED | MAP_NEW);
	mprotect(0x1F0000, 0x10000, 0, MAP_KERNEL | MAP_NEW);

	write_cr3(uint64_t(fixed_globals->pml4));
	fixed_globals->dynamic_globals = mmap(nullptr, 0x1000, 0, MAP_INITIALIZE);
	void* new_frame_info = mmap(0x400000, 0x100000 * sizeof(frame_info), 0, MAP_RESERVED | MAP_INITIALIZE);
	kmemcpy<4096>(new_frame_info, (void*)0x65000, 0x1000);
	fixed_globals->frame_info_table = new_frame_info;
	munmap(0x65000, 0x1000);
}