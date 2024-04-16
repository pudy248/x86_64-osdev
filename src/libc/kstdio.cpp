#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <stl/array.hpp>
#include <sys/global.hpp>

console::console(char (*g)(uint32_t, uint32_t), void (*s)(uint32_t, uint32_t, char), void (*r)(), int d[2])
	: text_rect{ 0, 0, d[0], d[1] }
	, get_char(g)
	, set_char(s)
	, refresh(r) {
}
void console::newline() {
	cy++;
	if (cy == text_rect[3] - text_rect[1]) {
		for (int y = text_rect[1]; y < text_rect[1] + text_rect[3] - 1; y++) {
			for (int x = text_rect[0]; x < text_rect[0] + text_rect[2]; x++) {
				set_char(x, y, get_char(x, y + 1));
			}
		}
		cy--;
	}
	for (int x = text_rect[0]; x < text_rect[0] + text_rect[2]; x++) {
		set_char(x, cy, 0);
	}
	//Unix or Windows?
	cx = 0;
}
void console::putchar_noupdate(char c) {
	if (!c)
		return;
	else if (c == '\r')
		cx = 0;
	else if (c == '\n')
		newline();
	else {
		set_char(cx, cy, c);
		cx++;
		if (cx == text_rect[0] + text_rect[2]) {
			cx = text_rect[0];
			newline();
		}
	}
}
void console::putchar(char c) {
	putchar_noupdate(c);
	refresh();
}
void console::putstr(const char* s) {
	for (int i = 0; s[i]; i++)
		putchar(s[i]);
	refresh();
}

static void hexdump_impl(console& c, uint8_t* src, int size, bool reversed) {
	const char* hextable = "0123456789ABCDEF";
	for (int i = reversed ? size - 1 : 0; reversed ? i >= 0 : i < size; reversed ? i-- : i++) {
		c.putchar(hextable[src[i] >> 4]);
		c.putchar(hextable[src[i] & 0xf]);
		if (!((i + !reversed) & 3))
			c.putchar(' ');
	}
}

void console::hexdump(void* src, uint32_t size) {
	hexdump_impl(*this, (uint8_t*)src, size, false);
	putstr("\n");
}
void console::hexdump_rev(void* src, uint32_t size, uint32_t swap_width) {
	for (uint32_t i = 0; i < size; i += swap_width)
		hexdump_impl(*this, (uint8_t*)((uint64_t)src + i), swap_width, true);
	putstr("\n");
}

void print(const char* str) {
	globals->g_console->putstr(str);
}
void print(rostring str) {
	for (int i = 0; str.size(); i++)
		globals->g_console->putchar(str[i]);
}

template <typename... Args> void printf(const char* fmt, Args... args) {
	string s = format(rostring(fmt), args...);
	globals->g_console->putstr(s.c_str_this());
}
template <typename... Args> void printf(rostring fmt, Args... args) {
	string s = format(fmt, args...);
	globals->g_console->putstr(s.c_str_this());
}
template <std::size_t N, typename... Args> void qprintf(const char* fmt, Args... args) {
	array<char, N> buf;
	buf.at(formats(buf, fmt, args...)) = 0;
	globals->g_console->putstr(buf.begin());
}