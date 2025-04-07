#pragma once
#include "stl/iterator/iterator_interface.hpp"
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
		void operator=(R) const {};
	};
	using value_type = null_assignable;
	constexpr null_iterator& operator+=(std::ptrdiff_t) { return *this; };
	constexpr null_assignable operator*() const { return {}; }
};