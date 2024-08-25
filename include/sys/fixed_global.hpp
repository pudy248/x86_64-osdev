#pragma once
#include <cstdint>
#include <stl/bitset.hpp>
#include <sys/memory/memory.hpp>
#include <sys/memory/paging.hpp>

struct fixed_global_data_t {
	void* dynamic_globals;
	void* frame_info_table;
	volatile uint64_t total_page_count;
	volatile uint64_t mapped_pages;
	page_pml4* pml4;
	void* idt;
};

#define fixed_globals ((fixed_global_data_t*)(0x60000))