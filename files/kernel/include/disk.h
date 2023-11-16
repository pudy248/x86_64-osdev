#pragma once
#include <typedefs.h>

typedef struct bios_disk_packet {
    uint8_t size;
    uint8_t reserved;
    uint16_t numSectors;
    uint16_t addrOffset;
    uint16_t addrSector;
    uint32_t lbaLow;
    uint32_t lbaHigh;
} bios_disk_packet;

void bios_disk_load(void* address, uint32_t lbaStart, uint16_t lbaCount);
