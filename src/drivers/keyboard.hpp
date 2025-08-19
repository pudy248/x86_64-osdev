#pragma once
#include <cstdint>
#include <kstring.hpp>
#include <sys/idt.hpp>

struct KeyboardBuffer {
	bool shift;
	bool ctrl;
	bool alt;
	bool e0;

	uint8_t pushIdx;
	uint8_t popIdx;

	uint8_t loopqueue[256];
};
extern KeyboardBuffer keyboardInput;

void keyboard_irq(uint64_t, register_file*);
uint8_t update_modifiers(uint8_t key);
char key_to_ascii(uint8_t key);
int getchar();
string getline();