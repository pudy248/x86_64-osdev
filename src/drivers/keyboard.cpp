#include <cstdint>
#include <drivers/keyboard.hpp>
#include <kstdlib.hpp>

struct register_file;

KeyboardBuffer keyboardInput = { 0, 0, 0, 0, 0, 0, {} };

struct {
	int start;
	int length;
	const char* lowercase;
	const char* uppercase;
} spans[] = {
	{ 0x2, 0xC, "1234567890-=", "!@#$%^&*()_+" },
	{ 0x10, 0xD, "qwertyuiop[]", "QWERTYUIOP{}" },
	{ 0x1E, 0xC, "asdfghjkl;'`", "ASDFGHJKL:\"~" },
	{ 0X2B, 0xB, "\\zxcvbnm,./", "|ZXCVBNM<>?" },
	{ 0x39, 0x1, " ", " " },
};

[[gnu::force_align_arg_pointer]] void keyboard_irq(uint64_t, register_file*) {
	uint8_t status = inb(0x64);
	if ((status & 1) == 0)
		return;
	uint8_t key = inb(0x60);
	keyboardInput.loopqueue[keyboardInput.pushIdx] = key;
	keyboardInput.pushIdx = (keyboardInput.pushIdx + 1) % 256;
}

uint8_t update_modifiers(uint8_t key) {
	if (key == 0xE0) {
		keyboardInput.e0 = 1;
		return 1;
	}
	if (keyboardInput.e0) {
		keyboardInput.e0 = 0;
		if (key == 0x2a)
			return 1;
	}

	uint8_t release = (key & 0x80) >> 7;
	uint8_t code = key & 0x7f;
	switch (code) {
	case 0x2a:
		keyboardInput.shift = !release;
		break;
	case 0x1d:
		keyboardInput.ctrl = !release;
		break;
	case 0x38:
		keyboardInput.alt = !release;
		break;
	default:
		return 0;
	}
	return 1;
}

char key_to_ascii(uint8_t key) {
	for (int i = 0; i < 5; i++) {
		if (key >= spans[i].start && key < spans[i].start + spans[i].length) {
			if (keyboardInput.shift)
				return spans[i].uppercase[key - spans[i].start];
			else
				return spans[i].lowercase[key - spans[i].start];
		}
	}
	return 0;
}