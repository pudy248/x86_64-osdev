#include <asm.hpp>
#include <cstdint>
#include <drivers/ahci.hpp>
#include <drivers/ihd.cpp>
#include <drivers/ihd.hpp>
#include <drivers/pci.hpp>
#include <drivers/vmware_svga.hpp>
#include <kassert.hpp>
#include <kfile.hpp>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <lib/cmd/commandline.hpp>
#include <lib/cmd/rsh.hpp>
#include <lib/filesystems/fat.hpp>
#include <lib/flash.hpp>
#include <lib/profile.hpp>
#include <net/dhcp.hpp>
#include <net/dns.hpp>
#include <net/http.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <stl/iterator.hpp>
#include <stl/map.hpp>
#include <stl/vector.hpp>
#include <sys/global.hpp>
#include <sys/init.hpp>
#include <sys/ktime.hpp>
#include <sys/thread.hpp>
#include <text/console.hpp>
#include <text/gfx_terminal.hpp>

extern "C" int atexit(void (*)()) { return 0; }

static void http_main() {
	vector<tcp_conn_t> conns;
	while (true) {
		net_fwdall();
		{
			tcp_conn_t c = tcp_accept(80);
			if (!c)
				c = tcp_accept(8080);
			if (c)
				conns.push_back(c);
		}
		for (std::size_t i = 0; i < conns.size(); i++) {
			tcp_conn_t conn = conns.at(i);
			if (conn->state == TCP_STATE::CLOSED) {
				tcp_destroy(conn);
				conns.erase(i);
				i--;
				continue;
			}
			if (conn->received_packets.size()) {
				basic_istringstream<char, tcp_input_iterator, null_sentinel> stream({conn}, {});
				vector<char> h;
				ranges::mut::copy_through_block(ranges::unbounded_range(h.oend()), stream, "\r\n\r\n"_RO);
				vector<char> http_packet{h.begin(), h.end()};
				rostring s = http_packet;
				printf("%S\n", &s);
				if (http_process(conn, s)) {
					conn->close();
					tcp_destroy(conn);
					conns.erase(i);
					i--;
				}
			}
		}
	}
}
/*
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
	file_t f = fs::open("/cow.obj"_RO);
	istringstream obj(f.rodata());
	while (obj.readable()) {
		if (obj.match("v ")) {
			ranges::mut::iterate_through(obj, algo::equal_to_v{ ' ' });
			float x = obj.read_f();
			ranges::mut::iterate_through(obj, algo::equal_to_v{ ' ' });
			float y = obj.read_f();
			ranges::mut::iterate_through(obj, algo::equal_to_v{ ' ' });
			float z = obj.read_f();
			ranges::mut::iterate_through(obj, algo::equal_to_v{ ' ' });
			p.vertexBuffer[vi++] = (Vertex){ (Vec4){ x, y, z, 0 }, (Vec4){ 255.f, 255.f, 255.f, 0 } };
		} else if (obj.match("f ")) {
			ranges::mut::iterate_through(obj, algo::equal_to_v{ ' ' });
			int v1 = obj.read_i();
			ranges::mut::iterate_through(obj, algo::equal_to_v{ ' ' });
			int v2 = obj.read_i();
			ranges::mut::iterate_through(obj, algo::equal_to_v{ ' ' });
			int v3 = obj.read_i();
			ranges::mut::iterate_through(obj, algo::equal_to_v{ ' ' });
			p.triangleBuffer[3 * ti] = v1 - 1;
			p.triangleBuffer[3 * ti + 1] = v2 - 1;
			p.triangleBuffer[3 * ti + 2] = v3 - 1;
			ti++;
		} else {
			rostring s = { obj.begin(), ranges::find(obj, ' ') };
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
        int now = get_rtc_second();
        if (now != second) {
            second = now;
            fps = iters - frameStart;
            frameStart = iters;
        }
        vesa_printf(10, 10, "frame %i (%i fps)", iters2, fps);
svga_update();
}
}
*/

static void dealloc_fat() {
	file_inode* tmp = globals->fat32->root_directory.n;
	globals->fat32->root_directory = file_t();
	globals->fs = {};
	globals->fat32->fat_tables.clear();
	tmp->purge();

	delete tmp;
}

static void console_init() {
	do_pit_readout = false;

	if (pci_device* svga_pci = pci_match_id(0x15AD, 0x0405))
		svga_init(*svga_pci, 1366, 768);
	else {
		pci_device* ihd_gfx_pci = pci_match(PCI_CLASS::DISPLAY, PCI_SUBCLASS::DISPLAY_VGA, 0);
		kassert(ALWAYS_ACTIVE, TASK_EXCEPTION, ihd_gfx_pci && ihd_gfx_pci->vendor_id == 0x8086,
			"Intel HD Graphics PCI device not found!\n");
		ihd_gfx_init(*ihd_gfx_pci);
		ihd_gfx_modeset();
	}
	graphics_text_init();
	replace_console(console(&graphics_text_set_char, &graphics_text_update, graphics_text_dimensions));
	do_pit_readout = true;
}

[[noreturn]] static int generator(int start) {
	while (1)
		thread_co_yield(start++);
}

static void thread_main() {
	threading_init();
	thread<int> t = thread_create(&generator, 123);
	timepoint time1, time2;
	PROFILE_LOOP(thread_switch(t), time1 = timepoint::now(), time2 = timepoint::now(), 500000)
	uint64_t t1, t2;
	PROFILE_PRECISE(thread_switch(t), t1, t2, 50);
	thread_kill(t);
	printf("Thread exited. Ran 1 million context swaps in %f sec.\n100 swaps took an average of %i cycles each.\n",
		units::seconds(time2 - time1).rep, (t2 - t1) / 100);
	inf_wait();
}

int cmd_http_fetch(int argc, const ccstr_t* argv) {
	if (argc != 2) {
		print("Bad argument count.\n");
		return -1;
	}
	rostring s(argv[1]);
	ipv4_t ip = dns_query(s);
	tcp_conn_t conn = tcp_connect(ip, 54321, HTTP_PORT);
	http_response r = http_req_get(conn, s);
	conn->close();
	tcp_destroy(conn);
	printf("[HTTP] GET / from %S returned code %i and %i bytes.\n", &s, r.code, r.content.size());
	return 0;
}

void net_fwd_loop() {
	while (true) {
		net_fwdall();
		thread_yield();
	}
}

extern bool do_logging;

extern "C" void kernel_main(void) {
	kernel_reinit();
	do_pit_readout = true;
	//globals->fat32->root_directory.n->purge();
	//inf_wait();

	//graphics_main();
	//dealloc_fat();
	//thread_main();
	threading_init();
	//net_init();
	//dhcp_set_active(dhcp_query());
	//cli_init();
	//cli_loop();
	//http_main();

	//thread_create(&rsh_loop);
	//thread_create(&tcp_flash_loop, 20);
	//thread_create(&net_fwd_loop);

	console_init();
	cli_init();
	thread_create(&cli_loop);

	//tag_dump();

	print("Kernel initialization thread reached end of execution.\n");
	thread_exit(0);
	while (num_thread_contexts() > 1)
		thread_yield();

	global_dtors();
	inf_wait();
}