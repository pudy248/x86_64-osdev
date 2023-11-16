#include <typedefs.h>
#include <common.h>
#include <basic_console.h>
#include <idt.h>
#include <pic.h>

struct idt_entry {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t pad_0;
    uint8_t type;
    uint16_t offset_high;
} __attribute__((packed));

struct idt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

static struct {
    struct idt_entry entries[256];
    struct idt_ptr pointer;
} idt;
void* idtptr;

void idt_set(uint8_t index, uint32_t base, uint8_t flags) {
    idt.entries[index] = (struct idt_entry) {
        .offset_low = base & 0xFFFF,
        .offset_high = (base >> 16) & 0xFFFF,
        .selector = 0x18,
        .type = flags,// | 0x60,
        .pad_0 = 0
    };
}

extern uint32_t isr_stub_table[40];
static const char *exceptions[32] = {
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
    "Machine check",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED",
    "RESERVED"
};

static uint32_t errCtr;

__attribute__((noreturn)) void isr_err(int int_num, int err_code, int cs, int eip, int eflags);
__attribute__((noreturn)) void isr_err(int int_num, int err_code, int cs, int eip, int eflags) {
    basic_printf("EXCEPT ERR %i (#%i) - %s (%i)\r\n    -> %x:%x\r\n", int_num, errCtr++, exceptions[int_num], err_code, cs, eip);
    while(1);
}

void isr_no_err(int int_num, int cs, int eip, int eflags);
void isr_no_err(int int_num, int cs, int eip, int eflags) {
    basic_printf("EXCEPT %i (#%i) - %s\r\n    -> %x:%x\r\n", int_num, errCtr++, exceptions[int_num], cs, eip);
}

void irq_isr(int code, int cs, int eip, int eflags);
void irq_isr(int code, int cs, int eip, int eflags) {
    /*
    if(code == 32) {
        pic_eoi(0);
        return;
    }
    else if(code == 33) {
        handle_key();
    }
    else {
        basic_printf("IRQ %i\r\n", code);
    }
    */
    pic_eoi((uint8_t)(code - 32));
}

void idt_init() {
    errCtr = 0;
    idt.pointer.limit = sizeof(idt.entries) - 1;
    idt.pointer.base = (uint32_t) &idt.entries[0];
    memset((char*)&idt.entries[0], 0, sizeof(idt.entries));
    int i = 0;
    for(; i < 32; i++) {
        idt_set((uint8_t)i, isr_stub_table[i], 0x8e);
    }
    for(; i < 40; i++) {
        idt_set((uint8_t)i, isr_stub_table[i], 0x8e);
    }
    for(; i < 256; i++) {
        idt_set((uint8_t)i, isr_stub_table[0], 0x8E);
    }
    idtptr = (void*)&idt.pointer;
    load_idt(idtptr);
    //__asm__ __volatile__("xor %%ecx, %%ecx\n\t div %%ecx" : : : "eax", "ecx", "edx");
}
