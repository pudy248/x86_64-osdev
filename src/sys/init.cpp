#include <cstdint>
#include <kstdlib.hpp>
#include <sys/global.h>
#include <sys/init.h>

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
    globals->vga_console = console();
    global_ctors();
}