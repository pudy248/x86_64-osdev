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
							   command{ "add", cmd_touch }, cmd(rm), cmd(mv), cmd(save_output));

void cli_init();
int sh_exec(const rostring& s);