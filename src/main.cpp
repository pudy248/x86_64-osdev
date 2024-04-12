#include <cstddef>
#include <cstdint>
#include <drivers/keyboard.hpp>
#include <drivers/pci.hpp>
#include <drivers/vmware_svga.hpp>
#include <graphics/pipeline.hpp>
#include <graphics/transform.hpp>
#include <graphics/vectypes.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/fat.hpp>
#include <net/http.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <stl/vector.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>
#include <sys/idt.hpp>
#include <sys/init.hpp>
#include <sys/ktime.hpp>
#include <text/graphical_console.hpp>

extern "C" void atexit(void (*)(void)) {
}

static void http_main() {
	stacktrace();
	net_init();
	vector<tcp_connection*> conns;
	while (true) {
		net_process();
		{
			tcp_connection* c = NULL;
			if (!c)
				c = tcp_accept(80);
			if (!c)
				c = tcp_accept(8080);
			if (c) {
				conns.append(c);
			}
		}
		for (int i = 0; i < conns.size(); i++) {
			tcp_connection* conn = conns.at(i);
			if (conn->state == TCP_STATE::CLOSED) {
				tcp_destroy(conn);
				conns.erase(i);
				i--;
				continue;
			}
			if (conn->recieved_packets.size()) {
				tcp_packet p = conn->recv();
				if (http_process(conn, p)) {
					conn->close();
					tcp_destroy(conn);
					conns.erase(i);
					i--;
				}
				free(p.contents.begin());
			}
		}
	}
}

static void graphics_main() {
	pci_device* svga_pci = pci_match(PCI_CLASS::DISPLAY, PCI_SUBCLASS::DISPLAY_VGA);
	kassert(svga_pci, "No VGA display device detected!\r\n");
	svga_init(*svga_pci, 640, 480);

	//svga_disable();

	RenderPipeline p;
	p.vertexBuffer	 = (aVertex_p)0x20000000;
	p.projVertBuffer = (aProjVertex_p)0x22000000;
	p.triangleBuffer = (auint32_p)0x2400000;
	p.fragBuffer	 = (aFragment_p)0x2600000;
	p.fragTexture	 = (auint32_p)0x2A00000;
	p.renderTexture	 = svga_dev->fb;
	p.display_w		 = svga_dev->width;
	p.display_h		 = svga_dev->height;

	uint32_t vi = 0;
	uint32_t ti = 0;
	FILE f		= file_open("/cow.obj");
	istringstream obj(f.inode->data);
	while (obj.readable()) {
		if (rostring(obj.data).starts_with(rostring("v "))) {
			obj.read_c();
			obj.read_while<rostring, rostring>([](rostring s) { return s.starts_with(' '); });
			float x = obj.read_f();
			obj.read_while<rostring, rostring>([](rostring s) { return s.starts_with(' '); });
			float y = obj.read_f();
			obj.read_while<rostring, rostring>([](rostring s) { return s.starts_with(' '); });
			float z = obj.read_f();
			obj.read_until<rostring, rostring>([](rostring s) { return s.starts_with('\n'); }, true);
			p.vertexBuffer[vi++] = (Vertex){ (Vec4){ x, y, z, 0 }, (Vec4){ 255.f, 255.f, 255.f, 0 } };
		} else if (rostring(obj.data).starts_with(rostring("f "))) {
			obj.read_c();
			obj.read_while<rostring, rostring>([](rostring s) { return s.starts_with(' '); });
			int v1 = obj.read_i();
			obj.read_while<rostring, rostring>([](rostring s) { return s.starts_with(' '); });
			int v2 = obj.read_i();
			obj.read_while<rostring, rostring>([](rostring s) { return s.starts_with(' '); });
			int v3 = obj.read_i();
			obj.read_until<rostring, rostring>([](rostring s) { return s.starts_with('\n'); }, true);
			p.triangleBuffer[3 * ti]	 = v1;
			p.triangleBuffer[3 * ti + 1] = v2;
			p.triangleBuffer[3 * ti + 2] = v3;
			ti++;
		} else {
			obj.read_until<rostring, rostring>([](rostring s) { return s.starts_with('\n'); }, true);
		}
	}
	p.nVertices	 = vi;
	p.nTriangles = ti;
	printf("loaded model with %i verts, %i tris\r\n", vi, ti);

	projectionMatrix = project(4, 3, 2);
	int iters		 = 0;
	while (true) {
		iters++;

		//double thetaX = sin((double)iters * 0.0281);
		//double thetaY = cos((double)iters * 0.1) + (double)iters * 0.05;
		//double thetaZ = sin((double)iters * 0.0314);
		double thetaX = iters * 0.01f;
		double thetaY = iters * 0.01f;
		double thetaZ = iters * 0.01f;

		Mat4x4 rot = rotate(thetaX, thetaY, thetaZ);

		void* params[] = { &iters, &rot };
		pipeline_flush(&p);
		//pipeline_execute(&p, params);
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

static void console_main() {
	graphics_text_init();
	*globals->g_console =
		console(&graphics_text_get_char, &graphics_text_set_char, &graphics_text_update, graphics_text_dimensions);

	for (int i = 0; i < 3; i++)
		clockspeed_MHz();

	fat_inode* tmp						= globals->fat_data.root_directory.inode;
	globals->fat_data.root_directory	= FILE();
	globals->fat_data.working_directory = FILE();
	globals->fat_data.fat_tables.clear();
	delete tmp;

	//stacktrace();
	//inf_wait();
	//http_main();
}

extern "C" void kernel_main(void) {
	idt_init();
	irq_set(0, &inc_pit);
	irq_set(1, &keyboard_irq);
	time_init();
	global_ctors();
	//load_debug_symbs("/symbols.txt");
	globals->fat_data.root_directory.inode->purge();

	//http_main();
	//graphics_main();
	console_main();

	print("Kernel reached end of execution.\n");
	int cnt = 0, cnt2 = 0;
	double lastTimepoint = timepoint::pit_time_imprecise().unix_seconds();
	while (1) {
		timepoint t = timepoint::pit_time_imprecise();
		//double curTimepoint = t.unix_seconds();
		//if ((int)t.unix_seconds() > cnt) {
		//    cnt++;
		//    qprintf<64>("%i iters (%f ns), %f us\n", cnt2, 1000000000. / cnt2, (curTimepoint - lastTimepoint) * 1000000.);
		//    cnt2 = 0;
		//}
		//lastTimepoint = curTimepoint;
		//cnt2++;
		array<char, 32> arr;
		int x = globals->g_console->text_rect[2] - 1;
		int l = formats(arr, "%02i:%02i:%02i.%03i", t.hour, t.minute, t.second, (int)(t.micros / 1000));
		for (int i = l - 1; i >= 0; --i)
			globals->g_console->set_char(x--, 3, arr[i]);
	}
	global_dtors();
	inf_wait();
}
