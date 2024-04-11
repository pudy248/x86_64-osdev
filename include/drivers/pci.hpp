#pragma once
#include <cstdint>

namespace PCI_CLASS { enum PCI_CLASS {
    UNCLASSIFIED,
    STORAGE,
    NETWORK,
    DISPLAY,
    MULTIMEDIA,
    MEMORY,
    BRIDGE,
    SIMPLE_COMM,
    PERIPHERAL,
    INPUT,
    DOCKING_STATION,
    PROCESSOR,
    SERIAL,
    WIRELESS,
};}
namespace PCI_SUBCLASS { enum PCI_SUBCLASS {
    STORAGE_SCSI=0,
    STORAGE_IDE,
    STORAGE_FLOPPY,
    STORAGE_IPI,
    STORAGE_RAID,
    STORAGE_ATA,
    STORAGE_SATA,
    STORAGE_SERIAL_SCSI,
    STORAGE_NVM,

    NETWORK_ETHERNET=0,
    
    DISPLAY_VGA=0,
    DISPLAY_XGA,
    DISPLAY_3D,

    BRIDGE_HOST=0,
    BRIDGE_ISA,
    BRIDGE_EISA,
    BRIDGE_MCA,
    BRIDGE_PCI,
    BRIDGE_PCIMCIA,
    BRIDGE_NUBUS,
    BRIDGE_CARDBUS,
    BRIDGE_RACEWAY,
    BRIDGE_PCI2,

    SIMPLE_COMM_SERIAL=0,
    SIMPLE_COMM_PARALLEL,
    SIMPLE_COMM_MULTIPORT,
    SIMPLE_COMM_MODEM,

    PERIPHERAL_PIC=0,
    PERIPERHAL_DMA,
    PERIPHERAL_TIMER,
    PERIPERHAL_RTC,

    SERIAL_FIREWIRE=0,
    SERIAL_ACCESSBUS,
    SERIAL_SSA,
    SERIAL_USB,
    SERIAL_FIBRE,
    SERIAL_SMBUS,
};}

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

uint32_t pci_read(pci_addr dev, uint8_t reg);
void pci_write(pci_addr dev, uint8_t reg, uint32_t data);
void pci_enable_mem(pci_addr dev);
pci_device pci_create(pci_addr addr);
void pci_init(void);
void pci_print(void);

pci_device* pci_match_id(uint16_t vendor_id, uint16_t device_id);
pci_device* pci_match(uint8_t class_id, uint8_t subclass = 255, uint8_t prog_if = 255);
