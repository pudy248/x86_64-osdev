#pragma once
#include <concepts>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <stl/pointer.hpp>

static inline uint64_t align_to(uint64_t ptr, uint16_t alignment) { return (ptr + alignment - 1) & ~(alignment - 1); }

template <typename A>
class allocator_traits {};

template <typename A>
concept allocator = requires(A allocator) {
	requires requires(uint64_t size) {
		{ allocator.alloc(size) } -> std::same_as<typename allocator_traits<A>::ptr_t>;
	};
	requires requires(allocator_traits<A>::ptr_t ptr, uint64_t size, uint64_t new_count) {
		{ allocator.realloc(ptr, size, new_count) } -> std::same_as<typename allocator_traits<A>::ptr_t>;
	};
	requires requires(allocator_traits<A>::ptr_t ptr) { allocator.dealloc(ptr); };
	allocator.destroy();
};

class default_allocator;
template <>
class allocator_traits<default_allocator> {
public:
	using ptr_t = pointer<void, reinterpret>;
};
class default_allocator {
public:
	using ptr_t = allocator_traits<default_allocator>::ptr_t;
	ptr_t alloc(uint64_t size) { return kmalloc(size); }
	void dealloc(ptr_t ptr) { kfree(ptr); }
	template <typename Derived>
	ptr_t realloc(this Derived& self, ptr_t ptr, uint64_t size, uint64_t new_size) {
		ptr_t new_alloc = self.alloc(new_size);
		memcpy(new_alloc, ptr, min(size, new_size));
		memset(ptr_t{ (uint64_t)new_alloc + min(size, new_size) }, 0, new_size - size);
		self.dealloc(ptr);
		return new_alloc;
	}
	template <typename Derived>
	constexpr ptr_t move(this Derived&, Derived&, ptr_t other_ptr) {
		return other_ptr;
	}
	constexpr void destroy() {}
};
template <typename T>
using default_allocator_t = default_allocator;

template <allocator T>
class allocator_reference : public default_allocator {
public:
	T& ref;
	allocator_reference() = delete;
	allocator_reference(T& ref) : ref(ref) {}
	allocator_traits<T>::ptr_t alloc(uint64_t size) { return ref.alloc(size); }
	void dealloc(allocator_traits<T>::ptr_t ptr) { ref.dealloc(ptr); }
};
template <allocator T>
class allocator_traits<allocator_reference<T>> {
public:
	using ptr_t = allocator_traits<T>::ptr_t;
};

template <allocator T, T& Ref>
class static_allocator_reference : public default_allocator {
public:
	allocator_traits<T>::ptr_t alloc(uint64_t size) { return Ref.alloc(size); }
	void dealloc(allocator_traits<T>::ptr_t ptr) { Ref.dealloc(ptr); }
};
template <allocator T, T& Ref>
class allocator_traits<static_allocator_reference<T, Ref>> {
public:
	using ptr_t = allocator_traits<T>::ptr_t;
};