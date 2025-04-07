#pragma once
#include <cstddef>
#include <stl/ranges/concepts.hpp>
#include <stl/ranges/view.hpp>

void refresh_tty();

void putchar(char c, bool refresh = true);
void print(const char* str, bool refresh = true);
void print(span<const char> str, bool refresh = true);

template <typename... Args>
	requires(!!sizeof...(Args))
void printf(const char* fmt, Args... args);
template <typename... Args>
	requires(!!sizeof...(Args))
void printf(span<const char> fmt, Args... args);
template <std::size_t N, typename... Args>
	requires(!!sizeof...(Args))
void qprintf(const char* fmt, Args... args);

void hexdump(const void* ptr, uint32_t bytes, uint32_t block_width = 4, uint32_t num_columns = 8, bool reversed = false,
			 bool refresh = true);

class console& default_console();
class text_layer& default_output();

void disable_log();
void clear_log();
span<const char> output_log();

void error(const char* str);
template <std::size_t N, typename... Args>
	requires(!!sizeof...(Args))
void errorf(const char* fmt, Args... args);

void replace_console(console&& con);