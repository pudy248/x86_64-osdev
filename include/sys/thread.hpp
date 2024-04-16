#pragma once
#include <cstdint>
#include <stl/functional.hpp>
#include <stl/optional.hpp>
#include <sys/idt.hpp>

namespace THREAD_STATE
{
enum THREAD_STATE {
	UNINITIALIZED,
	UNSTARTED,
	RUNNING,
	COYIELD_WAIT,
	JOIN_WAIT,
	KILLED,
};
}

template <typename R> struct thread { uint32_t id; };
template <typename R> struct thread_context {
	int state;
	void* _stack;
	void* _heap;
	register_file registers;
	optional<R> return_val;
	void* args;
};

void threading_init();

template <typename R, typename... Args> thread<R> thread_create(R (*fn)(Args...), Args... args);
template <typename R> void thread_switch(thread<R> t);
template <typename R> void thread_jump(thread<R> t);
template <typename R> void thread_kill(thread<R> t);
void thread_exit();
void thread_yield();
template <typename R> R thread_co_join(thread<R> t);
template <typename R> R thread_co_await(thread<R> t);
template <typename R> void thread_co_yield(R co_ret);
template <typename R> void thread_co_return(R co_ret);
