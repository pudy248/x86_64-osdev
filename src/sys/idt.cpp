#include <cstdint>
#include <kstddefs.h>
#include <kstdlib.hpp>

#include <sys/global.h>
#include <sys/idt.h>
#include <sys/pic.h>

struct a_packed idt_entry {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t reserved_0;
    uint8_t type;
    uint16_t offset_mid;
    uint32_t offset_high;
    uint32_t reserved_1;
};

struct a_packed idt_ptr {
    uint16_t limit;
    uint32_t base;
};

static struct idt_t {
    struct idt_entry entries[256];
    struct idt_ptr pointer;
}* idt = (idt_t*)0x58000;
void* idtptr;

void idt_set(uint8_t index, uint64_t base, uint8_t flags) {
    idt->entries[index] = {
        (uint16_t)base,
        0x18,
        0,
        flags,// | 0x60,
        (uint16_t)(base >> 16U),
        (uint32_t)(base >> 32U),
        0
    };
}

extern uint32_t isr_stub_table[48];
static const char *exceptions[] = {
    "Divide by zero",
    "Debug",
    "NMI",
    "Breakpoint",
    "Overflow",
    "OOB",
    "Invalid opcode",
    "No coprocessor",
    "Double fault",
    "Coprocessor segment overrun",
    "Bad TSS",
    "Segment not present",
    "Stack fault",
    "General protection fault",
    "Page fault",
    "Unrecognized interrupt",
    "Coprocessor fault",
    "Alignment check",
    "Machine check"
};

void irq_set(uint8_t index, void(*fn)(void)) {
    globals->irq_fns[index] = fn;
    if (index < 8) outb(0x21, inb(0x21) & ~(1 << index));
    else outb(0xA1, inb(0xA1) & ~(1 << (index - 8)));
}

void handle_exception(int err, uint64_t int_num, uint64_t err_code, register_file* registers) {
    qprintf<80>("\nException v=%02x e=%04x %s\n", int_num, err_code, int_num >= 0x20 ? "IRQ" : exceptions[int_num]);
    qprintf<80>("IP: %02x:%016x\n", registers->cs, registers->rip);
    print("Register dump:\n");
    qprintf<80>("%016x %016x %016x %016x\n", registers->rax, registers->rbx, registers->rcx, registers->rdx);
    qprintf<80>("%016x %016x %016x %016x\n", registers->rsi, registers->rdi, registers->rbp, registers->rsp);
    qprintf<80>("%016x %016x %016x %016x\n", registers->r8_15[0], registers->r8_15[1], registers->r8_15[2], registers->r8_15[3]);
    qprintf<80>("%016x %016x %016x %016x\n", registers->r8_15[4], registers->r8_15[5], registers->r8_15[6], registers->r8_15[7]);
    qprintf<80>("%016x %016x %016x %016x\n", read_cr0(), read_cr2(), read_cr3(), read_cr4());
    
    stacktrace();

    if (err) {
        print("Unrecoverable exception - halting...\n");
        inf_wait();
    }
}

extern "C" {
    __attribute__((force_align_arg_pointer)) void isr_err(uint64_t int_num, register_file* registers, uint64_t err_code) {
        handle_exception(1, int_num, err_code, registers);
    }

    __attribute__((force_align_arg_pointer)) void isr_no_err(uint64_t int_num, register_file* registers) {
        handle_exception(0, int_num, 0, registers);
    }

    __attribute__((force_align_arg_pointer)) void irq_isr(uint64_t code, register_file* registers) {
        if (globals->irq_fns[code - 32])
            globals->irq_fns[code - 32]();
        else
            handle_exception(0, code, 0, registers);
        pic_eoi((uint8_t)(code - 32));
    }
}

void idt_init() {
    idt->pointer.limit = sizeof(idt->entries) - 1;
    idt->pointer.base = (uint64_t) &idt->entries[0];
    memset((char*)&idt->entries[0], 0, sizeof(idt->entries));
    int i = 0;
    for (; i < 32; i++) {
        idt_set((uint8_t)i, isr_stub_table[i], 0x8e);
    }
    for (; i < 48; i++) {
        idt_set((uint8_t)i, isr_stub_table[i], 0x8e);
    }
    for (; i < 256; i++) {
        idt_set((uint8_t)i, isr_stub_table[0], 0x8e);
    }
    for (int i = 0; i < 16; i++) {
        globals->irq_fns[i] = NULL;
    }
    idtptr = (void*)&idt->pointer;
    load_idt(idtptr);
    //asmv("xor %%ecx, %%ecx\n\t div %%ecx" : : : "eax", "ecx", "edx");
}
