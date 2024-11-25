#include "commands.hpp"
#include "commandline.hpp"
#include <kfile.hpp>
#include <kstdio.hpp>
#include <sys/global.hpp>

static bool print_file_error(ACCESS_RESULT a) {
	switch (a) {
	case ACCESS_RESULT::SUCCESS: return false;
	case ACCESS_RESULT::ERR_NOT_FOUND: print("File not found.\n"); return true;
	case ACCESS_RESULT::ERR_TYPE_FILE: print("Not a directory.\n"); return true;
	case ACCESS_RESULT::ERR_TYPE_DIRECTORY: print("Not a file.\n"); return true;
	case ACCESS_RESULT::ERR_PATH_NOT_FOUND: print("Invalid path.\n"); return true;
	case ACCESS_RESULT::ERR_PATH_TYPE: print("Invalid path.\n"); return true;
	case ACCESS_RESULT::ERR_EXISTS: print("File already exists.\n"); return true;
	case ACCESS_RESULT::ERR_READONLY: print("File is read-only.\n"); return true;
	case ACCESS_RESULT::ERR_FLAGS: print("Invalid flags.\n"); return true;
	case ACCESS_RESULT::ERR_IN_USE: print("File is in use.\n"); return true;
	case ACCESS_RESULT::ERR_NOT_EMPTY: print("Directory is not empty.\n"); return true;
	}
}

#define try_access(p, f)                     \
	do {                                     \
		ACCESS_RESULT a = file_access(p, f); \
		if (print_file_error(a))             \
			return -1;                       \
	} while (0)

int cmd_help(int, const ccstr_t*) {
	for (auto c : cmd_arr) {
		printf("%s\n", c.name);
	}
	return 0;
}
int cmd_echo(int argc, const ccstr_t* argv) {
	for (int i = 1; i < argc; i++)
		printf("%s ", argv[i]);
	print("\n");
	return 0;
}
int cmd_exec(int argc, const ccstr_t* argv) {
	for (int i = 1; i < argc; i++) {
		try_access(argv[i], ACCESS_FLAGS::READ | ACCESS_FLAGS::FILE);
		file_t f = file_open(argv[i], ACCESS_FLAGS::READ | ACCESS_FLAGS::FILE);
		if (!f)
			continue;
		for (rostring& s : rostring(f.rodata()).split('\n')) {
			printf("sh> %S\n", &s);
			sh_exec(s);
		}
	}
	return 0;
}

int cmd_ls(int argc, const ccstr_t* argv) {
	file_t dir = globals->fs->current;
	if (argc > 1) {
		try_access(argv[1], ACCESS_FLAGS::READ | ACCESS_FLAGS::DIRECTORY);
		dir = file_open(argv[1], ACCESS_FLAGS::READ | ACCESS_FLAGS::DIRECTORY);
	}

	for (file_t f : dir.children()) {
		if (f.n->is_hidden)
			continue;
		rostring s = rostring(f.n->filename);
		printf("%S ", &s);
	}
	print("\n");
	return 0;
}

static void impl_tree(const file_t& f, int depth) {
	for (int i = 0; i < depth; i++)
		print("  ");
	rostring s = rostring(f.n->filename);
	printf("%S%s\n", &s, f.n->is_directory ? "/" : "");
	for (const file_t& c : f.children()) {
		if (c.n->is_hidden)
			continue;
		impl_tree(c, depth + 1);
	}
}
int cmd_tree(int, const ccstr_t*) {
	impl_tree(globals->fs->current, 0);
	return 0;
}

int cmd_cat(int argc, const ccstr_t* argv) {
	if (argc != 2) {
		print("Bad argument count.\n");
		return -1;
	}
	try_access(argv[1], ACCESS_FLAGS::READ | ACCESS_FLAGS::FILE);
	file_t f = file_open(argv[1], ACCESS_FLAGS::READ | ACCESS_FLAGS::FILE);
	print(f.rodata());
	return 0;
}

int cmd_cd(int argc, const ccstr_t* argv) {
	if (argc != 2) {
		print("Bad argument count.\n");
		return -1;
	}
	try_access(argv[1], ACCESS_FLAGS::READ | ACCESS_FLAGS::DIRECTORY);
	globals->fs->current = file_open(argv[1], ACCESS_FLAGS::READ | ACCESS_FLAGS::DIRECTORY);
	return 0;
}
int cmd_mkdir(int argc, const ccstr_t* argv) {
	if (argc < 2) {
		print("No arguments.\n");
		return -1;
	}
	for (int i = 1; i < argc; i++) {
		try_access(argv[i], ACCESS_FLAGS::WRITE | ACCESS_FLAGS::DIRECTORY | ACCESS_FLAGS::CREATE);
		file_t _ = file_open(argv[i], ACCESS_FLAGS::WRITE | ACCESS_FLAGS::DIRECTORY | ACCESS_FLAGS::CREATE);
	}
	return 0;
}
int cmd_touch(int argc, const ccstr_t* argv) {
	if (argc < 2) {
		print("No arguments.\n");
		return -1;
	}
	for (int i = 1; i < argc; i++) {
		try_access(argv[i], ACCESS_FLAGS::WRITE | ACCESS_FLAGS::CREATE);
		file_t _ = file_open(argv[i], ACCESS_FLAGS::WRITE | ACCESS_FLAGS::CREATE);
	}
	return 0;
}
int cmd_rm(int argc, const ccstr_t* argv) {
	if (argc < 2) {
		print("Bad argument count.\n");
		return -1;
	}

	for (int i = 1; i < argc; i++) {
		try_access(argv[i], 0);
		if (print_file_error(file_delete(argv[1], 0)))
			return -1;
	}
	return 0;
}
int cmd_mv(int argc, const ccstr_t* argv) {
	if (argc != 3) {
		print("Bad argument count.\n");
		return -1;
	}
	if (print_file_error(file_move(argv[1], argv[2])))
		return -1;
	return 0;
}

int cmd_save_output(int argc, const ccstr_t* argv) {
	if (argc != 2) {
		print("Bad argument count.\n");
		return -1;
	}
	try_access(argv[1], ACCESS_FLAGS::READ | ACCESS_FLAGS::FILE | ACCESS_FLAGS::CREATE_IF_MISSING);
	file_t f = file_open(argv[1], ACCESS_FLAGS::READ | ACCESS_FLAGS::FILE | ACCESS_FLAGS::CREATE_IF_MISSING);
	f.data() = output_log();
	while (1) {
		idx_t off = f.rodata().find('\0');
		if (off == -1)
			break;
		f.data().erase(off);
	}
	f.n->write();
	return 0;
}