#pragma once
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>
#include <sys/memory/paging.hpp>

class mmap_allocator;
template <> class allocator_traits<mmap_allocator> {
public:
	using ptr_t = void*;
};
class mmap_allocator : public default_allocator {
private:
	struct actual_ptr {
		void* begin;
		void* fake_begin;
		std::size_t size;
	};
	actual_ptr get_actual_ptr(void* ptr) {
		return { (uint64_t*)ptr - 2, ptr, ((uint64_t*)ptr)[-2] };
	}

public:
	using ptr_t = allocator_traits<mmap_allocator>::ptr_t;
	std::size_t used = 0;
	mmap_allocator() = default;

	bool contains(ptr_t ptr) { return mstat(get_actual_ptr(ptr).begin).map_flags & MAP_ALLOC; }
	std::size_t mem_used() { return used; }

	ptr_t alloc(uint64_t size, uint16_t = 0x10) {
		size += 16;
		uint64_t* ptr = (uint64_t*)mmap(0, size, 0, MAP_ALLOC);
		*ptr = size;
		used += (size + 0xfff) & ~0xfff;
		return ptr + 2;
	}
	void dealloc(ptr_t ptr, uint64_t = 0) {
		kassert(ALWAYS_ACTIVE, ERROR, contains(ptr),
				"Tried to free pointer not belonging to mmap allocator.");
		actual_ptr a = get_actual_ptr(ptr);
		munmap(a.begin, a.size);
	}
};