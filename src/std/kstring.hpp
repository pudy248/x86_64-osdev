#pragma once
#include <cstdint>
#include <iterator>
#include <kcstring.hpp>
#include <limits>
#include <stl/allocator.hpp>
#include <stl/array.hpp>
#include <stl/ranges.hpp>
#include <stl/stream.hpp>
#include <stl/vector.hpp>

template <std::forward_iterator I>
constexpr std::ptrdiff_t strilen(const I& cstr) {
	I iter = cstr;
	std::ptrdiff_t i = 0;
	for (; *iter; ++i, ++iter)
		;
	return i;
}
template <std::forward_iterator I>
constexpr I striend(const I& cstr) {
	I iter = cstr;
	while (*iter)
		++iter;
	return iter;
}

template <typename CharT, std::forward_iterator I = CharT*, std::sentinel_for<I> S = I>
class basic_string_interface {
public:
	template <typename Derived>
	constexpr operator span<CharT>(this const Derived& self) {
		return span<const CharT>(ranges::begin(self), ranges::end(self));
	}

	template <typename Derived, ranges::range R>
	bool operator==(this const Derived& self, const R& other) {
		bool self_empty = !ranges::size(self) || !ranges::at(self, 0);
		bool other_empty = !ranges::size(other) || !ranges::at(other, 0);
		if (self_empty && other_empty)
			return true;
		if (self_empty != other_empty)
			return false;
		return ranges::equal(
			view(ranges::begin(self), ranges::find(self, 0)), view(ranges::begin(other), ranges::find(other, 0)));
	}

	template <template <typename> typename C = vector, std::forward_iterator I2, typename S2, typename Derived>
		requires container_template<C>
	C<Derived> split(this const Derived& self, I2 begin2, S2 end2);

	template <template <typename> typename C = vector, ranges::forward_range R, typename Derived>
		requires container_template<C>
	C<Derived> split(this const Derived& self, const R& range);

	template <template <typename...> typename C = vector, typename Derived>
		requires container_template<C>
	C<Derived> split(this const Derived& self, CharT c);
};

template <typename CharT, std::forward_iterator I = CharT*, std::sentinel_for<I> S = I>
class basic_rostring : public view<I, S>, public basic_string_interface<CharT, I, S> {
public:
	constexpr basic_rostring() = default;
	constexpr basic_rostring(I begin, S end) : view<I, S>(begin, end) {
		if (this->iter != this->sentinel)
			this->sentinel = ranges::find(*this, 0);
	}
	constexpr basic_rostring(I begin, std::iter_difference_t<I> length) : view<I, S>(begin, length) {};
	template <ranges::range R>
	constexpr basic_rostring(R&& range) : view<I, S>(ranges::begin(range), ranges::end(range)) {
		if (this->iter != this->sentinel)
			this->sentinel = ranges::find(*this, 0);
	}
	//template <std::forward_iterator I2>
	//constexpr basic_rostring(I2 begin) : view<I, S>(begin, striend(begin)) {}
};
using rostring = basic_rostring<const char>;

template <typename I>
basic_rostring(I i) -> basic_rostring<I, I>;
constexpr rostring operator""_RO(const char* literal, uint64_t) { return rostring(literal); }

template <typename CharT, allocator A = default_allocator<CharT>>
class basic_string : public vector<CharT, A>, public basic_string_interface<CharT> {
public:
	using vector<CharT, A>::vector;
	CharT* c_str() {
		if (!this->size() || this->at(this->size() - 1) != '\0')
			this->push_back(0);
		return &*this->begin();
	}
};
using string = basic_string<char>;

template <typename S = string, ranges::range R>
	requires ranges::range<ranges::value_t<R>>
constexpr auto concat(const R& range) {
	S s = {};
	for (const auto& str : range)
		ranges::copy(ranges::unbounded_range(s.oend()), str);
	return s;
}

template <typename CharT, iterator_of<CharT> I>
class basic_ostringstream : public basic_ostream<CharT, I> {
public:
	using basic_ostream<CharT, I>::basic_ostream;
	using basic_ostream<CharT, I>::write;

	constexpr void writei(uint64_t n, int field_width = 1, int radix = 10, CharT lead_char = ' ',
		bool enforce_width = false, const CharT* letters = "0123456789ABCDEF", bool is_signed = true) {
		if (is_signed && n < 0) {
			this->put('-');
			writei(-n, max(field_width - 1, 1), radix, enforce_width, lead_char, letters, false);
			return;
		}

		CharT tmpstr[32];
		tmpstr[31] = 0;
		int i = 30;
		do {
			tmpstr[i--] = letters[n % radix];
			n /= radix;
		} while (n != 0 && (!enforce_width || i > 30 - field_width));
		for (; i > 30 - field_width; i--)
			tmpstr[i] = lead_char;
		write(tmpstr + i + 1);
	}
	constexpr void writef(double n, int leading = 0, int trailing = 3, CharT leadChar = ' ') {
		if ((((uint32_t*)&n)[1] & 0x7ff00000) == 0x7ff00000)
			write("NaN");
		else if (n == 1. / 0.)
			write("Inf");
		else if (n == -1. / 0.)
			write("-Inf");
		else {
			if (n < 0) {
				n = -n;
				this->put('-');
			}
			double tmp = n;
			int ctr = 0;
			do {
				tmp /= 10;
				ctr++;
			} while ((int)tmp > 0);
			int tmpctr = ctr--;

			for (int i = 0; i < leading - ctr - 1; i++)
				this->put(leadChar);

			array<CharT, 32> tmpstr;
			tmp = n;
			do {
				tmpstr.at(ctr--) = '0' + (int)tmp % 10;
				tmp /= 10;
			} while ((int)tmp > 0);
			this->write(tmpstr.begin(), tmpctr);

			if (trailing > 0) {
				this->put('.');

				tmp = n - (int)n;
				for (int i = 0; i < trailing; i++) {
					tmp *= 10;
					tmpstr.at(i) = '0' + (int)tmp % 10; // + (i == trailing - 1);
				}
				this->write(tmpstr.begin(), trailing);
			}
		}
	}
};

template <typename CharT, std::input_iterator I = const CharT*, std::sentinel_for<I> S = I>
class basic_istringstream : public basic_istream<I, S> {
public:
	using basic_istream<I, S>::basic_istream;

	constexpr basic_istringstream(const I& i, const S& s) : basic_istream<I, S>(i, s) {}

	constexpr CharT read_c() { return this->get(); }
	constexpr int64_t read_i() {
		int64_t val = 0;
		char neg = 0;
		if (this->peek() == '-') {
			neg = 1;
			read_c();
		}
		while (this->peek() >= '0' && this->peek() <= '9') {
			val *= 10;
			val += read_c() - '0';
		}
		if (neg)
			val = -val;
		return val;
	}
	constexpr uint64_t read_x() {
		uint64_t val = 0;
		while (this->readable()) {
			CharT c = this->peek();
			if (c >= '0' && c <= '9')
				val = (val << 4) + (c - '0');
			else if (c >= 'A' && c <= 'F')
				val = (val << 4) + (c - 'A' + 10);
			else if (c >= 'a' && c <= 'f')
				val = (val << 4) + (c - 'a' + 10);
			else
				break;
			this->read_c();
		}
		return val;
	}
	constexpr double read_f() {
		double val = 0;
		bool neg = false;

		if (this->peek() == '-') {
			neg = true;
			this->ignore(1);
		}
		if (ranges::starts_with(*this, "NaN"_RO))
			return std::numeric_limits<double>::quiet_NaN();
		//else if (view<I, S>(*this).starts_with("Inf"_RO))
		//	return neg ? -std::numeric_limits<double>::infinity() : std::numeric_limits<double>::infinity();

		while (this->peek() >= '0' && this->peek() <= '9')
			val = val * 10 + (this->read_c() - '0');
		if (this->peek() == '.') {
			constexpr int trailingMax = 10;
			int afterDecimal = 0;
			this->ignore(1);
			double multiplier = 0.1;
			while (this->peek() >= '0' && this->peek() <= '9' && afterDecimal < trailingMax) {
				val += (this->read_c() - '0') * multiplier;
				multiplier *= 0.1;
				++afterDecimal;
			}
		}
		return neg ? -val : val;
	}
};
class ostringstream : public basic_ostringstream<char, vector<char>::iterator_type> {
public:
	using basic_ostringstream<char, vector<char>::iterator_type>::basic_ostringstream;
};
class istringstream : public basic_istringstream<char> {
public:
	using basic_istringstream<char>::basic_istringstream;
};

template <std::output_iterator<char> I>
constexpr int formats(I output, const rostring fmt, ...);
template <typename... Args>
string format(rostring fmt, Args... args);