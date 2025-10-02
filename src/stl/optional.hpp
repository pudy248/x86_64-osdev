#pragma once
#include <kassert.hpp>
#include <kstdlib.hpp>

template <typename T>
class optional {
	bool has_value;
	union {
		T value;
		std::byte none;
	};

public:
	constexpr optional() : has_value(false), none() {}
	template <typename TF>
	constexpr optional(TF&& val) : has_value(true), value(std::forward<TF>(val)) {}
	constexpr optional(const optional& other) : has_value(other.has_value) {
		if (has_value)
			new (&value) T(other.value);
	}
	constexpr optional(optional&& other) : has_value(other.has_value) {
		if (has_value)
			new (&value) T(std::move(other.value));
	}

	constexpr optional& operator=(const optional& other) {
		if (has_value)
			value.~T();
		has_value = other.has_value;
		if (has_value)
			new (&value) T(other.value);
		return *this;
	}
	constexpr optional& operator=(optional&& other) {
		if (has_value)
			value.~T();
		has_value = other.has_value;
		if (has_value)
			new (&value) T(std::move(other.value));
		return *this;
	}

	constexpr operator T() const {
		kassert(DEBUG_ONLY, ERROR, has_value, "Attempted to convert empty optional.");
		return value;
	}
	constexpr const T& get() const {
		kassert(DEBUG_ONLY, ERROR, has_value, "Attempted to convert empty optional.");
		return value;
	}
	constexpr T* operator->() {
		kassert(DEBUG_ONLY, ERROR, has_value, "Attempted to convert empty optional.");
		return &value;
	}
	constexpr ~optional() {
		if (has_value)
			value.~T();
	}
	constexpr operator bool() const { return has_value; }
};

template <>
class optional<void> {};
