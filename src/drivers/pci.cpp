#include <cstdint>
#include <drivers/pci.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <sys/global.hpp>

uint32_t pci_read(pci_addr dev, uint8_t reg) {
	uint32_t lbus = (uint32_t)dev.bus;
	uint32_t lslot = (uint32_t)dev.slot;
	uint32_t lfunc = (uint32_t)dev.func;
	uint32_t lreg = (uint32_t)reg;

	uint32_t address = (uint32_t)((lbus << 16) | (lslot << 11) | (lfunc << 8) | (lreg << 2) | 0x80000000U);

	outl(0xCF8, address);
	return inl(0xCFC);
}
void pci_write(pci_addr dev, uint8_t reg, uint32_t data) {
	uint32_t lbus = (uint32_t)dev.bus;
	uint32_t lslot = (uint32_t)dev.slot;
	uint32_t lfunc = (uint32_t)dev.func;
	uint32_t lreg = (uint32_t)reg;

	uint32_t address = (uint32_t)((lbus << 16) | (lslot << 11) | (lfunc << 8) | (lreg << 2) | 0x80000000U);

	outl(0xCF8, address);
	outl(0xCFC, data);
}
void pci_write(pci_addr dev, uint32_t offset, uint8_t size, uint32_t data) {
	uint8_t reg = offset >> 2;
	uint8_t reg_off = offset & 3;
	uint32_t v = pci_read(dev, reg);
	for (int i = 0; i < size; i++)
		((uint8_t*)&v)[reg_off + i] = ((uint8_t*)&data)[i];
}

void pci_enable_mem(pci_addr dev) { pci_write(dev, 1, pci_read(dev, 1) | 7); }

pci_device pci_create(pci_addr addr) {
	pci_device dev;
	dev.address = addr;
	*(uint32_t*)&dev.vendor_id = pci_read(addr, 0);
	*(uint32_t*)&dev.rev_id = pci_read(addr, 2);
	*(uint32_t*)&dev.cache_line_size = pci_read(addr, 3);
	for (int i = 0; i < 6; i++)
		dev.bars[i] = pci_read(addr, 4 + i);
	*(uint32_t*)&dev.subsystem_vendor = pci_read(addr, 11);
	*(uint16_t*)&dev.interrupt_line = (uint16_t)pci_read(addr, 15);
	return dev;
}

void pci_init() {
	globals->pci = decltype(globals->pci)::make_nocopy((pci_devices*)walloc(sizeof(pci_devices), 0x10));
	int device_idx = 0;

	for (uint16_t bus = 0; bus < 256; bus++) {
		for (uint8_t slot = 0; slot < 32; slot++) {
			pci_addr addr = {(uint8_t)bus, slot, 0};
			uint32_t reg0 = pci_read(addr, 0);
			if (reg0 == 0xffffffff)
				continue;
			globals->pci->devices[device_idx++] = pci_create(addr);
			if (!(globals->pci->devices[device_idx - 1].header_type & 0x80))
				continue;
			for (uint8_t func = 1; func < 7; func++) {
				pci_addr addr2 = {(uint8_t)bus, slot, func};
				uint32_t reg1 = pci_read(addr2, 0);
				if (reg1 == 0xffffffff)
					continue;
				globals->pci->devices[device_idx++] = pci_create(addr2);
			}
		}
	}

	globals->pci->numDevs = device_idx;
}

void pci_print() {
	for (int i = 0; i < globals->pci->numDevs; i++) {
		printf("(%i:%i:%i) dev:%04x vendor:%04x class %02x:%02x:%02x:%02x\n", globals->pci->devices[i].address.bus,
			globals->pci->devices[i].address.slot, globals->pci->devices[i].address.func,
			globals->pci->devices[i].device_id, globals->pci->devices[i].vendor_id, globals->pci->devices[i].class_id,
			globals->pci->devices[i].subclass, globals->pci->devices[i].prog_if, globals->pci->devices[i].rev_id);
	}
}

pci_device* pci_match(uint8_t class_id, uint8_t subclass, uint8_t prog_if) {
	for (int i = 0; i < globals->pci->numDevs; i++) {
		bool passed = globals->pci->devices[i].class_id == class_id;
		if (subclass < 255)
			passed &= globals->pci->devices[i].subclass == subclass;
		if (prog_if < 255)
			passed &= globals->pci->devices[i].prog_if == prog_if;
		if (passed)
			return &globals->pci->devices[i];
	}
	return nullptr;
}
pci_device* pci_match_id(uint16_t vendor_id, uint16_t device_id) {
	for (int i = 0; i < globals->pci->numDevs; i++)
		if (globals->pci->devices[i].vendor_id == vendor_id && globals->pci->devices[i].device_id == device_id)
			return &globals->pci->devices[i];
	return nullptr;
}

pci_id pci_lookup(rostring id1, rostring id2, const pci_device& dev) {
	rostring vendor = {};
	rostring device = {};
	rostring subsystem = {};

	rostring class_id = {};
	rostring subclass = {};
	rostring prog_if = {};
	{
		vector<rostring> lines = id1.split<vector>("\n");
		int stage = 0;
		for (std::size_t i = 0; i < lines.size(); i++) {
			rostring line = lines[i];
			if (line.size() == 0)
				continue;
			if (line[0] == '#')
				continue;
			istringstream s(line);
			if (s.peek() != '\t') {
				if (stage > 0)
					break;
				uint16_t n = s.read_x();
				s.ignore(2);
				if (n == dev.vendor_id) {
					stage++;
					vendor = rostring(s.begin(), s.end());
				}
				continue;
			}
			s.get();
			if (s.peek() != '\t') {
				if (stage > 1)
					break;
				if (stage < 1)
					continue;
				uint16_t n = s.read_x();
				s.ignore(2);
				if (n == dev.device_id) {
					stage++;
					device = rostring(s.begin(), s.end());
				}
				continue;
			}
			s.get();
			if (s.peek() != '\t') {
				if (stage < 2)
					continue;
				uint16_t n = s.read_x();
				s.ignore(1);
				uint16_t m = s.read_x();
				s.ignore(2);
				if (n == dev.subsystem_vendor && m == dev.subsystem_id) {
					subsystem = rostring(s.begin(), s.end());
					break;
				}
			}
		}
	}
	{
		vector<rostring> lines = id2.split<vector>("\n");
		int stage = 0;
		for (std::size_t i = 0; i < lines.size(); i++) {
			rostring line = lines[i];
			if (line.size() == 0)
				continue;
			if (line[0] == '#')
				continue;
			istringstream s(line);
			if (s.peek() != '\t') {
				if (stage > 0)
					break;
				uint16_t n = s.read_x();
				s.ignore(2);
				if (n == dev.class_id) {
					stage++;
					class_id = rostring(s.begin(), s.end());
				}
				continue;
			}
			s.get();
			if (s.peek() != '\t') {
				if (stage > 1)
					break;
				if (stage < 1)
					continue;
				uint16_t n = s.read_x();
				s.ignore(2);
				if (n == dev.subclass) {
					stage++;
					subclass = rostring(s.begin(), s.end());
				}
				continue;
			}
			s.get();
			if (s.peek() != '\t') {
				if (stage < 2)
					continue;
				uint16_t n = s.read_x();
				s.ignore(2);
				if (n == dev.prog_if) {
					prog_if = rostring(s.begin(), s.end());
					break;
				}
			}
		}
	}
	return {vendor, device, subsystem, class_id, subclass, prog_if};
}
