#pragma once
#include <cstdint>
#include <kstring.hpp>
#include <kstdlib.hpp>

class console {
private:
    uint16_t* c = (uint16_t*)0xb8000;
public:
    int cx = 0;
    int cy = 0;
    int rect[4] = {0, 0, 72, 25};

    console();
    void clear();
    void update_cursor();
    char get(int x, int y);
    void set(char ch, int x, int y);
    void newline();
    void putchar(char c);
    void putstr(const char* s);

    void hexdump(void* ptr, uint32_t bytes);
    void hexdump_rev(void* ptr, uint32_t bytes, uint32_t swap_width);
};

void print(rostring str);
void print(const char* str);
template <typename... Args> void printf(const char* fmt, Args... args);
template <typename... Args> void printf(rostring fmt, Args... args);
template <std::size_t N, typename... Args> void qprintf(const char* fmt, Args... args);
#define kassert(condition, msg) if (!(condition)) { printf("%s:%i: %s\n", __FILE__, __LINE__, msg); inf_wait(); }