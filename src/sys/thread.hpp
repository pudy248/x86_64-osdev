#pragma once
#include <cstdint>
#include <stl/function.hpp>
#include <stl/optional.hpp>
#include <sys/idt.hpp>

namespace THREAD_STATE {
enum THREAD_STATE {
	UNSTARTED,
	RUNNING,
	SUSPENDED,
	COYIELD_WAIT,
	JOIN_WAIT,
	KILLED,
};
}

template <typename R> struct thread {
	uint32_t id;
};
template <typename R> struct thread_context {
	uint32_t id;
	uint32_t state;
	uint32_t __reference_count;
	uint32_t exit_code;
	void* stack_bottom;
	void* args;
	register_file registers;
	optional<R> return_val;
	thread<R> handle() const { return thread<R>{ id }; }
};

struct thread_creation_opts {
	uint32_t stack_size = 0x10000;
	bool run_now = true;
};

void threading_init();

template <typename R, typename... Args> thread<R> thread_create(R (*fn)(Args...), Args... args);
template <typename R, typename... Args>
thread<R> thread_create_w(thread_creation_opts opts, R (*fn)(Args...), Args... args);
template <typename R> void thread_switch(thread<R> t);
template <typename R> [[gnu::noreturn]] void thread_jump(thread<R> t);
[[gnu::noreturn]] void thread_exit(int code);
void thread_yield();
template <typename R> R thread_join(thread<R> t);
template <typename R> void thread_kill(thread<R> t);

template <typename R> R thread_co_await(thread<R> t);
template <typename R> void thread_co_yield(R co_ret);
