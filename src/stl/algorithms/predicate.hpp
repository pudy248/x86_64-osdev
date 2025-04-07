#pragma once
#include "operators.hpp"
#include <iterator>
#include <stl/iterator.hpp>

namespace algo {
template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryPred>
constexpr bool all_of(I begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (!predicate(*begin))
			return false;
	return true;
}
template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred>
constexpr bool all_of_partial(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2) {
		if (!predicate(*begin, *begin2))
			return false;
	}
	return true;
}
template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred>
constexpr bool all_of(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (;; ++begin, ++begin2) {
		if (begin == end || begin2 == end2) {
			if (begin == end && begin2 == end2)
				break;
			else
				return false;
		}
		if (!predicate(*begin, *begin2))
			return false;
	}
	return true;
}
template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryPred>
constexpr bool any_of(I begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (predicate(*begin))
			return true;
	return false;
}
template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred>
constexpr bool any_of(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			return true;
	return false;
}
template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryPred>
constexpr bool none_of(I begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (predicate(*begin))
			return false;
	return true;
}
template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred>
constexpr bool none_of(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			return false;
	return true;
}
}