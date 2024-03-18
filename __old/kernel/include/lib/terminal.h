#pragma once
#include <inttypes.hpp>
#include <lib/textbuffer.hpp>
#include <lib/fat.hpp>

void terminal_init();
void terminal_input_loop(void);
void terminal_exec(char* cmd);
