#pragma once
#include <cstdint>
#include <utility>
#include <concepts>
#include <type_traits>
#include <kstdlib.hpp>
#include <kstdio.hpp>

#define HEAP_MERGE_FREE_BLOCKS
#define HEAP_ALLOC_PROTECTOR
//#define HEAP_VERBOSE_LISTS

static inline uint64_t align_to(uint64_t ptr, uint16_t alignment) {
    return (ptr + alignment - 1) & ~(alignment - 1);
}

template <typename A> class allocator_traits { };

template <typename A, typename T> concept allocator =
requires(A allocator) {
    requires requires(uint64_t count, uint16_t alignment) {
        { allocator.alloc(count, alignment) } -> std::same_as<typename allocator_traits<A>::ptr_t>;
    };
    requires requires(allocator_traits<A>::ptr_t ptr, uint64_t count, uint64_t new_count, uint16_t alignment) {
        { allocator.realloc(ptr, count, new_count, alignment) } -> std::same_as<typename allocator_traits<A>::ptr_t>;
    };
    requires requires(allocator_traits<A>::ptr_t ptr, uint64_t count) {
        allocator.dealloc(ptr, count);
    };
    allocator.destroy();
};

template <typename T> class default_allocator;
template <typename T> class allocator_traits<default_allocator<T>> {
public:
    using ptr_t = std::add_pointer_t<T>;
};
template <typename T> class default_allocator {
public:
    using ptr_t = allocator_traits<default_allocator<T>>::ptr_t;
    ptr_t alloc(uint64_t count, uint16_t alignment = alignof(T)) {
        return new (alignment) T[count];
    }
    void dealloc(ptr_t ptr, uint64_t count) {
        delete[] ptr;
    }
    ptr_t realloc(ptr_t ptr, uint64_t count, uint64_t new_count, uint16_t alignment = alignof(T)) {
        ptr_t new_alloc = alloc(new_count, alignment);
        for (uint64_t i = 0; i < count; i++) {
            new (&new_alloc[i]) T(std::move(ptr[i]));
        }
        for (uint64_t i = count; i < new_count; i++) {
            new (&new_alloc[i]) T();
        }
        dealloc(ptr, count);
        return new_alloc;
    }
    void destroy() { }
};

template <typename T> class waterline_allocator;
template <typename T> class allocator_traits<waterline_allocator<T>> {
public:
    using ptr_t = std::add_pointer_t<T>;
};
template <typename T> class waterline_allocator {
public:
    using ptr_t = allocator_traits<waterline_allocator<T>>::ptr_t;
    ptr_t begin;
    ptr_t end;
    ptr_t waterline;
    constexpr waterline_allocator(ptr_t ptr, uint32_t size) : begin(ptr), end((ptr_t)((uint64_t)ptr + size)), waterline(ptr) { }

    ptr_t alloc(uint64_t count, uint16_t alignment = alignof(T)) {
        if (!alignment) alignment = 1;
        waterline = (ptr_t)(((uint64_t)waterline + alignment - 1) & ~(uint64_t)(alignment - 1));
        ptr_t ret = waterline;
        waterline = (ptr_t)((uint64_t)waterline + sizeof(T) * count);
        kassert((uint64_t)waterline <= (uint64_t)end, "Waterline allocator overflow.");
        return new (ret) T[count];
    }
    void dealloc(ptr_t ptr, uint64_t count) {
        kassert((uint64_t)ptr >= (uint64_t)begin && (uint64_t)ptr <= (uint64_t)end, "Tried to free pointer out of range of waterline allocator.");
        destruct(ptr, count);
        ptr_t ptr_end = (ptr_t)((uint64_t)ptr + sizeof(T) * count);
        if (ptr_end == waterline) waterline = (void*)ptr;
    }
    ptr_t realloc(ptr_t ptr, uint64_t count, uint64_t new_count, uint16_t alignment = alignof(T)) {
        ptr_t ptr_end = (ptr_t)((uint64_t)ptr + sizeof(T) * count);
        if (ptr_end == waterline) {
            for (uint64_t i = count; i < new_count; i++) new (&ptr[i]) T();
            waterline = (ptr_t)((uint64_t)ptr + sizeof(T) * new_count);
            kassert((uint64_t)waterline <= (uint64_t)end, "Waterline allocator overflow.\n");
            return ptr;
        }
        else {
            ptr_t n = alloc(new_count, alignment);
            for (uint64_t i = 0; i < count; i++) n[i] = std::move(ptr[i]);
            for (uint64_t i = count; i < new_count; i++) new (&n[i]) T();
            return n;
        }
    }

    void destroy() { }
};

template <typename T> class heap_allocator;
template <typename T> class allocator_traits<heap_allocator<T>> {
public:
    using ptr_t = std::add_pointer_t<T>;
};
template <typename T> class heap_allocator {
private:
    struct heap_blk {
        uint64_t data;
        uint32_t blk_size;
        uint32_t pad;
    };
    struct heap_meta_head {
        uint32_t size;
        uint32_t alignment_offset;
        #ifdef HEAP_ALLOC_PROTECTOR
        uint64_t protector;
        #endif
    };
    struct heap_meta_tail {
        #ifdef HEAP_ALLOC_PROTECTOR
        uint64_t protector;
        #endif
    };

    static constexpr uint64_t protector_head_magic = 0xF0F1F2F3F4F5F6F7LL;
    static constexpr uint64_t protector_tail_magic = 0x08090A0B0C0D0E0FLL;

    static inline heap_blk* heap_next(heap_blk* blk) {
        return (heap_blk*)(blk->data + blk->blk_size - sizeof(heap_blk));
    }
    static inline uint32_t heap_alloc_size(uint32_t requested_size) {
        return (requested_size + sizeof(heap_meta_head) + 
            sizeof(heap_meta_tail) + (sizeof(heap_blk) - 1)) & ~0xFLLU;
    }

public:
    using ptr_t = allocator_traits<heap_allocator<T>>::ptr_t;
    ptr_t begin;
    ptr_t end;
    uint64_t used;

    heap_allocator(ptr_t begin, ptr_t end) : begin(begin), end(end), used(0) {
        ((heap_blk*)begin)->blk_size = (uint64_t)end - (uint64_t)begin - sizeof(heap_blk);
        ((heap_blk*)begin)->data = (uint32_t)(uint64_t)&((heap_blk*)begin)[1];
        heap_next((heap_blk*)begin)->data = 0;
        heap_next((heap_blk*)begin)->blk_size = 0;
    }
    heap_allocator(ptr_t begin, uint64_t size) : heap_allocator(begin, (ptr_t)((uint64_t)begin + size)) { }

    ptr_t alloc(uint64_t count, uint16_t alignment = alignof(T)) {
        alignment = min(alignment, sizeof(heap_blk));
        uint32_t adj_size = heap_alloc_size(count * sizeof(T));
    #ifdef HEAP_VERBOSE_LISTS
        qprintf<64>("\nMALLOC HEAP DUMP: REQUESTED %08p BYTES\n", count * sizeof(T));
        heap_blk* dbg_block = (heap_blk*)begin;
        while (dbg_block->data) {
            qprintf<64>("%08p [%08p bytes]\n", dbg_block->data, dbg_block->blk_size);
            dbg_block = heap_next(dbg_block);
        }
    #endif
        heap_blk* target_block = (heap_blk*)begin;
        uint64_t aligned_addr;
        uint32_t align_offset;
        while (true) {
            uint64_t block_ptr = (uint64_t)target_block->data;
            aligned_addr = align_to(block_ptr + sizeof(heap_meta_head), alignment) - sizeof(heap_meta_head);
            
            uint32_t blk_size_aligned = target_block->blk_size - (aligned_addr - block_ptr);
            if (blk_size_aligned >= adj_size) {
                align_offset = (aligned_addr - block_ptr);
                break;
            }
            if (!target_block->data) {
                qprintf<32>("\nMALLOC FAIL! HEAP DUMP:\n");
                target_block = (heap_blk*)begin;
                while (target_block->data) {
                    qprintf<64>("%08p [%08p bytes]\n", target_block->data, target_block->blk_size);
                    target_block = heap_next(target_block);
                }
                kassert(false, "");
            }
            target_block = heap_next(target_block);
        }
        uint32_t alloc_size = adj_size + align_offset;
        uint32_t blk_size = adj_size - sizeof(heap_meta_head) - sizeof(heap_meta_tail);

        if (alloc_size - target_block->blk_size < sizeof(heap_blk)) {
            *target_block = *heap_next(target_block);
        }
        else {
            target_block->blk_size -= alloc_size;
            target_block->data += alloc_size;
        }

        heap_meta_head* head_ptr = (heap_meta_head*)aligned_addr;
        heap_meta_tail* tail_ptr = (heap_meta_tail*)(aligned_addr + sizeof(heap_meta_head) + blk_size);
        head_ptr->size = blk_size;
        head_ptr->alignment_offset = align_offset;
        
    #ifdef HEAP_ALLOC_PROTECTOR
        head_ptr->protector = protector_head_magic;
        tail_ptr->protector = protector_tail_magic;
    #endif

        used += alloc_size;
        return (ptr_t)(head_ptr + 1);
    }

    void dealloc(ptr_t ptr, uint64_t count) {
        if(!ptr) return;
        kassert((uint64_t)ptr >= (uint64_t)begin && (uint64_t)ptr <= (uint64_t)end, "Tried to free pointer out of range of heap.");
    #ifdef HEAP_VERBOSE_LISTS
        qprintf<64>("\nFREE HEAP DUMP: PTR %08p\n", ptr);
        heap_blk* dbg_block = (heap_blk*)begin;
        while (dbg_block->data) {
            qprintf<64>("%08p [%08p bytes]\n", dbg_block->data, dbg_block->blk_size);
            dbg_block = heap_next(dbg_block);
        }
    #endif
        heap_meta_head* head_ptr = (heap_meta_head*)((uint64_t)ptr - sizeof(heap_meta_head));
        heap_meta_tail* tail_ptr = (heap_meta_tail*)((uint64_t)ptr + head_ptr->size);
    #ifdef HEAP_ALLOC_PROTECTOR
        if (head_ptr->protector != protector_head_magic) {
            qprintf<256>("FREE %08p: Heap alloc protector bytes corrupted! [%08X] found at head, expected [%08X].\n", ptr, head_ptr->protector, protector_head_magic);
            kassert(false, "");
        }
        if (tail_ptr->protector != protector_tail_magic) {
            qprintf<256>("FREE %08p: Heap alloc protector bytes corrupted! [%08X] found at tail, expected [%08X].\n", ptr, tail_ptr->protector, protector_tail_magic);
            kassert(false, "");
        }
        if (head_ptr->protector != protector_head_magic || tail_ptr->protector != protector_tail_magic) inf_wait();
    #endif

        uint64_t base_addr = (uint64_t)head_ptr - head_ptr->alignment_offset;
        uint64_t end_addr = (uint64_t)tail_ptr + sizeof(heap_meta_tail);
    #ifdef HEAP_MERGE_FREE_BLOCKS
        heap_blk* heap_iter = (heap_blk*)begin;
        while (heap_iter->blk_size) {
            uint64_t blk_base = heap_iter->data;
            uint64_t blk_end = blk_base + heap_iter->blk_size;
            if (blk_end == base_addr) { //Merge backwards
                *heap_iter = *heap_next(heap_iter);
                base_addr = blk_base;
                continue;
            }
            if (blk_base == end_addr) { //Merge forwards
                *heap_iter = *heap_next(heap_iter);
                end_addr = blk_end;
                continue;
            }
            heap_iter = heap_next(heap_iter);
        }
    #endif
        heap_blk orig = *(heap_blk*)begin;
        ((heap_blk*)begin)->data = base_addr;
        ((heap_blk*)begin)->blk_size = end_addr - base_addr,
        *heap_next((heap_blk*)begin) = orig;

        used -= head_ptr->alignment_offset + sizeof(heap_meta_head) + head_ptr->size + sizeof(heap_meta_tail);
    }
    
    ptr_t realloc(ptr_t ptr, uint64_t count, uint64_t new_count, uint16_t alignment = alignof(T)) {
        ptr_t n = alloc(new_count, alignment);
        for (uint64_t i = 0; i < count; i++) {
            n[i] = std::move(ptr[i]);
        }
        for (uint64_t i = count; i < new_count; i++) {
            new (&n[i]) T();
        }
        dealloc(ptr, count);
        return n;
    }

    void destroy() { }
};