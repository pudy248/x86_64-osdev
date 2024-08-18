#pragma once

consteval unsigned long long operator""_KB(unsigned long long v) {
	return v << 10;
}
consteval unsigned long long operator""_MB(unsigned long long v) {
	return v << 20;
}
consteval unsigned long long operator""_GB(unsigned long long v) {
	return v << 30;
}
consteval unsigned long long operator""_TB(unsigned long long v) {
	return v << 40;
}