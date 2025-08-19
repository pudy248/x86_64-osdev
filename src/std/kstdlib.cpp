#include <cstdint>
#include <kassert.hpp>
#include <kstdlib.hpp>
#include <lib/allocators/heap.hpp>
#include <lib/allocators/mmap.hpp>
#include <lib/allocators/slab_pagemap.hpp>
#include <lib/allocators/waterline.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>

extern "C" {
void memcpy(void* dest, const void* src, uint64_t size) {
	for (uint64_t i = 0; i < size; i++)
		((char*)dest)[i] = ((char*)src)[i];
}
void memmove(void* dest, void* src, uint64_t size) {
	for (uint64_t i = 0; i < size; i++)
		((char*)dest)[i] = ((char*)src)[i];
}
void memset(void* dest, uint8_t src, uint64_t size) {
	for (uint64_t i = 0; i < size; i++)
		((uint8_t*)dest)[i] = src;
}
int memcmp(void* l, void* r, uint64_t size) {
	for (uint64_t i = 0; i < size; i++) {
		if (((uint8_t*)l)[i] > ((uint8_t*)r)[i])
			return 1;
		if (((uint8_t*)l)[i] < ((uint8_t*)r)[i])
			return -1;
	}
	return 0;
}
}

void mem_init() {
	new (&globals->global_waterline) waterline_allocator<void>(mmap(0x2000000, 0x400000, 0), 0x400000);
	new (&globals->global_heap) heap_allocator<void>(mmap(0x2000000, 0x1000000, 0), 0x1000000);
	new (&globals->global_mmap_alloc) mmap_allocator<void>();
	new (&globals->global_pagemap) slab_pagemap();
}

[[gnu::returns_nonnull, gnu::malloc]] void* __walloc(uint64_t size, uint16_t alignment) {
	return (void*)globals->global_waterline.alloc(size, alignment);
}

[[gnu::returns_nonnull, gnu::malloc]] void* __malloc(uint64_t size, uint16_t alignment) {
	void* ptr = globals->global_pagemap.alloc(size);
	if (!ptr && size > 0x10000)
		ptr = globals->global_mmap_alloc.alloc(size);
	if (!ptr)
		ptr = globals->global_heap.alloc(size, alignment);
	return ptr;
}

void __free(void* ptr) {
	if (globals->global_pagemap.contains(ptr))
		globals->global_pagemap.dealloc(ptr);
	else if (globals->global_mmap_alloc.contains(ptr))
		globals->global_mmap_alloc.dealloc(ptr);
	else if (globals->global_heap.contains(ptr))
		globals->global_heap.dealloc(ptr);
	else {
		print("Freed non-freeable allocation!\n");
		wait_until_kbhit();
		inline_stacktrace();
	}
}

[[gnu::malloc]] void* walloc(uint64_t size, uint16_t alignment) {
	kassert(DEBUG_ONLY, WARNING, size <= 0xffffffff, "Invalid size in walloc()");
	void* ptr = size ? __walloc(size, alignment) : nullptr;
	if (ptr && tags_enabled())
		return tag_alloc(size, ptr);
	return ptr;
}
[[gnu::malloc]] void* kmalloc(uint64_t size, uint16_t alignment) {
	kassert(DEBUG_ONLY, WARNING, size <= 0xffffffff, "Invalid size in malloc()");
	void* ptr = size ? __malloc(size, alignment) : nullptr;
	if (ptr && tags_enabled())
		return tag_alloc(size, ptr);
	return ptr;
}
[[gnu::malloc]] void* kcalloc(uint64_t size, uint16_t alignment) {
	void* ptr = kmalloc(size, alignment);
	kbzero<16>(ptr, (size + alignment - 1) & ~(alignment - 1));
	return ptr;
}
void kfree(void* ptr) {
	if (!ptr)
		return;
	if (tags_enabled())
		tag_free(ptr);
	__free(ptr);
}

void* operator new(uint64_t size) { return kmalloc(size); }
void* operator new(uint64_t size, std::align_val_t alignment) { return kmalloc(size, (uint16_t)alignment); }
void* operator new[](uint64_t size) { return kmalloc(size); }
void* operator new[](uint64_t size, std::align_val_t alignment) { return kmalloc(size, (uint16_t)alignment); }
void operator delete(void* ptr) noexcept {
	if (ptr)
		kfree(ptr);
}
void operator delete(void* ptr, unsigned long) noexcept {
	if (ptr)
		kfree(ptr);
}
void operator delete[](void* ptr) noexcept {
	if (ptr)
		kfree(ptr);
}
void operator delete[](void* ptr, unsigned long) noexcept {
	if (ptr)
		kfree(ptr);
}

extern "C" void abort() { int3(); }