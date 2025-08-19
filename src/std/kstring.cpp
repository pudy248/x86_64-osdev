#include <cstdarg>
#include <cstdint>
#include <kstring.hpp>
#include <net/net.hpp>
#include <stl/container.hpp>
#include <stl/ranges.hpp>

template <typename CharT, std::forward_iterator I, std::sentinel_for<I> S>
template <template <typename> typename C, std::forward_iterator I2, typename S2, typename Derived>
	requires container_template<C>
C<Derived> basic_string_interface<CharT, I, S>::split(this const Derived& self, I2 begin2, S2 end2) {
	std::size_t sz = ranges::count_all(self, view(begin2, end2)) + 1;
	C<Derived> container{ sz };
	istringstream stream(self);
	for (std::size_t i = 0; i < sz; i++) {
		I i1 = stream.begin();
		I i2 = ranges::find_first_of(stream, view(begin2, end2));
		stream.begin() = i2;
		container.emplace_back(i1, i2);
		if (i < sz - 1)
			stream.ignore(1);
	}
	return container;
}
template <typename CharT, std::forward_iterator I, std::sentinel_for<I> S>
template <template <typename> typename C, ranges::forward_range R, typename Derived>
	requires container_template<C>
C<Derived> basic_string_interface<CharT, I, S>::split(this const Derived& self, const R& range) {
	std::size_t sz = ranges::count_all(self, range) + 1;
	C<Derived> container{ sz };
	istringstream stream(self);
	for (std::size_t i = 0; i < sz; i++) {
		I i1 = stream.begin();
		I i2 = ranges::find_first_of(stream, range);
		stream.begin() = i2;
		container.emplace_back(i1, i2);
		if (i < sz - 1)
			stream.ignore(1);
	}
	return container;
}
template <typename CharT, std::forward_iterator I, std::sentinel_for<I> S>
template <template <typename...> typename C, typename Derived>
	requires container_template<C>
C<Derived> basic_string_interface<CharT, I, S>::split(this const Derived& self, CharT c) {
	std::size_t sz = ranges::count(self, c) + 1;
	C<Derived> container{ sz };
	istringstream stream(self);
	for (std::size_t i = 0; i < sz; i++) {
		I i1 = stream.begin();
		I i2 = ranges::find(stream, c);
		stream.begin() = i2;
		container.emplace_back(i1, i2);
		if (i < sz - 1)
			stream.ignore(1);
	}
	return container;
}

template <std::output_iterator<char> I>
constexpr int formats(I output, const rostring fmt, ...) {
	va_list l;
	va_start(l, fmt);

	istringstream fmts(fmt);

	basic_ostringstream<char, I> ostr(output);

	const rostring fmtchars("ixXpbfsSIM");

	while (fmts.readable()) {
		char c = fmts.read_c();
		if (c == '%') {
			istringstream fmtArg(fmts.read_until_v(fmtchars, true));

			bool hasLeading = false;
			bool hasDecimal = false;
			int leadingChars = 1;
			int decimals = 3;
			char leadingChar = ' ';

			auto parseOption = [&](char front) {
				if (front == 'l' || front == 'z')
					fmtArg.read_c();
				else if (front == 'n') {
					fmtArg.read_c();
					leadingChars = va_arg(l, uint64_t);
					hasLeading = true;
				} else if (front == '.') {
					fmtArg.read_c();
					hasDecimal = true;
					decimals = fmtArg.read_i();
				} else if (front >= '1' && front <= '9') {
					leadingChars = fmtArg.read_i();
					hasLeading = true;
				} else
					leadingChar = fmtArg.read_c();
			};

			while (fmtArg.readable()) {
				char front = fmtArg.peek();
				if (ranges::count(fmtchars, front))
					break;
				parseOption(front);
			}

			char c2 = *(fmtArg.end() - 1);

			if (c2 == 'i')
				ostr.writei(va_arg(l, int64_t), leadingChars, 10, leadingChar);
			else if (c2 == 'X')
				ostr.writei(va_arg(l, uint64_t), leadingChars, 16, leadingChar, hasLeading);
			else if (c2 == 'x')
				ostr.writei(va_arg(l, uint64_t), leadingChars, 16, leadingChar, hasLeading, "0123456789abcdef");
			else if (c2 == 'p') {
				ostr.put('0');
				ostr.put('x');
				ostr.writei(va_arg(l, uint64_t), hasLeading ? leadingChars : 8, 16, '0', true);
			} else if (c2 == 'b')
				ostr.writei(va_arg(l, uint64_t), leadingChars, 2, leadingChar);
			else if (c2 == 'f')
				ostr.writef(va_arg(l, double), leadingChars, decimals, leadingChar);
			else if (c2 == 's') {
				const char* ptr = va_arg(l, const char*);
				if (hasDecimal)
					ostr.write(rostring(ptr, ptr + decimals));
				else
					ostr.write(ptr);
			} else if (c2 == 'S')
				ostr.write(*va_arg(l, rostring*));
			else if (c2 == 'I') {
				ipv4_t ip = va_arg(l, ipv4_t);
				for (int i = 0; i < 4; i++) {
					ostr.writei(((uint8_t*)&ip)[i]);
					if (i < 3)
						ostr.put('.');
				}
			} else if (c2 == 'M') {
				mac_t mac = va_arg(l, mac_t);
				for (int i = 0; i < 6; i++) {
					ostr.writei(((uint8_t*)&mac)[i], 2, 16, '0', false, "0123456789abcdef");
					if (i < 5)
						ostr.put(':');
				}
			}
		} else
			ostr.put(c);
	}
	if (fmt.begin() + (fmt.size() - 1))
		ostr.put((char)0);
	va_end(l);

	if constexpr (requires { ostr.begin() - output; })
		return ostr.begin() - output;
	return 0;
}

template <typename... Args>
string format(rostring fmt, Args... args) {
	string s;
	formats(s.oend(), fmt, args...);
	return s;
}