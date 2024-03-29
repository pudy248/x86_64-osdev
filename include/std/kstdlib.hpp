#pragma once
#include <cstdint>
#include <kstddefs.hpp>

extern "C" {
    void memcpy(void* a_restrict dest, const void* a_restrict src, uint64_t size);
    void memmove(void* dest, void* src, uint64_t size);
    void memset(void* dest, uint8_t src, uint64_t size);
}

void mem_init();
__attribute__((returns_nonnull)) __attribute__((malloc)) void* walloc(uint64_t size, uint16_t alignment);
__attribute__((returns_nonnull)) __attribute__((malloc)) void* malloc(uint64_t size, uint16_t alignment = 0x10);
void free(void* ptr);

struct heap_allocation {
    void* ptr;
    uint64_t size;
    const char* file;
    int line;
};

extern uint64_t waterline;
extern uint64_t mem_used;
extern uint64_t mem_free;

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    asmv("inb %1, %0" : "=a"(ret) : "Nd"(port) : "memory");
    return ret;
}
static inline uint16_t inw(uint16_t port) {
    uint16_t ret;
    asmv("inw %1, %0" : "=a"(ret) : "Nd"(port) : "memory");
    return ret;
}
static inline uint32_t inl(uint16_t port) {
    uint32_t ret;
    asmv("inl %1, %0" : "=a"(ret) : "Nd"(port) : "memory");
    return ret;
}

static inline void outb(uint16_t port, uint8_t val) {
    asmv("outb %0, %1" : : "a"(val), "Nd"(port) : "memory");
}
static inline void outw(uint16_t port, uint16_t val) {
    asmv("outw %0, %1" : : "a"(val), "Nd"(port) : "memory");
}
static inline void outl(uint16_t port, uint32_t val)
{
    asmv("outl %0, %1" : : "a"(val), "Nd"(port) : "memory");
}

static inline uint64_t read_cr0(void) {
    uint64_t val;
    asmv("mov %%cr0, %0" : "=r"(val));
    return val;
}
static inline uint64_t read_cr2(void) {
    uint64_t val;
    asmv("mov %%cr2, %0" : "=r"(val));
    return val;
}
static inline uint64_t read_cr3(void) {
    uint64_t val;
    asmv("mov %%cr3, %0" : "=r"(val));
    return val;
}
static inline uint64_t read_cr4(void) {
    uint64_t val;
    asmv("mov %%cr4, %0" : "=r"(val));
    return val;
}

static inline void write_cr0(uint64_t val) {
    asmv("mov %0, %%cr0" : "=r"(val));
}
static inline void write_cr2(uint64_t val) {
    asmv("mov %0, %%cr2" : "=r"(val));
}
static inline void write_cr3(uint64_t val) {
    asmv("mov %0, %%cr3" : "=r"(val));
}
static inline void write_cr4(uint64_t val) {
    asmv("mov %0, %%cr4" : "=r"(val));
}

static a_noinline void* get_rip() {
    return __builtin_return_address(0);
}
static inline void invlpg(void* m) {
    asmv("invlpg (%0)" : : "b"(m) : "memory");
}
static inline uint64_t rdtsc(void) {
    uint32_t low, high;
    asmv("rdtsc":"=a"(low),"=d"(high));
    return ((uint64_t)high << 32) | low;
}
static inline __attribute__((noreturn)) void inf_wait(void) {
    while (1) asmv("");
}
static inline __attribute__((noreturn)) void cpu_halt(void) {
    asmv("cli; hlt");
    //The compiler is of the opinion that this may halt.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Winvalid-noreturn"
}
#pragma clang diagnostic pop

__attribute__((returns_nonnull)) void* operator new(uint64_t size);
__attribute__((returns_nonnull)) void* operator new(uint64_t size, void* ptr) noexcept;
__attribute__((returns_nonnull)) void* operator new[](uint64_t size);
__attribute__((returns_nonnull)) void* operator new[](uint64_t size, void* ptr) noexcept;
void operator delete(void* ptr) noexcept;
void operator delete(void* ptr, uint64_t size) noexcept;
void operator delete[](void* ptr) noexcept;
void operator delete[](void* ptr, uint64_t size) noexcept;

template<typename T> T* waterline_new(uint64_t size, uint16_t alignment) {
    return (T*)walloc(size, alignment);
}
template<typename T> T* waterline_new(uint16_t alignment) {
    return waterline_new<T>(sizeof(T), alignment);
}

void stacktrace();
void print(const char*);
#define STRINGIZE(x) STRINGIZE2(x)
#define STRINGIZE2(x) #x
#define kassert(condition, msg) { if (!(condition)) { print("ASSERT " __FILE__ ":" STRINGIZE(__LINE__) ": " msg); stacktrace(); inf_wait(); } }