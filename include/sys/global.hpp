#pragma once
#include "stl/allocator.hpp"
#include <cstdint>
#include <kstdio.hpp>
#include <lib/fat.hpp>

struct global_data_t {
    console g_console;

    class waterline_allocator<uint8_t>* global_waterline;
    class heap_allocator<uint8_t>* global_heap;
    
    void(*irq_fns[16])(void);
    volatile uint64_t elapsedPITs;

    struct pci_devices* pci;
    struct ahci_device* ahci;
    struct svga_device* svga;
    fat_sys_data fat_data;
};

#define globals ((global_data_t*)0x110000)