#include <cstdint>
#include <kstdlib.hpp>
#include <kstdio.hpp>
#include <stl/vector.hpp>
#include <net/net.hpp>
#include <net/arp.hpp>
#include <net/ipv4.hpp>
#include <net/tcp.hpp>

static void ip_checksum(ip_header* ip){
    ip->checksum = 0;
    uint64_t sum = 0;
    uint16_t ip_len = (ip->ver_ihl & 0xf)<<2;
    uint16_t* ip_payload = (uint16_t*)ip;
    while (ip_len > 1) {
        sum += * ip_payload++;
        ip_len -= 2;
    }
    while (sum>>16) {
        sum = (sum & 0xffff) + (sum >> 16);
    }
    sum = ~sum;
    ip->checksum = sum;
}

void ipv4_process(ethernet_packet packet) {
    ip_header* ip = (ip_header*)packet.contents.begin();

    void* contents = (void*)((uint64_t)packet.contents.begin() + sizeof(ip_header));
    uint16_t expected_size = htons(ip->total_length) - sizeof(ip_header);
    uint16_t actual_size = packet.contents.size() - sizeof(ip_header);

    if(expected_size > actual_size) {
        qprintf<100>("[IPv4] In packet from %I: Mismatch in ethernet and IP packet sizes! %i vs %i\n", ip->src_ip, expected_size, actual_size);
        return;
    }

    //printf("[IPv4] %I -> %I (%i/%i bytes)\n", ip->src_ip, ip->dst_ip, expected_size, actual_size);
    
    arp_update(packet.src, ip->src_ip);

    ip_packet new_packet = {
        packet, ip->protocol, ip->src_ip, ip->dst_ip, span<char>((char*)contents, expected_size)
    };

    switch (ip->protocol) {
        case IP_PROTOCOL_TCP:
            tcp_process(new_packet);
            break;
        //case IP_PROTOCOL_UDP:
        //    udp_receive(frame, *ip, data, dataSize);
        //    break;
    }
}

int ipv4_send(ip_packet packet) {
    void* buf = malloc(packet.contents.size() + sizeof(ip_header));
    ip_header* ip = (ip_header*)buf;
    ip->ver_ihl = 0x45;
    ip->dscp = 0;
    ip->total_length = htons(20 + packet.contents.size());
    ip->ident = 0x100;
    ip->frag_offset = 0;
    ip->ttl = 64;
    ip->protocol = packet.protocol;
    ip->checksum = 0;
    ip->src_ip = packet.src;
    ip->dst_ip = packet.dst;
    ip_checksum(ip);

    memcpy((void*)((uint64_t)buf + sizeof(ip_header)), packet.contents.begin(), packet.contents.size());
    ethernet_packet eth;
    eth.type = ETHERTYPE_IPv4;
    eth.src = global_mac;
    eth.dst = arp_translate_ip(packet.dst);
    eth.contents = span<char>((char*)buf, packet.contents.size() + sizeof(ip_header));

    int handle = ethernet_send(eth);
    free(buf);
    return handle;
}
