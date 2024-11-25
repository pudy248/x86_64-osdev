#pragma once
#include <cstdint>
#include <kassert.hpp>
#include <kcstring.hpp>
#include <limits>
#include <stl/array.hpp>
#include <stl/stream.hpp>
#include <stl/vector.hpp>
#include <stl/view.hpp>

template <iterator_of<char> I>
constexpr idx_t strilen(const I& cstr) {
	I iter = cstr;
	idx_t i = 0;
	for (; *iter; i++, iter++)
		;
	return i;
}
template <iterator_of<char> I>
constexpr I striend(const I& cstr) {
	I iter = cstr;
	while (*iter)
		iter++;
	return iter;
}

template <typename CharT, iterator_of<CharT> I = CharT*, std::sentinel_for<I> S = I>
class basic_string : public view<I, S> {
public:
	using view<I, S>::view;

	constexpr basic_string(const I& begin, const S& end) : view<I, S>(begin, end) {}
	template <iterator_of<CharT> I2, typename S2>
	constexpr basic_string(const view<I2, S2>& other) : view<I, S>(other.begin(), other.end()) {}

	constexpr operator span<const CharT>() const { return span<const CharT>(this->begin(), this->end()); }
	constexpr operator span<CharT>() { return span<CharT>(this->begin(), this->end()); }

	constexpr basic_string(const I& cstr) : view<I, S>(cstr, striend(cstr)) {}

	template <template <typename> typename C = vector, comparable_iter_I<I> I2, typename S2, typename Derived>
		requires requires {
			requires container_template<C>;
			requires(!view<I2, S2>::Infinite);
		}
	C<Derived> split(this const Derived& self, const view<I2, S2>& any);

	template <template <typename...> typename C = vector, typename Derived>
		requires container_template<C>
	C<Derived> split(this const Derived& self, CharT c);

	template <template <typename...> typename C = vector, typename Derived>
		requires container_template<C>
	C<Derived> split(this const Derived& self, ccstr_t c);
};

template <typename I>
basic_string(const I& i) -> basic_string<I, I>;

class rostring : public basic_string<char, ccstr_t> {
public:
	using basic_string<char, ccstr_t>::basic_string;
	rostring(ccstr_t cstr) : basic_string(cstr) {}
};
constexpr rostring operator""_RO(const char* literal, uint64_t) { return rostring(literal); }

template <allocator A = default_allocator>
class alloc_string : public vector<char, A> {
public:
	using vector<char, A>::vector;
	char* c_str() {
		if (!this->size() || this->at(this->size() - 1) != '\0')
			this->append(0);
		return &*this->begin();
	}
	bool operator==(const rostring& other) const {
		auto v = view(*this);
		auto o = other;
		if (view(*this).contains(0))
			v = view(this->begin(), this->begin() + view(*this).find(0));
		if (other.contains(0))
			o = other.subspan(0, other.find(0));
		return v == o;
	}
};
using string = alloc_string<default_allocator>;

template <convertible_elem_I<rostring> I, typename S>
constexpr string concat(const view<I, S>& v) {
	string s;
	for (const rostring& str : v)
		s.append(str);
	return s;
}
template <typename C>
constexpr string concat(const C& c) {
	return concat(view(c.cbegin(), c.cend()));
}

template <typename CharT, iterator_of<CharT> I>
class basic_ostringstream : public basic_ostream<CharT, I> {
public:
	using basic_ostream<CharT, I>::basic_ostream;

	constexpr void write(const CharT elem) { *(this->iter++) = elem; }
	void write(ccstr_t dat) { write(rostring(dat)); }
	void write(const rostring& dat) {
		kassert(DEBUG_VERBOSE, ERROR, dat.begin(), "Null string.");
		for (CharT c : dat)
			write(c);
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
		for (; i > 30 - field_width; i--)
			tmpstr[i] = lead_char;
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

			for (int i = 0; i < leading - ctr - 1; i++)
				write(leadChar);

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

	constexpr basic_istringstream(const I& i, const S& s) : basic_istream<CharT, I, S>(i, s) {}

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
		if (neg)
			val = -val;
		return val;
	}
	uint64_t read_x() {
		uint64_t val = 0;
		for (I& it = this->begin(); it != this->end(); ++it) {
			if (*it >= '0' && *it <= '9')
				val = (val << 4) + (*it - '0');
			else if (*it >= 'A' && *it <= 'F')
				val = (val << 4) + (*it - 'A' + 10);
			else if (*it >= 'a' && *it <= 'f')
				val = (val << 4) + (*it - 'a' + 10);
			else
				break;
		}
		return val;
	}
	double read_f() {
		constexpr int trailingMax = 10;
		double val = 0;
		int afterDecimal = 0;
		bool neg = false;
		I& it = this->begin();

		if (*it == '-') {
			neg = true;
			++it;
		}
		if (view<I, S>(*this).starts_with("NaN"_RO))
			return std::numeric_limits<double>::quiet_NaN();
		//else if (view<I, S>(*this).starts_with("Inf"_RO))
		//	return neg ? -std::numeric_limits<double>::infinity() : std::numeric_limits<double>::infinity();

		while (*it >= '0' && *it <= '9') {
			val = val * 10 + (*it++ - '0');
		}
		if (*it == '.') {
			++it;
			double multiplier = 0.1;
			while (*it >= '0' && *it <= '9' && afterDecimal < trailingMax) {
				val += (*it++ - '0') * multiplier;
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

template <iterator_of<char> I>
int formats(const I& output, const rostring fmt, ...);
template <typename... Args>
string format(rostring fmt, Args... args);