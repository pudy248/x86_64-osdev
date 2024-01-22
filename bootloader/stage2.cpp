#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <kcstring.h>

#include <sys/global.h>
#include <sys/idt.h>
#include <sys/pic.h>
#include <sys/ktime.hpp>
#include <drivers/pci.h>
#include <drivers/ahci.h>
#include <lib/fat.hpp>

extern "C" void kernel_main(void);

static int clockspeed_MHz() {
    double t1 = timepoint().unix_seconds();
    uint64_t stsc=rdtsc();
    tsc_delay(0x1000000LLU);
    double t2 = timepoint().unix_seconds();
    long etsc=rdtsc();

    double eSec = (t2 - t1);
    double freqMHz = (double)(etsc - stsc) / eSec / 1000000;
    printf("%iMHz (%li cycles in %ius)\r\n", (uint32_t)freqMHz, etsc - stsc, (uint32_t)(eSec * 1000000));
    return freqMHz;
}

extern "C" void stage2_main(unsigned int driveNum);
extern "C" void stage2_main(unsigned int driveNum) {
    mem_init();
    globals->vga_console = console();
    idt_init();
    pic_init();
    irq_set(0, &inc_pit);
    time_init();

    for (int i = 0; i < 10; i++)
        clockspeed_MHz();

    //////////////////////////////////////////////////////////
    // Initialize AHCI controller if AHCI driver is enabled //
    //////////////////////////////////////////////////////////
    pci_init();
    pci_device* ahci_pci = pci_match(1, 6);
    kassert(ahci_pci, "No AHCI controller detected!\r\n");
    printf("Detected AHCI device: %04x:%04x\r\n", ahci_pci->vendor_id, ahci_pci->device_id);
    ahci_init(*ahci_pci);

    ///////////////////////////////////
    // Load kernel modules from disk //
    ///////////////////////////////////

    print("Parsing partition table...\r\n");
    partition_table* partTable = (partition_table*)(0x7c00 + MBR_PARTITION_START);
    int activeEntry = -1;
    for (int i = 0; i < 4; i++) {
        if (partTable->entries[i].sysid == SIG_MBR_FAT32) {
            activeEntry = i;
            break;
        }
    }
    if (activeEntry == -1) {
        print("No FAT32 partitions detected.\r\n");
        inf_wait();
    }

    print("Loading FAT32 filesystem...\r\n");
    fat32_bpb* bpb = (fat32_bpb*)0x1000000;
    read_disk((void*)bpb, partTable->entries[activeEntry].lba_start, 1);

    if (bpb->signature != SIG_BPB_FAT32) {
        print("Invalid FAT32 partition.\r\n");
        //hexdump((void*)&bpb->signature, 1);
        print("Partition table:\r\n");
        //for (uint32_t i = 0; i < 4; i++) {
        //    hexdump((void*)(partTable + 0x20 * i), 0x20);
        //}
        print("FAT BPB:\r\n");
        //for (uint32_t i = 0; i < 8; i++) {
        //    hexdump((void*)(bpb + 0x20 * i), 0x20);
        //}
        inf_wait();
    }

    print("Loading FAT tables...\r\n");
    read_disk((void*)0x1000200, partTable->entries[activeEntry].lba_start + 1, bpb->reserved_sectors - 1 + bpb->fat_tables * bpb->sectors_per_fat32);
    fat_init(&partTable->entries[activeEntry], bpb);

    print("Loading root directory...\r\n");
    fat_file rootDir = {"NULL", 0, (void*)get_cluster_addr(bpb->root_cluster_num)};
    read_cluster_chain(rootDir.dataPtr, bpb->root_cluster_num, 0xffffffff);

    print("Scanning for kernel executables...\r\n");
    fat_file rootFiles[32];
    int nFiles = enum_dir(rootDir, rootFiles);

    int kernelIdx = -1;
    for (int i = 0; i < nFiles; i++)
        if (streql(rootFiles[i].filename, "kernel.img"))
            kernelIdx = i;
    
    read_file(rootFiles[kernelIdx], (void*)0x40000, 512);
    read_file(rootFiles[kernelIdx], *(void**)0x40000, rootFiles[kernelIdx].entry->file_size);

    kernel_main();
    inf_wait();
}
