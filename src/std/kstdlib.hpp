#pragma once
#include <cstdint>
#include <new>
#include <type_traits>

extern "C" {
void memcpy(void* __restrict dest, const void* __restrict src, uint64_t size);
void memmove(void* dest, void* src, uint64_t size);
void memset(void* dest, uint8_t src, uint64_t size);
}

template <std::size_t A = 1>
void memcpy(void* __restrict dest, const void* __restrict src, uint64_t size) {
	void* adest = __builtin_assume_aligned(dest, A);
	void* asrc = __builtin_assume_aligned(src, A);
	__builtin_assume(size % A == 0);
	for (uint64_t i = 0; i < size; i++)
		((uint8_t* __restrict)adest)[i] = ((uint8_t* __restrict)asrc)[i];
}

template <std::size_t A = 1> void memset(void* __restrict dest, uint8_t src, uint64_t size) {
	void* adest = __builtin_assume_aligned(dest, A);
	__builtin_assume(size % A == 0);
	for (uint64_t i = 0; i < size; i++) { ((uint8_t*)adest)[i] = src; }
}

template <std::size_t A = 1> void bzero(void* __restrict dest, uint64_t size) {
	void* adest = __builtin_assume_aligned(dest, A);
	__builtin_assume(size % A == 0);
	for (uint64_t i = 0; i < size; i++) { ((uint8_t*)adest)[i] = 0; }
}

void mem_init();
[[gnu::returns_nonnull, gnu::malloc]] void* walloc(uint64_t size, uint16_t alignment);
[[gnu::returns_nonnull, gnu::malloc]] void* kmalloc(uint64_t size, uint16_t alignment = 0x10);
void kfree(void* ptr);

extern uint64_t waterline;
extern uint64_t mem_used;
extern uint64_t mem_free;

[[gnu::returns_nonnull]] void* operator new(uint64_t size);
[[gnu::returns_nonnull]] void* operator new(uint64_t size, std::align_val_t alignment);
[[gnu::returns_nonnull]] void* operator new[](uint64_t size);
void operator delete(void* ptr) noexcept;
void operator delete(void* ptr, unsigned long) noexcept;
void operator delete[](void* ptr) noexcept;
void operator delete[](void* ptr, unsigned long) noexcept;
template <typename T> static inline void destruct(T* ptr, int count) {
	if constexpr (std::is_destructible_v<T>)
		for (int i = 0; i < count; i++) ptr[i].~T();
}

template <typename T> T* waterline_new(uint64_t count = 1, uint16_t alignment = alignof(T)) {
	return (T*)walloc(count * sizeof(T), alignment);
}
