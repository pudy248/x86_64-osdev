#pragma once
#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/array.hpp>
#include <stl/vector.hpp>

#define DEBUG_MAX_STACK_FRAMES 20

class very_verbose_class {
public:
	int id;
	very_verbose_class()
		: id(0) {
		qprintf<80>("Default-constructing with id %i at %p.\n", id, this);
	}
	very_verbose_class(int id)
		: id(id) {
		qprintf<80>("Constructing new instance with id %i at %p.\n", id, this);
	}
	very_verbose_class(const very_verbose_class& copy)
		: id(copy.id) {
		qprintf<80>("Copy-constructing with id %i at %p (from %p).\n", id, this, &copy);
	}
	very_verbose_class(very_verbose_class&& other)
		: id(other.id) {
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
	~very_verbose_class() {
		qprintf<80>("Destructing with id %i at %p.\n", id, this);
	}
};

struct debug_symbol {
	void* addr;
	const char* name;
	uint32_t size;
};
extern vector<debug_symbol> symbol_table;
void load_debug_symbs(const char* filename);
debug_symbol* nearest_symbol(void* address, bool* out_contains = NULL);
void wait_until_kbhit();

class stacktrace {
public:
	struct stack_frame {
		void* ret;
		void* rbp;
	};
	int num_ptrs;
	array<stack_frame, DEBUG_MAX_STACK_FRAMES> ptrs;
	[[gnu::noinline]] stacktrace();
	stacktrace(void* disable_trace);
	stacktrace(const stacktrace& other, int start);
	void print() const;
};
void inline_stacktrace();

struct heap_tag {
	void* ptr;
	uint64_t size;
	stacktrace alloc_trace;
};
extern vector<heap_tag, waterline_allocator>* heap_allocations;

void* tagged_alloc(uint64_t size, uint16_t alignment);
void tagged_free(void* ptr);
void tag_dump();