#include <kstdlib.hpp>
#include <kstdio.hpp>

#include <sys/init.hpp>
#include <sys/idt.hpp>
#include <sys/pic.hpp>
#include <sys/ktime.hpp>
#include <sys/global.hpp>
#include <sys/debug.hpp>
#include <drivers/pci.hpp>
#include <drivers/ahci.hpp>
#include <drivers/keyboard.hpp>
#include <lib/fat.hpp>

#ifdef KERNEL
void* stage2_main_discard() {
#else
extern "C" void* stage2_main() {
#endif
    init_libcpp();
    idt_init();
    pic_init();
    irq_set(0, &inc_pit);
    irq_set(1, &keyboard_irq);
    time_init();

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
    wait_until_kbhit();
    load_debug_symbs("/symbols2.txt");
    stacktrace();
    uint64_t kernel_main;
    {
        FILE kernel = file_open("/kernel.img");

        kassert(kernel.inode, "Kernel image not found!\n");
        uint64_t kernel_link_loc = ((uint64_t*)kernel.inode->data.begin())[0];
        kernel_main = ((uint64_t*)kernel.inode->data.begin())[1];
        memcpy((void*)kernel_link_loc, kernel.inode->data.begin(), kernel.inode->data.size());
    }

    global_dtors();
    //kernel_main();
    return (void*)kernel_main;
}