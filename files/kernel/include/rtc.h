#pragma once
#include <typedefs.h>

typedef struct rtc_timepoint {
    uint8_t second;
    uint8_t minute;
    uint8_t hour;
    uint8_t day;
    uint8_t month;
    uint8_t year;

    uint8_t century;
    uint8_t pad_0;
} rtc_timepoint;

uint8_t get_cmos_register(uint8_t reg);
rtc_timepoint get_rtc(void);
uint8_t get_rtc_second(void);
void print_rtc(rtc_timepoint rtc, int fmt);
void rtc_delay(int seconds);
