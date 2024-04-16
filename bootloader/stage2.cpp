#include <cstdint>
#include <drivers/ahci.hpp>
#include <drivers/keyboard.hpp>
#include <drivers/pci.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <lib/allocators/waterline.hpp>
#include <lib/fat.hpp>
#include <stl/vector.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>
#include <sys/idt.hpp>
#include <sys/init.hpp>
#include <sys/ktime.hpp>
#include <sys/pic.hpp>

#ifdef KERNEL
void* stage2_main_discard() {
#else
extern "C" void* stage2_main() {
#endif
	init_libcpp();
	new (&globals->heap_allocations)
		vector<heap_tag, waterline_allocator>(1000, waterline_allocator((void*)0x2000000, 0x1000000));

	idt_init();
	pic_init();
	isr_set(32, &inc_pit);
	isr_set(33, &keyboard_irq);
	time_init();

	pci_init();
	pci_device* ahci_pci = pci_match(PCI_CLASS::STORAGE, PCI_SUBCLASS::STORAGE_SATA);
	kassert(ahci_pci, "No AHCI controller detected!\n");
	//printf("Detected AHCI device: %04x:%04x\n", ahci_pci->vendor_id, ahci_pci->device_id);
	ahci_init(*ahci_pci);

	fat_init();
	//load_debug_symbs("/symbols2.txt");
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