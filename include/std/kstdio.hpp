#pragma once
#include <cstddef>
#include <cstdint>

class console {
private:
    void putchar_noupdate(char c);
    void newline();
public:
    int cx = 0;
    int cy = 0;
    int text_rect[4];
    char(*get_char)(uint32_t, uint32_t);
    void(*set_char)(uint32_t, uint32_t, char);
    void(*refresh)();

    console(char(*)(uint32_t, uint32_t), void(*)(uint32_t, uint32_t, char), void(*)(), int[2]);
    void clear();
    void putchar(char c);
    void putstr(const char* s);

    void hexdump(void* ptr, uint32_t bytes);
    void hexdump_rev(void* ptr, uint32_t bytes, uint32_t swap_width);
};

void print(class rostring str);
void print(const char* str);
template <typename... Args> void printf(const char* fmt, Args... args);
template <typename... Args> void printf(class rostring fmt, Args... args);
template <std::size_t N, typename... Args> void qprintf(const char* fmt, Args... args);