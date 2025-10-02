#include <asm.hpp>
#include <cstdint>
#include <drivers/ahci.hpp>
#include <drivers/pci.hpp>
#include <kassert.hpp>
#include <kfile.hpp>
#include <kstdlib.hpp>
#include <lib/filesystems/fat.hpp>
#include <sys/init.hpp>
#include <sys/memory/memory.hpp>
#include <sys/memory/paging.hpp>

#ifdef KERNEL
void* stage2_main_discard() {
#else
extern "C" void* stage2_main() {
#endif
	init_libcpp();

	if (0) {
		e820_t* mem = paging::invariant_mem_address((e820_t*)0x6f000);
		while (mem->base || mem->length) {
			printf("%08x %08x %02x\n", mem->base, mem->length, mem->type);
			mem++;
		}
	}

	pci_init();
	pci_device* ahci_pci = pci_match(PCI_CLASS::STORAGE, PCI_SUBCLASS::STORAGE_SATA);
	kassert(UNMASKABLE, CATCH_FIRE, ahci_pci, "No AHCI controller detected!\n");
	//printf("Detected AHCI device: %04x:%04x\n", ahci_pci->vendor_id, ahci_pci->device_id);
	ahci_init(*ahci_pci);

	fat_init();
	//load_debug_symbs("/symbols2.txt");
	uint64_t kernel_main;
	{
		file_t kernel = fs::open("/kernel.img");
		kassert(UNMASKABLE, CATCH_FIRE, kernel.n, "Kernel image not found!\n");
		uint64_t kernel_link_loc = pointer<const uint64_t, reinterpret>(kernel.rodata().begin())[0];
		uint64_t kernel_mem_end = pointer<const uint64_t, reinterpret>(kernel.rodata().begin())[1];
		kernel_main = pointer<const uint64_t, reinterpret>(kernel.rodata().begin())[2];
		mmap(kernel_link_loc, kernel_mem_end - kernel_link_loc, MAP_PINNED | MAP_PERMANENT);
		kmemcpy<8>((void*)kernel_link_loc, kernel.rodata().cbegin(), kernel.rodata().size());
	}

	disable_interrupts();
	global_dtors();
	//kernel_main();
	return (void*)kernel_main;
}