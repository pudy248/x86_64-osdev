#pragma once
#include "concepts.hpp"
#include <stl/algorithms.hpp>
#include <utility>

namespace ranges {
namespace mut {
template <ranges::range OutR, ranges::range InR>
constexpr void copy(OutR&& out, InR&& range) {
	algo::mut::copy(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range));
}
template <ranges::range OutR, ranges::range InR>
constexpr void copy_n(OutR&& out, InR&& range, ranges::difference_t<InR> n) {
	algo::mut::copy_n(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), n);
}

template <ranges::range OutR, ranges::range InR>
constexpr void move(OutR&& out, InR&& range) {
	algo::mut::move(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range));
}
template <ranges::range OutR, ranges::range InR>
constexpr void move_n(OutR&& out, const InR& range, ranges::difference_t<InR> n) {
	algo::mut::move_n(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), n);
}

template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr void copy_while(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	algo::mut::copy_while(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
						  std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr void copy_until(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	algo::mut::copy_until(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
						  std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr void copy_through(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	algo::mut::copy_through(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
							std::move(predicate));
}

template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename BinaryPred = algo::equal_to>
constexpr void copy_until_block(OutR&& out, InR&& range, const InR2& range2, BinaryPred predicate = {}) {
	algo::mut::copy_until_block(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
								ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range InR, ranges::range InR2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<ranges::iterator_t<InR>>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_through_block(OutI&& out, InR&& range, const InR2& range2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(out, ranges::begin(range), ranges::end(range), ranges::begin(range2),
								  ranges::end(range2), std::move(predicate));
}
template <ranges::range OutR, std::input_iterator InI, ranges::range InR2, typename BinaryPred = algo::equal_to>
[[deprecated("Unbounded 1st iterator")]]
constexpr void copy_through_block(OutR&& out, InI&& begin, const InR2& range2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(ranges::begin(out), ranges::end(out), begin, ranges::begin(range2),
								  ranges::end(range2), std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename BinaryPred = algo::equal_to>
constexpr void copy_through_block(OutR&& out, InR&& range, const InR2& range2, BinaryPred predicate = {}) {
	algo::mut::copy_through_block(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
								  ranges::begin(range2), ranges::end(range2), std::move(predicate));
}

template <ranges::range R, typename UnaryPred>
constexpr void iterate_through(R&& range, UnaryPred predicate = {}) {
	algo::mut::iterate_through(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <std::input_iterator I, ranges::range R2, typename BinaryPred = algo::equal_to>
[[deprecated("Unbounded 1st iterator")]]
constexpr void iterate_through_block(I&& begin, const R2& range2, BinaryPred predicate = {}) {
	algo::mut::iterate_through_block(begin, ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred = algo::equal_to>
constexpr void iterate_through_block(R&& range, const R2& range2, BinaryPred predicate = {}) {
	algo::mut::iterate_through_block(ranges::begin(range), ranges::end(range), ranges::begin(range2),
									 ranges::end(range2), std::move(predicate));
}
}
}