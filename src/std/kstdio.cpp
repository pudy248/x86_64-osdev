#include <cstddef>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <stl/array.hpp>
#include <text/console.hpp>
#include <text/text_display.hpp>

static constinit string log_string;
static bool do_logging = true;

void refresh_tty() {
	default_output().display();
	default_console().refresh();
}

void putchar(char c, bool refresh) {
	if (do_logging)
		log_string.push_back(c);
	default_output().putchar(c);
	if (refresh)
		refresh_tty();
}
void print(const char* str, bool refresh) {
	print(rostring(str), refresh);
}
void print(span<const char> str, bool refresh) {
	if (do_logging)
		log_string.push_back(str);
	default_output().print(str);
	if (refresh)
		refresh_tty();
}

template <typename... Args>
	requires(!!sizeof...(Args))
void printf(const char* fmt, Args... args) {
	string s = format(fmt, args...);
	print(span<const char>(s.cbegin(), s.cend()));
}
template <typename... Args>
	requires(!!sizeof...(Args))
void printf(span<const char> fmt, Args... args) {
	string s = format(fmt.begin(), args...);
	print(span<const char>(s.cbegin(), s.cend()));
}
template <std::size_t N, typename... Args>
	requires(!!sizeof...(Args))
void qprintf(const char* fmt, Args... args) {
	array<char, N> buf;
	buf.at(formats(buf.begin(), fmt, args...)) = 0;
	print(rostring(buf.cbegin()));
}

void hexdump(const void* ptr, uint32_t bytes, uint32_t block_width, uint32_t num_columns, bool reversed, bool refresh) {
	default_output().hexdump(ptr, bytes, block_width, num_columns, reversed);
	if (refresh)
		refresh_tty();
}

void replace_console(console&& con) {
	text_layer t1{ default_output() };
	text_layer t2{ con };
	t2.copy(t1);
	t2.fill_zeroes(' ');
	default_console() = std::move(con);
	default_output() = t2;
}

void disable_log() {
	do_logging = false;
}
void clear_log() {
	log_string.clear();
}
span<const char> output_log() {
	return log_string;
}

void error(const char* str) {
	disable_log();
	print(str, true);
}
template <std::size_t N, typename... Args>
	requires(!!sizeof...(Args))
void errorf(const char* fmt, Args... args) {
	disable_log();
	qprintf<N>(fmt, args...);
	refresh_tty();
}