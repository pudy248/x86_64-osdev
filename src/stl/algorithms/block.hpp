#pragma once
#include <iterator>
#include <stl/iterator.hpp>

namespace algo {
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy(OutI out, InI begin, InS end) {
	for (; begin != end; ++begin, ++out)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void copy(OutI out, OutS out_end, InI begin, InS end) {
	for (; begin != end && out != out_end; ++begin, ++out)
		*out = *begin;
}
template <std::input_iterator InI, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_n(OutI out, InI begin, std::iter_difference_t<InI> n) {
	for (; n > 0; ++begin, ++out, --n)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_n(OutI out, InI begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && n > 0; ++begin, ++out, --n)
		*out = *begin;
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void copy_n(OutI out, OutS out_end, InI begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && out != out_end && n > 0; ++begin, ++out, --n)
		*out = *begin;
}

template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void move(OutI out, InI begin, InS end) {
	for (; begin != end; ++begin, ++out)
		*out = std::move(*begin);
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void move(OutI out, OutS out_end, InI begin, InS end) {
	for (; begin != end && out != out_end; ++begin, ++out)
		*out = std::move(*begin);
}
template <std::input_iterator InI, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void move_n(OutI out, InI begin, std::iter_difference_t<InI> n) {
	for (; n > 0; ++begin, ++out, --n)
		*out = std::move(*begin);
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI>
[[deprecated("Unbounded output iterator")]]
constexpr void move_n(OutI out, InI begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && n > 0; ++begin, ++out, --n)
		*out = std::move(*begin);
}
template <std::input_iterator InI, std::sentinel_for<InI> InS, std::output_iterator<std::iter_value_t<InI>> OutI,
		  std::sentinel_for<OutI> OutS>
constexpr void move_n(OutI out, OutS out_end, InI begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && out != out_end && n > 0; ++begin, ++out, --n)
		*out = std::move(*begin);
}

template <std::input_iterator I, std::sentinel_for<I> S, typename T>
constexpr void fill(I begin, S end, const T& value) {
	for (; begin != end; ++begin)
		*begin = value;
}
template <std::input_iterator I, typename T>
[[deprecated("Unbounded iterator")]]
constexpr void fill_n(I begin, std::iter_difference_t<I> n, const T& value) {
	for (; n > 0; --n, ++begin)
		*begin = value;
}
template <std::input_iterator I, std::sentinel_for<I> S, typename T>
constexpr void fill_n(I begin, S end, std::iter_difference_t<I> n, const T& value) {
	for (; begin != end && n > 0; --n, ++begin)
		*begin = value;
}

template <std::input_iterator I, std::sentinel_for<I> S, typename VoidOp>
constexpr void generate(I begin, S end, VoidOp generator = {}) {
	for (; begin != end; ++begin)
		*begin = generator();
}
template <std::input_iterator I, typename VoidOp>
[[deprecated("Unbounded iterator")]]
constexpr void generate_n(I begin, std::iter_difference_t<I> n, VoidOp generator = {}) {
	for (; n > 0; --n, ++begin)
		*begin = generator();
}
template <std::input_iterator I, std::sentinel_for<I> S, typename VoidOp>
constexpr void generate_n(I begin, S end, std::iter_difference_t<I> n, VoidOp generator = {}) {
	for (; begin != end && n > 0; --n, ++begin)
		*begin = generator();
}

template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryOp>
constexpr void indexed_generate(I begin, S end, UnaryOp generator = {}) {
	for (std::iter_difference_t<I> i = 0; begin != end; ++begin, ++i)
		*begin = generator(i);
}
template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryOp>
[[deprecated("Unbounded iterator")]]
constexpr void indexed_generate_n(I begin, std::iter_difference_t<I> n, UnaryOp generator = {}) {
	for (std::iter_difference_t<I> i = 0; i < n; ++begin, ++i)
		*begin = generator(i);
}
template <std::input_iterator I, std::sentinel_for<I> S, typename UnaryOp>
constexpr void indexed_generate_n(I begin, S end, std::iter_difference_t<I> n, UnaryOp generator = {}) {
	for (std::iter_difference_t<I> i = 0; begin != end && i < n; ++begin, ++i)
		*begin = generator(i);
}
}