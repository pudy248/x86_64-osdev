#pragma once

typedef struct TextBuffer {
    char* buffer;
    int bufferLen;
    int lineCount;

    int topLine;
    int cursorLine;
    int cursorOffset;
} TextBuffer;

TextBuffer globalBuffer;
    
void buffer_init(TextBuffer* this);
char buffer_handle_navigation(TextBuffer* this, char code);
void buffer_insert_char(TextBuffer* this, char c);
void buffer_display(TextBuffer* this);
