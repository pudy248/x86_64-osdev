#pragma once
#include <kstring.hpp>
#include <kcstring.h>
#include <sys/global.h>

#define print(str) globals->vga_console.putstr(str)
#define printf(fmt, ...) globals->vga_console.putstr(format(rostring(fmt, strlen(fmt)), __VA_ARGS__).c_str_this())
