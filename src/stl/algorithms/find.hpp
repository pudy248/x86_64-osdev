#pragma once
#include "concepts.hpp"
#include "operators.hpp"
#include "predicate.hpp"
#include <iterator>
#include <stl/iterator.hpp>

namespace algo {
namespace mut {
template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_input<I, S>
constexpr void find_if(I&& begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (predicate(*begin))
			break;
}

template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_input<I, S>
constexpr void find_if_not(I&& begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (!predicate(*begin))
			break;
}

template <typename I, typename S, typename I2, typename S2, typename BinaryPred>
	requires impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr void find_if(I&& begin, S end, I2&& begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			break;
}
template <typename I, typename S, typename I2, typename BinaryPred>
	requires impl::bounded_input<I, S> && impl::input<I2>
[[deprecated("Unbounded 2nd input iterator")]]
constexpr void find_if(I&& begin, S end, I2&& begin2, BinaryPred predicate = {}) {
	algo::mut::find_if(begin, end, begin2, null_sentinel{}, predicate);
}

template <typename I, typename S, typename T>
	requires impl::bounded_input<I, S>
constexpr void find(I&& begin, S end, T value) {
	algo::mut::find_if(begin, end, algo::equal_to_v{value});
}

template <typename IT, typename ST, typename IV, typename SV>
	requires impl::bounded_input<IT, ST> && impl::bounded_forward<IV, SV>
constexpr void find_set(IT&& tbegin, ST tend, IV&& vbegin, SV vend) {
	for (; tbegin != tend; ++tbegin) {
		auto tmp = *tbegin;
		for (auto iter = vbegin; iter != vend; ++iter) {
			if (tmp == *iter) {
				vbegin = iter;
				return;
			}
		}
	}
	vbegin = vend;
}

template <typename IT, typename ST, typename IV, typename SV, typename BinaryPred>
	requires impl::bounded_forward<IT, ST> && impl::bounded_forward<IV, SV>
constexpr void find_if_block(IT&& tbegin, ST tend, IV vbegin, SV vend, BinaryPred predicate = {}) {
	for (; tbegin != tend; ++tbegin)
		if (algo::all_of_partial(tbegin, tend, vbegin, vend, predicate))
			break;
}

template <typename IT, typename ST, typename IV, typename SV>
	requires impl::bounded_input<IT, ST> && impl::bounded_forward<IV, SV>
constexpr void find_block(IT&& tbegin, ST tend, IV vbegin, SV vend) {
	algo::mut::find_if_block(tbegin, tend, vbegin, vend, algo::equal_to{});
}
}

template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_input<I, S>
constexpr I find_if(I begin, S end, UnaryPred predicate = {}) {
	algo::mut::find_if(begin, end, predicate);
	return begin;
}

template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_input<I, S>
constexpr I find_if_not(I begin, S end, UnaryPred predicate = {}) {
	algo::mut::find_if_not(begin, end, predicate);
	return begin;
}

template <typename I, typename S, typename I2, typename BinaryPred>
	requires impl::bounded_input<I, S> && impl::input<I2>
[[deprecated("Unbounded 2nd input iterator")]]
constexpr I find_if(I begin, S end, I2 begin2, BinaryPred predicate = {}) {
	algo::mut::find_if(begin, end, begin2, predicate);
	return begin;
}
template <typename I, typename S, typename I2, typename S2, typename BinaryPred>
	requires impl::bounded_input<I, S> && impl::bounded_input<I2, S2>
constexpr I find_if(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	algo::mut::find_if(begin, end, begin2, end2, predicate);
	return begin;
}

template <typename I, typename S, typename T>
	requires impl::bounded_input<I, S>
constexpr I find(I begin, S end, T value) {
	algo::mut::find(begin, end, value);
	return begin;
}

template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_forward<I, S>
constexpr std::iter_difference_t<I> where_if(I begin, S end, UnaryPred predicate = {}) {
	I iter = begin;
	for (; begin != end; ++begin)
		if (predicate(*begin))
			break;
	return begin == end ? -1 : begin - iter;
}

template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_forward<I, S>
constexpr std::iter_difference_t<I> where_not(I begin, S end, UnaryPred predicate = {}) {
	I iter = begin;
	for (; begin != end; ++begin)
		if (!predicate(*begin))
			break;
	return begin == end ? -1 : begin - iter;
}

template <typename I, typename S, typename I2, typename S2, typename BinaryPred>
	requires impl::bounded_forward<I, S> && impl::bounded_input<I2, S2>
constexpr std::iter_difference_t<I> where_if(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	I iter = begin;
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			break;
	return begin == end ? -1 : begin - iter;
}
template <typename I, typename S, typename I2, typename BinaryPred>
	requires impl::bounded_forward<I, S> && impl::input<I2>
[[deprecated("Unbounded 2nd input iterator")]]
constexpr std::iter_difference_t<I> where_if(I begin, S end, I2 begin2, BinaryPred predicate = {}) {
	return algo::where_if(begin, end, begin2, null_sentinel{}, predicate);
}

template <typename I, typename S, typename T>
	requires impl::bounded_forward<I, S>
constexpr std::iter_difference_t<I> where_is(I begin, S end, T value) {
	return algo::where_if(begin, end, algo::equal_to_v{value});
}

template <typename IT, typename ST, typename IV, typename SV>
	requires impl::bounded_input<IT, ST> && impl::bounded_forward<IV, SV>
constexpr std::pair<IT, IV> find_set(IT tbegin, ST tend, IV vbegin, SV vend) {
	algo::mut::find_set(tbegin, tend, vbegin, vend);
	return {tbegin, vbegin};
}

template <typename IT, typename ST, typename IV, typename SV>
	requires impl::bounded_input<IT, ST> && impl::bounded_forward<IV, SV>
constexpr IT find_first_of(IT tbegin, ST tend, IV vbegin, SV vend) {
	return algo::find_set(tbegin, tend, vbegin, vend).first;
}

template <typename IT, typename ST, typename IV, typename SV, typename BinaryPred>
	requires impl::bounded_forward<IT, ST> && impl::bounded_forward<IV, SV>
constexpr IT find_if_block(IT tbegin, ST tend, IV vbegin, SV vend, BinaryPred predicate = {}) {
	algo::mut::find_if_block(tbegin, tend, vbegin, vend, predicate);
	return tbegin;
}

template <typename IT, typename ST, typename IV, typename SV>
	requires impl::bounded_input<IT, ST> && impl::bounded_forward<IV, SV>
constexpr IT find_block(IT tbegin, ST tend, IV vbegin, SV vend) {
	algo::mut::find_block(tbegin, tend, vbegin, vend);
	return tbegin;
}

template <typename I, typename S, typename UnaryPred>
	requires impl::bounded_input<I, S>
constexpr std::iter_difference_t<I> count_if(I begin, S end, UnaryPred predicate = {}) {
	std::iter_difference_t<I> c = 0;
	for (std::iter_difference_t<I> i = 0; begin != end; ++i, ++begin)
		if (predicate(*begin))
			c++;
	return c;
}

template <typename I, typename S, typename T>
	requires impl::bounded_input<I, S>
constexpr std::iter_difference_t<I> count(I begin, S end, const T& value) {
	return algo::count_if(begin, end, algo::equal_to_v{value});
}
template <typename I, typename S, typename I2, typename S2>
	requires impl::bounded_input<I, S> && impl::bounded_forward<I2, S2>
constexpr std::iter_difference_t<I> count_all(I begin, S end, I2 begin2, S2 end2) {
	return algo::count_if(begin, end, algo::equal_to_any{begin2, end2});
}
}