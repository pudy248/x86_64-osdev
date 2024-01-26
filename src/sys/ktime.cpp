#include <cstdint>
#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <kprint.h>
#include <sys/global.h>
#include <sys/ktime.hpp>

void inc_pit() {
    globals->elapsedPITs++;
    //Print diagnostics
    {
        int x;
        int tmp_mem = globals->mem_used;

        x = 79;
        string heap_mem = format("   %i", tmp_mem);
        for (int i = heap_mem.size() - 1; i >= 0; --i)
            globals->vga_console.set(heap_mem[i], x--, 0);
        
        
        x = 79;
        string waterline_mem = format("   %i", globals->waterline - 0x200000);
        for (int i = waterline_mem.size() - 1; i >= 0; --i)
            globals->vga_console.set(waterline_mem[i], x--, 1);
    }
}

static const char* months[12] = {
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
};

static uint8_t get_cmos_register(uint8_t reg) {
    outb(0x70, reg);
    return (uint8_t)inb(0x71);
}

static timepoint reference_timepoint;

void time_init(void) {
    reference_timepoint = timepoint(0);
    globals->elapsedPITs = 0;
}

timepoint::timepoint(uint64_t micros_override) {
    while (get_cmos_register(0x0a) & 0x80);
    year = get_cmos_register(0x9);
    month = get_cmos_register(0x8);
    day = get_cmos_register(0x7);
    hour = get_cmos_register(0x4);
    minute = get_cmos_register(0x2);
    second = get_cmos_register(0x0);

    if (1) { //get_cmos_register(0x0b) & 0x04
        second = (second & 0x0F) + ((second / 16) * 10);
        minute = (minute & 0x0F) + ((minute / 16) * 10);
        hour = ((hour & 0x0F) + (((hour & 0x70) / 16) * 10)) | (hour & 0x80);
        day = (day & 0x0F) + ((day / 16) * 10);
        month = (month & 0x0F) + ((month / 16) * 10);
        year = (year & 0x0F) + ((year / 16) * 10);
    }

    micros = micros_override % 1000000LLU;
    uint64_t newSecond = micros_override / 1000000LLU + second;
    uint32_t newMinute = newSecond / 60 + minute;
    uint32_t newHour = newMinute / 60 + hour;
    second = newSecond % 60;
    minute = newMinute % 60;
    hour = newHour % 24;
    day += newHour / 24;
}

timepoint::timepoint() {
	uint32_t subcnt = inb(0x40);
	subcnt |= ((uint32_t)inb(0x40))<<8;
    subcnt = 65536 - subcnt;
    uint64_t cnt = (uint64_t)((int64_t)globals->elapsedPITs * 65536 + subcnt);
    //printf("%i %i\r\n", globals->elapsedPITs, subcnt);
    this->micros = cnt * 1000000LLU / 1193182LLU;
}

double timepoint::unix_seconds() {
    double unixsecs = micros / 1000000.0; 
    return unixsecs;
}

void tsc_delay(uint64_t cycles) {
    uint64_t start = rdtsc();
    while (rdtsc() - start < cycles);
}

void pit_delay(double seconds) {
    double start = timepoint().unix_seconds();
    while (timepoint().unix_seconds() - start < seconds);
}

/*
void print_lres_timepoint(lres_timepoint rtc, int fmt) {
    switch(fmt) {
        case 0: printf("%s %i, 20%02i - %02i:%02i:%02i\r\n", months[rtc.month], rtc.day, rtc.year, rtc.hour, rtc.minute, rtc.second); break;
        case 1: printf("%02i/%02i/%02i %02i:%02i", rtc.month, rtc.day, rtc.year, rtc.hour, rtc.minute); break;
        case 2: printf("%02i:%02i:%02i", rtc.hour, rtc.minute, rtc.second); break;
    }
}*/
