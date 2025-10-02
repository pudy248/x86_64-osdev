#pragma once
#include <kassert.hpp>
#include <optional>
#include <tuple>
#include <utility>

template <typename F>
class function_instance;
template <typename R, typename... Args>
class function_instance<R (*)(Args...)> {
protected:
	R (*function)(Args...);
	std::optional<std::tuple<Args...>> args_data;

public:
	constexpr function_instance(R (*fn)(Args...)) : function(fn), args_data(std::nullopt) {}
	template <typename... Args2>
	constexpr function_instance(R (*fn)(Args...), Args2&&... args)
		: function(fn), args_data(std::forward<Args2>(args)...) {}
	template <typename... Args2>
	constexpr void set_args(Args2&&... args) {
		args_data = std::tuple<Args...>(std::forward<Args2>(args)...);
	}
	constexpr bool has_args() { return args_data.has_value(); }
	constexpr R operator()() {
		kassert(DEBUG_ONLY, WARNING, args_data.has_value() || sizeof...(Args) == 0,
			"Function instances cannot be evaluated when no argument pack exists!");
		if constexpr (sizeof...(Args) == 0)
			return function();
		else
			return std::apply(function, std::move(*args_data));
	}
	template <typename... Args2>
	constexpr R operator()(Args2&&... args) {
		set_args(std::forward<Args>(args)...);
		return (*this)();
	}
};
