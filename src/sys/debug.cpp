#include <cstdint>
#include <drivers/keyboard.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/allocators/waterline.hpp>
#include <lib/fat.hpp>
#include <stl/array.hpp>
#include <stl/vector.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>

vector<debug_symbol> symbol_table;
static bool is_enabled = false;

void load_debug_symbs(const char* filename) {
	FILE f = file_open(filename);
	kassert(f.inode, "Failed to open file.");
	istringstream str(rostring(f.inode->data));

	symbol_table.reserve(f.inode->data.size() / 100);

	// llvm-objdump --syms
	str.read_c();
	str.read_until_v<rostring>('\n', true);
	str.read_c();
	str.read_until_v<rostring>('\n', true);

	while (str.readable()) {
		debug_symbol symb;
		symb.addr = (void*)str.read_x();
		char tmp2[16];
		str.bzread(tmp2, 9);
		str.read_until_v<rostring>('\t', true);
		symb.size = str.read_x();
		str.read_c();
		rostring tmp = str.read_until_v<rostring>('\n');
		char* name = (char*)walloc(tmp.size() + 1, 0x10);
		memcpy(name, tmp.begin(), tmp.size());
		name[tmp.size()] = 0;
		symb.name = name;
		str.read_c();

		symbol_table.append(symb);
		//qprintf<1024>("%08x %04x %10s\n", symb.addr, symb.size, symb.name);
	}

	//f.inode->close();
	is_enabled = true;
}

debug_symbol* nearest_symbol(void* address, bool* out_contains) {
	int bestIdx = 0;
	uint64_t bestDistance = INT64_MAX;
	for (int i = 0; i < symbol_table.size(); i++) {
		uint64_t distance = (uint64_t)address - (uint64_t)symbol_table[i].addr - 5;
		if (distance < bestDistance && distance >= 0) {
			bestIdx = i;
			bestDistance = distance;
			if ((uint64_t)address < (uint64_t)symbol_table[i].addr + symbol_table[i].size) {
				if (out_contains)
					*out_contains = false;
				return &symbol_table[bestIdx];
			}
		}
	}
	if (out_contains)
		*out_contains = false;
	return &symbol_table[bestIdx];
}

void wait_until_kbhit() {
	while (true) {
		if (*(volatile uint8_t*)&keyboardInput.pushIdx == keyboardInput.popIdx)
			continue;
		else if (key_to_ascii(keyboardInput.loopqueue[keyboardInput.popIdx]) != 'c') {
			keyboardInput.popIdx = keyboardInput.pushIdx;
			continue;
		} else
			break;
	}
	keyboardInput.popIdx = keyboardInput.pushIdx;
}

stacktrace::stacktrace()
	: num_ptrs(0) {
	uint64_t* rbp = (uint64_t*)__builtin_frame_address(0);
	while (num_ptrs < ptrs.size() && rbp[1]) {
		ptrs.at(num_ptrs++) = { (void*)rbp[1], (void*)rbp };
		rbp = (uint64_t*)*rbp;
	}
}

stacktrace::stacktrace(void*)
	: num_ptrs(0) {
}

stacktrace::stacktrace(const stacktrace& other, int start)
	: num_ptrs(other.num_ptrs - start) {
	ptrs.blit(other.ptrs.subspan(start, other.num_ptrs), 0);
}

void stacktrace::print() const {
	::print("\nIDX:  RETURN    STACKPTR  NAME\n");
	for (int i = 0; i < num_ptrs; i++) {
		qprintf<512>("% 3i:  %08x  %08x  %s\n", i, ptrs.at(i).ret, ptrs.at(i).rbp,
					 nearest_symbol(ptrs.at(i).ret)->name);
	}
	::print("\n");
}

void inline_stacktrace() {
	stacktrace(stacktrace(), 1).print();
}

void* __malloc(uint64_t size, uint16_t alignment);
void __free(void* ptr);
void* tagged_alloc(uint64_t size, uint16_t alignment) {
	void* ptr = __malloc(size, alignment);
	for (int i = 0; i < globals->heap_allocations.size(); i++) {
		if (globals->heap_allocations.at(i).ptr == ptr) {
			kassert(true, "Aliased malloc!");
		}
	}
	globals->heap_allocations.append((heap_tag){ ptr, size, stacktrace(stacktrace(), 1) });
	return ptr;
}
void tagged_free(void* ptr) {
	for (int i = 0; i < globals->heap_allocations.size(); i++) {
		if (globals->heap_allocations.at(i).ptr == ptr) {
			globals->heap_allocations.erase(i);
			__free(ptr);
			return;
		}
	}
	kassert(true, "Double free!");
}
void tag_dump() {
	for (const heap_tag& tag : globals->heap_allocations) {
		qprintf<64>("Allocation %p (%x bytes)\n", tag.ptr, tag.size);
		tag.alloc_trace.print();
		wait_until_kbhit();
	}
}