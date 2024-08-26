#include <asm.hpp>
#include <cstddef>
#include <cstdint>
#include <kcstring.hpp>
#include <kstdio.hpp>
#include <sys/debug.hpp>
#include <sys/fixed_global.hpp>
#include <sys/global.hpp>
#include <sys/idt.hpp>
#include <sys/memory/paging.hpp>

#define BETTER_EXCEPTION_PRINTING

struct [[gnu::packed]] idt_entry {
	uint16_t offset_low;
	uint16_t selector;
	uint8_t ist;
	uint8_t flags : 4;
	uint8_t reserved_1 : 4;
	uint16_t offset_mid;
	uint32_t offset_high;
	uint32_t reserved_2;
};
struct idt_t {
	idt_entry entries[256];
};
struct [[gnu::packed]] idt_ptr {
	uint16_t limit;
	uint64_t base;
} idt_pointer;

isr_t isr_fns[48];

void idt_set(uint8_t index, uint64_t base, uint8_t flags, uint8_t ist) {
	((idt_t*)(fixed_globals->idt))->entries[index] =
		idt_entry{ (uint16_t)base,			0x18, ist, flags, 0x8, (uint16_t)(base >> 16U),
				   (uint32_t)(base >> 32U), 0 };
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

static int previous_interrupt = 0;
static bool previous_interrupt_was_fatal = false;
extern "C" void handle_exception(uint64_t int_num, register_file* registers, uint64_t err_code,
								 bool is_fatal) {
	if (previous_interrupt_was_fatal && is_fatal) {
		const char* msg = "DOUBLE FATAL FAULT";
		for (int i = 0; i < strlen(msg); i++) ((uint16_t*)0xb8000)[i] = 0x0c00 + msg[i];
		cpu_halt();
	}
	previous_interrupt = int_num;
	previous_interrupt_was_fatal = is_fatal;
	qprintf<80>("\nException v=%02x e=%04x %s\n", int_num, err_code,
				int_num >= 0x20 ? "IRQ" :
				int_num >= 19	? "OUT OF RANGE" :
								  exceptions[int_num]);
#ifdef BETTER_EXCEPTION_PRINTING
	qprintf<128>("RIP=%016x RSP=%016x RFLAGS=", registers->rip, registers->rsp);
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
	qprintf<128>("RAX=%012x RBX=%012x RCX=%012x RDX=%012x\n", registers->rax, registers->rbx,
				 registers->rcx, registers->rdx);
	qprintf<128>("RSI=%012x RDI=%012x RBP=%012x RSP=%012x\n", registers->rsi, registers->rdi,
				 registers->rbp, registers->rsp);
	qprintf<128>("R08=%012x R09=%012x R10=%012x R11=%012x\n", registers->r8, registers->r9,
				 registers->r10, registers->r11);
	qprintf<128>("R12=%012x R13=%012x R14=%012x R15=%012x\n", registers->r12, registers->r13,
				 registers->r14, registers->r15);
	qprintf<128>("CR0=%012x CR2=%012x CR3=%012x CR4=%012x\n", read_cr0(), read_cr2(), read_cr3(),
				 read_cr4());
#else
	qprintf<80>("RIP=%016x RSP=%016x RFLAGS=%016x\nRegister dump:\n", registers->rip,
				registers->rsp, registers->rflags);
	qprintf<80>("%016x %016x %016x %016x\n", registers->rax, registers->rbx, registers->rcx,
				registers->rdx);
	qprintf<80>("%016x %016x %016x %016x\n", registers->rsi, registers->rdi, registers->rbp,
				registers->rsp);
	qprintf<80>("%016x %016x %016x %016x\n", registers->r8, registers->r9, registers->r10,
				registers->r11);
	qprintf<80>("%016x %016x %016x %016x\n", registers->r12, registers->r13, registers->r14,
				registers->r15);
	qprintf<80>("%016x %016x %016x %016x\n", read_cr0(), read_cr2(), read_cr3(), read_cr4());
#endif

	stacktrace::trace((uint64_t*)registers->rbp, registers->rip).print();

	if (is_fatal) {
		print("Unrecoverable exception - halting...\n");
		inf_wait();
	}
}

void idt_init() {
	fixed_globals->idt = mmap(0, 0x1000, 0, MAP_INITIALIZE | MAP_PHYSICAL);
	fixed_globals->register_file_ptr = mmap(0, 0x1000, 0, MAP_INITIALIZE | MAP_PHYSICAL);
	fixed_globals->register_file_ptr_swap = mmap(0, 0x1000, 0, MAP_INITIALIZE | MAP_PHYSICAL);
	idt_reinit();
	//asmv("xor %%ecx, %%ecx\n\t div %%ecx" : : : "eax", "ecx", "edx");
}

void idt_reinit() {
	disable_interrupts();
	idt_pointer.limit = sizeof(((idt_t*)(fixed_globals->idt))->entries) - 1;
	idt_pointer.base = (uint64_t)&((idt_t*)(fixed_globals->idt))->entries[0];
	int i = 0;
	for (; i < 30; i++) { idt_set((uint8_t)i, isr_stub_table[i], 0xe); }
	for (; i < 32; i++) { idt_set((uint8_t)i, isr_stub_table[i], 0xe); }
	for (; i < 48; i++) { idt_set((uint8_t)i, isr_stub_table[i], 0xe); }
	for (; i < 256; i++) { idt_set((uint8_t)i, isr_stub_table[0], 0xe); }
	for (int i = 0; i < 48; i++) { isr_fns[i] = NULL; }
	load_idt(&idt_pointer);
}
