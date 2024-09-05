#pragma once
#include <cstdint>
#include <kstddefs.hpp>

static inline uint8_t inb(uint16_t port) {
	uint8_t ret;
	asmv("inb %1, %0\n" : "=a"(ret) : "Nd"(port) : "memory");
	return ret;
}
static inline uint16_t inw(uint16_t port) {
	uint16_t ret;
	asmv("inw %1, %0\n" : "=a"(ret) : "Nd"(port) : "memory");
	return ret;
}
static inline uint32_t inl(uint16_t port) {
	uint32_t ret;
	asmv("inl %1, %0\n" : "=a"(ret) : "Nd"(port) : "memory");
	return ret;
}

static inline void outb(uint16_t port, uint8_t val) {
	asmv("outb %0, %1\n" : : "a"(val), "Nd"(port) : "memory");
}
static inline void outw(uint16_t port, uint16_t val) {
	asmv("outw %0, %1\n" : : "a"(val), "Nd"(port) : "memory");
}
static inline void outl(uint16_t port, uint32_t val) {
	asmv("outl %0, %1\n" : : "a"(val), "Nd"(port) : "memory");
}

static inline uint64_t read_cr0(void) {
	uint64_t val;
	asmv("mov %%cr0, %0\n" : "=r"(val));
	return val;
}
static inline uint64_t read_cr2(void) {
	uint64_t val;
	asmv("mov %%cr2, %0" : "=r"(val));
	return val;
}
static inline uint64_t read_cr3(void) {
	uint64_t val;
	asmv("mov %%cr3, %0\n" : "=r"(val));
	return val;
}
static inline uint64_t read_cr4(void) {
	uint64_t val;
	asmv("mov %%cr4, %0\n" : "=r"(val));
	return val;
}

static inline void write_cr0(uint64_t val) { asmv("mov %0, %%cr0\n" : : "r"(val)); }
static inline void write_cr2(uint64_t val) { asmv("mov %0, %%cr2\n" : : "r"(val)); }
static inline void write_cr3(uint64_t val) { asmv("mov %0, %%cr3\n" : : "r"(val)); }
static inline void write_cr4(uint64_t val) { asmv("mov %0, %%cr4\n" : : "r"(val)); }

static inline uint64_t rdtsc(void) {
	uint32_t low, high;
	asmv("rdtsc" : "=a"(low), "=d"(high) : : "memory");
	return ((uint64_t)high << 32) | low;
}
static inline uint64_t rdmsr(uint32_t msr) {
	uint32_t low, high;
	asmv("rdmsr\n" : "=a"(low), "=d"(high) : "c"(msr));
	return ((uint64_t)high << 32) | low;
}
static inline void wrmsr(uint32_t msr, uint64_t val) {
	asmv("wrmsr\n" : : "c"(msr), "a"((uint32_t)val), "d"(val >> 32));
}

static inline void cpu_relax() { asm("rep nop\n" : : : "memory"); }
[[noreturn]] static inline void cpu_halt(void) {
	asmv("cli\nhlt\nnop\n");
	__builtin_unreachable();
}
[[noreturn]] static inline void inf_wait(void) {
	for (;;);
	//cpu_halt();
}

template <int N> static inline void invoke_interrupt(void) {
	__asm__("int %0\n" : : "N"(N) : "cc", "memory");
}
static inline void int3(void) { asmv("int3\n"); }
static inline void disable_interrupts() { asmv("cli\n"); }
static inline void enable_interrupts() { asmv("sti\n"); }
