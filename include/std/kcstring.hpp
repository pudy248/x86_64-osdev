#pragma once
#include <kstddefs.hpp>

constexpr int strlen(const char* str) {
    int i = 0;
    while (str[i]) i++;
    return i;
}
void strcpy(char* __restrict _dest, const char* __restrict source);
char streql(const char* __restrict lhs, const char* __restrict rhs);
