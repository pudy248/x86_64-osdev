#include <cstdint>
#include <kassert.hpp>
#include <kstdlib.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/function.hpp>
#include <stl/optional.hpp>
#include <stl/vector.hpp>
#include <sys/idt.hpp>
#include <sys/memory/paging.hpp>
#include <sys/thread.hpp>

//#define INTERRUPT_SWAP

static vector<thread_context<int>*, waterline_allocator> contexts;
static uint32_t thread_id_ctr = 0;
static thread_context<int>* active_thread = NULL;
static bool allow_context_switching = false;

extern "C" void swap_context();

template <typename R> static thread_context<R>* get_thread_context(thread<R> t) {
	for (thread_context<int>* c : contexts) {
		if (c->id == t.id)
			return (thread_context<R>*)c;
	}
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, true, "Failed to find thread.");
	return NULL;
}

template <typename R, typename... Args> static void thread_entry(thread_context<R>* context) {
	context->state = THREAD_STATE::RUNNING;
	function_instance<R (*)(Args...)>* instance = (function_instance<R (*)(Args...)>*)context->args;
	R retval = (*instance)();
	context->return_val = optional<R>(retval);
	thread_exit(0);
}

void threading_init() {
	contexts = { 1, waterline_allocator(mmap(0, 0x100000, 0, 0), 0x100000) };
	thread_context<int>* context = new thread_context<int>();
	context->id = thread_id_ctr++;
	context->state = THREAD_STATE::RUNNING;
	context->stack_bottom = (void*)0x200000;
	context->args = NULL;
	contexts.append(context);

	active_thread = (thread_context<int>*)context;
	register_file_ptr = &active_thread->registers;

	allow_context_switching = true;
}

template <typename R, typename... Args> thread<R> thread_create(R (*fn)(Args...), Args... args) {
	return thread_create_w(thread_creation_opts(), fn, args...);
}

template <typename R, typename... Args>
thread<R> thread_create_w(thread_creation_opts opts, R (*fn)(Args...), Args... args) {
	function_instance<R (*)(Args...)>* dispatch = new function_instance<R (*)(Args...)>(fn, args...);
	thread_context<R>* context = new thread_context<R>();
	contexts.append((thread_context<int>*)context);
	context->id = thread_id_ctr++;
	context->state = THREAD_STATE::UNSTARTED;
	context->stack_bottom = mmap(0, opts.stack_size, 0, 0);
	context->args = dispatch;
	context->registers = {};

	context->registers.rip = (uint64_t)&thread_entry<R, Args...>;
	context->registers.rflags = 0x202;
	context->registers.rsp = (uint64_t)context->stack_bottom;
	context->registers.isr_rsp = context->registers.rsp - 0x38;
	context->registers.rdi = (uint64_t)context;

	if (opts.run_now)
		thread_switch(context->handle());

	return context->handle();
}
template <typename R> void thread_switch(thread<R> t) {
	//if (!allow_context_switching)
	//	return;
	disable_interrupts();
	thread_context<R>* context = contexts.m_at(t.id); //get_thread_context(t);
	//if (active_thread->state == THREAD_STATE::RUNNING)
	//	active_thread->state = THREAD_STATE::SUSPENDED;
	active_thread = (thread_context<int>*)context;
	register_file_ptr_swap = &context->registers;
	// active_thread->state = THREAD_STATE::RUNNING;
#ifdef INTERRUPT_SWAP
	invoke_interrupt<30>();
#else
	swap_context();
#endif
	enable_interrupts();
}
[[gnu::noreturn]] void thread_exit(int code) {
	active_thread->state = THREAD_STATE::JOIN_WAIT;
	active_thread->exit_code = code;
	thread_yield();
	kassert(UNMASKABLE, CATCH_FIRE, true, "No threads to switch to. Did the kernel die?");
	inf_wait();
}
void thread_yield() {
	for (thread_context<int>* c : contexts) {
		if (c->state == THREAD_STATE::UNSTARTED || c->state == THREAD_STATE::SUSPENDED)
			thread_switch(c->handle());
	}
}
template <typename R> R thread_join(thread<R> t) {
	volatile thread_context<R>* context = get_thread_context(t);
	while (context->state != THREAD_STATE::JOIN_WAIT && context->state != THREAD_STATE::KILLED) {
		thread_switch(t);
	}
	R val = context->return_val;
	thread_kill(t);
	return val;
}
template <typename R> void thread_kill(thread<R> t) {
	for (int i = 0; i < contexts.size(); i++) {
		if (contexts[i]->id == t.id)
			contexts.erase(i);
	}
}
template <typename R> R thread_co_await(thread<R> t) {
	volatile thread_context<R>* context = get_thread_context(t);
	while (context->state != THREAD_STATE::COYIELD_WAIT && context->state != THREAD_STATE::JOIN_WAIT) {
		thread_switch(t);
	}
	R val = context->return_val;
	if (context->state == THREAD_STATE::COYIELD_WAIT)
		context->state = THREAD_STATE::SUSPENDED;
	return val;
}
template <typename R> void thread_co_yield(R co_ret) {
	active_thread->state = THREAD_STATE::COYIELD_WAIT;
	active_thread->return_val = optional<R>(co_ret);
	thread_yield();
	kassert(UNMASKABLE, CATCH_FIRE, true, "No threads to switch to. Did the kernel die?");
}
