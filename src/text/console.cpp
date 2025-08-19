#include <cstdint>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <sys/global.hpp>
#include <text/console.hpp>

console& default_console() { return *globals->g_console; }

console::console(void (*s)(uint32_t, uint32_t, char), void (*r)(), const int d[2])
	: dims(d[0], d[1]), _set_char(s), refresh(r), backing_data((char*)kcalloc(d[0] * d[1])) {}

console& console::operator=(console&& c2) {
	this->~console();
	new (this) console(std::forward<console>(c2));
	return *this;
}
console::console(console&& c2)
	: dims(c2.dims[0], c2.dims[1]), _set_char(c2._set_char), refresh(c2.refresh), backing_data(c2.backing_data) {
	c2.backing_data = 0;
}
console::~console() { kfree(backing_data); }
void console::set(uint32_t x, uint32_t y, char c) {
	if (backing_data[y * dims[0] + x] != c) {
		backing_data[y * dims[0] + x] = c;
		_set_char(x, y, c);
	}
}
