#pragma once
#include <cstdint>
#include <stl/bitset.hpp>
#include <stl/pointer.hpp>
#include <sys/memory/memory.hpp>
#include <sys/memory/paging.hpp>

struct fixed_global_data_t {
	void* dynamic_globals;
	pointer<struct frame_info, reinterpret> frame_info_table;
	volatile uint64_t total_page_count;
	volatile uint64_t mapped_pages;
	pointer<page_pml4, reinterpret> pml4;
	pointer<struct idt_t, unique> idt;
	pointer<void, reinterpret> register_file_ptr;
	pointer<void, reinterpret> register_file_ptr_swap;
};

#define fixed_globals ((fixed_global_data_t*)(0x60000))