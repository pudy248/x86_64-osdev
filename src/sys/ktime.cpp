#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/allocators/heap.hpp>
#include <lib/allocators/slab_pagemap.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/array.hpp>
#include <stl/container.hpp>
#include <sys/global.hpp>
#include <sys/ktime.hpp>

struct register_file;

void inc_pit(uint64_t, register_file* regs) {
	globals->elapsedPITs = globals->elapsedPITs + 1;
	//Print diagnostics
	if (0) {
		int x, l;
		array<char, 20> arr;
		x = globals->g_console->text_rect[2] - 1;
		l = formats(arr.begin(), "    W %i", globals->global_waterline.mem_used());
		for (int i = l - 1; i >= 0; --i)
			globals->g_console->set_char(x--, 0, arr[i]);

		x = globals->g_console->text_rect[2] - 1;
		l = formats(arr.begin(), "    S %i", globals->global_pagemap.mem_used());
		for (int i = l - 1; i >= 0; --i)
			globals->g_console->set_char(x--, 1, arr[i]);

		x = globals->g_console->text_rect[2] - 1;
		l = formats(arr.begin(), "    H %i", globals->global_heap.mem_used());
		for (int i = l - 1; i >= 0; --i)
			globals->g_console->set_char(x--, 2, arr[i]);

		//timepoint t = timepoint::pit_time();
		//x = globals->g_console->text_rect[2] - 1;
		//l = formats(arr, "%02i:%02i:%02i.%03i", t.hour, t.minute, t.second, (int)(t.micros / 1000));
		//for (int i = l - 1; i >= 0; --i)
		//    globals->g_console->set_char(x--, 3, arr[i]);

		globals->g_console->refresh();
	}
}

static const char* months[12] = {
	"January", "February", "March",		"April",   "May",	   "June",
	"July",	   "August",   "September", "October", "November", "December",
};

static uint8_t get_cmos_register(uint8_t reg) {
	outb(0x70, reg);
	return (uint8_t)inb(0x71);
}

static timepoint reference_timepoint;

void time_init(void) {
	reference_timepoint = timepoint::cmos_time();
	globals->elapsedPITs = 0;
}

timepoint timepoint::cmos_time() {
	timepoint t;
	while (get_cmos_register(0x0a) & 0x80)
		;
	t.year = get_cmos_register(0x9);
	t.month = get_cmos_register(0x8);
	t.day = get_cmos_register(0x7);
	t.hour = get_cmos_register(0x4);
	t.minute = get_cmos_register(0x2);
	t.second = get_cmos_register(0x0);

	if (1) { //get_cmos_register(0x0b) & 0x04
		t.second = (t.second & 0x0F) + ((t.second / 16) * 10);
		t.minute = (t.minute & 0x0F) + ((t.minute / 16) * 10);
		t.hour = ((t.hour & 0x0F) + (((t.hour & 0x70) / 16) * 10)) | (t.hour & 0x80);
		t.day = (t.day & 0x0F) + ((t.day / 16) * 10);
		t.month = (t.month & 0x0F) + ((t.month / 16) * 10);
		t.year = (t.year & 0x0F) + ((t.year / 16) * 10);
	}
	return t;
}

static timepoint pit_time_override(uint32_t subcnt) {
	timepoint t;
	uint64_t cnt = (uint64_t)((int64_t)globals->elapsedPITs * 65536 + subcnt);
	uint64_t micros_total = cnt * 1000000LLU / 1193182LLU;

	uint64_t newSecond = micros_total / 1000000LLU;
	uint32_t newMinute = newSecond / 60;
	uint32_t newHour = newMinute / 60;
	t.micros = micros_total % 1000000LLU;
	t.second = newSecond % 60;
	t.minute = newMinute % 60;
	t.hour = newHour % 24;
	t.day = newHour / 24;

	return t;
}

timepoint timepoint::pit_time() {
	uint32_t subcnt = inb(0x40);
	subcnt |= ((uint32_t)inb(0x40)) << 8;
	subcnt = 65536 - subcnt;
	return pit_time_override(subcnt);
}

timepoint timepoint::pit_time_imprecise() {
	return pit_time_override(0);
}

double timepoint::unix_seconds() {
	double unixsecs = micros / 1000000.0 + second + minute * 60 + hour * 3600 + hour * 24 * 3600;
	return unixsecs;
}

void tsc_delay(uint64_t cycles) {
	uint64_t start = rdtsc();
	while (rdtsc() - start < cycles)
		;
}

void pit_delay(double seconds) {
	double start = timepoint::pit_time().unix_seconds();
	while (timepoint::pit_time().unix_seconds() - start < seconds)
		;
}

/*
void print_lres_timepoint(lres_timepoint rtc, int fmt) {
    switch(fmt) {
        case 0: printf("%s %i, 20%02i - %02i:%02i:%02i\n", months[rtc.month], rtc.day, rtc.year, rtc.hour, rtc.minute, rtc.second); break;
        case 1: printf("%02i/%02i/%02i %02i:%02i", rtc.month, rtc.day, rtc.year, rtc.hour, rtc.minute); break;
        case 2: printf("%02i:%02i:%02i", rtc.hour, rtc.minute, rtc.second); break;
    }
}*/

int clockspeed_MHz() {
	double t1 = timepoint::pit_time().unix_seconds();
	uint64_t stsc = rdtsc();
	tsc_delay(0x1000000LLU);
	double t2 = timepoint::pit_time().unix_seconds();
	long etsc = rdtsc();

	double eSec = (t2 - t1);
	double freqMHz = (double)(etsc - stsc) / eSec / 1000000;
	printf("%iMHz (%li cycles in %ius)\n", (uint32_t)freqMHz, etsc - stsc, (uint32_t)(eSec * 1000000));
	return freqMHz;
}