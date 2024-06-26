#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>
#include <sys/idt.hpp>

struct [[gnu::packed]] idt_entry {
	uint16_t offset_low;
	uint16_t selector;
	uint8_t reserved_0;
	uint8_t type;
	uint16_t offset_mid;
	uint32_t offset_high;
	uint32_t reserved_1;
};
struct [[gnu::packed]] idt_ptr {
	uint16_t limit;
	uint32_t base;
};
static struct idt_t {
	struct idt_entry entries[256];
	struct idt_ptr pointer;
}* idt = (idt_t*)0x58000;
void* idtptr;

isr_t isr_fns[48];

void idt_set(uint8_t index, uint64_t base, uint8_t flags) {
	idt->entries[index] = { (uint16_t)base,
							0x18,
							0,
							flags, // | 0x60,
							(uint16_t)(base >> 16U),
							(uint32_t)(base >> 32U),
							0 };
}

extern uint32_t isr_stub_table[48];
static const char* exceptions[] = { "Divide by zero",
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
									"Machine check" };

void isr_set(uint8_t index, isr_t fn) {
	isr_fns[index] = fn;
	if (index >= 32) {
		index -= 32;
		if (index < 8)
			outb(0x21, inb(0x21) & ~(1 << index));
		else
			outb(0xA1, inb(0xA1) & ~(1 << (index - 8)));
	}
}

extern "C" [[gnu::force_align_arg_pointer]] void handle_exception(uint64_t int_num, register_file* registers,
																  uint64_t err_code, bool is_fatal) {
	qprintf<80>("\nException v=%02x e=%04x %s\n", int_num, err_code, int_num >= 0x20 ? "IRQ" : exceptions[int_num]);
	qprintf<80>("RIP=%016x RSP=%016x RFLAGS=", registers->rip, registers->rsp);
	uint64_t rflags = registers->rflags;
	const char* flagchars = "C-P-A-ZSTIDO";
	for (int i = 0; i < 12; i++) {
		bool set = rflags & 1;
		if (set && flagchars[i] != '-') {
			globals->g_console->putchar(flagchars[i]);
			print("F ");
		}
		rflags >>= 1;
	}
	print("\nRegister dump:\n");
	qprintf<80>("%016x %016x %016x %016x\n", registers->rax, registers->rbx, registers->rcx, registers->rdx);
	qprintf<80>("%016x %016x %016x %016x\n", registers->rsi, registers->rdi, registers->rbp, registers->rsp);
	qprintf<80>("%016x %016x %016x %016x\n", registers->r8, registers->r9, registers->r10, registers->r11);
	qprintf<80>("%016x %016x %016x %016x\n", registers->r12, registers->r13, registers->r14, registers->r15);
	qprintf<80>("%016x %016x %016x %016x\n", read_cr0(), read_cr2(), read_cr3(), read_cr4());

	stacktrace();

	if (is_fatal) {
		print("Unrecoverable exception - halting...\n");
		inf_wait();
	}
}

void idt_init() {
	idt->pointer.limit = sizeof(idt->entries) - 1;
	idt->pointer.base = (uint64_t)&idt->entries[0];
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
	for (int i = 0; i < 48; i++) {
		isr_fns[i] = NULL;
	}
	idtptr = (void*)&idt->pointer;
	load_idt(idtptr);
	//asmv("xor %%ecx, %%ecx\n\t div %%ecx" : : : "eax", "ecx", "edx");
}
