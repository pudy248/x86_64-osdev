#include <cstdint>
#include <kstddefs.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <lib/allocators/heap.hpp>
#include <lib/allocators/pagemap.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/allocator.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>

#define abs(a) (a < 0 ? -a : a)
#define min(a, b) ((a) < (b) ? (a) : (b))
#define max(a, b) ((a) > (b) ? (a) : (b))

extern "C" {
void memcpy(void* __restrict dest, const void* __restrict src, uint64_t size) {
	for (uint64_t i = 0; i < size; i++) {
		((char*)dest)[i] = ((char*)src)[i];
	}
}
void memmove(void* dest, void* src, uint64_t size) {
	for (uint64_t i = 0; i < size; i++) {
		((char*)dest)[i] = ((char*)src)[i];
	}
}
void memset(void* dest, uint8_t src, uint64_t size) {
	for (uint64_t i = 0; i < size; i++) {
		((uint8_t*)dest)[i] = src;
	}
}
}

void mem_init() {
	new (&globals->global_waterline)
		waterline_allocator((uint8_t*)(0x400000 + sizeof(waterline_allocator)), 0x400000 - sizeof(waterline_allocator));
	new (&globals->global_heap) heap_allocator((void*)0x1000000, 0x1000000);
	new (&globals->global_pagemap) slab_pagemap<64, 64>((void*)0x800000);
}

[[gnu::returns_nonnull, gnu::malloc]] void* walloc(uint64_t size, uint16_t alignment) {
	return (void*)globals->global_waterline.alloc(size, alignment);
}

[[gnu::returns_nonnull, gnu::malloc]] void* malloc(uint64_t size, uint16_t alignment) {
	void* ptr = globals->global_pagemap.alloc(size);
	if (!ptr)
		ptr = globals->global_heap.alloc(size, alignment);
	return ptr;
}

void free(void* ptr) {
	if (globals->global_pagemap.contains(ptr))
		globals->global_pagemap.dealloc(ptr);
	else if (globals->global_heap.contains(ptr))
		globals->global_heap.dealloc(ptr);
	else {
		print("Freed non-freeable allocation!\n");
		wait_until_kbhit();
		stacktrace();
	}
}

void* operator new(uint64_t size) {
	return malloc(size);
}
void* operator new(uint64_t size, void* ptr) noexcept {
	return ptr;
}
void* operator new(uint64_t size, uint32_t alignment) noexcept {
	return (void*)malloc(size, alignment);
}
void* operator new[](uint64_t size) {
	return (void*)malloc(size);
}
void* operator new[](uint64_t size, void* ptr) noexcept {
	return ptr;
}
void* operator new[](uint64_t size, uint32_t alignment) noexcept {
	return (void*)malloc(size, alignment);
}
void operator delete(void* ptr) noexcept {
	if (ptr)
		free((uint8_t*)ptr);
}
void operator delete[](void* ptr) noexcept {
	if (ptr)
		free((uint8_t*)ptr);
}