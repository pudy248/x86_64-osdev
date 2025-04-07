#pragma once
#include "concepts.hpp"
#include <concepts>
#include <cstddef>
#include <iterator>
#include <kassert.hpp>
#include <stl/iterator.hpp>
#include <stl/pointer.hpp>
#include <type_traits>

namespace ranges {
template <typename R>
class view_interface {
public:
	template <typename Derived>
	constexpr decltype(auto) operator[](this const Derived& self, ranges::difference_t<Derived> index) {
		if constexpr (ranges::bounded_range<R>)
			kassert(DEBUG_ONLY, WARNING, index >= 0 && index < (ranges::difference_t<Derived>)self.size(),
					"Out of bounds access to view.");
		return *std::next(ranges::begin(self), index);
	}
	template <typename Derived>
	constexpr auto size(this const Derived& self) {
		return ranges::end(self) - ranges::begin(self);
	}
};
}

template <std::forward_iterator I, std::sentinel_for<I> S = I>
class view : public ranges::view_interface<view<I, S>> {
protected:
	I iter;
	S sentinel;

public:
	using value_type = std::iter_value_t<I>;
	using difference_type = std::iter_difference_t<I>;

	constexpr view(const I& begin = I{}, const S& end = S{}) : iter(begin), sentinel(end) {};
	constexpr view(I&& begin, S&& end) : iter(std::move(begin)), sentinel(std::move(end)) {};
	constexpr view(I begin, difference_type length) : iter(begin), sentinel(begin + length) {};
	template <ranges::range R>
	constexpr view(R&& range) : iter(ranges::begin(range)), sentinel(ranges::end(range)) {}

	constexpr I begin() { return iter; }
	constexpr const I begin() const { return iter; }
	constexpr const I cbegin() const { return iter; }
	constexpr S end() { return sentinel; }
	constexpr const S end() const { return sentinel; }
	constexpr const S cend() const { return sentinel; }
	constexpr std::size_t size() const {
		if (std::same_as<S, std::unreachable_sentinel_t>)
			return -1;
		if constexpr (std::sized_sentinel_for<S, I>)
			return end() - begin();
		else {
			difference_type v = 0;
			for (I it = iter; it != sentinel; ++v, ++it)
				;
			return v;
		}
	}
	constexpr bool empty() const { return end() == begin(); }
};

template <typename T>
class span : public view<T*, T*> {
public:
	using value_type = T;
	using view<T*, T*>::view;
	constexpr span(std::initializer_list<T> list) : span(list.begin(), list.end()) {}
};
template <typename T>
class span<const T> : public view<const T*, const T*> {
public:
	using value_type = const T;
	using view<const T*, const T*>::view;
	constexpr span(std::initializer_list<T> list) : span(list.begin(), list.end()) {}
};
template <typename T>
class ispan : public view<T*, std::unreachable_sentinel_t> {
public:
	using value_type = T;
	using view<T*, std::unreachable_sentinel_t>::view;
};
template <typename T>
class ispan<const T> : public view<const T*, std::unreachable_sentinel_t> {
public:
	using value_type = const T;
	using view<const T*, std::unreachable_sentinel_t>::view;
};
class bytespan : public view<pointer<std::byte, type_cast>, pointer<std::byte, type_cast>> {
public:
	using value_type = std::byte;
	using view<pointer<std::byte, type_cast>, pointer<std::byte, type_cast>>::view;

	template <typename I2, typename S2>
	constexpr bytespan(const I2& begin, const S2& end)
		: view<pointer<std::byte, type_cast>, pointer<std::byte, type_cast>>(begin, end) {}
};
class cbytespan : public view<pointer<const std::byte, type_cast>, pointer<const std::byte, type_cast>> {
public:
	using value_type = std::byte;
	using view<pointer<const std::byte, type_cast>, pointer<const std::byte, type_cast>>::view;

	template <typename I2, typename S2>
	constexpr cbytespan(const I2& begin, const S2& end)
		: view<pointer<const std::byte, type_cast>, pointer<const std::byte, type_cast>>(begin, end) {}
	template <typename T>
		requires(std::is_integral_v<T> || std::is_enum_v<T> || sizeof(T) == 1)
	constexpr cbytespan(const std::initializer_list<T>& list) : cbytespan(list.begin(), list.end()) {}
};

//template <container C>
//view(C&) -> view<container_iterator_t<C>>;
//template <container C>
//view(const C&) -> view<container_const_iterator_t<C>>;
template <typename T>
view(T*) -> view<T*, std::unreachable_sentinel_t>;

template <typename I>
span(const I&, const I&) -> span<decltype(*std::declval<I>())>;
//template <container C>
//span(C&) -> span<std::remove_reference_t<decltype(*std::declval<container_iterator_t<C>>())>>;
//template <container C>
//span(const C&) -> span<std::remove_reference_t<decltype(*std::declval<container_const_iterator_t<C>>())>>;
template <typename T>
span(T*, T*) -> span<T>;
template <typename T>
span(T*, std::ptrdiff_t) -> span<T>;
template <typename T>
ispan(T*) -> ispan<T>;