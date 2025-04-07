#pragma once
#include <cstdint>
#include <initializer_list>
#include <kcstring.hpp>
#include <kstdio.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/ranges.hpp>
#include <stl/vector.hpp>

class text_layer {
	template <typename T>
	constexpr static void set_if_src(T& dest, T src, T inval = (T)-1) {
		if (src != inval)
			dest = src;
	}
	template <typename T>
	constexpr static void set_if_not_dest(T& dest, T src, T inval = (T)-1) {
		if (dest == inval)
			dest = src;
	}

	constexpr static void scroll_up(char* buf, int stride, int rect[4]) {
		for (int y = rect[2]; y < rect[3] - 1; y++) {
			for (int x = rect[0]; x < rect[1]; x++) {
				buf[y * stride + x] = buf[(y + 1) * stride + x];
				// if (!buf[y * stride + x]) buf[y * stride + x] = ' ';
			}
		}
		for (int x = rect[0]; x < rect[1]; x++)
			buf[(rect[3] - 1) * stride + x] = ' ';
	}
	constexpr static void append_char(text_layer& l, char c, bool never_wrap) {
		l.buffer[l.cursor[1] * l.dims[0] + l.cursor[0]] = c;
		l.cursor[0]++;
		if (l.cursor[0] == l.margins[1] && !never_wrap)
			l.newline(false);
	}

public:
	heap_array<char> buffer;
	int cursor[2] = {};
	int offset[2] = {};
	int dims[2] = {};
	int margins[4] = {}; // xxyy, in this-space

	constexpr text_layer() = default;
	text_layer(const class console& c);
	template <ranges::range R1, ranges::range R2, ranges::range R3>
	constexpr text_layer(const R1& offset, const R2& dims, const R3& margins)
		: buffer(ranges::at(dims, 0) * ranges::at(dims, 1))
		, cursor(0, 0)
		, offset(ranges::at(offset, 0), ranges::at(offset, 1))
		, dims(ranges::at(dims, 0), ranges::at(dims, 1))
		, margins(ranges::at(margins, 0), ranges::at(margins, 1), ranges::at(margins, 2), ranges::at(margins, 3)) {
		ranges::fill(buffer, 0);
	}
	constexpr text_layer(std::initializer_list<int> offset, std::initializer_list<int> dims,
						 std::initializer_list<int> margins)
		: text_layer(span<const int>(offset), dims, margins) {};

	constexpr text_layer& clear() {
		cursor[0] = margins[0];
		cursor[1] = margins[2];
		ranges::fill(buffer, 0);
		return *this;
	}
	constexpr text_layer& fill(char c, int x1 = -1, int x2 = -1, int y1 = -1, int y2 = -1) {
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
	constexpr text_layer& fill_zeroes(char c, int x1 = -1, int x2 = -1, int y1 = -1, int y2 = -1) {
		set_if_not_dest(x1, 0);
		set_if_not_dest(y1, 0);
		set_if_not_dest(x2, dims[0]);
		set_if_not_dest(y2, dims[1]);
		for (int y = y1; y < y2; y++) {
			for (int x = x1; x < x2; x++) {
				if (!buffer[y * dims[0] + x])
					buffer[y * dims[0] + x] = c;
			}
		}
		return *this;
	}

	constexpr text_layer& newline(bool right) {
		cursor[0] = right ? margins[1] : margins[0];
		cursor[1]++;
		if (cursor[1] == margins[3] - 1) {
			scroll_up(ranges::begin(buffer), dims[0], margins);
			cursor[1]--;
		}
		return *this;
	}
	constexpr text_layer& putchar(char c, int x = -1, int y = -1) {
		set_if_src(cursor[0], x);
		set_if_src(cursor[1], y);
		append_char(*this, c, false);
		return *this;
	}
	//text_layer& print(const char* str, bool right_align = false, int x = -1, int y = -1);
	template <ranges::range R>
	constexpr text_layer& print(const R& str, bool right_align = false, int x = -1, int y = -1) {
		set_if_src(cursor[0], x);
		set_if_src(cursor[1], y);
		for (std::size_t i = 0; i < ranges::size(str) && str[i]; i++) {
			if (right_align)
				for (std::size_t j = i; j < ranges::size(str) && str[j] && str[j] != '\n'; j++, cursor[0]--)
					;
			for (; i < ranges::size(str) && str[i] && str[i] != '\n'; append_char(*this, str[i++], right_align))
				;
			if (i < ranges::size(str) && str[i] == '\n')
				newline(right_align);
		}
		return *this;
	}
	constexpr text_layer& hexdump(const void* ptr, uint32_t bytes, uint32_t block_width = 4, uint32_t num_columns = 8,
								  bool reversed = false) {
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
				newline(false);
			else
				this->putchar(' ');
		}
		if (bytes / block_width % num_columns)
			newline(false);
		return *this;
	}

	text_layer& display();
	text_layer& display(console& output, bool clear = false);
	constexpr text_layer& display(text_layer& layer, bool clear = false) {
		for (int y = 0; y < dims[1]; y++) {
			if (y + offset[1] >= layer.dims[1])
				break;
			for (int x = 0; x < dims[0]; x++) {
				if (x + offset[0] >= layer.dims[0])
					break;
				if (buffer[y * dims[0] + x])
					layer.buffer[(y + offset[1]) * layer.dims[0] + x + offset[0]] = buffer[y * dims[0] + x];
				if (clear)
					buffer[y * dims[0] + x] = 0;
			}
		}
		return *this;
	}
	constexpr text_layer& copy(text_layer& layer) {
		memcpy(ranges::begin(buffer), ranges::begin(layer.buffer), ranges::size(layer.buffer));
		memcpy(cursor, layer.cursor, sizeof(int) * 4); // cursor *and* offset
		return *this;
	}
};