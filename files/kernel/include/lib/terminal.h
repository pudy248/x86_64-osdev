#pragma once
#include <inttypes.h>
#include <lib/textbuffer.h>
#include <lib/fat.h>

void terminal_init(fat_file rootDir);
void terminal_input_loop(void);
void terminal_exec(char* cmd);
