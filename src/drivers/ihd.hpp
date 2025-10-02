#pragma once
#include "kassert.hpp"
#include <cstdint>
#include <drivers/pci.hpp>
#include <drivers/register.hpp>
#include <stl/array.hpp>
#include <stl/ranges.hpp>

namespace IHD {
enum class DDI { A, B, C, D, E };
enum class TRANSCODER { A, B, C, WD0, EDP };
enum class DPLL { DPLL0, DPLL1, DPLL2, DPLL3 };

uint32_t ihd_reg_read(uint32_t addr);
void ihd_reg_write(uint32_t addr, uint32_t val);

template <typename CRTP>
using ihd_gfx_reg_s = mmio_reg_s<uint32_t, uint32_t, ihd_reg_read, ihd_reg_write, CRTP>;
template <typename CRTP>
using ihd_gfx_reg_d = mmio_reg_d<uint32_t, uint32_t, ihd_reg_read, ihd_reg_write, CRTP>;

struct TRANS_CONF : ihd_gfx_reg_d<TRANS_CONF> {
	using ihd_gfx_reg_d<TRANS_CONF>::operator=;
	constexpr TRANS_CONF(TRANSCODER trans)
		: ihd_gfx_reg_d<TRANS_CONF>(array(0x60000, 0x61000, 0x62000, 0x7e000, 0x7f000)[(uint32_t)trans]) {}

	enum_bitmask(INTERLACED, 21, 2, PF_PD, PF_ID, IF_ID);
	flag_bitmask(STATE, 30);
	flag_bitmask(ENABLE, 31);
};
struct TRANS_CLK_SEL : ihd_gfx_reg_d<TRANS_CLK_SEL> {
	using ihd_gfx_reg_d<TRANS_CLK_SEL>::operator=;
	constexpr TRANS_CLK_SEL(TRANSCODER trans) : ihd_gfx_reg_d<TRANS_CLK_SEL>(0x46140 + ((uint32_t)trans * 4)) {
		kassert(ALWAYS_ACTIVE, ERROR, trans != TRANSCODER::WD0 && trans != TRANSCODER::EDP, "Register does not exist.");
	}

	enum_bitmask(CLK_SEL, 29, 3, NONE, DDIB = 2, DDIC, DDID, DDIE);
};
struct TRANS_DDI_FUNC_CTL : ihd_gfx_reg_d<TRANS_DDI_FUNC_CTL> {
	using ihd_gfx_reg_d<TRANS_DDI_FUNC_CTL>::operator=;
	constexpr TRANS_DDI_FUNC_CTL(TRANSCODER trans)
		: ihd_gfx_reg_d<TRANS_DDI_FUNC_CTL>(array(0x60400, 0x61400, 0x62400, 0, 0x6f400)[(uint32_t)trans]) {
		kassert(ALWAYS_ACTIVE, ERROR, trans != TRANSCODER::WD0, "Register does not exist.");
	}

	enum_bitmask(WIDTH, 1, 3, WIDTH1, WIDTH2, WIDTH4);
	enum_bitmask(EDP_INPUT, 12, 3, A_ALWAYS_ON, B_ON_OFF = 5, C_ON_OFF);
	flag_bitmask(PORT_SYNC_ENABLE, 15);
	flag_bitmask(HSYNC_HIGH, 16);
	flag_bitmask(VSYNC_HIGH, 17);
	enum_bitmask(PORT_SYNC_MASTER, 18, 2, EDP, A, B, C);
	enum_bitmask(BPC, 20, 3, BPC8, BPC10, BPC6, BPC12);
	enum_bitmask(DDI_MODE, 24, 3, HDMI, DVI, DP_SST, DP_MST);
	enum_bitmask(DDI_SEL, 28, 3, NONE, DDIB, DDIC, DDID, DDIE);
	flag_bitmask(ENABLE, 31);
};
struct TRANS_HTOTAL : ihd_gfx_reg_d<TRANS_HTOTAL> {
	using ihd_gfx_reg_d<TRANS_HTOTAL>::operator=;
	constexpr TRANS_HTOTAL(TRANSCODER trans)
		: ihd_gfx_reg_d<TRANS_HTOTAL>(array(0x60000, 0x61000, 0x62000, 0x6e000, 0x6f000)[(uint32_t)trans]) {}
	int_bitmask(HACTIVE, 0, 12);
	int_bitmask(HTOTAL, 16, 12);
};
struct TRANS_HBLANK : ihd_gfx_reg_d<TRANS_HBLANK> {
	using ihd_gfx_reg_d<TRANS_HBLANK>::operator=;
	constexpr TRANS_HBLANK(TRANSCODER trans)
		: ihd_gfx_reg_d<TRANS_HBLANK>(array(0x60004, 0x61004, 0x62004, 0, 0x6f004)[(uint32_t)trans]) {
		kassert(ALWAYS_ACTIVE, ERROR, trans != TRANSCODER::WD0, "Register does not exist.");
	}
	int_bitmask(HBLANK_START, 0, 12);
	int_bitmask(HBLANK_END, 16, 12);
};
struct TRANS_HSYNC : ihd_gfx_reg_d<TRANS_HSYNC> {
	using ihd_gfx_reg_d<TRANS_HSYNC>::operator=;
	constexpr TRANS_HSYNC(TRANSCODER trans)
		: ihd_gfx_reg_d<TRANS_HSYNC>(array(0x60008, 0x61008, 0x62008, 0, 0x6f008)[(uint32_t)trans]) {
		kassert(ALWAYS_ACTIVE, ERROR, trans != TRANSCODER::WD0, "Register does not exist.");
	}
	int_bitmask(HSYNC_START, 0, 12);
	int_bitmask(HSYNC_END, 16, 12);
};
struct TRANS_VTOTAL : ihd_gfx_reg_d<TRANS_VTOTAL> {
	using ihd_gfx_reg_d<TRANS_VTOTAL>::operator=;
	constexpr TRANS_VTOTAL(TRANSCODER trans)
		: ihd_gfx_reg_d<TRANS_VTOTAL>(array(0x6000c, 0x6100c, 0x6200c, 0x6e00c, 0x6f00c)[(uint32_t)trans]) {}
	int_bitmask(VACTIVE, 0, 12);
	int_bitmask(VTOTAL, 16, 12);
};
struct TRANS_VBLANK : ihd_gfx_reg_d<TRANS_VBLANK> {
	using ihd_gfx_reg_d<TRANS_VBLANK>::operator=;
	constexpr TRANS_VBLANK(TRANSCODER trans)
		: ihd_gfx_reg_d<TRANS_VBLANK>(array(0x60010, 0x61010, 0x62010, 0, 0x6f010)[(uint32_t)trans]) {
		kassert(ALWAYS_ACTIVE, ERROR, trans != TRANSCODER::EDP, "Register does not exist.");
	}
	int_bitmask(VBLANK_START, 0, 12);
	int_bitmask(VBLANK_END, 16, 12);
};
struct TRANS_VSYNC : ihd_gfx_reg_d<TRANS_VSYNC> {
	using ihd_gfx_reg_d<TRANS_VSYNC>::operator=;
	constexpr TRANS_VSYNC(TRANSCODER trans)
		: ihd_gfx_reg_d<TRANS_VSYNC>(array(0x60014, 0x61014, 0x62014, 0, 0x6f014)[(uint32_t)trans]) {
		kassert(ALWAYS_ACTIVE, ERROR, trans != TRANSCODER::EDP, "Register does not exist.");
	}
	int_bitmask(VSYNC_START, 0, 12);
	int_bitmask(VSYNC_END, 16, 12);
};

struct DP_TP_CTL : ihd_gfx_reg_d<DP_TP_CTL> {
	using ihd_gfx_reg_d<DP_TP_CTL>::operator=;
	constexpr DP_TP_CTL(DDI ddi) : ihd_gfx_reg_d<DP_TP_CTL>(0x64040 + ((uint32_t)ddi * 0x100)) {}

	flag_bitmask(ALTERNATE_SR, 6);
	enum_bitmask(DP_LINK_TRAINING, 8, 3, TP_1, TP_2, IDLE, NORMAL, TP_3);
	flag_bitmask(ENHANCED_FRAMING, 18);
	enum_bitmask(TRANSPORT_MODE, 27, 1, SST, MST);
	flag_bitmask(ENABLE, 31);
};
struct DDI_AUX_CTL : ihd_gfx_reg_d<DDI_AUX_CTL> {
	using ihd_gfx_reg_d<DDI_AUX_CTL>::operator=;
	constexpr DDI_AUX_CTL(DDI ddi) : ihd_gfx_reg_d<DDI_AUX_CTL>(0x64010 + ((uint32_t)ddi * 0x100)) {
		kassert(ALWAYS_ACTIVE, ERROR, ddi != DDI::E, "Register does not exist.");
	}

	int_bitmask(MESSAGE_SIZE, 20, 5);
	flag_bitmask(DONE, 30);
	flag_bitmask(SEND_BUSY, 31);
};
struct DDI_AUX_DATA : ihd_gfx_reg_d<DDI_AUX_DATA> {
	using ihd_gfx_reg_d<DDI_AUX_DATA>::operator=;
	constexpr DDI_AUX_DATA(DDI ddi, unsigned dword)
		: ihd_gfx_reg_d<DDI_AUX_DATA>(0x64014 + ((uint32_t)ddi * 0x100) + (dword * 4)) {
		kassert(ALWAYS_ACTIVE, ERROR, ddi != DDI::E && dword < 5, "Register does not exist.");
	}
};
struct DDI_BUF_CTL : ihd_gfx_reg_d<DDI_BUF_CTL> {
	using ihd_gfx_reg_d<DDI_BUF_CTL>::operator=;
	constexpr DDI_BUF_CTL(DDI ddi) : ihd_gfx_reg_d<DDI_BUF_CTL>(0x64000 + ((uint32_t)ddi * 0x100)) {}

	flag_bitmask(INIT_DISLAY_DETECTED, 0);
	enum_bitmask(DP_PORT_WIDTH, 1, 3, X1, X2, X4);
	enum_bitmask(DDIA_LANE_CAPABILITY, 4, 1, A2_E2, A4_E0);
	flag_bitmask(DDI_IDLE, 7);
	flag_bitmask(ENABLE, 31);
};
struct SFUSE_STRAP : ihd_gfx_reg_s<SFUSE_STRAP> {
	using ihd_gfx_reg_s<SFUSE_STRAP>::operator=;
	static constexpr uint32_t offset = 0xC2014;
	flag_bitmask(PORT_D_STRAP, 0);
	flag_bitmask(PORT_C_STRAP, 1);
	flag_bitmask(PORT_B_STRAP, 2);
};

struct PLANE_BUF_CFG_1_A : ihd_gfx_reg_s<PLANE_BUF_CFG_1_A> {
	using ihd_gfx_reg_s<PLANE_BUF_CFG_1_A>::operator=;
	static constexpr uint32_t offset = 0x7027c;
	int_bitmask(BUFFER_START, 0, 10);
	int_bitmask(BUFFER_END, 16, 10);
};
struct PLANE_CTL_1_A : ihd_gfx_reg_s<PLANE_CTL_1_A> {
	using ihd_gfx_reg_s<PLANE_CTL_1_A>::operator=;
	static constexpr uint32_t offset = 0x70180;
	// more
	flag_bitmask(CSC_ENABLE, 23);
	enum_bitmask(
		SOURCE_PFMT, 24, 4, YUV422, NV12_YUV420, RGB2101010 = 2, RGB8888 = 4, RGB16161616FLOAT = 6); // todo rest
	flag_bitmask(YUV_RANGE_CORRECT_DISABLE, 28);
	flag_bitmask(REMOVE_YUV_OFFSET, 29);
	flag_bitmask(GAMMA_ENABLE, 30);
	flag_bitmask(ENABLE, 31);
};
struct PLANE_STRIDE_1_A : ihd_gfx_reg_s<PLANE_STRIDE_1_A> {
	using ihd_gfx_reg_s<PLANE_STRIDE_1_A>::operator=;
	static constexpr uint32_t offset = 0x70188;
	int_bitmask(STRIDE, 0, 10);
};
struct PLANE_POS_1_A : ihd_gfx_reg_s<PLANE_POS_1_A> {
	using ihd_gfx_reg_s<PLANE_POS_1_A>::operator=;
	static constexpr uint32_t offset = 0x7018C;
	int_bitmask(POS_X, 0, 13);
	int_bitmask(POS_Y, 16, 13);
};
struct PLANE_SIZE_1_A : ihd_gfx_reg_s<PLANE_SIZE_1_A> {
	using ihd_gfx_reg_s<PLANE_SIZE_1_A>::operator=;
	static constexpr uint32_t offset = 0x70190;
	int_bitmask(SIZE_X, 0, 13);
	int_bitmask(SIZE_Y, 16, 13);
};
struct PLANE_SURF_1_A : ihd_gfx_reg_s<PLANE_SURF_1_A> {
	using ihd_gfx_reg_s<PLANE_SURF_1_A>::operator=;
	static constexpr uint32_t offset = 0x7019C;
	int_bitmask(SURF_ADDR, 12, 20);
};
struct PLANE_OFFSET_1_A : ihd_gfx_reg_s<PLANE_OFFSET_1_A> {
	using ihd_gfx_reg_s<PLANE_OFFSET_1_A>::operator=;
	static constexpr uint32_t offset = 0x701A4;
	int_bitmask(OFFSET_X, 0, 13);
	int_bitmask(OFFSET_Y, 16, 13);
};
struct PIPE_SRCSZ_A : ihd_gfx_reg_s<PIPE_SRCSZ_A> {
	using ihd_gfx_reg_s<PIPE_SRCSZ_A>::operator=;
	static constexpr uint32_t offset = 0x6001C;
	int_bitmask(SRC_WIDTH, 0, 12);
	int_bitmask(SRC_HEIGHT, 16, 12);
};
struct PLANE_WM_1_A : ihd_gfx_reg_s<PLANE_WM_1_A> {
	using ihd_gfx_reg_s<PLANE_WM_1_A>::operator=;
	static constexpr uint32_t offset = 0x70140;
	int_bitmask(BLOCKS, 0, 10);
	int_bitmask(LINES, 14, 5);
};
struct WM_LINETIME_A : ihd_gfx_reg_s<WM_LINETIME_A> {
	using ihd_gfx_reg_s<WM_LINETIME_A>::operator=;
	static constexpr uint32_t offset = 0x45270;
	int_bitmask(LINETIME, 0, 8);
};
struct PS_CTRL_1_A : ihd_gfx_reg_s<PS_CTRL_1_A> {
	using ihd_gfx_reg_s<PS_CTRL_1_A>::operator=;
	static constexpr uint32_t offset = 0x68180;
	flag_bitmask(PS_ENABLE, 31);
};
struct PS_WIN_SZ_1_A : ihd_gfx_reg_s<PS_WIN_SZ_1_A> {
	using ihd_gfx_reg_s<PS_WIN_SZ_1_A>::operator=;
	static constexpr uint32_t offset = 0x68174;
	int_bitmask(YSIZE, 0, 12);
	int_bitmask(XSIZE, 16, 12);
};
struct PS_CTRL_2_A : ihd_gfx_reg_s<PS_CTRL_2_A> {
	using ihd_gfx_reg_s<PS_CTRL_2_A>::operator=;
	static constexpr uint32_t offset = 0x68280;
	flag_bitmask(PS_ENABLE, 31);
};
struct PS_WIN_SZ_2_A : ihd_gfx_reg_s<PS_WIN_SZ_2_A> {
	using ihd_gfx_reg_s<PS_WIN_SZ_2_A>::operator=;
	static constexpr uint32_t offset = 0x68274;
	int_bitmask(YSIZE, 0, 12);
	int_bitmask(XSIZE, 16, 12);
};
struct PS_CTRL_1_B : ihd_gfx_reg_s<PS_CTRL_1_B> {
	using ihd_gfx_reg_s<PS_CTRL_1_B>::operator=;
	static constexpr uint32_t offset = 0x68980;
	flag_bitmask(PS_ENABLE, 31);
};
struct PS_WIN_SZ_1_B : ihd_gfx_reg_s<PS_WIN_SZ_1_B> {
	using ihd_gfx_reg_s<PS_WIN_SZ_1_B>::operator=;
	static constexpr uint32_t offset = 0x68974;
	int_bitmask(YSIZE, 0, 12);
	int_bitmask(XSIZE, 16, 12);
};
struct PS_CTRL_2_B : ihd_gfx_reg_s<PS_CTRL_2_B> {
	using ihd_gfx_reg_s<PS_CTRL_2_B>::operator=;
	static constexpr uint32_t offset = 0x68A80;
	flag_bitmask(PS_ENABLE, 31);
};
struct PS_WIN_SZ_2_B : ihd_gfx_reg_s<PS_WIN_SZ_2_B> {
	using ihd_gfx_reg_s<PS_WIN_SZ_2_B>::operator=;
	static constexpr uint32_t offset = 0x68A74;
	int_bitmask(YSIZE, 0, 12);
	int_bitmask(XSIZE, 16, 12);
};
struct PS_CTRL_1_C : ihd_gfx_reg_s<PS_CTRL_1_C> {
	using ihd_gfx_reg_s<PS_CTRL_1_C>::operator=;
	static constexpr uint32_t offset = 0x69180;
	flag_bitmask(PS_ENABLE, 31);
};
struct PS_WIN_SZ_1_C : ihd_gfx_reg_s<PS_WIN_SZ_1_C> {
	using ihd_gfx_reg_s<PS_WIN_SZ_1_C>::operator=;
	static constexpr uint32_t offset = 0x69174;
	int_bitmask(YSIZE, 0, 12);
	int_bitmask(XSIZE, 16, 12);
};

struct GMBUS0 : ihd_gfx_reg_s<GMBUS0> {
	using ihd_gfx_reg_s<GMBUS0>::operator=;
	static constexpr uint32_t offset = 0xC5100;
	enum_bitmask(PIN_PAIR, 0, 3, DISABLED = 0, DDIC = 4, DDIB, DDID);
};
struct GMBUS1 : ihd_gfx_reg_s<GMBUS1> {
	using ihd_gfx_reg_s<GMBUS1>::operator=;
	static constexpr uint32_t offset = 0xC5104;
	flag_bitmask(SLAVE_READ, 0);
	int_bitmask(SLAVE_ADDR_OFFSET, 1, 7);
	int_bitmask(SLAVE_REGISTER_OFFSET, 8, 8);
	int_bitmask(LENGTH_OFFSET, 16, 9);
	flag_bitmask(BUS_CYCLE_WAIT, 25);
	flag_bitmask(BUS_CYCLE_INDEX, 26);
	flag_bitmask(BUS_CYCLE_STOP, 27);
	flag_bitmask(SW_RDY, 30);
	flag_bitmask(SW_CLR_INT, 31);
};
struct GMBUS2 : ihd_gfx_reg_s<GMBUS2> {
	using ihd_gfx_reg_s<GMBUS2>::operator=;
	static constexpr uint32_t offset = 0xC5108;
	flag_bitmask(GMBUS_ACTIVE, 9);
	flag_bitmask(NAK, 10);
	flag_bitmask(HW_RDY, 11);
};
struct GMBUS3 : ihd_gfx_reg_s<GMBUS3> {
	using ihd_gfx_reg_s<GMBUS3>::operator=;
	static constexpr uint32_t offset = 0xC510c;
};
struct DPLL_CFGCR1 : ihd_gfx_reg_d<DPLL_CFGCR1> {
	using ihd_gfx_reg_d<DPLL_CFGCR1>::operator=;
	constexpr DPLL_CFGCR1(DPLL dpll) : ihd_gfx_reg_d<DPLL_CFGCR1>(0x6c040 + ((uint32_t)dpll * 8) - 8) {
		kassert(ALWAYS_ACTIVE, ERROR, dpll != DPLL::DPLL0, "Register does not exist.");
	}
	int_bitmask(DCO_INTEGER, 0, 8);
	int_bitmask(DCO_FRACTION, 8, 15);
	flag_bitmask(FREQUENCY_ENABLE, 31);
};
struct DPLL_CFGCR2 : ihd_gfx_reg_d<DPLL_CFGCR2> {
	using ihd_gfx_reg_d<DPLL_CFGCR2>::operator=;
	constexpr DPLL_CFGCR2(DPLL dpll) : ihd_gfx_reg_d<DPLL_CFGCR2>(0x6c044 + ((uint32_t)dpll * 8) - 8) {
		kassert(ALWAYS_ACTIVE, ERROR, dpll != DPLL::DPLL0, "Register does not exist.");
	}
	enum_bitmask(CENTRAL_FREQUENCY, 0, 2, FREQ_9600MHz, FREQ_9000MHz, FREQ_8400MHz = 3);
	enum_bitmask(PDIV, 2, 3, PDIV_1, PDIV_2, PDIV_3, PDIV_7 = 4);
	enum_bitmask(KDIV, 5, 2, KDIV_5, KDIV_2, KDIV_3, KDIV_1);
	flag_bitmask(QDIV_ENABLE, 7);
	int_bitmask(QDIV, 8, 8);
};
struct DPLL_CTRL1 : ihd_gfx_reg_s<DPLL_CTRL1> {
	using ihd_gfx_reg_s<DPLL_CTRL1>::operator=;
	static constexpr uint32_t offset = 0x6c058;
	flag_bitmask(DPLL0_ENABLE, 0);
	enum_bitmask(DPLL0_LINK_RATE, 1, 3, LR_2700MHz, LR_1350MHz, LR_810MHz, LR_1620MHz, LR_1080MHz, LR_2160MHz);
	flag_bitmask(DPLL1_ENABLE, 6);
	int_bitmask(DPLL1_LINK_RATE, 7, 3);
	flag_bitmask(DPLL1_SSC_ENABLE, 10);
	enum_bitmask(DPLL1_HDMI_MODE, 11, 1, DP, HDMI);
	flag_bitmask(DPLL2_ENABLE, 12);
	int_bitmask(DPLL2_LINK_RATE, 13, 3);
	flag_bitmask(DPLL2_SSC_ENABLE, 16);
	flag_bitmask(DPLL2_HDMI_MODE, 17);
	flag_bitmask(DPLL3_ENABLE, 18);
	int_bitmask(DPLL3_LINK_RATE, 19, 3);
	flag_bitmask(DPLL3_SSC_ENABLE, 22);
	flag_bitmask(DPLL3_HDMI_MODE, 23);
};
struct DPLL_CTRL2 : ihd_gfx_reg_s<DPLL_CTRL2> {
	using ihd_gfx_reg_s<DPLL_CTRL2>::operator=;
	static constexpr uint32_t offset = 0x6c05c;
	flag_bitmask(DDIA_SELECT_OVERRIDE, 0);
	enum_bitmask(DDIA_SELECT, 1, 2, DPLL0, DPLL1, DPLL2, DPLL3);
	flag_bitmask(DDIB_SELECT_OVERRIDE, 3);
	int_bitmask(DDIB_SELECT, 4, 2);
	flag_bitmask(DDIC_SELECT_OVERRIDE, 6);
	int_bitmask(DDIC_SELECT, 7, 2);
	flag_bitmask(DDID_SELECT_OVERRIDE, 9);
	int_bitmask(DDID_SELECT, 10, 2);
	flag_bitmask(DDIE_SELECT_OVERRIDE, 12);
	int_bitmask(DDIE_SELECT, 13, 2);
	flag_bitmask(DDIA_CLK_OFF, 15);
	flag_bitmask(DDIB_CLK_OFF, 16);
	flag_bitmask(DDIC_CLK_OFF, 17);
	flag_bitmask(DDID_CLK_OFF, 18);
	flag_bitmask(DDIE_CLK_OFF, 19);
};
struct DPLL_STATUS : ihd_gfx_reg_s<DPLL_STATUS> {
	using ihd_gfx_reg_s<DPLL_STATUS>::operator=;
	static constexpr uint32_t offset = 0x6c060;
	flag_bitmask(DPLL0_LOCKED, 0);
	flag_bitmask(DPLL0_SEM, 4);
	flag_bitmask(DPLL1_LOCKED, 8);
	flag_bitmask(DPLL1_SEM, 12);
	flag_bitmask(DPLL2_LOCKED, 16);
	flag_bitmask(DPLL2_SEM, 20);
	flag_bitmask(DPLL3_LOCKED, 24);
	flag_bitmask(DPLL3_SEM, 28);
};
// Actually LCPLL_CTL and WRPLL_CTL
struct DPLL_CTL : ihd_gfx_reg_d<DPLL_CTL> {
	using ihd_gfx_reg_d<DPLL_CTL>::operator=;
	constexpr DPLL_CTL(DPLL dpll)
		: ihd_gfx_reg_d<DPLL_CTL>(array(0x46010, 0x46014, 0x46040, 0x46060)[(uint32_t)dpll]) {}
	flag_bitmask(ENABLE, 31);
};

struct VGA_CONTROL : ihd_gfx_reg_s<VGA_CONTROL> {
	using ihd_gfx_reg_s<VGA_CONTROL>::operator=;
	static constexpr uint32_t offset = 0x41000;
	flag_bitmask(DISABLE, 31);
};

namespace REG {
enum REG : uint32_t {
	VGA_MSR_READ = 0x003cc,
	VGA_MSR_WRITE = 0x003c2,
	VGA_SR00 = 0x003c4,
	VGA_SR01 = 0x003c5,

	//RING_BUFFER_TAIL = 0x02030,
	//RING_BUFFER_HEAD = 0x02034,
	//RING_BUFFER_START = 0x02038,
	//RING_BUFFER_CTL = 0x0203C,

	CDCLK_CTL = 0x46000,
	SPLL_CTL = 0x46020,
	WRPLL_CTL = 0x46040,
	PORT_CLK_SEL = 0x46110, // DDI E

	SBI_ADDR = 0xC6000,
	SBI_DATA = 0xC6004,
	SBI_CTL_STAT = 0xC6008,
};
}

namespace BIT {
namespace SBI_CTL_STAT {
enum SBI_CTL_STAT : uint32_t {
	BUSY = (1 << 0),
	IO_READ = (2 << 8),
	IO_WRITE = (3 << 8),
	CR_READ = (6 << 8),
	CR_WRITE = (7 << 8),
	DEST_MPHY = (1 << 16),
};
}
}

struct [[gnu::packed]] EDID_t {
	uint64_t header;
	uint16_t mfr_id;
	uint16_t product_code;
	uint32_t serial_number;
	uint8_t week_manufacture;
	uint8_t year_manufacture;
	uint16_t edid_version;
	uint8_t video_interface;
	uint8_t screen_width;
	uint8_t screen_height;
	uint8_t gamma;
	uint8_t features;
	uint8_t color[10];
	uint8_t established_timings[3];
	struct {
		uint8_t resolution;
		uint8_t frequency_aspect;
	} standardTimings[8];
	struct {
		uint16_t pixel_clock_10khz;
		uint8_t h_active;
		uint8_t h_blank;
		uint8_t h_active_blank_upper;
		uint8_t v_active;
		uint8_t v_blank;
		uint8_t v_active_blank_upper;
		uint8_t h_front_porch;
		uint8_t h_sync_pulse;
		uint8_t v_front_porch_sync_pulse;
		uint8_t many_bits;
		uint8_t h_image_size;
		uint8_t v_image_size;
		uint8_t image_size_upper;
		uint8_t h_border;
		uint8_t v_border;
		uint8_t features;
	} detail_timings[4];
	uint8_t numExtensions;
	uint8_t checksum;
};
}

struct direction_timings {
	uint32_t active;
	uint32_t sync_start;
	uint32_t sync_end;
	uint32_t total;
};
struct display_timings {
	uint32_t pixel_clock;
	direction_timings horizontal;
	direction_timings vertical;
};
struct pll_params {
	int n, m1, m2, p1, p2;
	int computeDot(int refclock) {
		int p = p1 * p2;
		return (computeVco(refclock) + p / 2) / p;
	}

	int computeVco(int refclock) {
		auto m = computeM();
		return (refclock * m + (n + 2) / 2) / (n + 2);
	}

	int computeM() { return 5 * (m1 + 2) + (m2 + 2); }

	int computeP() { return p1 * p2; }
};

struct framebuffer {
	uint32_t w, h, stride;
	span<uint32_t> buffer;
};

struct ihd_gfx_device {
	uint64_t mmio_base;
	uint64_t gtt_base;

	IHD::DDI active_port;
	IHD::TRANSCODER active_transcoder;
	IHD::DPLL active_dpll;

	display_timings timings;
	framebuffer buf;
};

void ihd_gfx_init(pci_device& ihd_pci);
void ihd_gfx_modeset();
void ihd_set_pix(uint32_t x, uint32_t y, uint32_t color);