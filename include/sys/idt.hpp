#pragma once
#include <cstdint>
#include <kstddefs.hpp>

struct register_file {
	union {
		struct {
			uint64_t rax, rbx, rcx, rdx, rsi, rdi, rbp, rsp;
			uint64_t r8, r9, r10, r11, r12, r13, r14, r15;
		};
		uint64_t general_purpose_registers[16];
	};
	uint64_t rip, rflags, ret_rsp, pad;
	uint256_t ymm[16];
};

typedef void (*isr_t)(uint64_t, register_file*);
extern void* register_file_ptr;

void idt_set(uint8_t index, uint64_t base, uint8_t flags);
void isr_set(uint8_t index, isr_t fn);
void idt_init(void);
extern "C" void* idtptr;
extern "C" void load_idt(void* idtptr);
