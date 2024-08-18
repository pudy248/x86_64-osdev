#pragma once
#include <cstdint>
#include <stl/bitset.hpp>
#include <sys/memory/memory.hpp>
#include <sys/memory/paging.hpp>

struct fixed_global_data_t {
	void* dynamic_globals;
	void* frame_info_table;
	uint64_t total_page_count;
	page_pml4* pml4;
	void* idt;
};

#define fixed_globals ((fixed_global_data_t*)(0x60000))