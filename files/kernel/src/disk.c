#include <typedefs.h>
#include <common.h>
#include <kernel16/exports.h>
#include <disk.h>

void bios_disk_load(void* address, uint32_t lbaStart, uint16_t lbaCount) {
    bios_disk_packet* packet = (bios_disk_packet*)0x1000;
    *packet = (bios_disk_packet){0x10, 0, 64, 0, 0x4000, lbaStart, 0};
    bios_int_regs regs = {0x4200, 0, 0, 0x80, 0x1000, 0, 0, 0};
    while(lbaCount > 0) {
        if(lbaCount < 64) packet->numSectors = lbaCount;
        bios_interrupt(0x13, regs);
        memcpy(address, (void*)0x40000, (uint32_t)packet->numSectors << 9);
        //basic_printf("Interrupt: %x sectors from %x copied to %x, %x remaining", packet->numSectors, packet->lbaLow, address, lbaCount - packet->numSectors);
        address = (void*)((uint32_t)address + ((uint32_t)packet->numSectors << 9));
        packet->lbaLow += packet->numSectors;
        lbaCount -= packet->numSectors;
    }
}
