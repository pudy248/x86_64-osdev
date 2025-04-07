#pragma once
#include <cstdint>
#include <text/text_display.hpp>

class console {
public:
	int dims[2];

private:
	void (*_set_char)(uint32_t, uint32_t, char);

public:
	void (*refresh)();
	char* backing_data;
	console(void (*)(uint32_t, uint32_t, char), void (*)(), int[2]);
	console(console&& new_console);
	console& operator=(console&& new_console);
	~console();

	void set(uint32_t x, uint32_t y, char c);
};
