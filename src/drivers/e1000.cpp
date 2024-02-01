#include "drivers/pci.h"
#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kprint.h>
#include <sys/idt.h>
#include <sys/paging.h>
#include <drivers/e1000.h>

e1000_handle* e1000_dev;
static void(*receive_fn)(void* packet, uint16_t len);
static void(*link_fn)(void);

static void e1000_write(uint16_t addr, uint32_t val) {
    ((volatile uint32_t*)e1000_dev->mmio_base)[addr >> 2] = val;
}
static uint32_t e1000_read(uint16_t addr) {
    return ((volatile uint32_t*)e1000_dev->mmio_base)[addr >> 2];
}
static uint16_t e1000_read_eeprom(uint8_t addr) {
    uint32_t tmp;
    tmp = (uint32_t)addr << 8;
    tmp |= 1;
    e1000_write(E1000_REG::EERD, tmp);
    for (int i = 0; 1; i++) {
        outb(0x80, 0);
        tmp = e1000_read(E1000_REG::EERD);
        if (tmp & 0x10) break;
        if (i > 1000) {
            printf("EEPROM Read Error: %08x %08x\r\n", e1000_read(E1000_REG::EECD), e1000_read(E1000_REG::EERD));
            inf_wait();
        }
    }
    return tmp >> 16;
}

static void e1000_link() {
    e1000_write(E1000_REG::CTRL, e1000_read(E1000_REG::CTRL) | 0x40);
    link_fn();
}

void e1000_init(pci_device e1000_pci, void(*receive_callback)(void* packet, uint16_t len), void(*link_callback)(void)) {
    e1000_dev = waterline_new<e1000_handle>(0x10);
    e1000_dev->rx_descs = (e1000_rx_desc*)walloc(sizeof(e1000_rx_desc) * E1000_NUM_RX_DESC, 0x80);
    e1000_dev->tx_descs = (e1000_tx_desc*)walloc(sizeof(e1000_tx_desc) * E1000_NUM_TX_DESC, 0x80);

    receive_fn = receive_callback;
    link_fn = link_callback;
    e1000_dev->mmio_base = (uint64_t)(e1000_pci.bars[0] & 0xfffffff0);
    e1000_dev->pio_base = (uint16_t)(e1000_pci.bars[1] & 0xfffffffe);

    set_page_flags((void*)e1000_dev->mmio_base, PAGE_WT);
    pci_enable_mem(e1000_pci.address);
    //printf("Using Ethernet MMIO at %08x\r\n", e1000_pci.bars[0]);    

    //Clear and disable interrupts
    e1000_write(E1000_REG::IMC, 0xFFFFFFFF);
    e1000_read(E1000_REG::ICR);

    //Global reset
    e1000_write(E1000_REG::CTRL, e1000_read(E1000_REG::CTRL)& ~0x04000000);
    outb(0x80, 0);
    //e1000_write(E1000_REG::CTRL, e1000_read(E1000_REG::CTRL) & ~0xC0000088);

    //Detect eeprom
    e1000_dev->eeprom = 0;
    e1000_write(E1000_REG::EERD, 0x1);
    for (int i = 0; i < 1000; i++) {
        outb(0x80, 0);
        if (e1000_read(E1000_REG::EERD) & 0x10) {
            e1000_dev->eeprom = 1;
            break;
        }
    }

    //Read MAC
    if (e1000_dev->eeprom) {
        //print("Device has EEPROM\r\n");
        e1000_write(E1000_REG::EECD, 0xB);
        uint16_t v;
        v = e1000_read_eeprom(0);
        e1000_dev->mac[0] = v & 0xff;
        e1000_dev->mac[1] = v >> 8;
        v = e1000_read_eeprom(1);
        e1000_dev->mac[2] = v & 0xff;
        e1000_dev->mac[3] = v >> 8;
        v = e1000_read_eeprom(2);
        e1000_dev->mac[4] = v & 0xff;
        e1000_dev->mac[5] = v >> 8;
    }
    else {
        //print("Device no has EEPROM\r\n");
        uint32_t* mac = (uint32_t*)(e1000_dev->mmio_base + 0x5400);
        uint32_t v = mac[0];
        e1000_dev->mac[0] = v & 0xff;
        e1000_dev->mac[1] = v >> 8;
        e1000_dev->mac[2] = v >> 16;
        e1000_dev->mac[3] = v >> 24;
        v = mac[1];
        e1000_dev->mac[4] = v & 0xff;
        e1000_dev->mac[5] = v >> 8;
    }

    printf("Found MAC address: %02x:%02x:%02x:%02x:%02x:%02x\r\n", 
        e1000_dev->mac[0], e1000_dev->mac[1], e1000_dev->mac[2], e1000_dev->mac[3], e1000_dev->mac[4], e1000_dev->mac[5]);

    
    for (int i = 0; i < 0x80; i++)
        e1000_write(0x5200 + i * 4, 0);
    
    //Initialize RX
    for (int i = 0; i < E1000_NUM_RX_DESC; i++) {
        e1000_dev->rx_descs[i].addr = (volatile uint64_t)walloc(E1000_BUFSIZE, 0x10);
        e1000_dev->rx_descs[i].status = 0;
    }
    e1000_write(E1000_REG::RXDESCLO, (uint64_t)e1000_dev->rx_descs);
    e1000_write(E1000_REG::RXDESCHI, 0);
    e1000_write(E1000_REG::RXDESCSZ, E1000_NUM_RX_DESC * 16);
    e1000_write(E1000_REG::RXDCTL, 1 | (1 << 8) | (1 << 16) | (1 << 24));
    e1000_write(E1000_REG::RDTR, 0);
    e1000_write(E1000_REG::RXDESCHD, 0);
    e1000_write(E1000_REG::RXDESCTL, E1000_NUM_RX_DESC);
    e1000_dev->rx_cur = 0;
    e1000_write(E1000_REG::RCTRL, E1000_RCTL::EN | E1000_RCTL::SBP | E1000_RCTL::UPE | E1000_RCTL::MPE | E1000_RCTL::RDMTS_H | E1000_RCTL::BAM | E1000_RCTL::SECRC | E1000_BUFSIZE_FLAGS);

    //Initialize TX
    for (int i = 0; i < E1000_NUM_TX_DESC; i++) {
        e1000_dev->tx_descs[i].addr = (volatile uint64_t)walloc(E1000_BUFSIZE, 0x10);
        e1000_dev->tx_descs[i].cmd = 0;
        e1000_dev->tx_descs[i].status = E1000_TSTA::DD;
    }
    e1000_write(E1000_REG::TXDESCLO, (uint64_t)e1000_dev->tx_descs);
    e1000_write(E1000_REG::TXDESCHI, 0);
    e1000_write(E1000_REG::TXDESCSZ, E1000_NUM_TX_DESC * 16);
    e1000_write(E1000_REG::TXDESCHD, 0);
    e1000_write(E1000_REG::TXDESCTL, 0);
    e1000_dev->tx_cur = 0;
    e1000_write(E1000_REG::TCTRL,  E1000_TCTL::EN | E1000_TCTL::PSP | (15 << E1000_TCTL::CTSHIFT) | (64 << E1000_TCTL::CTCSHIFT) | E1000_TCTL::RTLC);
    if (e1000_pci.device_id != 0x100E)
        e1000_write(E1000_REG::TCTRL, 0b0110000000000111111000011111010);
    e1000_write(E1000_REG::TIPG, 0x0060200A);

    //Enable interrupts
    //pci_write_register(e1000_pci.address, 15, 5);
    //e1000_pci.interrupt_line = 5;

    //printf("Using interrupt line %i\r\n", e1000_pci.interrupt_line);
    irq_set(e1000_pci.interrupt_line, &e1000_int_handler);
    outb(0x21, 0x2);
    outb(0xA1, 0x80);
    //e1000_write(E1000_REG::ITR, 0);
    print("e1000e network card initialized.\r\n\n");
}

void e1000_enable() {
    e1000_write(E1000_REG::IMS, 0xFF & ~4);
}

void e1000_int_handler() {
    e1000_write(E1000_REG::IMS, 0x1);
    uint32_t status = e1000_read(E1000_REG::ICR);
    //printf("%02x\r\n", status);
    if(status & 0x02) {

    }
    if(status & 0x04)
        e1000_link();
    if(status & 0x40) {
        print("RXO\r\n");
        printf("  RCTRL %08x\r\n", e1000_read(E1000_REG::RCTRL));
        printf("  RXDH %i RXDT %i\r\n", e1000_read(E1000_REG::RXDESCHD), e1000_read(E1000_REG::RXDESCTL));
        printf("  RX0 ADDR %08x STATUS %02x\r\n", e1000_dev->rx_descs->addr, e1000_dev->rx_descs->status);
    }
    if(status & 0x80)
        e1000_receive();
}
 
void e1000_receive() {
    int tail = e1000_read(E1000_REG::RXDESCTL);
    int head = e1000_read(E1000_REG::RXDESCHD);
    if (head < tail) head += E1000_NUM_RX_DESC;
    //printf("%02i:%02i\r\n", tail, head);
    uint16_t old_cur = tail;
    //double t1 = timepoint().unix_seconds();
    while (e1000_dev->rx_descs[e1000_dev->rx_cur].status & 0x1) {
        //printf("Reading %i\r\n", e1000_dev->rx_cur);
        uint8_t *buf = (uint8_t *)e1000_dev->rx_descs[e1000_dev->rx_cur].addr;
        uint16_t len = e1000_dev->rx_descs[e1000_dev->rx_cur].length;
        receive_fn(buf, len);
        //double t2 = timepoint().unix_seconds();
        //printf("Done reading %i in %fms\r\n", e1000_dev->rx_cur, (t2 - t1) * 1000);
        //t1 = t2;
        e1000_dev->rx_descs[e1000_dev->rx_cur].status = 0;
        old_cur = e1000_dev->rx_cur;
        e1000_dev->rx_cur = (e1000_dev->rx_cur + 1) % E1000_NUM_RX_DESC;
    }
    e1000_write(E1000_REG::RXDESCTL, old_cur);
}

int e1000_send_async(void* data, uint16_t len) {
    while (~e1000_dev->tx_descs[e1000_dev->tx_cur].status & 1) asmv("nop");
    memcpy((void*)e1000_dev->tx_descs[e1000_dev->tx_cur].addr, data, len);
    e1000_dev->tx_descs[e1000_dev->tx_cur].length = len;
    e1000_dev->tx_descs[e1000_dev->tx_cur].cmd = E1000_TCMD::EOP | E1000_TCMD::IFCS | E1000_TCMD::RS;
    e1000_dev->tx_descs[e1000_dev->tx_cur].status = 0;
    uint8_t handle = e1000_dev->tx_cur;
    e1000_dev->tx_cur = (e1000_dev->tx_cur + 1) % E1000_NUM_TX_DESC;
    e1000_write(E1000_REG::TXDESCTL, e1000_dev->tx_cur);   
    //e1000_await(handle);
    return handle;
}

void net_await(int handle) {
    while(~e1000_dev->tx_descs[handle].status & 1) asmv("nop");
}
