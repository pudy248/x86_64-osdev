#pragma once
#include "concepts.hpp"
#include "operators.hpp"
#include <iterator>
#include <stl/iterator.hpp>
#include <utility>

namespace algo {
template <typename OutI, typename InI, typename InS, typename UnaryOp>
[[deprecated("Unbounded output iterator")]]
constexpr void transform(OutI out, InI begin, InS end, UnaryOp op = {}) {
	for (; begin != end; ++begin, ++out)
		*out = op(*begin);
}
template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryOp>
	requires impl::bounded_input<InI, InS> && impl::bounded_output_unary_from<OutI, OutS, UnaryOp, InI>
constexpr void transform(OutI out, OutS out_end, InI begin, InS end, UnaryOp op = {}) {
	for (; begin != end && out != out_end; ++begin, ++out)
		*out = op(*begin);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename InI2, typename InS2, typename BinaryOp>
	requires impl::bounded_input<InI, InS> && impl::bounded_input<InI2, InS2> &&
			 impl::bounded_output_binary_from2<OutI, OutS, BinaryOp, InI, InI2>
constexpr void transform(OutI out, OutS out_end, InI begin, InS end, InI2 begin2, InS2 end2, BinaryOp op = {}) {
	for (; begin != end && begin2 != end2 && out != out_end; ++begin, ++begin2, ++out)
		*out = op(*begin, *begin2);
}
template <typename OutI, typename InI, typename InS, typename InI2, typename InS2, typename BinaryOp>
	requires impl::bounded_input<InI, InS> && impl::bounded_input<InI2, InS2> &&
			 impl::output_binary_from2<OutI, BinaryOp, InI, InI2>
[[deprecated("Unbounded output iterator")]]
constexpr void transform(OutI out, InI begin, InS end, InI2 begin2, InS2 end2, BinaryOp op = {}) {
	algo::transform(out, null_sentinel{}, begin, end, begin2, end2, op);
}
template <typename OutI, typename InI, typename InS, typename InI2, typename BinaryOp>
	requires impl::bounded_input<InI, InS> && impl::input<InI2> && impl::output_binary_from2<OutI, BinaryOp, InI, InI2>
[[deprecated("Unbounded 2nd input and output iterators")]]
constexpr void transform(OutI out, InI begin, InS end, InI2 __restrict begin2, BinaryOp op = {}) {
	algo::transform(out, null_sentinel{}, begin, end, begin2, null_sentinel{}, op);
}

template <typename I, typename S, typename Init = std::iter_value_t<std::remove_reference_t<I>>,
		  typename BinaryOp = algo::add>
	requires impl::bounded_input<I, S>
constexpr Init reduce(I begin, S end, Init init = {}, BinaryOp op = {}) {
	for (; begin != end; ++begin)
		init = op(std::move(init), *begin);
	return init;
}

template <typename I, typename S, typename Init = std::iter_value_t<I>, typename UnaryOp, typename BinaryOp = algo::add>
	requires impl::bounded_input<I, S>
constexpr Init transform_reduce(I begin, S end, Init init = {}, UnaryOp transform = {}, BinaryOp reduce = {}) {
	for (; begin != end; ++begin)
		init = reduce(std::move(init), transform(*begin));
	return init;
}
template <typename I, typename S, typename I2, typename S2, typename Init = std::iter_value_t<I>,
		  typename BinaryOp = algo::mul, typename BinaryOp2 = algo::add>
	requires impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr Init transform_reduce(I begin, S end, I2 begin2, S2 end2, Init init = {}, BinaryOp transform = {},
								BinaryOp2 reduce = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		init = reduce(std::move(init), transform(*begin, *begin2));
	return init;
}
template <typename I, typename S, typename I2, typename Init = std::iter_value_t<I>, typename BinaryOp = algo::mul,
		  typename BinaryOp2 = algo::add>
	requires impl::bounded_input<I, S> && impl::input<I2>
[[deprecated("Unbounded 2nd input iterator")]]
constexpr Init transform_reduce(I begin, S end, I2 __restrict begin2, Init init = {}, BinaryOp transform = {},
								BinaryOp2 reduce = {}) {
	return algo::transform_reduce(begin, end, begin2, null_sentinel{}, init, transform, reduce);
}

template <typename OutI, typename OutS, typename InI, typename InS,
		  typename Init = std::iter_value_t<std::remove_reference_t<InI>>, typename BinaryOp = algo::add,
		  typename UnaryOp = algo::identity>
	requires impl::bounded_input<InI, InS> && impl::bounded_output_unary_result<OutI, OutS, UnaryOp, Init>
constexpr Init reduce_transform(OutI out, OutS out_end, InI begin, InS end, Init init = {}, BinaryOp reduce = {},
								UnaryOp transform = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		init = reduce(std::move(init), *begin);
		*out = transform(init);
	}
	return init;
}
template <typename OutI, typename InI, typename InS, typename Init = std::iter_value_t<std::remove_reference_t<InI>>,
		  typename BinaryOp = algo::add, typename UnaryOp = algo::identity>
	requires impl::bounded_input<InI, InS> && impl::output_unary_result<OutI, UnaryOp, Init>
[[deprecated("Unbounded output iterator")]]
constexpr Init reduce_transform(OutI out, InI begin, InS end, Init init = {}, BinaryOp reduce = {},
								UnaryOp transform = {}) {
	return algo::reduce_transform(out, null_sentinel{}, begin, end, init, reduce, transform);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename InI2, typename InS2,
		  typename Init = std::iter_value_t<std::remove_reference_t<InI>>, typename BinaryOp, typename BinaryOp2>
	requires impl::bounded_input<InI, InS> && impl::bounded_input<InI2, InS2> &&
			 impl::bounded_output_binary_from1<OutI, OutS, BinaryOp, Init, InI2>
constexpr Init reduce_transform(OutI out, OutS out_end, InI begin, InS end, InI2 begin2, InS2 end2, Init init = {},
								BinaryOp reduce = {}, BinaryOp2 transform = {}) {
	for (; begin != end && begin2 != end2 && out != out_end; ++begin, ++begin2, ++out) {
		init = reduce(std::move(init), *begin);
		*out = transform(init, *begin2);
	}
	return init;
}
template <typename OutI, typename InI, typename InS, typename InI2, typename InS2,
		  typename Init = std::iter_value_t<std::remove_reference_t<InI>>, typename BinaryOp, typename BinaryOp2>
	requires impl::bounded_input<InI, InS> && impl::bounded_input<InI2, InS2> &&
			 impl::output_binary_from1<OutI, BinaryOp, Init, InI2>
[[deprecated("Unbounded output iterator")]]
constexpr Init reduce_transform(OutI out, InI begin, InS end, InI2 begin2, InS2 end2, Init init = {},
								BinaryOp reduce = {}, BinaryOp2 transform = {}) {
	return algo::reduce_transform(out, null_sentinel{}, begin, end, begin2, end2, init, reduce, transform);
}
template <typename OutI, typename InI, typename InS, typename InI2,
		  typename Init = std::iter_value_t<std::remove_reference_t<InI>>, typename BinaryOp, typename BinaryOp2>
	requires impl::bounded_input<InI, InS> && impl::input<InI2> && impl::output_binary_from1<OutI, BinaryOp, Init, InI2>
[[deprecated("Unbounded 2nd input and output iterators")]]
constexpr Init reduce_transform(OutI out, InI begin, InS end, InI2 __restrict begin2, Init init = {},
								BinaryOp reduce = {}, BinaryOp2 transform = {}) {
	return algo::reduce_transform(out, null_sentinel{}, begin, end, begin2, null_sentinel{}, init, reduce, transform);
}
}