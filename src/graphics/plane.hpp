#pragma once
#include "mem.hpp"
#include <cstdint>

namespace gfx {
struct rect {
	uint32_t left;
	uint32_t top;
	uint32_t width;
	uint32_t height;
};

struct buffer {
	uint32_ptr_a64 pixels;
	uint32_t width;
	uint32_t height;
	uint32_t stride_div64;
};

struct plane {
	uint32_ptr_a64 pixels;
	rect r;
	uint32_t depth;
};
}