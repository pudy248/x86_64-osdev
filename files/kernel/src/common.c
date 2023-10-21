#include <typedefs.h>
#include <common.h>

void memset(void* dest, char src, uint32_t size) {
    for(uint32_t i = 0; i < size; i++) ((char*)dest)[i] = src;
}
