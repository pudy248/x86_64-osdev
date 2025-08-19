#pragma once
#include <iterator>
#include <stl/iterator.hpp>

namespace ranges {
template <typename T>
struct _begin_t {};
template <typename T>
	requires requires(T& t) { t.begin(); }
struct _begin_t<T> {
	constexpr static decltype(auto) begin(T& t) { return t.begin(); }
};
template <typename PChar>
	requires std::is_pointer_v<PChar> && std::same_as<std::remove_cv_t<std::remove_pointer_t<PChar>>, char>
struct _begin_t<PChar> {
	constexpr static PChar begin(PChar p) { return p; }
};
template <typename T, std::size_t N>
struct _begin_t<T[N]> {
	constexpr static T* begin(T (&t)[N]) { return (T*)t; }
};
template <typename T, std::size_t N>
struct _begin_t<T (*)[N]> {
	constexpr static T* begin(T (*t)[N]) { return (T*)*t; }
};
template <typename T, std::size_t N>
struct _begin_t<T (*const)[N]> {
	constexpr static const T* begin(T (*const t)[N]) { return (const T*)*t; }
};

template <typename T>
	requires requires(T& t) { _begin_t<T>::begin(t); }
constexpr decltype(auto) begin(T& t) {
	return _begin_t<T>::begin(t);
}

template <typename T>
struct _end_t {};
template <typename T>
	requires requires(T& t) { t.end(); }
struct _end_t<T> {
	constexpr static decltype(auto) end(T& t) { return t.end(); }
};
template <typename PChar>
	requires std::is_pointer_v<PChar> && std::same_as<std::remove_cv_t<std::remove_pointer_t<PChar>>, char>
struct _end_t<PChar> {
	constexpr static PChar end(PChar p) {
		std::remove_cv_t<PChar> tmp = p;
		for (; *tmp; ++tmp)
			;
		return tmp;
	}
};
template <typename T, std::size_t N>
struct _end_t<T[N]> {
	constexpr static T* end(T (&t)[N]) { return t + N; }
};
template <typename T, std::size_t N>
struct _end_t<T (*)[N]> {
	constexpr static T* end(T (*t)[N]) { return (T*)*t + N; }
};
template <typename T, std::size_t N>
struct _end_t<T (*const)[N]> {
	constexpr static const T* end(T (*const t)[N]) { return (const T*)*t + N; }
};

template <typename T>
	requires requires(T& t) { _end_t<T>::end(t); }
constexpr decltype(auto) end(T& t) {
	return _end_t<T>::end(t);
}

template <typename R>
concept range = std::is_array_v<R> || requires(R r) {
	ranges::begin(r);
	ranges::end(r);
};

template <typename T>
using iterator_t = std::remove_reference_t<decltype(ranges::begin(std::declval<T&>()))>;
template <typename T>
using sentinel_t = std::remove_reference_t<decltype(ranges::end(std::declval<T&>()))>;
template <typename T>
using iter_category_t = std::iterator_traits<iterator_t<T>>::iterator_category;
template <typename T>
using difference_t = std::iterator_traits<std::remove_cv_t<iterator_t<T>>>::difference_type;
template <typename T>
using value_t = std::remove_reference_t<decltype(*ranges::begin(std::declval<T&>()))>;
template <typename T>
using const_value_t = std::remove_reference_t<decltype(*ranges::begin(std::declval<const T&>()))>;
template <typename T>
using lvalue_reference_t = value_t<T>&;
template <typename T>
using rvalue_reference_t = value_t<T>&&;

template <typename T>
concept bounded_range = range<T> && !std::same_as<sentinel_t<T>, std::unreachable_sentinel_t> &&
						!std::same_as<sentinel_t<T>, null_sentinel>;
template <typename R>
concept sized_range = range<R> && std::sized_sentinel_for<sentinel_t<R>, iterator_t<R>>;
template <typename R>
concept input_range = range<R> && std::input_iterator<iterator_t<R>>;
template <typename R, typename T>
concept output_range = range<R> && std::output_iterator<iterator_t<R>, T>;
template <typename R>
concept forward_range = range<R> && std::forward_iterator<iterator_t<R>>;
template <typename R>
concept bidirectional_range = range<R> && std::bidirectional_iterator<iterator_t<R>>;
template <typename R>
concept random_access_range = range<R> && std::random_access_iterator<iterator_t<R>>;
}