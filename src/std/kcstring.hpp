#pragma once

using cstr_t = char*;
using ccstr_t = const char*;

constexpr int strlen(ccstr_t str) {
	int i = 0;
	while (str[i])
		i++;
	return i;
}
constexpr char streql(ccstr_t __restrict lhs, ccstr_t __restrict rhs) {
	int i;
	for (i = 0; lhs[i]; i++)
		if (rhs[i] != lhs[i])
			return 0;
	if (rhs[i] != lhs[i])
		return 0;
	return 1;
}
void strcpy(cstr_t __restrict _dest, ccstr_t __restrict source);
