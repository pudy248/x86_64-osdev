#include "asm.hpp"
#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/config.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/udp.hpp>
#include <stl/optional.hpp>
#include <stl/ranges.hpp>
#include <sys/global.hpp>

vector<udp_conn_t> open_connections_udp;

vector<uint16_t> blocked_ports_udp = vector<uint16_t>({7423});

void udp_block(uint16_t port, bool is_blocked) {
	if (is_blocked) {
		int idx = ranges::where_is(blocked_ports_udp, port);
		if (idx >= 0)
			blocked_ports_udp.erase(idx);
	} else {
		if (!ranges::count(blocked_ports_udp, port))
			blocked_ports_udp.push_back(port);
	}
}
udp_conn_t udp_accept(uint16_t port) {
	udp_conn_t conn = new udp_connection{port, {}};
	open_connections_udp.push_back(conn);
	return conn;
}
void udp_close(udp_conn_t conn) {
	for (std::size_t i = 0; i < open_connections_udp.size(); i++) {
		if (open_connections_udp.at(i) == conn) {
			open_connections_udp.erase(i);
			return;
		}
	}
}

net_buffer_t udp_new(std::size_t data_size) {
	net_buffer_t buf = ipv4_new(data_size + 16);
	return {buf.frame_begin, buf.data_begin + 16, data_size};
}

udp_packet udp_read(ipv4_packet p) {
	udp_packet udp = {(udp_info)p.i, p.b};
	udp.i.src_port = udp.b.read<uint16_t>();
	udp.i.dst_port = udp.b.read<uint16_t>();
	uint16_t expected_size = udp.b.read<uint16_t>() - 8;
	udp.b.read<uint16_t>(); // checksum

	uint16_t actual_size = p.b.data_size;

	if (expected_size > actual_size) {
		qprintf<128>("[UDP] In packet from %I:%i->%i: Mismatch in ethernet and UDP packet sizes! %i vs %i\n",
			p.i.src_ip, udp.i.src_port, udp.i.dst_port, expected_size, actual_size);
		inf_wait();
		return udp_packet(0);
	}
	udp.b.data_size = expected_size;

	if (UDP_LOG)
		qprintf<128>("[UDP] %i bytes received from %I:%i to port %i.\n", expected_size, (uint64_t)p.i.src_ip,
			(uint64_t)udp.i.src_port, (uint64_t)udp.i.dst_port);

	return udp;
}
ipv4_packet udp_write(udp_packet p) {
	p.b.write<uint16_t>(0);
	p.b.write<uint16_t>(p.b.data_size + 6);
	p.b.write<uint16_t>(p.i.dst_port);
	p.b.write<uint16_t>(p.i.src_port);

	p.i.protocol = IPv4_PROTOCOL::UDP;
	p.i.src_ip = global_ip;

	ipv4_pseudo_header h{p.i.src_ip, p.i.dst_ip, 0, p.i.protocol, htons(p.b.data_size)};
	((uint16_t*)p.b.data_begin)[3] =
		net_checksum(net_partial_checksum(&h, sizeof(h)) + net_partial_checksum(p.b.data_begin, p.b.data_size));

	return {p.i, p.b};
}
net_async_t udp_send(udp_packet p) { return ipv4_send(udp_write(p)); }

optional<udp_packet> udp_get(uint16_t port) {
	optional<ipv4_packet> opt = ipv4_get();
	if (!opt)
		return {};
	if (opt->i.protocol != IPv4_PROTOCOL::UDP) {
		ipv4_forward(opt);
		return {};
	}
	udp_packet p2 = udp_read(opt);
	if (p2.i.dst_port != port) {
		udp_forward(p2);
		return {};
	}
	return p2;
}

optional<udp_packet> udp_get(udp_conn_t conn) {
	if (conn->packets.size()) {
		udp_packet p = conn->packets.at(0);
		conn->packets.erase(0);
		return p;
	} else
		return udp_get(conn->port);
}

void udp_forward(udp_packet p) {
	for (udp_conn_t c : open_connections_udp) {
		if (c->port == htons(p.i.dst_port)) {
			c->packets.push_back(p);
			return;
		}
	}
	//kfree(p.b.frame_begin);
}