#include <cstdint>
#include <kstddefs.h>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <sys/global.h>
#include <stl/vector.hpp>

#define abs(a) (a < 0 ? -a : a)
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

#define HEAP_MERGE_FREE_BLOCKS
#define HEAP_ALLOC_PROTECTOR
//#define HEAP_VERBOSE_LISTS

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

struct heap_meta_head {
    uint32_t size;
    uint32_t alignment_offset;
    uint64_t protector;
};

struct heap_meta_tail {
    uint64_t protector;
};

#define heap ((heap_blk*)0x1000000)
static constexpr uint64_t total_heap_size = 0x1000000;
static constexpr uint64_t protector_head_magic = 0xF0F1F2F3F4F5F6F7LL;
static constexpr uint64_t protector_tail_magic = 0x08090A0B0C0D0E0FLL;

static inline heap_blk* heap_next(heap_blk* blk) {
    return (heap_blk*)(blk->data + blk->blk_size - sizeof(heap_blk));
}

static inline uint32_t heap_alloc_size(uint32_t requested_size) {
    return (requested_size + sizeof(heap_meta_head) + sizeof(heap_meta_tail) + (sizeof(heap_blk) - 1)) & ~0xFLLU;
}

static inline uint64_t align_to(uint64_t ptr, uint16_t alignment) {
    if (ptr & (alignment - 1))
        return ((ptr & ~(alignment - 1)) + alignment);
    else return ptr;
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
    uint32_t adj_size = heap_alloc_size(size);
#ifdef HEAP_VERBOSE_LISTS
    qprintf<80>("\nMALLOC HEAP DUMP: REQUESTED %08p BYTES\n", size);
    heap_blk* dbg_block = heap;
    while (dbg_block->data) {
        qprintf<80>("%08p [%08p bytes]\n", dbg_block->data, dbg_block->blk_size);
        dbg_block = heap_next(dbg_block);
    }
#endif
    heap_blk* target_block = heap;
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
            qprintf<30>("\nMALLOC FAIL! HEAP DUMP:\n");
            target_block = heap;
            while (target_block->data) {
                qprintf<80>("%08p [%08p bytes]\n", target_block->data, target_block->blk_size);
                target_block = heap_next(target_block);
            }
            inf_wait();
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

    globals->mem_used += alloc_size;
    return (void*)(head_ptr + 1);
}


void free(void* ptr) {
    if(!ptr) return;
#ifdef HEAP_VERBOSE_LISTS
    qprintf<80>("\nFREE HEAP DUMP: PTR %08p\n", ptr);
    heap_blk* dbg_block = heap;
    while (dbg_block->data) {
        qprintf<80>("%08p [%08p bytes]\n", dbg_block->data, dbg_block->blk_size);
        dbg_block = heap_next(dbg_block);
    }
#endif
    heap_meta_head* head_ptr = (heap_meta_head*)((uint64_t)ptr - sizeof(heap_meta_head));
    heap_meta_tail* tail_ptr = (heap_meta_tail*)((uint64_t)ptr + head_ptr->size);
#ifdef HEAP_ALLOC_PROTECTOR
    if (head_ptr->protector != protector_head_magic) qprintf<100>("FREE %08p: Heap alloc protector bytes corrupted! [%08X] found at head.", ptr, head_ptr->protector);
    if (tail_ptr->protector != protector_tail_magic) qprintf<100>("FREE %08p: Heap alloc protector bytes corrupted! [%08X] found at tail.", ptr, tail_ptr->protector);
    if (head_ptr->protector != protector_head_magic || tail_ptr->protector != protector_tail_magic) inf_wait();
#endif

    uint64_t base_addr = (uint64_t)head_ptr - head_ptr->alignment_offset;
    uint64_t end_addr = (uint64_t)tail_ptr + sizeof(heap_meta_tail);
#ifdef HEAP_MERGE_FREE_BLOCKS
    heap_blk* heap_iter = heap;
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
    heap_blk orig = *heap;
    heap->data = base_addr;
    heap->blk_size = end_addr - base_addr,
    *heap_next((heap_blk*)heap) = orig;

    globals->mem_used -= head_ptr->alignment_offset + sizeof(heap_meta_head) + head_ptr->size + sizeof(heap_meta_tail);
}

void* operator new(uint64_t size) {
    return malloc(size);
}
void* operator new(uint64_t size, void* ptr) noexcept {
    return ptr;
}
void* operator new[](uint64_t size) {
    return malloc(size);
}
void* operator new[](uint64_t size, void* ptr) noexcept {
    return ptr;
}
void operator delete(void* ptr) noexcept {
    if (ptr) free(ptr);
}
void operator delete(void* ptr, uint64_t size) noexcept {
    if (ptr) free(ptr);
}
void operator delete[](void* ptr) noexcept {
    if (ptr) free(ptr);
}
void operator delete[](void* ptr, uint64_t size) noexcept {
    if (ptr) free(ptr);
}