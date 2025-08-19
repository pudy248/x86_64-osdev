#pragma once
#include "../adaptor.hpp"
#include "../concepts.hpp"
#include <concepts>
#include <ranges>
#include <stl/array.hpp>
#include <stl/iterator.hpp>

namespace ranges {
template <ranges::range R, typename T>
class cast_view : public ranges::view_interface<cast_view<R, T>> {
	template <bool is_const>
	class cast_iterator;
	template <>
	class cast_iterator<true> : public enclosed_iterator_interface<ranges::iterator_t<R>> {
	public:
		using value_type = T;
		using reference = T&;
		using pointer = T*;
		constexpr const value_type operator*() const { return static_cast<const T>(*this->backing); };
	};
	template <>
	class cast_iterator<false> : public enclosed_iterator_interface<ranges::iterator_t<R>> {
	public:
		using value_type = T;
		using reference = T&;
		using pointer = T*;
		constexpr value_type operator*() const { return static_cast<T>(*this->backing); };
	};
	R range;

public:
	constexpr cast_view()
		requires std::default_initializable<R>
	= default;
	constexpr cast_view(R range) : range(std::move(range)) {}
	constexpr R base() const
		requires std::is_copy_constructible_v<R>
	{
		return range;
	}
	constexpr R base() && { return std::move(range); }
	constexpr cast_iterator<false> begin() { return cast_iterator<false>{ ranges::begin(range) }; }
	constexpr cast_iterator<false> end() { return cast_iterator<false>{ ranges::end(range) }; }
	constexpr cast_iterator<true> begin() const { return cast_iterator<true>{ ranges::begin(range) }; }
	constexpr cast_iterator<true> end() const { return cast_iterator<true>{ ranges::end(range) }; }
	constexpr cast_iterator<true> cbegin() const { return cast_iterator<true>{ std::cbegin(range) }; }
	constexpr cast_iterator<true> cend() const { return cast_iterator<true>{ std::cend(range) }; }
};

template <typename T>
struct cast : public ranges::range_adaptor_interface<cast<T>> {
	using ranges::range_adaptor_interface<cast<T>>::operator|;
	template <ranges::range R>
	constexpr auto operator()(R&& r) const {
		return cast_view<std::views::all_t<R>, T>{ std::forward<R>(r) };
	}
};
}