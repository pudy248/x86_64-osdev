#pragma once

constexpr int toupper(int c) { return c >= 'a' && c <= 'z' ? c - 'a' + 'A' : c; }
constexpr int tolower(int c) { return c >= 'A' && c <= 'Z' ? c - 'A' + 'a' : c; }