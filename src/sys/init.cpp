#include <cstdint>
#include <drivers/keyboard.hpp>
#include <kfile.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <lib/filesystems/fat.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>
#include <sys/idt.hpp>
#include <sys/init.hpp>
#include <sys/ktime.hpp>
#include <sys/memory/paging.hpp>
#include <text/console.hpp>
#include <text/text_display.hpp>
#include <text/vga_terminal.hpp>

extern uint64_t start_ctors;
extern uint64_t end_ctors;
extern uint64_t start_dtors;
extern uint64_t end_dtors;
extern uint64_t start_bss;
extern uint64_t end_bss;

void global_ctors() {
	void (**i)() = (void (**)())&start_ctors;
	void (**end)() = (void (**)())&end_ctors;
	while (i < end)
		(*(i++))();
}
void global_dtors() {
	void (**i)() = (void (**)())&start_dtors;
	void (**end)() = (void (**)())&end_dtors;
	while (i < end)
		(*(i++))();
}

void init_libcpp() {
	kbzero<8>(&start_bss, (&end_bss - &start_bss) * sizeof(uint64_t));
	kbzero<8>(fixed_globals, sizeof(fixed_global_data_t));
	paging_init();
	vga_text_init();
	mem_init();
	globals->g_console = decltype(globals->g_console)::make_unique(waterline_new<console>());
	new (globals->g_console()) console(&vga_text_set_char, &vga_text_update, vga_text_dimensions);
	globals->g_stdout = decltype(globals->g_stdout)::make_unique(waterline_new<text_layer>());
	new (globals->g_stdout) text_layer(default_console());
	default_output().fill(' ');
	debug_init();
	global_ctors();
}

void kernel_reinit() {
	kbzero<8>(&start_bss, (&end_bss - &start_bss) * sizeof(uint64_t));
	//globals->tag_allocs = true;
	replace_console(console(&vga_text_set_char, &vga_text_update, vga_text_dimensions));
	idt_reinit();
	*globals->fs = { fat_read_directory, fat_write_directory, fat_read_file,
					 fat_write_file,	 globals->fs->root,	  globals->fs->current };
	global_ctors();
	isr_set(32, &inc_pit);
	isr_set(33, &keyboard_irq);
	time_init();
#ifdef DEBUG
	load_debug_symbs("/symbols.txt");
	load_debug_symbs("/symbols2.txt");
#endif
}