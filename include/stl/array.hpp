#pragma once
#include <concepts>
#include <cstddef>
#include <kstddefs.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>
#include <stl/container.hpp>

template <typename T, std::size_t N> class array : public basic_container<T, array<T, N>> {
protected:
	T m_arr[N];

public:
	using basic_container<T, array<T, N>>::basic_container;
	constexpr array()
		: m_arr() {
	}
	template <std::convertible_to<T> R> constexpr array(const R* begin, const R* end) {
		std::size_t i = 0;
		for (; i < min((std::size_t)(end - begin), N); i++) {
			new (&m_arr[i]) T(begin[i]);
		}
		for (; i < N; i++) {
			m_arr[i] = T();
		}
	}
	template <container<T> C>
	constexpr array(const C& other)
		: array(other.begin(), other.end()) {
	}

	constexpr T& at(int idx) {
		kassert(idx >= 0 && idx < size(), "OOB access in array.at()\n");
		return m_arr[idx];
	}
	constexpr const T& at(int idx) const {
		kassert(idx >= 0 && idx < size(), "OOB access in array.at()\n");
		return m_arr[idx];
	}
	constexpr T* begin() {
		return m_arr;
	}
	constexpr const T* begin() const {
		return m_arr;
	}
	constexpr void reserve(int size) {
		kassert((uint64_t)size <= N, "Attempted to reserve size above maximum array size.");
	}
	constexpr int size() const {
		return N;
	}
};
