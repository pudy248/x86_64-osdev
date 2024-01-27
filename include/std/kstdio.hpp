#pragma once
#include <cstdint>

class console {
private:
    uint16_t* c = (uint16_t*)0xb8000;
public:
    int cx = 0;
    int cy = 0;
    int rect[4] = {0, 0, 80, 25};

    console();
    void clear();
    void update_cursor();
    void set(char ch, int x, int y);
    void newline();
    void putchar(char c);
    void putstr(const char* s);
};
