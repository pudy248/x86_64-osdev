#include <asm.hpp>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>
#include <sys/init.hpp>
#include <sys/memory/paging.hpp>
#include <text/vga_console.hpp>

extern uint64_t start_ctors;
extern uint64_t end_ctors;
extern uint64_t start_dtors;
extern uint64_t end_dtors;

void global_ctors() {
	void (**i)() = (void (**)()) & start_ctors;
	void (**end)() = (void (**)()) & end_ctors;
	while (i < end)
		(*(i++))();
}
void global_dtors() {
	void (**i)() = (void (**)()) & start_dtors;
	void (**end)() = (void (**)()) & end_dtors;
	while (i < end)
		(*(i++))();
}

void init_libcpp() {
	paging_init();
	vga_text_init();
	mem_init();
	globals->g_console = new (waterline_new<console>())
		console(&vga_text_get_char, &vga_text_set_char, &vga_text_update, vga_text_dimensions);
	debug_init();
	global_ctors();
}