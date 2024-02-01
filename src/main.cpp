#include <kstdlib.hpp>
#include <kprint.h>
#include <sys/idt.h>
#include <sys/ktime.hpp>
#include <sys/global.h>

#include <drivers/keyboard.h>
#include <drivers/pci.h>
#include <drivers/vmware_svga.h>

#include <net/net.hpp>
#include <net/tcp.hpp>
#include <net/http.hpp>

#include <graphics/transform.h>
#include <graphics/pipeline.h>

extern "C" void atexit(void (*)(void) __attribute__((cdecl))) {}

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

static void svga_main() {
    pci_device* svga_pci = pci_match(PCI_CLASS::DISPLAY, PCI_SUBCLASS::DISPLAY_VGA);
    kassert(svga_pci, "No VGA display device detected!\r\n");
    svga_init(*svga_pci);
    
    //svga_disable();

    RenderPipeline p;
    p.vertexBuffer = (aVertex_p)0x20000000;
    p.projVertBuffer = (aProjVertex_p)0x22000000;
    p.triangleBuffer = (auint32_p)0x2400000;
    p.fragBuffer = (aFragment_p)0x2600000;
    p.fragTexture = (auint32_p)0x2A00000;
    p.renderTexture = svga_dev->fb;
    p.display_w = svga_dev->width;
    p.display_h = svga_dev->height;

    uint32_t vi = 0;
    uint32_t ti = 0;
    FILE f = file_open("/cow.obj");
    istringstream obj(f.inode->data);
    while (obj.readable()) {
        if (rostring(obj).starts_with(rostring("v "))) {
            obj.read<char>();
            obj.read_while([](rostring s){ return s.starts_with(' '); });
            float x = obj.read<double>();
            obj.read_while([](rostring s){ return s.starts_with(' '); });
            float y = obj.read<double>();
            obj.read_while([](rostring s){ return s.starts_with(' '); });
            float z = obj.read<double>();
            obj.read_until([](rostring s){ return s.starts_with('\n'); });
            p.vertexBuffer[vi++] = (Vertex){(Vec4){x, y, z, 0}, (Vec4){255.f, 255.f, 255.f, 0}};
            obj.read<char>();
        }
        else if (rostring(obj).starts_with(rostring("f "))) {
            obj.read<char>();
            obj.read_while([](rostring s){ return s.starts_with(' '); });
            int v1 = obj.read<int64_t>();
            obj.read_while([](rostring s){ return s.starts_with(' '); });
            int v2 = obj.read<int64_t>();
            obj.read_while([](rostring s){ return s.starts_with(' '); });
            int v3 = obj.read<int64_t>();
            obj.read_until([](rostring s){ return s.starts_with('\n'); });
            p.triangleBuffer[3 * ti] = v1;
            p.triangleBuffer[3 * ti + 1] = v2;
            p.triangleBuffer[3 * ti + 2] = v3;
            ti++;
            obj.read<char>();
        }
        else {
            obj.read_until([](rostring s){ return s.starts_with('\n'); });
            obj.read<char>();
        }
    }
    p.nVertices = vi;
    p.nTriangles = ti;
    printf("loaded model with %i verts, %i tris\r\n", vi, ti);

    projectionMatrix = project(4, 3, 2);
    int iters = 0;
    while (true) {
        iters++;

        //double thetaX = sin((double)iters * 0.0281);
        //double thetaY = cos((double)iters * 0.1) + (double)iters * 0.05;
        //double thetaZ = sin((double)iters * 0.0314);
        double thetaX = iters * 0.01f;
        double thetaY = iters * 0.01f;
        double thetaZ = iters * 0.01f;

        Mat4x4 rot = rotate(thetaX, thetaY, thetaZ);

        void* params[] = {&iters, &rot};
        pipeline_flush(&p);
        pipeline_execute(&p, params);
        /*
        for (int i = 0; i < ti; i++) {
            Vec3 w1 = vertices[triangles[3 * i]];
            Vec3 w2 = vertices[triangles[3 * i + 1]];
            Vec3 w3 = vertices[triangles[3 * i + 2]];
            
            //tri3(w1, w2, w3, color);
        }
        
        int now = get_rtc_second();
        if (now != second) {
            second = now;
            fps = iters - frameStart;
            frameStart = iters;
        }
        vesa_printf(10, 10, "frame %i (%i fps)", iters2, fps);
        */
        svga_update();
    }
    
}

extern "C" __attribute__((noreturn)) __attribute__((force_align_arg_pointer)) void kernel_main(void);
extern "C" __attribute__((noreturn)) __attribute__((force_align_arg_pointer)) void kernel_main(void) {
    idt_init();
    irq_set(0, &inc_pit);
    irq_set(1, &keyboard_irq);
    time_init();
    globals->fat_data.root_directory.inode->purge();

    http_main();
    //svga_main();
    
    //terminal_init(rootDir);
    //terminal_input_loop();
    inf_wait();
}
