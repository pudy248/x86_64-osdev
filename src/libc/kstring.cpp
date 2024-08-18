#include <cstdarg>
#include <cstdint>
#include <kstring.hpp>
#include <net/net.hpp>
#include <stl/container.hpp>
#include <stl/stream.hpp>
#include <stl/vector.hpp>
#include <stl/view.hpp>

char* string::c_str_new() { return &*this->begin(); }
char* string::c_str_this() {
	if (!this->size() || *(this->end() - 1)) this->append(0);
	return &*this->begin();
}

template <typename CharT, iterator_of<CharT> I, std::sentinel_for<I> S>
template <template <typename> typename C, comparable_iter_I<I> I2, typename S2>
	requires requires {
		requires container_template<C>;
		requires(!view<I2, S2>::Infinite);
	}
C<basic_string<CharT, I, S>> basic_string<CharT, I, S>::split(const view<I2, S2>& any) const {
	idx_t sz = this->count(any) + 1;
	C<basic_string<CharT, I, S>> container{ sz };
	idx_t i = 0;
	istringstream stream(*this);
	while (i < sz) {
		container.at(i++) = stream.read_until_v(any);
		stream.read_c();
	}
	return container;
}
template <typename CharT, iterator_of<CharT> I, std::sentinel_for<I> S>
template <template <typename...> typename C>
	requires container_template<C>
C<basic_string<CharT, I, S>> basic_string<CharT, I, S>::split(CharT c) const {
	idx_t sz = this->count(c) + 1;
	C<basic_string<CharT, I, S>> container{ sz };
	idx_t i = 0;
	istringstream stream(*this);
	while (i < sz) {
		container.at(i++) = stream.read_until_v(c);
		stream.read_c();
	}
	return container;
}

template <typename CharT, iterator_of<CharT> I, std::sentinel_for<I> S>
template <template <typename...> typename C>
	requires container_template<C>
C<basic_string<CharT, I, S>> basic_string<CharT, I, S>::split(cstr_t c) const {
	return this->split<C>(rostring(c));
}
bool string::operator==(const rostring& other) { return view(*this).equals(other); }

template <iterator_of<char> I> int formats(const I& output, const rostring fmt, ...) {
	va_list l;
	va_start(l, fmt);

	istringstream fmts(fmt);

	basic_ostringstream<char, I> ostr(output);

	const rostring fmtchars("ixXpbfsSIM");

	while (fmts.readable()) {
		char c = fmts.read_c();
		if (c == '%') {
			istringstream fmtArg(fmts.read_until_v(fmtchars, true));
			int leadingChars = 1;
			int decimals = 3;
			bool hasDecimal = false;
			char leadingChar = ' ';

			while (fmtArg.readable()) {
				char front = *fmtArg.begin();
				if (fmtchars.contains(front))
					break;
				else if (front == 'l' || front == 'z')
					fmtArg.read_c();
				else if (front == 'n') {
					fmtArg.read_c();
					leadingChars = va_arg(l, uint64_t);
				} else if (front == '.') {
					fmtArg.read_c();
					hasDecimal = true;
					decimals = fmtArg.read_i();
				} else if (front >= '1' && front <= '9') {
					leadingChars = fmtArg.read_i();
				} else {
					leadingChar = fmtArg.read_c();
				}
			}
			char c2 = *(fmtArg.end() - 1);
			if (c2 == 'i') {
				ostr.writei(va_arg(l, int64_t), leadingChars, 10, leadingChar);
			} else if (c2 == 'X') {
				ostr.writei(va_arg(l, uint64_t), leadingChars, 16, leadingChar, true);
			} else if (c2 == 'x') {
				ostr.writei(va_arg(l, uint64_t), leadingChars, 16, leadingChar, true,
							"0123456789abcdef");
			} else if (c2 == 'p') {
				ostr.write('0');
				ostr.write('x');
				ostr.writei(va_arg(l, uint64_t), leadingChars, 16, leadingChar, true);
			} else if (c2 == 'b') {
				ostr.writei(va_arg(l, uint64_t), leadingChars, 2, leadingChar);
			} else if (c2 == 'f') {
				ostr.writef(va_arg(l, double), leadingChars, decimals, leadingChar);
			} else if (c2 == 's') {
				const char* ptr = va_arg(l, const char*);
				if (hasDecimal)
					ostr.write(rostring(ptr, ptr + decimals));
				else
					ostr.write(ptr);
			} else if (c2 == 'S') {
				ostr.write(*va_arg(l, rostring*));
			} else if (c2 == 'I') {
				ipv4_t ip = va_arg(l, ipv4_t);
				for (int i = 0; i < 4; i++) {
					ostr.writei(((uint8_t*)&ip)[i]);
					if (i < 3) ostr.write('.');
				}
			} else if (c2 == 'M') {
				mac_t mac = va_arg(l, mac_t);
				for (int i = 0; i < 6; i++) {
					ostr.writei(((uint8_t*)&mac)[i], 2, 16, '0', false, "0123456789abcdef");
					if (i < 5) ostr.write(':');
				}
			}
		} else
			ostr.write(c);
	}
	va_end(l);

	return ostr.begin() - output;
}

template <typename... Args> string format(rostring fmt, Args... args) {
	string s;
	formats(s.begin(), fmt, args...);
	return s;
}
