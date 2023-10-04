#pragma once
#include <typedefs.h>

typedef struct Heap {
    uint32_t numPages;
    uint32_t numFreeBlocks;
} Heap;

Heap* AllocPages(uint32_t count);
void* malloc(uint32_t size, Heap* heap);
void free(void* ptr, Heap* heap);

void memcpy(void *dest, const void *src, uint32_t n);