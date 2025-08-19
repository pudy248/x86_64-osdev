#pragma once
#include "concepts.hpp"
#include <iterator>
#include <stl/iterator.hpp>

namespace algo {
namespace mut {
template <typename OutI, typename OutS, typename InI, typename InS>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void copy(OutI&& out, OutS out_end, InI&& begin, InS end) {
	for (; begin != end && out != out_end; ++begin, ++out)
		*out = *begin;
}
template <typename OutI, typename InI, typename InS>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void copy(OutI&& out, InI&& begin, InS end) {
	algo::mut::copy(out, null_sentinel{}, begin, end);
}
template <typename OutI, typename OutS, typename InI, typename InS>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void copy_n(OutI&& out, OutS out_end, InI&& begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && out != out_end && n > 0; ++begin, ++out, --n)
		*out = *begin;
}
template <typename OutI, typename InI, typename InS>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_n(OutI&& out, InI&& begin, InS end, std::iter_difference_t<InI> n) {
	algo::mut::copy_n(out, null_sentinel{}, begin, end, n);
}
template <typename OutI, typename InI>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_n(OutI&& out, InI&& begin, std::iter_difference_t<InI> n) {
	algo::mut::copy_n(out, null_sentinel{}, begin, null_sentinel{}, n);
}

template <typename OutI, typename OutS, typename InI, typename InS>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void move(OutI out, OutS out_end, InI begin, InS end) {
	for (; begin != end && out != out_end; ++begin, ++out)
		*out = std::move(*begin);
}
template <typename OutI, typename InI, typename InS>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void move(OutI&& out, InI&& begin, InS end) {
	algo::mut::move(out, null_sentinel{}, begin, end);
}
template <typename OutI, typename OutS, typename InI, typename InS>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void move_n(OutI&& out, OutS out_end, InI&& begin, InS end, std::iter_difference_t<InI> n) {
	for (; begin != end && out != out_end && n > 0; ++begin, ++out, --n)
		*out = std::move(*begin);
}
template <typename OutI, typename InI, typename InS>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void move_n(OutI&& out, InI&& begin, InS end, std::iter_difference_t<InI> n) {
	algo::mut::move_n(out, null_sentinel{}, begin, end, n);
}
template <typename OutI, typename InI>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void move_n(OutI&& out, InI&& begin, std::iter_difference_t<InI> n) {
	algo::mut::move_n(out, null_sentinel{}, begin, null_sentinel{}, n);
}

template <typename I, typename S, typename T>
	requires impl::bounded_input<I, S>
constexpr void fill(I&& begin, S end, const T& value) {
	for (; begin != end; ++begin)
		*begin = value;
}
template <typename I, typename S, typename T>
	requires impl::bounded_input<I, S>
constexpr void fill_n(I&& begin, S end, std::iter_difference_t<I> n, const T& value) {
	for (; begin != end && n > 0; --n, ++begin)
		*begin = value;
}
template <typename I, typename T>
	requires impl::input<I>
[[deprecated("Unbounded iterator")]]
constexpr void fill_n(I&& begin, std::iter_difference_t<I> n, const T& value) {
	algo::mut::fill_n(begin, null_sentinel{}, n, value);
}

template <typename I, typename S, typename VoidOp>
	requires impl::bounded_input<I, S>
constexpr void generate(I&& begin, S end, VoidOp generator = {}) {
	for (; begin != end; ++begin)
		*begin = generator();
}
template <typename I, typename S, typename VoidOp>
	requires impl::bounded_input<I, S>
constexpr void generate_n(I&& begin, S end, std::iter_difference_t<I> n, VoidOp generator = {}) {
	for (; begin != end && n > 0; --n, ++begin)
		*begin = generator();
}
template <typename I, typename VoidOp>
	requires impl::input<I>
[[deprecated("Unbounded iterator")]]
constexpr void generate_n(I&& begin, std::iter_difference_t<I> n, VoidOp generator = {}) {
	algo::mut::generate_n(begin, null_sentinel{}, n, generator);
}

template <typename I, typename S, typename UnaryOp>
	requires impl::bounded_input<I, S>
constexpr void indexed_generate(I&& begin, S end, UnaryOp generator = {}) {
	for (std::iter_difference_t<I> i = 0; begin != end; ++begin, ++i)
		*begin = generator(i);
}
template <typename I, typename S, typename UnaryOp>
	requires impl::bounded_input<I, S>
constexpr void indexed_generate_n(I&& begin, S end, std::iter_difference_t<I> n, UnaryOp generator = {}) {
	for (std::iter_difference_t<I> i = 0; begin != end && i < n; ++begin, ++i)
		*begin = generator(i);
}
template <typename I, typename UnaryOp>
	requires impl::input<I>
[[deprecated("Unbounded iterator")]]
constexpr void indexed_generate_n(I&& begin, std::iter_difference_t<I> n, UnaryOp generator = {}) {
	algo::mut::indexed_generate_n(begin, null_sentinel{}, n, generator);
}
}

template <typename OutI, typename OutS, typename InI, typename InS>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void copy(OutI out, OutS out_end, InI begin, InS end) {
	algo::mut::copy(out, out_end, begin, end);
}
template <typename OutI, typename InI, typename InS>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void copy(OutI out, InI begin, InS end) {
	algo::mut::copy(out, null_sentinel{}, begin, end);
}
template <typename OutI, typename OutS, typename InI, typename InS>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void copy_n(OutI out, OutS out_end, InI begin, InS end, std::iter_difference_t<InI> n) {
	algo::mut::copy_n(out, out_end, begin, end, n);
}
template <typename OutI, typename InI, typename InS>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void copy_n(OutI out, InI begin, InS end, std::iter_difference_t<InI> n) {
	algo::mut::copy_n(out, null_sentinel{}, begin, end, n);
}
template <typename OutI, typename InI>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void copy_n(OutI out, InI begin, std::iter_difference_t<InI> n) {
	algo::mut::copy_n(out, null_sentinel{}, begin, null_sentinel{}, n);
}

template <typename OutI, typename OutS, typename InI, typename InS>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void move(OutI out, OutS out_end, InI begin, InS end) {
	algo::mut::move(out, out_end, begin, end);
}
template <typename OutI, typename InI, typename InS>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void move(OutI out, InI begin, InS end) {
	algo::mut::move(out, null_sentinel{}, begin, end);
}
template <typename OutI, typename OutS, typename InI, typename InS>
	requires impl::bounded_output_with_bounded_input<OutI, OutS, InI, InS>
constexpr void move_n(OutI out, OutS out_end, InI begin, InS end, std::iter_difference_t<InI> n) {
	algo::mut::move_n(out, out_end, begin, end, n);
}
template <typename OutI, typename InI, typename InS>
	requires impl::output_with_bounded_input<OutI, InI, InS>
[[deprecated("Unbounded output iterator")]]
constexpr void move_n(OutI out, InI begin, InS end, std::iter_difference_t<InI> n) {
	algo::mut::move_n(out, null_sentinel{}, begin, end, n);
}
template <typename OutI, typename InI>
	requires impl::output_with_input<OutI, InI>
[[deprecated("Unbounded input and output iterators")]]
constexpr void move_n(OutI out, InI begin, std::iter_difference_t<InI> n) {
	algo::mut::move_n(out, null_sentinel{}, begin, null_sentinel{}, n);
}

template <typename I, typename S, typename T>
	requires impl::bounded_input<I, S>
constexpr void fill(I begin, S end, const T& value) {
	algo::mut::fill(begin, end, value);
}
template <typename I, typename S, typename T>
	requires impl::bounded_input<I, S>
constexpr void fill_n(I begin, S end, std::iter_difference_t<I> n, const T& value) {
	algo::mut::fill_n(begin, end, n, value);
}
template <typename I, typename T>
	requires impl::input<I>
[[deprecated("Unbounded iterator")]]
constexpr void fill_n(I begin, std::iter_difference_t<I> n, const T& value) {
	algo::mut::fill_n(begin, null_sentinel{}, n, value);
}

template <typename I, typename S, typename VoidOp>
	requires impl::bounded_input<I, S>
constexpr void generate(I begin, S end, VoidOp generator = {}) {
	algo::mut::generate(begin, end, generator);
}
template <typename I, typename S, typename VoidOp>
	requires impl::bounded_input<I, S>
constexpr void generate_n(I begin, S end, std::iter_difference_t<I> n, VoidOp generator = {}) {
	algo::mut::generate_n(begin, end, n, generator);
}
template <typename I, typename VoidOp>
	requires impl::input<I>
[[deprecated("Unbounded iterator")]]
constexpr void generate_n(I begin, std::iter_difference_t<I> n, VoidOp generator = {}) {
	algo::mut::generate_n(begin, null_sentinel{}, n, generator);
}

template <typename I, typename S, typename UnaryOp>
	requires impl::bounded_input<I, S>
constexpr void indexed_generate(I begin, S end, UnaryOp generator = {}) {
	algo::mut::indexed_generate(begin, end, generator);
}
template <typename I, typename S, typename UnaryOp>
	requires impl::bounded_input<I, S>
constexpr void indexed_generate_n(I begin, S end, std::iter_difference_t<I> n, UnaryOp generator = {}) {
	algo::mut::indexed_generate_n(begin, end, n, generator);
}
template <typename I, typename UnaryOp>
	requires impl::input<I>
[[deprecated("Unbounded iterator")]]
constexpr void indexed_generate_n(I begin, std::iter_difference_t<I> n, UnaryOp generator = {}) {
	algo::mut::indexed_generate_n(begin, null_sentinel{}, n, generator);
}
}