#include <typedefs.h>
#include <string.h>
#include <arith64.h>

void strcpy(char* dest, char* source) {
    while(*source != 0) {
        *dest = *source;
        ++dest;++source;
    }
}

void memset(char* dest, char source, uint32_t size) {
    for(uint32_t i = 0; i < size; i++) dest[i] = source;
}

void itoa(char* dest, int source) {
    if(source < 0) {
        source = -source;
        *dest = '-';
        dest++;
    }
    int tmp = source;
    int ctr = 0;
    do {
        tmp = tmp / 10;
        ctr++;
    } while(tmp > 0);
    dest[ctr] = '\0';
    while (ctr > 0) {
        int rem = source % 10;
        dest[--ctr] = rem + '0';
        source = source / 10;
    }
    return;
}
void ltoa(char* dest, uint64_t source) {
    if(source < 0) {
        source = -source;
        *dest = '-';
        dest++;
    }
    uint64_t tmp = source;
    int ctr = 0;
    do {
        tmp = tmp / 10;
        ctr++;
    } while(tmp > 0);
    dest[ctr] = '\0';
    while (ctr > 0) {
        uint64_t rem = (uint32_t)source % 10;
        dest[--ctr] = rem + '0';
        source = source / 10;
    }
    return;
}
void xtoa(char* dest, uint32_t source) {
    uint32_t tmp = source;
    int ctr = 0;
    do {
        tmp = tmp / 16;
        ctr++;
    } while(tmp > 0);
    dest[ctr] = '\0';
    while (ctr > 0) {
        uint32_t rem = source % 16;
        dest[--ctr] = rem > 9 ? rem + 'A' - 10 : rem + '0';
        source = source / 16;
    }
    return;
}
void xtoa_zeroes(char* dest, int source, int leadingZeroes)
{
    int ctr = leadingZeroes;
    dest[ctr] = '\0';
    while (ctr >= 0) {
        int rem = source % 16;
        dest[--ctr] = rem > 9 ? rem + 'A' - 10 : rem + '0';
        source = source / 16;
    }
    return;
}
void ftoa(char* dest, float source, int decimals) {
    if(source < 0) {
        source = -source;
        *dest = '-';
        dest++;
    }
    int digits = 0;
    float tmp = source;
    while(tmp > 1) {
        tmp *= 0.1f;
        digits++;
    }
    tmp = source;
    if(digits > 0) {
        int ctr = digits;
        while(ctr > 0) {
            dest[ctr - 1] = (int)tmp % 10 + '0';
            tmp *= 0.1f;
            ctr--;
        }
        dest += digits;
    }
    else {
        *dest = '0';
        dest++;
    }
    *dest = '.';
    dest++;
    tmp = source;
    for(int i = 0; i < decimals; i++) {
        tmp *= 10;
        *dest = (int)tmp % 10 + '0';
        dest++;
    }

    *dest = 0;
    dest++;
}

#define tmpStrAddr ((char*)0x60000)
void vsprintf(char* buffer, char* format, uint8_t* vArgs) {
    int bIdx = 0;
    int sIdx = 0;
    double d;
    for(int i = 0; format[i] != '\0'; i++) {
        if(format[i] == '%') {
            i++;
            switch(format[i]) {
                case 'i':
                    itoa(tmpStrAddr, *(int*)vArgs);
                    for(sIdx = 0; tmpStrAddr[sIdx] != 0;) buffer[bIdx++] = tmpStrAddr[sIdx++];
                    vArgs += 4;
                    break;
                case 'l':
                    ltoa(tmpStrAddr, *(uint64_t*)vArgs);
                    for(sIdx = 0; tmpStrAddr[sIdx] != 0;) buffer[bIdx++] = tmpStrAddr[sIdx++];
                    vArgs += 8;
                    break;
                case 'x':
                    xtoa(tmpStrAddr, *(uint32_t*)vArgs);
                    for(sIdx = 0; tmpStrAddr[sIdx] != 0;) buffer[bIdx++] = tmpStrAddr[sIdx++];
                    vArgs += 4;
                    break;
                case 's':
                    for(sIdx = 0; (*(char**)vArgs)[sIdx] != 0;) buffer[bIdx++] = (*(char**)vArgs)[sIdx++];
                    vArgs += 4;
                    break;
                case 'c':
                    buffer[bIdx++] = *(int*)vArgs;
                    vArgs += 4;
                    break;
                case 'f':
                    d = *(double*)vArgs;
                    ftoa(tmpStrAddr, (float)d, 4);
                    for(sIdx = 0; tmpStrAddr[sIdx] != 0;) buffer[bIdx++] = tmpStrAddr[sIdx++];
                    vArgs += 8;
                    break;
            }
        }
        else buffer[bIdx++] = format[i];
    }
    buffer[bIdx] = 0;
}

void sprintf(char* buffer, char* format, ...) {
    vsprintf(buffer, format, (uint8_t*)((uint32_t)&format + 4));
}

float fparse(char *arr){
    int offset = 0;
    float val = 0;
    int afterDecimal = 0;
    char neg = 0;
    if (arr[offset] == '-') {
        neg = 1;
        offset++;
    }
    while(arr[offset] >= '0' && arr[offset] <= '9') {
        val *= 10;
        val += arr[offset] - '0';
        offset++;
    }
    if(arr[offset] == '.') {
        offset++;
        while(arr[offset] >= '0' && arr[offset] <= '9' && afterDecimal < 5) {
            afterDecimal++;
            val *= 10;
            val += arr[offset] - '0';
            offset++;
        }
    }
    for(int i = 0; i < afterDecimal; i++) val *= 0.1f;
    if(neg) val = -val;
    return val;
}
int iparse(char *arr){
    int offset = 0;
    int val = 0;
    char neg = 0;
    if (arr[offset] == '-') {
        neg = 1;
        offset++;
    }
    while(arr[offset] >= '0' && arr[offset] <= '9') {
        val *= 10;
        val += arr[offset] - '0';
        offset++;
    }
    if(neg) val = -val;
    return val;
}
