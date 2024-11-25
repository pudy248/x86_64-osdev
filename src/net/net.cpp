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
#include <stl/vector.hpp>
#include <sys/global.hpp>
#include <sys/ktime.hpp>
#include <text/text_display.hpp>

mac_t global_mac;
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
	global_mac = globals->e1000->mac;
	e1000_enable();
	if (e1000_pci->device_id == 0x100E)
		ethernet_link();
	else
		while (!eth_connected)
			cpu_relax();
}

void ethernet_link() {
	print("Link status changed.\n");
	eth_connected = true;
}

void net_update_ip(ipv4_t ip) {
	global_ip = ip;
	arp_update(global_mac, global_ip);
}

void ethernet_recieve(net_buffer_t buf) {
	eth_packet p = eth_process(buf);
	if (!PROMISCUOUS && p.i.dst_mac != global_mac && p.i.dst_mac != MAC_BCAST)
		return;
	if (PACKET_LOG)
		qprintf<64>("R %M -> %M (%i bytes)\n", p.i.src_mac, p.i.dst_mac, buf.data_size);
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

bool eth_get(eth_packet& out) {
	net_touch();
	if (packet_queue_front.size()) {
		out = packet_queue_front.dequeue();
		return true;
	}
	return false;
}

eth_packet eth_process(net_buffer_t raw) {
	ethernet_header* frame = raw.data_begin;
	mac_t src, dst;
	memcpy(&src, &frame->src, 6);
	memcpy(&dst, &frame->dst, 6);

	pointer<std::byte, type_cast> newBuf = kmalloc(raw.data_size);
	memcpy(newBuf, raw.frame_begin, raw.data_size);
	uint16_t size = raw.data_size - sizeof(ethernet_header);
	pointer<std::byte, type_cast> contents = newBuf + sizeof(ethernet_header);
	eth_packet packet = { { timepoint::now(), src, dst, htons(frame->ethertype) }, { newBuf, contents, size } };
	return packet;
}

net_buffer_t eth_new(std::size_t data_size) {
	pointer<std::byte, type_cast> buf = kcalloc(data_size + sizeof(ethernet_header));
	return { buf, buf + sizeof(ethernet_header), data_size };
}

net_async_t eth_send(eth_packet p) {
	ethernet_header* frame = (ethernet_header*)(p.b.data_begin - sizeof(ethernet_header));
	memcpy(&frame->dst, &p.i.dst_mac, 6);
	memcpy(&frame->src, &p.i.src_mac, 6);
	frame->ethertype = htons(p.i.ethertype);

	if (PACKET_LOG)
		qprintf<64>("S %M -> %M (%i bytes)\n", p.i.src_mac, p.i.dst_mac, p.b.data_size + sizeof(ethernet_header));

	return e1000_send_async({ p.b.frame_begin, p.b.frame_begin, p.b.data_size + sizeof(ethernet_header) });
}

void net_forward(eth_packet p) {
	switch (p.i.ethertype) {
	case ETHERTYPE::ARP: arp_process(p); break;
	case ETHERTYPE::IPv4: ipv4_forward(ipv4_process(p)); break;
	default: kfree(p.b.frame_begin); break;
	}
}

void net_fwdall() {
	net_touch();
	while (packet_queue_front.size()) {
		net_forward(packet_queue_front.dequeue());
	}
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
	while (sum >> 16) {
		sum = (sum & 0xffff) + (sum >> 16);
	}
	sum = ~sum;
	return sum;
}
uint16_t net_checksum(const void* data, uint16_t len) { return net_checksum(net_partial_checksum(data, len)); }

template <typename T, bool FL>
tlv_option_t<T, FL> read_tlv(ibinstream<>& s) {
	tlv_option_t<T, FL> opt;
	opt.opt = s.read_b<T>();
	T len = s.read_b<T>();
	opt.value = s.read_n(len - FL * 2 * sizeof(T));
	return opt;
}
template <typename T, bool FL>
void write_tlv(tlv_option_t<T, FL> opt, obinstream<>& s) {
	s.write_b<T>(opt.opt);
	s.write_b<T>(opt.value.size() + FL * 2 * sizeof(T));
	s.write(opt.value);
}