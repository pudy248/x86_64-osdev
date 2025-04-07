#pragma once
#include <cstddef>
#include <cstdint>
#include <iterator>
#include <kassert.hpp>
#include <stl/allocator.hpp>
#include <stl/ranges.hpp>
#include <stl/vector.hpp>

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

template <std::size_t N>
class bitset;
class bitset_iterator;

template <>
class std::indirectly_readable_traits<bitset_iterator> {
public:
	using value_type = bool;
};

class bitset_iterator : random_access_iterator_interface<bitset_iterator> {
public:
	uint8_t* ptr;
	uint8_t offset;
	constexpr bitset_reference operator*() { return { ptr, offset }; }
	constexpr const bitset_reference operator*() const { return { ptr, offset }; }
	constexpr bitset_iterator& operator+=(std::ptrdiff_t v) {
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
	constexpr bool operator==(const bitset_iterator& other) const { return ptr == other.ptr && offset == other.offset; }
};

template <std::size_t N>
class container_traits<bitset<N>> {
public:
	using value_type = bool;
	using reference_type = bitset_reference;
	using iterator_type = bitset_iterator;
};

template <std::size_t N>
class bitset {
protected:
	constexpr static std::size_t ARR_SIZE = (N + 7) / 8;
	uint8_t m_arr[ARR_SIZE];

public:
	constexpr bitset() = default;
	template <typename I, typename S>
	constexpr bitset(const I& begin, const S& end) : bitset(view<I, S>(begin, end)) {}
	template <ranges::range R>
	constexpr bitset(const R& range) {
		if constexpr (std::same_as<ranges::value_t<R>, uint8_t>) {
			auto iter = ranges::begin(range);
			for (std::ptrdiff_t i = 0; iter != ranges::end(range); i++, iter++)
				m_arr[i] = *iter;
		} else {
			auto iter = ranges::begin(range);
			for (std::ptrdiff_t i = 0; iter != ranges::end(range); i++, iter++)
				set(i, *iter);
		}
	}

	template <std::size_t N2>
	constexpr void copy(const bitset<N2>& other, std::ptrdiff_t start, std::ptrdiff_t count) {
		for (std::ptrdiff_t i = 0; i < count; i++)
			set(start + i, other.at(i));
	}
	template <std::size_t N2>
	constexpr void copy(const bitset<N2>& other, std::ptrdiff_t start = 0) {
		copy(other, start, other.size());
	}

	constexpr bitset_reference at(std::ptrdiff_t idx) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.at()\n");
		return bitset_reference{ m_arr + (idx >> 3), (uint8_t)(idx & 7) };
	}
	constexpr bitset_reference at(std::ptrdiff_t idx) const {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.at()\n");
		return bitset_reference{ m_arr + (idx >> 3), (uint8_t)(idx & 7) };
	}
	template <typename Derived>
	constexpr const bitset_reference operator[](this Derived& self, std::ptrdiff_t idx) {
		return self.at(idx);
	}
	constexpr void set(std::ptrdiff_t idx, bool value) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.set()\n");
		if (value)
			m_arr[idx >> 3] |= 1 << (idx & 7);
		else
			m_arr[idx >> 3] &= ~(1 << (idx & 7));
	}
	constexpr void flip(std::ptrdiff_t idx) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.set()\n");
		m_arr[idx >> 3] ^= 1 << (idx & 7);
	}
	constexpr std::ptrdiff_t first_equal(bool value = false) const {
		for (std::ptrdiff_t i = 0; i < size(); i++) {
			if (m_arr[i] == value)
				return i;
		}
		return -1;
	}
	constexpr std::ptrdiff_t contiguous_span_equal(std::ptrdiff_t how_many, bool value = false) {
		std::ptrdiff_t counter = 0;
		for (std::ptrdiff_t i = 0; i < size(); i++) {
			if (m_arr[i] == value) {
				counter++;
				if (counter == how_many)
					return i - counter + 1;
			} else
				counter = 0;
		}
		return -1;
	}

	template <typename Derived>
	constexpr auto begin(this Derived& self) {
		return bitset_iterator(self.m_arr, 0);
	}
	template <typename Derived>
	constexpr auto end(this Derived& self) {
		return bitset_iterator(self.m_arr, self.size());
	}
	constexpr std::ptrdiff_t size() const { return N; }
};

class bitvector {
protected:
	vector<uint8_t> m_vec;
	std::size_t m_size = 0;

public:
	constexpr bitvector() = default;
	template <typename I, typename S>
	constexpr bitvector(const I& begin, const S& end) : bitvector(view<I, S>(begin, end)) {}
	template <ranges::range R>
	constexpr bitvector(const R& range) {
		if constexpr (std::same_as<ranges::value_t<R>, uint8_t>) {
			m_vec.resize(std::size(range));
			m_size = std::size(range) * 8;
			auto iter = ranges::begin(range);
			for (std::ptrdiff_t i = 0; iter != ranges::end(range); i++, iter++)
				m_vec[i] = *iter;
		} else {
			m_vec.resize((std::size(range) + 7) / 8);
			m_size = std::size(range);
			auto iter = ranges::begin(range);
			for (std::ptrdiff_t i = 0; iter != ranges::end(range); i++, iter++)
				set(i, *iter);
		}
	}

	template <std::size_t N2>
	constexpr void copy(const bitset<N2>& other, std::ptrdiff_t start, std::ptrdiff_t count) {
		for (std::ptrdiff_t i = 0; i < count; i++)
			set(start + i, other.at(i));
	}
	template <std::size_t N2>
	constexpr void copy(const bitset<N2>& other, std::ptrdiff_t start = 0) {
		copy(other, start, other.size());
	}

	constexpr bitset_reference at(std::ptrdiff_t idx) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.at()\n");
		return bitset_reference{ m_vec.begin() + (idx >> 3), (uint8_t)(idx & 7) };
	}
	constexpr bitset_reference at(std::ptrdiff_t idx) const {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.at()\n");
		return bitset_reference{ m_vec.begin() + (idx >> 3), (uint8_t)(idx & 7) };
	}
	template <typename Derived>
	constexpr const bitset_reference operator[](this Derived& self, std::ptrdiff_t idx) {
		return self.at(idx);
	}
	constexpr void set(std::ptrdiff_t idx, bool value) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.set()\n");
		if (value)
			m_vec[idx >> 3] |= 1 << (idx & 7);
		else
			m_vec[idx >> 3] &= ~(1 << (idx & 7));
	}
	constexpr void flip(std::ptrdiff_t idx) {
		kassert(DEBUG_ONLY, WARNING, idx >= 0 && idx < size(), "OOB access in bitset.set()\n");
		m_vec[idx >> 3] ^= 1 << (idx & 7);
	}
	constexpr std::ptrdiff_t first_equal(bool value = false) const {
		for (std::ptrdiff_t i = 0; i < size(); i++) {
			if (m_vec[i] == value)
				return i;
		}
		return -1;
	}
	constexpr std::ptrdiff_t contiguous_span_equal(std::ptrdiff_t how_many, bool value = false) {
		std::ptrdiff_t counter = 0;
		for (std::ptrdiff_t i = 0; i < size(); i++) {
			if (m_vec[i] == value) {
				counter++;
				if (counter == how_many)
					return i - counter + 1;
			} else
				counter = 0;
		}
		return -1;
	}

	template <typename Derived>
	constexpr auto begin(this Derived& self) {
		return bitset_iterator(self.m_vec.begin(), 0);
	}
	template <typename Derived>
	constexpr auto end(this Derived& self) {
		return bitset_iterator(self.m_vec.begin() + self.size() / 8, self.size() & 0x7);
	}
	constexpr std::ptrdiff_t size() const { return m_size; }
};