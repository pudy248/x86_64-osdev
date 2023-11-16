#include <rtc.h>
#include <common.h>
#include <basic_console.h>

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

uint8_t get_cmos_register(uint8_t reg) {
    outb(0x70, reg);
    return (uint8_t)inb(0x71);
}
uint8_t get_rtc_second(void) {
    return get_cmos_register(0x0);
}
rtc_timepoint get_rtc(void) {
    rtc_timepoint t;
    while(get_cmos_register(0x0a) & 0x80);
    t.second = get_cmos_register(0x0);
    t.minute = get_cmos_register(0x2);
    t.hour = get_cmos_register(0x4);
    t.day = get_cmos_register(0x7);
    t.month = get_cmos_register(0x8);
    t.year = get_cmos_register(0x9);

    if(1) { //get_cmos_register(0x0b) & 0x04
        t.second = (t.second & 0x0F) + ((t.second / 16) * 10);
        t.minute = (t.minute & 0x0F) + ((t.minute / 16) * 10);
        t.hour = ((t.hour & 0x0F) + (((t.hour & 0x70) / 16) * 10) ) | (t.hour & 0x80);
        t.day = (t.day & 0x0F) + ((t.day / 16) * 10);
        t.month = (t.month & 0x0F) + ((t.month / 16) * 10);
        t.year = (t.year & 0x0F) + ((t.year / 16) * 10);
    }

    return t;
}
void print_rtc(rtc_timepoint rtc, int fmt) {
    switch(fmt) {
        case 0: basic_printf("%s %i, 20%02i - %02i:%02i:%02i\r\n", months[rtc.month], rtc.day, rtc.year, rtc.hour, rtc.minute, rtc.second); break;
        case 1: basic_printf("%02i/%02i/%02i %02i:%02i", rtc.month, rtc.day, rtc.year, rtc.hour, rtc.minute); break;
        case 2: basic_printf("%02i:%02i:%02i", rtc.hour, rtc.minute, rtc.second); break;
    }
}
void rtc_delay(int seconds) {
    return;
}
