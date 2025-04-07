#pragma once
#include "concepts.hpp"
#include <iterator>

template <typename T, typename V>
class pure_input_iterator_interface : std::input_iterator_tag {
public:
	using iterator_concept = std::input_iterator_tag;
	using iterator_category = iterator_concept;
	using value_type = V;
	using difference_type = std::ptrdiff_t;
	using reference = V&;
	using pointer = V*;

private:
	struct iter_value_copy {
		V value;
		constexpr V operator*() const { return value; }
	};

public:
	template <typename Derived>
	constexpr iter_value_copy operator++(this Derived& self, int) {
		iter_value_copy s = { *self };
		++self;
		return s;
	}
};

template <typename T>
struct pure_output_iterator_interface : std::output_iterator_tag {
	using iterator_concept = std::output_iterator_tag;
	using iterator_category = iterator_concept;
	using value_type = std::remove_reference_t<decltype(*std::declval<T&>())>;
	using difference_type = std::ptrdiff_t;
	using reference = decltype(*std::declval<T&>());
	using pointer = decltype(&*std::declval<T&>());

	using T::T;

	template <typename Derived>
	constexpr Derived& operator++(this const Derived& self) {
		return self;
	}
	template <typename Derived>
	constexpr Derived operator++(this const Derived& self, int) {
		return self;
	}
};

template <typename T>
	requires std::equality_comparable<T> && impl::pre_incrementable<T>
struct forward_iterator_interface : std::forward_iterator_tag {
	using iterator_concept = std::forward_iterator_tag;
	using iterator_category = iterator_concept;
	using value_type = std::remove_reference_t<decltype(*std::declval<T&>())>;
	using difference_type = std::ptrdiff_t;
	using reference = decltype(*std::declval<T&>());
	using pointer = decltype(&*std::declval<T&>());

	template <typename Derived>
	constexpr Derived operator++(this Derived& self, int) {
		Derived s = self;
		++self;
		return s;
	}
};

template <typename T>
	requires std::equality_comparable<T> && impl::pre_incrementable<T>
struct bidirectional_iterator_interface : std::bidirectional_iterator_tag, public forward_iterator_interface<T> {
	using iterator_concept = std::bidirectional_iterator_tag;
	using iterator_category = iterator_concept;

	template <typename Derived>
	constexpr Derived& operator--(this Derived& self) {
		return std::advance(self, -1);
	}
	template <typename Derived>
	constexpr Derived operator--(this Derived& self, int) {
		Derived s = self;
		--self;
		return s;
	}
};

template <typename Base>
struct random_access_iterator_interface : std::random_access_iterator_tag {
	using iterator_concept = std::random_access_iterator_tag;
	using iterator_category = iterator_concept;
	using difference_type = std::ptrdiff_t;

	template <typename Derived>
	constexpr std::iter_reference_t<Derived> operator[](this const Derived& self, difference_type v) {
		return *(self + v);
	}

	template <typename Derived>
	constexpr Derived& operator+=(this Derived& self, difference_type v) {
		for (difference_type i = 0; i < v; ++i)
			++self;
		return self;
	}
	template <typename Derived>
	constexpr Derived& operator++(this Derived& self) {
		return self += 1;
	}

	template <typename Derived>
	constexpr Derived operator++(this Derived& self, int) {
		Derived s = self;
		++self;
		return s;
	}
	template <typename Derived>
	constexpr Derived& operator--(this Derived& self) {
		return self += -1;
	}
	template <typename Derived>
	constexpr Derived operator--(this Derived& self, int) {
		Derived s = self;
		--self;
		return s;
	}
	template <typename Derived>
	constexpr Derived& operator-=(this Derived& self, difference_type v) {
		return self += -v;
	}
	template <typename Derived>
		requires std::copy_constructible<Derived>
	constexpr Derived operator+(this const Derived& self, difference_type v) {
		Derived other = self;
		other += v;
		return other;
	}
	template <typename Derived>
		requires std::copy_constructible<Derived>
	constexpr Derived operator-(this const Derived& self, difference_type v) {
		Derived other = self;
		other -= v;
		return other;
	}
};

template <typename Base>
struct contiguous_iterator_interface : std::contiguous_iterator_tag {
	using iterator_concept = std::contiguous_iterator_tag;
	using iterator_category = iterator_concept;
	using difference_type = std::ptrdiff_t;

	template <typename Derived>
		requires(!std::is_void_v<std::iter_reference_t<Derived>>)
	constexpr std::iter_reference_t<Derived> operator[](this const Derived& self, difference_type v) {
		return *(self + v);
	}

	template <typename Derived>
	constexpr Derived& operator+=(this Derived& self, difference_type v) {
		for (difference_type i = 0; i < v; ++i)
			++self;
		return self;
	}
	template <typename Derived>
	constexpr Derived& operator++(this Derived& self) {
		return self += 1;
	}

	template <typename Derived>
	constexpr Derived operator++(this Derived& self, int) {
		Derived s = self;
		++self;
		return s;
	}
	template <typename Derived>
	constexpr Derived& operator--(this Derived& self) {
		return self += -1;
	}
	template <typename Derived>
	constexpr Derived operator--(this Derived& self, int) {
		Derived s = self;
		--self;
		return s;
	}
	template <typename Derived>
	constexpr Derived& operator-=(this Derived& self, difference_type v) {
		return self += -v;
	}
	template <typename Derived>
		requires std::copy_constructible<Derived>
	constexpr Derived operator+(this const Derived& self, difference_type v) {
		Derived other = self;
		other += v;
		return other;
	}
	template <typename Derived>
		requires std::copy_constructible<Derived>
	constexpr Derived operator-(this const Derived& self, difference_type v) {
		Derived other = self;
		other -= v;
		return other;
	}
};

namespace impl {
template <typename Base>
class enclosed_iterator_interface_base {
protected:
	Base backing;

public:
	using value_type = std::iter_value_t<Base>;
	using reference = std::iter_reference_t<Base>;
	using pointer = value_type*;

	constexpr enclosed_iterator_interface_base()
		requires std::default_initializable<Base>
	= default;
	constexpr enclosed_iterator_interface_base(Base i) : backing(std::move(i)) {}

	template <typename Derived>
	constexpr decltype(auto) operator*(this Derived self) {
		return *self.backing;
	}
	template <typename Derived>
	constexpr Derived& operator++(this Derived& self)
		requires impl::pre_incrementable<Base>
	{
		++self.backing;
		return self;
	}
	template <typename Derived>
	constexpr Derived& operator+=(this Derived& self, const std::iter_difference_t<Base> n)
		requires impl::add_assignable<Base, std::iter_difference_t<Base>>
	{
		self.backing += n;
		return self;
	}
	template <typename Derived>
	constexpr auto operator-(this const Derived& self, const enclosed_iterator_interface_base<Base>& other)
		requires std::sized_sentinel_for<Base, Base>
	{
		return self.backing - other.backing;
	}
	template <typename Derived>
	constexpr auto operator==(this const Derived& self, const enclosed_iterator_interface_base<Base>& other)
		requires std::equality_comparable<Base>
	{
		return self.backing == other.backing;
	}
	template <typename Derived>
	constexpr auto operator<=>(this const Derived& self, const enclosed_iterator_interface_base<Base>& other)
		requires std::three_way_comparable<Base>
	{
		return self.backing <=> other.backing;
	}
};
}

template <typename I>
class enclosed_iterator_interface;

template <typename I>
	requires std::forward_iterator<I> && (!std::bidirectional_iterator<I>)
class enclosed_iterator_interface<I> : public impl::enclosed_iterator_interface_base<I>,
									   public forward_iterator_interface<enclosed_iterator_interface<I>> {
public:
	using impl::enclosed_iterator_interface_base<I>::enclosed_iterator_interface_base;
	using impl::enclosed_iterator_interface_base<I>::operator++;
	using forward_iterator_interface<enclosed_iterator_interface<I>>::operator++;
};

template <typename I>
	requires std::bidirectional_iterator<I> && (!std::random_access_iterator<I>)
class enclosed_iterator_interface<I> : public impl::enclosed_iterator_interface_base<I>,
									   public bidirectional_iterator_interface<enclosed_iterator_interface<I>> {
public:
	using impl::enclosed_iterator_interface_base<I>::enclosed_iterator_interface_base;
	using impl::enclosed_iterator_interface_base<I>::operator++;
	using bidirectional_iterator_interface<enclosed_iterator_interface<I>>::operator++;
};

template <typename I>
	requires std::random_access_iterator<I> && (!std::contiguous_iterator<I>)
class enclosed_iterator_interface<I> : public impl::enclosed_iterator_interface_base<I>,
									   public random_access_iterator_interface<enclosed_iterator_interface<I>> {
public:
	using impl::enclosed_iterator_interface_base<I>::enclosed_iterator_interface_base;
	using impl::enclosed_iterator_interface_base<I>::operator++;
	using impl::enclosed_iterator_interface_base<I>::operator+=;
	using impl::enclosed_iterator_interface_base<I>::operator-;
	using random_access_iterator_interface<enclosed_iterator_interface<I>>::operator++;
	using random_access_iterator_interface<enclosed_iterator_interface<I>>::operator+=;
	using random_access_iterator_interface<enclosed_iterator_interface<I>>::operator-;
};

template <typename I>
	requires std::contiguous_iterator<I>
class enclosed_iterator_interface<I> : std::contiguous_iterator_tag,
									   public impl::enclosed_iterator_interface_base<I>,
									   public random_access_iterator_interface<enclosed_iterator_interface<I>> {
public:
	using iterator_concept = std::contiguous_iterator_tag;
	using impl::enclosed_iterator_interface_base<I>::enclosed_iterator_interface_base;
	using impl::enclosed_iterator_interface_base<I>::operator++;
	using impl::enclosed_iterator_interface_base<I>::operator+=;
	using impl::enclosed_iterator_interface_base<I>::operator-;
	using random_access_iterator_interface<enclosed_iterator_interface<I>>::operator++;
	using random_access_iterator_interface<enclosed_iterator_interface<I>>::operator+=;
	using random_access_iterator_interface<enclosed_iterator_interface<I>>::operator-;
};
