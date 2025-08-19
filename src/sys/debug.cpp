#include <asm.hpp>
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kcstring.hpp>
#include <kfile.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/array.hpp>
#include <stl/ranges.hpp>
#include <stl/vector.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>
#include <sys/memory/paging.hpp>

constinit vector<debug_symbol> symbol_table;
static bool is_enabled = false;

bool tags_enabled() { return globals->tag_allocs; }
void debug_init() {
	new (&globals->heap_allocations) vector<heap_tag, waterline_allocator<heap_tag>>(
		1000, waterline_allocator<heap_tag>(mmap(nullptr, 0x100000, 0), 0x100000));
	//globals->tag_allocs = true;
}

void* __walloc(uint64_t size, uint16_t alignment);

void load_debug_symbs(ccstr_t filename) {
	file_t f = fs::open(filename);
	kassert(DEBUG_ONLY, WARNING, f, "Failed to open file.");
	if (!f)
		return;
	istringstream str(f.rodata());

	vector<debug_symbol> symbs2;

	// llvm-objdump --syms
	str.read_c();
	ranges::mut::iterate_through(str, algo::equal_to_v{'\n'});
	str.read_c();
	ranges::mut::iterate_through(str, algo::equal_to_v{'\n'});

	while (str.end() - str.begin() > 1) {
		debug_symbol symb;
		symb.addr = pointer<void, integer>(str.read_x());
		array<char, 10> tmp2;
		str.read(tmp2.begin(), 9);
		ranges::mut::iterate_through(str, algo::equal_to_v{'\t'});
		symb.size = str.read_x();
		str.read_c();
		rostring tmp = {str.begin(), ranges::find(str, '\n')};
		pointer<char, type_cast> name = __walloc(tmp.size() + 1, 0x10);
		memcpy(name, tmp.begin(), tmp.size());
		name[tmp.size()] = 0;
		symb.name = name;
		str.begin() = tmp.end();
		str.read_c();

		symbol_table.push_back(symb);
		symbs2.push_back(symb);
	}
	is_enabled = true;
}

pointer<debug_symbol> nearest_symbol(pointer<void, integer> address, pointer<bool> out_contains) {
	int bestIdx = -1;
	uint64_t bestDistance = INT64_MAX;
	for (std::size_t i = 0; i < symbol_table.size(); i++) {
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
	if (bestIdx == -1)
		return NULL;
	else
		return &symbol_table[bestIdx];
}

void wait_until_kbhit() {
	while (true) {
		while (!(inb(0x64) & 1))
			cpu_relax();
		if (!(inb(0x60) & 0x80))
			break;
	}
}

[[gnu::noinline]] stacktrace stacktrace::trace() {
	stacktrace r = {};
	pointer<uint64_t, reinterpret> rbp = __builtin_frame_address(0);
	while (r.num_ptrs < r.ptrs.size() && rbp[1] > 0x8000) {
		r.ptrs.at(r.num_ptrs++) = {pointer<void, reinterpret>(rbp[1]), pointer<void, reinterpret>(rbp[0])};
		rbp = pointer<uint64_t, reinterpret>(*rbp);
	}
	return r;
}

[[gnu::noinline]] stacktrace stacktrace::trace(pointer<uint64_t, integer> rbp, uint64_t return_addr) {
	stacktrace r = {};
	r.ptrs.at(r.num_ptrs++) = {pointer<void, reinterpret>(return_addr), pointer<void, reinterpret>(rbp)};
	while (r.num_ptrs < r.ptrs.size() && rbp[1] > 0x8000) {
		r.ptrs.at(r.num_ptrs++) = {pointer<void, reinterpret>(rbp[1]), pointer<void, reinterpret>(rbp[0])};
		rbp = pointer<uint64_t, reinterpret>(*rbp);
	}
	return r;
}

stacktrace::stacktrace(const stacktrace& other, int start) : num_ptrs(other.num_ptrs - start) {
	ranges::copy(ranges::subrange(other.ptrs, start, other.num_ptrs), ptrs);
}

void stacktrace::print() const {
	::print("\nIDX:  RETURN    STACKPTR  NAME\n");
	for (uint32_t i = 0; i < num_ptrs; i++) {
		pointer<debug_symbol> nearest = nearest_symbol(ptrs.at(i).ret);
		printf("%3i:  %08x  %08x  %s\n", i, ptrs.at(i).ret(), ptrs.at(i).rbp(), nearest ? nearest->name : "(none)");
	}
	::print("\n");
}
void stacktrace::eprint() const {
	::print("\nIDX:  RETURN    STACKPTR  NAME\n");
	for (uint32_t i = 0; i < num_ptrs; i++) {
		pointer<debug_symbol> nearest = nearest_symbol(ptrs.at(i).ret);
		errorf<512>(
			"%3i:  %08x  %08x  %s\n", i, ptrs.at(i).ret(), ptrs.at(i).rbp(), nearest ? nearest->name : "(none)");
	}
	::print("\n");
}

void inline_stacktrace() { stacktrace(stacktrace::trace(), 1).print(); }

pointer<void> tag_alloc(uint64_t size, pointer<void> ptr) {
	for (std::size_t i = 0; i < globals->heap_allocations.size(); i++) {
		if (globals->heap_allocations.at(i).ptr == ptr) {
			print("Aliased malloc!");
			kassert_trace(ALWAYS_ACTIVE, ERROR);
		}
	}
	globals->heap_allocations.push_back((heap_tag){ptr, size, stacktrace(stacktrace::trace(), 1)});
	return ptr;
}
void tag_free(pointer<void> ptr) {
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
		printf("Allocation %p (%i bytes)\n", tag.ptr(), tag.size);
		tag.alloc_trace.print();
		wait_until_kbhit();
		//delay(units::seconds{ 3. });
	}
}