#pragma once
#include <concepts>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <type_traits>
#include <utility>

static inline uint64_t align_to(uint64_t ptr, uint16_t alignment) {
	return (ptr + alignment - 1) & ~(alignment - 1);
}

template <typename A> class allocator_traits {};

template <typename A>
concept allocator = requires(A allocator) {
	requires requires(uint64_t size) {
		{ allocator.alloc(size) } -> std::same_as<typename allocator_traits<A>::ptr_t>;
	};
	requires requires(allocator_traits<A>::ptr_t ptr, uint64_t size, uint64_t new_count) {
		{ allocator.realloc(ptr, size, new_count) } -> std::same_as<typename allocator_traits<A>::ptr_t>;
	};
	requires requires(allocator_traits<A>::ptr_t ptr) {
		allocator.dealloc(ptr);
	};
	allocator.destroy();
};

class default_allocator;
template <> class allocator_traits<default_allocator> {
public:
	using ptr_t = void*;
};
class default_allocator {
public:
	using ptr_t = allocator_traits<default_allocator>::ptr_t;
	ptr_t alloc(uint64_t size) {
		return malloc(size);
	}
	void dealloc(ptr_t ptr) {
		free(ptr);
	}
	template <typename Derived> ptr_t realloc(this Derived& self, ptr_t ptr, uint64_t size, uint64_t new_size) {
		ptr_t new_alloc = self.alloc(new_size);
		memcpy(new_alloc, ptr, size);
		memset((void*)((uint64_t)ptr + size), 0, new_size - size);
		self.dealloc(ptr);
		return new_alloc;
	}
	void destroy() {
	}
};
