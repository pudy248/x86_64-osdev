#include <asm.hpp>
#include <cstddef>
#include <cstdint>
#include <drivers/e1000.hpp>
#include <drivers/pci.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/arp.hpp>
#include <net/config.hpp>
#include <net/dhcp.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <stl/queue.hpp>
#include <stl/stream.hpp>
#include <sys/global.hpp>
#include <sys/ktime.hpp>
#include <text/text_display.hpp>

mac_union global_mac;
ipv4_t global_ip;

bool eth_connected;

static queue<eth_packet> packet_queue_front;
static queue<eth_packet> packet_queue_back;

void net_init() {
	pci_device* e1000_pci = pci_match(PCI_CLASS::NETWORK, PCI_SUBCLASS::NETWORK_ETHERNET);
	if (!e1000_pci) {
		print("Failed to locate Ethernet controller!\n");
		pci_print();
		inf_wait();
	}
	qprintf<64>("Detected Ethernet device: %04x:%04x\n", e1000_pci->vendor_id, e1000_pci->device_id);
	e1000_init(*e1000_pci, &ethernet_recieve, &ethernet_link);
	global_mac.as_int = globals->e1000->mac;
	e1000_enable();
	//if (e1000_pci->device_id == 0x100E)
	ethernet_link();
	//else
	//	while (!eth_connected)
	//		cpu_relax();
}

void ethernet_link() {
	print("Link status changed.\n");
	eth_connected = true;
}

void net_update_ip(ipv4_t ip) {
	global_ip = ip;
	arp_update(global_mac.as_int, global_ip);
}

void ethernet_recieve(net_buffer_t buf) {
	eth_packet p = eth_read(buf);
	if (!PROMISCUOUS && p.i.dst_mac != global_mac.as_int && p.i.dst_mac != MAC_BCAST)
		return;
	if (PACKET_LOG)
		qprintf<64>("R %M -> %M (%i bytes)\n", p.i.src_mac, p.i.dst_mac, buf.data_size);
	if (PACKET_HEXDUMP)
		hexdump(buf.data_begin, buf.data_size);
	packet_queue_back.enqueue(p);
}

static void net_touch() {
	disable_interrupts();
	//e1000_pause();
	while (packet_queue_back.size())
		packet_queue_front.enqueue(packet_queue_back.dequeue());
	enable_interrupts();
	//e1000_resume();

	if (DHCP_AUTORENEW && active_lease.duration.rep &&
		active_lease.established + active_lease.duration < timepoint::now()) {
		active_lease.duration.rep = 0;
		dhcp_set_active(dhcp_query(active_lease.yiaddr));
	}
}

optional<eth_packet> eth_get() {
	net_touch();
	if (packet_queue_front.size())
		return packet_queue_front.dequeue();
	return {};
}

eth_packet eth_read(net_buffer_t raw) {
	eth_packet packet(raw);
	packet.i.timestamp = timepoint::now();
	packet.i.dst_mac = packet.b.read<mac_t>();
	packet.i.src_mac = packet.b.read<mac_t>();
	packet.i.ethertype = packet.b.read<ETHERTYPE>();
	return packet;
}

net_buffer_t eth_new(std::size_t data_size) {
	pointer<std::byte, type_cast> buf = kcalloc(data_size + 14);
	return {buf, buf + 14, data_size};
}

net_buffer_t eth_write(eth_packet p) {
	p.b.write(p.i.ethertype);
	p.b.write(p.i.src_mac);
	p.b.write(p.i.dst_mac);

	if (PACKET_LOG)
		qprintf<64>("S %M -> %M (%i bytes)\n", p.i.src_mac, p.i.dst_mac, p.b.data_size + 14);

	return p.b;
}
net_async_t eth_send(eth_packet packet) { return net_send(eth_write(packet)); }
net_async_t net_send(net_buffer_t packet) { return e1000_send_async(packet); }

void net_forward(eth_packet p) {
	switch (p.i.ethertype) {
	case ETHERTYPE::ARP: arp_process(p); break;
	case ETHERTYPE::IPv4:
		ipv4_forward(ipv4_read(p));
		break;
		//default: kfree(p.b.frame_begin); break;
	}
}

void net_fwdall() {
	net_touch();
	while (packet_queue_front.size())
		net_forward(packet_queue_front.dequeue());
}

uint64_t net_partial_checksum(const void* data, uint16_t len) {
	uint64_t sum = 0;
	uint16_t* buf = (uint16_t*)data;
	while (len > 1) {
		sum += *buf++;
		len -= 2;
	}
	if (len)
		sum += *buf & 0xff;
	return sum;
}
uint16_t net_checksum(uint64_t sum) {
	while (sum >> 16)
		sum = (sum & 0xffff) + (sum >> 16);
	sum = ~sum;
	return sum;
}
uint16_t net_checksum(const void* data, uint16_t len) { return net_checksum(net_partial_checksum(data, len)); }

template <typename T, typename SZ, bool FL>
tlv_option_t<T, SZ, FL> read_tlv(ibinstream<>& s) {
	tlv_option_t<T, SZ, FL> opt;
	opt.opt = s.read_raw<T>();
	SZ len = s.read_raw<SZ>();
	opt.value = s.reference_read(len - FL * (sizeof(T) + sizeof(SZ)));
	return opt;
}
template <typename T, typename SZ, bool FL>
void write_tlv(const tlv_option_t<T, SZ, FL>& opt, obinstream<>& s) {
	s.write_raw<T>(opt.opt);
	s.write_raw<SZ>(opt.value.size() + FL * (sizeof(T) + sizeof(SZ)));
	s.write(opt.value);
}