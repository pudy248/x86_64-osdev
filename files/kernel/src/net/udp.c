#include <inttypes.h>
#include <sys/kstdio.h>
#include <net/net.h>
#include <net/ipv4.h>
#include <net/udp.h>

void udp_receive(etherframe_t frame, ip_header ip, void* buf, uint16_t size) {
    return;
    udp_header* udp = (udp_header*)buf;
    printf("[UDP] Port %i -> %i\r\n", udp->src_port, udp->dst_port);
    void* data = buf + sizeof(udp_header);
    uint16_t dataSize = size - sizeof(udp_header);

    printf("[UDP] Body (%i bytes)\r\n", dataSize);
    hexdump(data, dataSize);    
    printf("\r\n");
}
void* udp_create(uint16_t src, uint16_t dst, uint16_t len);
void udp_send(void* buf, uint16_t size);
