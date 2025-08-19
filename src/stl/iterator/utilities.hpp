#pragma once
#include "iterator_interface.hpp"
#include <iterator>
#include <kassert.hpp>

template <std::input_iterator I, std::sentinel_for<I> S>
constexpr I bounded_advance(I& begin, S end, std::size_t amount) {
	for (; begin != end && amount; ++begin, --amount)
		;
	return begin;
}

struct null_iterator : public random_access_iterator_interface<null_iterator> {
	struct null_assignable {
		template <typename R>
		constexpr void operator=(R) const {};
	};
	using value_type = null_assignable;
	constexpr null_iterator& operator+=(std::ptrdiff_t) { return *this; };
	constexpr null_assignable operator*() const { return {}; }
};

struct null_sentinel {
	template <typename R>
	friend constexpr bool operator==(const null_sentinel&, const R&) {
		return false;
	}
	template <typename R>
	friend constexpr bool operator==(const R&, const null_sentinel&) {
		return false;
	}
	template <typename R>
	friend constexpr bool operator!=(const R&, const null_sentinel&) {
		return true;
	}
	template <typename R>
	friend constexpr bool operator!=(const null_sentinel&, const R&) {
		return true;
	}
};

template <std::forward_iterator I, std::sentinel_for<I> S>
struct ring_iterator : public enclosed_iterator_interface<I> {
	I begin;
	S end;
	constexpr ring_iterator(const I& begin, const S& end)
		: enclosed_iterator_interface<I>(begin), begin(begin), end(end) {}
	constexpr ring_iterator(const I& begin, const S& end, const I& iter)
		: enclosed_iterator_interface<I>(iter), begin(begin), end(end) {}

	using enclosed_iterator_interface<I>::operator++;

	constexpr ring_iterator& operator++() {
		++this->backing;
		if (this->backing == end)
			this->backing = begin;
		return *this;
	};
};
template <std::forward_iterator I, std::sentinel_for<I> S>
ring_iterator(const I&, const S&) -> ring_iterator<I, S>;
template <std::forward_iterator I, std::sentinel_for<I> S>
ring_iterator(const I&, const S&, const I&) -> ring_iterator<I, S>;

class input_counter_iterator : public pure_input_iterator_interface<input_counter_iterator, int> {
public:
	int n = 0;
	using pure_input_iterator_interface<input_counter_iterator, int>::operator++;
	constexpr int operator*() const { return n; }
	constexpr input_counter_iterator& operator++() {
		n++;
		return *this;
	}
};

template <typename T>
class output_counter_iterator {
	T t;

public:
	using iterator_concept = std::input_iterator_tag;
	using iterator_category = iterator_concept;
	using value_type = T;
	using difference_type = std::ptrdiff_t;
	using reference = T&;
	using pointer = T*;

	int n = 0;
	constexpr T& operator*() { return t; }
	constexpr output_counter_iterator& operator++() {
		n++;
		return *this;
	}
	constexpr output_counter_iterator operator++(int) {
		auto ret = *this;
		n++;
		return ret;
	}
};

template <typename T>
constexpr T&& decay(T&& t) {
	return t;
}
template <typename T>
	requires std::is_array_v<std::remove_reference_t<T>>
constexpr decltype(auto) decay(T&& t) {
	return static_cast<std::decay_t<T>>(t);
}