#include <kstdlib.hpp>
#include <kprint.h>
#include <sys/idt.h>
#include <sys/ktime.hpp>
#include <sys/global.h>

#include <drivers/keyboard.h>

#include <net/net.hpp>
#include <net/tcp.hpp>
#include <net/http.hpp>

extern "C" void atexit(void (*)(void) __attribute__((cdecl))) {
    
}

static void http_main() {
    net_init();
    vector<tcp_connection*> conns;
    while (true) {
        net_process();
        {
            tcp_connection* c = NULL;
            if (!c) c = tcp_accept(80);
            if (!c) c = tcp_accept(8080);
            if(c) {
                conns.append(c);
            }
        }
        for (int i = 0; i < conns.size(); i++) {
            tcp_connection* conn = conns.at(i);
            if (conn->state == TCP_STATE::CLOSED) {
                tcp_destroy(conn);
                conns.erase(i);
                i--; continue;
            }
            if (conn->recieved_packets.size()) {
                tcp_packet p = conn->recv();
                if (http_process(conn, p)) {
                    conn->close();
                    tcp_destroy(conn);
                    conns.erase(i);
                    i--;
                }
                free(p.contents.unsafe_arr());
            }
        }
    }
}

extern "C" __attribute__((noreturn)) __attribute__((force_align_arg_pointer)) void kernel_main(void);
extern "C" __attribute__((noreturn)) __attribute__((force_align_arg_pointer)) void kernel_main(void) {
    irq_set(0, &inc_pit);
    irq_set(1, &keyboard_irq);
    time_init();
    globals->fat_data.root_directory.inode->purge();

    http_main();
    
    //terminal_init(rootDir);
    //terminal_input_loop();
    inf_wait();
}
