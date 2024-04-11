#pragma once
#include <cstdint>

struct register_file {
    union {
        struct {
            uint64_t rax, rbx, rcx, rdx, rsi, rdi, rbp, rsp;
            uint64_t r8,  r9,  r10, r11, r12, r13, r14, r15;
        };
        uint64_t general_purpose_registers[16];
    };
    uint64_t rip, rflags, cs, ss;
    uint64_t ymm[64];
};

void idt_set(uint8_t index, uint64_t base, uint8_t flags);
void irq_set(uint8_t index, void(*fn)(void));
void idt_init(void);
extern "C" void* idtptr;
extern "C" void load_idt(void* idtptr);
