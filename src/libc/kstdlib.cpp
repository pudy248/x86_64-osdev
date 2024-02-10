#include <cstdint>
#include <kstddefs.h>
#include <kstdlib.hpp>
#include <sys/global.h>
#include <stl/vector.hpp>

#define abs(a) (a < 0 ? -a : a)
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

//#define HEAP_VERBOSE_LISTS
#define HEAP_MERGE_FREE_BLOCKS

extern "C" {
    void memcpy(void* a_restrict dest, const void* a_restrict src, uint64_t size) {
        for (uint64_t i = 0; i < size; i++) {
            ((char*)dest)[i] = ((char*)src)[i];
        }
    }
    void memmove(void* dest, void* src, uint64_t size) {
        for (uint64_t i = 0; i < size; i++) {
            ((char*)dest)[i] = ((char*)src)[i];
        }
    }
    void memset(void* dest, uint8_t src, uint64_t size) {
        for (uint64_t i = 0; i < size; i++) {
            ((uint8_t*)dest)[i] = src;
        }
    }
}

struct heap_blk {
    uint64_t data;
    uint32_t blk_size;
    uint32_t pad;
};

struct heap_meta {
    uint32_t size;
    uint32_t alignment_offset;
    uint64_t pad;
};

static_assert(sizeof(heap_blk) == sizeof(heap_meta), "Heap block and heap metadata size must match.");

#define heap ((heap_blk*)0x1000000)
static constexpr uint64_t total_heap_size = 0x1000000;

static inline heap_blk* heap_next(heap_blk* blk) {
    return (heap_blk*)(blk->data + blk->blk_size - sizeof(heap_blk));
}

static void reset_heap() {
    heap->blk_size = total_heap_size - sizeof(heap_blk);
    heap->data = (uint32_t)(uint64_t)&heap[1];
    heap_next(heap)->data = 0;
    heap_next(heap)->blk_size = 0;
}

void mem_init() {
    globals->waterline = 0x400000;
    globals->mem_avail = total_heap_size - sizeof(heap_blk);
    globals->mem_used = sizeof(heap_blk);
    reset_heap();
}

__attribute__((malloc)) void* walloc(uint64_t size, uint16_t alignment) {
    alignment = min(alignment, sizeof(heap_blk));
    uint64_t aligned_ptr = align_to(globals->waterline, alignment);
    globals->waterline = aligned_ptr + size;
    return (void*)aligned_ptr;
}

__attribute__((malloc)) void* malloc(uint64_t size, uint16_t alignment) {
    alignment = min(alignment, sizeof(heap_blk));
    uint64_t adj_size = max(16, (size + sizeof(heap_meta) + sizeof(heap_blk) - 1) & ~0xfLLU); //Add space for blk size, round up to boundary
    heap_blk* target_block = heap;
#ifdef HEAP_VERBOSE_LISTS
    globals->vga_console.putstr("\nMALLOC: ");
    globals->vga_console.hexdump_rev(&size, 4, 4);
    heap_blk* dbg_block = heap;
    while (dbg_block->blk_size) {
        globals->vga_console.hexdump_rev(dbg_block, sizeof(heap_blk), 4);
        dbg_block = heap_next(dbg_block);
    };
#endif
    uint64_t aligned_ptr;
    heap_meta meta;
    while (true) {
        uint64_t block_ptr = (uint64_t)target_block->data;
        aligned_ptr = align_to(block_ptr + sizeof(heap_meta), alignment) - sizeof(heap_meta);
        
        meta.size = target_block->blk_size - (aligned_ptr - block_ptr);
        if (meta.size >= adj_size) {
            meta.alignment_offset = (aligned_ptr - block_ptr);
            break;
        }
        if (!target_block->data) {
            globals->vga_console.putstr("\nMALLOC FAIL:\n");
            target_block = heap;
            while (target_block) {
                globals->vga_console.hexdump(target_block, sizeof(heap_blk));
                target_block = heap_next(target_block);
            }
            inf_wait();
        }
        target_block = heap_next(target_block);
    }
    meta.size = adj_size;

    if (meta.size + meta.alignment_offset - target_block->blk_size < sizeof(heap_blk)) {
        *target_block = *heap_next(target_block);
    }
    else {
        target_block->blk_size -= meta.size + meta.alignment_offset;
        target_block->data += meta.size + meta.alignment_offset;
    }
    *(heap_meta*)aligned_ptr = meta;
    globals->mem_used += meta.size + meta.alignment_offset;
    aligned_ptr += sizeof(heap_meta);
    return (void*)aligned_ptr;
}

void free(void* ptr) {
    if(!ptr) return;
#ifdef HEAP_VERBOSE_LISTS
    globals->vga_console.putstr("\nFREE: ");
    globals->vga_console.hexdump_rev(&ptr, 4, 4);
    heap_blk* dbg_block = heap;
    while (dbg_block->blk_size) {
        globals->vga_console.hexdump_rev(dbg_block, sizeof(heap_blk), 4);
        dbg_block = heap_next(dbg_block);
    };
#endif
    heap_meta* meta_ptr = (heap_meta*)((uint64_t)ptr - sizeof(heap_meta));
    heap_meta meta = *meta_ptr;
    uint64_t base_ptr = (uint64_t)meta_ptr - meta.alignment_offset;
    uint64_t end_ptr = (uint64_t)meta_ptr + meta.size;
#ifdef HEAP_MERGE_FREE_BLOCKS
    heap_blk* heap_iter = heap;
    while (heap_iter->blk_size) {
        uint64_t blk_base = heap_iter->data;
        uint64_t blk_end = blk_base + heap_iter->blk_size;
        if (blk_end == base_ptr) { //Merge backwards
            *heap_iter = *heap_next(heap_iter);
            base_ptr = blk_base;
            continue;
        }
        if (blk_base == end_ptr) { //Merge forwards
            *heap_iter = *heap_next(heap_iter);
            end_ptr = blk_end;
            continue;;
        }
        heap_iter = heap_next(heap_iter);
    }
#endif
    heap_blk orig = *heap;
    heap->data = base_ptr;
    heap->blk_size = end_ptr - base_ptr,
    *heap_next((heap_blk*)heap) = orig;

    globals->mem_used -= meta.size + meta.alignment_offset;
}

void* operator new(uint64_t size) {
    return malloc(size);
}
void* operator new[](uint64_t size) {
    return malloc(size);
}
void operator delete(void* ptr) {
    if (ptr) free(ptr);
}
void operator delete(void* ptr, uint64_t size) {
    if (ptr) free(ptr);
}
void operator delete[](void* ptr) {
    if (ptr) free(ptr);
}
void operator delete[](void* ptr, uint64_t size) {
    if (ptr) free(ptr);
}