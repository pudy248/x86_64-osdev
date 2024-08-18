#pragma once
#include <cstdint>
#include <kcstring.hpp>
#include <stl/array.hpp>
#include <stl/stream.hpp>
#include <stl/vector.hpp>
#include <stl/view.hpp>

template <iterator_of<char> I> constexpr idx_t strilen(const I& cstr) {
	I iter = cstr;
	idx_t i = 0;
	for (; *iter; i++, iter++)
		;
	return i;
}
template <iterator_of<char> I> constexpr I striend(const I& cstr) {
	I iter = cstr;
	while (*iter)
		iter++;
	return iter;
}

template <iterator_of<char> I, typename S> class basic_string : public view<I, S> {
public:
	using view<I, S>::view;

	constexpr basic_string(const I& begin, const S& end)
		: view<I, S>(begin, end) {
	}
	template <iterator_of<char> I2, typename S2>
	constexpr basic_string(const view<I2, S2>& other)
		: view<I, S>(other.begin(), other.end()) {
	}

	constexpr basic_string(const I& cstr)
		: view<I, S>(cstr, striend(cstr)) {
	}

	template <template <typename> typename C, comparable_iter_I<I> I2, typename S2>
		requires requires {
			requires container_template<C>;
			requires(!view<I2, S2>::Infinite);
		}
	C<basic_string<I, I>> split(const view<I2, S2>& any) const;

	template <template <typename...> typename C>
		requires container_template<C>
	C<basic_string<I, I>> split(char c) const;
	template <template <typename...> typename C>
		requires container_template<C>
	C<basic_string<I, I>> split(const char* c) const;
};

template <typename I> basic_string(const I& i) -> basic_string<I, I>;

using rostring = basic_string<const char*, const char*>;
class string : public vector<char> {
public:
	using vector<char>::vector;
	char* c_str_this();
	char* c_str_new();
	bool operator==(const rostring& other);
};

constexpr rostring operator""_RO(const char* literal, uint64_t) {
	return rostring(literal);
}

template <iterator_of<char> I> class basic_ostringstream : public basic_ostream<I> {
public:
	using basic_ostream<I>::basic_ostream;
	using T = typename basic_ostream<I>::T;

	constexpr void write(const char elem) {
		*(this->iter++) = elem;
	}
	void write(const char* dat) {
		write(rostring(dat));
	}
	void write(const rostring& dat) {
		for (const char c : dat)
			write(c);
	}
	void writei(uint64_t n, int field_width = 0, int radix = 10, char lead_char = ' ',
				const char* letters = "0123456789ABCDEF", bool is_signed = true) {
		if (is_signed && n < 0) {
			n = -n;
			write('-');
			field_width--;
			writei(n, field_width, radix, lead_char, letters, false);
			return;
		}

		char tmpstr[22] = {};
		int i = field_width - 1;
		for (; n != 0; i--) {
			tmpstr[i--] = letters[n % radix];
			n /= radix;
		}
		for (; i >= 0; i--)
			tmpstr[i] = lead_char;
		write(tmpstr);
	}
	void writef(double n, int leading = 0, int trailing = 3, char leadChar = ' ') {
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

			for (int i = 0; i < leading - ctr - 1; i++)
				write(leadChar);

			array<char, 15> tmpstr;
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

template <iterator_of<char> I, typename S> class basic_istringstream : public basic_istream<I, S> {
public:
	using basic_istream<I, S>::basic_istream;
	using T = typename basic_istream<I, S>::T;

	constexpr basic_istringstream(const I& i, const S& s)
		: basic_istream<I, S>(i, s) {
	}

	char read_c() {
		return this->read();
	}
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
		if (neg)
			val = -val;
		return val;
	}
	uint64_t read_x() {
		uint64_t val = 0;
		bool isN = *this->begin() >= '0' && *this->begin() <= '9';
		bool isU = *this->begin() >= 'A' && *this->begin() <= 'F';
		bool isL = *this->begin() >= 'f' && *this->begin() <= 'a';
		while (isN || isU || isL) {
			val *= 16;
			if (isN)
				val += read_c() - '0';
			if (isU)
				val += read_c() - 'A' + 10;
			if (isL)
				val += read_c() - 'a' + 10;
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
		if (this->as().starts_with(rostring("NaN")))
			return 0. / 0.;
		else if (this->as().starts_with(rostring("Inf")))
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
		if (neg)
			val = -val;
		return val;
	}
};
class ostringstream : public basic_ostringstream<vector<char>::iterator_type> {
public:
	using basic_ostringstream<vector<char>::iterator_type>::basic_ostringstream;
};
class istringstream : public basic_istringstream<const char*, const char*> {
public:
	using basic_istringstream<const char*, const char*>::basic_istringstream;
};

template <iterator_of<char> I> int formats(const I& output, const rostring fmt, ...);
template <typename... Args> string format(rostring fmt, Args... args);