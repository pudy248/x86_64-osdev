#pragma once
#include <kstdlib.hpp>

template <typename T> class optional {
public:
	bool has_value;
	T value;
	optional()
		: has_value(false)
		, value() {
	}
	optional(T val)
		: has_value(true)
		, value(val) {
	}
	operator T() {
		kassert(has_value, "Attempted to convert empty optional.");
		return value;
	}
};