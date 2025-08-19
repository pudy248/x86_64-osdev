#pragma once
#include "concepts.hpp"
#include "stl/iterator/utilities.hpp"
#include <iterator>
#include <stl/iterator.hpp>

namespace ranges {
template <typename I>
struct unbounded_range {
	I iter;
	constexpr auto& begin() { return iter; }
	constexpr const auto& begin() const { return iter; }
	constexpr auto end() const { return null_sentinel{}; }
};
template <std::indirectly_readable I, std::sentinel_for<I> S>
struct reference_range {
	I& iter;
	const S& sentinel;
	constexpr reference_range(I& i, const S& s) : iter(i), sentinel(s) {}
	template <ranges::range R>
	constexpr reference_range(R& r) : iter(ranges::begin(r)), sentinel(ranges::end(r)) {}
	constexpr I& begin() { return iter; }
	constexpr const I& begin() const { return iter; }
	constexpr const S& end() const { return sentinel; }
};
template <ranges::range R>
reference_range(R& r)
	-> reference_range<std::remove_cv_t<ranges::iterator_t<R>>, std::remove_cv_t<ranges::sentinel_t<R>>>;

template <ranges::sized_range R>
	requires(requires(const R r) { r.size(); })
constexpr std::size_t size(const R& r) {
	return r.size();
}
template <ranges::sized_range R>
	requires(!requires(const R r) { r.size(); })
constexpr std::size_t size(const R& r) {
	return ranges::end(r) - ranges::begin(r);
}

template <ranges::range R>
constexpr decltype(auto) at(R& r, std::size_t idx) {
	return ranges::begin(r)[idx];
}

using null_range = unbounded_range<null_iterator>;
template <std::forward_iterator I, std::sentinel_for<I> S>
using ring_range = unbounded_range<ring_iterator<I, S>>;
}