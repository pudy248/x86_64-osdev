#pragma once
#include "operators.hpp"
#include <iterator>
#include <utility>

namespace algo {
template <std::input_iterator I, std::sentinel_for<I> S, typename Init = std::iter_value_t<I>, typename UnaryOp,
		  typename BinaryOp = algo::add>
constexpr Init transform_reduce(I begin, S end, Init init = {}, UnaryOp transform = {}, BinaryOp reduce = {}) {
	for (; begin != end; ++begin)
		init = reduce(std::move(init), transform(*begin));
	return init;
}
template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, typename Init = std::iter_value_t<I>,
		  typename BinaryOp = algo::mul, typename BinaryOp2 = algo::add>
[[deprecated("Unbounded 2nd input iterator")]]
constexpr Init transform_reduce(I begin, S end, I2 __restrict begin2, Init init = {}, BinaryOp transform = {},
								BinaryOp2 reduce = {}) {
	for (; begin != end; ++begin, ++begin2)
		init = reduce(std::move(init), transform(*begin, *begin2));
	return init;
}
template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename Init = std::iter_value_t<I>, typename BinaryOp = algo::mul, typename BinaryOp2 = algo::add>
constexpr Init transform_reduce(I begin, S end, I2 begin2, S2 end2, Init init = {}, BinaryOp transform = {},
								BinaryOp2 reduce = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		init = reduce(std::move(init), transform(*begin, *begin2));
	return init;
}
}