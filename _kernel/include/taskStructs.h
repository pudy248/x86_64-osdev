#pragma once
#include <typedefs.h>

typedef struct Task_stackframe {
    uint32_t ebp;
    uint32_t edi;
    uint32_t esi;
    uint32_t edx;
    uint32_t ecx;
    uint32_t ebx;
    uint32_t eax;
    uint32_t retAddr;
} Task_stackframe;

typedef struct Task {
    uint32_t esp; //esp saved for context switches, all other info, including eip, is on stack
    uint8_t flags; //task flags, format is XXXXXXX E -- E = task exists, X = reserved
    uint8_t core; //Core index
    uint8_t pad[6];
    void* extraInfoPtr; //if task has extra associated data you can put it here
} Task;

typedef struct PageTable {
    char pageTaskIDs[4092];
    uint16_t numFree;
    uint16_t maxFreeSpan;
} PageTable;

typedef struct GlobalKernelStruct {
    /*0x1000*/ PageTable* pageDirectory[256];
    /*0x1400*/ Task tasks[64];
    /*0x1800*/ uint16_t coreTaskIndices[32]; //lower half of each is selected task, upper is whatever
    /*0x1840*/ uint16_t numTasks;
    /*0x1842*/ uint16_t tblWaterline;
    /*0x1844*/ uint32_t pgWaterline;
} GlobalKernelStruct;

#define gks ((GlobalKernelStruct*)0x11000)
