#pragma once
#include "operators.hpp"
#include <iterator>
#include <utility>

namespace algo {
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename Init = std::iter_value_t<InI>,
		  typename BinaryOp = algo::add, typename UnaryOp = algo::identity,
		  std::output_iterator<algo::unary_op_result_t<UnaryOp, Init>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr Init reduce_transform(OutI out, InI begin, InS end, Init init = {}, BinaryOp reduce = {},
								UnaryOp transform = {}) {
	for (; begin != end; ++begin, ++out) {
		init = reduce(std::move(init), *begin);
		*out = transform(init);
	}
	return init;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename Init = std::iter_value_t<InI>,
		  typename BinaryOp = algo::add, typename UnaryOp = algo::identity,
		  std::output_iterator<algo::unary_op_result_t<UnaryOp, Init>> OutI, std::sentinel_for<OutI> OutS>
constexpr Init reduce_transform(OutI out, OutS out_end, InI begin, InS end, Init init = {}, BinaryOp reduce = {},
								UnaryOp transform = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		init = reduce(std::move(init), *begin);
		*out = transform(init);
	}
	return init;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, std::input_iterator InI2,
		  typename Init = std::iter_value_t<InI>, typename BinaryOp, typename BinaryOp2,
		  std::output_iterator<algo::binary_op_result_t<BinaryOp, Init, std::iter_value_t<InI2>>> OutI>
[[deprecated("Unbounded 2nd input and output iterators")]]
constexpr Init reduce_transform(OutI out, InI begin, InS end, InI2 __restrict begin2, Init init = {},
								BinaryOp reduce = {}, BinaryOp2 transform = {}) {
	for (; begin != end; ++begin, ++begin2, ++out) {
		init = reduce(std::move(init), *begin);
		*out = transform(init, *begin2);
	}
	return init;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::input_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename Init = std::iter_value_t<InI>, typename BinaryOp, typename BinaryOp2,
		  std::output_iterator<algo::binary_op_result_t<BinaryOp, Init, std::iter_value_t<InI2>>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr Init reduce_transform(OutI out, InI begin, InS end, InI2 begin2, InS2 end2, Init init = {},
								BinaryOp reduce = {}, BinaryOp2 transform = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2, ++out) {
		init = reduce(std::move(init), *begin);
		*out = transform(init, *begin2);
	}
	return init;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::input_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename Init = std::iter_value_t<InI>, typename BinaryOp, typename BinaryOp2,
		  std::output_iterator<algo::binary_op_result_t<BinaryOp, Init, std::iter_value_t<InI2>>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr Init reduce_transform(OutI out, OutS out_end, InI begin, InS end, InI2 begin2, InS2 end2, Init init = {},
								BinaryOp reduce = {}, BinaryOp2 transform = {}) {
	for (; begin != end && begin2 != end2 && out != out_end; ++begin, ++begin2, ++out) {
		init = reduce(std::move(init), *begin);
		*out = transform(init, *begin2);
	}
	return init;
}
}