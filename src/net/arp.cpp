#include <cstdint>
#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kstdio.hpp>
#include <net/net.hpp>
#include <net/arp.hpp>
#include <stl/vector.hpp>

constexpr mac_t MAC_BCAST = 0xffffffffffffULL;

vector<arp_entry> arp_table;

void arp_update(mac_t mac, ipv4_t ip) {
    for (int i = 0; i < arp_table.size(); i++) {
        //if (mac == arp_table[i].mac) {
        //    arp_table[i].ip = ip;
        //    return;
        //}
        if (ip == arp_table[i].ip) {
            arp_table[i].mac = mac;
            return;
        }
    }
    arp_table.append({mac, ip});
}

ipv4_t arp_translate_mac(mac_t mac) {
    for (int i = 0; i < arp_table.size(); i++) {
        if (mac == arp_table[i].mac)
            return arp_table[i].ip;
    }
    return 0;
}
mac_t arp_translate_ip(ipv4_t ip) {
    for (int i = 0; i < arp_table.size(); i++) {
        if (ip == arp_table[i].ip)
            return arp_table[i].mac;
    }
    return 0;
}

void arp_process(ethernet_packet packet) {
    arp_header<ipv4_t>* h = (arp_header<ipv4_t>*)packet.contents.begin();
    ipv4_t selfIP, targetIP;
    mac_t selfMac, targetMac;
    selfMac = targetMac = 0;

    memcpy(&selfIP, &h->selfIP, 4);
    memcpy(&targetIP, &h->targetIP, 4);
    memcpy(&selfMac, &h->selfMac, 6);
    memcpy(&targetMac, &h->targetMac, 6);
    char sMac = !!selfMac;
    char sIp  = !!selfIP;
    char tMac = !!targetMac;
    char tIp  = !!targetIP;

    if(sMac && sIp)
        arp_update(selfMac, selfIP);

    switch ((sMac << 0) | (sIp << 1) | (tMac << 2) | (tIp << 3) | (htons(h->op) << 4)) {
        case 0x19: //Probe
            printf("[ARP] %M wants to know: Is %I available?\n", selfMac, targetIP);
            if (targetIP == global_ip) {
                printf("[ARP] No, %I belongs to %M.\n", global_ip, global_mac);   
                arp_send(2, arp_entry(global_mac, global_ip), arp_entry(selfMac, selfIP));
            }
            break;
        case 0x1B:
            if (selfIP != targetIP) {  //Request
                printf("[ARP] %I wants to know: Who is %I?\n", selfIP, targetIP);
                if (targetIP == new_ipv4(10,0,2,15))
                    global_ip = targetIP;
                
                if (targetIP == global_ip) {
                    printf("[ARP] Responding to %I: %I is %M.\n", selfIP, global_ip, global_mac);
                    arp_send(2, arp_entry(global_mac, global_ip), arp_entry(selfMac, selfIP));
                }
            } else { //Gratuitous announcement
                printf("[ARP] Announcement: %I belongs to %M.\n", selfIP, selfMac);
            }
            break;
        case 0x1F:
            if (targetIP == global_ip) {
                printf("[ARP] Responding to %I: %I is %M.\n", selfIP, global_ip, global_mac);   
                arp_send(2, arp_entry(global_mac, global_ip), arp_entry(selfMac, selfIP));
            }
            break;
        default:
            printf("[ARP] Not sure what to do with %s. (%M %I) (%M %I)\n", htons(h->op) == 2 ? "reply" : "request", h->selfMac, h->selfIP, h->targetMac, h->targetIP);
            break;
    }
}

int arp_send(uint16_t op, arp_entry self, arp_entry target) {
    mac_t eth_dst;
    if (!target.mac)
        eth_dst = MAC_BCAST;
    else 
        eth_dst = target.mac;

    arp_header<ipv4_t>* h = new arp_header<ipv4_t>();
    h->htype = htons(ARP_HTYPE_ETH);
    h->ptype = htons(ARP_PTYPE_IPv4);
    h->hlen = 6;
    h->plen = 4;
    h->op = htons(op);
    memcpy(&h->selfIP, &self.ip, 4);
    memcpy(&h->targetIP, &target.ip, 4);
    memcpy(&h->selfMac, &self.mac, 6);
    memcpy(&h->targetMac, &eth_dst, 6);

    ethernet_packet packet;
    packet.dst = eth_dst;
    packet.src = self.mac;
    packet.type = ETHERTYPE_ARP;
    packet.contents = span<char>((char*)h, sizeof(arp_header<ipv4_t>));

    int handle = ethernet_send(packet);
    delete h;
    return handle;
}

void arp_announce(ipv4_t ip) {
    global_ip = ip;
    printf("[ARP] Announcement: %I belongs to %M.\n", global_ip, global_mac);
    arp_send(ARP_OP_REQUEST, arp_entry(global_mac, global_ip), arp_entry(0, global_ip));
}
