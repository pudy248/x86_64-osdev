#pragma once
#include "operators.hpp"
#include "predicate.hpp"
#include <iterator>
#include <kstdio.hpp>
#include <stl/iterator.hpp>

namespace algo {
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_if(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin) {
		auto tmp = *begin;
		if (predicate(tmp))
			*out++ = tmp;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr OutI copy_if(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin) {
		auto tmp = *begin;
		if (predicate(tmp))
			*out++ = tmp;
	}
	return out;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_if_not(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin) {
		auto tmp = *begin;
		if (!predicate(tmp))
			*out++ = tmp;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr OutI copy_if_not(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin) {
		auto tmp = *begin;
		if (!predicate(tmp))
			*out++ = tmp;
	}
	return out;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI move_if(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin) {
		auto tmp = std::move(*begin);
		if (predicate(tmp))
			*out++ = std::move(tmp);
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr OutI move_if(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin) {
		auto tmp = std::move(*begin);
		if (predicate(tmp))
			*out++ = std::move(tmp);
	}
	return out;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI move_if_not(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin) {
		auto tmp = std::move(*begin);
		if (!predicate(tmp))
			*out++ = std::move(tmp);
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr OutI move_if_not(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin) {
		auto tmp = std::move(*begin);
		if (!predicate(tmp))
			*out++ = std::move(tmp);
	}
	return out;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr OutI copy_while(OutI out, InI begin, UnaryPred predicate = {}) {
	for (;; ++begin, ++out) {
		auto tmp = *begin;
		if (!predicate(tmp))
			break;
		*out = tmp;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_while(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin, ++out) {
		auto tmp = *begin;
		if (!predicate(tmp))
			break;
		*out = tmp;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr OutI copy_while(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		auto tmp = *begin;
		if (!predicate(tmp))
			break;
		*out = tmp;
	}
	return out;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr OutI copy_until(OutI out, InI begin, UnaryPred predicate = {}) {
	for (;; ++begin, ++out) {
		auto tmp = *begin;
		if (predicate(tmp))
			break;
		*out = tmp;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_until(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin, ++out) {
		auto tmp = *begin;
		if (predicate(tmp))
			break;
		*out = tmp;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr OutI copy_until(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		auto tmp = *begin;
		if (predicate(tmp))
			break;
		*out = tmp;
	}
	return out;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr OutI copy_through(OutI out, InI begin, UnaryPred predicate = {}) {
	for (;; ++begin, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (predicate(tmp))
			break;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_through(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (predicate(tmp))
			break;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, typename UnaryPred,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr OutI copy_through(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (predicate(tmp))
			break;
	}
	return out;
}

template <std::forward_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2,
		  std::sentinel_for<InI2> InS2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_until_block(OutI out, InI begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (; begin != end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	return out;
}
template <std::forward_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2,
		  std::sentinel_for<InI2> InS2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr OutI copy_until_block(OutI out, OutS out_end, InI begin, InS end, InI2 begin2, InS2 end2,
								BinaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	return out;
}

template <std::input_iterator InI, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded 1st input and output iterators")]]
constexpr OutI copy_through_block(OutI out, InI begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (InI2 iter2 = begin2; iter2 != end2; ++begin, ++iter2, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (!predicate(tmp, *iter2))
			iter2 = begin2;
	}
	return out;
}
template <std::input_iterator InI, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
[[deprecated("Unbounded 1st input iterator")]]
constexpr OutI copy_through_block(OutI out, OutS out_end, InI begin, InI2 begin2, InS2 end2,
								  BinaryPred predicate = {}) {
	for (InI2 iter2 = begin2; iter2 != end2 && out != out_end; ++begin, ++iter2, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (!predicate(tmp, *iter2))
			iter2 = begin2;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_through_block(OutI out, InI begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (InI2 iter2 = begin2; iter2 != end2 && begin != end; ++begin, ++iter2, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (!predicate(tmp, *iter2))
			iter2 = begin2;
	}
	return out;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr OutI copy_through_block(OutI out, OutS out_end, InI begin, InS end, InI2 begin2, InS2 end2,
								  BinaryPred predicate = {}) {
	for (InI2 iter2 = begin2; iter2 != end2 && begin != end && out != out_end; ++begin, ++iter2, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (!predicate(tmp, *iter2))
			iter2 = begin2;
	}
	return out;
}

template <std::forward_iterator InI, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded 1st input and output iterators")]]
constexpr OutI copy_through_block(OutI out, InI begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (;; ++begin, ++out) {
		if (algo::all_of_partial(begin, std::unreachable_sentinel_t{}, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	for (; begin2 != end2; begin++, begin2++, out++)
		*out = *begin;
	return out;
}
template <std::forward_iterator InI, std::forward_iterator InI2, std::sentinel_for<InI2> InS2,
		  typename BinaryPred = algo::equal_to, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
[[deprecated("Unbounded 1st input iterator")]]
constexpr OutI copy_through_block(OutI out, OutS out_end, InI begin, InI2 begin2, InS2 end2,
								  BinaryPred predicate = {}) {
	for (; out != out_end; ++begin, ++out) {
		if (algo::all_of_partial(begin, std::unreachable_sentinel_t{}, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	for (; begin2 != end2 && out != out_end; begin++, begin2++, out++)
		*out = *begin;
	return out;
}
template <std::forward_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2,
		  std::sentinel_for<InI2> InS2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_through_block(OutI out, InI begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (; begin != end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	for (; begin != end && begin2 != end2; begin++, begin2++, out++)
		*out = *begin;
	return out;
}
template <std::forward_iterator InI, std::sentinel_for<InI> InS, std::forward_iterator InI2,
		  std::sentinel_for<InI2> InS2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<InI>> OutI, std::sentinel_for<OutI> OutS>
constexpr OutI copy_through_block(OutI out, OutS out_end, InI begin, InS end, InI2 begin2, InS2 end2,
								  BinaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	for (; begin != end && begin2 != end2 && out != out_end; begin++, begin2++, out++)
		*out = *begin;
	return out;
}
}