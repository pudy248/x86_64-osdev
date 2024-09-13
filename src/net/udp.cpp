#include <cstddef>
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/udp.hpp>
#include <sys/global.hpp>

vector<udp_conn_t> open_connections_udp;

udp_conn_t udp_accept(uint16_t port) {
	udp_conn_t conn = new udp_connection{port, {}};
	open_connections_udp.append(conn);
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
	net_buffer_t buf = ipv4_new(data_size + sizeof(udp_header));
	return { buf.frame_begin, buf.data_begin + sizeof(udp_header), data_size };
}

void udp_receive(struct ipv4_packet packet) {
	udp_header* udp = (udp_header*)packet.buf.data_begin;
	uint8_t* data = packet.buf.data_begin + sizeof(udp_header);
	
	uint16_t expected_size = htons(udp->length);
	uint16_t actual_size = packet.buf.data_size;

	if (expected_size > actual_size) {
		qprintf<128>(
			"[UDP] In packet from %I:%i->%i: Mismatch in ethernet and UDP packet sizes! %i vs %i\n",
			packet.src, htons(udp->src_port), htons(udp->dst_port), expected_size, actual_size);
		return;
	}

	qprintf<128>("[UDP] Packet received from %I:%i to port %i.\n", packet.src, htons(udp->src_port), htons(udp->dst_port));
	// globals->g_console->hexdump(udp, actual_size);
	// qprintf<32>("\n\n");

	bool stored = false;
	for (udp_conn_t c : open_connections_udp) {
		if (c->port == htons(udp->dst_port)) {
			c->packets.append({packet.src, htons(udp->src_port), {packet.buf.frame_begin, data, actual_size}});
			stored = true;
		}
	}
	if (!stored) kfree(packet.buf.frame_begin);
}
net_async_t udp_send(udp_conn_t conn, udp_packet packet) {
	udp_header* udp = (udp_header*)(packet.buf.data_begin - sizeof(udp_header));
	udp->dst_port = htons(packet.client_port);
	udp->src_port = htons(conn->port);
	udp->length = htons(packet.buf.data_size + sizeof(udp_header));
	udp->checksum = 0;

	ipv4_pseudo_header h{global_ip, packet.client_ip, 0, IPv4::PROTOCOL_UDP, htons(packet.buf.data_size)};
	udp->checksum = net_checksum(
		net_partial_checksum(&h, sizeof(h)) +
		net_partial_checksum(udp, packet.buf.data_size + sizeof(udp_header))
	);

	ipv4_packet p_ip;
	p_ip.src = global_ip;
	p_ip.dst = packet.client_ip;
	p_ip.protocol = IPv4::PROTOCOL_UDP;
	p_ip.buf = { packet.buf.frame_begin, packet.buf.data_begin - sizeof(udp_header),
				 packet.buf.data_size + sizeof(udp_header) };
	return ipv4_send(p_ip);
}

bool udp_get(udp_conn_t conn, udp_packet& out_packet) {
	if (conn->packets.size()) {
		out_packet = conn->packets.at(0);
		conn->packets.erase(0);
		return true;
	}
	else return false;
}
