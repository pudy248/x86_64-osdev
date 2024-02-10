#pragma once
#include <kstdio.hpp> //provides kassert() for runtime assertions
#include <cstddef>
#include <cstdint>
#include <utility>
#include <type_traits>

template<typename... T> consteval static size_t parameter_pack_count() {
    return sizeof...(T);
}
template<typename... T> consteval static size_t parameter_pack_size() {
    return (0 + ... + sizeof(T));
}
template <typename F> class function_instance;
template <typename R, typename... Args>
class function_instance<R (Args...)> {
    static_assert((std::is_move_assignable<Args>() && ...), "Function instances require moveable arguments.");
    static_assert((std::is_default_constructible<Args>() && ...), "Function instances require default-constructible arguments.");
private:
    //Necessary, because comma operator is a sequence point but function comma separator is not.
    //Also makes default-constructibility a requirement :/
    R dummy_function(Args... args) {
        size_t offset = 0;
        ((args = std::move(*(Args*)&arg_data[(offset += sizeof(Args)) - sizeof(Args)])), ...);
        return function(args...);
    }
protected:
    uint8_t arg_data[parameter_pack_size<Args...>()];
    R(*function)(Args...);
    bool _has_args;
    void set_args_ref(Args&... args) {
        _has_args = true;
        size_t offset = 0;
        ((new ((Args*)&arg_data[(offset += sizeof(Args)) - sizeof(Args)]) Args (std::move(args))), ...);
    }
public:
    function_instance(R(*fn)(Args...)) : function(fn), _has_args(false) { }
    function_instance(R(*fn)(Args...), Args... args) : function(fn), _has_args(true) {
        set_args_ref(args...);
    }
    void set_args(Args... args) {
        set_args_ref(args...);
    }
    bool has_args() {
        return _has_args;
    }
    R operator()() {
        kassert(_has_args, "Function instances cannot be evaluated when no argument pack exists!");
        //Arguments must be default constructed so that we can emplace the actual values later. This is super lame.
        return dummy_function(Args()...);
    }
    R operator()(Args... args) {
        set_args_ref(args...);
        return (*this)();
    }
};
