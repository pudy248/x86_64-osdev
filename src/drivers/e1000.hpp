#pragma once
#include <cstdint>
#include <drivers/register.hpp>
#include <kstddef.hpp>
#include <net/net.hpp>

struct pci_device;

namespace E1000 {
void e1000_write(uint16_t addr, uint32_t val);
uint32_t e1000_read(uint16_t addr);
template <typename CRTP>
using e1000_reg = mmio_reg_s<uint32_t, uint16_t, e1000_read, e1000_write, CRTP>;
struct CTRL : e1000_reg<CTRL> {
	using e1000_reg<CTRL>::operator=;
	static constexpr uint16_t offset = 0x0000;
	flag_bitmask(FD, 0);
	flag_bitmask(LRST, 3);
	flag_bitmask(SLU, 6);
	enum_bitmask(SPEED, 8, 2, S_10Mb, S_100Mb, S_1000Mb);
	flag_bitmask(PHYRA, 10);
	flag_bitmask(RST, 26);
	flag_bitmask(RFCE, 27);
	flag_bitmask(TFCE, 28);
	flag_bitmask(VME, 30);
	flag_bitmask(PHY_RST, 31);
};
struct STATUS : e1000_reg<STATUS> {
	using e1000_reg<STATUS>::operator=;
	static constexpr uint16_t offset = 0x0008;
	flag_bitmask(FD, 0);
	flag_bitmask(LU, 1);
	flag_bitmask(TXOFF, 4);
	enum_bitmask(SPEED, 6, 2, S_10Mb, S_100Mb, S_1000Mb);
	int_bitmask(ASDV, 8, 2);
};
struct EEC : e1000_reg<EEC> {
	using e1000_reg<EEC>::operator=;
	static constexpr uint16_t offset = 0x0010;
	flag_bitmask(EE_SK, 0);
	flag_bitmask(EE_CS, 1);
	flag_bitmask(EE_DI, 2);
	flag_bitmask(EE_DO, 3);
	flag_bitmask(EE_CLK, 4);
	flag_bitmask(EE_REQ, 6);
	flag_bitmask(EE_GNT, 7);
	flag_bitmask(EE_PRES, 8);
	// ...
};
struct EERD : e1000_reg<EERD> {
	using e1000_reg<EERD>::operator=;
	static constexpr uint16_t offset = 0x0014;
	flag_bitmask(START, 0);
	flag_bitmask(DONE, 1);
	int_bitmask(ADDR, 2, 14);
	int_bitmask(DATA, 16, 16);
};
struct ICR : e1000_reg<ICR> {
	using e1000_reg<ICR>::operator=;
	static constexpr uint16_t offset = 0x00C0;
	flag_bitmask(TXDW, 0);
	flag_bitmask(TXQE, 1);
	flag_bitmask(LSC, 2);
	flag_bitmask(RXSEQ, 3);
	flag_bitmask(RXDMT0, 4);
	flag_bitmask(RXO, 6);
	flag_bitmask(RXT0, 7);
	flag_bitmask(TXD_LOW, 15);
};
struct ITR : e1000_reg<ITR> {
	using e1000_reg<ITR>::operator=;
	static constexpr uint16_t offset = 0x00C4;
	// 256ns increments
	int_bitmask(INTERVAL, 0, 16);
};
struct ICS : e1000_reg<ICS> {
	using e1000_reg<ICS>::operator=;
	static constexpr uint16_t offset = 0x00C8;
	flag_bitmask(TXDW, 0);
	flag_bitmask(TXQE, 1);
	flag_bitmask(LSC, 2);
	flag_bitmask(RXSEQ, 3);
	flag_bitmask(RXDMT0, 4);
	flag_bitmask(RXO, 6);
	flag_bitmask(RXT0, 7);
	flag_bitmask(TXD_LOW, 15);
};
struct IMS : e1000_reg<IMS> {
	using e1000_reg<IMS>::operator=;
	static constexpr uint16_t offset = 0x00D0;
	flag_bitmask(TXDW, 0);
	flag_bitmask(TXQE, 1);
	flag_bitmask(LSC, 2);
	flag_bitmask(RXSEQ, 3);
	flag_bitmask(RXDMT0, 4);
	flag_bitmask(RXO, 6);
	flag_bitmask(RXT0, 7);
	flag_bitmask(TXD_LOW, 15);
};
struct IMC : e1000_reg<IMC> {
	using e1000_reg<IMC>::operator=;
	static constexpr uint16_t offset = 0x00D8;
	flag_bitmask(TXDW, 0);
	flag_bitmask(TXQE, 1);
	flag_bitmask(LSC, 2);
	flag_bitmask(RXSEQ, 3);
	flag_bitmask(RXDMT0, 4);
	flag_bitmask(RXO, 6);
	flag_bitmask(RXT0, 7);
	flag_bitmask(TXD_LOW, 15);
};

struct RCTRL : e1000_reg<RCTRL> {
	using e1000_reg<RCTRL>::operator=;
	static constexpr uint16_t offset = 0x0100;
	flag_bitmask(EN, 1);
	flag_bitmask(SBP, 2);
	flag_bitmask(UPE, 3);
	flag_bitmask(MPE, 4);
	flag_bitmask(LPE, 5);
	int_bitmask(LBM, 6, 2);
	enum_bitmask(RDMTS, 8, 2, RDLEN_H, RDLEN_Q, RDLEN_E);
	enum_bitmask(DTYP, 10, 2, DTYP_LEGACY, DTYP_PACKET_SPLIT);
	flag_bitmask(BAM, 15);
	enum_bitmask(BSIZE, 16, 2, BSZ_2048, BSZ_1024, BSZ_512, BSZ_256);
	flag_bitmask(VFE, 18);
	flag_bitmask(CFIEN, 19);
	flag_bitmask(CFI, 20);
	flag_bitmask(DPF, 22);
	flag_bitmask(PMCF, 23);
	flag_bitmask(BSEX, 25);
	flag_bitmask(SECRC, 26);
};

namespace E1000_REG {
enum E1000_REG : uint16_t {
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
	TXDCTL = 0x3828,

	RNBC = 0x40A0,
	ROC = 0x40AC,
};
}

struct RDESC_STATUS : data_reg<uint8_t, volatile uint8_t> {
	using data_reg::operator=;
	flag_bitmask(DD, 0);
	flag_bitmask(EOP, 1);
	flag_bitmask(IXSM, 2);
	flag_bitmask(VP, 3);
	flag_bitmask(UDPCS, 4);
	flag_bitmask(TCPCS, 5);
	flag_bitmask(IPCS, 6);
	flag_bitmask(PIF, 7);
};
struct RDESC_ERR : data_reg<uint8_t, volatile uint8_t> {
	using data_reg::operator=;
	flag_bitmask(CE, 0);
	flag_bitmask(SE, 1);
	flag_bitmask(SEQ, 2);
	flag_bitmask(TCPE, 5);
	flag_bitmask(IPE, 6);
	flag_bitmask(RXE, 7);
};
struct TDESC_CMD : data_reg<uint8_t, volatile uint8_t> {
	using data_reg::operator=;
	flag_bitmask(EOP, 0);
	flag_bitmask(IFCS, 1);
	flag_bitmask(IC, 2);
	flag_bitmask(RS, 3);
	flag_bitmask(DEXT, 5);
	flag_bitmask(VLE, 6);
	flag_bitmask(IDE, 7);
};
struct TDESC_STATUS : data_reg<uint8_t, volatile uint8_t> {
	using data_reg::operator=;
	flag_bitmask(DD, 0);
	flag_bitmask(EC, 1);
	flag_bitmask(LC, 2);
};

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
}

constexpr int E1000_NUM_RX_DESC = 32;
constexpr int E1000_NUM_TX_DESC = 8;
constexpr uint32_t E1000_BUFSIZE_FLAGS = E1000::RCTRL::BSZ_256 | E1000::RCTRL::BSEX;
constexpr int E1000_BUFSIZE = 0x1000;

//80ec64d7 00000000 560162c7 73000000
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

struct e1000_device {
	uint64_t mmio_base;
	uint16_t pio_base;
	mac_t mac;
	void** rx_vaddrs;
	void** tx_vaddrs;
	e1000_rx_desc* rx_descs;
	e1000_tx_desc* tx_descs;
	uint16_t rx_cur;
	uint16_t tx_tail;
	uint16_t tx_head;
	bool eeprom;
};

void e1000_init(pci_device e1000_pci, void (*receive_callback)(net_buffer_t), void (*link_callback)(void));
void e1000_enable();
void e1000_pause();
void e1000_resume();
void e1000_receive(void);
int e1000_send_async(net_buffer_t);
void net_await(int handle);
