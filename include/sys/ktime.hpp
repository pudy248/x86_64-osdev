#pragma once
#include <cstdint>
#include <sys/idt.hpp>


struct timepoint {
	uint32_t micros;
	uint8_t second;
	uint8_t minute;
	uint8_t hour;
	uint8_t day;
	uint8_t month;
	uint8_t year;

	// Mean error: 0.5sec
	static timepoint cmos_time();
	// Mean error: 450ns
	static timepoint pit_time();
	// Mean error: 9ms
	static timepoint pit_time_imprecise();

	//timepoint();
	//timepoint(uint64_t micros_override);
	double unix_seconds();

	timepoint& operator+=(const timepoint& other);
	timepoint& operator-=(const timepoint& other);
	timepoint operator+(const timepoint& other) const;
	timepoint operator-(const timepoint& other) const;

	void delay_until();
};

void time_init(void);
void inc_pit(uint64_t, register_file*);
void pit_delay(double seconds);

void rtc_delay(uint32_t seconds);
void tsc_delay(uint64_t cycles);

int clockspeed_MHz(void);