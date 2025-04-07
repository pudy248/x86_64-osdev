#pragma once
#include "operators.hpp"
#include <iterator>

namespace algo {
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryOp,
		  std::output_iterator<algo::unary_op_result_t<UnaryOp, std::iter_value_t<InI>>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void transform(OutI out, InI begin, InS end, UnaryOp op = {}) {
	for (; begin != end; ++begin, ++out)
		*out = op(*begin);
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryOp,
		  std::output_iterator<algo::unary_op_result_t<UnaryOp, std::iter_value_t<InI>>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void transform(OutI out, OutS out_end, InI begin, InS end, UnaryOp op = {}) {
	for (; begin != end && out != out_end; ++begin, ++out)
		*out = op(*begin);
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, std::input_iterator InI2, typename BinaryOp,
		  std::output_iterator<algo::binary_op_result_t<BinaryOp, std::iter_value_t<InI>, std::iter_value_t<InI2>>> OutI>
[[deprecated("Unbounded 2nd input and output iterators")]]
constexpr void transform(OutI out, InI begin, InS end, InI2 __restrict begin2, BinaryOp op = {}) {
	for (; begin != end; ++begin, ++begin2, ++out)
		*out = op(*begin, *begin2);
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::input_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryOp,
		  std::output_iterator<algo::binary_op_result_t<BinaryOp, std::iter_value_t<InI>, std::iter_value_t<InI2>>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void transform(OutI out, InI begin, InS end, InI2 begin2, InS2 end2, BinaryOp op = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2, ++out)
		*out = op(*begin, *begin2);
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::input_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryOp,
		  std::output_iterator<algo::binary_op_result_t<BinaryOp, std::iter_value_t<InI>, std::iter_value_t<InI2>>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void transform(OutI out, OutS out_end, InI begin, InS end, InI2 begin2, InS2 end2, BinaryOp op = {}) {
	for (; begin != end && begin2 != end2 && out != out_end; ++begin, ++begin2, ++out)
		*out = op(*begin, *begin2);
}
}