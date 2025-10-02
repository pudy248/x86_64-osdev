#include "e1000.hpp"
#include <asm.hpp>
#include <cstdint>
#include <drivers/pci.hpp>
#include <drivers/register.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/net.hpp>
#include <sys/global.hpp>
#include <sys/idt.hpp>
#include <sys/memory/paging.hpp>

static void (*receive_fn)(net_buffer_t);
static void (*link_fn)(void);
static void e1000_int_handler(uint64_t, register_file*);

constexpr bool copy_tx = true;

namespace E1000 {
void e1000_write(uint16_t addr, uint32_t val) { ((volatile uint32_t*)globals->e1000->mmio_base)[addr >> 2] = val; }
uint32_t e1000_read(uint16_t addr) { return ((volatile uint32_t*)globals->e1000->mmio_base)[addr >> 2]; }
static uint16_t e1000_read_eeprom(uint8_t addr) {
	EERD{} = EERD::ADDR(addr) | EERD::START;
	for (int i = 0; 1; i++) {
		io_wait();
		if (EERD{}.DONE_v)
			break;
		if (i > 1000) {
			qprintf<80>("EEPROM Read Error: %08x %08x\n", (uint32_t)EEC{}, (uint32_t)EERD{});
			inf_wait();
		}
	}
	return EERD{}.DATA_v;
}
}
using namespace E1000;

static void e1000_link() {
	CTRL{}.write(CTRL::SPEED, CTRL::S_100Mb);
	link_fn();
}

void e1000_init(pci_device e1000_pci, void (*receive_callback)(net_buffer_t), void (*link_callback)(void)) {
	globals->e1000 = decltype(globals->e1000)::make_nocopy(waterline_new<e1000_device>());
	globals->e1000->rx_vaddrs = (void**)walloc(sizeof(void*) * E1000_NUM_RX_DESC, 0x10);
	globals->e1000->tx_vaddrs = (void**)walloc(sizeof(void*) * E1000_NUM_TX_DESC, 0x10);
	globals->e1000->rx_descs =
		(e1000_rx_desc*)mmap(nullptr, sizeof(e1000_rx_desc) * E1000_NUM_RX_DESC, MAP_WRITETHROUGH);
	globals->e1000->tx_descs =
		(e1000_tx_desc*)mmap(nullptr, sizeof(e1000_tx_desc) * E1000_NUM_TX_DESC, MAP_WRITETHROUGH);

	receive_fn = receive_callback;
	link_fn = link_callback;
	globals->e1000->pio_base = (uint16_t)(e1000_pci.bars[1] & 0xfffffffe);
	globals->e1000->mmio_base =
		(uint64_t)mmap((e1000_pci.bars[0] & 0xfffffff0), 0x20000, MAP_WRITETHROUGH | MAP_PHYSICAL | MAP_PINNED);

	pci_enable_mem(e1000_pci.address);
	printf("Using Ethernet MMIO at %08x=>%08x\n", e1000_pci.bars[0], globals->e1000->mmio_base);

	//Global reset
	CTRL{}.set(CTRL::RST);
	io_wait();
	mmio_transaction trans{CTRL{}};
	trans.clear(CTRL::PHY_RST);
	trans.clear(CTRL::LRST);
	trans.commit();

	//Clear and disable interrupts
	IMC{} = 0xFFFFFFFF;
	(void)ICR{};

	//Detect eeprom
	globals->e1000->eeprom = false;
	EERD{} = EERD::START;
	for (int i = 0; i < 1000; i++) {
		io_wait();
		if (EERD{}.DONE_v) {
			globals->e1000->eeprom = true;
			break;
		}
	}

	//Read MAC
	uint8_t* mac_ptr = (uint8_t*)&globals->e1000->mac;
	if (globals->e1000->eeprom) {
		//print("Device has EEPROM\n");
		EEC{} = EEC::EE_SK | EEC::EE_CS | EEC::EE_DO;
		uint16_t v = e1000_read_eeprom(0);
		mac_ptr[0] = v & 0xff;
		mac_ptr[1] = v >> 8;
		v = e1000_read_eeprom(1);
		mac_ptr[2] = v & 0xff;
		mac_ptr[3] = v >> 8;
		v = e1000_read_eeprom(2);
		mac_ptr[4] = v & 0xff;
		mac_ptr[5] = v >> 8;
	} else {
		//print("Device no has EEPROM\n");
		uint32_t* mac = (uint32_t*)(globals->e1000->mmio_base + 0x5400);
		uint32_t v = mac[0];
		mac_ptr[0] = v & 0xff;
		mac_ptr[1] = v >> 8;
		mac_ptr[2] = v >> 16;
		mac_ptr[3] = v >> 24;
		v = mac[1];
		mac_ptr[4] = v & 0xff;
		mac_ptr[5] = v >> 8;
	}

	qprintf<80>("Found MAC address: %M\n", globals->e1000->mac);

	for (int i = 0; i < 0x80; i++)
		e1000_write(0x5200 + i * 4, 0);

	//Initialize RX
	for (int i = 0; i < E1000_NUM_RX_DESC; i++) {
		globals->e1000->rx_vaddrs[i] = mmap(nullptr, E1000_BUFSIZE, MAP_CONTIGUOUS | MAP_INITIALIZE);
		globals->e1000->rx_descs[i].addr = (uint64_t)virt2phys(globals->e1000->rx_vaddrs[i]);
		globals->e1000->rx_descs[i].status = 0;
		//printf("RX %08x\n", globals->e1000->rx_descs[i].addr);
	}
	e1000_write(E1000_REG::RXDESCLO, (uint64_t)virt2phys(globals->e1000->rx_descs));
	e1000_write(E1000_REG::RXDESCHI, 0);
	e1000_write(E1000_REG::RXDESCSZ, E1000_NUM_RX_DESC * 16);
	e1000_write(E1000_REG::RXDCTL, 1 | (1 << 8) | (1 << 16) | (1 << 24));
	e1000_write(E1000_REG::RDTR, 0);
	e1000_write(E1000_REG::RXDESCHD, 0);
	e1000_write(E1000_REG::RXDESCTL, E1000_NUM_RX_DESC);
	globals->e1000->rx_cur = 0;
	RCTRL{} = RCTRL::EN | RCTRL::SBP | RCTRL::UPE | RCTRL::MPE | RCTRL::RDMTS(RCTRL::RDLEN_H) | RCTRL::BAM |
			  RCTRL::SECRC | E1000_BUFSIZE_FLAGS;

	//Initialize TX
	for (int i = 0; i < E1000_NUM_TX_DESC; i++) {
		globals->e1000->tx_vaddrs[i] = mmap(nullptr, E1000_BUFSIZE, MAP_CONTIGUOUS | MAP_INITIALIZE);
		globals->e1000->tx_descs[i].addr = (uint64_t)virt2phys(globals->e1000->tx_vaddrs[i]);
		;
		globals->e1000->tx_descs[i].cmd = 0;
		globals->e1000->tx_descs[i].status = TDESC_STATUS::DD;
	}
	e1000_write(E1000_REG::TXDESCLO, (uint64_t)virt2phys(globals->e1000->tx_descs));
	e1000_write(E1000_REG::TXDESCHI, 0);
	e1000_write(E1000_REG::TXDESCSZ, E1000_NUM_TX_DESC * 16);
	e1000_write(E1000_REG::TXDESCHD, 0);
	e1000_write(E1000_REG::TXDESCTL, 0);
	globals->e1000->tx_tail = 0;
	globals->e1000->tx_head = 0;
	if (e1000_pci.device_id == 0x100E)
		e1000_write(E1000_REG::TCTRL, E1000_TCTL::EN | E1000_TCTL::PSP | (15 << E1000_TCTL::CTSHIFT) |
										  (64 << E1000_TCTL::CTCSHIFT) | E1000_TCTL::RTLC);
	else
		e1000_write(E1000_REG::TCTRL,
			E1000_TCTL::EN | E1000_TCTL::PSP | (15 << E1000_TCTL::CTSHIFT) | 63 << E1000_TCTL::CTCSHIFT | 3 << 28);
	e1000_write(E1000_REG::TXDCTL, 1 << 24);
	e1000_write(E1000_REG::TIPG, 0x0060200A);

	//Enable interrupts
	//pci_write_field(e1000_pci, interrupt_line, 5);

	printf("Using interrupt line %i\n", e1000_pci.interrupt_line);
	isr_set(e1000_pci.interrupt_line + 32, &e1000_int_handler);
	print("e1000e network card initialized.\n\n");
}
void e1000_enable() { IMS{} = 0xFF; }
void e1000_pause() { IMC{} = IMC::RXT0; }
void e1000_resume() { IMS{} = IMS::RXT0; }
static void e1000_int_handler(uint64_t, register_file*) {
	IMS{} = IMS::TXDW;
	auto status = ICR{};
	// printf("ICR %02x\n", status);
	if (status.TXDW_v || status.TXQE_v) {
		int head = e1000_read(E1000_REG::TXDESCHD);
		//qprintf<32>("%i\n", head);
		while (globals->e1000->tx_head != head) {
			//qprintf<32>("freeing %i\n", globals->e1000->tx_head);
			//if constexpr (!copy_tx)
			//	kfree((void*)globals->e1000->tx_vaddrs[globals->e1000->tx_head].addr);
			globals->e1000->tx_head = (globals->e1000->tx_head + 1) % E1000_NUM_TX_DESC;
		}
	}
	if (status.LSC_v)
		e1000_link();
	if (status.RXO_v) {
		print("RXO\n");
		printf("  RCTRL %08x\n", (uint32_t)RCTRL{});
		printf("  RXDH %i RXDT %i\n", e1000_read(E1000_REG::RXDESCHD), e1000_read(E1000_REG::RXDESCTL));
		printf("  RX0 ADDR %08x STATUS %02x\n", globals->e1000->rx_descs->addr, globals->e1000->rx_descs->status);
	}
	if (status.RXT0_v)
		e1000_receive();
}

void e1000_receive() {
	int tail = e1000_read(E1000_REG::RXDESCTL);
	uint16_t old_cur = tail;
	while (RDESC_STATUS{globals->e1000->rx_descs[globals->e1000->rx_cur].status}.DD_v) {
		uint8_t* buf = (uint8_t*)globals->e1000->rx_vaddrs[globals->e1000->rx_cur];
		uint16_t len = globals->e1000->rx_descs[globals->e1000->rx_cur].length;
		if ((globals->e1000->rx_descs[globals->e1000->rx_cur].addr & 0xfff) ||
			(uint64_t)buf != virt2phys(globals->e1000->rx_descs[globals->e1000->rx_cur].addr))
			memcpy(
				buf, (const void*)(0xffff800000000000ull | globals->e1000->rx_descs[globals->e1000->rx_cur].addr), len);
		receive_fn(net_buffer_t(buf, buf, len));
		globals->e1000->rx_descs[globals->e1000->rx_cur].status = 0;
		old_cur = globals->e1000->rx_cur;
		globals->e1000->rx_cur = (globals->e1000->rx_cur + 1) % E1000_NUM_RX_DESC;
	}
	e1000_write(E1000_REG::RXDESCTL, old_cur);
}

int e1000_send_async(net_buffer_t buf) {
	uint8_t handle = globals->e1000->tx_tail;
	while (~globals->e1000->tx_descs[handle].status & 1)
		cpu_relax();
	if constexpr (copy_tx) {
		memcpy((void*)globals->e1000->tx_vaddrs[handle], buf.data_begin, buf.data_size);
		if (buf.free_on_send)
			kfree(buf.frame_begin);
	}
	globals->e1000->tx_descs[handle].length = buf.data_size;
	globals->e1000->tx_descs[handle].status = 0;
	globals->e1000->tx_descs[handle].cmd = TDESC_CMD::EOP | TDESC_CMD::IFCS | TDESC_CMD::RS;
	globals->e1000->tx_tail = (globals->e1000->tx_tail + 1) % E1000_NUM_TX_DESC;
	e1000_write(E1000_REG::TXDESCTL, globals->e1000->tx_tail);
	return handle;
}

void net_await(int handle) {
	while (~globals->e1000->tx_descs[handle].status & 1)
		cpu_relax();
}