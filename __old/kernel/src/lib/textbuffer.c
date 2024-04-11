#include <stdarg.h>
#include <sys/kstdio.h>
#include <sys/keyboard.h>
#include <lib/textbuffer.h>
#include <lib/kstring.h>

TextBuffer globalBuffer;

static void buffer_newline(TextBuffer* this);

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

static int local_to_global_x(int lx, int ly, TextRegion region) {
    return (lx % region.dims[0]) + region.origin[0] + (!ly ? region.indent : 0);
}
static int local_to_global_y(int lx, int ly, TextRegion region) {
    return (lx / region.dims[0]) + ly + region.origin[1];
}

static char key_to_ascii(uint8_t key)
{
    for (int i = 0; i < 5; i++) {
        if (key >= spans[i].start && key < spans[i].start + spans[i].length) {
            if (keyboardInput.shift)
                return spans[i].uppercase[key - spans[i].start];
            else
                return spans[i].lowercase[key - spans[i].start];
        }
    }
	return 0;
}

static int buffer_lineOffset(TextBuffer* this, int line) {
    int ctr = 0;
    for (int i = 0; i < this->bufferLen; i++) {
        if (ctr == line) return i;
        if (this->buffer[i] == '\n') ctr++;
    }
    return 0;
}
static int buffer_lineLength(TextBuffer* this, int line) {
    if (line >= this->lineCount) return 0;
    int start = buffer_lineOffset(this, line);
    int i;
    for (i = start; i < this->bufferLen &&  this->buffer[i] != '\n'; i++);
    return i - start;
}

static void bound_cursor(TextBuffer* this) {
    if (this->firstLine >= this->lineCount) this->firstLine = this->lineCount - 1;
    if (this->flags & TEXTBUFFER_AUTOSCROLL) {
        if (this->firstLine + this->region.dims[1] - this->cursorY < 1) this->firstLine = this->cursorY - this->region.dims[1] + 1;
        if (this->cursorY - this->firstLine < 0) this->firstLine = this->cursorY;
    }
    else {
        if (this->firstLine + this->region.dims[1] - this->cursorY < 1) this->cursorY = this->firstLine + this->region.dims[1] - 1;
        if (this->cursorY - this->firstLine < 0) this->cursorY = this->firstLine;
    }
}

static void buffer_up(TextBuffer* this) {
    if (this->cursorY == 0 || (this->flags & TEXTBUFFER_LINELOCK)) {
        this->cursorX = 0;
    }
    else {
        int len = buffer_lineLength(this, this->cursorY - 1);
        if (this->cursorX > len) this->cursorX = len;
        this->cursorY--;
        bound_cursor(this);
    }
}
static void buffer_down(TextBuffer* this) {
    if (this->cursorY == this->lineCount - 1 || (this->flags & TEXTBUFFER_LINELOCK)) {
        this->cursorX = buffer_lineLength(this, this->cursorY);
    }
    else {
        int len = buffer_lineLength(this, this->cursorY + 1);
        if (this->cursorX > len) this->cursorX = len;
        this->cursorY++;
        bound_cursor(this);
    }
}
static void buffer_left(TextBuffer* this) {
    if (this->cursorX == 0) {
        if (this->cursorY == 0) return;
        buffer_up(this);
        this->cursorX = buffer_lineLength(this, this->cursorY);
    }
    else {
        this->cursorX--;
    }
}
static void buffer_right(TextBuffer* this) {
    int len = buffer_lineLength(this, this->cursorY);
    if (this->cursorX == len) {
        this->cursorX = 0;
        buffer_down(this);
    }
    else {
        this->cursorX++;
    }
}

static void buffer_insert(TextBuffer* this, char c) {
    if (this->region.maxChars >= 0 && this->bufferLen == this->region.maxChars) return;
    int cursorX = buffer_lineOffset(this, this->cursorY) + this->cursorX;
    for (int i = this->bufferLen + 1; i > cursorX; i--) this->buffer[i] = this->buffer[i - 1]; 
    this->buffer[cursorX] = c;
    this->bufferLen++;
    this->cursorX++;

    if (this->cursorX == this->region.dims[0] && c != '\n') buffer_newline(this);
}
static void buffer_delete(TextBuffer* this) {
    if (this->bufferLen < 2 || (this->cursorY == 0 && this->cursorX == 0)) return;

    int cursorX = buffer_lineOffset(this, this->cursorY) + this->cursorX;
    char original = this->buffer[cursorX - 1];
    for (int i = cursorX; i < this->bufferLen; i++) this->buffer[i - 1] = this->buffer[i]; 
    if (original == '\n') {
        buffer_up(this);
        this->cursorX = cursorX - buffer_lineOffset(this, this->cursorY) - 1;
        this->lineCount--;
    }
    else
        this->cursorX--;
    this->bufferLen--;
}

static void buffer_newline(TextBuffer* this) {
    if (this->flags & TEXTBUFFER_LINELOCK) return;
    buffer_insert(this, '\n');
    this->cursorX = 0;
    this->lineCount++;
    buffer_down(this);
}

char buffer_nav(TextBuffer* this, char code) {
    switch(code) {
        case 0x48: buffer_up(this); break;
        case 0x50: buffer_down(this); break;
        case 0x4B: buffer_left(this); break;
        case 0x4D: buffer_right(this); break;
        default: return 0;
    }
    return 1;
}

void buffer_putkey(TextBuffer* this, uint8_t c) {
    if (c == 0xE) { //backspace
        if (keyboardInput.ctrl) {
            if (keyboardInput.alt) buffer_wipe(this);
            else {
                if (this->cursorX == 0) buffer_delete(this);
                while (this->cursorX > 0) buffer_delete(this);
            }
        }
        else buffer_delete(this);
    }
    else if (c == 0x1C) { //enter
        buffer_newline(this);
    }
    else if (c == 0x49) { // pgup
        if (keyboardInput.shift) {
            this->firstLine = this->firstLine >= this->region.dims[1] ? this->firstLine - this->region.dims[1] : 0;
        }
        else {
            this->firstLine = this->firstLine >= 1 ? this->firstLine - 1 : 0;
        }
        bound_cursor(this);
    }
    else if (c == 0x51) { // pgdown
        if (keyboardInput.shift) {
            this->firstLine += this->region.dims[1];
        }
        else {
            this->firstLine++;
        }
        bound_cursor(this);
    }
    else if (c == 0x53) { //delete
        if (this->cursorY == this->lineCount - 1 && this->cursorX == buffer_lineLength(this, this->cursorY)) return;
        buffer_right(this);
        buffer_delete(this);
    }
    else if (key_to_ascii(c)) {
        buffer_insert(this, key_to_ascii(c));
    }
    else {
        bsprintf(this, "[%02x]", *(uint8_t*)&c);
    }
}
void buffer_putchar(TextBuffer* this, char c) {
    if (c == '\n') buffer_newline(this);
    else if (c == '\r');
    else buffer_insert(this, c);
}
void buffer_putstr(TextBuffer* this, char* s) {
    for (int i = 0; s[i]; ++i)
        buffer_putchar(this, s[i]);
    buffer_display(this);
}
void bsprintf(TextBuffer* this, char* fmt, ...) {
    va_list l;
    va_start((void*)&l, fmt);
    char* dest = (char*)0x60000;
    vsprintf(&dest, fmt, l);
    buffer_putstr(this, (char*)0x60000);
    va_end(l);
}

void buffer_clear(TextBuffer* this) {
    for (int y = 0; y < this->region.dims[1]; y++) {
        for (int x = 0; x < this->region.dims[0]; x++) {
            int gx = local_to_global_x(x, y, this->region);
            int gy = local_to_global_y(x, y, this->region);
            BASIC_CONSOLE[2 * (gy * BASIC_CONSOLE_W + gx)] = ' ';
        }
    }
}

void buffer_wipe(TextBuffer* this) {
    this->buffer[0] = '\n';
    this->buffer[1] = 0;
    this->bufferLen = 1;
    this->lineCount = 1;
    this->firstLine = 0;
    this->cursorY = 0;
    this->cursorX = 0;
}

void buffer_display(TextBuffer* this) {
    buffer_clear(this);
    int offset = buffer_lineOffset(this, this->firstLine);
    for (int i = 0; i < this->region.dims[1]; i++) {
        int len = buffer_lineLength(this, this->firstLine + i);
        for (int j = 0; j < len; j++) {
            int x = local_to_global_x(j, i, this->region);
            int y = local_to_global_y(j, i, this->region);
            BASIC_CONSOLE[2 * (y * BASIC_CONSOLE_W + x)] = this->buffer[offset + j];
        }
        offset += len + 1;
    }
    int cx = local_to_global_x(this->cursorX, this->cursorY - this->firstLine, this->region);
    int cy = local_to_global_y(this->cursorX, this->cursorY - this->firstLine, this->region);
    update_cursor(cx, cy);
}

void buffer_init(TextBuffer* this, char* buffer, TextRegion region) {
    this->buffer = buffer;
    this->region = region;
    buffer_wipe(this);
    this->flags = TEXTBUFFER_AUTOSCROLL;

    int cx = local_to_global_x(this->cursorX, this->cursorY - this->firstLine, this->region);
    int cy = local_to_global_y(this->cursorX, this->cursorY - this->firstLine, this->region);
    update_cursor(cx, cy);
}
