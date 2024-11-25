#pragma once
#include <cstddef>
#include <cstdint>
#include <kcstring.hpp>
#include <kstdio.hpp>
#include <lib/allocators/mmap.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/array.hpp>
#include <stl/pointer.hpp>
#include <stl/vector.hpp>

#define DEBUG_MAX_STACK_FRAMES 20

class very_verbose_class {
public:
	int id;
	very_verbose_class() : id(0) { qprintf<80>("Default-constructing with id %i at %p.\n", id, this); }
	very_verbose_class(int id) : id(id) { qprintf<80>("Constructing new instance with id %i at %p.\n", id, this); }
	very_verbose_class(const very_verbose_class& copy) : id(copy.id) {
		qprintf<80>("Copy-constructing with id %i at %p (from %p).\n", id, this, &copy);
	}
	very_verbose_class(very_verbose_class&& other) : id(other.id) {
		other.id = 0;
		qprintf<80>("Move-constructing with id %i at %p (from %p).\n", id, this, &other);
	}
	very_verbose_class& operator=(const very_verbose_class& copy) {
		id = copy.id;
		qprintf<80>("Copy-assigning with id %i at %p (from %p).\n", id, this, &copy);
		return *this;
	}
	very_verbose_class& operator=(very_verbose_class&& other) {
		id = other.id;
		other.id = 0;
		qprintf<80>("Move-assigning with id %i at %p (from %p).\n", id, this, &other);
		return *this;
	}
	~very_verbose_class() { qprintf<80>("Destructing with id %i at %p.\n", id, this); }
};

struct debug_symbol {
	pointer<void, integer> addr;
	ccstr_t name;
	uint32_t size;
};

class stacktrace {
public:
	struct stack_frame {
		pointer<void, reinterpret> ret;
		pointer<void, reinterpret> rbp;
	};
	uint32_t num_ptrs;
	array<stack_frame, DEBUG_MAX_STACK_FRAMES> ptrs;
	stacktrace() = default;
	stacktrace(const stacktrace& other, int start);
	[[gnu::noinline]] static stacktrace trace();
	static stacktrace trace(pointer<uint64_t, integer> rbp, uint64_t return_addr);
	void print() const;
};

struct heap_tag {
	pointer<void> ptr;
	uint64_t size;
	stacktrace alloc_trace;
};

extern vector<debug_symbol, mmap_allocator> symbol_table;

void debug_init();
void load_debug_symbs(ccstr_t filename);
pointer<debug_symbol> nearest_symbol(pointer<void, integer> address, pointer<bool> out_contains = nullptr);
void wait_until_kbhit();

void inline_stacktrace();

bool tags_enabled();
pointer<void> tag_alloc(uint64_t size, pointer<void> ptr);
void tag_free(pointer<void> ptr);
void tag_dump();