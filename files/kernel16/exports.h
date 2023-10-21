#pragma once
#include <typedefs.h>

typedef struct bios_int_regs {
    uint16_t ax;
    uint16_t bx;
    uint16_t cx;
    uint16_t dx;
    uint16_t si;
    uint16_t di;

    uint16_t ds;
    uint16_t es;
} bios_int_regs;

extern void call_real(void* realFnPtr);
extern void set_disk_num_bios(uint32_t driveNum);
extern void read_disk_bios(void* address, uint32_t lbaStart, uint32_t lbaCount);
extern void bios_interrupt(uint32_t interrupt, bios_int_regs regs);
