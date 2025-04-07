#pragma once
#include <iterator>
#include <optional>
#include <stl/ranges.hpp>
#include <type_traits>

template <typename S, typename CharT>
concept istream = requires(S s) {
	requires requires(CharT* p, std::size_t sz) { s.read(p, sz); };
	requires requires(CharT c) { s.read(c); };
};
template <typename S, typename CharT>
concept ostream = requires(S s) {
	requires requires(CharT* p, std::size_t sz) { s.write(p, sz); };
	requires requires(CharT c) { s.write(c); };
};

template <std::input_iterator I, std::sentinel_for<I> S = std::unreachable_sentinel_t>
class basic_istream {
protected:
	I iter;
	S sentinel;
	std::optional<std::iter_value_t<I>> peeked_val;

public:
	constexpr basic_istream() = default;
	constexpr basic_istream(I i, S s = {}) : iter(std::move(i)), sentinel(std::move(s)) {}
	template <ranges::range R>
	constexpr basic_istream(const R& range) : iter(ranges::begin(range)), sentinel(ranges::end(range)) {}
	template <typename Derived>
	constexpr auto& begin(this Derived& self) {
		return self.iter;
	}
	template <typename Derived>
	constexpr const auto& end(this Derived& self) {
		return self.sentinel;
	}

	constexpr bool readable() const { return sentinel != iter; }
	constexpr auto peek() {
		if (!peeked_val.has_value())
			peeked_val = std::move(*iter);
		return peeked_val.value();
	}
	constexpr auto get() {
		if (peeked_val.has_value()) {
			auto t = std::move(peeked_val.value());
			peeked_val.reset();
			++iter;
			return t;
		} else {
			auto t = std::move(*iter);
			++iter;
			return t;
		}
	}
	constexpr operator bool() const { return readable(); }
	constexpr basic_istream& operator++() {
		++iter;
		return *this;
	}

	template <std::output_iterator<std::iter_value_t<I>> OutI>
	constexpr void read(OutI out, std::size_t sz) {
		algo::mut::copy_n(out, begin(), end(), sz);
	}
	constexpr span<std::iter_value_t<I>> reference_read(std::size_t sz)
		requires std::contiguous_iterator<I>
	{
		I it = begin();
		bounded_advance(begin(), end(), sz);
		return span<std::iter_value_t<I>>(it, begin());
	}

	template <ranges::range R>
	constexpr span<std::remove_reference_t<std::iter_reference_t<I>>> read_until_v(const R& range, bool inclusive) {
		I i1 = begin();
		I i2 = ranges::find_first_of(*this, range);
		if (inclusive)
			++i2;
		begin() = i2;
		return { i1, i2 };
	}
};

template <typename T, std::output_iterator<T> I>
class basic_ostream {
protected:
	I iter;

public:
	constexpr basic_ostream() = default;
	constexpr basic_ostream(I i) : iter(i) {}
	template <typename Derived>
	constexpr auto& begin(this Derived& self) {
		return self.iter;
	}

	constexpr operator view<I, std::unreachable_sentinel_t>() const { return view(begin(), {}); }

	constexpr void put(const T& elem) {
		*iter = elem;
		++iter;
	}
	constexpr void put(T&& elem) {
		*iter = std::move(elem);
		++iter;
	}
	template <ranges::range R>
	constexpr void write(R range) {
		for (auto iter = ranges::begin(range); iter != ranges::end(range); ++iter)
			put(*iter);
	}
	template <std::input_iterator I2, std::sentinel_for<I2> S2>
	constexpr void write(I2 begin2, S2 end2) {
		write(view(begin2, end2));
	}
	template <std::input_iterator I2>
	constexpr void write(I2 begin2, std::size_t sz) {
		for (std::size_t i = 0; i < sz; i++, ++begin2)
			put(*begin2);
	}
};

template <std::output_iterator<std::byte> I = std::byte*>
class obinstream : public basic_ostream<std::byte, I> {
public:
	using basic_ostream<std::byte, I>::basic_ostream;
	void write_raw(const void* ptr, std::ptrdiff_t size) {
		this->write(span<std::iter_value_t<I>>((std::iter_value_t<I>*)ptr, size));
	}
	template <typename T>
	void write_raw(const T& val) {
		this->write_raw(&val, sizeof(T));
	}
};

template <iterator_of<std::byte> I = std::byte*, std::sentinel_for<I> S = I>
class ibinstream : public basic_istream<I, S> {
public:
	using basic_istream<I, S>::basic_istream;
	constexpr void read_raw(void* ptr, std::size_t size) { this->read((std::byte*)ptr, size); }
	template <typename T>
	constexpr T read_raw() {
		std::byte data[sizeof(T)];
		this->read(data, sizeof(T));
		return *(T*)data;
	}
};

template <typename I>
basic_istream(I) -> basic_istream<I, std::unreachable_sentinel_t>;
template <iterator_of<std::byte> I>
obinstream(I i) -> obinstream<I>;
template <iterator_of<std::byte> I, std::sentinel_for<I> S>
ibinstream(I i, S s) -> ibinstream<I, S>;