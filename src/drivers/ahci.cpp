#include "ahci.hpp"
#include <asm.hpp>
#include <cstdint>
#include <drivers/pci.hpp>
#include <kstddef.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <sys/global.hpp>
#include <sys/ktime.hpp>
#include <sys/memory/paging.hpp>

void ahci_init(pci_device ahci_pci) {
	globals->ahci = decltype(globals->ahci)::make_nocopy(waterline_new<ahci_device>());
	void* mem = mmap(nullptr, 0x3000, MAP_INITIALIZE | MAP_CONTIGUOUS);
	void* pmem = virt2phys(mem);

	hba_cmd_header* cmd_list = (hba_cmd_header*)mem;
	fis_reg_h2d* fis = (fis_reg_h2d*)ptr_offset(mem, 0x800);
	hba_cmd_tbl* ctbas = (hba_cmd_tbl*)ptr_offset(mem, 0x1000);

	volatile ahci_mmio* ahci_vmem =
		(volatile ahci_mmio*)mmap(ahci_pci.bars[5] & 0xfffffff0, 0x20000, MAP_WRITETHROUGH | MAP_PHYSICAL | MAP_PINNED);
	pci_enable_mem(ahci_pci.address);
	printf("Using AHCI MMIO at %08x=>%08x\n", ahci_pci.bars[5], ahci_vmem);
	volatile hba_port* ports = (volatile hba_port*)ptr_offset(ahci_vmem, 0x100);

	if (ahci_vmem->cap2 & 1) {
		ahci_vmem->bohc |= 2;
		while (ahci_vmem->bohc & 1)
			;
		print("BIOS handoff done!\n");
	}

	tsc_delay(10000000);

	int port_idx = -1;
	for (int i = 0; i < 32; i++) {
		if (~ahci_vmem->pi & (1 << i))
			continue;
		if (ports[i].ssts) {
			port_idx = i;
			break;
		}
	}
	//printf("Selecting port %i.\n", port_idx);

	ports[port_idx].cmd &= 0xffffffee;
	//printf("Waiting for FR/CR bits to clear. CMD:%08x\n", ports[port_idx].cmd);
	while (*(volatile uint32_t*)(&ports[port_idx].cmd) & 0xc000)
		;

	//printf("Creating CLB and FB.\n");
	ports[port_idx].clb = (uint64_t)pmem;
	ports[port_idx].clbu = 0;
	ports[port_idx].fb = (uint64_t)ptr_offset(pmem, 0x800);
	ports[port_idx].fbu = 0;

	for (uint32_t i = 0; i < 32; i++) {
		cmd_list[i].ctba = (uint64_t)ptr_offset(pmem, 0x1000 + 0x100 * i);
		cmd_list[i].ctbau = 0;
		cmd_list[i].prdtl = 8;
	}

	ports[port_idx].cmd |= 0x11;
	//printf("Waiting for CR bit to set. CMD: %08x\n", ports[port_idx].cmd);
	for (int i = 0; (*(volatile uint32_t*)&ports[port_idx].cmd & 0xc000) != 0xc000; i++) {
		if (i > 0x2000000) {
			printf("AHCI init stalled. CMD: %08x\n", ports[port_idx].cmd);
			inf_wait();
		}
	}

	//printf("Returning initialized AHCI port handle. CMD: %08x\n", ports[port_idx].cmd);
	*globals->ahci = {ahci_vmem, &ports[port_idx], cmd_list, fis, ctbas};
}

void ahci_read(uint64_t LBA, uint16_t sectors, void* buffer) {
	uint32_t slots = globals->ahci->port->sact | globals->ahci->port->ci;
	int slot;
	for (slot = 0; slot < 32; slot++)
		if (((slots >> slot) & 1) == 0)
			break;
	if (slot == 32) {
		print("No available command slots!\n");
		return;
	}

	globals->ahci->clb[slot].cfl = sizeof(fis_reg_h2d) / 4;
	globals->ahci->clb[slot].w = 0;
	globals->ahci->ctba[slot].prdt_entry[0].dba = (uint64_t)virt2phys(buffer);
	globals->ahci->ctba[slot].prdt_entry[0].dbau = 0;
	globals->ahci->ctba[slot].prdt_entry[0].dbc = sectors * 512llu - 1;
	globals->ahci->ctba[slot].prdt_entry[0].i = 0;

	//printf("%08x ", globals->ahci->port->cmd);
	fis_reg_h2d* cmdfis = (fis_reg_h2d*)&globals->ahci->ctba[slot].cfis;
	cmdfis->fis_type = 0x27;
	cmdfis->c = 1;
	cmdfis->command = 0x25;
	cmdfis->lba0 = LBA & 0xff;
	cmdfis->lba1 = (LBA >> 8) & 0xff;
	cmdfis->lba2 = (LBA >> 16) & 0xff;
	cmdfis->device = 0x40;
	cmdfis->lba3 = (LBA >> 24) & 0xff;
	cmdfis->lba4 = (LBA >> 32) & 0xff;
	cmdfis->lba5 = (LBA >> 40) & 0xff;
	cmdfis->countl = sectors & 0xff;
	cmdfis->counth = (sectors >> 8) & 0xff;
	//print("2 ");
	while (*(volatile uint32_t*)&globals->ahci->port->tfd & 0x84)
		;
	globals->ahci->port->ci |= 1 << slot;
	//print("3\n");
	while ((*(volatile uint32_t*)&globals->ahci->port->ci & (1 << slot)) &&
		   !(*(volatile uint32_t*)&globals->ahci->port->is & 0x40000000)) {
		//printf("Write: %08x %08x\n", globals->ahci->port->cmd, globals->ahci->port->serr); //4017 800
	}
	if (globals->ahci->port->is & 0x40000000)
		print("Disk read error!\n");
}

void ahci_write(uint64_t LBA, uint16_t sectors, const void* buffer) {
	uint32_t slots = globals->ahci->port->sact | globals->ahci->port->ci;
	int slot;
	for (slot = 0; slot < 32; slot++)
		if (((slots >> slot) & 1) == 0)
			break;
	if (slot == 32) {
		print("No available command slots!\n");
		return;
	}

	globals->ahci->clb[slot].cfl = sizeof(fis_reg_h2d) / 4;
	globals->ahci->clb[slot].w = 1;
	globals->ahci->ctba[slot].prdt_entry[0].dba = (uint64_t)virt2phys(buffer);
	//qprintf<80>("ADDR: %08x -> %08x # %08x\n", globals->ahci->ctba[slot].prdt_entry[0].dba, LBA, sectors);
	globals->ahci->ctba[slot].prdt_entry[0].dbau = 0;
	globals->ahci->ctba[slot].prdt_entry[0].dbc = sectors * 512llu - 1;
	globals->ahci->ctba[slot].prdt_entry[0].i = 0;

	fis_reg_h2d* cmdfis = (fis_reg_h2d*)&globals->ahci->ctba[slot].cfis;
	cmdfis->fis_type = 0x27;
	cmdfis->c = 1;
	cmdfis->command = 0x35;
	cmdfis->lba0 = LBA & 0xff;
	cmdfis->lba1 = (LBA >> 8) & 0xff;
	cmdfis->lba2 = (LBA >> 16) & 0xff;
	cmdfis->device = 0x40;
	cmdfis->lba3 = (LBA >> 24) & 0xff;
	cmdfis->lba4 = (LBA >> 32) & 0xff;
	cmdfis->lba5 = (LBA >> 40) & 0xff;
	cmdfis->countl = sectors & 0xff;
	cmdfis->counth = (sectors >> 8) & 0xff;
	while (globals->ahci->port->tfd & 0x84)
		;
	globals->ahci->port->ci |= 1 << slot;
	std::size_t i = 0;
	while (
		(*(volatile uint32_t*)&globals->ahci->port->ci & (1 << slot)) && (globals->ahci->port->is & 0x40000000) == 0) {
		i++;
		if (i == 500000)
			qprintf<80>("Slow write: %08x %08x %08x %08x %08x\n", globals->ahci->port->cmd, globals->ahci->port->serr,
				globals->ahci->port->ci, globals->ahci->port->is, globals->ahci->port->tfd,
				globals->ahci->port->ssts); //4017 800
		if (i > 10000000) {
			print("Write failed!\n");
			inf_wait();
		}
	}
	if (globals->ahci->port->is & 0x40000000)
		print("Disk write error!\n");
}

void read_disk(void* buffer, uint32_t lbaStart, uint16_t lbaCount, uint64_t bufSize) {
	void* mem = mmap(nullptr, lbaCount * 512llu, MAP_CONTIGUOUS);
	ahci_read(lbaStart, lbaCount, mem);
	memcpy(buffer, mem, bufSize);
	kbzero(ptr_offset(mem, bufSize), lbaCount * 512llu - bufSize);
	munmap(mem, lbaCount * 512llu);
}

void write_disk(void* buffer, uint32_t lbaStart, uint16_t lbaCount, uint64_t bufSize) {
	void* mem = mmap(0x10000000, lbaCount * 512llu, MAP_CONTIGUOUS | MAP_PHYSICAL);
	memcpy(mem, buffer, bufSize);
	kbzero(ptr_offset(mem, bufSize), lbaCount * 512llu - bufSize);
	for (int i = 0; i < lbaCount; i += 8)
		ahci_write(lbaStart + i, min(8, lbaCount - i), ptr_offset(mem, i * 512llu));
	munmap(mem, lbaCount * 512llu);
}
