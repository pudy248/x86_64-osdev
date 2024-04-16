#pragma once
#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <stl/array.hpp>
#include <stl/vector.hpp>
#include <type_traits>
#include <utility>

template <typename... T> consteval static std::size_t parameter_pack_count() {
	return sizeof...(T);
}
template <typename... T> consteval static std::size_t parameter_pack_size() {
	return (0 + ... + sizeof(T));
}

template <typename F> class function_instance;
template <typename R, typename... Args> class function_instance<R(Args...)> {
	static_assert((std::is_move_assignable<Args>() && ...), "Function instances require moveable arguments.");
	static_assert((std::is_default_constructible<Args>() && ...),
				  "Function instances require default-constructible arguments.");

private:
	//Necessary, because comma operator is a sequence point but function comma separator is not.
	//Also makes default-constructibility a requirement :/
	R dummy_function(Args&&... args) {
		size_t offset = 0;
		((args = std::move(*(Args*)&arg_data[(offset += sizeof(Args)) - sizeof(Args)])), ...);
		return function(args...);
	}

protected:
	array<uint8_t, parameter_pack_size<Args...>()> arg_data;
	R (*function)(Args...);
	bool _has_args;

public:
	function_instance(R (*fn)(Args...))
		: function(fn)
		, _has_args(false) {
	}
	function_instance(R (*fn)(Args...), Args... args)
		: function(fn)
		, _has_args(true) {
		set_args(std::forward<Args>(args)...);
	}
	function_instance(R (*fn)(Args...), Args&&... args)
		: function(fn)
		, _has_args(true) {
		set_args(std::forward<Args>(args)...);
	}
	~function_instance() {
		if (_has_args) {
			size_t offset = 0;
			((((Args*)&arg_data[(offset += sizeof(Args)) - sizeof(Args)])->~Args()), ...);
		}
	}
	void set_args(Args&&... args) {
		_has_args = true;
		size_t offset = 0;
		((new ((Args*)&arg_data[(offset += sizeof(Args)) - sizeof(Args)]) Args(std::move(args))), ...);
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
		set_args(std::forward<Args>(args)...);
		return (*this)();
	}
};
