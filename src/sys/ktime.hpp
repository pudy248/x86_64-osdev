#pragma once
#include <compare>
#include <cstdint>
#include <ratio>
#include <sys/idt.hpp>

template <typename T, typename R>
struct duration {
	T rep;
	template <typename R2>
	constexpr operator duration<T, R2>() const {
		return { rep * std::ratio_divide<R, R2>::num / std::ratio_divide<R, R2>::den };
	}
	template <typename T2>
	constexpr operator duration<T2, R>() const {
		return { (T2)rep };
	}
	template <typename T2, typename R2>
	constexpr operator duration<T2, R2>() const {
		return (duration<T2, R2>)(duration<T2, R>)*this;
	}
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
	constexpr std::partial_ordering operator<=>(const duration& other) const { return rep <=> other.rep; }
};
namespace units {
using nanoseconds = duration<double, std::ratio<1, 1000000000>>;
using microseconds = duration<double, std::ratio<1, 1000000>>;
using milliseconds = duration<double, std::ratio<1, 1000>>;
using seconds = duration<double, std::ratio<1>>;
using minutes = duration<double, std::ratio<60>>;
using hours = duration<double, std::ratio<3600>>;
using days = duration<double, std::ratio<86400>>;

using pit_subcnts = duration<double, std::ratio<1, 1193182>>;
using pit_cnts = duration<double, std::ratio<65536, 1193182>>;
}
namespace unitsi {
using nanoseconds = duration<int64_t, std::ratio<1, 1000000000>>;
using microseconds = duration<int64_t, std::ratio<1, 1000000>>;
using milliseconds = duration<int64_t, std::ratio<1, 1000>>;
using seconds = duration<int64_t, std::ratio<1>>;
using minutes = duration<int64_t, std::ratio<60>>;
using hours = duration<int64_t, std::ratio<3600>>;
using days = duration<int64_t, std::ratio<86400>>;

using pit_subcnts = duration<double, std::ratio<1, 1193182>>;
using pit_cnts = duration<double, std::ratio<65536, 1193182>>;
}

struct timepoint {
	units::nanoseconds t;

	// Mean error: 9ms
	static timepoint pit_time_imprecise();
	// Mean error: 450ns
	static timepoint pit_time();
	// Mean error: 0.3ns
	static timepoint tsc_time();

	static timepoint now();

	template <typename T, typename R>
	constexpr timepoint& operator+=(const duration<T, R>& other) {
		t += other;
		return *this;
	}
	template <typename T, typename R>
	constexpr timepoint& operator-=(const duration<T, R>& other) {
		t -= other;
		return *this;
	}
	template <typename T, typename R>
	constexpr timepoint operator+(const duration<T, R>& other) const {
		timepoint t = *this;
		t += other;
		return t;
	}
	template <typename T, typename R>
	constexpr timepoint operator-(const duration<T, R>& other) const {
		timepoint t = *this;
		t -= other;
		return t;
	}

	constexpr std::partial_ordering operator<=>(const timepoint& other) const { return t <=> other.t; }

	constexpr units::seconds operator-(const timepoint& other) const { return t - other.t; }
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

	// Mean error: 0.5sec
	static htimepoint cmos_time();

	constexpr htimepoint() : htimepoint(timepoint::now()) {}
	constexpr htimepoint(const timepoint& t) {
		unitsi::microseconds total = t.t;
		uint64_t newSecond = total.rep / 1000000LLU;
		uint32_t newMinute = newSecond / 60;
		uint32_t newHour = newMinute / 60;
		micros = total.rep % 1000000LLU;
		second = newSecond % 60;
		minute = newMinute % 60;
		hour = newHour % 24;
		day = newHour / 24;
		month = 0;
		year = 0;
	}

	constexpr static htimepoint reference();
};

void time_init(void);
void inc_pit(uint64_t, register_file*);
void delay(units::seconds t);
void pit_delay(units::seconds t);
// void rtc_delay(units::seconds t);
void tsc_delay(uint64_t cycles);

int clockspeed_MHz(void);
void calibrate_frequency();

extern bool do_pit_readout;