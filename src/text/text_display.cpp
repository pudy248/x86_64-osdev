#include <kstring.hpp>
#include <stl/ranges.hpp>
#include <sys/global.hpp>
#include <text/console.hpp>
#include <text/text_display.hpp>

text_layer& default_output() {
	return *globals->g_stdout;
}

text_layer::text_layer(const console& c)
	: buffer(c.dims[0] * c.dims[1])
	, cursor(0, 0)
	, offset(0, 0)
	, dims(c.dims[0], c.dims[1])
	, margins(0, c.dims[0], 0, c.dims[1]) {
	ranges::fill(buffer, 0);
}

text_layer& text_layer::display() {
	return display(default_console(), false);
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