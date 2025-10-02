#include "thread.hpp"
#include <asm.hpp>
#include <config.hpp>
#include <cstddef>
#include <cstdint>
#include <kassert.hpp>
#include <lib/allocators/waterline.hpp>
#include <stl/map.hpp>
#include <stl/optional.hpp>
#include <sys/fixed_global.hpp>
#include <sys/memory/paging.hpp>

static unordered_map<int, pointer<thread_context<>, type_cast, owning>, uint32_t> contexts;
static uint32_t thread_id_ctr = 0;
static pointer<thread_context<>, type_cast> active_thread;
static bool allow_context_switching = false;

extern "C" void swap_context();

static pointer<thread_context<>> get_thread_context(thread_any t) {
	for (auto [_, c] : contexts)
		if (c->id == t.id)
			return c;
	kassert(ALWAYS_ACTIVE, CATCH_FIRE, true, "Failed to find thread.");
	return NULL;
}

template <typename R, typename... Args>
static void thread_entry(thread_context<R>* context) {
	context->state = THREAD_STATE::RUNNING;
	if constexpr (!std::is_void_v<R>) {
		function_instance<R (*)(Args...)>* instance = (function_instance<R (*)(Args...)>*)context->args;
		R retval = (*instance)();
		context->return_val = optional<R>(retval);
	} else {
		function_instance<R (*)(Args...)>* instance = (function_instance<R (*)(Args...)>*)context->args;
		(*instance)();
	}
	thread_exit(0);
}

std::size_t num_thread_contexts() { return contexts.size(); }

void threading_init() {
	new (&contexts) std::remove_reference_t<decltype(contexts)>{1};
	contexts.insert(++thread_id_ctr, new thread_context<>{});
	pointer<thread_context<>> context = contexts[thread_id_ctr];
	context->id = thread_id_ctr;
	context->state = THREAD_STATE::RUNNING;
	context->stack_bottom = 0x1f0000;
	context->stack_size = 0x10000;
	context->args = nullptr;
	active_thread = context;

	munmap(fixed_globals->register_file_ptr(), 0x1000);
	fixed_globals->register_file_ptr = pointer(&active_thread->registers);

	allow_context_switching = true;
}

template <typename R, typename... Args>
thread<R> thread_create(R (*fn)(Args...), std::type_identity_t<Args>... args) {
	return thread_create_w(thread_creation_opts(), fn, args...);
}

template <typename R, typename... Args>
thread<R> thread_create_w(thread_creation_opts opts, R (*fn)(Args...), std::type_identity_t<Args>... args) {
	function_instance<R (*)(Args...)>* dispatch = new function_instance<R (*)(Args...)>(fn, args...);
	contexts.insert(++thread_id_ctr, new thread_context<>{});
	pointer<thread_context<R>, integer> context = contexts[thread_id_ctr];
	context->id = thread_id_ctr;
	context->state = THREAD_STATE::UNSTARTED;
	context->stack_bottom = mmap(nullptr, opts.stack_size, MAP_INITIALIZE);
	context->stack_size = opts.stack_size;
	context->args = dispatch;
	context->registers = {};

	context->registers.rip = (uint64_t)&thread_entry<R, Args...>;
	context->registers.rflags = 0x202;
	context->registers.rsp = uint64_t(context->stack_bottom) + context->stack_size - 0x10;
	context->registers.isr_rsp = context->registers.rsp - 0x38;
	context->registers.rdi = uint64_t(context);

	if (opts.run_now)
		thread_switch(context->handle());

	return context->handle();
}
void thread_switch(thread_any t) {
	if (!allow_context_switching)
		return;
	disable_interrupts();
	pointer<thread_context<>> context = get_thread_context(t);
	if (active_thread->state == THREAD_STATE::RUNNING)
		active_thread->state = THREAD_STATE::SUSPENDED;
	active_thread = context;
	fixed_globals->register_file_ptr_swap = pointer(&context->registers);
	active_thread->state = THREAD_STATE::RUNNING;
	if constexpr (INTERRUPT_SWAP)
		invoke_interrupt<30>();
	else
		swap_context();
	enable_interrupts();
}
[[gnu::noreturn]] void thread_exit(int code) {
	active_thread->state = THREAD_STATE::JOIN_WAIT;
	active_thread->exit_code = code;
	thread_yield();
	kassert(UNMASKABLE, CATCH_FIRE, true, "No threads to switch to. Did the kernel die?");
	cpu_halt();
}
void thread_yield() {
	if (!allow_context_switching)
		return;
	active_thread->yield_timestamp = rdtsc();
	thread_any oldest = -1;
	uint64_t oldest_timestamp = -1llu;
	for (auto [_, c] : contexts) {
		if ((c->state == THREAD_STATE::UNSTARTED || c->state == THREAD_STATE::SUSPENDED) &&
			c->yield_timestamp < oldest_timestamp) {
			oldest = c->handle();
			oldest_timestamp = c->yield_timestamp;
		}
	}
	if (oldest_timestamp != -1llu)
		thread_switch(oldest);
}
void thread_kill(thread_any t) {
	munmap(contexts[t.id]->stack_bottom, contexts[t.id]->stack_size);
	contexts.erase(t.id);
}
template <typename R>
R thread_join(thread<R> t) {
	volatile thread_context<R>* context = get_thread_context(t);
	while (context->state != THREAD_STATE::JOIN_WAIT && context->state != THREAD_STATE::KILLED)
		thread_switch(t);
	R val = context->return_val;
	thread_kill(t);
	return val;
}
template <>
void thread_join<void>(thread<void> t) {
	volatile thread_context<void>* context = get_thread_context(t);
	while (context->state != THREAD_STATE::JOIN_WAIT && context->state != THREAD_STATE::KILLED)
		thread_switch(t);
	thread_kill(t);
}
template <typename R>
R thread_co_await(thread<R> t) {
	volatile thread_context<R>* context = get_thread_context(t);
	while (context->state != THREAD_STATE::COYIELD_WAIT && context->state != THREAD_STATE::JOIN_WAIT)
		thread_switch(t);
	R val = context->return_val;
	if (context->state == THREAD_STATE::COYIELD_WAIT)
		context->state = THREAD_STATE::SUSPENDED;
	return val;
}
template <typename R>
void thread_co_yield(R co_ret) {
	active_thread->state = THREAD_STATE::COYIELD_WAIT;
	pointer<thread_context<R>, type_cast>(active_thread)->return_val = optional<R>(co_ret);
	thread_yield();
	kassert(UNMASKABLE, CATCH_FIRE, true, "No threads to switch to. Did the kernel die?");
}
