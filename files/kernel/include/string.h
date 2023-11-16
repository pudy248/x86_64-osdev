#pragma once
#include <typedefs.h>

void strcpy(char* dest, char* source);
void memset(void* dest, char source, uint32_t size);
void itoa(char* dest, int source);
void itoa_zeroes(char* dest, int source, int leadingZeroes);
void ltoa(char* dest, int64_t source);
void xtoa(char* dest, uint32_t source);
void xtoa_zeroes(char* dest, uint32_t source, int leadingZeroes);
void ftoa(char* dest, double source, int decimals);

void vsprintf(char* buffer, char* format, uint8_t* vArgs);
void sprintf(char* buffer, char* format, ...);

int iparse(char* ptr);
float fparse(char* ptr);
