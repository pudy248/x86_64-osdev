#include "sys/ktime.hpp"
#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <net/net.hpp>
#include <net/arp.hpp>
#include <net/ipv4.hpp>
#include <net/tcp.hpp>
#include <drivers/pci.h>
#include <drivers/e1000.h>

mac_t global_mac;
ipv4_t global_ip;

void net_init() {
    pci_device* e1000_pci = pci_match(2, 0);
    if (!e1000_pci) {
        print("Failed to locate Ethernet controller!\r\n");
        pci_print();
        inf_wait();
    }
    printf("Detected Ethernet device: %04x:%04x\r\n", e1000_pci->vendor_id, e1000_pci->device_id);
    e1000_init(*e1000_pci, &ethernet_recieve, &ethernet_link);
    global_mac = new_mac(e1000_dev->mac);
    memset(&arp_table, 0, sizeof(vector<arp_entry>));
    memset(&open_connections, 0, sizeof(vector<tcp_connection*>));
    e1000_enable();
}

void ethernet_link() {
    arp_announce(new_ipv4(192,168,1,69));
    arp_announce(new_ipv4(169,254,1,69));
}

void ethernet_recieve(void* buf, uint16_t size) {
    etherframe_t* frame = (etherframe_t*)buf;
    
    uint16_t newSize = size - sizeof(etherframe_t);
    char* contents = (char*)((uint64_t)buf + sizeof(etherframe_t));
    
    ethernet_packet packet = {
        timepoint(), 0, 0, htons(frame->type), span<char>(contents, newSize)
    };
    memcpy(&packet.src, &frame->src, 6);
    memcpy(&packet.dst, &frame->dst, 6);

    switch(packet.type) {
        case ETHERTYPE_ARP:
            arp_process(packet);
            break;
        case ETHERTYPE_IPv4:
            ipv4_process(packet);
            break;
    }
}
void ethernet_send(ethernet_packet packet) {
    void* buf = malloc(packet.contents.size() + sizeof(etherframe_t));
    etherframe_t* frame = (etherframe_t*)buf;
    memcpy(&frame->dst, &packet.dst, 6);
    memcpy(&frame->src, &packet.src, 6);
    frame->type = htons(packet.type);

    memcpy((void*)((uint64_t)buf + sizeof(etherframe_t)), packet.contents.unsafe_arr(), packet.contents.size());
    e1000_send(buf, packet.contents.size() + sizeof(etherframe_t));
    free(buf);
}
