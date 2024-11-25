#include <asm.hpp>
#include <cstdint>
#include <drivers/ahci.hpp>
#include <drivers/pci.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <sys/global.hpp>
#include <sys/memory/paging.hpp>

void ahci_init(pci_device ahci_pci) {
	globals->ahci = decltype(globals->ahci)::make_unique(waterline_new<ahci_device>());
	hba_cmd_header* cmd_list = (hba_cmd_header*)mmap(nullptr, 0x1000, 0, MAP_PHYSICAL | MAP_INITIALIZE);
	fis_reg_h2d* fis = (fis_reg_h2d*)((uint64_t)cmd_list + 0x800);
	hba_cmd_tbl* ctbas = (hba_cmd_tbl*)mmap(nullptr, 0x2000, 0, MAP_PHYSICAL | MAP_INITIALIZE);

	volatile ahci_mmio* ahci_mem = (volatile ahci_mmio*)(uint64_t)(ahci_pci.bars[5] & 0xfffffff0);
	mmap((void*)ahci_mem, 0x20000, PAGE_WT, MAP_PHYSICAL | MAP_PINNED);
	pci_enable_mem(ahci_pci.address);
	printf("Using AHCI MMIO at %08x\n", ahci_pci.bars[5]);
	volatile hba_port* ports = (volatile hba_port*)(uint64_t)(ahci_pci.bars[5] + 0x100);

	int port_idx = -1;
	for (int i = 0; i < 32; i++) {
		if (~ahci_mem->pi & (1 << i))
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
	ports[port_idx].clb = (uint64_t)cmd_list;
	ports[port_idx].clbu = 0;
	ports[port_idx].fb = (uint64_t)fis;
	ports[port_idx].fbu = 0;

	for (uint32_t i = 0; i < 32; i++) {
		cmd_list[i].ctba = (uint64_t)ctbas + 0x100 * i;
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
	*globals->ahci = { ahci_mem, &ports[port_idx], cmd_list, fis, ctbas };
}

void ahci_read(ahci_device dev, uint64_t LBA, uint16_t sectors, void* buffer) {
	dev.clb[0].cfl = sizeof(fis_reg_h2d) / 4;
	dev.clb[0].w = 0;
	dev.ctba[0].prdt_entry[0].dba = (uint64_t)buffer;
	dev.ctba[0].prdt_entry[0].dbau = 0;
	dev.ctba[0].prdt_entry[0].dbc = sectors * 512 - 1;
	dev.ctba[0].prdt_entry[0].i = 1;

	//printf("%08x ", dev.port->cmd);
	fis_reg_h2d* cmdfis = (fis_reg_h2d*)&dev.ctba[0].cfis;
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
	while (*(volatile uint32_t*)&dev.port->tfd & 0x84)
		;
	dev.port->ci |= 1;
	//print("3\n");
	while ((*(volatile uint32_t*)&dev.port->ci & 1) && !(*(volatile uint32_t*)&dev.port->is & 0x40000000)) {
		//printf("Write: %08x %08x\n", dev.port->cmd, dev.port->serr); //4017 800
	}
	if (dev.port->is & 0x40000000)
		print("Disk read error!\n");
}

void ahci_write(ahci_device dev, uint64_t LBA, uint16_t sectors, const void* buffer) {
	uint32_t slots = dev.port->sact | dev.port->ci;
	int slot;
	for (slot = 0; slot < 32; slot++)
		if (((slots >> slot) & 1) == 0)
			break;
	if (slot == 32) {
		print("No available command slots!\n");
		return;
	}

	dev.clb[slot].cfl = sizeof(fis_reg_h2d) / 4;
	dev.clb[slot].w = 1;
	dev.ctba[slot].prdt_entry[0].dba = (uint64_t)buffer;
	dev.ctba[slot].prdt_entry[0].dbau = 0;
	dev.ctba[slot].prdt_entry[0].dbc = sectors * 512 - 1;
	dev.ctba[slot].prdt_entry[0].i = 1;

	fis_reg_h2d* cmdfis = (fis_reg_h2d*)&dev.ctba[0].cfis;
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
	while (dev.port->tfd & 0x84)
		;
	dev.port->ci = 1 << slot;
	while ((dev.port->ci & (1 << slot)) && (dev.port->is & 0x40000000) == 0)
		;
	//if (dev.port->is & 0x40000000) console_printf("Disk write error!\n");
}

void read_disk(void* address, uint32_t lbaStart, uint16_t lbaCount) {
	ahci_read(*globals->ahci, lbaStart, lbaCount, address);
}

void write_disk(void* address, uint32_t lbaStart, uint16_t lbaCount) {
	ahci_write(*globals->ahci, lbaStart, lbaCount, address);
}
