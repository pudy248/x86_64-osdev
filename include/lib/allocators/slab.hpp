#pragma once
#include <bit>
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
template <std::size_t SS, std::size_t PS> class [[gnu::packed]] slab_allocator : public default_allocator {
	static_assert(std::has_single_bit(SS), "MSS should be a power of two");

public:
	using ptr_t = allocator_traits<slab_allocator<SS, PS>>::ptr_t;
	constexpr static std::size_t SLAB_COUNT = ((PS - 8) * 8 / (SS * 8 + 1));
	constexpr static std::size_t EXTRA_BYTES = ((PS - 8) * 8 - SLAB_COUNT * (SS * 8 + 1)) / 8;
	bitset<SLAB_COUNT> bits;
	uint8_t padding[EXTRA_BYTES];

	uint32_t num_allocs = 0;
	uint32_t ring_index = 0;
	struct {
		uint8_t bytes[SS];
	} slabs[SLAB_COUNT];

protected:
	constexpr inline int index_of(ptr_t ptr) {
		return ((uint64_t)ptr - (uint64_t)&slabs) / SS;
	}

public:
	bool contains(ptr_t ptr) {
		return ptr >= this && ptr < this + 1;
	}
	uint64_t mem_used() {
		return SS * (num_allocs);
	}

	ptr_t alloc(uint64_t size) {
		kassert(DEBUG_ONLY, ERROR, !size || size == SS, "Attempted to allocate slab of incorrect size.");
		kassert(DEBUG_ONLY, ERROR, num_allocs < SS, "Attempted to allocate slab from full allocator.");
		for (;; ring_index = (ring_index + 1) % SLAB_COUNT) {
			if (!bits[ring_index])
				break;
		}
		bits.flip(ring_index);
		num_allocs++;
		return &slabs[ring_index];
	}
	void dealloc(ptr_t ptr) {
		int index = index_of(ptr);
		kassert(DEBUG_ONLY, WARNING, bits[index], "Double free in slab allocator.");
		bits.flip(index);
		num_allocs--;
	}
};