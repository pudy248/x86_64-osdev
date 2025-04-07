#pragma once
#include "operators.hpp"
#include "predicate.hpp"
#include <iterator>
#include <stl/iterator.hpp>

namespace algo {
template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred = algo::equal_to>
constexpr bool equal(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	return algo::all_of(begin, end, begin2, end2, std::move(predicate));
}

template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred = algo::equal_to>
constexpr bool starts_with(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin2 != end2; ++begin, ++begin2) {
		if (begin == end)
			return false;
		if (!predicate(*begin, *begin2))
			return false;
	}
	return true;
}
template <std::bidirectional_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred = algo::equal_to>
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

template <std::forward_iterator I, std::sentinel_for<I> S, std::forward_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred = algo::equal_to>
constexpr I search(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin != end; ++begin) {
		I iter = begin;
		I2 iter2 = begin2;
		for (; iter2 != end2; ++iter, ++iter2)
			if (!predicate(*iter, *iter2))
				break;
		if (iter2 == end2)
			break;
	}
	return begin;
}
}