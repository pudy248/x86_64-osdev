#include <cstddef>
#include <cstdint>
#include <drivers/keyboard.hpp>
#include <drivers/pci.hpp>
#include <drivers/vmware_svga.hpp>
#include <graphics/pipeline.hpp>
#include <graphics/transform.hpp>
#include <graphics/vectypes.hpp>
#include <kassert.hpp>
#include <kstddefs.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/fat.hpp>
#include <net/http.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <stl/array.hpp>
#include <stl/container.hpp>
#include <stl/vector.hpp>
#include <sys/debug.hpp>
#include <sys/global.hpp>
#include <sys/idt.hpp>
#include <sys/init.hpp>
#include <sys/ktime.hpp>
#include <sys/thread.hpp>
#include <text/graphical_console.hpp>

extern "C" int atexit(void (*)(void)) {
	return 0;
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
	kassert(ALWAYS_ACTIVE, TASK_EXCEPTION, svga_pci, "No VGA display device detected!\r\n");

	//svga_disable();

	RenderPipeline p;
	p.vertexBuffer = (vertex_ptr_a64)0x20000000;
	p.projVertBuffer = (proj_vertex_ptr_a64)0x22000000;
	p.triangleBuffer = (uint32_ptr_a64)0x2400000;
	p.fragBuffer = (fragment_ptr_a64)0x2600000;
	p.fragTexture = (uint32_ptr_a64)0x2A00000;

	uint32_t vi = 0;
	uint32_t ti = 0;
	fat_file f = file_open("/cow.obj");
	basic_istringstream obj(f.inode->data.begin(), f.inode->data.end());
	while (obj.readable()) {
		if (rostring(obj.begin(), obj.end()).starts_with("v "_RO)) {
			obj.read_c();
			obj.read_until_v(' ', false, true);
			float x = obj.read_f();
			obj.read_until_v(' ', false, true);
			float y = obj.read_f();
			obj.read_until_v(' ', false, true);
			float z = obj.read_f();
			obj.read_until_v(' ', true, true);
			p.vertexBuffer[vi++] = (Vertex){ (Vec4){ x, y, z, 0 }, (Vec4){ 255.f, 255.f, 255.f, 0 } };
		} else if (rostring(obj.begin(), obj.end()).starts_with("f "_RO)) {
			obj.read_c();
			obj.read_until_v(' ', false, true);
			int v1 = obj.read_i();
			obj.read_until_v(' ', false, true);
			int v2 = obj.read_i();
			obj.read_until_v(' ', false, true);
			int v3 = obj.read_i();
			obj.read_until_v(' ', true, true);
			p.triangleBuffer[3 * ti] = v1 - 1;
			p.triangleBuffer[3 * ti + 1] = v2 - 1;
			p.triangleBuffer[3 * ti + 2] = v3 - 1;
			ti++;
		} else {
			rostring s = obj.read_until_v(' ', true, true);
			printf("%S\n", &s);
		}
	}
	p.nVertices = vi;
	p.nTriangles = ti;
	printf("loaded model with %i verts, %i tris\r\n", vi, ti);
	svga_init(*svga_pci, 1280, 960);
	p.renderTexture = globals->svga->fb;
	p.display_w = globals->svga->width;
	p.display_h = globals->svga->height;

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

		void* params[] = { &iters, &rot };
		pipeline_flush(&p);
		pipeline_execute(&p, params);

		//for (int i = 0; i < ti; i++) {
		//	Vec3 w1 = vtrunc43(p.vertexBuffer[p.triangleBuffer[3 * i]].pos);
		//	Vec3 w2 = vtrunc43(p.vertexBuffer[p.triangleBuffer[3 * i + 1]].pos);
		//	Vec3 w3 = vtrunc43(p.vertexBuffer[p.triangleBuffer[3 * i + 2]].pos);
		//
		//	//tri3(w1, w2, w3, { 0xff, 0xff, 0xff });
		//}
		/*
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

static void dealloc_fat() {
	fat_inode* tmp = globals->fat_data.root_directory.inode;
	globals->fat_data.root_directory = fat_file();
	globals->fat_data.working_directory = fat_file();
	globals->fat_data.fat_tables.clear();
	tmp->purge();

	delete tmp;
}

static double frequency = 0;
static void set_freq() {
	for (int i = 0; i < 3; i++) {
		double freqi = clockspeed_MHz();
		frequency = max(frequency, freqi);
	}
}

static void console_init() {
	graphics_text_init();
	*globals->g_console =
		console(&graphics_text_get_char, &graphics_text_set_char, &graphics_text_update, graphics_text_dimensions);
}

static int generator(int start) {
	while (1)
		thread_switch<int>({ 0 });
	//thread_co_yield(start++);
}

[[gnu::noinline]] static void isolated(uint64_t& t1, uint64_t& t2, thread<int>& t) {
	t1 = rdtsc();
	thread_switch(t);
	thread_switch(t);
	thread_switch(t);
	thread_switch(t);
	thread_switch(t);
	t2 = rdtsc();
}

static void thread_main() {
	threading_init();
	thread<int> t = thread_create(&generator, 123);
	double time1 = timepoint::pit_time().unix_seconds();
	for (int i = 0; i < 50000000; i++) {
		thread_switch(t);
		//int retval = thread_co_await(t);
	}
	uint64_t t1, t2;
	isolated(t1, t2, t);
	thread_kill(t);
	double time2 = timepoint::pit_time().unix_seconds();
	printf("Thread exited. Ran 100 million context swaps in %f sec.\n10 swaps took an average of %i cycles each.\n",
		   (time2 - time1), (t2 - t1) / 10);
}

extern "C" void kernel_main(void) {
	idt_init();
	global_ctors();
	time_init();
	isr_set(32, &inc_pit);
	isr_set(33, &keyboard_irq);
#ifdef DEBUG
	load_debug_symbs("/symbols.txt");
	load_debug_symbs("/symbols2.txt");
#endif
	//globals->fat_data.root_directory.inode->purge();

	//graphics_main();
	dealloc_fat();
	//http_main();
	//console_init();
	thread_main();

	//tag_dump();
	print("Kernel reached end of execution.\n");
	//int cnt = 0, cnt2 = 0;
	//double lastTimepoint = timepoint::pit_time().unix_seconds();
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
		int l = formats(arr.begin(), "%02i:%02i:%02i.%03i", t.hour, t.minute, t.second, (int)(t.micros / 1000));
		for (int i = l - 1; i >= 0; --i)
			globals->g_console->set_char(x--, 3, arr[i]);
	}
	global_dtors();
	inf_wait();
}
