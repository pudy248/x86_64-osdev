#include <asm.hpp>
#include <cstdint>
#include <drivers/ahci.hpp>
#include <drivers/keyboard.hpp>
#include <drivers/pci.hpp>
#include <kassert.hpp>
#include <kstdlib.hpp>
#include <lib/fat.hpp>
#include <stl/vector.hpp>
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
	idt_init();
	pic_init();
	time_init();
	isr_set(32, &inc_pit);
	isr_set(33, &keyboard_irq);

	pci_init();
	pci_device* ahci_pci = pci_match(PCI_CLASS::STORAGE, PCI_SUBCLASS::STORAGE_SATA);
	kassert(UNMASKABLE, CATCH_FIRE, ahci_pci, "No AHCI controller detected!\n");
	//printf("Detected AHCI device: %04x:%04x\n", ahci_pci->vendor_id, ahci_pci->device_id);
	ahci_init(*ahci_pci);

	fat_init();
	//load_debug_symbs("/symbols2.txt");
	uint64_t kernel_main;
	{
		fat_file kernel = file_open("/kernel.img");

		kassert(UNMASKABLE, CATCH_FIRE, kernel.inode, "Kernel image not found!\n");
		uint64_t kernel_link_loc = ((uint64_t*)&*kernel.inode->data.begin())[0];
		kernel_main = ((uint64_t*)&*kernel.inode->data.begin())[1];
		memcpy<8>((void*)kernel_link_loc, kernel.inode->data.begin(),
				  kernel.inode->data.size() + 8);
	}

	disable_interrupts();
	global_dtors();
	//kernel_main();
	return (void*)kernel_main;
}