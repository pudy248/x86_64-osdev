#include <kstdlib.hpp>
#include <kstdio.hpp>

#include <sys/init.h>
#include <sys/idt.h>
#include <sys/pic.h>
#include <sys/ktime.hpp>
#include <sys/global.h>
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
    printf("%iMHz (%li cycles in %ius)\n", (uint32_t)freqMHz, etsc - stsc, (uint32_t)(eSec * 1000000));
    return freqMHz;
}

extern "C" void stage2_main(unsigned int driveNum);
extern "C" void stage2_main(unsigned int driveNum) {
    init_libcpp();
    idt_init();
    pic_init();
    irq_set(0, &inc_pit);
    time_init();

    //for (int i = 0; i < 2; i++)
    //    clockspeed_MHz();

    //////////////////////////////////////////////////////////
    // Initialize AHCI controller if AHCI driver is enabled //
    //////////////////////////////////////////////////////////
    pci_init();
    pci_device* ahci_pci = pci_match(PCI_CLASS::STORAGE, PCI_SUBCLASS::STORAGE_SATA);
    kassert(ahci_pci, "No AHCI controller detected!\n");
    //printf("Detected AHCI device: %04x:%04x\n", ahci_pci->vendor_id, ahci_pci->device_id);
    ahci_init(*ahci_pci);

    ///////////////////////////////////
    // Load kernel modules from disk //
    ///////////////////////////////////
    fat_init();
    {
        FILE kernel = file_open("/kernel.img");

        kassert(kernel.inode, "Kernel image not found!\n");
        uint64_t kernel_link_loc = *(uint64_t*)kernel.inode->data.begin();
        //printf("Loading kernel to 0x%x.\n", kernel_link_loc);
        memcpy((void*)kernel_link_loc, kernel.inode->data.begin(), kernel.inode->data.size());
    }

    kernel_main();
    inf_wait();
}
