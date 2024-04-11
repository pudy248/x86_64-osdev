#pragma once
#include <cstddef>
#include <cstdint>
#include <kstdlib.hpp>
#include <kstdio.hpp>
#include <stl/allocator.hpp>
#include <stl/array.hpp>
#include <stl/vector.hpp>
#include <lib/allocators/slab.hpp>

// page count, max slab size
template <std::size_t PC, std::size_t MSS> class slab_pagemap;
template <std::size_t PC, std::size_t MSS> class allocator_traits<slab_pagemap<PC, MSS>> {
public:
    using ptr_t = void*;
};
template <std::size_t PC, std::size_t MSS> class slab_pagemap : public default_allocator {
protected:
    constexpr static uint8_t next_power_of_two(uint8_t val) {
        if (!val) return 0;
        for (uint8_t i = 1; i && i <= MSS; i <<= 1) if (val <= i) return i;
        return 0;
    }
    template <std::size_t SS> slab_allocator<SS, 4096>* get_slab() {
        kassert((std::size_t)allocated_pages < PC, "Slab pagemap ran out of pages!");
        int first_unused = -1;
        for (std::size_t i = 0; i < PC; i++) {
            if (slab_widths[i] == SS) {
                if (pages.at(i).num_free) return (slab_allocator<SS, 4096>*)&pages.at(i);
            }
            else if (!slab_widths[i] && first_unused == -1) {
                first_unused = i;
                break;
            }
        }
        kassert(first_unused >= 0, "Pagemap error.");
        allocated_pages++;
        slab_widths[first_unused] = SS;
        new (&pages.at(first_unused)) slab_allocator<SS, 4096>();
        return (slab_allocator<SS, 4096>*)&pages.at(first_unused);
    }
    template <std::size_t SS> slab_allocator<SS, 4096>* as_width(int index) {
        return (slab_allocator<SS, 4096>*)&pages.at(index);
    }
public:
    using ptr_t = allocator_traits<slab_pagemap>::ptr_t;
    span<slab_allocator<1, 4096>> pages;
    int allocated_pages = 0;
    array<uint8_t, PC> slab_widths;

    slab_pagemap(void* page_ptr) : pages (
    (slab_allocator<1, 4096>*)page_ptr, 
    (slab_allocator<1, 4096>*)((uint64_t)page_ptr + 4096 * PC)) {
        memset(slab_widths.begin(), 0, PC);
    }

    bool contains(ptr_t ptr) {
        return ptr >= pages.begin() && ptr < pages.end();
    }
    uint64_t mem_used() {
        uint64_t sum = 0;
        for (int index = 0; index < allocated_pages; index++) {
            switch (slab_widths[index]) {
                case 1: sum += as_width<1>(index)->mem_used(); break;
                case 2: sum += as_width<2>(index)->mem_used(); break;
                case 4: sum += as_width<4>(index)->mem_used(); break;
                case 8: sum += as_width<8>(index)->mem_used(); break;
                case 16: sum += as_width<16>(index)->mem_used(); break;
                case 32: sum += as_width<32>(index)->mem_used(); break;
                case 64: sum += as_width<64>(index)->mem_used(); break;
                case 128: sum += as_width<128>(index)->mem_used(); break;
            }
        }
        return sum;
    }

    ptr_t alloc(uint64_t size) {
        switch (next_power_of_two(size)) {
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
        int index = ((uint64_t)ptr - (uint64_t)pages.begin()) >> 12;
        switch (slab_widths[index]) {
            case 1: as_width<1>(index)->dealloc(ptr); break;
            case 2: as_width<2>(index)->dealloc(ptr); break;
            case 4: as_width<4>(index)->dealloc(ptr); break;
            case 8: as_width<8>(index)->dealloc(ptr); break;
            case 16: as_width<16>(index)->dealloc(ptr); break;
            case 32: as_width<32>(index)->dealloc(ptr); break;
            case 64: as_width<64>(index)->dealloc(ptr); break;
            case 128: as_width<128>(index)->dealloc(ptr); break;
            default: kassert(false, "Deallocated invalid slab block.");
        }
    }
};