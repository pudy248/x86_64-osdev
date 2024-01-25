#pragma once
#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kstdio.hpp>

#include <sys/idt.h>
#include <sys/pic.h>
#include <sys/ktime.hpp>
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
    uint64_t elapsedPITs;

    ahci_device* ahci;
    fat_sys_data fat_data;
};

#define globals ((global_data_t*)0x110000)