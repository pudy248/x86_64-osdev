//#define AHCI

#ifdef AHCI
#include <pci.h>
#include <ahci.h>
#include <string.h>
#else
#include <kernel16/exports.h>
#endif
#include <common.h>
#include <fat.h>
#include <basic_console.h>

extern void longjmp(uint32_t addr);

#ifdef AHCI
static ahci_device ahciDev;
void read_disk(void* address, uint32_t lbaStart, uint32_t lbaCount) {
    ahci_read(ahciDev, lbaStart, lbaCount, address);
}
#else
void read_disk(void* address, uint32_t lbaStart, uint32_t lbaCount) {
    basic_printf("read disk %x %x %x\r\n", address, lbaStart, lbaCount);
    read_disk_bios(address, lbaStart, lbaCount);
    hexdump((uint32_t)address, 32);
}
#endif

void bootstrap_main(unsigned int driveNum) {
    basic_console_init();

    #ifdef AHCI
    basic_putstr("Scanning for AHCI SATA controller...\r\n");
    pci_devices devs = pci_scan_devices();
    int ahci_idx = -1;
    for(int i = 0; i < devs.numDevs; i++) {
        if(devs.devices[i].class_id == 1) ahci_idx = i;
    }
    if(1){//(ahci_idx == -1) {
        basic_putstr("No AHCI controller detected. PCI devices:\r\n");
        for(int i = 0; i < devs.numDevs; i++) {
            sprintf((char*)0x60800, "(%i:%i:%i) dev:%04x vendor:%04x class %02x:%02x:%02x:%02x\r\n", 
                devs.devices[i].address.bus, devs.devices[i].address.slot, devs.devices[i].address.func,
                devs.devices[i].device_id, devs.devices[i].vendor_id,
                devs.devices[i].class_id, devs.devices[i].subclass, devs.devices[i].prog_if, devs.devices[i].rev_id
            );
            basic_putstr((char*)0x60800);
        }
        while(1);
    }
    ahciDev = ahci_init(devs.devices[ahci_idx]);
    #endif

    basic_putstr("Parsing partition table...\r\n");

    partition_table* partTable = (partition_table*)(0x7c00 + MBR_PARTITION_START);
    int activeEntry = -1;
    for(int i = 0; i < 4; i++) {
        if(partTable->entries[i].sysid == SIG_MBR_FAT32) {
            activeEntry = i;
            break;
        }
    }
    if(activeEntry == -1) {
        basic_putstr("No FAT32 partitions detected.\r\n");
        while(1);
    }

    basic_putstr("Loading FAT BPB...\r\n");
    fat32_bpb* bpb = (fat32_bpb*)0x200000;
    read_disk((void*)bpb, partTable->entries[activeEntry].lba_start, 1);
    if(bpb->signature != SIG_BPB_FAT32) {
        basic_putstr("Invalid FAT32 partition.\r\n");
        hexdump(bpb->signature, 1);
        basic_putstr("Partition table:\r\n");
        for(uint32_t i = 0; i < 4; i++) {
            hexdump((uint32_t)partTable + 0x20 * i, 0x20);
        }
        basic_putstr("FAT BPB:\r\n");
        for(uint32_t i = 0; i < 8; i++) {
            hexdump((uint32_t)bpb + 0x20 * i, 0x20);
        }
        while(1);
    }

    basic_putstr("Loading FAT tables...\r\n");
    read_disk((void*)0x200200, partTable->entries[activeEntry].lba_start + 1, bpb->reserved_sectors - 1 + bpb->fat_tables * bpb->sectors_per_fat32);
    set_fat_constants(&partTable->entries[activeEntry], bpb);
   
    basic_putstr("Loading root directory...\r\n");
    fat_file* rootDir = (fat_file*)get_cluster_addr(bpb->root_cluster_num);
    read_cluster_chain((uint32_t)rootDir, bpb->root_cluster_num);
    
    basic_putstr("Scanning for kernel executables...\r\n");
    int kernelIdx = read_code_file_from_name(rootDir, "kernel  img");
    if(kernelIdx < 0) {
        basic_putstr("Kernel load error.");
        while(1);
    }
    int k16idx = read_code_file_from_name(rootDir, "kernel16img");
    if(k16idx < 0) {
        basic_putstr("Kernel load error.");
        while(1);
    }

    //hexdump(0x80000000, 0x20);
    longjmp(code_fn_addr(rootDir[kernelIdx], 0));

    while(1);
}
