#pragma once
#include <cstddef>
#include <iterator>
#include <kassert.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/iterator.hpp>
#include <stl/iterator/iterator_interface.hpp>
#include <stl/iterator/utilities.hpp>
#include <stl/ranges.hpp>
#include <stl/vector.hpp>
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
template <std::input_iterator I>
class istreambuf_sp_iterator;
template <std::input_iterator I>
class istreambuf_mp_iterator;

template <std::input_iterator I>
class istream_buffer : public vector<std::iter_value_t<I>> {
protected:
	friend class istreambuf_sp_iterator<I>;
	friend class istreambuf_mp_iterator<I>;

public:
	I backing_iter;
	std::ptrdiff_t base_offset;
	std::ptrdiff_t create_offset;
	using vector<std::iter_value_t<I>>::size;

	constexpr explicit istream_buffer(I begin)
		: vector<std::iter_value_t<I>>(0), backing_iter(std::move(begin)), base_offset(0), create_offset(0) {}
	constexpr istreambuf_sp_iterator<I> spbegin() { return istreambuf_sp_iterator(*this); }
	constexpr istreambuf_mp_iterator<I> mpbegin() { return istreambuf_mp_iterator(*this); }
	constexpr void advance_to(std::ptrdiff_t count) {
		this->erase(0, min(std::ptrdiff_t(this->size()), base_offset + count));
		base_offset = base_offset + count;
		create_offset = max(create_offset, base_offset);
	}
	constexpr void advance_to(istreambuf_mp_iterator<I> it) { advance_to(it.offset - base_offset); }
	constexpr void advance_to() { advance_to(this->size()); }
	constexpr void advance_creation(istreambuf_mp_iterator<I> it) { create_offset = it.offset; }
};
template <typename I>
struct std::indirectly_readable_traits<istreambuf_sp_iterator<I>> {
	using value_type = std::iter_value_t<I>;
};
template <std::input_iterator I>
class istreambuf_sp_iterator : public pure_input_iterator_interface<istreambuf_sp_iterator<I>, std::iter_value_t<I>> {
	friend class istream_buffer<I>;
	istream_buffer<I>* buf;

public:
	using pure_input_iterator_interface<istreambuf_sp_iterator<I>, std::iter_value_t<I>>::operator++;

	constexpr istreambuf_sp_iterator(istream_buffer<I>& b) : buf(&b) {}
	constexpr std::iter_value_t<I> operator*() const {
		if (!buf->size())
			return *buf->backing_iter;
		else
			return buf->at(0);
	}
	constexpr istreambuf_sp_iterator& operator++() {
		if (buf->size())
			buf->advance_to(1);
		else
			++buf->backing_iter;
		return *this;
	}
	constexpr bool operator==(const istreambuf_sp_iterator& iter) const { return buf == iter.buf; }
	template <typename R>
		requires(!std::same_as<R, null_sentinel>)
	constexpr bool operator==(const R& sent) const {
		return buf->backing_iter == sent;
	}
	constexpr std::ptrdiff_t operator-(const istreambuf_sp_iterator&) const { return 0; }
};
template <typename I>
struct std::indirectly_readable_traits<istreambuf_mp_iterator<I>> {
	using value_type = std::iter_value_t<I>;
};
template <std::input_iterator I>
class istreambuf_mp_iterator : public forward_iterator_interface<istreambuf_mp_iterator<I>> {
	friend class istream_buffer<I>;
	istream_buffer<I>* buf;
	std::ptrdiff_t offset;

public:
	using forward_iterator_interface<istreambuf_mp_iterator<I>>::operator++;

	constexpr istreambuf_mp_iterator(istream_buffer<I>& b) : buf(&b), offset(b.create_offset) {}
	constexpr const std::iter_value_t<I>& operator*() const {
		while (offset >= buf->base_offset + buf->size()) {
			buf->emplace_back(*buf->backing_iter);
			++buf->backing_iter;
		}
		return buf->iat(offset - buf->base_offset);
	}
	constexpr istreambuf_mp_iterator& operator++() {
		++offset;
		return *this;
	}
	constexpr bool operator==(const istreambuf_mp_iterator& iter) const { return offset == iter.offset; }
	template <typename R>
		requires(!std::same_as<R, null_sentinel>)
	constexpr bool operator==(const R& sent) const {
		return buf->backing_iter == sent;
	}
	constexpr std::ptrdiff_t operator-(const istreambuf_mp_iterator& iter) const { return offset - iter.offset; }
};

template <std::input_iterator I, std::sentinel_for<I> S = null_sentinel>
class basic_istream {
public:
	mutable istream_buffer<I> buffer;
	S sentinel;

public:
	constexpr basic_istream() : buffer(I{}), sentinel(S{}) {};
	constexpr basic_istream(I i, S s = {}) : buffer(std::move(i)), sentinel(std::move(s)) {}
	template <ranges::range R>
	constexpr basic_istream(const R& range) : buffer(ranges::begin(range)), sentinel(ranges::end(range)) {}
	template <typename Derived>
		requires(!std::is_const_v<Derived>)
	constexpr auto begin(this Derived& self) {
		return self.buffer.spbegin();
	}
	template <typename Derived>
		requires(!std::is_const_v<Derived>)
	constexpr auto mpbegin(this Derived& self) {
		return self.buffer.mpbegin();
	}
	template <typename Derived>
	constexpr const auto& end(this const Derived& self) {
		return self.sentinel;
	}
	constexpr void advance_buf() { buffer.advance_to(); }
	constexpr void advance_buf(istreambuf_mp_iterator<I> it) { buffer.advance_to(it); }

	constexpr bool readable() const { return sentinel != buffer.backing_iter; }
	constexpr auto peek() { return *begin(); }
	constexpr auto get() {
		auto it = begin();
		auto val = *it++;
		return val;
	}
	constexpr operator bool() const { return readable(); }

	constexpr void ignore(std::size_t sz) { buffer.advance_to(sz); }

	template <typename OutI>
		requires impl::output_for<OutI, I>
	constexpr void read(OutI&& out, std::size_t sz) {
		algo::mut::copy_n(decay(out), null_sentinel{}, begin(), end(), sz);
	}

	template <ranges::range R>
	constexpr vector<std::remove_reference_t<std::iter_reference_t<I>>> read_until_v(const R& range, bool inclusive) {
		auto i1 = begin();
		auto i2 = ranges::find_first_of(*this, range);
		if (inclusive)
			++i2;
		return vector<std::remove_reference_t<std::iter_reference_t<I>>>(i1, i2);
	}

	template <ranges::range R>
	constexpr bool match(const R& range) {
		if (ranges::val::starts_with(*this, range)) {
			this->ignore(ranges::size(range));
			return true;
		} else
			return false;
	}
};
template <std::forward_iterator I, std::sentinel_for<I> S>
class basic_istream<I, S> {
protected:
	I iter;
	S sentinel;

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
	constexpr auto& mpbegin(this Derived& self) {
		return self.iter;
	}
	template <typename Derived>
	constexpr const auto& end(this const Derived& self) {
		return self.sentinel;
	}
	constexpr void advance_buf() {}
	constexpr void advance_buf(auto) {}

	constexpr bool readable() const { return sentinel != iter; }
	constexpr auto peek() { return *iter; }
	constexpr auto get() {
		auto t = std::move(*iter);
		++iter;
		return t;
	}
	constexpr operator bool() const { return readable(); }
	constexpr void ignore(std::size_t sz) { std::advance(iter, sz); }

	template <typename OutI>
		requires impl::output_for<OutI, I>
	constexpr void read(OutI&& out, std::size_t sz) {
		algo::mut::copy_n(decay(out), null_sentinel{}, begin(), end(), sz);
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
		return {i1, i2};
	}

	template <ranges::range R>
	constexpr bool match(const R& range) {
		if (ranges::val::starts_with(*this, range)) {
			this->ignore(ranges::size(range));
			return true;
		} else
			return false;
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

	//constexpr operator view<I, null_sentinel>() const { return view(begin(), {}); }

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
	void write_raw(const void* ptr, std::ptrdiff_t size) { this->write(span((std::byte*)ptr, size)); }
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
basic_istream(I) -> basic_istream<I, null_sentinel>;
template <iterator_of<std::byte> I>
obinstream(I i) -> obinstream<I>;
template <iterator_of<std::byte> I, std::sentinel_for<I> S>
ibinstream(I i, S s) -> ibinstream<I, S>;