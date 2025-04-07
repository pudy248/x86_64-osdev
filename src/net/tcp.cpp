#include <cstddef>
#include <cstdint>
#include <kstddef.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/config.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <stl/algorithms.hpp>
#include <stl/ranges.hpp>
#include <stl/vector.hpp>
#include <utility>

#define TCP_DATA_OFFSET(s) ((s + 5) << 4)
#define TCP_FLAG_FIN (1 << 8)
#define TCP_FLAG_SYN (1 << 9)
#define TCP_FLAG_RST (1 << 10)
#define TCP_FLAG_PSH (1 << 11)
#define TCP_FLAG_ACK (1 << 12)
#define TCP_FLAG_URG (1 << 13)
#define TCP_FLAG_ECE (1 << 14)
#define TCP_FLAG_CWR (1 << 15)

vector<tcp_conn_t> open_connections;

#define TCP_MSS 8000UL
#define TCP_CLI_MSS 8000UL

struct tcp_mss {
	uint8_t op = 0x02;
	uint8_t len = 0x04;
	uint16_t mss;
};
constexpr bool TCP_STATE::valid(int s) { return s == ESTABLISHED; }
tcp_flags::tcp_flags(uint16_t f) { kmemcpy(this, &f, 2); }

net_buffer_t tcp_new(std::size_t data_size) {
	net_buffer_t buf = ipv4_new(data_size + sizeof(tcp_header));
	return { buf.frame_begin, buf.data_begin + sizeof(tcp_header), data_size };
}
net_async_t tcp_transmit(tcp_conn_t conn, tcp_packet p) {
	tcp_header* tcp = (tcp_header*)(p.b.data_begin - sizeof(tcp_header));
	tcp->src_port = htons(conn->cur_port);
	tcp->dst_port = htons(conn->cli_port);
	tcp->ack_num = htonl(conn->cur_ack);
	tcp->seq_num = htonl(conn->cur_seq);
	tcp->flags = tcp_flags(p.i.flags);
	tcp->window_size = 0xffff;
	tcp->checksum = 0;
	tcp->urgent = 0;

	ipv4_pseudo_header h{ conn->cur_ip, conn->cli_ip, 0, IPv4::PROTOCOL_TCP,
						  htons(p.b.data_size + sizeof(tcp_header)) };
	tcp->checksum = net_checksum(net_partial_checksum(&h, sizeof(h)) +
								 net_partial_checksum(tcp, p.b.data_size + sizeof(tcp_header)));

	ipv4_info npi = p.i;
	npi.src_ip = conn->cur_ip;
	npi.dst_ip = conn->cli_ip;
	npi.protocol = IPv4::PROTOCOL_TCP;
	net_buffer_t buf = { p.b.frame_begin, p.b.data_begin - sizeof(tcp_header), p.b.data_size + sizeof(tcp_header) };
	return ipv4_send({ npi, buf });
}
static net_async_t tcp_transmit(tcp_conn_t conn, span<std::byte> data, uint16_t flags) {
	net_buffer_t buf = tcp_new(data.size());
	algo::copy(buf.data_begin, buf.data_begin + buf.data_size, data.begin(), data.end());
	return tcp_transmit(conn, { tcp_info{ .flags = flags }, buf });
}

void tcp_receive(ipv4_packet p) {
	tcp_header* tcp = (tcp_header*)p.b.data_begin;

	uint16_t header_size = 4 * tcp->flags.data_offset;
	uint16_t size = p.b.data_size - header_size;
	std::byte* contents = p.b.data_begin + header_size;

	for (std::size_t i = 0; i < open_connections.size(); i++) {
		tcp_conn_t conn = open_connections.at(i);

		if (conn->state == TCP_STATE::LISTENING) {
			if ((!conn->cur_port || conn->cur_port == htons(tcp->dst_port)) && tcp->flags.syn && !tcp->flags.ack) {
				conn->cli_ip = p.i.src_ip;
				conn->cur_ip = p.i.dst_ip;
				conn->cli_port = htons(tcp->src_port);
				conn->cur_port = htons(tcp->dst_port);
				conn->start_seq = htonl(open_connections.size());
				conn->start_ack = htonl(tcp->seq_num);
				conn->cur_ack = conn->start_ack + 1;
				conn->cur_seq = conn->start_seq;
				conn->cli_ack = conn->start_seq;

				if (TCP_LOG_VERBOSE)
					printf("[TCP] Opening connection to port %i with %I:%i.\n", conn->cur_port, conn->cli_ip,
						   conn->cli_port);
				tcp_mss mss = { 0x02, 0x04, htons(TCP_MSS) };
				conn->state = TCP_STATE::SYNACK_SENT;
				tcp_transmit(conn, span<std::byte>((std::byte*)&mss, 4),
							 TCP_DATA_OFFSET(1) | TCP_FLAG_SYN | TCP_FLAG_ACK);
				goto cleanup;
			}
		}

		if (conn->state == TCP_STATE::UNINITIALIZED)
			continue;
		if (conn->cur_port != htons(tcp->dst_port))
			continue;
		if (conn->cli_ip != p.i.src_ip)
			continue;
		if (conn->cli_port != htons(tcp->src_port))
			continue;

		else if (conn->state == TCP_STATE::WAITING) {
			if (tcp->flags.rst) {
				tcp_transmit(conn, span<std::byte>(), TCP_DATA_OFFSET(1) | TCP_FLAG_RST);
				tcp_destroy(conn);
			}
			goto cleanup;
		}

		if (tcp->flags.rst) {
			printf("[TCP] %I:%i->%i: RST recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
			tcp_transmit(conn, span<std::byte>(), TCP_DATA_OFFSET(0) | TCP_FLAG_RST | TCP_FLAG_ACK);
			conn->state = TCP_STATE::CLOSED;
			goto cleanup;
		} else if (conn->state == TCP_STATE::SYN_SENT) {
			if (!tcp->flags.syn || !tcp->flags.ack) {
				print("[TCP] Spurious packet recieved during handshake, expected SYN/ACK\n");
			} else {
				conn->cur_seq++;
				conn->cur_ack = htonl(tcp->seq_num) + 1;
				tcp_transmit(conn, span<std::byte>(), TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);
				if (TCP_LOG_VERBOSE)
					printf("[TCP] %I:%i->%i: SYN/ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
				conn->state = TCP_STATE::ESTABLISHED;
			}
			goto cleanup;
		} else if (conn->state == TCP_STATE::SYNACK_SENT) {
			if (tcp->flags.syn || !tcp->flags.ack || tcp->flags.psh) {
				print("[TCP] Spurious packet recieved during handshake, expected ACK\n");
			} else {
				if (TCP_LOG_VERBOSE)
					printf("[TCP] %I:%i->%i: Handshake ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
				conn->cur_seq++;
				conn->packet_offset = 0;
				conn->state = TCP_STATE::ESTABLISHED;
			}
			goto cleanup;
		} else if (conn->state == TCP_STATE::FIN_SENT) {
			if (tcp->flags.fin) {
				conn->cur_ack = htonl(tcp->seq_num) + 1;
				conn->cur_seq++;
				tcp_transmit(conn, { span<std::byte>() }, TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);
				if (TCP_LOG_VERBOSE)
					printf("[TCP] %I:%i->%i: FIN/ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
				conn->state = TCP_STATE::CLOSED;
				goto cleanup;
			}
		} else if (conn->state == TCP_STATE::FINACK_SENT) {
			if (tcp->flags.ack) {
				if (TCP_LOG_VERBOSE)
					printf("[TCP] %I:%i->%i: Final ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
				conn->state = TCP_STATE::CLOSED;
			}
			goto cleanup;
		}

		if (tcp->flags.psh || size) {
			if (conn->state != TCP_STATE::ESTABLISHED) {
				printf("[TCP] PSH recieved during invalid state %i.\n", conn->state);
				goto cleanup;
			}
			if (TCP_LOG_VERBOSE)
				printf("[TCP] %I:%i->%i: PSH recieved: %i bytes.\n", conn->cli_ip, conn->cli_port, conn->cur_port,
					   size);
			uint32_t tmp_ack = conn->cur_ack;

			conn->cur_ack = htonl(tcp->seq_num) + size;
			tcp_transmit(conn, { span<std::byte>() }, TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);

			if (htonl(tcp->seq_num) != tmp_ack || conn->partial.start_seq) {
				if (!conn->partial.start_seq) {
					conn->partial.start_seq = tmp_ack;
					conn->partial.end_seq = htonl(tcp->seq_num) + size;
					conn->partial.contents = vector<char>(conn->partial.end_seq - conn->partial.start_seq);
				}
				conn->partial.contents.reserve(htonl(tcp->seq_num) + size - conn->partial.start_seq);
				algo::copy((std::byte*)conn->partial.contents.begin() + (htonl(tcp->seq_num) - conn->partial.start_seq),
						   contents, contents + size);
				if (htonl(tcp->seq_num) + size == conn->partial.end_seq)
					conn->partial.end_seq = htonl(tcp->seq_num);
				if (htonl(tcp->seq_num) == conn->partial.start_seq)
					conn->partial.start_seq = htonl(tcp->seq_num);
				if (conn->partial.start_seq == conn->partial.end_seq) {
					char* buf = conn->partial.contents.c_arr();
					conn->partial.contents.clear();
					conn->partial.start_seq = conn->partial.end_seq = 0;

					conn->received_packets.append({ buf, buf + size });
				}
			} else {
				//tcp_send(conn, { span(contents, size) }, set_flags(TCP_DATA_OFFSET(0) | TCP_FLAG_PSH | TCP_FLAG_ACK));
				conn->received_packets.append({ (char*)contents, (char*)contents + size });
			}
		} else if (tcp->flags.fin) {
			conn->cur_ack = htonl(tcp->seq_num) + 1;
			tcp_transmit(conn, { span<std::byte>() }, TCP_DATA_OFFSET(0) | TCP_FLAG_FIN | TCP_FLAG_ACK);
			if (TCP_LOG_VERBOSE)
				printf("[TCP] %I:%i->%i: FIN recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
			conn->state = TCP_STATE::FINACK_SENT;
		} else if (tcp->flags.ack && conn->state != TCP_STATE::CLOSED) {
			if (htonl(tcp->seq_num) == conn->cur_ack - 1) {
				tcp_transmit(conn, span<std::byte>(), TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);
			} else if (conn->cur_seq != conn->cli_ack) {
				conn->cli_ack = htonl(tcp->ack_num);
			} else {
				if (TCP_LOG_VERBOSE)
					printf("[TCP] %I:%i->%i: Unknown ACK. CURSEQ %i CLIACK %i), tcp (SEQ %i ACK %i).\n", conn->cli_ip,
						   conn->cli_port, conn->cur_port, conn->cur_seq, conn->cli_ack, htonl(tcp->seq_num),
						   htonl(tcp->ack_num));
			}
		} else
			continue;
		goto cleanup;
	}

	if (tcp->flags.syn) {
		tcp_conn_t conn = new tcp_connection();
		conn->cli_ip = p.i.src_ip;
		conn->cur_ip = p.i.dst_ip;
		conn->cli_port = htons(tcp->src_port);
		conn->cur_port = htons(tcp->dst_port);
		conn->start_ack = htonl(tcp->seq_num);
		conn->state = TCP_STATE::WAITING;
		open_connections.append((tcp_conn_t)conn);
		if (TCP_LOG_VERBOSE)
			printf("[TCP] %I:%i->%i: SYN recieved, waiting.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
		goto cleanup;
	}
	printf("[TCP] Invalid packet: SRC %i, Flags=%02x, SYN=%i, ACK=%i\n", htons(tcp->src_port),
		   *(uint16_t*)&tcp->flags >> 8, htonl(tcp->seq_num), htonl(tcp->ack_num));

cleanup:
	kfree(p.b.frame_begin);
}

tcp_conn_t tcp_accept(uint16_t port) {
	for (std::size_t i = 0; i < open_connections.size(); i++) {
		tcp_conn_t conn = (tcp_conn_t)open_connections.at(i);
		if (conn->state != TCP_STATE::WAITING)
			continue;
		if (port && conn->cur_port != port)
			continue;

		conn->start_seq = rdtsc();
		conn->cur_ack = conn->start_ack + 1;
		conn->cur_seq = conn->start_seq;
		conn->cli_ack = conn->cur_seq;
		conn->state = TCP_STATE::SYNACK_SENT;

		if (TCP_LOG_VERBOSE)
			printf("[TCP] %I:%i->%i: Accepting SYN.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
		tcp_mss mss = { 0x02, 0x04, htons(TCP_MSS) };
		tcp_transmit((tcp_conn_t)conn, { span((std::byte*)&mss, 4) }, TCP_DATA_OFFSET(1) | TCP_FLAG_SYN | TCP_FLAG_ACK);

		while (conn->state != TCP_STATE::ESTABLISHED && conn->state != TCP_STATE::CLOSED)
			net_fwdall();
		if (conn->state == TCP_STATE::CLOSED) {
			tcp_destroy(conn);
			return NULL;
		} else
			return conn;
	}
	return NULL;
}

tcp_conn_t tcp_connect(ipv4_t ip, uint16_t src_port, uint16_t dst_port) {
	tcp_conn_t conn = new tcp_connection();
	conn->cur_ip = global_ip;
	conn->cli_ip = ip;
	conn->cur_port = src_port;
	conn->cli_port = dst_port;
	conn->start_seq = rdtsc();
	conn->cur_seq = conn->start_seq;
	conn->state = TCP_STATE::SYN_SENT;
	if (TCP_LOG_VERBOSE)
		printf("[TCP] %I:%i->%i: Opening connection.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
	open_connections.append((tcp_conn_t)conn);
	tcp_mss mss = { 0x02, 0x04, htons(TCP_MSS) };
	tcp_transmit(conn, span<std::byte>((std::byte*)&mss, 4), TCP_DATA_OFFSET(1) | TCP_FLAG_SYN);
	while (conn->state != TCP_STATE::ESTABLISHED)
		net_fwdall();
	return conn;
}

tcp_async_t tcp_connection::send(tcp_fragment&& p) {
	if (p.size() > TCP_CLI_MSS) {
		if (TCP_LOG_VERBOSE)
			printf("[TCP] LARGE PACKET: %i bytes\n", p.size());
		std::size_t offset = 0;
		while (true) {
			std::size_t size = min(p.size() - offset, TCP_CLI_MSS);
			tcp_transmit((tcp_conn_t)this, { span((std::byte*)p.begin() + offset, size) },
						 TCP_DATA_OFFSET(0) | TCP_FLAG_PSH | TCP_FLAG_ACK);
			cur_seq += size;
			offset += size;
			if (offset == p.size())
				break;
		}
		return this;
	} else {
		tcp_transmit((tcp_conn_t)this, span<std::byte>((std::byte*)p.begin(), p.size()),
					 TCP_DATA_OFFSET(0) | TCP_FLAG_PSH | TCP_FLAG_ACK);
		cur_seq += p.size();
		return this;
	}
}
void tcp_connection::await_packet(std::size_t target_count) {
	while (received_packets.size() < target_count) {
		net_fwdall();
		if (state == TCP_STATE::CLOSED)
			return;
	}
}
tcp_fragment tcp_connection::recv() {
	await_packet(1);
	tcp_fragment p = std::move(received_packets.at(0));
	received_packets.erase(0);
	return p;
}
void tcp_connection::close() {
	if (state == TCP_STATE::FINACK_SENT) {
		if (TCP_LOG_VERBOSE)
			printf("[TCP] %I:%i->%i: Already closing.\n", cli_ip, cli_port, cur_port);
	} else {
		if (TCP_LOG_VERBOSE)
			printf("[TCP] %I:%i->%i: Sending FIN.\n", cli_ip, cli_port, cur_port);
		tcp_transmit((tcp_conn_t)this, {}, TCP_DATA_OFFSET(0) | TCP_FLAG_FIN | TCP_FLAG_ACK);
		state = TCP_STATE::FIN_SENT;
	}
	while (state != TCP_STATE::CLOSED)
		net_fwdall();
}

void tcp_destroy(tcp_conn_t conn) {
	for (std::size_t i = 0; i < open_connections.size(); i++) {
		if (open_connections[i] == conn) {
			open_connections.erase(i);
			break;
		}
	}
	delete conn;
}
void tcp_await(tcp_conn_t conn) {
	while (conn->cur_seq != conn->cli_ack) {
		net_fwdall();
	}
}

tcp_input_iterator::tcp_input_iterator(tcp_conn_t conn) : conn(conn) {}
const char& tcp_input_iterator::operator*() const {
	conn->await_packet(1);
	return conn->received_packets[0][conn->packet_offset];
}
tcp_input_iterator& tcp_input_iterator::operator++() {
	conn->packet_offset++;
	if (conn->packet_offset == conn->received_packets[0].size()) {
		conn->received_packets.erase(0);
		conn->packet_offset = 0;
	}
	return *this;
}