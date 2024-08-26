#pragma once
#include <cstdint>
#include <ratio>
#include <sys/idt.hpp>

template <typename T, typename R> struct duration {
	T rep;
	template <typename R2> constexpr operator duration<T, R2>() const {
		return { rep * std::ratio_divide<R, R2>::num / std::ratio_divide<R, R2>::den };
	}
	constexpr operator T() const { return rep; }
};
namespace units {
using nanoseconds = duration<double, std::ratio<1, 1000000000>>;
using microseconds = duration<double, std::ratio<1, 1000000>>;
using milliseconds = duration<double, std::ratio<1, 1000>>;
using seconds = duration<double, std::ratio<1>>;
using minutes = duration<double, std::ratio<60>>;
using hours = duration<double, std::ratio<3600>>;
using days = duration<double, std::ratio<86400>>;
namespace i {
using nanoseconds = duration<int64_t, std::ratio<1, 1000000000>>;
using microseconds = duration<int64_t, std::ratio<1, 1000000>>;
using milliseconds = duration<int64_t, std::ratio<1, 1000>>;
using seconds = duration<int64_t, std::ratio<1>>;
using minutes = duration<int64_t, std::ratio<60>>;
using hours = duration<int64_t, std::ratio<3600>>;
using days = duration<int64_t, std::ratio<86400>>;
}
}

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
	// Mean error:
	static timepoint tsc_time();

	//timepoint();
	//timepoint(uint64_t micros_override);
	double unix_seconds();

	timepoint& operator+=(const timepoint& other);
	timepoint& operator-=(const timepoint& other);
	timepoint operator+(const timepoint& other) const;
	timepoint operator-(const timepoint& other) const;

	void delay_until();
};

struct htimepoint {
	uint32_t micros;
	uint8_t second;
	uint8_t minute;
	uint8_t hour;
	uint8_t day;
	uint8_t month;
	uint8_t year;

	htimepoint& operator+=(const htimepoint& other);
	htimepoint& operator-=(const htimepoint& other);
	htimepoint operator+(const htimepoint& other) const;
	htimepoint operator-(const htimepoint& other) const;
};

void time_init(void);
void inc_pit(uint64_t, register_file*);
void pit_delay(double seconds);

void rtc_delay(uint32_t seconds);
void tsc_delay(uint64_t cycles);

int clockspeed_MHz(void);

extern bool do_pit_readout;