#include <asm.hpp>
#include <cstdint>
#include <drivers/e1000.hpp>
#include <drivers/pci.hpp>
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

static void e1000_write(uint16_t addr, uint32_t val) {
	((volatile uint32_t*)globals->e1000->mmio_base)[addr >> 2] = val;
}
static uint32_t e1000_read(uint16_t addr) { return ((volatile uint32_t*)globals->e1000->mmio_base)[addr >> 2]; }
static uint16_t e1000_read_eeprom(uint8_t addr) {
	uint32_t tmp;
	tmp = (uint32_t)addr << 8;
	tmp |= 1;
	e1000_write(E1000_REG::EERD, tmp);
	for (int i = 0; 1; i++) {
		outb(0x80, 0);
		tmp = e1000_read(E1000_REG::EERD);
		if (tmp & 0x10)
			break;
		if (i > 1000) {
			qprintf<80>("EEPROM Read Error: %08x %08x\n", e1000_read(E1000_REG::EECD), e1000_read(E1000_REG::EERD));
			inf_wait();
		}
	}
	return tmp >> 16;
}

static void e1000_link() {
	e1000_write(E1000_REG::CTRL, e1000_read(E1000_REG::CTRL) | 0x40);
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

	//Clear and disable interrupts
	e1000_write(E1000_REG::IMC, 0xFFFFFFFF);
	e1000_read(E1000_REG::ICR);

	//Global reset
	e1000_write(E1000_REG::CTRL, e1000_read(E1000_REG::CTRL) & ~0x04000000);
	outb(0x80, 0);
	e1000_write(E1000_REG::CTRL, e1000_read(E1000_REG::CTRL) & ~0xC0000088);

	//Detect eeprom
	globals->e1000->eeprom = false;
	e1000_write(E1000_REG::EERD, 0x1);
	for (int i = 0; i < 1000; i++) {
		outb(0x80, 0);
		if (e1000_read(E1000_REG::EERD) & 0x10) {
			globals->e1000->eeprom = true;
			break;
		}
	}

	//Read MAC
	uint8_t* mac_ptr = (uint8_t*)&globals->e1000->mac;
	if (globals->e1000->eeprom) {
		//print("Device has EEPROM\n");
		e1000_write(E1000_REG::EECD, 0xB);
		uint16_t v;
		v = e1000_read_eeprom(0);

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
	}
	e1000_write(E1000_REG::RXDESCLO, (uint64_t)virt2phys(globals->e1000->rx_descs));
	e1000_write(E1000_REG::RXDESCHI, 0);
	e1000_write(E1000_REG::RXDESCSZ, E1000_NUM_RX_DESC * 16);
	e1000_write(E1000_REG::RXDCTL, 1 | (1 << 8) | (1 << 16) | (1 << 24));
	e1000_write(E1000_REG::RDTR, 0);
	e1000_write(E1000_REG::RXDESCHD, 0);
	e1000_write(E1000_REG::RXDESCTL, E1000_NUM_RX_DESC);
	globals->e1000->rx_cur = 0;
	e1000_write(E1000_REG::RCTRL, E1000_RCTL::EN | E1000_RCTL::SBP | E1000_RCTL::UPE | E1000_RCTL::MPE |
									  E1000_RCTL::RDMTS_H | E1000_RCTL::BAM | E1000_RCTL::SECRC | E1000_BUFSIZE_FLAGS);

	//Initialize TX
	for (int i = 0; i < E1000_NUM_TX_DESC; i++) {
		globals->e1000->tx_vaddrs[i] = mmap(nullptr, E1000_BUFSIZE, MAP_CONTIGUOUS | MAP_INITIALIZE);
		globals->e1000->tx_descs[i].addr = (uint64_t)virt2phys(globals->e1000->tx_vaddrs[i]);
		;
		globals->e1000->tx_descs[i].cmd = 0;
		globals->e1000->tx_descs[i].status = E1000_TSTA::DD;
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

void e1000_enable() { e1000_write(E1000_REG::IMS, 0xFF & ~4); }
void e1000_pause() { e1000_write(E1000_REG::IMC, 0x80); }
void e1000_resume() { e1000_write(E1000_REG::IMS, 0x80); }

static void e1000_int_handler(uint64_t, register_file*) {
	e1000_write(E1000_REG::IMS, 0x1);
	uint32_t status = e1000_read(E1000_REG::ICR);
	// printf("ICR %02x\n", status);
	if ((status & 0x01) || (status & 0x02)) {
		int head = e1000_read(E1000_REG::TXDESCHD);
		//qprintf<32>("%i\n", head);
		while (globals->e1000->tx_head != head) {
			//qprintf<32>("freeing %i\n", globals->e1000->tx_head);
			//if constexpr (!copy_tx)
			//	kfree((void*)globals->e1000->tx_vaddrs[globals->e1000->tx_head].addr);
			globals->e1000->tx_head = (globals->e1000->tx_head + 1) % E1000_NUM_TX_DESC;
		}
	}
	if (status & 0x04)
		e1000_link();
	if (status & 0x40) {
		print("RXO\n");
		printf("  RCTRL %08x\n", e1000_read(E1000_REG::RCTRL));
		printf("  RXDH %i RXDT %i\n", e1000_read(E1000_REG::RXDESCHD), e1000_read(E1000_REG::RXDESCTL));
		printf("  RX0 ADDR %08x STATUS %02x\n", globals->e1000->rx_descs->addr, globals->e1000->rx_descs->status);
	}
	if (status & 0x80)
		e1000_receive();
}

void e1000_receive() {
	int tail = e1000_read(E1000_REG::RXDESCTL);
	uint16_t old_cur = tail;
	while (globals->e1000->rx_descs[globals->e1000->rx_cur].status & 0x1) {
		uint8_t* buf = (uint8_t*)globals->e1000->rx_vaddrs[globals->e1000->rx_cur];
		uint16_t len = globals->e1000->rx_descs[globals->e1000->rx_cur].length;
		receive_fn({buf, buf, len});
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
		kfree(buf.frame_begin);
	} // else
	//	globals->e1000->tx_descs[handle].addr = (uint64_t)pointer<std::byte, integer>(buf.frame_begin);
	globals->e1000->tx_descs[handle].length = buf.data_size;

	globals->e1000->tx_descs[handle].cmd = E1000_TCMD::EOP | E1000_TCMD::IFCS | E1000_TCMD::RS;
	globals->e1000->tx_descs[handle].status = 0;
	globals->e1000->tx_tail = (globals->e1000->tx_tail + 1) % E1000_NUM_TX_DESC;
	e1000_write(E1000_REG::TXDESCTL, globals->e1000->tx_tail);
	return handle;
}

void net_await(int handle) {
	while (~globals->e1000->tx_descs[handle].status & 1)
		cpu_relax();
}