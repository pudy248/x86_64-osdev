#include <cstdint>
#include <kstddefs.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <sys/global.hpp>
#include <sys/debug.hpp>
#include <stl/allocator.hpp>

#define abs(a) (a < 0 ? -a : a)
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

extern "C" {
    void memcpy(void* a_restrict dest, const void* a_restrict src, uint64_t size) {
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
    globals->global_waterline = (waterline_allocator<uint8_t>*)0x400000;
    new (globals->global_waterline) waterline_allocator<uint8_t>(
        (uint8_t*)(0x400000 + sizeof(waterline_allocator<uint8_t>)),
        0xC00000 - sizeof(waterline_allocator<uint8_t>));
    globals->global_heap = waterline_new<heap_allocator<uint8_t>>();
    new (globals->global_heap) heap_allocator<uint8_t>((uint8_t*)0x1000000, 0x1000000);
}

__attribute__((malloc)) void* walloc(uint64_t size, uint16_t alignment) {
    return (void*)globals->global_waterline->alloc(size, alignment);
}

__attribute__((malloc)) void* malloc(uint64_t size, uint16_t alignment) {
    return (void*)globals->global_heap->alloc(size, alignment);
}

void free(void* ptr) {
    globals->global_heap->dealloc((uint8_t*)ptr, 0);
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
    if (ptr) free((uint8_t*)ptr);
}
void operator delete[](void* ptr) noexcept {
    if (ptr) free((uint8_t*)ptr);
}