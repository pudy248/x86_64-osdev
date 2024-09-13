#include <asm.hpp>
#include <cstddef>
#include <cstdint>
#include <drivers/e1000.hpp>
#include <drivers/pci.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/arp.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <stl/vector.hpp>
#include <sys/global.hpp>
#include <sys/ktime.hpp>

mac_t global_mac;
ipv4_t global_ip;

volatile bool initialized;

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
	global_mac = globals->e1000->mac;
	e1000_enable();
}

void ethernet_link() {
	arp_announce(new_ipv4(192, 168, 1, 69));
	arp_announce(new_ipv4(169, 254, 1, 69));
	arp_announce(new_ipv4(172, 29, 244, 123));
	print("ARP init completed.\n");
	initialized = true;
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

	qprintf<64>("R %M -> %M (%i bytes)\n", packet.src, packet.dst, buf.data_size);

	packet_queue_back.append(packet);
}

net_async_t ethernet_send(ethernet_packet packet) {
	ethernet_header* frame = (ethernet_header*)(packet.buf.data_begin - sizeof(ethernet_header));
	memcpy(&frame->dst, &packet.dst, 6);
	memcpy(&frame->src, &packet.src, 6);
	frame->type = htons(packet.type);
	
	qprintf<64>("S %M -> %M (%i bytes)\n", packet.src, packet.dst, packet.buf.data_size + sizeof(ethernet_header));

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

uint64_t net_partial_checksum(void* data, uint16_t len) {
	uint64_t sum = 0;
	uint16_t* buf = (uint16_t*)data;
	while (len > 1) {
		sum += *buf++;
		len -= 2;
	}
	if (len) sum += *buf & 0xff;
	return sum;
}
uint16_t net_checksum(uint64_t sum) {
	while (sum >> 16) { sum = (sum & 0xffff) + (sum >> 16); }
	sum = ~sum;
	return sum;
}
uint16_t net_checksum(void* data, uint16_t len) {
	return net_checksum(net_partial_checksum(data, len));
}

void write_bufoff(void* obj, std::size_t sz, uint8_t* buf, std::size_t& off) {
	for(std::size_t i = 0; i < sz; i++)
		buf[off++] = ((uint8_t*)obj)[i];
}

template <typename T, bool FL> tlv_option_t<T, FL> read_tlv(uint8_t* buf, std::size_t& off) {
	tlv_option_t<T, FL> opt;
	opt.opt = *(T*)&buf[off += sizeof(T)];
	T len = *(T*)&buf[off += sizeof(T)];
	opt.value = span<uint8_t>(buf + off, buf + off + len - FL * 2 * sizeof(T));
	off += len - FL * 2 * sizeof(T);
	return opt;
}
template <typename T, bool FL> void write_tlv(tlv_option_t<T, FL> opt, uint8_t* buf, std::size_t& off) {
	*(T*)&buf[off += sizeof(T)] = opt.opt;
	*(T*)&buf[off += sizeof(T)] = opt.value.size() + FL * 2 * sizeof(T);
	for (uint8_t n : opt.value) buf[off++] = n;
}