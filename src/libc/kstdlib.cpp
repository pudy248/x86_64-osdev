#include <cstdint>
#include <kstddefs.h>
#include <kstdlib.hpp>
#include <sys/global.h>
#include <stl/vector.hpp>

#define abs(a) (a < 0 ? -a : a)
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

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
    uint64_t blk_size;
    heap_blk* data;
};

struct heap_meta {
    uint64_t size;
    uint64_t pad;
};

#define heap ((heap_blk*)0x1000000)
static constexpr uint64_t total_heap_size = 0x1000000;

static void reset_heap() {
    heap->blk_size = total_heap_size - 8;
    heap->data = &heap[1];
    heap[1].blk_size = 0;
}

void mem_init() {
    globals->waterline = 0x400000;
    globals->mem_avail = total_heap_size - sizeof(heap_blk);
    globals->mem_used = sizeof(heap_blk);
    reset_heap();
    //vector<heap_allocation>* _allocs = waterline_new<vector<heap_allocation>>(1);
    //_allocs->unsafe_set((heap_allocation*)walloc(sizeof(heap_allocation) * 4096, 0x10), 0, 4096);
    //globals->allocs = (void*)_allocs;
}

__attribute__((malloc)) void* walloc(uint64_t size, uint16_t alignment) {
    alignment = min(alignment, sizeof(heap_blk));
    if (globals->waterline % alignment)
        globals->waterline += alignment - globals->waterline % alignment;
    uint64_t tmp = globals->waterline;
    globals->waterline += size;
    return (void*)tmp;
}

__attribute__((malloc)) void* __malloc(uint64_t size) {
    uint64_t adjSize = max(16, (size + sizeof(heap_meta) + sizeof(heap_blk) - 1) & ~0xfLLU); //Add space for blk size, round up to boundary
    heap_blk* targetBlock = heap;
    while (targetBlock->blk_size < adjSize)
        targetBlock = targetBlock->data;

    heap_blk selectedBlock = *targetBlock;
    if (selectedBlock.blk_size - adjSize < sizeof(heap_blk)) {
        adjSize = selectedBlock.blk_size;
        *targetBlock = *selectedBlock.data;
    }
    else {
        targetBlock->blk_size -= adjSize;
        selectedBlock.data += targetBlock->blk_size;
    }
    
    void* ptr = (void*)((uint64_t)selectedBlock.data + sizeof(heap_meta));
    heap_meta* metadata = (heap_meta*)selectedBlock.data;
    metadata->size = adjSize;
    globals->mem_used += adjSize;
    return ptr;
}
__attribute__((malloc)) void* __malloc_tracked(uint64_t size, const char* file, int line) {
    uint64_t adjSize = max(16, (size + sizeof(heap_meta) + sizeof(heap_blk) - 1) & ~0xfLLU); //Add space for blk size, round up to boundary
    heap_blk* targetBlock = heap;
    while (targetBlock->blk_size < adjSize)
        targetBlock = targetBlock->data;

    heap_blk selectedBlock = *targetBlock;
    if (selectedBlock.blk_size - adjSize < sizeof(heap_blk)) {
        adjSize = selectedBlock.blk_size;
        *targetBlock = *selectedBlock.data;
    }
    else {
        targetBlock->blk_size -= adjSize;
        selectedBlock.data += targetBlock->blk_size;
    }
    
    void* ptr = (void*)((uint64_t)selectedBlock.data + sizeof(heap_meta));
    heap_meta* metadata = (heap_meta*)selectedBlock.data;
    metadata->size = adjSize;
    globals->mem_used += adjSize;
    
    //((vector<heap_allocation>*)globals->allocs)->append({ptr, adjSize, file, line});
    
    return ptr;
}

void free(void* ptr) {
    if(!ptr) return;
    heap_blk* blk = (heap_blk*)((uint64_t)ptr - sizeof(heap_meta));
    heap_meta metadata = *(heap_meta*)blk;
    *blk = *heap;
    heap->blk_size = metadata.size;
    heap->data = blk;
    globals->mem_used -= metadata.size;
    //for (int i = 0; i < ((vector<heap_allocation>*)globals->allocs)->size(); i++) {
    //    if (((vector<heap_allocation>*)globals->allocs)->at(i).ptr == ptr) {
    //        ((vector<heap_allocation>*)globals->allocs)->erase(i);
    //        break;
    //    }
    //}
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