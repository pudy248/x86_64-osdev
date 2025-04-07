#pragma once
#include <concepts>
#include <iterator>
#include <kassert.hpp>
#include <type_traits>

template <typename I, typename T>
concept iterator_of = std::input_iterator<I> && std::same_as<std::remove_cvref_t<std::iter_value_t<I>>, T>;

namespace impl {
template <typename T>
concept pre_incrementable = requires(T& t) {
	{ ++t } -> std::same_as<T&>;
};
template <typename T, typename N>
concept add_assignable = requires(T& t, N n) {
	{ t += n } -> std::same_as<T&>;
};
}