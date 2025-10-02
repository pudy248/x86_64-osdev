#include <asm.hpp>
#include <cstdint>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <stl/array.hpp>
#include <sys/fixed_global.hpp>
#include <sys/global.hpp>
#include <sys/ktime.hpp>
#include <sys/thread.hpp>
#include <text/console.hpp>
#include <text/text_display.hpp>

struct register_file;

bool do_pit_readout = false;

static bool reset_tsc = false;

void inc_pit(uint64_t, register_file* reg) {
	globals->elapsed_pits++;
	if (reset_tsc) [[unlikely]] {
		globals->reference_tsc = rdtsc();
		globals->elapsed_pits = 0;
		reset_tsc = false;
	}
	if (globals->elapsed_pits == 2) [[unlikely]]
		calibrate_frequency();
	if (globals->elapsed_pits == 10) [[unlikely]]
		calibrate_frequency();
	if (globals->elapsed_pits == 100) [[unlikely]]
		calibrate_frequency();
	if (globals->elapsed_pits == 1000) [[unlikely]]
		calibrate_frequency();

	//Print diagnostics
	if (do_pit_readout) {
		array<char, 32> arr;
		text_layer o{default_console()};
		o.fill(0);

		htimepoint t1(timepoint::tsc_time());
		htimepoint t2(timepoint::pit_time_imprecise());
		formats(arr.begin(), "TSC %02i:%02i:%02.3f\n", t1.hour, t1.minute, t1.second + t1.micros / 1000000.);
		o.print(rostring(arr.begin()), true, o.dims[0], 0);
		formats(arr.begin(), "PIT %02i:%02i:%02.3f\n", t2.hour, t2.minute, t2.second + t2.micros / 1000000.);
		o.print(rostring(arr.begin()), true);
		formats(arr.begin(), "IP %p\n", reg->rip);
		o.print(rostring(arr.begin()), true);
		formats(arr.begin(), "   PA %i\n", fixed_globals->pages_allocated);
		o.print(rostring(arr.begin()), true);
		formats(arr.begin(), "    W %i\n", globals->global_waterline.mem_used());
		o.print(rostring(arr.begin()), true);
		formats(arr.begin(), "    H %i\n", globals->global_heap_alloc.mem_used());
		o.print(rostring(arr.begin()), true);
		formats(arr.begin(), "    S %i\n", globals->global_slab_alloc.mem_used());
		o.print(rostring(arr.begin()), true);
		o.display(default_output());
		refresh_tty();
	}
}

void time_init(void) {
	globals->frequency = 3000;
	reset_tsc = true;
	while (globals->elapsed_pits < 1)
		cpu_relax();
	reset_tsc = true;
	globals->reference_timepoint = htimepoint::cmos_time();
}

static uint8_t get_cmos_register(uint8_t reg) {
	outb(0x70, reg);
	return inb(0x71);
}

htimepoint htimepoint::cmos_time() {
	htimepoint t;
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

static timepoint pit_time_override(uint32_t subcnt, int64_t pitcnt) {
	units::pit_subcnts d{(double)(pitcnt * 65536 + subcnt)};
	return {d};
}

timepoint timepoint::pit_time() {
	uint32_t subcnt = inb(0x40);
	subcnt |= ((uint32_t)inb(0x40)) << 8;
	subcnt = 65536 - subcnt;
	return pit_time_override(subcnt, globals->elapsed_pits);
}

timepoint timepoint::pit_time_imprecise() { return pit_time_override(0, globals->elapsed_pits); }

timepoint timepoint::tsc_time() {
	double n = rdtsc() - globals->reference_tsc;
	units::microseconds diff = {n / globals->frequency};
	return {diff};
}

timepoint timepoint::now() { return timepoint::tsc_time(); };

void tsc_delay(uint64_t cycles) {
	uint64_t start = rdtsc();
	while (rdtsc() - start < cycles)
		;
}

void pit_delay(units::seconds seconds) {
	timepoint start = timepoint::pit_time();
	while (timepoint::pit_time() - start < seconds)
		thread_yield();
}
void delay(units::seconds seconds) {
	timepoint start = timepoint::now();
	while (timepoint::now() - start < seconds)
		thread_yield();
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
	timepoint t1 = timepoint::pit_time();
	uint64_t stsc = rdtsc();
	tsc_delay(0x3000000LLU);
	timepoint t2 = timepoint::pit_time();
	uint64_t etsc = rdtsc();

	units::microseconds eus = (t2 - t1);
	double freqMHz = (double)(etsc - stsc) / eus.rep;
	return freqMHz;
}

void calibrate_frequency() {
	units::pit_cnts pit{(double)globals->elapsed_pits};
	uint64_t tsc = rdtsc() - globals->reference_tsc;
	double frequency = tsc / units::microseconds(pit);
	if (frequency < 1000 || frequency > 10000) {
		printf("Frequency: %f\n", frequency);
		return;
	}
	globals->frequency = frequency;
}