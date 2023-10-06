#pragma once
#include <typedefs.h>

extern void Yield();
extern void ForceYield(uint32_t taskIndex);
extern void KillCurrentTask();

void task_init();

char MakeTask(uint32_t entry, char core);
void KillTask(char idx);

void delay(uint64_t cycles);
