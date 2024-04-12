#pragma once
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>

class waterline_allocator;
template <> class allocator_traits<waterline_allocator> {
public:
	using ptr_t = void*;
};
class waterline_allocator : public default_allocator {
public:
	using ptr_t = allocator_traits<waterline_allocator>::ptr_t;
	ptr_t begin;
	ptr_t end;
	ptr_t waterline;
	waterline_allocator(ptr_t ptr, uint64_t size)
		: begin(ptr)
		, end((ptr_t)((uint64_t)ptr + size))
		, waterline(ptr) {
	}

	bool contains(ptr_t ptr) {
		return ptr >= begin && ptr < end;
	}
	uint64_t mem_used() {
		return (uint64_t)waterline - (uint64_t)begin;
	}

	ptr_t alloc(uint64_t size, uint16_t alignment = 0x10) {
		if (!alignment)
			alignment = 1;
		waterline = (ptr_t)(((uint64_t)waterline + alignment - 1) & ~(uint64_t)(alignment - 1));
		ptr_t ret = waterline;
		waterline = (ptr_t)((uint64_t)waterline + size);
		kassert((uint64_t)waterline <= (uint64_t)end, "Waterline allocator overflow.");
		return ret;
	}
	void dealloc(ptr_t ptr, uint64_t size = 0) {
		kassert((uint64_t)ptr >= (uint64_t)begin && (uint64_t)ptr <= (uint64_t)end,
				"Tried to free pointer out of range of waterline allocator.");
		ptr_t ptr_end = (ptr_t)((uint64_t)ptr + size);
		if (ptr_end == waterline)
			waterline = (void*)ptr;
	}
	ptr_t realloc(ptr_t ptr, uint64_t size, uint64_t new_size, uint16_t alignment = 0x10) {
		ptr_t ptr_end = (ptr_t)((uint64_t)ptr + size);
		if (ptr_end == waterline) {
			waterline = (ptr_t)((uint64_t)ptr + new_size);
			kassert((uint64_t)waterline <= (uint64_t)end, "Waterline allocator overflow.");
			return ptr;
		} else {
			ptr_t n = alloc(new_size, alignment);
			memcpy(n, ptr, size);
			return n;
		}
	}
};
