#pragma once
#include <cstdint>
#include <kstddefs.hpp>

struct pci_device;

namespace E1000_REG {
enum E1000_REG : uint16_t {
	CTRL = 0x0000,
	STATUS = 0x0008,
	EECD = 0x0010,
	EERD = 0x0014,
	CTRL_EXT = 0x0018,
	ICR = 0x00C0,
	ITR = 0x00C4,
	ICS = 0x00C8,
	IMS = 0x00D0,
	IMC = 0x00D8,

	RCTRL = 0x0100,
	RDFHS = 0x2420,
	RDFTS = 0x2428,
	RDFPC = 0x2430,
	RXDESCLO = 0x2800,
	RXDESCHI = 0x2804,
	RXDESCSZ = 0x2808,
	RXDESCHD = 0x2810,
	RXDESCTL = 0x2818,
	RDTR = 0x2820,
	RXDCTL = 0x2828,
	RADV = 0x282C,
	RSRPD = 0x2C00,

	TCTRL = 0x0400,
	TIPG = 0x0410,
	TXDESCLO = 0x3800,
	TXDESCHI = 0x3804,
	TXDESCSZ = 0x3808,
	TXDESCHD = 0x3810,
	TXDESCTL = 0x3818,

	RNBC = 0x40A0,
	ROC = 0x40AC,
};
}

namespace E1000_RCTL {
enum E1000_RCTL : uint32_t {
	EN = 1 << 1,
	SBP = 1 << 2,
	UPE = 1 << 3,
	MPE = 1 << 4,
	LPE = 1 << 5,
	LBM_NONE = 0 << 6,
	LBM_PHY = 3 << 6,
	RDMTS_H = 0 << 8,
	RDMTS_Q = 1 << 8,
	RDMTS_E = 2 << 8,
	MO36 = 0 << 12,
	MO35 = 1 << 12,
	MO34 = 2 << 12,
	MO32 = 3 << 12,
	BSZ256 = 3 << 16,
	BSZ512 = 2 << 16,
	BSZ1024 = 1 << 16,
	BSZ2048 = 0 << 16,
	BSZ4096 = ((3 << 16) | (1 << 25)),
	BSZ8192 = ((2 << 16) | (1 << 25)),
	BSZ16384 = ((1 << 16) | (1 << 25)),
	BAM = 1 << 15,
	VFE = 1 << 18,
	CFIEN = 1 << 19,
	CFI = 1 << 20,
	DPF = 1 << 22,
	PMCF = 1 << 23,
	SECRC = 1 << 26,
};
}

namespace E1000_TCMD {
enum E1000_TCMD : uint8_t {
	EOP = 1 << 0,
	IFCS = 1 << 1,
	IC = 1 << 2,
	RS = 1 << 3,
	RPS = 1 << 4,
	VLE = 1 << 6,
	IDE = 1 << 7,
};
}

namespace E1000_TCTL {
enum E1000_TCTL : uint32_t {
	EN = 1 << 1,
	CTSHIFT = 4,
	CTCSHIFT = 12,
	PSP = 1 << 3,
	SWXOFF = 1 << 22,
	RTLC = 1 << 24,
};
}

namespace E1000_TSTA {
enum E1000_TSTA : uint8_t {
	DD = 1 << 0,
	EC = 1 << 1,
	LC = 1 << 2,
	TU = 1 << 3,
};
}

constexpr int E1000_NUM_RX_DESC = 32;
constexpr int E1000_NUM_TX_DESC = 8;
constexpr uint32_t E1000_BUFSIZE_FLAGS = E1000_RCTL::BSZ8192;
constexpr int E1000_BUFSIZE = 0x2000;

struct [[gnu::packed]] e1000_rx_desc {
	volatile uint64_t addr;
	volatile uint16_t length;
	volatile uint16_t checksum;
	volatile uint8_t status;
	volatile uint8_t errors;
	volatile uint16_t special;
};

struct [[gnu::packed]] e1000_tx_desc {
	volatile uint64_t addr;
	volatile uint16_t length;
	volatile uint8_t cso;
	volatile uint8_t cmd;
	volatile uint8_t status;
	volatile uint8_t css;
	volatile uint16_t special;
};

struct e1000_handle {
	uint64_t mmio_base;
	uint16_t pio_base;
	uint8_t mac[6];
	e1000_rx_desc* rx_descs;
	e1000_tx_desc* tx_descs;
	uint16_t rx_cur;
	uint16_t tx_cur;
	uint8_t eeprom;
};

extern e1000_handle* e1000_dev;

void e1000_init(pci_device e1000_pci, void (*receive_callback)(void* packet, uint16_t len),
				void (*link_callback)(void));
void e1000_enable();
void e1000_receive(void);
int e1000_send_async(void* data, uint16_t len);
void net_await(int handle);
