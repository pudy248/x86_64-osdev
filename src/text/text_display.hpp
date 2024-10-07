#pragma once
#include <cstdint>
#include <kcstring.hpp>
#include <kstdio.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/vector.hpp>
#include <stl/view.hpp>

class text_layer {
public:
	heap_array<char> buffer;
	int pos[2] = {};
	int dims[2] = {};
	int margins[4] = {};

	text_layer() = default;
	text_layer(const class console& c);
	text_layer(span<const int>, span<const int>, span<const int>);

	text_layer& clear();
	text_layer& fill(char c, int x1 = -1, int x2 = -1, int y1 = -1, int y2 = -1);

	text_layer& putchar(char c, int x = -1, int y = -1);
	text_layer& print(const char* str, bool right_align = false, int x = -1, int y = -1);
	text_layer& print(view<const char*, const char*> str, bool right_align = false, int x = -1, int y = -1);
	text_layer& hexdump(const void* ptr, uint32_t bytes, uint32_t block_width = 4, uint32_t num_columns = 8,
						bool reversed = false);

	text_layer& display(console& output = default_console(), bool clear = false);
	text_layer& display(text_layer& layer, bool clear = false);
};