#pragma once
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>
#include <stl/pointer.hpp>

template <typename T>
class waterline_allocator;
template <typename T>
class allocator_traits<waterline_allocator<T>> {
public:
	using ptr_t = T*;
};
template <>
class allocator_traits<waterline_allocator<void>> {
public:
	using ptr_t = pointer<void, reinterpret>;
};
template <typename T>
class waterline_allocator : public default_allocator<T> {
public:
	using ptr_t = allocator_traits<waterline_allocator>::ptr_t;
	ptr_t begin;
	ptr_t end;
	ptr_t waterline;
	waterline_allocator() = default;
	waterline_allocator(ptr_t ptr, uint64_t size) : begin(ptr), end(ptr_offset(ptr, size)), waterline(ptr) {}

	bool contains(ptr_t ptr) { return ptr >= begin && ptr < end; }
	uint64_t mem_used() { return (uint64_t)waterline - (uint64_t)begin; }

	ptr_t alloc(uint64_t size, uint16_t alignment = 0x10) {
		if (!alignment)
			alignment = 1;
		waterline = (ptr_t)(((uint64_t)waterline + alignment - 1) & ~(uint64_t)(alignment - 1));
		ptr_t ret = waterline;
		waterline = (ptr_t)((uint64_t)waterline + size);
		kassert(DEBUG_ONLY, WARNING, (uint64_t)waterline <= (uint64_t)end, "Waterline allocator overflow.");
		return ret;
	}
	void dealloc(ptr_t ptr, uint64_t size = 0) {
		kassert(ALWAYS_ACTIVE, ERROR, (uint64_t)ptr >= (uint64_t)begin && (uint64_t)ptr <= (uint64_t)end,
			"Tried to free pointer out of range of waterline allocator.");
		ptr_t ptr_end = ptr_offset(ptr, size);
		if (ptr_end == waterline)
			waterline = ptr;
	}
	ptr_t realloc(ptr_t ptr, uint64_t size, uint64_t new_size, uint16_t alignment = 0x10) {
		ptr_t ptr_end = ptr_offset(ptr, size);
		if (ptr_end == waterline) {
			waterline = ptr_offset(ptr, new_size);
			kassert(DEBUG_ONLY, WARNING, (uint64_t)waterline <= (uint64_t)end, "Waterline allocator overflow.");
			return ptr;
		} else {
			ptr_t n = alloc(new_size, alignment);
			memcpy(n, ptr, size);
			return n;
		}
	}
};

template <typename T, std::size_t N>
class array_allocator;
template <typename T, std::size_t N>
class allocator_traits<array_allocator<T, N>> {
public:
	using ptr_t = T*;
};
template <typename T, std::size_t N>
class array_allocator : public default_allocator<T> {
public:
	using ptr_t = allocator_traits<array_allocator>::ptr_t;
	uint8_t arr[N - 8];
	uint64_t waterline;
	array_allocator() : waterline(0) {}

	bool contains(ptr_t ptr) { return ptr >= this && ptr < this + 1; }
	uint64_t mem_used() { return waterline; }

	ptr_t alloc(uint64_t size, uint16_t = 0x10) {
		kassert(DEBUG_ONLY, WARNING, !waterline, "Array allocator does not support multiple allocations.");
		kassert(DEBUG_ONLY, WARNING, size <= N, "Array allocator overflow.");
		waterline += size;
		return arr;
	}
	void dealloc(ptr_t ptr, uint64_t = 0) {
		kassert(DEBUG_ONLY, ERROR, (uint8_t*)ptr == arr, "Tried to free pointer out of range of array allocator.");
		waterline = 0;
	}
	ptr_t realloc(ptr_t ptr, uint64_t size, uint64_t new_size, uint16_t = 0x10) {
		dealloc(ptr, size);
		return alloc(new_size);
	}
	template <typename Derived>
	ptr_t move(this Derived& self, Derived& other, ptr_t other_ptr) {
		kassert(DEBUG_ONLY, ERROR, !other_ptr || (uint8_t*)other_ptr == other.arr,
			"Tried to move pointer out of range of array allocator.");
		return self.arr;
	}
};

template <typename T, std::size_t N>
class consteval_allocator;
template <typename T, std::size_t N>
class allocator_traits<consteval_allocator<T, N>> {
public:
	using ptr_t = T*;
};
template <typename T, std::size_t N>
class consteval_allocator : public default_allocator<T> {
public:
	using ptr_t = allocator_traits<consteval_allocator>::ptr_t;
	T arr[N] = {};
	consteval consteval_allocator() {}

	consteval ptr_t alloc(uint64_t, uint16_t = 0x10) { return arr; }
	consteval void dealloc(ptr_t, uint64_t = 0) {}
	consteval ptr_t realloc(ptr_t ptr, uint64_t size, uint64_t new_size, uint16_t = 0x10) {
		dealloc(ptr, size);
		return alloc(new_size);
	}
	template <typename Derived>
	consteval ptr_t move(this Derived& self, Derived&, ptr_t) {
		return self.arr;
	}
};