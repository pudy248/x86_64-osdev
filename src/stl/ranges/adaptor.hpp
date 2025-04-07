#pragma once
#include "concepts.hpp"

namespace ranges {
template <typename A1, typename A2>
class compose_adaptor {
	A1 a1;
	A2 a2;

public:
	template <typename A1F, typename A2F>
	constexpr compose_adaptor(A1F&& a1, A2F&& a2) : a1(std::forward<A1F>(a1)), a2(std::forward<A2F>(a2)) {}

	template <ranges::range R>
	constexpr auto operator()(R&& r) {
		return a2(a1(std::forward<R>(r)));
	}
	template <ranges::range R>
	constexpr auto operator|(R&& r) {
		return a2(a1(std::forward<R>(r)));
	}
	template <std::invocable A>
	constexpr auto operator|(A&& a) {
		return compose_adaptor<compose_adaptor<A1, A2>, A>(*this, std::forward<A>(a));
	};
};

template <typename CRTP>
class range_adaptor_interface {
public:
	template <typename D, ranges::range R>
	constexpr friend auto operator|(R&& r, const D& self) {
		return self(std::forward<R>(r));
	};
	template <typename Derived, typename A>
	constexpr auto operator|(this Derived& self, A&& t) {
		return compose_adaptor<Derived, A>(std::forward<Derived>(self), std::forward<A>(t));
	};
};
}