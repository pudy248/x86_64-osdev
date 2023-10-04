#include <typedefs.h>
#include <idt.h>
#include <pic.h>
#include <assembly.h>
#include <string.h>
#include <serial_console.h>

struct IDTEntry {
    uint16_t offset_low;
    uint16_t selector;
    uint8_t __ignored;
    uint8_t type;
    uint16_t offset_high;
} __attribute__((packed));

struct IDTPointer {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

static struct {
    struct IDTEntry entries[256];
    struct IDTPointer pointer;
} idt;

void idt_set(uint8_t index, uint32_t base, uint8_t flags) {
    idt.entries[index] = (struct IDTEntry) {
        .offset_low = base & 0xFFFF,
        .offset_high = (base >> 16) & 0xFFFF,
        .selector = 0x10,
        .type = flags,// | 0x60,
        .__ignored = 0
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

static uint32_t errCtr = 0;

void isr_err(int err, int err2) {
    serial_printf("EXCEPT ERR #%i - %s (%i)\r\n", errCtr++, exceptions[err], err2);
    while(1);
}

void isr_no_err(int err) {
    serial_printf("EXCEPT #%i - %s\r\n", errCtr++, exceptions[err]);
}

void irq_isr(int code) {
    if(code == 32) {
        pic_eoi(0);
        return;
    }
    else if(code == 33) {
        handle_key();
    }
    else {
        serial_printf("IRQ %i\r\n", code);
    }
    pic_eoi(code - 32);
}

void idt_init() {
    idt.pointer.limit = sizeof(idt.entries) - 1;
    idt.pointer.base = (uint32_t) &idt.entries[0];
    memset((char*)&idt.entries[0], 0, sizeof(idt.entries));
    int i = 0;
    for(; i < 32; i++) {
        idt_set(i, isr_stub_table[i], 0x8e);
    }
    for(; i < 40; i++) {
        idt_set(i, isr_stub_table[i], 0x8e);
    }
    for(; i < 256; i++) {
        idt_set(i, isr_stub_table[0], 0x8E);
    }
    loadIDT((uint32_t) &idt.pointer);
}
