#include "rsh.hpp"
#include "commandline.hpp"
#include <kstdio.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <stl/optional.hpp>
#include <sys/thread.hpp>
#include <text/text_display.hpp>

extern bool do_logging;
[[noreturn]] void rsh_loop() {
	while (true) {
		tcp_conn_t conn;
		while (true) {
			thread_yield();
			conn = tcp_accept(23);
			if (!conn)
				continue;
			printf("Remote shell connected to %I:%i\n", conn->cli_ip, conn->cli_port);
			break;
		}
		print("> ");
		std::size_t output_offset = 0;

		while (conn->state != TCP_STATE::CLOSED) {
			thread_yield();
			string s;
			while (output_offset < output_log().size()) {
				// printf("%i %i\n", output_offset, output_log().size());
				std::size_t tmp = output_log().size();
				std::size_t delta = min(tmp - output_offset, 1024ul);
				conn->send(span<const char>(output_log().begin() + output_offset, delta));
				output_offset += delta;
			}
			optional<tcp_fragment> opt = conn->get();
			if (!opt)
				continue;
			if (opt->size() >= 5 && !memcmp(opt->begin(), "exit\n", 5)) {
				print("Remote shell disconnected\n");
				conn->close();
				break;
			}
			for (std::size_t i = 0; opt && i < opt->size(); i++) {
				char c = ((char*)opt->begin())[i];

				if (c == '\n') {
					s.push_back(0);
					auto l = rostring(s);
					do_logging = false;
					printf("> %S\n", &l);
					do_logging = true;
					if (l.size())
						thread_create(&sh_exec, l);
					s.clear();
				} else if (c == '\b') {
					if (s.size())
						s.erase(s.size() - 1);
				} else
					s.push_back(c);
			}
		}
		printf("Remote shell disconnected from %I:%i\n", conn->cli_ip, conn->cli_port);
		tcp_destroy(conn);
	}
}
