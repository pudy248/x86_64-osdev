#pragma once
#include <cstdint>
#include <sys/idt.hpp>

typedef struct {
	uint8_t shift;
	uint8_t ctrl;
	uint8_t alt;
	uint8_t e0;

	uint8_t pushIdx;
	uint8_t popIdx;

	uint8_t loopqueue[256];
} KeyboardBuffer;
extern KeyboardBuffer keyboardInput;

void keyboard_irq(uint64_t, register_file*);
uint8_t update_modifiers(uint8_t key);
char key_to_ascii(uint8_t key);