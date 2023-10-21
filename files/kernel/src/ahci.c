#include <pci.h>
#include <ahci.h>
#include <common.h>
#include <basic_console.h>

ahci_device ahci_init(pci_device ahci_pci) {
    hba_mem* ahci_mem = (hba_mem*)ahci_pci.bars[5];
    hba_port* ports = (hba_port*)(ahci_pci.bars[5] + 0x100);
    hba_cmd_header* cmd_list = (hba_cmd_header*)0x12000;
    fis_reg_h2d* fis = (void*)0x12800;
    hba_cmd_tbl* ctbas = (void*)0x13000;
    memset((char*)ctbas, 0, 0x12000);

    int port_idx = 0;
    for(int i = 0; i < 32; i++) {
        if(~ahci_mem->pi & (1 << i)) continue;
        if(ports[i].ssts) port_idx = i;
    }
    ports[port_idx].cmd &= 0xfffffffe;
    while(ports[port_idx].cmd & 0x8000);

    ports[port_idx].clb = (uint32_t)cmd_list;
    ports[port_idx].clbu = 0;
    ports[port_idx].fb = (uint32_t)fis;
    ports[port_idx].fbu = 0;
    
    for(uint32_t i = 0; i < 32; i++) {
        cmd_list[i].ctba = (uint32_t)ctbas + 0x100 * i;
        cmd_list[i].ctbau = 0;
        cmd_list[i].prdtl = 8;
    }
    while((ports[port_idx].cmd & 0x4000) != 0x4000);
    ports[port_idx].cmd |= 0x101;

    return (ahci_device){ahci_mem, &ports[port_idx], cmd_list, fis, ctbas};
}

void ahci_read(ahci_device dev, uint64_t LBA, uint32_t sectors, void* buffer) {
    dev.clb[0].cfl = sizeof(fis_reg_h2d) / 4;
    dev.clb[0].w = 0;
    dev.ctba[0].prdt_entry[0].dba = (uint32_t)buffer;
    dev.ctba[0].prdt_entry[0].dbau = 0;
    dev.ctba[0].prdt_entry[0].dbc = sectors * 512 - 1;
    dev.ctba[0].prdt_entry[0].i = 1;

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
    while(dev.port->tfd & 0x84);
    dev.port->ci = 1;
    while(dev.port->ci && (dev.port->is & 0x40000000) == 0);
    //if(dev.port->is & 0x40000000) console_printf("Disk read error!\r\n");
}

void ahci_write(ahci_device dev, uint64_t LBA, uint32_t sectors, void* buffer) {
    uint32_t slots = dev.port->sact | dev.port->ci;
    int slot;
    for(slot = 0; slot < 32; slot++) if(((slots >> slot) & 1) == 0) break;
    if(slot == 32) {
        //console_printf("No available command slots!\r\n");
        return;
    }

    dev.clb[slot].cfl = sizeof(fis_reg_h2d) / 4;
    dev.clb[slot].w = 1;
    dev.ctba[slot].prdt_entry[0].dba = (uint32_t)buffer;
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
    while(dev.port->tfd & 0x84);
    dev.port->ci = 1 << slot;
    while((dev.port->ci & (1 << slot)) && (dev.port->is & 0x40000000) == 0);
    //if(dev.port->is & 0x40000000) console_printf("Disk write error!\r\n");
}
