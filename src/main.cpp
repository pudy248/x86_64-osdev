#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <sys/idt.h>
#include <sys/ktime.hpp>

#include <drivers/pci.h>
#include <drivers/keyboard.h>

#include <net/net.hpp>
#include <net/arp.hpp>
#include <net/tcp.hpp>

extern "C" int __cxa_atexit(void (*f)(void *), void *objptr, void *dso) {
	return 0;
};

extern "C" __attribute__((noreturn)) __attribute__((force_align_arg_pointer)) void kernel_main(void);
extern "C" __attribute__((noreturn)) __attribute__((force_align_arg_pointer)) void kernel_main(void) {
    irq_set(0, &inc_pit);
    irq_set(1, &keyboard_irq);
    time_init();
    pci_init();
    net_init();
    //outb(0x21, 0x0);
    //outb(0xA1, 0x80);
    
    vector<volatile tcp_connection*> conns;

    int z = 1;
    while (*(volatile int*)&z) {
        {
            volatile tcp_connection* c = NULL;
            if (!c) c = tcp_accept(80);
            if (!c) c = tcp_accept(8080);
            if(c) {
                conns.append(c);
            }
        }
        for (int i = 0; i < conns.size(); i++) {
            volatile tcp_connection* conn = conns.at(i);
            if (conn->state == TCP_STATE::CLOSED) {
                tcp_destroy(conn);
                conns.erase(i);
                i--; continue;
            }
            if (conn->recieved_packets.size()) {
                tcp_packet p = conn->recv();
                vector<rostring> lines = rostring(p.contents).split("\n");
                for (int i = 0; i < lines.size() && i < 3; i++)
                    printf("%S\r\n", &lines[i]);
                
                if (lines[0].starts_with(rostring("GET /index.html HTTP/1.1")) ||
                    lines[0].starts_with(rostring("GET / HTTP/1.1"))) {
                    rostring fstr(
                        "HTTP/1.1 200 OK\r\n"
                        "Content-Type: text/html\r\n"
                        "Content-Length: %i\r\n"
                        "Accept-Ranges: bytes\r\n"
                        "Connection: close\r\n"
                        "\r\n%s"
                    );
                    
                    const char* html = 
                        "<!DOCTYPE html>"
                        "<head><title>Super Cool Website</title></head>"
                        "<body>"
                            "<h1>Big text!</h1>"
                            "<p><i>italics!</i></p>"
                            "<p><a href=\"https://pudy248.github.io/noitaWandAtlas\">links!</a></p>"
                            "<p>More pending?</p>"
                        "</body>"
                    ;
                    string response = format(fstr, strlen(html), html);

                    conn->send({ span<char>(response) });
                }
                else if (lines[0].starts_with(rostring("GET"))) {
                    rostring response(
                        "404 Not Found\r\n"
                        "Content-Type: text/plain\r\n"
                        "Content-Length: 0\r\n"
                        "Connection: close\r\n"
                    );

                    conn->send({ span<char>(response) });
                    conn->close();
                    tcp_destroy(conn);
                    conns.erase(i);
                    i--;
                }
                free((void*)p.contents.unsafe_arr());
            }
        }
    }

    //partition_table* partTable = (partition_table*)(0x7c00 + MBR_PARTITION_START);
    //int activeEntry = 0;
    //fat32_bpb* bpb = (fat32_bpb*)0x200000;
    //fat_init(&partTable->entries[activeEntry], bpb);
    //fat_file rootDir = {"NULL", 0, (void*)get_cluster_addr(bpb->root_cluster_num)};
    //print("Kernel FAT table loaded.\r\n");
    
    //terminal_init(rootDir);
    //terminal_input_loop();
    inf_wait();
}
