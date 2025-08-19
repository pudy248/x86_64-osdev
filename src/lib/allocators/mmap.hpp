#pragma once
#include "stl/pointer.hpp"
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kstdio.hpp>
#include <stl/allocator.hpp>
#include <sys/memory/paging.hpp>

template <typename T>
class mmap_allocator;
template <typename T>
class allocator_traits<mmap_allocator<T>> {
public:
	using ptr_t = T*;
};
template <typename T>
class mmap_allocator : public default_allocator<T> {
public:
	using ptr_t = allocator_traits<mmap_allocator>::ptr_t;

private:
	struct actual_ptr {
		ptr_t begin;
		ptr_t fake_begin;
		std::size_t size;
	};
	static actual_ptr get_actual_ptr(const ptr_t& ptr) {
		return {pointer<uint64_t, reinterpret>(uintptr_t(ptr) - 0x10), ptr, pointer<uint64_t, reinterpret>(ptr)[-2]};
	}

public:
	std::size_t used = 0;
	mmap_allocator() = default;

	bool contains(const ptr_t& ptr) {
		return (uintptr_t(ptr) & 0xfff) == 0x10 && (mstat(uintptr_t(ptr) - 0x10) & MAP_ALLOCATED);
	}
	std::size_t mem_used() const { return used; }

	ptr_t alloc(uint64_t size, uint16_t = 0x10) {
		size += 16;
		pointer<uint64_t, reinterpret> ptr = mmap(nullptr, size, MAP_ALLOCATED);
		*ptr = size;
		used += (size + 0xfff) & ~0xfff;
		return ptr_t(pointer<uint64_t, reinterpret>(uintptr_t(ptr) + 0x10));
	}
	void dealloc(const ptr_t& ptr, uint64_t = 0) {
		kassert(ALWAYS_ACTIVE, ERROR, contains(ptr), "Tried to free pointer not belonging to mmap allocator.");
		actual_ptr a = get_actual_ptr(ptr);
		munmap(a.begin, a.size);
	}
};