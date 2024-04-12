#pragma once
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>
#include <stl/bitset.hpp>

//slab size, page size (actually allocator size)
template <std::size_t SS, std::size_t PS> class slab_allocator;
template <std::size_t SS, std::size_t PS> class allocator_traits<slab_allocator<SS, PS>> {
public:
	using ptr_t = void*;
};
template <std::size_t SS, std::size_t PS> class slab_allocator : public default_allocator {
public:
	using ptr_t = allocator_traits<slab_allocator<SS, PS>>::ptr_t;
	constexpr static std::size_t SLAB_COUNT = ((PS - 8) * 8 / (SS * 8 + 1));

protected:
	constexpr static std::size_t extra_bytes = ((PS - 8) * 8 - SLAB_COUNT * (SS * 8 + 1)) / 8;

	bitset<SLAB_COUNT> bits;
	uint8_t padding[extra_bytes];

public:
	uint32_t num_free = SLAB_COUNT;

protected:
	uint32_t ring_index = 0;
	struct {
		uint8_t bytes[SS];
	} slabs[SLAB_COUNT];

	constexpr inline int index_of(ptr_t ptr) {
		return ((uint64_t)ptr - (uint64_t)&slabs) / SS;
	}

public:
	bool contains(ptr_t ptr) {
		return ptr >= this && ptr < this + 1;
	}
	uint64_t mem_used() {
		return SS * (SLAB_COUNT - num_free);
	}

	ptr_t alloc(uint64_t size) {
		kassert(!size || size == SS, "Attempted to allocate slab of incorrect size.");
		kassert(num_free > 0, "Attempted to allocate slab from full allocator.");
		for (;; ring_index = (ring_index + 1) % SLAB_COUNT) {
			if (!bits[ring_index])
				break;
		}
		bits.flip(ring_index);
		num_free--;
		return &slabs[ring_index];
	}
	void dealloc(ptr_t ptr) {
		int index = index_of(ptr);
		kassert(bits[index], "Double free.");
		bits.flip(index);
		num_free++;
	}
};
