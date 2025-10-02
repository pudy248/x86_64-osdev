#pragma once
#include <cstdint>
#include <stl/function.hpp>
#include <stl/optional.hpp>
#include <sys/idt.hpp>
#include <sys/types.h>

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

template <typename R>
struct thread {
	uint32_t id;
};
struct thread_any {
	uint32_t id;
	constexpr thread_any() = default;
	constexpr thread_any(uint32_t id) : id(id) {}
	template <typename R>
	constexpr thread_any(thread<R> t) : id(t.id) {}
};
template <typename R = void>
struct thread_context {
	uint32_t id;
	uint32_t state;
	uint32_t __reference_count;
	uint32_t exit_code;
	uint64_t yield_timestamp;

	pointer<void, reinterpret> stack_bottom;
	uint32_t stack_size;
	pointer<void, reinterpret> args;
	register_file registers;

	optional<R> return_val;

	thread<R> handle() const { return thread<R>{id}; }
};

struct thread_creation_opts {
	uint32_t stack_size = 0x1000;
	bool run_now = true;
};

void threading_init();
std::size_t num_thread_contexts();

template <typename R, typename... Args>
thread<R> thread_create(R (*fn)(Args...), std::type_identity_t<Args>... args);
template <typename R, typename... Args>
thread<R> thread_create_w(thread_creation_opts opts, R (*fn)(Args...), std::type_identity_t<Args>... args);
void thread_switch(thread_any t);
[[gnu::noreturn]] void thread_jump(thread_any t);
[[gnu::noreturn]] void thread_exit(int code);
void thread_yield();
void thread_kill(thread_any t);

template <typename R>
R thread_join(thread<R> t);
template <typename R>
R thread_co_await(thread<R> t);
template <typename R>
void thread_co_yield(R co_ret);
