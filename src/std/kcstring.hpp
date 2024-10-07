#pragma once
#include <kstddef.hpp>

constexpr int strlen(const char* str) {
	int i = 0;
	while (str[i]) i++;
	return i;
}
constexpr char streql(const char* __restrict lhs, const char* __restrict rhs) {
	int i;
	for (i = 0; lhs[i]; i++) {
		if (rhs[i] != lhs[i]) return 0;
	}
	if (rhs[i] != lhs[i]) return 0;
	return 1;
}
void strcpy(char* __restrict _dest, const char* __restrict source);
