#include <cstdint>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <kstdio.hpp>
#include <sys/global.h>
#include <sys/ktime.hpp>

void inc_pit() {
    globals->elapsedPITs = globals->elapsedPITs + 1;
    //Print diagnostics
    {
        int x, l;
        int tmp_mem = globals->mem_used;
        array<char, 20> arr;
        x = globals->g_console.text_rect[2] - 1;
        l = formats(arr, "   %i", tmp_mem);
        for (int i = l - 1; i >= 0; --i)
            globals->g_console.set_char(x--, 0, arr[i]);
        
        x = globals->g_console.text_rect[2] - 1;
        l = formats(arr, "   %i", globals->waterline - 0x400000);
        for (int i = l - 1; i >= 0; --i)
            globals->g_console.set_char(x--, 1, arr[i]);
            
        globals->g_console.refresh();
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
        case 0: printf("%s %i, 20%02i - %02i:%02i:%02i\n", months[rtc.month], rtc.day, rtc.year, rtc.hour, rtc.minute, rtc.second); break;
        case 1: printf("%02i/%02i/%02i %02i:%02i", rtc.month, rtc.day, rtc.year, rtc.hour, rtc.minute); break;
        case 2: printf("%02i:%02i:%02i", rtc.hour, rtc.minute, rtc.second); break;
    }
}*/
