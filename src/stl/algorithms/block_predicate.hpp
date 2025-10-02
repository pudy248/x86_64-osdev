#pragma once
#include "concepts.hpp"
#include "operators.hpp"
#include "predicate.hpp"
#include "stl/iterator/utilities.hpp"
#include <cstddef>
#include <iterator>
#include <kstdio.hpp>
#include <stl/iterator.hpp>

namespace algo {
namespace mut {
template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void copy_if(OutI&& out, OutS out_end, InI&& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin) {
		auto tmp = *begin;
		if (predicate(tmp))
			*out++ = tmp;
	}
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_if(OutI&& out, InI&& begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_if(out, null_sentinel{}, begin, end, predicate);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void copy_if_not(OutI&& out, OutS out_end, InI&& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin) {
		auto tmp = *begin;
		if (!predicate(tmp))
			*out++ = tmp;
	}
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_if_not(OutI&& out, InI&& begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_if_not(out, null_sentinel{}, begin, end, predicate);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void move_if(OutI&& out, OutS out_end, InI&& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin) {
		auto tmp = std::move(*begin);
		if (predicate(tmp))
			*out++ = std::move(tmp);
	}
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void move_if(OutI&& out, InI&& begin, InS end, UnaryPred predicate = {}) {
	algo::mut::move_if(out, null_sentinel{}, begin, end, predicate);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void move_if_not(OutI&& out, OutS out_end, InI&& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin) {
		auto tmp = std::move(*begin);
		if (!predicate(tmp))
			*out++ = std::move(tmp);
	}
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void move_if_not(OutI&& out, InI&& begin, InS end, UnaryPred predicate = {}) {
	algo::mut::move_if_not(out, null_sentinel{}, begin, end, predicate);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void copy_while(OutI&& out, OutS out_end, InI&& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		auto tmp = *begin;
		if (!predicate(tmp))
			break;
		*out = tmp;
	}
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_while(OutI&& out, InI&& begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_while(out, null_sentinel{}, begin, end, predicate);
}
template <typename OutI, typename InI, typename UnaryPred>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_while(OutI&& out, InI&& begin, UnaryPred predicate = {}) {
	algo::mut::copy_while(out, null_sentinel{}, begin, null_sentinel{}, predicate);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void copy_until(OutI&& out, OutS out_end, InI&& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		auto tmp = *begin;
		if (predicate(tmp))
			break;
		*out = tmp;
	}
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_until(OutI&& out, InI&& begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_until(out, null_sentinel{}, begin, end, predicate);
}
template <typename OutI, typename InI, typename UnaryPred>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_until(OutI&& out, InI&& begin, UnaryPred predicate = {}) {
	algo::mut::copy_until(out, null_sentinel{}, begin, null_sentinel{}, predicate);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void copy_through(OutI&& out, OutS out_end, InI&& begin, InS end, UnaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		auto tmp = *begin;
		*out = tmp;
		if (predicate(tmp))
			break;
	}
	if (begin != end && out != out_end)
		++begin, ++out;
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_through(OutI&& out, InI&& begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_through(out, null_sentinel{}, begin, end, predicate);
}
template <typename OutI, typename InI, typename UnaryPred>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_through(OutI&& out, InI&& begin, UnaryPred predicate = {}) {
	algo::mut::copy_through(out, null_sentinel{}, begin, null_sentinel{}, predicate);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename InI2, typename InS2,
	typename BinaryPred = algo::equal_to>
	requires impl::bounded_output_with_bounded_forward<OutI, OutS, InI, InS> && impl::bounded_forward<InI2, InS2>
constexpr void copy_until_block(
	OutI&& out, OutS out_end, InI&& begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
}
template <typename OutI, typename InI, typename InS, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::output_with_bounded_forward<OutI, InI, InS> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_until_block(OutI&& out, InI&& begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_until_block(out, null_sentinel{}, begin, end, begin2, end2, predicate);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename InI2, typename InS2,
	typename BinaryPred = algo::equal_to>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS> && impl::bounded_forward<InI2, InS2>
constexpr void copy_through_block(
	OutI&& out, OutS out_end, InI&& begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	auto* buffer = new std::iter_value_t<std::remove_reference_t<InI>>[end2 - begin2];
	std::ptrdiff_t idx = 0;
	// Initialize buffer while copying
	for (; idx < end2 - begin2 && out != out_end && begin != end; ++begin, ++out, ++idx) {
		buffer[idx] = *begin;
		*out = buffer[idx];
	}
	idx = 0;
	for (; out != out_end && begin != end; ++begin, ++out, idx = (idx + 1) % (end2 - begin2)) {
		if (algo::all_of_partial(ring_iterator(&buffer[0], &buffer[end2 - begin2], &buffer[idx]), null_sentinel{},
				begin2, end2, predicate))
			break;

		buffer[idx] = *begin;
		*out = buffer[idx];
	}
	delete[] buffer;
}
template <typename OutI, typename OutS, typename InI, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::bounded_output_with_input<OutI, OutS, InI> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded 1st input iterator")]]
constexpr void copy_through_block(
	OutI&& out, OutS out_end, InI&& begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, out_end, begin, null_sentinel{}, begin2, end2, predicate);
}
template <typename OutI, typename InI, typename InS, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::output_with_bounded_input<OutI, InI, InS> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_through_block(OutI&& out, InI&& begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, null_sentinel{}, begin, end, begin2, end2, predicate);
}
template <typename OutI, typename InI, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::output_with_input<OutI, InI> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded 1st input and output iterators")]]
constexpr void copy_through_block(OutI&& out, InI&& begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, null_sentinel{}, begin, null_sentinel{}, begin2, end2, predicate);
}

template <typename OutI, typename OutS, typename InI, typename InS, typename InI2, typename InS2,
	typename BinaryPred = algo::equal_to>
	requires impl::bounded_output_with_bounded_forward<OutI, OutS, InI, InS> && impl::bounded_forward<InI2, InS2>
constexpr void copy_through_block(
	OutI&& out, OutS out_end, InI&& begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	for (; begin != end && out != out_end; ++begin, ++out) {
		if (algo::all_of_partial(begin, end, begin2, end2, predicate))
			break;
		*out = *begin;
	}
	for (; begin != end && begin2 != end2 && out != out_end; begin++, begin2++, out++)
		*out = *begin;
}
template <typename OutI, typename OutS, typename InI, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::bounded_output_with_forward<OutI, OutS, InI> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded 1st input iterator")]]
constexpr void copy_through_block(
	OutI&& out, OutS out_end, InI&& begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, out_end, begin, null_sentinel{}, begin2, end2, predicate);
}
template <typename OutI, typename InI, typename InS, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::output_with_bounded_forward<OutI, InI, InS> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_through_block(OutI&& out, InI&& begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, null_sentinel{}, begin, end, begin2, end2, predicate);
}
template <typename OutI, typename InI, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::output_with_forward<OutI, InI> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded 1st input and output iterators")]]
constexpr void copy_through_block(OutI&& out, InI&& begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, null_sentinel{}, begin, null_sentinel{}, begin2, end2, predicate);
}

template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_input<I, S>
constexpr void iterate_through(I&& begin, S end, UnaryPred predicate = {}) {
	algo::mut::copy_through(null_iterator{}, null_sentinel{}, begin, end, predicate);
}
template <typename I, typename UnaryPred>
	requires impl::input<I>
[[deprecated("Unbounded iterator")]]
constexpr void iterate_through(I&& begin, UnaryPred predicate = {}) {
	algo::mut::iterate_through(begin, null_sentinel{}, predicate);
}

template <typename I, typename S, typename I2, typename S2, typename BinaryPred = algo::equal_to>
	requires impl::bounded_input<I, S> && impl::bounded_forward<I2, S2>
constexpr void iterate_through_block(I&& begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(null_iterator{}, null_sentinel{}, begin, end, begin2, end2, predicate);
}
template <typename I, typename I2, typename S2, typename BinaryPred = algo::equal_to>
	requires impl::input<I> && impl::bounded_forward<I2, S2>
[[deprecated("Unbounded 1st input iterator")]]
constexpr void iterate_through_block(I&& begin, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	algo::mut::iterate_through_block(begin, null_sentinel{}, begin2, end2, predicate);
}
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr OutI copy_if(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_if(out, out_end, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_if(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_if(out, begin, end, predicate);
	return out;
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr OutI copy_if_not(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_if_not(out, out_end, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_if_not(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_if_not(out, begin, end, predicate);
	return out;
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr OutI move_if(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::move_if(out, out_end, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr OutI move_if(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::move_if(out, begin, end, predicate);
	return out;
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr OutI move_if_not(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::move_if_not(out, out_end, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr OutI move_if_not(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::move_if_not(out, begin, end, predicate);
	return out;
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr OutI copy_while(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_while(out, out_end, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_while(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_while(out, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename UnaryPred>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr OutI copy_while(OutI out, InI begin, UnaryPred predicate = {}) {
	algo::mut::copy_while(out, begin, predicate);
	return out;
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr OutI copy_until(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_until(out, out_end, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_until(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_until(out, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename UnaryPred>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr OutI copy_until(OutI out, InI begin, UnaryPred predicate = {}) {
	algo::mut::copy_until(out, begin, predicate);
	return out;
}

template <typename OutI, typename OutS, typename InI, typename InS, typename UnaryPred>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr OutI copy_through(OutI out, OutS out_end, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_through(out, out_end, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename InS, typename UnaryPred>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_through(OutI out, InI begin, InS end, UnaryPred predicate = {}) {
	algo::mut::copy_through(out, begin, end, predicate);
	return out;
}
template <typename OutI, typename InI, typename UnaryPred>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr OutI copy_through(OutI out, InI begin, UnaryPred predicate = {}) {
	algo::mut::copy_through(out, begin, predicate);
	return out;
}

template <typename OutI, typename OutS, typename InI, typename InS, typename InI2, typename InS2,
	typename BinaryPred = algo::equal_to>
	requires impl::bounded_output_with_bounded_forward<OutI, OutS, InI, InS> && impl::bounded_forward<InI2, InS2>
constexpr OutI copy_until_block(
	OutI out, OutS out_end, InI begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_until_block(out, out_end, begin, end, begin2, end2, predicate);
	return out;
}
template <typename OutI, typename InI, typename InS, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::output_with_bounded_forward<OutI, InI, InS> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_until_block(OutI out, InI begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_until_block(out, begin, end, begin2, end2, predicate);
	return out;
}

template <typename OutI, typename OutS, typename InI, typename InS, typename InI2, typename InS2,
	typename BinaryPred = algo::equal_to>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS> && impl::bounded_forward<InI2, InS2>
constexpr OutI copy_through_block(
	OutI out, OutS out_end, InI begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, out_end, begin, end, begin2, end2, predicate);
	return out;
}
template <typename OutI, typename OutS, typename InI, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::bounded_output_with_input<OutI, OutS, InI> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded 1st input iterator")]]
constexpr OutI copy_through_block(
	OutI out, OutS out_end, InI begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, out_end, begin, begin2, end2, predicate);
	return out;
}
template <typename OutI, typename InI, typename InS, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::output_with_bounded_input<OutI, InI, InS> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded output iterator")]]
constexpr OutI copy_through_block(OutI out, InI begin, InS end, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, begin, end, begin2, end2, predicate);
	return out;
}
template <typename OutI, typename InI, typename InI2, typename InS2, typename BinaryPred = algo::equal_to>
	requires impl::output_with_input<OutI, InI> && impl::bounded_forward<InI2, InS2>
[[deprecated("Unbounded 1st input and output iterators")]]
constexpr OutI copy_through_block(OutI out, InI begin, InI2 begin2, InS2 end2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, begin, begin2, end2, predicate);
	return out;
}
}