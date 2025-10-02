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
constexpr void move_n(OutR&& out, InR&& range, ranges::difference_t<InR> n) {
	algo::mut::move_n(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), n);
}

template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr void copy_while(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	algo::mut::copy_while(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr void copy_until(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	algo::mut::copy_until(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr void copy_through(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	algo::mut::copy_through(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
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
	algo::mut::copy_through_block(
		ranges::begin(out), ranges::end(out), begin, ranges::begin(range2), ranges::end(range2), std::move(predicate));
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
	algo::mut::iterate_through_block(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
}
namespace val {
template <ranges::range R, typename Init = ranges::value_t<R>, typename BinaryOp = algo::add>
constexpr Init reduce(R&& range, Init init = {}, BinaryOp op = {}) {
	return algo::reduce(ranges::begin(range), ranges::end(range), std::move(init), std::move(op));
}

template <ranges::range OutR, ranges::range InR, typename UnaryOp>
constexpr void transform(OutR&& out, InR&& range, UnaryOp op = {}) {
	algo::transform(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(op));
}

template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename BinaryOp>
constexpr void transform(OutR&& out, InR&& range, const InR2& range2, BinaryOp op = {}) {
	algo::transform(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
		ranges::begin(range2), ranges::end(range2), std::move(op));
}

template <ranges::range R, typename Init = ranges::value_t<R>, typename UnaryOp, typename BinaryOp = algo::add>
constexpr Init transform_reduce(R&& range, Init init = {}, UnaryOp transform = {}, BinaryOp reduce = {}) {
	return algo::transform_reduce(
		ranges::begin(range), ranges::end(range), std::move(init), std::move(transform), std::move(reduce));
}

template <ranges::range R, ranges::range R2, typename Init = ranges::value_t<R>, typename BinaryOp = algo::mul,
	typename BinaryOp2 = algo::add>
constexpr Init transform_reduce(
	R&& range, const R2& range2, Init init = {}, BinaryOp transform = {}, BinaryOp2 reduce = {}) {
	return algo::transform_reduce(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
		std::move(init), std::move(transform), std::move(reduce));
}

template <ranges::range OutR, ranges::range InR, typename Init = ranges::value_t<InR>, typename BinaryOp = algo::add,
	typename UnaryOp = algo::identity>
constexpr Init reduce_transform(OutR&& out, InR&& range, Init init = {}, BinaryOp reduce = {}, UnaryOp transform = {}) {
	return algo::reduce_transform(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
		std::move(init), std::move(reduce), std::move(transform));
}

template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename Init = ranges::value_t<InR>,
	typename BinaryOp, typename BinaryOp2>
constexpr Init reduce_transform(
	InR&& range, const InR2& range2, OutR&& out, Init init = {}, BinaryOp reduce = {}, BinaryOp2 transform = {}) {
	return algo::reduce_transform(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
		ranges::begin(range2), ranges::end(range2), std::move(init), std::move(reduce), std::move(transform));
}

template <ranges::range R, typename UnaryPred>
constexpr ranges::iterator_t<R> find_if(R&& range, UnaryPred predicate = {}) {
	return algo::find_if(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, typename UnaryPred>
constexpr ranges::difference_t<R> find_if_not(R&& range, UnaryPred predicate = {}) {
	return algo::find_if_not(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr ranges::iterator_t<R> find_if(R&& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::find_if(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range R, typename T>
constexpr ranges::iterator_t<R> find(R&& range, T value) {
	return algo::find(ranges::begin(range), ranges::end(range), std::move(value));
}

template <ranges::range R, typename UnaryPred>
constexpr ranges::difference_t<R> where_if(R&& range, UnaryPred predicate = {}) {
	return algo::where_if(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, typename UnaryPred>
constexpr ranges::difference_t<R> where_not(R&& range, UnaryPred predicate = {}) {
	return algo::where_not(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr ranges::difference_t<R> where_if(R&& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::where_if(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range R, typename T>
constexpr ranges::difference_t<R> where_is(R&& range, T value) {
	return algo::where_is(ranges::begin(range), ranges::end(range), std::move(value));
}

template <ranges::range RTarget, ranges::range RValues>
constexpr std::pair<ranges::iterator_t<RTarget>, ranges::iterator_t<RValues>> find_set(RTarget target, RValues values) {
	return algo::find_set(ranges::begin(target), ranges::end(target), ranges::begin(values), ranges::end(values));
}
template <ranges::range RTarget, ranges::range RValues>
constexpr ranges::iterator_t<RTarget> find_first_of(RTarget target, RValues values) {
	return algo::find_first_of(ranges::begin(target), ranges::end(target), ranges::begin(values), ranges::end(values));
}
template <ranges::range RTarget, ranges::range RValues, typename BinaryPred>
constexpr ranges::iterator_t<RTarget> find_if_block(RTarget target, RValues values, BinaryPred predicate = {}) {
	return algo::find_if_block(
		ranges::begin(target), ranges::end(target), ranges::begin(values), ranges::end(values), predicate);
}
template <ranges::range RTarget, ranges::range RValues>
constexpr ranges::iterator_t<RTarget> find_block(RTarget target, RValues values) {
	return algo::find_block(ranges::begin(target), ranges::end(target), ranges::begin(values), ranges::end(values));
}

template <ranges::range R, typename UnaryPred>
constexpr ranges::difference_t<R> count_if(R&& range, UnaryPred pred = {}) {
	return algo::count_if(ranges::begin(range), ranges::end(range), std::move(pred));
}
template <ranges::range R, typename T>
constexpr ranges::difference_t<R> count(R&& range, const T& value) {
	return algo::count(ranges::begin(range), ranges::end(range), std::move(value));
}
template <ranges::range R, ranges::range R2>
constexpr ranges::difference_t<R> count_all(R&& range, const R2& range2) {
	return algo::count_all(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2));
}

template <ranges::range R, typename UnaryPred>
constexpr bool all_of(R&& range, UnaryPred predicate = {}) {
	return algo::all_of(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr bool all_of_partial(R&& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::all_of_partial(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr bool all_of(R&& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::all_of(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range R, typename UnaryPred>
constexpr bool any_of(R&& range, UnaryPred predicate = {}) {
	return algo::any_of(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr bool any_of(R&& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::any_of(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range R, typename UnaryPred>
constexpr bool none_of(R&& range, UnaryPred predicate = {}) {
	return algo::none_of(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr bool none_of(R&& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::none_of(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}

template <ranges::range R, ranges::range R2, typename BinaryPred = algo::equal_to>
constexpr bool equal(R&& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::equal(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred = algo::equal_to>
constexpr bool starts_with(R&& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::starts_with(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred = algo::equal_to>
constexpr bool ends_with(R&& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::ends_with(
		ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2), std::move(predicate));
}

template <ranges::range OutR, ranges::range InR>
constexpr void copy(OutR&& out, InR&& range) {
	algo::copy(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range));
}
template <ranges::range OutR, ranges::range InR>
constexpr void copy_n(OutR&& out, InR&& range, ranges::difference_t<InR> n) {
	algo::copy_n(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), n);
}

template <ranges::range OutR, ranges::range InR>
constexpr void move(OutR&& out, InR&& range) {
	algo::move(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range));
}
template <ranges::range OutR, ranges::range InR>
constexpr void move_n(OutR&& out, InR&& range, ranges::difference_t<InR> n) {
	algo::move_n(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), n);
}

template <ranges::range R, typename T>
constexpr void fill(R& range, const T& value) {
	algo::fill(ranges::begin(range), ranges::end(range), std::move(value));
}
template <ranges::range R, typename T>
constexpr void fill_n(R&& range, ranges::difference_t<R> n, const T& value) {
	algo::fill_n(ranges::begin(range), ranges::end(range), n, std::move(value));
}

template <ranges::range R, typename VoidOp>
constexpr void generate(R&& range, VoidOp generator = {}) {
	algo::generate(ranges::begin(range), ranges::end(range), std::move(generator));
}
template <ranges::range R, typename VoidOp>
constexpr void generate_n(R&& range, ranges::difference_t<R> n, VoidOp generator = {}) {
	algo::generate_n(ranges::begin(range), ranges::end(range), n, std::move(generator));
}

template <ranges::range R, typename UnaryOp>
constexpr void indexed_generate(R&& range, UnaryOp generator = {}) {
	algo::indexed_generate(ranges::begin(range), ranges::end(range), std::move(generator));
}
template <ranges::range R, typename UnaryOp>
constexpr void indexed_generate_n(R&& range, ranges::difference_t<R> n, UnaryOp generator = {}) {
	algo::indexed_generate_n(ranges::begin(range), ranges::end(range), n, std::move(generator));
}

template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_if(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	return algo::copy_if(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_if_not(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	return algo::copy_if_not(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
}

template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> move_if(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	return algo::move_if(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> move_if_not(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	return algo::move_if_not(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
}

template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_while(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	return algo::copy_while(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_until(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	return algo::copy_until(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_through(OutR&& out, InR&& range, UnaryPred predicate = {}) {
	return algo::copy_through(
		ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(predicate));
}

template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename BinaryPred = algo::equal_to>
constexpr ranges::iterator_t<OutR> copy_until_block(
	OutR&& out, InR&& range, const InR2& range2, BinaryPred predicate = {}) {
	return algo::copy_until_block(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
		ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range InR, ranges::range InR2, typename BinaryPred = algo::equal_to,
	std::output_iterator<std::iter_value_t<ranges::iterator_t<InR>>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_through_block(OutI out, InR&& begin, const InR2& range2, BinaryPred predicate = {}) {
	algo::copy_through_block(
		ranges::begin(out), ranges::end(out), begin, ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range OutR, std::input_iterator InI, ranges::range InR2, typename BinaryPred = algo::equal_to>
[[deprecated("Unbounded 1st iterator")]]
constexpr ranges::iterator_t<OutR> copy_through_block(
	OutR&& out, InI begin, const InR2& range2, BinaryPred predicate = {}) {
	return algo::copy_through_block(
		ranges::begin(out), ranges::end(out), begin, ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename BinaryPred = algo::equal_to>
constexpr ranges::iterator_t<OutR> copy_through_block(
	OutR&& out, InR&& range, const InR2& range2, BinaryPred predicate = {}) {
	return algo::copy_through_block(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
		ranges::begin(range2), ranges::end(range2), std::move(predicate));
}

}
}