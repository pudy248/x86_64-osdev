#pragma once
#include <inttypes.h>

typedef struct {
    uint16_t src_port;
    uint16_t dst_port;
    uint16_t length;
    uint16_t checksum;
} __attribute__((packed)) udp_header;

void udp_receive(etherframe_t frame, ip_header ip, void* buf, uint16_t size);
void* udp_create(uint16_t src, uint16_t dst, uint16_t len);
void udp_send(void* buf, uint16_t size);
