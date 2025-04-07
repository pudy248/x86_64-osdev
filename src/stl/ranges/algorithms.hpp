#pragma once
#include "concepts.hpp"
#include <stl/algorithms.hpp>
#include <utility>

namespace ranges {
template <ranges::range R, typename Init = ranges::value_t<R>, typename BinaryOp = algo::add>
constexpr Init reduce(const R& range, Init init = {}, BinaryOp op = {}) {
	return algo::reduce(ranges::begin(range), ranges::end(range), std::move(init), std::move(op));
}

template <ranges::range OutR, ranges::range InR, typename UnaryOp>
constexpr void transform(OutR&& out, const InR& range, UnaryOp op = {}) {
	algo::transform(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), std::move(op));
}

template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename BinaryOp>
constexpr void transform(OutR&& out, const InR& range, const InR2& range2, BinaryOp op = {}) {
	algo::transform(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
					ranges::begin(range2), ranges::end(range2), std::move(op));
}

template <ranges::range R, typename Init = ranges::value_t<R>, typename UnaryOp, typename BinaryOp = algo::add>
constexpr Init transform_reduce(const R& range, Init init = {}, UnaryOp transform = {}, BinaryOp reduce = {}) {
	return algo::transform_reduce(ranges::begin(range), ranges::end(range), std::move(init), std::move(transform),
								  std::move(reduce));
}

template <ranges::range R, ranges::range R2, typename Init = ranges::value_t<R>, typename BinaryOp = algo::mul,
		  typename BinaryOp2 = algo::add>
constexpr Init transform_reduce(const R& range, const R2& range2, Init init = {}, BinaryOp transform = {},
								BinaryOp2 reduce = {}) {
	return algo::transform_reduce(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
								  std::move(init), std::move(transform), std::move(reduce));
}

template <ranges::range OutR, ranges::range InR, typename Init = ranges::value_t<InR>, typename BinaryOp = algo::add,
		  typename UnaryOp = algo::identity>
constexpr Init reduce_transform(OutR&& out, const InR& range, Init init = {}, BinaryOp reduce = {},
								UnaryOp transform = {}) {
	return algo::reduce_transform(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
								  std::move(init), std::move(reduce), std::move(transform));
}

template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename Init = ranges::value_t<InR>,
		  typename BinaryOp, typename BinaryOp2>
constexpr Init reduce_transform(const InR& range, const InR2& range2, OutR&& out, Init init = {}, BinaryOp reduce = {},
								BinaryOp2 transform = {}) {
	return algo::reduce_transform(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
								  ranges::begin(range2), ranges::end(range2), std::move(init), std::move(reduce),
								  std::move(transform));
}

template <ranges::range R, typename UnaryPred>
constexpr ranges::iterator_t<R> find_if(const R& range, UnaryPred predicate = {}) {
	return algo::find_if(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, typename UnaryPred>
constexpr ranges::difference_t<R> find_if_not(const R& range, UnaryPred predicate = {}) {
	return algo::find_if_not(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr ranges::iterator_t<R> find_if(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::find_if(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
						 std::move(predicate));
}
template <ranges::range R, typename T>
constexpr ranges::iterator_t<R> find(const R& range, T value) {
	return algo::find(ranges::begin(range), ranges::end(range), std::move(value));
}

template <ranges::range R, typename UnaryPred>
constexpr ranges::difference_t<R> where_if(const R& range, UnaryPred predicate = {}) {
	return algo::where_if(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, typename UnaryPred>
constexpr ranges::difference_t<R> where_not(const R& range, UnaryPred predicate = {}) {
	return algo::where_not(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr ranges::difference_t<R> where_if(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::where_if(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
						  std::move(predicate));
}
template <ranges::range R, typename T>
constexpr ranges::difference_t<R> where_is(const R& range, T value) {
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
	return algo::find_if_block(ranges::begin(target), ranges::end(target), ranges::begin(values), ranges::end(values),
							   predicate);
}
template <ranges::range RTarget, ranges::range RValues>
constexpr ranges::iterator_t<RTarget> find_block(RTarget target, RValues values) {
	return algo::find_block(ranges::begin(target), ranges::end(target), ranges::begin(values), ranges::end(values));
}

template <ranges::range R, typename UnaryPred>
constexpr ranges::difference_t<R> count_if(const R& range, UnaryPred pred = {}) {
	return algo::count_if(ranges::begin(range), ranges::end(range), std::move(pred));
}
template <ranges::range R, typename T>
constexpr ranges::difference_t<R> count(const R& range, const T& value) {
	return algo::count(ranges::begin(range), ranges::end(range), std::move(value));
}
template <ranges::range R, ranges::range R2>
constexpr ranges::difference_t<R> count_all(const R& range, const R2& range2) {
	return algo::count_all(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2));
}

template <ranges::range R, typename UnaryPred>
constexpr bool all_of(const R& range, UnaryPred predicate = {}) {
	return algo::all_of(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr bool all_of_partial(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::all_of_partial(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
								std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr bool all_of(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::all_of(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
						std::move(predicate));
}
template <ranges::range R, typename UnaryPred>
constexpr bool any_of(const R& range, UnaryPred predicate = {}) {
	return algo::any_of(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr bool any_of(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::any_of(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
						std::move(predicate));
}
template <ranges::range R, typename UnaryPred>
constexpr bool none_of(const R& range, UnaryPred predicate = {}) {
	return algo::none_of(ranges::begin(range), ranges::end(range), std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred>
constexpr bool none_of(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::none_of(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
						 std::move(predicate));
}

template <ranges::range R, ranges::range R2, typename BinaryPred = algo::equal_to>
constexpr bool equal(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::equal(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
					   std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred = algo::equal_to>
constexpr bool starts_with(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::starts_with(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
							 std::move(predicate));
}
template <ranges::range R, ranges::range R2, typename BinaryPred = algo::equal_to>
constexpr bool ends_with(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::ends_with(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
						   std::move(predicate));
}

template <ranges::range R, ranges::range R2, typename BinaryPred = algo::equal_to>
constexpr ranges::iterator_t<R> search(const R& range, const R2& range2, BinaryPred predicate = {}) {
	return algo::search(ranges::begin(range), ranges::end(range), ranges::begin(range2), ranges::end(range2),
						std::move(predicate));
}

template <ranges::range OutR, ranges::range InR>
constexpr void copy(OutR&& out, const InR& range) {
	algo::copy(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range));
}
template <ranges::range OutR, ranges::range InR>
constexpr void copy_n(OutR&& out, const InR& range, ranges::difference_t<InR> n) {
	algo::copy_n(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), n);
}

template <ranges::range OutR, ranges::range InR>
constexpr void move(OutR&& out, const InR& range) {
	algo::move(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range));
}
template <ranges::range OutR, ranges::range InR>
constexpr void move_n(OutR&& out, const InR& range, ranges::difference_t<InR> n) {
	algo::move_n(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range), n);
}

template <ranges::range R, typename T>
constexpr void fill(R& range, const T& value) {
	algo::fill(ranges::begin(range), ranges::end(range), std::move(value));
}
template <ranges::range R, typename T>
constexpr void fill_n(const R& range, ranges::difference_t<R> n, const T& value) {
	algo::fill_n(ranges::begin(range), ranges::end(range), n, std::move(value));
}

template <ranges::range R, typename VoidOp>
constexpr void generate(const R& range, VoidOp generator = {}) {
	algo::generate(ranges::begin(range), ranges::end(range), std::move(generator));
}
template <ranges::range R, typename VoidOp>
constexpr void generate_n(const R& range, ranges::difference_t<R> n, VoidOp generator = {}) {
	algo::generate_n(ranges::begin(range), ranges::end(range), n, std::move(generator));
}

template <ranges::range R, typename UnaryOp>
constexpr void indexed_generate(const R& range, UnaryOp generator = {}) {
	algo::indexed_generate(ranges::begin(range), ranges::end(range), std::move(generator));
}
template <ranges::range R, typename UnaryOp>
constexpr void indexed_generate_n(const R& range, ranges::difference_t<R> n, UnaryOp generator = {}) {
	algo::indexed_generate_n(ranges::begin(range), ranges::end(range), n, std::move(generator));
}

template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_if(OutR&& out, const InR& range, UnaryPred predicate = {}) {
	return algo::copy_if(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
						 std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_if_not(OutR&& out, const InR& range, UnaryPred predicate = {}) {
	return algo::copy_if_not(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
							 std::move(predicate));
}

template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> move_if(OutR&& out, const InR& range, UnaryPred predicate = {}) {
	return algo::move_if(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
						 std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> move_if_not(OutR&& out, const InR& range, UnaryPred predicate = {}) {
	return algo::move_if_not(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
							 std::move(predicate));
}

template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_while(OutR&& out, const InR& range, UnaryPred predicate = {}) {
	return algo::copy_while(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
							std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_until(OutR&& out, const InR& range, UnaryPred predicate = {}) {
	return algo::copy_until(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
							std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, typename UnaryPred>
constexpr ranges::iterator_t<OutR> copy_through(OutR&& out, const InR& range, UnaryPred predicate = {}) {
	return algo::copy_through(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
							  std::move(predicate));
}

template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename BinaryPred = algo::equal_to>
constexpr ranges::iterator_t<OutR> copy_until_block(OutR&& out, const InR& range, const InR2& range2,
													BinaryPred predicate = {}) {
	return algo::copy_until_block(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
								  ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
template <ranges::range InR, ranges::range InR2, typename BinaryPred = algo::equal_to,
		  std::output_iterator<std::iter_value_t<ranges::iterator_t<InR>>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_through_block(OutI out, const InR& begin, const InR2& range2, BinaryPred predicate = {}) {
	algo::copy_through_block(ranges::begin(out), ranges::end(out), begin, ranges::begin(range2), ranges::end(range2),
							 std::move(predicate));
}
template <ranges::range OutR, std::input_iterator InI, ranges::range InR2, typename BinaryPred = algo::equal_to>
[[deprecated("Unbounded 1st iterator")]]
constexpr ranges::iterator_t<OutR> copy_through_block(OutR&& out, InI begin, const InR2& range2,
													  BinaryPred predicate = {}) {
	return algo::copy_through_block(ranges::begin(out), ranges::end(out), begin, ranges::begin(range2),
									ranges::end(range2), std::move(predicate));
}
template <ranges::range OutR, ranges::range InR, ranges::range InR2, typename BinaryPred = algo::equal_to>
constexpr ranges::iterator_t<OutR> copy_through_block(OutR&& out, const InR& range, const InR2& range2,
													  BinaryPred predicate = {}) {
	return algo::copy_through_block(ranges::begin(out), ranges::end(out), ranges::begin(range), ranges::end(range),
									ranges::begin(range2), ranges::end(range2), std::move(predicate));
}
}