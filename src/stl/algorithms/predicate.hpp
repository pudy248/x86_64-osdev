#pragma once
#include "concepts.hpp"
#include <stl/iterator.hpp>

namespace algo {

template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_input<I, S>
constexpr bool all_of(I begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (!predicate(*begin))
			return false;
	return true;
}

// True if end2 is reached, false if end is reached
template <typename I, typename S, typename I2, typename S2, typename BinaryPred>
	requires impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr bool all_of_partial(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (;; ++begin, ++begin2) {
		if (begin2 == end2)
			return true;
		if (begin == end)
			return false;
		if (!predicate(*begin, *begin2))
			return false;
	}
}
// False if ranges are not the same size
template <typename I, typename S, typename I2, typename S2, typename BinaryPred>
	requires impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr bool all_of(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (;; ++begin, ++begin2) {
		if (begin == end || begin2 == end2) {
			if (begin == end && begin2 == end2)
				return true;
			else
				return false;
		}
		if (!predicate(*begin, *begin2))
			return false;
	}
}
template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_input<I, S>
constexpr bool any_of(I begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (predicate(*begin))
			return true;
	return false;
}
template <typename I, typename S, typename I2, typename S2, typename BinaryPred>
	requires impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr bool any_of(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			return true;
	return false;
}
template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_input<I, S>
constexpr bool none_of(I begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (predicate(*begin))
			return false;
	return true;
}
template <typename I, typename S, typename I2, typename S2, typename BinaryPred>
	requires impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr bool none_of(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			return false;
	return true;
}
}