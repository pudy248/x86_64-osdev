#pragma once
#include "concepts.hpp"
#include "operators.hpp"
#include "predicate.hpp"
#include <stl/iterator.hpp>

namespace algo {
template <typename I, typename S, typename I2, typename S2, typename BinaryPred = algo::equal_to>
	requires impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr bool equal(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	return algo::all_of(begin, end, begin2, end2, std::move(predicate));
}

template <typename I, typename S, typename I2, typename S2, typename BinaryPred = algo::equal_to>
	requires impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr bool starts_with(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin2 != end2; ++begin, ++begin2) {
		if (begin == end)
			return false;
		if (!predicate(*begin, *begin2))
			return false;
	}
	return true;
}
template <typename I, typename S, typename I2, typename S2, typename BinaryPred = algo::equal_to>
	requires impl::bidirectional<I> && impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr bool ends_with(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	if (end2 - begin2 > end - begin)
		return false;
	begin = end - (end2 - begin2);
	for (; begin2 != end2; ++begin, ++begin2) {
		if (!predicate(*begin, *begin2))
			return false;
	}
	return true;
}
}