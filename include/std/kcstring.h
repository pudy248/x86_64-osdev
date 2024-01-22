#pragma once
#include <kstddefs.h>
#include <stdarg.h>

constexpr int strlen(const char* str) {
    int i = 0;
    while (str[i]) i++;
    return i;
}
void strcpy(char* a_restrict _dest, const char* a_restrict source);
char streql(const char* a_restrict lhs, const char* a_restrict rhs);
