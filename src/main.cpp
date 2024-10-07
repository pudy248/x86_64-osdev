#include <cstddef>
#include <cstdint>
#include <drivers/pci.hpp>
#include <drivers/vmware_svga.hpp>
#include <graphics/pipeline.hpp>
#include <graphics/transform.hpp>
#include <graphics/vectypes.hpp>
#include <kassert.hpp>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <lib/fat.hpp>
#include <lib/profile.hpp>
#include <net/arp.hpp>
#include <net/dhcp.hpp>
#include <net/dns.hpp>
#include <net/http.hpp>
#include <net/icmp.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <net/udp.hpp>
#include <stl/vector.hpp>
#include <sys/global.hpp>
#include <sys/init.hpp>
#include <sys/ktime.hpp>
#include <sys/thread.hpp>
#include <text/console.hpp>
#include <text/gfx_terminal.hpp>

extern "C" int atexit(void (*)(void)) { return 0; }

static void http_main() {
	vector<tcp_conn_t> conns;
	while (true) {
		net_fwdall();
		{
			tcp_conn_t c = tcp_accept(80);
			if (!c) c = tcp_accept(8080);
			if (c) { conns.append(c); }
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
				tcp_istream stream({ conn }, { conn });
				vector<uint8_t> http_packet =
					stream.read_until_cv<view<tcp_input_iterator, tcp_input_iterator>>("\r\n\r\n"_RO, true);
				rostring s = span(http_packet).reinterpret_as<char>();
				printf("%S\n", &s);
				if (http_process(conn, s)) {
					conn->close();
					tcp_destroy(conn);
					conns.erase(i);
					i--;
				}
				stream.begin().flush();
			}
		}
	}
}
static void dhcp_main() {
	net_init();
	dhcp_set_active(dhcp_query());
	// ping(new_ipv4(8, 8, 8, 8));
	// ping("www.google.com");
	rostring s = "www.google.com";
	ipv4_t ip = dns_query(s);
	tcp_conn_t conn = tcp_connect(ip, 54321, HTTP_PORT);
	http_response r = http_req_get(conn, s);
	conn->close();
	printf("[HTTP] GET / from %S returned code %i and %i bytes.\n", &s, r.code, r.content.size());
	while (1) net_fwdall();
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
	istringstream obj(span(f.inode->data).reinterpret_as<char>());
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

static void console_init() {
	graphics_text_init();
	replace_console(console(&graphics_text_set_char, &graphics_text_update, graphics_text_dimensions));
}

static int generator(int start) {
	while (1) thread_switch<int>({ 0 });
	//thread_co_yield(start++);
}

static void thread_main() {
	threading_init();
	thread<int> t = thread_create(&generator, 123);
	timepoint time1, time2;
	PROFILE_LOOP(thread_switch(t), time1 = timepoint::now(), time2 = timepoint::now(), 50000000)
	uint64_t t1, t2;
	PROFILE_PRECISE(thread_switch(t), t1, t2, 50);
	thread_kill(t);
	printf("Thread exited. Ran 100 million context swaps in %f sec.\n100 swaps took an average of %i cycles each.\n",
		   units::seconds(time2 - time1).rep, (t2 - t1) / 100);
}

extern "C" void kernel_main(void) {
	kernel_reinit();
	globals->fat_data.root_directory.inode->purge();
	do_pit_readout = true;
	//inf_wait();

	//graphics_main();
	dealloc_fat();
	//console_init();
	//http_main();
	dhcp_main();
	//thread_main();

	//tag_dump();
	print("Kernel reached end of execution.\n");
	global_dtors();
	inf_wait();
}
