#pragma once
#include <typedefs.h>

void longcall(uint32_t ptr, uint32_t argsize, ...);
void init_protected(void);

void basic_printf(char* format, ...);
void vsprintf(char* buffer, char* format, uint8_t* vArgs);
int iparse(char* ptr);
float fparse(char* ptr);

uint64_t rdtsc(void);
void delay(uint64_t cycles);
uint8_t get_rtc_second(void);

void memcpy(void* dest, void* src, uint32_t size);
void memset(void* dest, char src, uint32_t size);
