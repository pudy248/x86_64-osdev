#pragma once
#include "ihd.hpp"
#include <asm.hpp>
#include <cstdint>
#include <drivers/pci.hpp>
#include <drivers/register.hpp>
#include <kassert.hpp>
#include <kcstring.hpp>
#include <kfile.hpp>
#include <kstdio.hpp>
#include <lib/cmd/commands.hpp>
#include <stl/vector.hpp>
#include <sys/global.hpp>
#include <sys/ktime.hpp>
#include <sys/memory/paging.hpp>
#include <sys/types.h>

namespace IHD {
uint32_t ihd_reg_read(uint32_t address) { return *(volatile uint32_t*)(globals->ihd_gfx->mmio_base + address); }
void ihd_reg_write(uint32_t address, uint32_t value) {
	*(volatile uint32_t*)(globals->ihd_gfx->mmio_base + address) = value;
}

static uint32_t ihd_sbi_read(uint8_t tid, uint8_t reg) {
	ihd_reg_write(REG::SBI_ADDR, ((uint32_t)tid << 24) + ((uint32_t)reg << 16));
	ihd_reg_write(REG::SBI_CTL_STAT, BIT::SBI_CTL_STAT::CR_READ);
	while (ihd_reg_read(REG::SBI_CTL_STAT) & BIT::SBI_CTL_STAT::BUSY)
		io_wait();
	return ihd_reg_read(REG::SBI_DATA);
}
static void ihd_sbi_write(uint8_t tid, uint8_t reg, uint32_t value) {
	ihd_reg_write(REG::SBI_ADDR, ((uint32_t)tid << 24) + ((uint32_t)reg << 16));
	ihd_reg_write(REG::SBI_CTL_STAT, BIT::SBI_CTL_STAT::CR_WRITE);
	ihd_reg_write(REG::SBI_DATA, value);
	while (ihd_reg_read(REG::SBI_CTL_STAT) & BIT::SBI_CTL_STAT::BUSY)
		io_wait();
}

static vector<uint8_t> ihd_gmbus_read(DDI ddi, uint32_t address, uint8_t index, uint16_t size) {
	GMBUS1{} = GMBUS1::SW_CLR_INT;
	io_wait();
	GMBUS1{} = 0;
	io_wait();
	GMBUS0{} = ddi == DDI::B ? GMBUS0::DDIB : ddi == DDI::C ? GMBUS0::DDIC : GMBUS0::DDID;
	mmio_transaction trans{GMBUS1{}};
	trans.set(GMBUS1::SW_RDY);
	trans.set(GMBUS1::BUS_CYCLE_INDEX);
	trans.set(GMBUS1::BUS_CYCLE_WAIT);
	trans.write(GMBUS1::LENGTH_OFFSET, size);
	trans.write(GMBUS1::SLAVE_REGISTER_OFFSET, index);
	trans.write(GMBUS1::SLAVE_ADDR_OFFSET, address);
	trans.set(GMBUS1::SLAVE_READ);
	trans.commit();

	vector<uint8_t> output(size, vec_resize{});
	for (int i = 0; i < size; i += 4) {
		while (!GMBUS2{}.HW_RDY_v) {
			io_wait();
			if (GMBUS2{}.NAK_v) {
				print("GMBUS ERR\n");
				break;
			}
		}

		uint32_t bytes = GMBUS3{};

		output[i] = bytes & 0xFF;
		if (size > i + 1)
			output[i + 1] = (bytes >> 8) & 0xFF;
		if (size > i + 2)
			output[i + 2] = (bytes >> 16) & 0xFF;
		if (size > i + 3)
			output[i + 3] = (bytes >> 24) & 0xFF;
	}
	GMBUS1{} = GMBUS1::SW_RDY | GMBUS1::BUS_CYCLE_STOP;
	return output;
}
static display_timings parse_edid_timings(decltype(EDID_t::detail_timings[0]) t) {
	direction_timings ht = {};
	ht.active = t.h_active + ((uint32_t)(t.h_active_blank_upper >> 4) << 8);
	uint32_t h_blank = t.h_blank + ((uint32_t)(t.h_active_blank_upper & 0xf) << 8);
	uint32_t h_front_porch = t.h_front_porch + ((uint32_t)(t.many_bits >> 6) << 8);
	uint32_t h_sync_pulse = t.h_sync_pulse + ((uint32_t)((t.many_bits >> 4) & 0x3) << 8);
	ht.sync_start = ht.active + h_front_porch;
	ht.sync_end = ht.sync_start + h_sync_pulse;
	ht.total = ht.active + h_blank;

	direction_timings vt = {};
	vt.active = t.v_active + ((uint32_t)(t.v_active_blank_upper >> 4) << 8);
	uint32_t v_blank = t.v_blank + ((uint32_t)(t.v_active_blank_upper & 0xf) << 8);
	uint32_t v_front_porch = (t.v_front_porch_sync_pulse >> 4) + ((uint32_t)((t.many_bits >> 2) & 0x3) << 8);
	uint32_t v_sync_pulse = (t.v_front_porch_sync_pulse & 0xf) + ((uint32_t)(t.many_bits & 0x3) << 8);
	vt.sync_start = vt.active + v_front_porch;
	vt.sync_end = vt.sync_start + v_sync_pulse;
	vt.total = vt.active + v_blank;
	return {t.pixel_clock_10khz * 10u, ht, vt};
}

static void get_active_port() {
	for (DDI port : {DDI::A, DDI::B, DDI::C, DDI::D, DDI::E}) {
		if (DDI_BUF_CTL{port}.ENABLE_v) {
			globals->ihd_gfx->active_port = port;
			break;
		}
	}
	printf("Active port %i\n", globals->ihd_gfx->active_port);
}
static void get_active_transcoder() {
	for (TRANSCODER trans : {TRANSCODER::A, TRANSCODER::B, TRANSCODER::C, TRANSCODER::WD0, TRANSCODER::EDP}) {
		if (TRANS_CONF{trans}.ENABLE_v) {
			globals->ihd_gfx->active_transcoder = trans;
			break;
		}
	}
	printf("Active transcoder %i\n", globals->ihd_gfx->active_transcoder);
}
static void get_active_dpll() {
	for (DPLL dpll : {DPLL::DPLL1, DPLL::DPLL2, DPLL::DPLL3}) {
		if (DPLL_CFGCR1{dpll}.FREQUENCY_ENABLE_v) {
			globals->ihd_gfx->active_dpll = dpll;
			break;
		}
	}
	printf("Active dpll %i\n", globals->ihd_gfx->active_dpll);
}

static void disable_vga() {
	outb(REG::VGA_MSR_WRITE, inb(REG::VGA_MSR_READ) & ~2);
	outb(REG::VGA_SR00, 1);
	outb(REG::VGA_SR01, 0x20);
	delay(units::microseconds(100));
	VGA_CONTROL{}.DISABLE_v = 1;
}
static void disable_plane() { PLANE_CTL_1_A{}.ENABLE_v = 0; }
static void disable_transcoder() {
	TRANS_CONF{globals->ihd_gfx->active_transcoder}.ENABLE_v = 0;
	while (TRANS_CONF{globals->ihd_gfx->active_transcoder}.STATE_v)
		io_wait();
	TRANS_DDI_FUNC_CTL{globals->ihd_gfx->active_transcoder}.ENABLE_v = 0;
	TRANS_DDI_FUNC_CTL{globals->ihd_gfx->active_transcoder}.DDI_SEL_v = 0;
}
static void disable_port_scaler() {
	PS_CTRL_1_A{} = 0;
	PS_WIN_SZ_1_A{} = 0;
	PS_CTRL_2_A{} = 0;
	PS_WIN_SZ_1_B{} = 0;
	PS_CTRL_1_B{} = 0;
	PS_WIN_SZ_1_B{} = 0;
	PS_CTRL_2_B{} = 0;
	PS_WIN_SZ_2_B{} = 0;
	PS_CTRL_1_C{} = 0;
	PS_WIN_SZ_1_C{} = 0;
}
static void disable_trans_clock() { TRANS_CLK_SEL{globals->ihd_gfx->active_transcoder} = 0; }
static void disable_port() { DDI_BUF_CTL{globals->ihd_gfx->active_port}.ENABLE_v = 0; }
static void disable_dpll() {
	switch (globals->ihd_gfx->active_port) {
	case DDI::A: DPLL_CTRL2{}.DDIA_CLK_OFF_v = 1; break;
	case DDI::B: DPLL_CTRL2{}.DDIB_CLK_OFF_v = 1; break;
	case DDI::C: DPLL_CTRL2{}.DDIC_CLK_OFF_v = 1; break;
	case DDI::D: DPLL_CTRL2{}.DDID_CLK_OFF_v = 1; break;
	case DDI::E: DPLL_CTRL2{}.DDIE_CLK_OFF_v = 1; break;
	}
	switch (globals->ihd_gfx->active_dpll) {
	case DPLL::DPLL0:
		DPLL_CTRL1{}.DPLL0_ENABLE_v = 0;
		DPLL_CTL{DPLL::DPLL0}.ENABLE_v = 0;
		break;
	case DPLL::DPLL1:
		DPLL_CTRL1{}.DPLL1_ENABLE_v = 0;
		DPLL_CFGCR1{DPLL::DPLL1}.FREQUENCY_ENABLE_v = 0;
		DPLL_CTL{DPLL::DPLL1}.ENABLE_v = 0;
		break;
	case DPLL::DPLL2:
		DPLL_CTRL1{}.DPLL2_ENABLE_v = 0;
		DPLL_CFGCR1{DPLL::DPLL2}.FREQUENCY_ENABLE_v = 0;
		DPLL_CTL{DPLL::DPLL2}.ENABLE_v = 0;
		break;
	case DPLL::DPLL3:
		DPLL_CTRL1{}.DPLL3_ENABLE_v = 0;
		DPLL_CFGCR1{DPLL::DPLL3}.FREQUENCY_ENABLE_v = 0;
		DPLL_CTL{DPLL::DPLL3}.ENABLE_v = 0;
		break;
	}
}

static void configure_dpll_dry_run(uint32_t pixel_clock) {
	constexpr uint32_t even_dividers[] = {4, 6, 8, 10, 12, 14, 16, 18, 20, 24, 28, 30, 32, 36, 40, 42, 44, 48, 52, 54,
		56, 60, 64, 66, 68, 70, 72, 76, 78, 80, 84, 88, 90, 92, 96, 98};
	// constexpr uint32_t odd_dividers[] = {3, 5, 7, 9, 15, 21, 35};
	constexpr uint32_t dco_central_freqs[] = {9600000, 9000000, 8400000};
	double afe_clock = 5 * pixel_clock;
	double best_deviation = 1;
	double best_dco_freq = 0;
	uint32_t best_divider = 0;
	uint32_t best_dco_central_freq = 0;
	for (uint32_t divider : even_dividers) {
		for (uint32_t dco_central_freq : dco_central_freqs) {
			double dco_freq = divider * afe_clock;
			if ((dco_freq - dco_central_freq) / dco_central_freq < -0.06 ||
				(dco_freq - dco_central_freq) / dco_central_freq > 0.01)
				continue;
			double deviation = abs((dco_freq - dco_central_freq) / dco_central_freq);
			if (deviation < best_deviation) {
				best_deviation = deviation;
				best_dco_freq = dco_freq;
				best_dco_central_freq = dco_central_freq;
				best_divider = divider;
			}
		}
	}
	uint32_t p0 = 0, p1 = 0, p2 = 0;
	best_divider = best_divider / 2;
	if (best_divider == 1 || best_divider == 2 || best_divider == 3 || best_divider == 5) {
		p0 = 2;
		p1 = 1;
		p2 = best_divider;
	} else if (best_divider % 2 == 0) // Div by 4
	{
		p0 = 2;
		p1 = best_divider / 2;
		p2 = 2;
	} else if (best_divider % 3 == 0) // Div by 6
	{
		p0 = 3;
		p1 = best_divider / 3;
		p2 = 2;
	} else if (best_divider % 7 == 0) // Div by 14
	{
		p0 = 7;
		p1 = best_divider / 7;
		p2 = 2;
	}

	uint32_t dco_integer = best_dco_freq / 24000;
	uint32_t dco_fractional = (best_dco_freq / 24000 - dco_integer) * 65536;
	printf("%f %f %i %i\n", best_dco_freq, best_deviation, best_divider, best_dco_central_freq);

	printf("%i %i %i\n", p0, p1, p2);
	printf("%i %i\n", dco_integer, dco_fractional);
}

static void configure_dpll(uint32_t pixel_clock) {
	constexpr uint32_t even_dividers[] = {4, 6, 8, 10, 12, 14, 16, 18, 20, 24, 28, 30, 32, 36, 40, 42, 44, 48, 52, 54,
		56, 60, 64, 66, 68, 70, 72, 76, 78, 80, 84, 88, 90, 92, 96, 98};
	// constexpr uint32_t odd_dividers[] = {3, 5, 7, 9, 15, 21, 35};
	constexpr uint32_t dco_central_freqs[] = {9600000, 9000000, 8400000};
	double afe_clock = 5 * pixel_clock;
	double best_deviation = 1;
	double best_dco_freq = 0;
	uint32_t best_divider = 0;
	uint32_t best_dco_central_freq = 0;
	for (uint32_t divider : even_dividers) {
		for (uint32_t dco_central_freq : dco_central_freqs) {
			double dco_freq = divider * afe_clock;
			if ((dco_freq - dco_central_freq) / dco_central_freq < -0.06 ||
				(dco_freq - dco_central_freq) / dco_central_freq > 0.01)
				continue;
			double deviation = abs((dco_freq - dco_central_freq) / dco_central_freq);
			if (deviation < best_deviation) {
				best_deviation = deviation;
				best_dco_freq = dco_freq;
				best_dco_central_freq = dco_central_freq;
				best_divider = divider;
			}
		}
	}
	uint32_t p0 = 0, p1 = 0, p2 = 0;
	best_divider = best_divider / 2;
	if (best_divider == 1 || best_divider == 2 || best_divider == 3 || best_divider == 5) {
		p0 = 2;
		p1 = 1;
		p2 = best_divider;
	} else if (best_divider % 2 == 0) // Div by 4
	{
		p0 = 2;
		p1 = best_divider / 2;
		p2 = 2;
	} else if (best_divider % 3 == 0) // Div by 6
	{
		p0 = 3;
		p1 = best_divider / 3;
		p2 = 2;
	} else if (best_divider % 7 == 0) // Div by 14
	{
		p0 = 7;
		p1 = best_divider / 7;
		p2 = 2;
	}

	uint32_t dco_integer = best_dco_freq / 24000;
	uint32_t dco_fractional = (best_dco_freq / 24000 - dco_integer) * 65536;
	printf("%f %f %i %i\n", best_dco_freq, best_deviation, best_divider, best_dco_central_freq);

	printf("%i %i %i\n", p0, p1, p2);
	printf("%i %i\n", dco_integer, dco_fractional);

	// globals->ihd_gfx->active_dpll = DPLL::DPLL1;

	DPLL_CFGCR1{globals->ihd_gfx->active_dpll}.FREQUENCY_ENABLE_v = 1;
	switch (globals->ihd_gfx->active_dpll) {
	case DPLL::DPLL0: DPLL_CTRL1{}.DPLL0_ENABLE_v = 1; break;
	case DPLL::DPLL1:
		DPLL_CTRL1{}.DPLL1_ENABLE_v = 1;
		DPLL_CTRL1{}.DPLL1_SSC_ENABLE_v = 0;
		DPLL_CTRL1{}.DPLL1_HDMI_MODE_v = DPLL_CTRL1::HDMI;
		break;
	case DPLL::DPLL2:
		DPLL_CTRL1{}.DPLL2_ENABLE_v = 1;
		DPLL_CTRL1{}.DPLL2_SSC_ENABLE_v = 0;
		DPLL_CTRL1{}.DPLL2_HDMI_MODE_v = DPLL_CTRL1::HDMI;
		break;
	case DPLL::DPLL3:
		DPLL_CTRL1{}.DPLL3_ENABLE_v = 1;
		DPLL_CTRL1{}.DPLL3_SSC_ENABLE_v = 0;
		DPLL_CTRL1{}.DPLL3_HDMI_MODE_v = DPLL_CTRL1::HDMI;
		break;
	}

	DPLL_CFGCR1{globals->ihd_gfx->active_dpll}.DCO_INTEGER_v = dco_integer;
	DPLL_CFGCR1{globals->ihd_gfx->active_dpll}.DCO_FRACTION_v = dco_fractional;

	DPLL_CFGCR2{globals->ihd_gfx->active_dpll}.CENTRAL_FREQUENCY_v =
		best_dco_central_freq == 9600000 ? DPLL_CFGCR2::FREQ_9600MHz :
		best_dco_central_freq == 9000000 ? DPLL_CFGCR2::FREQ_9000MHz :
										   DPLL_CFGCR2::FREQ_8400MHz;
	DPLL_CFGCR2{globals->ihd_gfx->active_dpll}.PDIV_v = p0 == 7 ? DPLL_CFGCR2::PDIV_7 :
														p0 == 3 ? DPLL_CFGCR2::PDIV_3 :
														p0 == 2 ? DPLL_CFGCR2::PDIV_2 :
																  DPLL_CFGCR2::PDIV_1;
	DPLL_CFGCR2{globals->ihd_gfx->active_dpll}.KDIV_v = p2 == 5 ? DPLL_CFGCR2::KDIV_5 :
														p2 == 3 ? DPLL_CFGCR2::KDIV_3 :
														p2 == 2 ? DPLL_CFGCR2::KDIV_2 :
																  DPLL_CFGCR2::KDIV_1;
	if (p2 != 1) {
		DPLL_CFGCR2{globals->ihd_gfx->active_dpll}.QDIV_ENABLE_v = 1;
		DPLL_CFGCR2{globals->ihd_gfx->active_dpll}.QDIV_v = p1;
	}

	DPLL_CTL{globals->ihd_gfx->active_dpll}.ENABLE_v = 1;

	switch (globals->ihd_gfx->active_dpll) {
	case DPLL::DPLL0:
		while (!DPLL_STATUS{}.DPLL0_LOCKED_v)
			thread_yield();
		break;
	case DPLL::DPLL1:
		while (!DPLL_STATUS{}.DPLL1_LOCKED_v)
			thread_yield();
		break;
	case DPLL::DPLL2:
		while (!DPLL_STATUS{}.DPLL2_LOCKED_v)
			thread_yield();
		break;
	case DPLL::DPLL3:
		while (!DPLL_STATUS{}.DPLL3_LOCKED_v)
			thread_yield();
		break;
	}

	switch (globals->ihd_gfx->active_port) {
	case DDI::A:
		DPLL_CTRL2{}.DDIA_SELECT_OVERRIDE_v = 1;
		DPLL_CTRL2{}.DDIA_SELECT_v = (uint32_t)globals->ihd_gfx->active_dpll;
		DPLL_CTRL2{}.DDIA_CLK_OFF_v = 0;
		break;
	case DDI::B:
		DPLL_CTRL2{}.DDIB_SELECT_OVERRIDE_v = 1;
		DPLL_CTRL2{}.DDIB_SELECT_v = (uint32_t)globals->ihd_gfx->active_dpll;
		DPLL_CTRL2{}.DDIB_CLK_OFF_v = 0;
		break;
	case DDI::C:
		DPLL_CTRL2{}.DDIC_SELECT_OVERRIDE_v = 1;
		DPLL_CTRL2{}.DDIC_SELECT_v = (uint32_t)globals->ihd_gfx->active_dpll;
		DPLL_CTRL2{}.DDIC_CLK_OFF_v = 0;
		break;
	case DDI::D:
		DPLL_CTRL2{}.DDID_SELECT_OVERRIDE_v = 1;
		DPLL_CTRL2{}.DDID_SELECT_v = (uint32_t)globals->ihd_gfx->active_dpll;
		DPLL_CTRL2{}.DDID_CLK_OFF_v = 0;
		break;
	case DDI::E:
		DPLL_CTRL2{}.DDIE_SELECT_OVERRIDE_v = 1;
		DPLL_CTRL2{}.DDIE_SELECT_v = (uint32_t)globals->ihd_gfx->active_dpll;
		DPLL_CTRL2{}.DDIE_CLK_OFF_v = 0;
		break;
	}
	switch (globals->ihd_gfx->active_port) {
	case DDI::B: TRANS_CLK_SEL{globals->ihd_gfx->active_transcoder}.CLK_SEL_v = TRANS_CLK_SEL::DDIB; break;
	case DDI::C: TRANS_CLK_SEL{globals->ihd_gfx->active_transcoder}.CLK_SEL_v = TRANS_CLK_SEL::DDIC; break;
	case DDI::D: TRANS_CLK_SEL{globals->ihd_gfx->active_transcoder}.CLK_SEL_v = TRANS_CLK_SEL::DDID; break;
	case DDI::E: TRANS_CLK_SEL{globals->ihd_gfx->active_transcoder}.CLK_SEL_v = TRANS_CLK_SEL::DDIE; break;
	default: kassert(ALWAYS_ACTIVE, ERROR, false, "Unsupported port.");
	}
}

static void configure_gtt() {
	uint64_t pmem = (uint64_t)virt2phys(
		mmap(nullptr, (uint64_t)globals->ihd_gfx->buf.stride * globals->ihd_gfx->buf.h, MAP_CONTIGUOUS));
	page_t* gtt = (page_t*)globals->ihd_gfx->gtt_base;
	for (uint32_t i = 0; i < ((uint64_t)globals->ihd_gfx->buf.stride * globals->ihd_gfx->buf.h) >> 12; i++)
		gtt[i] = page_t(pmem + (i << 12), PAGE_P);
}

static void configure_plane() {
	PLANE_POS_1_A{} = 0;
	PLANE_OFFSET_1_A{} = 0;
	PLANE_SIZE_1_A{} = PLANE_SIZE_1_A::SIZE_X(globals->ihd_gfx->buf.w - 1) |
					   PLANE_SIZE_1_A::SIZE_Y(globals->ihd_gfx->buf.h - 1);
	PIPE_SRCSZ_A{} = PIPE_SRCSZ_A::SRC_WIDTH(globals->ihd_gfx->buf.w - 1) |
					 PIPE_SRCSZ_A::SRC_HEIGHT(globals->ihd_gfx->buf.h - 1);
	PLANE_STRIDE_1_A{} = PLANE_STRIDE_1_A::STRIDE((globals->ihd_gfx->buf.stride + 63) / 64);
	PLANE_SURF_1_A{} = 0;
	PLANE_CTL_1_A{}.SOURCE_PFMT_v = PLANE_CTL_1_A::RGB8888;

	WM_LINETIME_A{}.LINETIME_v = (8 * globals->ihd_gfx->buf.w) / globals->ihd_gfx->timings.pixel_clock / 1000;
	//PLANE_WM_1_A{}.BLOCKS_v = 152;
	//PLANE_WM_1_A{}.LINES_v = 2;

	PLANE_CTL_1_A{}.ENABLE_v = 1;
}

static void configure_transcoder() {
	TRANS_HTOTAL{globals->ihd_gfx->active_transcoder} =
		TRANS_HTOTAL::HACTIVE(globals->ihd_gfx->timings.horizontal.active - 1) |
		TRANS_HTOTAL::HTOTAL(globals->ihd_gfx->timings.horizontal.total - 1);
	TRANS_HBLANK{globals->ihd_gfx->active_transcoder} =
		TRANS_HBLANK::HBLANK_START(globals->ihd_gfx->timings.horizontal.active - 1) |
		TRANS_HBLANK::HBLANK_END(globals->ihd_gfx->timings.horizontal.total - 1);
	TRANS_HSYNC{globals->ihd_gfx->active_transcoder} =
		TRANS_HSYNC::HSYNC_START(globals->ihd_gfx->timings.horizontal.sync_start - 1) |
		TRANS_HSYNC::HSYNC_END(globals->ihd_gfx->timings.horizontal.sync_end - 1);

	TRANS_VTOTAL{globals->ihd_gfx->active_transcoder} =
		TRANS_VTOTAL::VACTIVE(globals->ihd_gfx->timings.vertical.active - 1) |
		TRANS_VTOTAL::VTOTAL(globals->ihd_gfx->timings.vertical.total - 1);
	TRANS_VBLANK{globals->ihd_gfx->active_transcoder} =
		TRANS_VBLANK::VBLANK_START(globals->ihd_gfx->timings.vertical.active - 1) |
		TRANS_VBLANK::VBLANK_END(globals->ihd_gfx->timings.vertical.total - 1);
	TRANS_VSYNC{globals->ihd_gfx->active_transcoder} =
		TRANS_VSYNC::VSYNC_START(globals->ihd_gfx->timings.vertical.sync_start - 1) |
		TRANS_VSYNC::VSYNC_END(globals->ihd_gfx->timings.vertical.sync_end - 1);

	mmio_transaction trans{TRANS_DDI_FUNC_CTL{globals->ihd_gfx->active_transcoder}};
	trans.set(TRANS_DDI_FUNC_CTL::HSYNC_HIGH);
	trans.set(TRANS_DDI_FUNC_CTL::VSYNC_HIGH);
	trans.write(TRANS_DDI_FUNC_CTL::BPC, TRANS_DDI_FUNC_CTL::BPC8);
	//trans.write(TRANS_DDI_FUNC_CTL::DDI_MODE, TRANS_DDI_FUNC_CTL::DVI);
	trans.write(TRANS_DDI_FUNC_CTL::DDI_SEL, (int)globals->ihd_gfx->active_port);
	trans.set(TRANS_DDI_FUNC_CTL::ENABLE);
	trans.commit();

	TRANS_CONF{globals->ihd_gfx->active_transcoder}.ENABLE_v = 1;
}

static void configure_port() { DDI_BUF_CTL{globals->ihd_gfx->active_port}.ENABLE_v = 1; }
}

using namespace IHD;

void ihd_gfx_init(pci_device& ihd_pci) {
	globals->ihd_gfx = decltype(globals->ihd_gfx)::make_nocopy(waterline_new<ihd_gfx_device>());
	globals->ihd_gfx->mmio_base = 0x400000;
	globals->ihd_gfx->gtt_base = 0x600000;
	mmap2(globals->ihd_gfx->mmio_base, ihd_pci.bars[0] & 0xfffffff0, 0x100000, MAP_UNCACHEABLE | MAP_PINNED);
	file_t f1 = fs::open("/pci1.ids");
	file_t f2 = fs::open("/pci2.ids");

	pci_id ids = pci_lookup(f1.rodata(), f2.rodata(), ihd_pci);
	printf("Intel GFX device: %S\n", &ids.device);
	printf("Using Intel HD MMIO at %08x=>%08x\n", ihd_pci.bars[0], globals->ihd_gfx->mmio_base);

	get_active_port();
	get_active_transcoder();
	get_active_dpll();

	vector<uint8_t> dat = ihd_gmbus_read(globals->ihd_gfx->active_port, 0x50, 0, 0x80);
	EDID_t edid = *(EDID_t*)dat.data();
	display_timings timings = parse_edid_timings(edid.detail_timings[0]);
	printf("clk %i\n", timings.pixel_clock);
	printf("h %i %i %i %i\n", timings.horizontal.total, timings.horizontal.active, timings.horizontal.sync_start,
		timings.horizontal.sync_end);
	printf("v %i %i %i %i\n", timings.vertical.total, timings.vertical.active, timings.vertical.sync_start,
		timings.vertical.sync_end);
	framebuffer buf = {timings.horizontal.active, timings.vertical.active, timings.horizontal.active * 4, nullptr};
	buf.buffer = span<uint32_t>(mmap(ihd_pci.bars[2] & 0xfffffff0, buf.h * buf.stride, MAP_IDENTITY), buf.h * buf.w);
	printf("buf %p stride %i\n", buf.buffer.begin(), buf.stride);
	globals->ihd_gfx->timings = timings;
	globals->ihd_gfx->buf = buf;
	configure_dpll_dry_run(globals->ihd_gfx->timings.pixel_clock);
}
void ihd_gfx_modeset() {
	disable_vga();
	disable_plane();
	disable_transcoder();
	disable_port_scaler();
	disable_port();
	disable_trans_clock();
	disable_dpll();

	delay(units::milliseconds(50)); // probably not needed, who knows

	configure_dpll(globals->ihd_gfx->timings.pixel_clock);
	configure_transcoder();
	configure_plane();
	configure_port();

	ranges::val::generate(globals->ihd_gfx->buf.buffer, [n = 0]() mutable {
		int y = n / globals->ihd_gfx->buf.w;
		int x = n % globals->ihd_gfx->buf.w;
		n++;
		if (y > 0.48 * globals->ihd_gfx->buf.h && y < 0.52 * globals->ihd_gfx->buf.h)
			return 0xffffffff;
		if (x > 0.48 * globals->ihd_gfx->buf.w && x < 0.52 * globals->ihd_gfx->buf.w)
			return 0xffffffff;
		return 0u;
	});

	print("Modeset done.\n");
}

int cmd_ihd_gfx_init(int, const ccstr_t*) {
	pci_device* dev = pci_match(3, 0, 0);
	kassert(
		ALWAYS_ACTIVE, TASK_EXCEPTION, dev && dev->vendor_id == 0x8086, "Intel HD Graphics PCI device not found!\n");
	ihd_gfx_init(*dev);
	return 0;
}

int cmd_ihd_gfx_modeset(int, const ccstr_t*) {
	ihd_gfx_modeset();
	return 0;
}
int cmd_gmbus_read(int argc, const ccstr_t* argv) {
	if (argc != 5) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t ddi = istringstream(argv[1]).read_x();
	uint64_t address = istringstream(argv[2]).read_x();
	uint64_t offset = istringstream(argv[3]).read_x();
	uint64_t size = istringstream(argv[4]).read_x();
	auto vec = ihd_gmbus_read((DDI)ddi, address, offset, size);
	hexdump(vec.data(), vec.size());
	return 0;
}

int cmd_sbi_read(int argc, const ccstr_t* argv) {
	if (argc != 3) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t tid = istringstream(argv[1]).read_x();
	uint64_t reg = istringstream(argv[1]).read_x();
	printf("%08x\n", ihd_sbi_read(tid, reg));
	return 0;
}
int cmd_sbi_write(int argc, const ccstr_t* argv) {
	if (argc != 4) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t tid = istringstream(argv[1]).read_x();
	uint64_t reg = istringstream(argv[1]).read_x();
	uint64_t val = istringstream(argv[1]).read_x();
	ihd_sbi_write(tid, reg, val);
	return 0;
}

void ihd_set_pix(uint32_t x, uint32_t y, uint32_t color) {
	((uint32_t*)ptr_offset(globals->ihd_gfx->buf.buffer.begin(), y * globals->ihd_gfx->buf.stride))[x] = color;
}