#pragma once
#include <typedefs.h>

typedef struct pci_geo_addr {
    uint8_t bus;
    uint8_t slot;
    uint8_t func;
} pci_geo_addr;

typedef struct pci_device {
    pci_geo_addr address;

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

    uint16_t subsystem_vendor;
    uint16_t subsystem_id;

    uint8_t interrupt_line;
    uint8_t interrupt_pin;
} pci_device;

typedef struct pci_devices {
    int numDevs;
    pci_device* devices;
} pci_devices;

uint32_t pci_read_register(pci_geo_addr dev, uint8_t reg);
void pci_write_register(pci_geo_addr dev, uint8_t reg, uint32_t data);
pci_device pci_create_device(pci_geo_addr addr);
pci_devices pci_scan_devices();
