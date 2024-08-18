#include <asm.hpp>
#include <cstdint>
#include <kassert.hpp>
#include <kstdlib.hpp>
#include <sys/fixed_global.hpp>
#include <sys/memory/paging.hpp>

#define CHECK_PRESENT 1
#define __frame_info ((frame_info*)fixed_globals->frame_info_table)

void* page_table::at(int index) {
	if (CHECK_PRESENT && !entries[index].p)
		inf_wait();
	return entries[index].address();
}
page_table* page_pdt::at(int index) {
	if (CHECK_PRESENT && !entries[index].p)
		inf_wait();
	return (page_table*)entries[index].address();
}
page_pdt* page_pdpt::at(int index) {
	if (CHECK_PRESENT && !entries[index].p)
		inf_wait();
	return (page_pdt*)entries[index].address();
}
page_pdpt* page_pml4::at(int index) {
	if (CHECK_PRESENT && !entries[index].p)
		inf_wait();
	return (page_pdpt*)entries[index].address();
}

struct page_resolution {
	page_t* ptr;
	int layer;
	// 0 = Memory
	// 1 = PTE
	// 2 = PDTE
	// 3 = PDPTE
	// 4 = PML4E
};
static page_resolution resolve_page(void* virtual_addr, int stop_level) {
	uint64_t addr = (uint64_t)virtual_addr;
	uint64_t pml4_idx = (addr >> 39) & 0x1ff;
	uint64_t pdpt_idx = (addr >> 30) & 0x1ff;
	uint64_t pdt_idx = (addr >> 21) & 0x1ff;
	uint64_t pt_idx = (addr >> 12) & 0x1ff;
	page_t* page = &fixed_globals->pml4->entries[pml4_idx];
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
	return { (page_t*)page->address(), 0 };
}

static void* find_contiguous_frame(uint64_t start, size_t size) {
	uint64_t counter = 0;
	for (uint64_t i = start; i < 0x10000; i++) {
		if (!__frame_info[i].p) {
			counter++;
			if (counter == size)
				return (void*)((i - counter + 1) << 12);
		} else
			counter = 0;
	}
	kassert(UNMASKABLE, CATCH_FIRE, false, "OUT OF MEMORY");
	return 0;
}

constexpr int TABLE_FLAGS = PAGE_P | PAGE_RW;
constexpr int DEFAULT_FLAGS = PAGE_P | PAGE_RW;

void* virt2phys(void* virt) {
	page_resolution result = resolve_page(virt, 0);
	kassert(ALWAYS_ACTIVE, ERROR, !result.layer, "Virtual address not present in virt2phys.");
	return result.ptr;
}
void* phys2virt(void* phys) {
	return phys;
}

static void map_page(void* physical_addr, int page_flags) {
	page_resolution pr = resolve_page(physical_addr, 1);
	while (pr.layer > 1) {
		void* page_addr = find_contiguous_frame(0, 1);
		*pr.ptr = page_t(page_addr, TABLE_FLAGS);
		invlpg(page_addr);
		mprotect((void*)page_addr, 0x1000, 0, MAP_PHYSICAL | MAP_INITIALIZE);
		pr = resolve_page(physical_addr, 1);
	}
	*pr.ptr = page_t(physical_addr, page_flags);
	invlpg(physical_addr);
}

void* mmap(void* addr, size_t size, uint16_t flags, int map) {
	size_t page_count = (size + 0xfff) >> 12;
	addr = find_contiguous_frame((uint64_t)addr >> 12, page_count);
	mprotect(addr, size, flags, map);
	return addr;
}
void munmap(void* addr, size_t size) {
	mprotect(addr, size, DEFAULT_FLAGS, MAP_EXISTS);
}
void mprotect(void* addr, size_t size, uint16_t flags, int map) {
	if constexpr (false) {
		if (~map & MAP_PHYSICAL)
			addr = virt2phys(addr);
	}

	size_t page_count = (size + 0xfff) >> 12;
	for (size_t i = 0; i < page_count; i++) {
		frame_info& fi = __frame_info[((uint64_t)addr >> 12) + i];
		if (map & (MAP_EXISTS | MAP_REMAP))
			kassert(DEBUG_ONLY, WARNING, fi.p, "Attempted to unmap non-present page.");
		else
			kassert(DEBUG_ONLY, WARNING, !fi.p, "Attempted to map present page.");

		if (fi.p && !(map & (MAP_REMAP | MAP_EXISTS)))
			printf("%08x\n", (uint64_t)addr + 0x1000 * i);
		kassert(DEBUG_ONLY, WARNING, !fi.permanent || !(map & MAP_EXISTS), "Attempted to unmap permanent allocation.");
		fi.set_flags(MAP_EXISTS ^ map);
	}
	if (~map & MAP_INFO_ONLY)
		for (size_t i = 0; i < page_count; i++)
			map_page((void*)((uint64_t)addr + (i << 12)), flags ^ DEFAULT_FLAGS);

	if (map & MAP_INITIALIZE)
		bzero<4096>(addr, size);
}

void paging_init() {
	fixed_globals->pml4 = (page_pml4*)0x61000;
	fixed_globals->pml4->entries[0] = page_t((void*)0x62000, TABLE_FLAGS);
	fixed_globals->pml4->at(0)->entries[0] = page_t((void*)0x63000, TABLE_FLAGS);
	fixed_globals->pml4->at(0)->at(0)->entries[0] = page_t((void*)0x64000, TABLE_FLAGS);
	fixed_globals->frame_info_table = (void*)0x65000;
	bzero<4096>(fixed_globals->frame_info_table, 0x1000);

	mprotect(0, 0x20000, 0, MAP_INFO_ONLY | MAP_PHYSICAL);
	mprotect(0, 0x20000, 0, MAP_REMAP | MAP_PHYSICAL);
	mprotect((void*)0x60000, 0x5000, 0, MAP_RESERVED);
	mprotect((void*)0x65000, 0x1000, 0, MAP_PHYSICAL);
	mprotect((void*)0xF0000, 0x20000, 0, MAP_RESERVED);
	mprotect((void*)0x1C0000, 0x40000, 0, MAP_RESERVED);
	mprotect((void*)0x200000, 0x80000, 0, MAP_RESERVED);

	write_cr3((uint64_t)fixed_globals->pml4);
	fixed_globals->dynamic_globals = mmap(0, 0x1000, 0, MAP_INITIALIZE);
	void* new_frame_info = mmap((void*)0x200000, 0x100000, 0, MAP_RESERVED | MAP_INITIALIZE);
	memcpy<4096>(new_frame_info, (void*)0x65000, 0x1000);
	fixed_globals->frame_info_table = new_frame_info;
	munmap((void*)0x65000, 0x1000);
}