#include <typedefs.h>
#include <taskStructs.h>
#include <memory.h>

typedef struct HeapFreeBlock {
    uint32_t offset;
    uint32_t size;
} HeapFreeBlock;

Heap* AllocPages(uint32_t count) {
    uint32_t start = gks->pgWaterline;
    gks->pgWaterline += count;
    Heap* h = (Heap*)(0x40000000 + 0x1000 * start);
    h->numPages = count;
    h->numFreeBlocks = 1;
    HeapFreeBlock* end = (HeapFreeBlock*)(h + h->numPages * 0x1000);
    end[-1].offset = 8;
    end[-1].size = (count * 0x1000) - 16;
    return h;
}

void* malloc(uint32_t size, Heap* heap) {
    HeapFreeBlock* end = (HeapFreeBlock*)(heap + heap->numPages * 0x1000);
    int i;
    for(i = -heap->numFreeBlocks; i < 0; i++) {
        if(end[i].size >= size) break;
    }
    if(i == 0) return 0;
    uint32_t ptr = (uint32_t)heap + end[i].offset;
    end[i].offset += size;
    end[i].size -= size;
    return (void*)ptr;
}

void free(void* ptr, Heap* heap) {
    //TODO MAKE FREE DO SOMETHING
}

void memcpy(void *dest, const void *src, uint32_t n)
{
    int n1 = n >> 2;
    int n2 = n & 3;
    for(int i = 0; i < n1; i++) {
        ((uint32_t*)dest)[i] = ((uint32_t*)src)[i];
    }
    for(int i = n1 << 2; i < (n1 << 2) + n2; i++) {
        ((uint8_t*)dest)[i] = ((uint8_t*)src)[i];
    }
}