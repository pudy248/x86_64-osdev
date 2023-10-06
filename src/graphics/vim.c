#include <keyboard.h>
#include <vim.h>
#include <console.h>
#include <string.h>
#include <memory.h>

void buffer_newline(TextBuffer* this);

struct {
    int start;
    int length;
    const char* lowercase;
    const char* uppercase;
} spans[] = {
    {0x2, 0xC, "1234567890-=", "!@#$%^&*()_+"},
    {0x10, 0xD, "qwertyuiop[]", "QWERTYUIOP{}"},
    {0x1E, 0xC, "asdfghjkl;'`", "ASDFGHJKL:\"~"},
    {0X2B, 0xB, "\\zxcvbnm,./", "|ZXCVBNM<>?"},
    {0x39, 0x1, " ", " "},
};

char key_to_ascii(uint8_t key)
{
    for(int i = 0; i < 5; i++) {
        if(key >= spans[i].start && key < spans[i].start + spans[i].length) {
            if(shift)
                return spans[i].uppercase[key - spans[i].start];
            else
                return spans[i].lowercase[key - spans[i].start];
        }
    }
	return 0;
}

int buffer_lineOffset(TextBuffer* this, int line) {
    int ctr = 0;
    for(int i = 0; i < this->bufferLen; i++) {
        if(ctr == line) return i;
        if(this->buffer[i] == '\n') ctr++;
    }
    return 0;
}
int buffer_lineLength(TextBuffer* this, int line) {
    if(line >= this->lineCount) return 0;
    int start = buffer_lineOffset(this, line);
    int i;
    for(i = start; i < this->bufferLen &&  this->buffer[i] != '\n'; i++);
    return i - start;
}

void buffer_up(TextBuffer* this) {
    if(this->cursorLine == 0) {
        this->cursorOffset = 0;
    }
    else {
        int len = buffer_lineLength(this, this->cursorLine - 1);
        if(this->cursorOffset > len) this->cursorOffset = len;
        this->cursorLine--;
    }
}
void buffer_down(TextBuffer* this) {
    if(this->cursorLine == this->lineCount - 1) {
        this->cursorOffset = buffer_lineLength(this, this->cursorLine);
    }
    else {
        int len = buffer_lineLength(this, this->cursorLine + 1);
        if(this->cursorOffset > len) this->cursorOffset = len;
        this->cursorLine++;
    }
}
void buffer_left(TextBuffer* this) {
    if(this->cursorOffset == 0) {
        if(this->cursorLine == 0) return;
        buffer_up(this);
        this->cursorOffset = buffer_lineLength(this, this->cursorLine);
    }
    else {
        this->cursorOffset--;
    }
}
void buffer_right(TextBuffer* this) {
    int len = buffer_lineLength(this, this->cursorLine);
    if(this->cursorOffset == len) {
        this->cursorOffset = 0;
        buffer_down(this);
    }
    else {
        this->cursorOffset++;
    }
}

void buffer_insert(TextBuffer* this, char c) {
    int cursorOffset = buffer_lineOffset(this, this->cursorLine) + this->cursorOffset;
    for(int i = this->bufferLen + 1; i > cursorOffset; i--) this->buffer[i] = this->buffer[i - 1]; 
    this->buffer[cursorOffset] = c;
    this->bufferLen++;
    this->cursorOffset++;

    if(this->cursorOffset == CONSOLE_W && c != '\n') buffer_newline(this);
}
void buffer_delete(TextBuffer* this) {
    if(this->bufferLen < 2 || (this->cursorLine == 0 && this->cursorOffset == 0)) return;

    int cursorOffset = buffer_lineOffset(this, this->cursorLine) + this->cursorOffset;
    char original = this->buffer[cursorOffset - 1];
    for(int i = cursorOffset; i < this->bufferLen; i++) this->buffer[i - 1] = this->buffer[i]; 
    if(original == '\n') {
        buffer_up(this);
        this->cursorOffset = cursorOffset - buffer_lineOffset(this, this->cursorLine) - 1;
        this->lineCount--;
    }
    else
        this->cursorOffset--;
    this->bufferLen--;
}

char buffer_handle_navigation(TextBuffer* this, char code) {
    switch(code) {
        case 0x48: buffer_up(this); break;
        case 0x50: buffer_down(this); break;
        case 0x4B: buffer_left(this); break;
        case 0x4D: buffer_right(this); break;
        default: return 0;
    }
    return 1;
}

void buffer_newline(TextBuffer* this) {
    buffer_insert(this, '\n');
    this->cursorOffset = 0;
    this->lineCount++;
    buffer_down(this);
}

void buffer_insert_char(TextBuffer* this, char c) {
    if(c == 0xE) { //backspace
        if(ctrl) {
            if(alt) buffer_init(this);
            else {
                if(this->cursorOffset == 0) buffer_delete(this);
                while(this->cursorOffset > 0) buffer_delete(this);
            }
        }
        else buffer_delete(this);
    }
    else if(c == 0x1C) { //enter
        buffer_newline(this);
    }
    else if(c == 0x49) { // pgup
        if(shift) {
            this->topLine = this->topLine >= CONSOLE_H ? this->topLine - CONSOLE_H : 0;
        }
        else {
            this->topLine = this->topLine >= 1 ? this->topLine - 1 : 0;
        }
    }
    else if(c == 0x51) { // pgdown
        if(shift) {
            this->topLine += CONSOLE_H;
        }
        else {
            this->topLine++;
        }
    }
    else if(c == 0x53) { //delete
        if(this->cursorLine == this->lineCount - 1 && this->cursorOffset == buffer_lineLength(this, this->cursorLine)) return;
        buffer_right(this);
        buffer_delete(this);
    }
    else if(key_to_ascii(c)) {
        buffer_insert(this, key_to_ascii(c));
    }
    else {
        #define tmpStrAddr ((char*)0x50000)
        sprintf(tmpStrAddr, "[%x]", *(uint8_t*)&c);
        for(int i = 0; tmpStrAddr[i] != 0; i++) {
            buffer_insert(this, tmpStrAddr[i]);
        }
    }
}

void buffer_display(TextBuffer* this) {
    clearconsole();
    int offset = buffer_lineOffset(this, this->topLine);
    for(int i = 0; i < CONSOLE_H; i++) {
        int len = buffer_lineLength(this, this->topLine + i);
        for(int j = 0; j < len; j++) console[2 * (i * CONSOLE_W + j)] = this->buffer[offset + j];
        offset += len + 1;
    }
    CURSOR_Y = this->cursorLine - this->topLine;
    CURSOR_X = this->cursorOffset;
    update_cursor();
}

void buffer_init(TextBuffer* this) {
    this->buffer[0] = '\n';
    this->buffer[1] = 0;
    this->bufferLen = 1;
    this->lineCount = 1;
    this->topLine = 0;
    this->cursorLine = 0;
    this->cursorOffset = 0;
}
