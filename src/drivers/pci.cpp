#include <cstdint>
#include <drivers/pci.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <stl/ranges.hpp>
#include <sys/global.hpp>
#include <utility>

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

pci_ids parse_pci_ids(rostring f) {
	vector<rostring> lines = f.split<vector>("\n");
	pci_ids ids = {};
	pci_ids::vendor cur_vendor = {};
	for (rostring& line : lines) {
		if (line.size() == 0)
			continue;
		if (line[0] == '#')
			continue;
		istringstream s(line);
		if (s.match("\t"_RO)) {
			pci_ids::device dev;
			dev.did = s.read_i();
			s.ignore(2);
			dev.name = rostring(s.begin(), s.end());
			cur_vendor.devices.push_back(dev);
		} else {
			if (cur_vendor.devices.size())
				ids.vendors.push_back(std::move(cur_vendor));
			cur_vendor.devices.clear();
			cur_vendor.vid = s.read_i();
			s.ignore(2);
			cur_vendor.name = rostring(s.begin(), s.end());
		}
	}
	if (cur_vendor.devices.size())
		ids.vendors.push_back(cur_vendor);
	return ids;
}
rostring pci_vendor_name(const pci_ids& ids, uint16_t vendor_id) {
	return ranges::find_if(ids.vendors, [vendor_id](const pci_ids::vendor& v) { return v.vid == vendor_id; })->name;
}
rostring pci_device_name(const pci_ids& ids, uint16_t vendor_id, uint16_t device_id) {
	pci_ids::vendor& v =
		*ranges::find_if(ids.vendors, [vendor_id](const pci_ids::vendor& v) { return v.vid == vendor_id; });
	return ranges::find_if(v.devices, [device_id](const pci_ids::device& d) { return d.did == device_id; })->name;
}