#pragma once
#include "operators.hpp"
#include "predicate.hpp"
#include <iterator>
#include <stl/iterator.hpp>

namespace algo {
template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryPred>
constexpr I find_if(I begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (predicate(*begin))
			break;
	return begin;
}

template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryPred>
constexpr I find_if_not(I begin, S end, UnaryPred predicate = {}) {
	for (; begin != end; ++begin)
		if (!predicate(*begin))
			break;
	return begin;
}

template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, typename BinaryPred>
[[deprecated("Unbounded 2nd input iterator")]]
constexpr I find_if(I begin, S end, I2 begin2, BinaryPred predicate = {}) {
	for (; begin != end; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			break;
	return begin;
}
template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred>
constexpr I find_if(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			break;
	return begin;
}

template <std::input_iterator I, std::sentinel_for<I> S, typename T>
constexpr I find(I begin, S end, T value) {
	return algo::find_if(begin, end, algo::equal_to_v{ value });
}

template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryPred>
constexpr std::iter_difference_t<I> where_if(I begin, S end, UnaryPred predicate = {}) {
	I iter = begin;
	for (; begin != end; ++begin)
		if (predicate(*begin))
			break;
	return begin == end ? -1 : begin - iter;
}

template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryPred>
constexpr std::iter_difference_t<I> where_not(I begin, S end, UnaryPred predicate = {}) {
	I iter = begin;
	for (; begin != end; ++begin)
		if (!predicate(*begin))
			break;
	return begin == end ? -1 : begin - iter;
}

template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, typename BinaryPred>
[[deprecated("Unbounded 2nd input iterator")]]
constexpr std::iter_difference_t<I> where_if(I begin, S end, I2 begin2, BinaryPred predicate = {}) {
	I iter = begin;
	for (; begin != end; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			break;
	return begin == end ? -1 : begin - iter;
}
template <std::input_iterator I, std::sentinel_for<I> S, std::input_iterator I2, std::sentinel_for<I2> S2,
		  typename BinaryPred>
constexpr std::iter_difference_t<I> where_if(I begin, S end, I2 begin2, S2 end2, BinaryPred predicate = {}) {
	I iter = begin;
	for (; begin != end && begin2 != end2; ++begin, ++begin2)
		if (predicate(*begin, *begin2))
			break;
	return begin == end ? -1 : begin - iter;
}

template <std::input_iterator I, std::sentinel_for<I> S, typename T>
constexpr std::iter_difference_t<I> where_is(I begin, S end, T value) {
	return algo::where_if(begin, end, algo::equal_to_v{ value });
}

template <std::input_iterator ITarget, std::sentinel_for<ITarget> STarget, std::forward_iterator IValues,
		  std::sentinel_for<IValues> SValues>
constexpr std::pair<ITarget, IValues> find_set(ITarget tbegin, STarget tend, IValues vbegin, SValues vend) {
	for (; tbegin != tend; ++tbegin) {
		for (auto iter = vbegin; iter != vend; ++iter) {
			if (*tbegin == *iter)
				return { tbegin, iter };
		}
	}
	return { tend, vend };
}

template <std::input_iterator ITarget, std::sentinel_for<ITarget> STarget, std::forward_iterator IValues,
		  std::sentinel_for<IValues> SValues>
constexpr ITarget find_first_of(ITarget tbegin, STarget tend, IValues vbegin, SValues vend) {
	return find_set(tbegin, tend, vbegin, vend).first;
}

template <std::input_iterator ITarget, std::sentinel_for<ITarget> STarget, std::forward_iterator IValues,
		  std::sentinel_for<IValues> SValues, typename BinaryPred>
constexpr ITarget find_if_block(ITarget tbegin, STarget tend, IValues vbegin, SValues vend, BinaryPred predicate = {}) {
	for (; tbegin != tend; ++tbegin)
		if (algo::all_of_partial(tbegin, tend, vbegin, vend, predicate))
			break;
	return tbegin;
}

template <std::forward_iterator ITarget, std::sentinel_for<ITarget> STarget, std::forward_iterator IValues,
		  std::sentinel_for<IValues> SValues>
constexpr ITarget find_block(ITarget tbegin, STarget tend, IValues vbegin, SValues vend) {
	return algo::find_if_block(tbegin, tend, vbegin, vend, algo::equal_to{});
}

template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryPred>
constexpr std::iter_difference_t<I> count_if(I begin, S end, UnaryPred predicate = {}) {
	std::iter_difference_t<I> c = 0;
	for (std::iter_difference_t<I> i = 0; begin != end; ++i, ++begin)
		if (predicate(*begin))
			c++;
	return c;
}

template <std::input_iterator I, std::sentinel_for<I> S, typename T>
constexpr std::iter_difference_t<I> count(I begin, S end, const T& value) {
	return algo::count_if(begin, end, algo::equal_to_v{ value });
}
template <std::input_iterator I, std::sentinel_for<I> S, std::forward_iterator I2, std::sentinel_for<I2> S2>
constexpr std::iter_difference_t<I> count_all(I begin, S end, I2 begin2, S2 end2) {
	return algo::count_if(begin, end, algo::equal_to_any{ begin2, end2 });
}
}