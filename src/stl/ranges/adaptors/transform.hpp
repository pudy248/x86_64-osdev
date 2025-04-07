#pragma once
#include "../adaptor.hpp"
#include "../concepts.hpp"
#include <concepts>
#include <stl/iterator/iterator_interface.hpp>

namespace ranges {
template <std::invocable F, typename I>
class transform_iterator {
	F func;
};
}