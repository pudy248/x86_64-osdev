#pragma once
#include <concepts>
#include <cstddef>
#include <iterator>
#include <kassert.hpp>
#include <stl/container.hpp>
#include <type_traits>

using idx_t = std::ptrdiff_t;
using uidx_t = std::size_t;

template <typename I, typename T>
concept iterator_of = std::input_iterator<I> && std::same_as<std::remove_const_t<std::iter_value_t<I>>, T>;

template <typename I, typename R>
concept comparable_elem_I = std::input_iterator<I> && requires(std::iter_value_t<I> v1, R v2) { v1 == v2; };
template <typename R, typename I>
concept comparable_iter_R = std::input_iterator<I> && requires(std::iter_value_t<I> v1, R v2) { v1 == v2; };
template <typename I1, typename I2>
concept comparable_iter_I = comparable_elem_I<I1, std::iter_value_t<I2>>;

template <typename I, typename R>
concept convertible_elem_I = std::input_iterator<I> && requires(std::iter_value_t<I> v) { R{ v }; };
template <typename I1, typename I2>
concept convertible_iter_I = convertible_elem_I<I1, std::iter_value_t<I2>>;

template <typename CRTP> class iterator_crtp {
public:
	using T = typename std::indirectly_readable_traits<CRTP>::value_type;

	template <typename Derived> constexpr auto& operator[](this Derived& self, idx_t v) { return *(self + v); }
	template <typename Derived> constexpr Derived& operator-=(this Derived& self, idx_t v) { return self += -v; }
	template <typename Derived> constexpr Derived operator+(this Derived self, idx_t v) {
		Derived other = self;
		other += v;
		return other;
	}
	template <typename Derived> constexpr Derived operator-(this Derived self, idx_t v) {
		Derived other = self;
		other -= v;
		return other;
	}
	template <typename Derived> constexpr Derived& operator++(this Derived& self) { return self += 1; }
	template <typename Derived> constexpr Derived operator++(this Derived& self, int) {
		Derived s = self;
		++self;
		return s;
	}
	template <typename Derived> constexpr Derived& operator--(this Derived& self) { return self -= 1; }
	template <typename Derived> constexpr Derived operator--(this Derived& self, int) {
		Derived s = self;
		--self;
		return s;
	}
};

template <typename I, typename T> class cast_iterator;

template <typename I, typename T> struct std::indirectly_readable_traits<cast_iterator<I, T>> {
public:
	using value_type = T;
};

template <typename I, typename T> class cast_iterator : public iterator_crtp<cast_iterator<I, T>> {
public:
	using value_type = T;
	using difference_type = idx_t;

	I backing;
	cast_iterator() = default;
	cast_iterator(const I& i)
		: backing(i) {}

	constexpr cast_iterator& operator+=(idx_t v) {
		backing += v;
		return *this;
	}
	constexpr idx_t operator-(const cast_iterator& other) const { return backing - other.backing; }
	constexpr T operator*() const { return (T)*backing; };
	constexpr bool operator==(const cast_iterator& other) const { return backing == other.backing; }

	constexpr operator I() const { return backing; }
};