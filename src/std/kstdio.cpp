#include <cstddef>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <stl/array.hpp>
#include <sys/global.hpp>
#include <text/console.hpp>
#include <text/text_display.hpp>

static string log_string;
static bool do_logging = true;

void refresh_tty() {
	default_output().display();
	default_console().refresh();
}

void putchar(char c, bool refresh) {
	if (do_logging)
		log_string.append(c);
	default_output().putchar(c);
	if (refresh)
		refresh_tty();
}
void print(const char* str, bool refresh) { print(rostring(str), refresh); }
void print(span<const char> str, bool refresh) {
	if (do_logging)
		log_string.append(str);
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
	default_console() = std::move(con);
	text_layer l{ default_console() };
	default_output().display(l);
	l = default_output();
}

void disable_log() { do_logging = false; }
void clear_log() { log_string.clear(); }
rostring output_log() { return log_string; }

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