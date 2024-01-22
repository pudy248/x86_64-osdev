#pragma once
#include <kstddefs.h>

struct timepoint {
    uint8_t year;
    uint8_t month;
    uint8_t day;
    uint8_t hour;
    uint8_t minute;
    uint8_t second;
    uint32_t micros;

    timepoint();
    timepoint(uint64_t micros_override);
    double unix_seconds();

    timepoint& operator+=(const timepoint& other);
    timepoint& operator-=(const timepoint& other);
    timepoint operator+(const timepoint& other);
    timepoint operator-(const timepoint& other);

    void delay_until();
};

void time_init(void);
void inc_pit(void);
void pit_delay(double seconds);

void rtc_delay(uint32_t seconds);
void tsc_delay(uint64_t cycles);
