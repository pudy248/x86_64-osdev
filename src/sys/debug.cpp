#include <asm.hpp>
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <kcstring.hpp>
#include <kfile.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/array.hpp>
#include <stl/vector.hpp>
#include <stl/view.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>
#include <sys/memory/paging.hpp>

vector<debug_symbol, mmap_allocator> symbol_table;
static bool is_enabled = false;

bool tags_enabled() { return globals->tag_allocs; }
void debug_init() {
	new (&globals->heap_allocations)
		vector<heap_tag, waterline_allocator>(1000, waterline_allocator(mmap(nullptr, 0x100000, 0, 0), 0x100000));
	//globals->tag_allocs = true;
}

void* __walloc(uint64_t size, uint16_t alignment);

void load_debug_symbs(ccstr_t filename) {
	file_t f = file_open(filename);
	kassert(DEBUG_ONLY, WARNING, f, "Failed to open file.");
	if (!f)
		return;

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
		symb.addr = str.read_x();
		array<char, 16> tmp2;
		view(tmp2).blit(str.read_n(9));
		str.read_until_v('\t', true);
		symb.size = str.read_x();
		str.read_c();
		rostring tmp = str.read_until_v('\n');
		pointer<char, type_cast> name = __walloc(tmp.size() + 1, 0x10);
		memcpy(name, tmp.begin(), tmp.size());
		name[tmp.size()] = 0;
		symb.name = name;
		str.read_c();

		symbol_table.append(symb);
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
		r.ptrs.at(r.num_ptrs++) = { rbp[1], rbp[0] };
		rbp = *rbp;
	}
	return r;
}

[[gnu::noinline]] stacktrace stacktrace::trace(pointer<uint64_t, integer> rbp, uint64_t return_addr) {
	stacktrace r = {};
	r.ptrs.at(r.num_ptrs++) = { return_addr, rbp };
	while (r.num_ptrs < r.ptrs.size() && rbp[1] > 0x8000) {
		r.ptrs.at(r.num_ptrs++) = { rbp[1], rbp[0] };
		rbp = *rbp;
	}
	return r;
}

stacktrace::stacktrace(const stacktrace& other, int start) : num_ptrs(other.num_ptrs - start) {
	view(ptrs).blit(view(other.ptrs).subspan(start, other.num_ptrs), 0);
}

void stacktrace::print() const {
	::print("\nIDX:  RETURN    STACKPTR  NAME\n");
	for (uint32_t i = 0; i < num_ptrs; i++) {
		pointer<debug_symbol> nearest = nearest_symbol(ptrs.at(i).ret);
		errorf<512>("%3i:  %08x  %08x  %s\n", i, ptrs.at(i).ret(), ptrs.at(i).rbp(),
					nearest ? nearest->name : "(none)");
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
	globals->heap_allocations.append((heap_tag){ ptr, size, stacktrace(stacktrace::trace(), 1) });
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
		errorf<64>("Allocation %p (%i bytes)\n", tag.ptr(), tag.size);
		tag.alloc_trace.print();
		delay(units::seconds{ 3. });
	}
}