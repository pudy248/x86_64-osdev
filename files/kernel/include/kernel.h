#pragma once
#include <typedefs.h>

extern void yield(void);
extern void yield_noreturn(uint32_t idx);
extern uint32_t co_yield(void);
extern uint32_t co_return(void);
extern void _die(void);

void task_init(void);
char create_task(uint32_t entry, char core);
void kill_task(uint32_t idx);

uint32_t rdtsc_high(void);
uint32_t rdtsc_low(void);
uint64_t rdtsc(void);
void delay(uint64_t cycles);
void load_idt(uint32_t idtaddr);
