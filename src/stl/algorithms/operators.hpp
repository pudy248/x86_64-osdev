#pragma once
#include <iterator>
#include <utility>

namespace algo {

struct identity {
	constexpr auto operator()(auto value) const { return value; }
};
template <typename T>
struct add_v {
	T value;
	constexpr auto operator()(auto lhs) const { return lhs + value; }
};
struct add {
	constexpr auto operator()(auto lhs, auto rhs) const { return lhs + rhs; }
};
struct sub {
	constexpr auto operator()(auto lhs, auto rhs) const { return lhs - rhs; }
};
template <typename T>
struct mul_v {
	T value;
	constexpr auto operator()(auto lhs) const { return lhs * value; }
};
struct mul {
	constexpr auto operator()(auto lhs, auto rhs) const { return lhs * rhs; }
};
struct div {
	constexpr auto operator()(auto lhs, auto rhs) const { return lhs / rhs; }
};

template <typename T>
struct greater_v {
	T value;
	constexpr bool operator()(auto lhs) const { return lhs > value; }
};
template <typename T>
struct greater_equal_v {
	T value;
	constexpr bool operator()(auto lhs) const { return lhs >= value; }
};
template <typename T>
struct equal_to_v {
	T value;
	constexpr bool operator()(auto lhs) const { return lhs == value; }
};
template <typename T>
struct not_equal_to_v {
	T value;
	constexpr bool operator()(auto lhs) const { return lhs != value; }
};
template <typename T>
struct less_equal_v {
	T value;
	constexpr bool operator()(auto lhs) const { return lhs <= value; }
};
template <typename T>
struct less_v {
	T value;
	constexpr bool operator()(auto lhs) const { return lhs < value; }
};
struct greater {
	constexpr bool operator()(auto lhs, auto rhs) const { return lhs > rhs; }
};
struct greater_equal {
	constexpr bool operator()(auto lhs, auto rhs) const { return lhs >= rhs; }
};
struct equal_to {
	constexpr bool operator()(auto lhs, auto rhs) const { return lhs == rhs; }
};
struct not_equal_to {
	constexpr bool operator()(auto lhs, auto rhs) const { return lhs != rhs; }
};
struct less_equal {
	constexpr bool operator()(auto lhs, auto rhs) const { return lhs <= rhs; }
};
struct less {
	constexpr bool operator()(auto lhs, auto rhs) const { return lhs < rhs; }
};

template <std::forward_iterator I, std::sentinel_for<I> S>
struct equal_to_any {
	I begin;
	S end;
	constexpr bool operator()(auto value) const {
		for (I iter = begin; iter != end; ++iter)
			if (*iter == value)
				return true;
		return false;
	}
};

template <typename Op1, typename Op2>
struct compose {
	Op1 op1;
	Op2 op2;
	constexpr auto operator()(auto value) const { return op1(op2(value)); }
};
}