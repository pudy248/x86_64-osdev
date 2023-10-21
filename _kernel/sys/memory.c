#include <typedefs.h>
#include <taskStructs.h>
#include <memory.h>

void* AllocHeap(uint32_t count) {
    uint32_t start = gks->pgWaterline;
    gks->pgWaterline += count;
    void* h = (void*)(0x40000000 + 0x1000 * start);
    uint32_t* htable = (uint32_t*)h;
    htable[0] = count * 0x1000 - 8;
    htable[1] = (uint32_t)h + 8;
    htable[3] = 0;
    return h;
}

void* malloc(uint32_t size, void* heap) {
    uint32_t adjSize = size + 4 < 8 ? 8 : size + 4;
    uint32_t* htable = (uint32_t*)heap;

    while(htable[1] != 0) {
        uint32_t blkSize = htable[0];
        if(blkSize < adjSize) {
            htable = (uint32_t*)(htable[1]);
            continue;
        }
        uint32_t blkPtr = htable[1];
        uint32_t allocSize = adjSize;
        if(blkSize - adjSize < 8) {
            htable[0] = ((uint32_t*)blkPtr)[0];
            htable[1] = ((uint32_t*)blkPtr)[1];
            allocSize = blkSize;
        }
        else {
            uint32_t nSize = blkSize - adjSize;
            uint32_t nPtr = blkPtr - adjSize;
            ((uint32_t*)nPtr)[0] = ((uint32_t*)blkPtr)[0];
            ((uint32_t*)nPtr)[1] = ((uint32_t*)blkPtr)[1];
            htable[0] = nSize;
            htable[1] = nPtr;
        }
        *(uint32_t*)blkPtr = allocSize;
        return (void*)(blkPtr + 4);
    }
    return 0;
}

void free(void* ptr, void* heap) {
    uint32_t* htable = (uint32_t*)heap;
    uint32_t* blk = (uint32_t*)((uint32_t)ptr - 4);
    uint32_t blkSize = blk[0];
    blk[0] = htable[0];
    blk[1] = htable[1];
    htable[0] = blkSize;
    htable[1] = (uint32_t)blk;
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
