#pragma once
#include <bit>
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <lib/allocators/mmap.hpp>
#include <lib/allocators/slab.hpp>
#include <stl/allocator.hpp>
#include <stl/array.hpp>
#include <stl/vector.hpp>
#include <sys/debug.hpp>

constexpr std::size_t SLAB_PAGEMAP_MSS = 64;

// page count, max slab size
template <>
class allocator_traits<class slab_pagemap> {
public:
	using ptr_t = pointer<void, reinterpret>;
};
class slab_pagemap : public default_allocator<uint8_t> {
protected:
	template <std::size_t SS>
	slab_allocator<SS, 4096>* as_width(int i) {
		return slabs[i].p;
	}
	template <std::size_t SS>
	slab_allocator<SS, 4096>* get_slab() {
		for (std::size_t i = 0; i < slabs.size(); i++) {
			if (slabs[i].width == SS)
				if (as_width<SS>(i)->num_allocs < slab_allocator<SS, 4096>::SLAB_COUNT)
					return as_width<SS>(i);
		}

		slabs.emplace_back(mmap(nullptr, 4096, MAP_INITIALIZE), SS);
		return as_width<SS>(slabs.size() - 1);
	}

public:
	using ptr_t = allocator_traits<slab_pagemap>::ptr_t;
	struct pagemap_entry {
		pointer<slab_allocator<1, 4096>, type_cast> p;
		uint8_t width;
	};
	vector<pagemap_entry> slabs{16};

	bool contains(ptr_t ptr) {
		for (auto s : slabs)
			if (ptr >= s.p && ptr < s.p + 1)
				return true;
		return false;
	}
	uint64_t mem_used() {
		uint64_t sum = 0;
		for (std::size_t i = 0; i < slabs.size(); i++) {
			switch (slabs[i].width) {
			case 1: sum += as_width<1>(i)->mem_used(); break;
			case 2: sum += as_width<2>(i)->mem_used(); break;
			case 4: sum += as_width<4>(i)->mem_used(); break;
			case 8: sum += as_width<8>(i)->mem_used(); break;
			case 16: sum += as_width<16>(i)->mem_used(); break;
			case 32: sum += as_width<32>(i)->mem_used(); break;
			case 64: sum += as_width<64>(i)->mem_used(); break;
			case 128: sum += as_width<128>(i)->mem_used(); break;
			}
		}
		return sum;
	}

	ptr_t alloc(uint64_t size) {
		if (size > SLAB_PAGEMAP_MSS)
			return nullptr;
		switch (std::bit_ceil(size)) {
		case 1: return get_slab<1>()->alloc(0);
		case 2: return get_slab<2>()->alloc(0);
		case 4: return get_slab<4>()->alloc(0);
		case 8: return get_slab<8>()->alloc(0);
		case 16: return get_slab<16>()->alloc(0);
		case 32: return get_slab<32>()->alloc(0);
		case 64: return get_slab<64>()->alloc(0);
		case 128: return get_slab<128>()->alloc(0);
		default: return nullptr;
		}
	}

	void dealloc(ptr_t ptr) {
		for (std::size_t i = 0; i < slabs.size(); i++) {
			if (ptr < slabs[i].p || ptr >= slabs[i].p + 1)
				continue;
			switch (slabs[i].width) {
			case 1: as_width<1>(i)->dealloc(ptr); break;
			case 2: as_width<2>(i)->dealloc(ptr); break;
			case 4: as_width<4>(i)->dealloc(ptr); break;
			case 8: as_width<8>(i)->dealloc(ptr); break;
			case 16: as_width<16>(i)->dealloc(ptr); break;
			case 32: as_width<32>(i)->dealloc(ptr); break;
			case 64: as_width<64>(i)->dealloc(ptr); break;
			case 128: as_width<128>(i)->dealloc(ptr); break;
			default: kassert(DEBUG_ONLY, ERROR, false, "Deallocated invalid slab block.");
			}
		}
	}
};