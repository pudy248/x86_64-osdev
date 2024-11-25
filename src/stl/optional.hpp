#pragma once
#include <kassert.hpp>
#include <kstdlib.hpp>

template <typename T>
class optional {
	bool has_value;
	T value;

public:
	optional() : has_value(false), value() {}
	optional(T val) : has_value(true), value(val) {}
	operator T() const volatile {
		kassert(DEBUG_ONLY, ERROR, has_value, "Attempted to convert empty optional.");
		return value;
	}
};

template <>
class optional<void> {};
