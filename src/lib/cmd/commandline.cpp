#pragma once
#include <drivers/keyboard.hpp>
#include <kstring.hpp>
#include <lib/cmd/commandline.hpp>
#include <text/text_display.hpp>

text_layer command_input;

static vector<string> argvify(const rostring& line) {
	vector<string> v;
	istringstream s(line);
	while (s.readable()) {
		string arg = {};
		bool quoted = false;
		while (s.readable()) {
			char c = s.read_c();
			if ((c == ' ' && !quoted) || !c)
				break;
			if (c == '"') {
				quoted = !quoted;
				continue;
			}
			if (c == '#') {
				s.begin() = s.end();
				continue;
			}
			if (c == '\\') {
				c = s.read_c();
			}
			arg.push_back(c);
		}
		if (!arg.size() || !strlen(arg.begin()))
			continue;
		arg.push_back(0);
		v.push_back(arg);
	}
	return v;
}

[[noreturn]] void cli_init() {
	command_input = text_layer({ 0, default_output().dims[1] - 1 }, { default_output().dims[0], 1 },
							   { 0, default_output().dims[0], 0, 1 });
	default_output().dims[1]--;
	default_output().margins[3]--;
	command_input.fill(' ').print("> ", false, 0, 0).display();
	while (true) {
		string s = getline();
		printf("> %s\n", s.c_str());
		sh_exec(s.c_str());
	}
}

int sh_exec(const rostring& cmd) {
	vector<string> args = argvify(cmd);
	vector<ccstr_t> argv(args.size() + 1);
	for (string& s : args) {
		argv.emplace_back(s.c_str());
	}
	argv.emplace_back(nullptr);

	for (auto c : cmd_arr) {
		if (args[0] == c.name) {
			return c.command(args.size(), argv.cbegin());
		}
	}

	printf("Unknown command: %s\n", args[0].c_str());
	return -1;
}