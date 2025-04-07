#pragma once
#include "operators.hpp"
#include "predicate.hpp"
#include <iterator>
#include <stl/iterator.hpp>

namespace algo {
namespace mut {
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy(OutI& out, InI& begin, InS end) {
	for (; begin != end; ++begin, ++out)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void copy(OutI& out, OutS out_end, InI& begin, InS end) {
	for (; begin != end && out != out_end; ++begin, ++out)
		*out = *begin;
}
template <std::input_iterator InI, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_n(OutI& out, InI& begin, std::iter_difference_t<InI> n) {
	for (; n > 0; ++begin, ++out, --n)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_n(OutI& out, InI& begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && n > 0; ++begin, ++out, --n)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void copy_n(OutI& out, OutS out_end, InI& begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && out != out_end && n > 0; ++begin, ++out, --n)
		*out = *begin;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void move(OutI& out, InI& begin, InS end) {
	for (; begin != end; ++begin, ++out)
		*out = std::move(*begin);
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void move(OutI& out, OutS out_end, InI& begin, InS end) {
	for (; begin != end && out != out_end; ++begin, ++out)
		*out = std::move(*begin);
}
template <std::input_iterator InI, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void move_n(OutI& out, InI& begin, std::iter_difference_t<InI> n) {
	for (; n > 0; ++begin, ++out, --n)
		*out = std::move(*begin);
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void move_n(OutI& out, InI& begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && n > 0; ++begin, ++out, --n)
		*out = std::move(*begin);
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void move_n(OutI& out, OutS out_end, InI& begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && out != out_end && n > 0; ++begin, ++out, --n)
		*out = std::move(*begin);
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_while(OutI& out, InI& begin, UnaryPred predicate = {}) {
	for (; predicate(*begin); ++begin, ++out)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_while(OutI& out, InI& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && predicate(*begin); ++begin, ++out)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr void copy_while(OutI& out, OutS out_end, InI& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end && predicate(*begin); ++begin, ++out)
		*out = *begin;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_until(OutI& out, InI& begin, UnaryPred predicate = {}) {
	for (; !predicate(*begin); ++begin, ++out)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_until(OutI& out, InI& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && !predicate(*begin); ++begin, ++out)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr void copy_until(OutI& out, OutS out_end, InI& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end && !predicate(*begin); ++begin, ++out)
		*out = *begin;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_through(OutI& out, InI& begin, UnaryPred predicate = {}) {
	for (; !predicate(*begin); ++begin, ++out)
		*out = *begin;
	*++out = *++begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_through(OutI& out, InI& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && !predicate(*begin); ++begin, ++out)
		*out = *begin;
	if (begin != end)
		*++out = *++begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr void copy_through(OutI& out, OutS out_end, InI& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end && !predicate(*begin); ++begin, ++out)
		*out = *begin;
	if (begin != end && out != out_end)
		*++out = *++begin;
}

template <std::forward_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2,
		  std::sentinel_for<InI2> InS2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_until_block(OutI& out, InI& begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (; begin != end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
}
template <std::forward_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2,
		  std::sentinel_for<InI2> InS2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr void copy_until_block(OutI& out, OutS out_end, InI& begin, InS end, InI2 begin2, InS2 end2,
								BinaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
}

template <std::input_iterator InI, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded 1st input and output iterators")]]
constexpr void copy_through_block(OutI& out, InI& begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (InI2 iter2 = begin2; iter2 != end2; ++begin, ++iter2, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (!predicate(tmp, *iter2))
			iter2 = begin2;
	}
}
template <std::input_iterator InI, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
[[deprecated("Unbounded 1st input iterator")]]
constexpr void copy_through_block(OutI& out, OutS out_end, InI& begin, InI2 begin2, InS2 end2,
								  BinaryPred predicate = {}) {
	for (InI2 iter2 = begin2; iter2 != end2 && out != out_end; ++begin, ++iter2, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (!predicate(tmp, *iter2))
			iter2 = begin2;
	}
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_through_block(OutI& out, InI& begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (InI2 iter2 = begin2; iter2 != end2 && begin != end; ++begin, ++iter2, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (!predicate(tmp, *iter2))
			iter2 = begin2;
	}
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void copy_through_block(OutI& out, OutS out_end, InI& begin, InS end, InI2 begin2, InS2 end2,
								  BinaryPred predicate = {}) {
	for (InI2 iter2 = begin2; iter2 != end2 && begin != end && out != out_end; ++begin, ++iter2, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (!predicate(tmp, *iter2))
			iter2 = begin2;
	}
}

template <std::forward_iterator InI, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded 1st input and output iterators")]]
constexpr void copy_through_block(OutI& out, InI& begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (;; ++begin, ++out) {
		if (algo::all_of_partial(begin, std::unreachable_sentinel_t{}, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	for (; begin2 != end2; begin++, begin2++, out++)
		*out = *begin;
}
template <std::forward_iterator InI, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
[[deprecated("Unbounded 1st input iterator")]]
constexpr void copy_through_block(OutI& out, OutS out_end, InI& begin, InI2 begin2, InS2 end2,
								  BinaryPred predicate = {}) {
	for (; out != out_end; ++begin, ++out) {
		if (algo::all_of_partial(begin, std::unreachable_sentinel_t{}, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	for (; begin2 != end2 && out != out_end; begin++, begin2++, out++)
		*out = *begin;
}
template <std::forward_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2,
		  std::sentinel_for<InI2> InS2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_through_block(OutI& out, InI& begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (; begin != end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	for (; begin != end && begin2 != end2; begin++, begin2++, out++)
		*out = *begin;
}
template <std::forward_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2,
		  std::sentinel_for<InI2> InS2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr void copy_through_block(OutI& out, OutS out_end, InI& begin, InS end, InI2 begin2, InS2 end2,
								  BinaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	for (; begin != end && begin2 != end2 && out != out_end; begin++, begin2++, out++)
		*out = *begin;
}

template <std::input_iterator I, typename UnaryPred>
[[deprecated("Unbounded iterator")]]
constexpr void iterate_through(I& begin, UnaryPred predicate = {}) {
	for (; !predicate(*begin); ++begin)
		;
	++begin;
}
template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryPred>
constexpr void iterate_through(I& begin, S end, UnaryPred predicate = {}) {
	for (; begin != end && !predicate(*begin); ++begin)
		;
	if (begin != end)
		++begin;
}

template <std::input_iterator I, std::forward_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred = algo::equal_to>
[[deprecated("Unbounded 1st input iterator")]]
constexpr void iterate_through_block(I& begin, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (I2 iter2 = begin2; iter2 != end2; ++begin, ++iter2) {
		if (!predicate(*begin, *iter2))
			iter2 = begin2;
	}
}
template <std::input_iterator I, std::sentinel_for<I> S, std::forward_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred = algo::equal_to>
constexpr void iterate_through_block(I& begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (I2 iter2 = begin2; iter2 != end2 && begin != end; ++begin, ++iter2) {
		if (!predicate(*begin, *iter2))
			iter2 = begin2;
	}
}
}
}