#pragma once
#include <iterator>
#include <stl/view.hpp>

template <typename T, iterator_of<T> I> class basic_ostream {
protected:
	I iter;

public:
	constexpr basic_ostream() = default;
	constexpr basic_ostream(const I& i)
		: iter(i) {}
	template <typename Derived> constexpr auto begin(this Derived& self) { return self.iter; }

	constexpr operator view<I, std::unreachable_sentinel_t>() const { return view(begin(), {}); }

	constexpr void write(const T& elem) { *(iter++) = elem; }
	template <convertible_iter_I<I> I2, typename S> constexpr void write(const view<I2, S>& elems) {
		for (I2 iter = elems.begin(); iter != elems.end(); iter++) write(*iter);
	}
};

template <typename T, iterator_of<T> I, std::sentinel_for<I> S> class basic_istream {
protected:
	I iter;
	const S sentinel;

public:
	constexpr basic_istream() = default;
	constexpr basic_istream(const I& i, const S& s)
		: iter(i)
		, sentinel(s) {}
	constexpr basic_istream(const view<I, S>& v)
		: iter(v.cbegin())
		, sentinel(v.cend()) {}
	template <typename Derived> constexpr auto begin(this Derived& self) { return self.iter; }
	template <typename Derived> constexpr auto end(this Derived& self) { return self.sentinel; }
	constexpr operator view<I, S>() const { return view(begin(), end()); }

	constexpr bool readable() const { return sentinel - iter > 0; }
	constexpr const T& read() { return *(iter++); }
	constexpr operator bool() const { return readable(); }
	constexpr T& operator*() { return *iter; }
	constexpr basic_istream& operator++() {
		iter++;
		return *this;
	}
	template <container_of<T> C = span<const T>, condition<const I&> B>
	constexpr C read_until(B cond, bool inclusive = false, bool invert = false) {
		I begin = iter;
		while (cond(iter) ^ !invert && readable()) iter++;
		if (inclusive && readable()) iter++;
		return C(begin, iter);
	}
	template <container_of<T> C = span<const T>, typename R>
		requires requires(R val, I iter) { val == *iter; }
	constexpr C read_until_v(const R& val, bool inclusive = false, bool invert = false) {
		return read_until([&val](const I& iter) { return *iter == val; }, inclusive, invert);
	}
	template <container_of<T> C = span<const T>, comparable_iter_I<I> I2, typename S2>
		requires(!view<I2, S2>::Infinite)
	constexpr C read_until_v(const view<I2, S2>& vals, bool inclusive = false,
							 bool invert = false) {
		return read_until(
			[&vals](const I& iter) {
				for (std::iter_value_t<I2> v : vals)
					if (v == *iter) return true;
				return false;
			},
			inclusive, invert);
	}
	template <container_of<T> C = span<const T>> constexpr C read_n(idx_t size) {
		idx_t counter = 0;
		return read_until([&counter, &size](const I&) {
			counter++;
			return counter == size;
		});
	}
};

template <iterator_of<uint8_t> I> class obinstream : public basic_ostream<uint8_t, I> {
public:
	using basic_ostream<uint8_t, I>::basic_ostream;
	void write(void* ptr, idx_t size) { this->write(span<char>((char*)ptr, ((char*)ptr) + size)); }
	template <typename T>
		requires(!std::same_as<T, uint8_t>)
	void write(const T& val) {
		this->write(&val, sizeof(T));
	}
};

template <iterator_of<uint8_t> I, std::sentinel_for<I> S>
class ibinstream : public basic_istream<uint8_t, I, S> {
public:
	using basic_istream<uint8_t, I, S>::basic_istream;
	template <typename T, container_of<T> C = span<T>> constexpr C read() {
		return this->read_n(sizeof(T));
	}
};