#pragma once
#include <concepts>
#include <kstddefs.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>
#include <stl/container.hpp>

template <typename C, typename T>
requires container<C, T>
class basic_ostream {
public:
	C data;
	int offset = 0;

	constexpr basic_ostream() = default;
	template <container<T> C2>
	constexpr basic_ostream(C2&& s)
		: data(s) {
	}

	constexpr void swrite(T elem) {
		data.at(offset++) = elem;
	}
	template <container<T> C2> constexpr void swrite(const C2& elems) {
		for (int i = 0; i < elems.size(); i++)
			swrite(elems[i]);
	}
};

template <typename C, typename T>
requires container_writeable<C, T>
class basic_istream {
public:
	C data;
	int offset = 0;
	constexpr basic_istream() = default;
	template <container<T> C2>
	constexpr basic_istream(const C2& s)
		: data(s) {
	}
	template <container<T> C2>
	constexpr basic_istream(C2&& s)
		: data(s) {
	}

	constexpr bool readable() const {
		return offset < data.size();
	}
	constexpr operator bool() const {
		return readable();
	}
	constexpr T front() {
		return data.at(offset);
	}
	constexpr T sread() {
		return data.at(offset++);
	}

	template <container<T> C2, container<T> C3> constexpr C2 read_until(bool (*condition)(C3), bool inclusive = false) {
		int sIdx = offset;
		while (!condition(C3(data, data.size() - offset, sIdx)) && readable())
			offset++;
		if (inclusive && readable())
			offset++;
		return C2(data, offset - sIdx, sIdx);
	}
	template <container<T> C2, container<T> C3> constexpr C2 read_while(bool (*condition)(C3)) {
		int sIdx = offset;
		while (condition(C3(data, data.size() - offset, sIdx)) && readable())
			offset++;
		return C2(data, offset - sIdx, sIdx);
	}
	template <container<T> C2> constexpr C2 read_until_v(const T val, bool inclusive = false) {
		int sIdx = offset;
		while (front() != val && readable())
			offset++;
		if (inclusive && readable())
			offset++;
		return C2(data, offset - sIdx, sIdx);
	}
	constexpr int read_while_v(const T val) {
		int sIdx = offset;
		while (front() == val && readable())
			offset++;
		return offset - sIdx;
	}
};