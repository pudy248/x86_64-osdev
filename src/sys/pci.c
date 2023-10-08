#include <pci.h>
#include <assembly.h>

uint32_t pci_read_register(pci_geo_addr dev, uint8_t reg) {
    uint32_t lbus  = (uint32_t)dev.bus;
    uint32_t lslot = (uint32_t)dev.slot;
    uint32_t lfunc = (uint32_t)dev.func;
    uint32_t lreg = (uint32_t)reg;
 
    uint32_t address = (uint32_t)((lbus << 16) | (lslot << 11) | (lfunc << 8) | (lreg << 2) | ((uint32_t)0x80000000));
 
    outl(0xCF8, address);
    return inl(0xCFC);
}
void pci_write_register(pci_geo_addr dev, uint8_t reg, uint32_t data);

pci_device pci_create_device(pci_geo_addr addr) {
    pci_device dev;
    dev.address = addr;
    *(uint32_t*)&dev.vendor_id = pci_read_register(addr, 0);
    *(uint32_t*)&dev.rev_id = pci_read_register(addr, 2);
    *(uint32_t*)&dev.cache_line_size = pci_read_register(addr, 3);
    for(int i = 0; i < 6; i++) dev.bars[i] = pci_read_register(addr, 4 + i);
    *(uint32_t*)&dev.subsystem_vendor = pci_read_register(addr, 11);
    *(uint16_t*)&dev.interrupt_line = (uint16_t)pci_read_register(addr, 15);
    return dev;
}

pci_devices pci_scan_devices() {
    pci_device* devices = (pci_device*)0x5000;
    int device_idx = 0;

    for(int bus = 0; bus < 2; bus++) {
        for(int slot = 0; slot < 32; slot++) {
            pci_geo_addr addr = {bus, slot, 0};
            uint32_t reg0 = pci_read_register(addr, 0);
            if(reg0 == 0xffffffff) continue;
            devices[device_idx++] = pci_create_device(addr);
        }
    }
    return (pci_devices){device_idx, devices};
}
