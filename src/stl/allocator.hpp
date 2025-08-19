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

template <typename A>
struct alloc_value;

template <typename A>
	requires std::is_pointer_v<typename allocator_traits<A>::ptr_t>
struct alloc_value<A> {
	using type = std::remove_pointer_t<typename allocator_traits<A>::ptr_t>;
};
template <typename A>
	requires requires() { typename allocator_traits<A>::ptr_t::type; }
struct alloc_value<A> {
	using type = typename allocator_traits<A>::ptr_t::type;
};
template <typename A>
using alloc_value_t = typename alloc_value<A>::type;

template <typename T>
class default_allocator;
template <typename T>
class allocator_traits<default_allocator<T>> {
public:
	using ptr_t = T*;
};
template <>
class allocator_traits<default_allocator<void>> {
public:
	using ptr_t = pointer<void, reinterpret>;
};

template <typename T>
class default_allocator {
public:
	using ptr_t = typename allocator_traits<default_allocator<T>>::ptr_t;
	ptr_t alloc(uint64_t size) { return typename allocator_traits<default_allocator<T>>::ptr_t(kmalloc(size)); }
	void dealloc(ptr_t ptr) { kfree(ptr); }
	template <typename Derived>
	ptr_t realloc(this Derived& self, ptr_t ptr, uint64_t size, uint64_t new_size) {
		ptr_t new_alloc = self.alloc(new_size);
		memcpy(new_alloc, ptr, min(size, new_size));
		memset(ptr_offset(new_alloc, min(size, new_size)), 0, new_size - size);
		self.dealloc(ptr);
		return new_alloc;
	}
	template <typename Derived>
	constexpr ptr_t move(this Derived&, Derived&, ptr_t other_ptr) {
		return other_ptr;
	}
	constexpr void destroy() {}
};

template <allocator A>
class allocator_reference : public default_allocator<alloc_value_t<A>> {
public:
	A& ref;
	allocator_reference() = delete;
	allocator_reference(A& ref) : ref(ref) {}
	typename allocator_traits<A>::ptr_t alloc(uint64_t size) { return ref.alloc(size); }
	void dealloc(allocator_traits<A>::ptr_t ptr) { ref.dealloc(ptr); }
};
template <allocator A>
class allocator_traits<allocator_reference<A>> {
public:
	using ptr_t = allocator_traits<A>::ptr_t;
};

template <allocator A, A& Ref>
class static_allocator_reference : public default_allocator<alloc_value_t<A>> {
public:
	typename allocator_traits<A>::ptr_t alloc(uint64_t size) { return Ref.alloc(size); }
	void dealloc(allocator_traits<A>::ptr_t ptr) { Ref.dealloc(ptr); }
};
template <allocator A, A& Ref>
class allocator_traits<static_allocator_reference<A, Ref>> {
public:
	using ptr_t = allocator_traits<A>::ptr_t;
};