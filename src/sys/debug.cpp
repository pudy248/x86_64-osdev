#include <asm.hpp>
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/allocators/waterline.hpp>
#include <lib/fat.hpp>
#include <stl/array.hpp>
#include <stl/vector.hpp>
#include <stl/view.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>
#include <sys/memory/paging.hpp>

vector<debug_symbol> symbol_table;
static bool is_enabled = false;

bool tags_enabled() { return globals->tag_allocs; }
void debug_init() {
	new (&globals->heap_allocations) vector<heap_tag, waterline_allocator>(
		1000, waterline_allocator(mmap(0, 0x100000, 0, 0), 0x100000));
	//globals->tag_allocs = true;
}

void load_debug_symbs(const char* filename) {
	bool old_tag = globals->tag_allocs;
	globals->tag_allocs = false;
	fat_file f = file_open(filename);
	kassert(DEBUG_ONLY, WARNING, f.inode, "Failed to open file.");
	if (!f.inode) return;

	auto v1 = f.rodata();
	auto v2 = v1.reinterpret_as<char>();

	istringstream str(v2);

	symbol_table.reserve(f.rodata().size() / 100);

	// llvm-objdump --syms
	str.read_c();
	str.read_until_v('\n', true);
	str.read_c();
	str.read_until_v('\n', true);

	while (str.end() - str.begin() > 1) {
		debug_symbol symb;
		symb.addr = (void*)str.read_x();
		array<char, 16> tmp2;
		view(tmp2).blit(str.read_n(9));
		str.read_until_v('\t', true);
		symb.size = str.read_x();
		str.read_c();
		rostring tmp = str.read_until_v('\n');
		char* name = (char*)walloc(tmp.size() + 1, 0x10);
		memcpy(name, tmp.begin(), tmp.size());
		name[tmp.size()] = 0;
		symb.name = name;
		str.read_c();

		symbol_table.append(symb);
		//qprintf<1024>("%08x %04x %10s\n", symb.addr, symb.size, symb.name);
	}
	globals->tag_allocs = old_tag;
	is_enabled = true;
}

debug_symbol* nearest_symbol(void* address, bool* out_contains) {
	int bestIdx = -1;
	uint64_t bestDistance = INT64_MAX;
	for (std::size_t i = 0; i < symbol_table.size(); i++) {
		uint64_t distance = (uint64_t)address - (uint64_t)symbol_table[i].addr - 5;
		if (distance < bestDistance && distance >= 0) {
			bestIdx = i;
			bestDistance = distance;
			if ((uint64_t)address < (uint64_t)symbol_table[i].addr + symbol_table[i].size) {
				if (out_contains) *out_contains = false;
				return &symbol_table[bestIdx];
			}
		}
	}
	if (out_contains) *out_contains = false;
	if (bestIdx == -1)
		return NULL;
	else
		return &symbol_table[bestIdx];
}

void wait_until_kbhit() {
	while (true) {
		while (!(inb(0x64) & 1)) cpu_relax();
		if (!(inb(0x60) & 0x80)) break;
	}
}

[[gnu::noinline]] stacktrace stacktrace::trace() {
	stacktrace r = {};
	uint64_t* rbp = (uint64_t*)__builtin_frame_address(0);
	while (r.num_ptrs < r.ptrs.size() && rbp[1] > 0x8000) {
		r.ptrs.at(r.num_ptrs++) = { (void*)rbp[1], (void*)rbp[0] };
		rbp = (uint64_t*)*rbp;
	}
	return r;
}

[[gnu::noinline]] stacktrace stacktrace::trace(uint64_t* rbp, uint64_t return_addr) {
	stacktrace r = {};
	r.ptrs.at(r.num_ptrs++) = { (void*)return_addr, (void*)rbp };
	while (r.num_ptrs < r.ptrs.size() && rbp[1] > 0x8000) {
		r.ptrs.at(r.num_ptrs++) = { (void*)rbp[1], (void*)rbp[0] };
		rbp = (uint64_t*)*rbp;
	}
	return r;
}

stacktrace::stacktrace(const stacktrace& other, int start)
	: num_ptrs(other.num_ptrs - start) {
	view(ptrs).blit(view(other.ptrs).subspan(start, other.num_ptrs), 0);
}

void stacktrace::print() const {
	::print("\nIDX:  RETURN    STACKPTR  NAME\n");
	for (int i = 0; i < num_ptrs; i++) {
		debug_symbol* nearest = nearest_symbol(ptrs.at(i).ret);
		qprintf<512>("%3i:  %08x  %08x  %s\n", i, ptrs.at(i).ret, ptrs.at(i).rbp,
					 nearest ? nearest->name : "(none)");
	}
	::print("\n");
}

void inline_stacktrace() { stacktrace(stacktrace::trace(), 1).print(); }

void* tag_alloc(uint64_t size, void* ptr) {
	for (std::size_t i = 0; i < globals->heap_allocations.size(); i++) {
		if (globals->heap_allocations.at(i).ptr == ptr) {
			print("Aliased malloc!");
			kassert_trace(ALWAYS_ACTIVE, ERROR);
		}
	}
	globals->heap_allocations.append((heap_tag){ ptr, size, stacktrace(stacktrace::trace(), 1) });
	return ptr;
}
void tag_free(void* ptr) {
	for (std::size_t i = 0; i < globals->heap_allocations.size(); i++) {
		if (globals->heap_allocations.at(i).ptr == ptr) {
			globals->heap_allocations.erase(i);
			return;
		}
	}
	//print("Double free!");
	//kassert_trace(DEBUG_ONLY, ERROR);
}
void tag_dump() {
	for (const heap_tag& tag : globals->heap_allocations) {
		qprintf<64>("Allocation %p (%i bytes)\n", tag.ptr, tag.size);
		tag.alloc_trace.print();
		wait_until_kbhit();
	}
}