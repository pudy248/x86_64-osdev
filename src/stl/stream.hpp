#pragma once
#include <iterator>
#include <stl/view.hpp>

template <typename T, iterator_of<T> I>
class basic_ostream {
protected:
	I iter;

public:
	constexpr basic_ostream() = default;
	constexpr basic_ostream(const I& i) : iter(i) {}
	template <typename Derived>
	constexpr auto& begin(this Derived& self) {
		return self.iter;
	}

	constexpr operator view<I, std::unreachable_sentinel_t>() const { return view(begin(), {}); }

	constexpr void write(const T& elem) {
		*iter = elem;
		++iter;
	}
	template <convertible_iter_I<I> I2, typename S>
	constexpr void write(const view<I2, S>& elems) {
		for (I2 iter = elems.begin(); iter != elems.end(); ++iter)
			write(*iter);
	}
};

template <iterator_of<std::byte> I = std::byte*>
class obinstream : public basic_ostream<std::byte, I> {
public:
	using basic_ostream<std::byte, I>::basic_ostream;
	using basic_ostream<std::byte, I>::write;
	void write(const void* ptr, idx_t size) {
		this->write(span<std::iter_value_t<I>>((std::iter_value_t<I>*)ptr, size));
	}
	template <typename T>
	void write_b(const T& val) {
		this->write(&val, sizeof(T));
	}
};
template <iterator_of<std::byte> I>
obinstream(I i) -> obinstream<I>;

template <typename T, iterator_of<T> I, std::sentinel_for<I> S>
class basic_istream {
protected:
	I iter;
	S sentinel;

public:
	constexpr basic_istream() = default;
	constexpr basic_istream(const I& i, const S& s) : iter(i), sentinel(s) {}
	constexpr basic_istream(const view<I, S>& v) : iter(v.cbegin()), sentinel(v.cend()) {}
	template <typename Derived>
	constexpr auto& begin(this Derived& self) {
		return self.iter;
	}
	template <typename Derived>
	constexpr const auto& end(this Derived& self) {
		return self.sentinel;
	}
	constexpr operator view<I, S>() const { return view(begin(), end()); }

	constexpr bool readable() const { return sentinel != iter; }
	constexpr auto peek() { return *iter; }
	constexpr auto read() {
		if constexpr (std::is_reference_v<decltype(*iter)>) {
			auto& t = *iter;
			++iter;
			return t;
		} else {
			auto t = *iter;
			++iter;
			return t;
		}
	}
	constexpr operator bool() const { return readable(); }
	constexpr T& operator*() { return *iter; }
	constexpr basic_istream& operator++(int) {
		++iter;
		return *this;
	}
	template <typename C = span<const T>, condition<const I&> B>
	constexpr C read_until(B cond, bool inclusive = false, bool invert = false) {
		I begin = iter;
		while (cond(iter) ^ !invert && readable())
			++iter;
		if (inclusive && readable())
			++iter;
		return C(begin, iter);
	}
	template <typename C = span<const T>, typename R>
		requires requires(R val, I iter) { val == *iter; }
	constexpr C read_until_v(const R& val, bool inclusive = false, bool invert = false) {
		return read_until([&val](const I& iter) { return *iter == val; }, inclusive, invert);
	}
	template <typename C = span<const T>, comparable_iter_I<I> I2, typename S2>
		requires(!view<I2, S2>::Infinite)
	constexpr C read_until_v(const view<I2, S2>& vals, bool inclusive = false, bool invert = false) {
		return read_until(
			[&vals](const I& iter) {
				for (std::iter_value_t<I2> v : vals)
					if (v == *iter)
						return true;
				return false;
			},
			inclusive, invert);
	}
	template <typename C, comparable_iter_I<I> I2, typename S2>
		requires(!view<I2, S2>::Infinite)
	constexpr C read_until_cv(const view<I2, S2>& consecutive, bool inclusive = false) {
		I begin = iter;
		while (!view(iter, sentinel).starts_with(consecutive) && readable())
			++iter;
		if (inclusive) {
			for (I2 iter2 = consecutive.begin(); iter2 != consecutive.end() && readable(); ++iter, ++iter2)
				;
		}
		return C(begin, iter);
	}
	template <typename C = span<const T>>
	constexpr C read_n(std::size_t size) {
		I begin = iter;
		while (size-- && readable())
			++iter;
		return C(begin, iter);
	}
	template <comparable_iter_I<I> I2, typename S2>
		requires(!view<I2, S2>::Infinite)
	constexpr bool match_cv(const view<I2, S2>& consecutive) {
		if (view(begin(), end()).starts_with(consecutive)) {
			for (std::size_t i = 0; i < consecutive.size(); ++iter, ++i)
				;
			return true;
		}
		return false;
	}
};

template <iterator_of<std::byte> I = std::byte*, std::sentinel_for<I> S = I>
class ibinstream : public basic_istream<std::byte, I, S> {
public:
	using basic_istream<std::byte, I, S>::basic_istream;
	template <typename T, container_of<T> C = span<T>>
	constexpr C read() {
		return this->read_n(sizeof(T));
	}

	template <typename T>
	constexpr T read_b() {
		return *(T*)this->read_n(sizeof(T)).begin();
	}
};
template <iterator_of<std::byte> I, std::sentinel_for<I> S>
ibinstream(I i, S s) -> ibinstream<I, S>;
