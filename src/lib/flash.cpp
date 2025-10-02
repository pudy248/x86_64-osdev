#include "flash.hpp"
#include <kfile.hpp>
#include <lib/cmd/commands.hpp>
#include <net/tcp.hpp>
#include <stl/ranges.hpp>
#include <sys/ktime.hpp>
#include <sys/thread.hpp>

void tcp_flash_loop(uint16_t port) {
	while (true) {
		thread_yield();
		tcp_conn_t conn = tcp_accept(port);
		if (!conn)
			continue;
		printf("Recieving kernel flash from %I.\n", conn->cli_ip);
		file_t kernel = fs::open("/kernel.img"_RO);
		kernel.data().clear();
		ranges::val::copy(ranges::unbounded_range{std::back_inserter(kernel.data())}, tcp_range{conn});
		printf("Updating kernel with %i bytes.\n", kernel.data().size());
		kernel.n->write();
		conn->close();
		tcp_destroy(conn);
		delay(units::seconds(1));
		cmd_triple_fault(0, nullptr);
	}
}