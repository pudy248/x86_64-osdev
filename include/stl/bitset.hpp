#pragma once
#include <cstddef>
#include <cstdint>
#include <iterator>
#include <kassert.hpp>
#include <stl/allocator.hpp>
#include <stl/view.hpp>

class bitset_reference {
public:
	uint8_t* ptr;
	uint8_t offset;

	constexpr bitset_reference& operator=(bool v) {
		if (v)
			*ptr |= (1 << offset);
		else
			*ptr &= ~(1 << offset);
		return *this;
	}
	constexpr bitset_reference& operator=(const bool& v) {
		if (v)
			*ptr |= (1 << offset);
		else
			*ptr &= ~(1 << offset);
		return *this;
	}
	constexpr operator bool() const { return (*ptr >> offset) & 1; }
};

template <std::size_t N> class bitset;
class bitset_iterator;

template <> class std::indirectly_readable_traits<bitset_iterator> {
public:
	using value_type = bool;
};

class bitset_iterator : iterator_crtp<bitset_iterator> {
public:
	uint8_t* ptr;
	uint8_t offset;
	constexpr bitset_reference operator*() { return { ptr, offset }; }
	constexpr const bitset_reference operator*() const { return { ptr, offset }; }
	constexpr bitset_iterator& operator+=(idx_t v) {
		ptr += v >> 3;
		offset += v & 7;
		if (offset >= 8) {
			offset -= 8;
			ptr++;
		}
		if (offset <= 0) {
			offset += 8;
			ptr--;
		}
		return *this;
	}
	constexpr bool operator==(const bitset_iterator& other) const {
		return ptr == other.ptr && offset == other.offset;
	}
};

template <std::size_t N> class container_traits<bitset<N>> {
public:
	using value_type = bool;
	using reference_type = bitset_reference;
	using iterator_type = bitset_iterator;
};

template <std::size_t N> class bitset {
protected:
	constexpr static std::size_t ARR_SIZE = (N + 7) / 8;
	uint8_t m_arr[ARR_SIZE];

public:
	constexpr bitset()
		: m_arr() {}
	template <typename I, typename S>
	constexpr bitset(const I& begin, const S& end)
		: bitset(view<I, S>(begin, end)) {}
	template <typename I, typename S>
		requires requires {
			requires convertible_elem_I<I, bool>;
			requires(!view<I, S>::Infinite);
		}
	constexpr bitset(const view<I, S>& v) {
		if constexpr (std::same_as<std::iter_value_t<I>, uint8_t>) {
			I iter = v.begin();
			for (idx_t i = 0; iter != v.end(); i++, iter++) m_arr[i] = *iter;
		} else {
			I iter = v.begin();
			for (idx_t i = 0; iter != v.end(); i++, iter++) set(i, *iter);
		}
	}

	template <std::size_t N2>
	constexpr void copy(const bitset<N2>& other, idx_t start, idx_t count) {
		for (idx_t i = 0; i < count; i++) set(start + i, other.at(i));
	}
	template <std::size_t N2> constexpr void copy(const bitset<N2>& other, idx_t start = 0) {
		copy(other, start, other.size());
	}

	constexpr bitset_reference at(idx_t idx) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.at()\n");
		return bitset_reference{ { m_arr + (idx >> 3) }, (uint8_t)(idx & 7) };
	}
	constexpr bitset_reference at(idx_t idx) const {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.at()\n");
		return bitset_reference{ { .cptr = m_arr + (idx >> 3) }, (uint8_t)(idx & 7) };
	}
	template <typename Derived>
	constexpr const bitset_reference operator[](this Derived& self, idx_t idx) {
		return self.at(idx);
	}
	constexpr void set(idx_t idx, bool value) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.set()\n");
		if (value)
			m_arr[idx >> 3] |= 1 << (idx & 7);
		else
			m_arr[idx >> 3] &= ~(1 << (idx & 7));
	}
	constexpr void flip(idx_t idx) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.set()\n");
		m_arr[idx >> 3] ^= 1 << (idx & 7);
	}
	constexpr idx_t first_equal(bool value = false) const {
		for (idx_t i = 0; i < size(); i++) {
			if (m_arr[i] == value) return i;
		}
		return -1;
	}
	constexpr idx_t contiguous_span_equal(idx_t how_many, bool value = false) {
		idx_t counter = 0;
		for (idx_t i = 0; i < size(); i++) {
			if (m_arr[i] == value) {
				counter++;
				if (counter == how_many) return i - counter + 1;
			} else
				counter = 0;
		}
		return -1;
	}

	template <typename Derived> constexpr auto begin(this Derived& self) {
		return iterator(self.m_arr, 0);
	}
	template <typename Derived> constexpr auto end(this Derived& self) {
		return iterator(self.m_arr, self.size());
	}
	constexpr idx_t size() const { return N; }
};