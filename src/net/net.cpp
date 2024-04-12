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
#include <utility>

mac_t global_mac;
ipv4_t global_ip;

static volatile vector<ethernet_packet> packet_queue_front;
static volatile vector<ethernet_packet> packet_queue_back;

void net_init() {
	pci_device* e1000_pci = pci_match(PCI_CLASS::NETWORK, PCI_SUBCLASS::NETWORK_ETHERNET);
	if (!e1000_pci) {
		print("Failed to locate Ethernet controller!\n");
		pci_print();
		inf_wait();
	}
	qprintf<50>("Detected Ethernet device: %04x:%04x\n", e1000_pci->vendor_id, e1000_pci->device_id);
	e1000_init(*e1000_pci, &ethernet_recieve, &ethernet_link);
	global_mac = new_mac(e1000_dev->mac);
	e1000_enable();
}

void ethernet_link() {
	arp_announce(new_ipv4(192, 168, 1, 69));
	arp_announce(new_ipv4(169, 254, 1, 69));
}

void ethernet_recieve(void* buf, uint16_t size) {
	etherframe_t* frame = (etherframe_t*)buf;

	uint16_t newSize  = size - sizeof(etherframe_t);
	char* contents	  = (char*)((uint64_t)buf + sizeof(etherframe_t));
	char* newContents = (char*)malloc(newSize);
	memcpy(newContents, contents, newSize);

	ethernet_packet packet = { timepoint(), 0, 0, htons(frame->type), span<char>(newContents, newSize) };
	memcpy(&packet.src, &frame->src, 6);
	memcpy(&packet.dst, &frame->dst, 6);

	((vector<ethernet_packet>&)packet_queue_back).append(packet);
}

void net_process() {
	if (packet_queue_front.size()) {
		for (ethernet_packet p : (vector<ethernet_packet>&)packet_queue_front) {
			switch (p.type) {
			case ETHERTYPE_ARP:
				arp_process(p);
				break;
			case ETHERTYPE_IPv4:
				ipv4_process(p);
				break;
			}
			free(p.contents.begin());
		}
		((vector<ethernet_packet>&)packet_queue_front).clear();
	}
	std::swap((vector<ethernet_packet>&)packet_queue_front, (vector<ethernet_packet>&)packet_queue_back);
}

int ethernet_send(ethernet_packet packet) {
	void* buf			= malloc(packet.contents.size() + sizeof(etherframe_t));
	etherframe_t* frame = (etherframe_t*)buf;
	memcpy(&frame->dst, &packet.dst, 6);
	memcpy(&frame->src, &packet.src, 6);
	frame->type = htons(packet.type);

	memcpy((void*)((uint64_t)buf + sizeof(etherframe_t)), packet.contents.begin(), packet.contents.size());
	int handle = e1000_send_async(buf, packet.contents.size() + sizeof(etherframe_t));
	free(buf);
	return handle;
}
