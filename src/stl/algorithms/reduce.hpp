#pragma once
#include "operators.hpp"
#include <iterator>
#include <utility>

namespace algo {
template <std::input_iterator I, std::sentinel_for<I> S, typename Init = std::iter_value_t<I>,
		  typename BinaryOp = algo::add>
constexpr Init reduce(I begin, S end, Init init = {}, BinaryOp op = {}) {
	for (; begin != end; ++begin)
		init = op(std::move(init), *begin);
	return init;
}
}