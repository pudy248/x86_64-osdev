#pragma once
#include <concepts>
#include <cstddef>
#include <kstddefs.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>
#include <stl/container.hpp>

template <std::size_t N> class bitset : public basic_container<bool, bitset<N>> {
protected:
	constexpr static std::size_t ARR_SIZE = (N + 7) / 8;
	uint8_t m_arr[ARR_SIZE];

public:
	constexpr bitset()
		: m_arr() {
	}
	constexpr bitset(const bool* begin, const bool* end) {
		std::size_t arr_index	   = 0;
		std::size_t bit_index	   = 0;
		std::size_t iterator_index = 0;
		uint8_t val				   = 0;

		for (; iterator_index < min((std::size_t)(end - begin), N); iterator_index++) {
			if (begin[iterator_index])
				val |= 1 << bit_index;
			bit_index++;
			if (bit_index == 8) {
				m_arr[arr_index++] = val;
				bit_index		   = 0;
				val				   = 0;
			}
		}
		if (bit_index) {
			m_arr[arr_index++] = val;
			bit_index		   = 0;
			val				   = 0;
		}
		for (; arr_index < ARR_SIZE; arr_index++) {
			arr_index = 0;
		}
	}
	template <container<bool> C>
	constexpr bitset(const C& other)
		: bitset(other.begin(), other.end()) {
	}

	constexpr bool at(int idx) const {
		kassert(idx >= 0 && idx < size(), "OOB access in bitset.at()\n");
		return (m_arr[idx >> 3] >> (idx & 7)) & 1;
	}
	constexpr bool operator[](int idx) const {
		return at(idx);
	}
	constexpr void set(int idx, bool value) {
		kassert(idx >= 0 && idx < size(), "OOB access in bitset.set()\n");
		if (value)
			m_arr[idx >> 3] |= 1 << (idx & 7);
		else
			m_arr[idx >> 3] &= ~(1 << (idx & 7));
	}
	constexpr void flip(int idx) {
		kassert(idx >= 0 && idx < size(), "OOB access in bitset.set()\n");
		m_arr[idx >> 3] ^= 1 << (idx & 7);
	}

	constexpr int size() const {
		return N;
	}
};
