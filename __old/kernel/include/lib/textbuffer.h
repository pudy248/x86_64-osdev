#pragma once
#include <inttypes.hpp>

#define TEXTBUFFER_AUTOSCROLL   0x01
#define TEXTBUFFER_LINELOCK     0x02

typedef struct {
    int dims[2];
    int origin[2];
    int indent;
    int maxChars;
} TextRegion;

typedef struct {
    TextRegion region;

    char* restrict buffer;
    int bufferLen;
    int lineCount;
    int firstLine;
    uint8_t flags;

    int cursorY;
    int cursorX;
} TextBuffer;

extern TextBuffer globalBuffer;
    
void buffer_init(TextBuffer* this, char* buffer, TextRegion region);
void buffer_clear(TextBuffer* this);
void buffer_wipe(TextBuffer* this);
char buffer_nav(TextBuffer* this, char code);
void buffer_display(TextBuffer* this);
void buffer_putkey(TextBuffer* this, uint8_t c);
void buffer_putchar(TextBuffer* this, char c);
void buffer_putstr(TextBuffer* this, char* s);
void bsprintf(TextBuffer* this, char* fmt, ...);
