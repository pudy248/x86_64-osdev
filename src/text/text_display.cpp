#include <cstdint>
#include <kstring.hpp>
#include <stl/vector.hpp>
#include <sys/global.hpp>
#include <text/console.hpp>
#include <text/text_display.hpp>

template <typename T>
constexpr void set_if_src(T& dest, T src, T inval = (T)-1) {
	if (src != inval)
		dest = src;
}
template <typename T>
constexpr void set_if_not_dest(T& dest, T src, T inval = (T)-1) {
	if (dest == inval)
		dest = src;
}

text_layer& default_output() { return *globals->g_stdout; }

text_layer::text_layer(const console& c)
	: buffer(c.dims[0] * c.dims[1])
	, cursor(0, 0)
	, offset(0, 0)
	, dims(c.dims[0], c.dims[1])
	, margins(0, c.dims[0], 0, c.dims[1]) {
	span(buffer).fill(0);
}
text_layer::text_layer(span<const int> o, span<const int> d, span<const int> m)
	: buffer(d[0] * d[1]), cursor(0, 0), offset(o[0], o[1]), dims(d[0], d[1]), margins(m[0], m[1], m[2], m[3]) {
	span(buffer).fill(0);
}

static constexpr void scroll_up(char* buf, int stride, int rect[4]) {
	for (int y = rect[2]; y < rect[3] - 1; y++) {
		for (int x = rect[0]; x < rect[1]; x++) {
			buf[y * stride + x] = buf[(y + 1) * stride + x];
			// if (!buf[y * stride + x]) buf[y * stride + x] = ' ';
		}
	}
	for (int x = rect[0]; x < rect[1]; x++)
		buf[(rect[3] - 1) * stride + x] = ' ';
}

text_layer& text_layer::fill(char c, int x1, int x2, int y1, int y2) {
	set_if_not_dest(x1, 0);
	set_if_not_dest(y1, 0);
	set_if_not_dest(x2, dims[0]);
	set_if_not_dest(y2, dims[1]);
	for (int y = y1; y < y2; y++) {
		for (int x = x1; x < x2; x++) {
			buffer[y * dims[0] + x] = c;
		}
	}
	return *this;
}
text_layer& text_layer::clear() {
	cursor[0] = margins[0];
	cursor[1] = margins[2];
	span(buffer).fill(0);
	return *this;
}

static void newline(text_layer& l, bool right) {
	l.cursor[0] = right ? l.margins[1] : l.margins[0];
	l.cursor[1]++;
	if (l.cursor[1] == l.margins[3] - 1) {
		scroll_up(l.buffer.begin(), l.dims[0], l.margins);
		l.cursor[1]--;
	}
}

static void append_char(text_layer& l, char c, bool never_wrap) {
	l.buffer[l.cursor[1] * l.dims[0] + l.cursor[0]] = c;
	l.cursor[0]++;
	if (l.cursor[0] == l.margins[1] && !never_wrap)
		newline(l, false);
}

text_layer& text_layer::putchar(char c, int x, int y) {
	set_if_src(cursor[0], x);
	set_if_src(cursor[1], y);
	append_char(*this, c, false);
	return *this;
}

text_layer& text_layer::print(const char* str, bool right_align, int x, int y) {
	return print(rostring(str), x, y, right_align);
}
text_layer& text_layer::print(view<const char*, const char*> str, bool right_align, int x, int y) {
	set_if_src(cursor[0], x);
	set_if_src(cursor[1], y);
	for (std::size_t i = 0; i < str.size() && str[i]; i++) {
		if (right_align)
			for (std::size_t j = i; j < str.size() && str[j] && str[j] != '\n'; j++, cursor[0]--)
				;
		for (; i < str.size() && str[i] && str[i] != '\n'; append_char(*this, str[i++], right_align))
			;
		if (i < str.size() && str[i] == '\n')
			newline(*this, right_align);
	}
	return *this;
}

text_layer& text_layer::display(console& c, bool clear) {
	for (int y = 0; y < dims[1]; y++) {
		if (y + offset[1] >= c.dims[1])
			break;
		for (int x = 0; x < dims[0]; x++) {
			if (x + offset[0] >= c.dims[0])
				break;
			if (buffer[y * dims[0] + x])
				c.set(x + offset[0], y + offset[1], buffer[y * dims[0] + x]);
			if (clear)
				buffer[y * dims[0] + x] = 0;
		}
	}
	return *this;
}
text_layer& text_layer::display(text_layer& l, bool clear) {
	for (int y = 0; y < dims[1]; y++) {
		if (y + offset[1] >= l.dims[1])
			break;
		for (int x = 0; x < dims[0]; x++) {
			if (x + offset[0] >= l.dims[0])
				break;
			if (buffer[y * dims[0] + x])
				l.buffer[(y + offset[1]) * l.dims[0] + x + offset[0]] = buffer[y * dims[0] + x];
			if (clear)
				buffer[y * dims[0] + x] = 0;
		}
	}
	return *this;
}

text_layer& text_layer::hexdump(const void* ptr, uint32_t bytes, uint32_t block_width, uint32_t num_columns,
								bool reversed) {
	const char* hextable = "0123456789ABCDEF";
	uint8_t* data = (uint8_t*)ptr;
	for (uint32_t off = 0; off < bytes; off += block_width) {
		int bl = reversed ? block_width - 1 : 0;
		while (reversed ? (bl >= 0) : (bl < (int)block_width)) {
			this->putchar(hextable[data[off + bl] >> 4]);
			this->putchar(hextable[data[off + bl] & 0xf]);
			if (reversed)
				bl--;
			else
				bl++;
		}
		if (off / block_width % num_columns == num_columns - 1)
			newline(*this, false);
		else
			this->putchar(' ');
	}
	if (bytes / block_width % num_columns)
		newline(*this, false);
	return *this;
}