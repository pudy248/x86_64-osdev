#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kprint.h>
#include <drivers/pci.h>

pci_devices* pci_dev;

uint32_t pci_read(pci_addr dev, uint8_t reg) {
    uint32_t lbus  = (uint32_t)dev.bus;
    uint32_t lslot = (uint32_t)dev.slot;
    uint32_t lfunc = (uint32_t)dev.func;
    uint32_t lreg = (uint32_t)reg;
 
    uint32_t address = (uint32_t)((lbus << 16) | (lslot << 11) | (lfunc << 8) | (lreg << 2) | 0x80000000U);
 
    outl(0xCF8, address);
    return inl(0xCFC);
}
void pci_write(pci_addr dev, uint8_t reg, uint32_t data) {
    uint32_t lbus  = (uint32_t)dev.bus;
    uint32_t lslot = (uint32_t)dev.slot;
    uint32_t lfunc = (uint32_t)dev.func;
    uint32_t lreg = (uint32_t)reg;
 
    uint32_t address = (uint32_t)((lbus << 16) | (lslot << 11) | (lfunc << 8) | (lreg << 2) | 0x80000000U);
 
    outl(0xCF8, address);
    outl(0xCFC, data);
}

pci_device pci_create(pci_addr addr) {
    pci_device dev;
    dev.address = addr;
    *(uint32_t*)&dev.vendor_id = pci_read(addr, 0);
    *(uint32_t*)&dev.rev_id = pci_read(addr, 2);
    *(uint32_t*)&dev.cache_line_size = pci_read(addr, 3);
    for (int i = 0; i < 6; i++) dev.bars[i] = pci_read(addr, 4 + i);
    *(uint32_t*)&dev.subsystem_vendor = pci_read(addr, 11);
    *(uint16_t*)&dev.interrupt_line = (uint16_t)pci_read(addr, 15);
    return dev;
}

void pci_init() {
    pci_dev = (pci_devices*)walloc(sizeof(pci_devices), 0x10);
    int device_idx = 0;
    
    for (uint16_t bus = 0; bus < 256; bus++) {
        for (uint8_t slot = 0; slot < 32; slot++) {
            pci_addr addr = {(uint8_t)bus, slot, 0};
            uint32_t reg0 = pci_read(addr, 0);
            if (reg0 == 0xffffffff) continue;
            pci_dev->devices[device_idx++] = pci_create(addr);
            if (!(pci_dev->devices[device_idx - 1].header_type & 0x80)) continue;
            for (uint8_t func = 1; func < 7; func++) {
                pci_addr addr2 = {(uint8_t)bus, slot, func};
                uint32_t reg1 = pci_read(addr2, 0);
                if (reg1 == 0xffffffff) continue;
                pci_dev->devices[device_idx++] = pci_create(addr2);
            }
        }
    }

    pci_dev->numDevs = device_idx;
}

void pci_print() {
    for (int i = 0; i < pci_dev->numDevs; i++) {
        printf("(%i:%i:%i) dev:%04x vendor:%04x class %02x:%02x:%02x:%02x\r\n", 
            pci_dev->devices[i].address.bus, pci_dev->devices[i].address.slot, pci_dev->devices[i].address.func,
            pci_dev->devices[i].device_id, pci_dev->devices[i].vendor_id,
            pci_dev->devices[i].class_id, pci_dev->devices[i].subclass, pci_dev->devices[i].prog_if, pci_dev->devices[i].rev_id
        );
    }
}

pci_device* pci_match(uint8_t class_id, uint8_t subclass, uint8_t prog_if) {
    for (int i = 0; i < pci_dev->numDevs; i++) {
        bool passed = pci_dev->devices[i].class_id == class_id;
        if (subclass < 255) passed &= pci_dev->devices[i].subclass == subclass;
        if (prog_if < 255) passed &= pci_dev->devices[i].prog_if == prog_if;
        if (passed) return &pci_dev->devices[i];
    }
    return NULL;
}
