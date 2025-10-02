#pragma once
#include "concepts.hpp"
#include "view.hpp"
#include <iterator>

namespace ranges {
template <ranges::forward_range R>
constexpr view<ranges::iterator_t<R>> subrange(R range, ranges::difference_t<R> begin, ranges::difference_t<R> end) {
	return {std::next(ranges::begin(range), begin), std::next(ranges::begin(range), end)};
}
template <ranges::range R>
constexpr R subrange(R range, ranges::difference_t<R> begin) {
	return {std::next(ranges::begin(range), begin), ranges::end(range)};
}
}