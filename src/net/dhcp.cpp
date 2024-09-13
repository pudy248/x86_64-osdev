#include <cstdint>
#include <kstddefs.hpp>
#include <kstdlib.hpp>
#include <net/net.hpp>
#include <net/udp.hpp>
#include <net/dhcp.hpp>
#include <stl/view.hpp>
#include <kstring.hpp>

ipv4_t dhcp_server;
ipv4_t dns_server;
ipv4_t subnet_mask;

constexpr static uint32_t COOKIE = 0x63538263;
constexpr const char* HOSTNAME = "KATEOS_DESKTOP";
constexpr const char* VENDOR = "KATEOS";

void dhcp_discover(udp_conn_t conn, uint32_t xid) {
    net_buffer_t buf = udp_new(sizeof(dhcp_header) + 64);
    dhcp_header* dhcp = (dhcp_header*)buf.data_begin;
    dhcp->op = 1;
    dhcp->htype = HTYPE::ETH;
    dhcp->hlen = 6;
    dhcp->hops = 0;
    dhcp->xid = xid;
    dhcp->secs = 0;
    dhcp->flags = htons(0x8000);
    dhcp->ciaddr = 0;
    dhcp->yiaddr = 0;
    dhcp->siaddr = 0;
    dhcp->giaddr = 0;
    memcpy<1>(dhcp->chaddr, &global_mac, 6);
    bzero<1>(dhcp->padding, sizeof(dhcp->padding));
    dhcp->cookie = COOKIE;
    
    std::size_t offset = 0;
    uint8_t* opts = (uint8_t*)(dhcp + 1);
    write_tlv<uint8_t, false>({DHCP_OPT::MESSAGE_TYPE, span<const uint8_t>({DHCP_MTYPE::DISCOVER})}, opts, offset);
    write_tlv<uint8_t, false>({DHCP_OPT::CLIENT_IDENT, {HTYPE::ETH, 0, 0, 0, 0, 0, 0}}, opts, offset);
    write_bufoff(&global_mac, 6, opts, offset -= 6);
    write_tlv<uint8_t, false>({DHCP_OPT::HOST_NAME, rostring(HOSTNAME).reinterpret_as<uint8_t>()}, opts, offset);
    write_tlv<uint8_t, false>({DHCP_OPT::VENDOR_IDENT, rostring(VENDOR).reinterpret_as<uint8_t>()}, opts, offset);

    span<const uint8_t> prl = {
        DHCP_OPT::SUBNET,
        DHCP_OPT::ROUTER,
        DHCP_OPT::NTP_SERVER,
        DHCP_OPT::DHCP_SERVER,
        DHCP_OPT::DNS_SERVER,
        DHCP_OPT::BROADCAST_ADDR,
    };
    write_tlv<uint8_t, false>({DHCP_OPT::PRL, prl}, opts, offset);
    opts[offset++] = DHCP_OPT::END;
    bzero<1>(opts + offset, 64 - offset);
    udp_send(conn, {0xffffffff, DHCP_SERVER_PORT, buf});
}
void dhcp_request(udp_conn_t conn, uint32_t xid);
void dhcp_ack(udp_conn_t conn, uint32_t xid);