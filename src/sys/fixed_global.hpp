#pragma once
#include <cstdint>
#include <stl/bitset.hpp>
#include <stl/pointer.hpp>
#include <sys/memory/memory.hpp>
#include <sys/memory/paging.hpp>

// UPDATE ISR_ASM IF OFFSET OF REGISTER FILES CHANGES!!
struct fixed_global_data_t {
	void* dynamic_globals;
	pointer<void, reinterpret> register_file_ptr;
	pointer<void, reinterpret> register_file_ptr_swap;

	uint64_t fml4_paddr;
	uint64_t pml4_paddr;

	uint64_t free_lists[8];

	uint64_t frames_free;
	uint64_t frames_allocated;
	uint64_t pages_allocated;

	pointer<struct idt_t, nocopy> idt;
};

#define fixed_globals ((fixed_global_data_t*)0x6000)