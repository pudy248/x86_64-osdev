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

struct [[gnu::packed]] idt_entry {
	uint16_t offset_low;
	uint16_t selector;
	uint8_t ist;
	uint8_t flags;
	uint16_t offset_mid;
	uint32_t offset_high;
	uint32_t reserved;
};
struct idt_t {
	idt_entry entries[256];
};
struct [[gnu::packed]] idt_ptr {
	uint16_t limit;
	uint64_t base;
} idt_pointer;

void idt_set(uint8_t index, uint64_t base, uint8_t flags, uint8_t ist) {
	((pointer<idt_t>)fixed_globals->idt)->entries[index] = idt_entry{
		(uint16_t)base, 0x18, ist, (uint8_t)(flags | 0x80), (uint16_t)(base >> 16U), (uint32_t)(base >> 32U), 0};
}

isr_t isr_fns[48];
extern uint32_t isr_table[48];

static const ccstr_t exceptions[] = {"Divide by zero", "Debug", "NMI", "Breakpoint", "Overflow", "OOB",
	"Invalid opcode", "No coprocessor", "Double fault", "Coprocessor segment overrun", "Bad TSS", "Segment not present",
	"Stack fault", "General protection fault", "Page fault", "Unrecognized interrupt", "Coprocessor fault",
	"Alignment check", "Machine check"};

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
extern "C" void handle_exception(uint64_t int_num, register_file* registers, uint64_t err_code, bool is_fatal) {
	if (previous_interrupt_was_fatal && is_fatal) {
		constexpr ccstr_t msg = "DOUBLE FATAL FAULT ";
		constexpr int msg_len = strlen(msg);
		for (int i = 0; i < msg_len; i++)
			((uint16_t*)0xb8000)[i] = 0x0c00 + msg[i];
		((uint16_t*)0xb8000)[msg_len] = 0x0c00 + '0' + previous_interrupt / 10;
		((uint16_t*)0xb8000)[msg_len + 1] = 0x0c00 + '0' + previous_interrupt % 10;
		cpu_halt();
	}
	previous_interrupt = int_num;
	previous_interrupt_was_fatal = is_fatal;
	errorf<80>("\nException v=%02x e=%04x %s\n", int_num, err_code,
		int_num >= 0x20 ? "IRQ" :
		int_num >= 19	? "OUT OF RANGE" :
						  exceptions[int_num]);
	if constexpr (BETTER_EXCEPTION_PRINTING) {
		errorf<128>("RIP=%016x RSP=%016x RFLAGS=", registers->rip, registers->rsp);
		uint64_t rflags = registers->rflags;
		ccstr_t flagchars = "C-P-A-ZSTIDO";
		for (int i = 0; i < 12; i++) {
			bool set = rflags & 1;
			if (set && flagchars[i] != '-') {
				putchar(flagchars[i], false);
				error("F ");
			}
			rflags >>= 1;
		}
		error("\nRegister dump:\n");
		errorf<128>("RAX=%012x RBX=%012x RCX=%012x RDX=%012x\n", registers->rax, registers->rbx, registers->rcx,
			registers->rdx);
		errorf<128>("RSI=%012x RDI=%012x RBP=%012x RSP=%012x\n", registers->rsi, registers->rdi, registers->rbp,
			registers->rsp);
		errorf<128>(
			"R08=%012x R09=%012x R10=%012x R11=%012x\n", registers->r8, registers->r9, registers->r10, registers->r11);
		errorf<128>("R12=%012x R13=%012x R14=%012x R15=%012x\n", registers->r12, registers->r13, registers->r14,
			registers->r15);
		errorf<128>("CR0=%012x CR2=%012x CR3=%012x CR4=%012x\n", read_cr0(), read_cr2(), read_cr3(), read_cr4());
	} else {
		errorf<80>(
			"RIP=%016x RSP=%016x RFLAGS=%016x\nRegister dump:\n", registers->rip, registers->rsp, registers->rflags);
		errorf<80>("%016x %016x %016x %016x\n", registers->rax, registers->rbx, registers->rcx, registers->rdx);
		errorf<80>("%016x %016x %016x %016x\n", registers->rsi, registers->rdi, registers->rbp, registers->rsp);
		errorf<80>("%016x %016x %016x %016x\n", registers->r8, registers->r9, registers->r10, registers->r11);
		errorf<80>("%016x %016x %016x %016x\n", registers->r12, registers->r13, registers->r14, registers->r15);
		errorf<80>("%016x %016x %016x %016x\n", read_cr0(), read_cr2(), read_cr3(), read_cr4());
	}

	stacktrace::trace((uint64_t*)registers->rbp, registers->rip).eprint();

	if (is_fatal) {
		error("Unrecoverable exception - halting...\n");
		inf_wait();
		//cpu_halt();
	}
}

void idt_init() {
	fixed_globals->idt = pointer<void, nocopy, type_cast>::make_nocopy(mmap(nullptr, 0x1000, MAP_INITIALIZE));
	fixed_globals->register_file_ptr = mmap(nullptr, 0x1000, MAP_INITIALIZE);
	idt_reinit();
	//asmv("xor %%ecx, %%ecx\n\t div %%ecx" : : : "eax", "ecx", "edx");
}

void idt_reinit() {
	idt_pointer.limit = sizeof(idt_t::entries) - 1;
	idt_pointer.base = (uint64_t)fixed_globals->idt.ptr;
	int i = 0;
	for (; i < 7; i++)
		idt_set(i, isr_table[i], 0xf);
	for (; i < 30; i++)
		idt_set(i, isr_table[i], 0xe);
	for (; i < 32; i++)
		idt_set(i, isr_table[i], 0xe);
	for (; i < 48; i++)
		idt_set(i, isr_table[i], 0xe);
	for (; i < 256; i++)
		idt_set(i, isr_table[0], 0xe);
	for (int i = 0; i < 48; i++)
		isr_fns[i] = NULL;
	load_idt(&idt_pointer);
}
