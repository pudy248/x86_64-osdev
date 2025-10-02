#pragma once
#include "commands.hpp"
#include <kcstring.hpp>
#include <kstring.hpp>
#include <stl/array.hpp>

using cmd_fn = int (*)(int argc, const ccstr_t* argv);

struct command {
	const char* name;
	cmd_fn command;
};

#define cmd(name) \
	command { #name, cmd_##name }
constexpr auto cmd_arr = array(cmd(help), cmd(echo), cmd(exec), cmd(cd), cmd(ls), cmd(tree), cmd(cat), cmd(mkdir),
	command{"add", cmd_touch}, cmd(rm), cmd(mv), cmd(save_output), cmd(triple_fault), cmd(hexdump), cmd(memset),
	cmd(readx), cmd(writex), cmd(readpio), cmd(writepio), cmd(memmap), cmd(stacktrace), cmd(dump_allocs), cmd(lspci),
	cmd(http_fetch), cmd(ihd_gfx_init), cmd(ihd_gfx_modeset), cmd(gmbus_read), cmd(sbi_read), cmd(sbi_write));

void cli_init();
[[noreturn]] void cli_loop();
int sh_exec(const rostring& s);