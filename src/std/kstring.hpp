#pragma once
#include <cstdint>
#include <kcstring.hpp>
#include <stl/array.hpp>
#include <stl/stream.hpp>
#include <stl/vector.hpp>
#include <stl/view.hpp>

using cstr_t = const char*;

template <iterator_of<char> I> constexpr idx_t strilen(const I& cstr) {
	I iter = cstr;
	idx_t i = 0;
	for (; *iter; i++, iter++);
	return i;
}
template <iterator_of<char> I> constexpr I striend(const I& cstr) {
	I iter = cstr;
	while (*iter) iter++;
	return iter;
}

template <typename CharT, iterator_of<CharT> I = CharT*, std::sentinel_for<I> S = I>
class basic_string : public view<I, S> {
public:
	using view<I, S>::view;

	constexpr basic_string(const I& begin, const S& end)
		: view<I, S>(begin, end) {}
	template <iterator_of<CharT> I2, typename S2>
	constexpr basic_string(const view<I2, S2>& other)
		: view<I, S>(other.begin(), other.end()) {}

	constexpr operator span<const CharT>() const { return span<const CharT>(this->begin(), this->end()); }
	constexpr operator span<CharT>() { return span<CharT>(this->begin(), this->end()); }

	constexpr basic_string(const I& cstr)
		: view<I, S>(cstr, striend(cstr)) {}

	template <template <typename> typename C = vector, comparable_iter_I<I> I2, typename S2>
		requires requires {
			requires container_template<C>;
			requires(!view<I2, S2>::Infinite);
		}
	C<basic_string> split(const view<I2, S2>& any) const;

	template <template <typename...> typename C = vector>
		requires container_template<C>
	C<basic_string> split(CharT c) const;
	template <template <typename...> typename C = vector>
		requires container_template<C>
	C<basic_string> split(cstr_t c) const;
};

template <typename I> basic_string(const I& i) -> basic_string<I, I>;

using rostring = basic_string<char, cstr_t>;
class string : public vector<char> {
public:
	using vector<char>::vector;
	char* c_str();
	bool operator==(const rostring& other);
};

constexpr rostring operator""_RO(cstr_t literal, uint64_t) { return rostring(literal); }

template <typename CharT, iterator_of<CharT> I> class basic_ostringstream : public basic_ostream<CharT, I> {
public:
	using basic_ostream<CharT, I>::basic_ostream;

	constexpr void write(const CharT elem) { *(this->iter++) = elem; }
	void write(cstr_t dat) { write(rostring(dat)); }
	void write(const rostring& dat) {
		kassert(DEBUG_VERBOSE, ERROR, dat.begin(), "Null string.");
		for (CharT c : dat) write(c);
	}
	void writei(uint64_t n, int field_width = 1, int radix = 10, CharT lead_char = ' ', bool enforce_width = false,
				CharT* letters = "0123456789ABCDEF", bool is_signed = true) {
		if (is_signed && n < 0) {
			write('-');
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
		for (; i > 30 - field_width; i--) tmpstr[i] = lead_char;
		write(tmpstr + i + 1);
	}
	void writef(double n, int leading = 0, int trailing = 3, CharT leadChar = ' ') {
		if ((((uint32_t*)&n)[1] & 0x7ff00000) == 0x7ff00000)
			write("NaN");
		else if (n == 1. / 0.)
			write("Inf");
		else if (n == -1. / 0.)
			write("-Inf");
		else {
			if (n < 0) {
				n = -n;
				write('-');
			}
			double tmp = n;
			int ctr = 0;
			do {
				tmp /= 10;
				ctr++;
			} while ((int)tmp > 0);
			int tmpctr = ctr--;

			for (int i = 0; i < leading - ctr - 1; i++) write(leadChar);

			array<CharT, 32> tmpstr;
			tmp = n;
			do {
				tmpstr.at(ctr--) = '0' + (int)tmp % 10;
				tmp /= 10;
			} while ((int)tmp > 0);
			write(rostring(tmpstr.begin(), tmpstr.begin() + tmpctr));

			if (trailing > 0) {
				write('.');

				tmp = n - (int)n;
				for (int i = 0; i < trailing; i++) {
					tmp *= 10;
					tmpstr.at(i) = '0' + (int)tmp % 10; // + (i == trailing - 1);
				}
				write(rostring(tmpstr.begin(), tmpstr.begin() + trailing));
			}
		}
	}
};

template <typename CharT, iterator_of<CharT> I = const CharT*, std::sentinel_for<I> S = I>
class basic_istringstream : public basic_istream<CharT, I, S> {
public:
	using basic_istream<CharT, I, S>::basic_istream;

	constexpr basic_istringstream(const I& i, const S& s)
		: basic_istream<CharT, I, S>(i, s) {}

	CharT read_c() { return this->read(); }
	int64_t read_i() {
		int64_t val = 0;
		char neg = 0;
		if (*this->begin() == '-') {
			neg = 1;
			read_c();
		}
		while (*this->begin() >= '0' && *this->begin() <= '9') {
			val *= 10;
			val += read_c() - '0';
		}
		if (neg) val = -val;
		return val;
	}
	uint64_t read_x() {
		uint64_t val = 0;
		bool isN = *this->begin() >= '0' && *this->begin() <= '9';
		bool isU = *this->begin() >= 'A' && *this->begin() <= 'F';
		bool isL = *this->begin() >= 'f' && *this->begin() <= 'a';
		while (isN || isU || isL) {
			val *= 16;
			if (isN) val += read_c() - '0';
			if (isU) val += read_c() - 'A' + 10;
			if (isL) val += read_c() - 'a' + 10;
			isN = *this->begin() >= '0' && *this->begin() <= '9';
			isU = *this->begin() >= 'A' && *this->begin() <= 'F';
			isL = *this->begin() >= 'a' && *this->begin() <= 'f';
		}
		return val;
	}
	double read_f() {
		constexpr int trailingMax = 10;
		double val = 0;
		int afterDecimal = 0;
		char neg = 0;
		if (*this->begin() == '-') {
			neg = 1;
			read_c();
		}
		if (view<I, S>(*this).starts_with("NaN"_RO))
			return 0. / 0.;
		else if (view<I, S>(*this).starts_with("Inf"_RO))
			return (neg ? -1. : 1.) / 0.;

		while (*this->begin() >= '0' && *this->begin() <= '9') {
			val *= 10;
			val += read_c() - '0';
		}
		if (*this->begin() == '.') {
			read_c();
			double multiplier = 0.1;
			while (*this->begin() >= '0' && *this->begin() <= '9' && afterDecimal < trailingMax) {
				afterDecimal++;
				val += (read_c() - '0') * multiplier;
				multiplier *= 0.1;
			}
		}
		if (neg) val = -val;
		return val;
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

template <iterator_of<char> I> int formats(const I& output, const rostring fmt, ...);
template <typename... Args> string format(rostring fmt, Args... args);