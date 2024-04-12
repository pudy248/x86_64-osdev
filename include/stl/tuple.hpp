#pragma once
#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <utility>

//TODO

template <typename... T> consteval static std::size_t parameter_pack_count() {
	return sizeof...(T);
}
template <typename... T> consteval static std::size_t parameter_pack_size() {
	return (0 + ... + sizeof(T));
}

template <typename... Ts> class tuple {
protected:
	uint8_t data[parameter_pack_size<Ts...>()];

public:
	constexpr tuple(Ts&&... ts) {
		std::size_t offset = 0;
		((new ((Ts*)&data[(offset += sizeof(Ts)) - sizeof(Ts)]) Ts(std::forward<Ts>(ts))), ...);
	}
};
