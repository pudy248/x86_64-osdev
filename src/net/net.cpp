#include <cstdint>
#include <drivers/e1000.hpp>
#include <drivers/pci.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/arp.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <stl/vector.hpp>
#include <sys/ktime.hpp>

mac_t global_mac;
ipv4_t global_ip;

static vector<ethernet_packet> packet_queue_front;
static vector<ethernet_packet> packet_queue_back;

void net_init() {
	pci_device* e1000_pci = pci_match(PCI_CLASS::NETWORK, PCI_SUBCLASS::NETWORK_ETHERNET);
	if (!e1000_pci) {
		print("Failed to locate Ethernet controller!\n");
		pci_print();
		inf_wait();
	}
	qprintf<50>("Detected Ethernet device: %04x:%04x\n", e1000_pci->vendor_id,
				e1000_pci->device_id);
	e1000_init(*e1000_pci, &ethernet_recieve, &ethernet_link);
	global_mac = new_mac(e1000_dev->mac);
	e1000_enable();
}

void ethernet_link() {
	arp_announce(new_ipv4(192, 168, 1, 69));
	arp_announce(new_ipv4(169, 254, 1, 69));
	print("ARP init completed.\n");
}

net_buffer_t ethernet_new(std::size_t data_size) {
	uint8_t* buf = (uint8_t*)kmalloc(data_size + sizeof(ethernet_header));
	return { buf, buf + sizeof(ethernet_header), data_size };
}

void ethernet_recieve(net_buffer_t buf) {
	ethernet_header* frame = (ethernet_header*)buf.data_begin;

	uint16_t size = buf.data_size - sizeof(ethernet_header);
	uint8_t* contents = buf.frame_begin + sizeof(ethernet_header);
	ethernet_packet packet = {
		timepoint(), 0, 0, htons(frame->type), { buf.frame_begin, contents, size }
	};
	memcpy(&packet.src, &frame->src, 6);
	memcpy(&packet.dst, &frame->dst, 6);

	packet_queue_back.append(packet);
}

net_async_t ethernet_send(ethernet_packet packet) {
	ethernet_header* frame = (ethernet_header*)(packet.buf.data_begin - sizeof(ethernet_header));
	memcpy(&frame->dst, &packet.dst, 6);
	memcpy(&frame->src, &packet.src, 6);
	frame->type = htons(packet.type);

	return e1000_send_async({ packet.buf.frame_begin, packet.buf.frame_begin,
							  packet.buf.data_size + sizeof(ethernet_header) });
}

void net_process() {
	disable_interrupts();
	//e1000_pause();
	for (ethernet_packet& p : packet_queue_back) { packet_queue_front.append(p); }
	packet_queue_back.clear();
	enable_interrupts();
	//e1000_resume();

	for (ethernet_packet p : packet_queue_front) {
		switch (p.type) {
		case ETHERTYPE::ARP: arp_receive(p); break;
		case ETHERTYPE::IPv4: ipv4_receive(p); break;
		default: kfree(p.buf.frame_begin); break;
		}
	}
	packet_queue_front.clear();
}