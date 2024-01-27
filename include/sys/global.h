#pragma once
#include <cstdint>
#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kstdio.hpp>

#include <drivers/pci.h>
#include <drivers/ahci.h>
#include <lib/fat.hpp>

struct global_data_t {
    console vga_console;

    uint64_t waterline;
    uint64_t mem_used;
    uint64_t mem_avail;
    void* allocs;

    void(*irq_fns[16])(void);
    volatile uint64_t elapsedPITs;

    pci_devices* pci;
    ahci_device* ahci;
    fat_sys_data fat_data;
};

#define globals ((global_data_t*)0x110000)