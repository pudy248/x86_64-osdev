#include <kernel.h>
#include <taskStructs.h>
#include <assembly.h>
#include <console.h>
#include <string.h>

void task_init() {
    gks->numTasks = 0;
    for(int i = 0; i < sizeof(Task)*64; i++) ((int*)&gks->tasks)[i] = 0;
}

char MakeTask(uint32_t entry, char core) {
    uint16_t idx;
    for(idx = 0; idx < 64; idx++) if ((gks->tasks[idx].flags & 1) == 0) break;
    if(idx == 64) return -1;
    uint32_t stackAddr = 0x20000 + 0x1000 * idx;

    gks->tasks[idx].flags = 1;
    gks->tasks[idx].core = 0;
    gks->tasks[idx].esp = stackAddr;
    gks->numTasks = gks->numTasks > idx + 1 ? gks->numTasks : idx + 1;
    Task_stackframe* newFrame = (Task_stackframe*)(stackAddr - 28);
    newFrame->ebp = stackAddr;
    newFrame->edi = 0;
    newFrame->esi = 0;
    newFrame->edx = 0;
    newFrame->ecx = 0;
    newFrame->ebx = 0;
    newFrame->eax = 0;
    newFrame->retAddr = entry;
    return idx;
}

void KillTask(char idx) {
    gks->tasks[idx].flags = 0;
}

uint64_t rdtscp() {
    uint32_t low = rdtscp_low();
    uint32_t high = rdtscp_high();
    return ((uint64_t)high) << 32 | low;
}

void delay(uint64_t cycles) {
    uint64_t start = rdtscp();
    uint64_t current = rdtscp();
    while(current - start < cycles) current = rdtscp();
}
