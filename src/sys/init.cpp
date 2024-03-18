#include <cstdint>
#include <kstdlib.hpp>
#include <kstdio.hpp>
#include <sys/global.hpp>
#include <sys/init.hpp>
#include <text/vga_console.hpp>

extern uint64_t start_ctors;
extern uint64_t end_ctors;
extern uint64_t start_dtors;
extern uint64_t end_dtors;

void global_ctors() {
    uint64_t i = start_ctors;
    while(i != end_ctors) {
        ((void(*)())i)();
    }
}
void global_dtors() {
    uint64_t i = start_dtors;
    while(i != end_dtors) {
        ((void(*)())i)();
    }
}
void init_libcpp() {
    mem_init();
    vga_text_init();
    globals->g_console = console(&vga_text_get_char, &vga_text_set_char, &vga_text_update, vga_text_dimensions);
    global_ctors();
}