#pragma once
#include <typedefs.h>

void* AllocHeap(uint32_t count);
void* malloc(uint32_t size, void* heap);
void free(void* ptr, void* heap);

void memcpy(void *dest, const void *src, uint32_t n);
