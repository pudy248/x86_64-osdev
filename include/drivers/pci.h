#pragma once
#include <kstddefs.h>

struct pci_addr {
    uint8_t bus;
    uint8_t slot;
    uint8_t func;
};

struct pci_device {
    pci_addr address;

    uint16_t vendor_id;
    uint16_t device_id;

    uint8_t rev_id;
    uint8_t prog_if;
    uint8_t subclass;
    uint8_t class_id;

    uint8_t cache_line_size;
    uint8_t latency;
    uint8_t header_type;
    uint8_t bist;

    uint32_t bars[6];

    //uint32_t Cardbus CIS Pointer

    uint16_t subsystem_vendor;
    uint16_t subsystem_id;

    uint8_t interrupt_line;
    uint8_t interrupt_pin;
};

struct pci_devices {
    pci_device devices[128];
    int numDevs;
};

extern pci_devices* pci_dev;

uint32_t pci_read(pci_addr dev, uint8_t reg);
void pci_write(pci_addr dev, uint8_t reg, uint32_t data);
pci_device pci_create(pci_addr addr);
void pci_init(void);
void pci_print(void);

pci_device* pci_match_id(uint16_t vendor_id, uint16_t device_id);
pci_device* pci_match(uint8_t class_id, uint8_t subclass = 255, uint8_t prog_if = 255);
