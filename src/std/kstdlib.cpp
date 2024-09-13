#include <cstdint>
#include <kassert.hpp>
#include <kstddefs.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <lib/allocators/heap.hpp>
#include <lib/allocators/mmap.hpp>
#include <lib/allocators/slab_pagemap.hpp>
#include <lib/allocators/waterline.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>

extern "C" {
void memcpy(void* dest, const void* src, uint64_t size) {
	for (uint64_t i = 0; i < size; i++) { ((char*)dest)[i] = ((char*)src)[i]; }
}
void memmove(void* dest, void* src, uint64_t size) {
	for (uint64_t i = 0; i < size; i++) { ((char*)dest)[i] = ((char*)src)[i]; }
}
void memset(void* dest, uint8_t src, uint64_t size) {
	for (uint64_t i = 0; i < size; i++) { ((uint8_t*)dest)[i] = src; }
}
}

void mem_init() {
	new (&globals->global_waterline) waterline_allocator(mmap(0, 0x40000, 0, 0), 0x40000);
	new (&globals->global_heap) heap_allocator(mmap(0, 0x10000, 0, 0), 0x10000);
	new (&globals->global_pagemap) slab_pagemap<16, 64>(mmap(0, 0x8000, 0, 0));
	new (&globals->global_mmap_alloc) mmap_allocator();
}

[[gnu::returns_nonnull, gnu::malloc]] void* __walloc(uint64_t size, uint16_t alignment) {
	return (void*)globals->global_waterline.alloc(size, alignment);
}

[[gnu::returns_nonnull, gnu::malloc]] void* __malloc(uint64_t size, uint16_t alignment) {
	void* ptr = 0;
	if (!ptr) ptr = globals->global_pagemap.alloc(size);
	if (!ptr && size > 0x4000) { ptr = globals->global_mmap_alloc.alloc(size); }
	if (!ptr) ptr = globals->global_heap.alloc(size, alignment);
	return ptr;
}

void __free(void* ptr) {
	if (globals->global_pagemap.contains(ptr))
		globals->global_pagemap.dealloc(ptr);
	else if (globals->global_heap.contains(ptr))
		globals->global_heap.dealloc(ptr);
	else if (globals->global_mmap_alloc.contains(ptr)) {
		globals->global_mmap_alloc.dealloc(ptr);
	} else {
		print("Freed non-freeable allocation!\n");
		wait_until_kbhit();
		inline_stacktrace();
	}
}

[[gnu::returns_nonnull, gnu::malloc]] void* walloc(uint64_t size, uint16_t alignment) {
	kassert(DEBUG_ONLY, WARNING, size <= 0xffffffff, "Invalid size in walloc()");
	void* ptr = __walloc(size, alignment);
	if (tags_enabled()) return tag_alloc(size, ptr);
	return ptr;
}
[[gnu::returns_nonnull, gnu::malloc]] void* kmalloc(uint64_t size, uint16_t alignment) {
	kassert(DEBUG_ONLY, WARNING, size <= 0xffffffff, "Invalid size in malloc()");
	void* ptr = __malloc(size, alignment);
	if (tags_enabled()) return tag_alloc(size, ptr);
	return ptr;
}
void kfree(void* ptr) {
	if (tags_enabled()) tag_free(ptr);
	__free(ptr);
}

void* operator new(uint64_t size) { return kmalloc(size); }
void* operator new(uint64_t size, std::align_val_t alignment) {
	return (void*)kmalloc(size, (uint16_t)alignment);
}
void* operator new[](uint64_t size) { return (void*)kmalloc(size); }
void* operator new[](uint64_t size, std::align_val_t alignment) {
	return (void*)kmalloc(size, (uint16_t)alignment);
}
void operator delete(void* ptr) noexcept {
	if (ptr) kfree((uint8_t*)ptr);
}
void operator delete(void* ptr, unsigned long) noexcept {
	if (ptr) kfree((uint8_t*)ptr);
}
void operator delete[](void* ptr) noexcept {
	if (ptr) kfree((uint8_t*)ptr);
}
void operator delete[](void* ptr, unsigned long) noexcept {
	if (ptr) kfree((uint8_t*)ptr);
}