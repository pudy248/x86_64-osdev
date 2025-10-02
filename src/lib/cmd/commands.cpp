#include "commands.hpp"
#include "commandline.hpp"
#include <drivers/pci.hpp>
#include <kfile.hpp>
#include <kstdio.hpp>
#include <stl/ranges.hpp>
#include <sys/fixed_global.hpp>
#include <sys/global.hpp>
#include <sys/ktime.hpp>
#include <sys/memory/paging.hpp>

static bool print_file_error(fs::ACCESS_RESULT a) {
	switch (a) {
	case fs::ACCESS_RESULT::SUCCESS: return false;
	case fs::ACCESS_RESULT::ERR_NOT_FOUND: print("File not found.\n"); return true;
	case fs::ACCESS_RESULT::ERR_TYPE_FILE: print("Not a directory.\n"); return true;
	case fs::ACCESS_RESULT::ERR_TYPE_DIRECTORY: print("Not a file.\n"); return true;
	case fs::ACCESS_RESULT::ERR_PATH_NOT_FOUND: print("Invalid path.\n"); return true;
	case fs::ACCESS_RESULT::ERR_PATH_TYPE: print("Invalid path.\n"); return true;
	case fs::ACCESS_RESULT::ERR_EXISTS: print("File already exists.\n"); return true;
	case fs::ACCESS_RESULT::ERR_READONLY: print("File is read-only.\n"); return true;
	case fs::ACCESS_RESULT::ERR_FLAGS: print("Invalid flags.\n"); return true;
	case fs::ACCESS_RESULT::ERR_IN_USE: print("File is in use.\n"); return true;
	case fs::ACCESS_RESULT::ERR_NOT_EMPTY: print("Directory is not empty.\n"); return true;
	}
}

#define try_access(p, f)                        \
	do {                                        \
		fs::ACCESS_RESULT a = fs::access(p, f); \
		if (print_file_error(a))                \
			return -1;                          \
	} while (0)

int cmd_help(int, const ccstr_t*) {
	for (auto c : cmd_arr)
		printf("%s\n", c.name);
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
		try_access(argv[i], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::FILE);
		file_t f = fs::unsafe::open(argv[i], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::FILE);
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
		try_access(argv[1], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::DIRECTORY);
		dir = fs::unsafe::open(argv[1], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::DIRECTORY);
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
	try_access(argv[1], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::FILE);
	file_t f = fs::unsafe::open(argv[1], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::FILE);
	print(f.rodata());
	return 0;
}

int cmd_cd(int argc, const ccstr_t* argv) {
	if (argc != 2) {
		print("Bad argument count.\n");
		return -1;
	}
	try_access(argv[1], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::DIRECTORY);
	globals->fs->current = fs::unsafe::open(argv[1], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::DIRECTORY);
	return 0;
}
int cmd_mkdir(int argc, const ccstr_t* argv) {
	if (argc < 2) {
		print("No arguments.\n");
		return -1;
	}
	for (int i = 1; i < argc; i++) {
		try_access(argv[i], fs::ACCESS_FLAGS::WRITE | fs::ACCESS_FLAGS::DIRECTORY | fs::ACCESS_FLAGS::CREATE);
		file_t _ =
			fs::unsafe::open(argv[i], fs::ACCESS_FLAGS::WRITE | fs::ACCESS_FLAGS::DIRECTORY | fs::ACCESS_FLAGS::CREATE);
	}
	return 0;
}
int cmd_touch(int argc, const ccstr_t* argv) {
	if (argc < 2) {
		print("No arguments.\n");
		return -1;
	}
	for (int i = 1; i < argc; i++) {
		try_access(argv[i], fs::ACCESS_FLAGS::WRITE | fs::ACCESS_FLAGS::CREATE);
		file_t _ = fs::unsafe::open(argv[i], fs::ACCESS_FLAGS::WRITE | fs::ACCESS_FLAGS::CREATE);
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
		if (print_file_error(fs::remove(argv[1], 0)))
			return -1;
	}
	return 0;
}
int cmd_mv(int argc, const ccstr_t* argv) {
	if (argc != 3) {
		print("Bad argument count.\n");
		return -1;
	}
	if (print_file_error(fs::move(argv[1], argv[2])))
		return -1;
	return 0;
}

int cmd_save_output(int argc, const ccstr_t* argv) {
	if (argc != 2) {
		print("Bad argument count.\n");
		return -1;
	}
	try_access(argv[1], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::FILE | fs::ACCESS_FLAGS::CREATE_IF_MISSING);
	file_t f = fs::unsafe::open(
		argv[1], fs::ACCESS_FLAGS::READ | fs::ACCESS_FLAGS::FILE | fs::ACCESS_FLAGS::CREATE_IF_MISSING);
	f.data() = output_log();
	while (1) {
		std::ptrdiff_t off = ranges::where_is(f.rodata(), '\0');
		if (off == -1)
			break;
		f.data().erase(off);
	}
	f.n->write();
	return 0;
}

int cmd_triple_fault(int, const ccstr_t*) {
	kbzero(fixed_globals->idt, 256 * 8);
	return 0;
}

int cmd_hexdump(int argc, const ccstr_t* argv) {
	if (argc != 3) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t addr = istringstream(argv[1]).read_x();
	uint64_t len = istringstream(argv[2]).read_x();
	hexdump((void*)addr, len);
	return 0;
}
int cmd_memset(int argc, const ccstr_t* argv) {
	if (argc != 4) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t addr = istringstream(argv[1]).read_x();
	uint64_t byte = istringstream(argv[2]).read_x();
	uint64_t len = istringstream(argv[3]).read_x();
	kmemset((void*)addr, byte, len);
	return 0;
}
int cmd_readx(int argc, const ccstr_t* argv) {
	if (argc != 3) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t addr = istringstream(argv[1]).read_x();
	uint64_t len = istringstream(argv[2]).read_x();
	switch (len) {
	case 1: printf("%02x\n", *(uint8_t*)addr); break;
	case 2: printf("%04x\n", *(uint16_t*)addr); break;
	case 4: printf("%08x\n", *(uint32_t*)addr); break;
	case 8: printf("%016x\n", *(uint64_t*)addr); break;
	default: print("Bad length.\n"); return -1;
	}
	return 0;
}
int cmd_writex(int argc, const ccstr_t* argv) {
	if (argc != 4) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t addr = istringstream(argv[1]).read_x();
	uint64_t data = istringstream(argv[2]).read_x();
	uint64_t len = istringstream(argv[3]).read_x();
	switch (len) {
	case 1: *(uint8_t*)addr = data; break;
	case 2: *(uint16_t*)addr = data; break;
	case 4: *(uint32_t*)addr = data; break;
	case 8: *(uint64_t*)addr = data; break;
	default: print("Bad length.\n"); return -1;
	}
	return 0;
}
int cmd_readpio(int argc, const ccstr_t* argv) {
	if (argc != 3) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t addr = istringstream(argv[1]).read_x();
	uint64_t len = istringstream(argv[2]).read_x();
	switch (len) {
	case 1: printf("%02x\n", inb(addr)); break;
	case 2: printf("%04x\n", inw(addr)); break;
	case 4: printf("%08x\n", inl(addr)); break;
	default: print("Bad length.\n"); return -1;
	}
	return 0;
}
int cmd_writepio(int argc, const ccstr_t* argv) {
	if (argc != 4) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t addr = istringstream(argv[1]).read_x();
	uint64_t data = istringstream(argv[2]).read_x();
	uint64_t len = istringstream(argv[3]).read_x();
	switch (len) {
	case 1: outb(addr, data); break;
	case 2: outw(addr, data); break;
	case 4: outl(addr, data); break;
	default: print("Bad length.\n"); return -1;
	}
	return 0;
}

int cmd_memmap(int argc, const ccstr_t* argv) {
	if (argc != 4) {
		print("Bad argument count.\n");
		return -1;
	}
	uint64_t addr = istringstream(argv[1]).read_x();
	uint64_t size = istringstream(argv[2]).read_x();
	uint64_t map = istringstream(argv[3]).read_x();
	printf("%p\n", mmap(addr, size, map)());
	return 0;
}

int cmd_stacktrace(int, const ccstr_t*) {
	stacktrace::trace().print();
	return 0;
}
int cmd_dump_allocs(int, const ccstr_t*) {
	tag_dump();
	return 0;
}

int cmd_lspci(int, const ccstr_t*) {
	file_t f1 = fs::open("/pci1.ids");
	file_t f2 = fs::open("/pci2.ids");

	for (int i = 0; i < globals->pci->numDevs; i++) {
		pci_device& d = globals->pci->devices[i];
		pci_id ids = pci_lookup(f1.rodata(), f2.rodata(), d);

		printf("(%i:%i:%i) %04x  %S\n", d.address.bus, d.address.slot, d.address.func, d.vendor_id, &ids.vendor);
		printf("  device:%04x   %S\n", d.device_id, &ids.device);
		printf("  %02x:%02x:%02x:%02x   ", d.class_id, d.subclass, d.prog_if, d.rev_id);
		if (ids.prog_if.size())
			printf("%S (%S)\n", &ids.subclass, &ids.prog_if);
		else if (ids.subclass.size())
			printf("%S\n", &ids.subclass);
		else
			printf("%S\n", &ids.class_id);
		printf("  BAR %08x %08x %08x\n", d.bars[0], d.bars[1], d.bars[2]);
		printf("  BAR %08x %08x %08x\n", d.bars[3], d.bars[4], d.bars[5]);
	}
	return 0;
}