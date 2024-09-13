#pragma once
#include <cstdint>
#include <ratio>
#include <sys/idt.hpp>

template <typename T, typename R> struct duration {
	T rep;
	template <typename R2> constexpr operator duration<T, R2>() const {
		return { rep * std::ratio_divide<R, R2>::num / std::ratio_divide<R, R2>::den };
	}
	template <typename T2> constexpr operator duration<T2, R>() const { return { rep }; }
	constexpr operator T() const { return rep; }
	constexpr T operator()() const { return rep; }
	constexpr duration& operator+=(const duration& other) {
		rep += other.rep;
		return *this;
	}
	constexpr duration operator+(const duration& other) const {
		duration d = *this;
		d += other;
		return d;
	}
	constexpr duration& operator-=(const duration& other) {
		rep -= other.rep;
		return *this;
	}
	constexpr duration operator-(const duration& other) const {
		duration d = *this;
		d -= other;
		return d;
	}
	constexpr duration& operator*=(const T& other) {
		rep *= other;
		return *this;
	}
	constexpr duration operator*(const T& other) const {
		duration d = *this;
		d *= other;
		return d;
	}
	constexpr duration& operator/=(const T& other) {
		rep /= other.rep;
		return *this;
	}
	constexpr duration operator/(const T& other) const {
		duration d = *this;
		d /= other;
		return d;
	}
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
	// units::nanoseconds t;

	uint32_t micros;
	uint8_t second;
	uint8_t minute;
	uint8_t hour;
	uint8_t day;
	uint8_t month;
	uint8_t year;

	constexpr double unix_seconds() const {
		double unixsecs = micros / 1000000.0 + second + minute * 60 + hour * 3600 + hour * 24 * 3600;
		return unixsecs;
	}

	// Mean error: 0.5sec
	static timepoint cmos_time();
	// Mean error: 9ms
	static timepoint pit_time_imprecise();
	// Mean error: 450ns
	static timepoint pit_time();
	// Mean error: 0.3ns
	static timepoint tsc_time();

	static timepoint now();

	constexpr operator double() const;

	constexpr timepoint& operator+=(const timepoint& other);
	constexpr timepoint& operator-=(const timepoint& other);
	constexpr timepoint operator+(const timepoint& other) const;
	constexpr timepoint operator-(const timepoint& other) const;

	void delay_until();
};

struct htimepoint {
	static constexpr uint8_t month_lengths[12] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

	uint32_t micros;
	uint8_t second;
	uint8_t minute;
	uint8_t hour;
	uint8_t day;
	uint8_t month;
	uint8_t year;

	constexpr htimepoint& operator+=(const htimepoint& other);
	constexpr htimepoint& operator-=(const htimepoint& other);
	constexpr htimepoint operator+(const htimepoint& other) const;
	constexpr htimepoint operator-(const htimepoint& other) const;
};

void time_init(void);
void inc_pit(uint64_t, register_file*);
void pit_delay(double seconds);

void rtc_delay(uint32_t seconds);
void tsc_delay(uint64_t cycles);

int clockspeed_MHz(void);

extern bool do_pit_readout;