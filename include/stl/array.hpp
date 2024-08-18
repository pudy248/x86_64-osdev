#pragma once
#include <cstddef>
#include <kassert.hpp>
#include <kstddefs.hpp>
#include <stl/allocator.hpp>
#include <stl/view.hpp>

template <typename T, std::size_t N> class array {
protected:
	T m_arr[N];

public:
	using value_type = T;
	constexpr array()
		: m_arr() {
	}
	template <convertible_elem_I<T> I, typename S>
		requires(!view<I, S>::Infinite)
	constexpr array(const view<I, S>& v) {
		std::size_t i = 0;
		for (; i < min(v.size(), N); i++) {
			new (&m_arr[i]) T(v[i]);
		}
		for (; i < N; i++) {
			m_arr[i] = T();
		}
	}
	template <convertible_elem_I<T> I, typename S>
	constexpr array(const I& begin, const S& end)
		: array(view<I, S>(begin, end)) {
	}

	template <typename Derived> constexpr auto& at(this Derived& self, idx_t idx) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < self.size(), "OOB access in array.at()\n");
		return self.m_arr[idx];
	}
	template <typename Derived> constexpr auto& operator[](this Derived& self, idx_t idx) {
		return self.m_arr[idx];
	}

	template <typename Derived> constexpr auto begin(this Derived& self) {
		return self.m_arr;
	}
	constexpr auto cbegin() const {
		return m_arr;
	}
	template <typename Derived> constexpr auto end(this Derived& self) {
		return self.m_arr + self.size();
	}
	constexpr auto cend() const {
		return m_arr + size();
	}
	constexpr idx_t size() const {
		return N;
	}
};