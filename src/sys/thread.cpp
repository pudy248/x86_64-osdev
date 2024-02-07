#include <cstdint>
#include <sys/thread.hpp>
#include <stl/vector.hpp>

template<typename... T> consteval static size_t pack_count() {
    return sizeof...(T);
}
template<typename... T> consteval static size_t pack_size() {
    return (... + sizeof(T));
}

vector<thread_context<void>*> threads;

void threading_init();

template <typename R, typename... Args> thread<R> thread_spawn(R(*fn)(Args...), Args... args) {
    
}

template <typename R> void thread_kill(thread<R> t);
template <typename R> void thread_switch(thread<R> t);
void thread_exit();
void thread_yield();
template <typename R> R thread_co_join(thread<R> t);
template <typename R> R thread_co_await(thread<R> t);
template <typename R> void thread_co_yield(R co_ret);
template <typename R> void thread_co_return(R co_ret);

