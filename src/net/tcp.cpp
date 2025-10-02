#include <cstddef>
#include <cstdint>
#include <kstddef.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/config.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <stl/optional.hpp>
#include <stl/ranges.hpp>
#include <stl/vector.hpp>
#include <utility>

namespace TCP_FLAG {
enum TCP_FLAG {
	DATA_OFFSET = 4,
	FIN = (1 << 8),
	SYN = (1 << 9),
	RST = (1 << 10),
	PSH = (1 << 11),
	ACK = (1 << 12),
	URG = (1 << 13),
	ECE = (1 << 14),
	CWR = (1 << 15),
};
}

vector<tcp_conn_t> open_connections;

constexpr uint16_t TCP_MSS = 1440;
constexpr uint16_t TCP_CLI_MSS = 1440;

struct tcp_mss {
	uint8_t op = 0x02;
	uint8_t len = 0x04;
	uint16_t mss;
};
constexpr bool TCP_STATE::valid(int s) { return s == ESTABLISHED; }

net_buffer_t tcp_new(std::size_t data_size) {
	net_buffer_t buf = ipv4_new(data_size + sizeof(tcp_header));
	return {buf.frame_begin, buf.data_begin + sizeof(tcp_header), data_size};
}
net_async_t tcp_transmit(tcp_conn_t conn, tcp_packet p) {
	tcp_header* tcp = (tcp_header*)(p.b.data_begin - sizeof(tcp_header));
	tcp->src_port = htons(conn->cur_port);
	tcp->dst_port = htons(conn->cli_port);
	tcp->ack_num = htonl(conn->cur_ack);
	tcp->seq_num = htonl(conn->cur_seq);
	tcp->flags = p.i.flags;
	tcp->window_size = 0xffff;
	tcp->checksum = 0;
	tcp->urgent = 0;

	ipv4_pseudo_header h{conn->cur_ip, conn->cli_ip, 0, IPv4_PROTOCOL::TCP, htons(p.b.data_size + sizeof(tcp_header))};
	tcp->checksum = net_checksum(
		net_partial_checksum(&h, sizeof(h)) + net_partial_checksum(tcp, p.b.data_size + sizeof(tcp_header)));

	ipv4_info npi = p.i;
	npi.src_ip = conn->cur_ip;
	npi.dst_ip = conn->cli_ip;
	npi.protocol = IPv4_PROTOCOL::TCP;
	net_buffer_t buf = {p.b.frame_begin, p.b.data_begin - sizeof(tcp_header), p.b.data_size + sizeof(tcp_header)};
	return ipv4_send({npi, buf});
}
static net_async_t tcp_transmit(tcp_conn_t conn, span<std::byte> data, uint16_t flags) {
	net_buffer_t buf = tcp_new(data.size());
	ranges::copy(span(buf.data_begin(), buf.data_size), data);
	return tcp_transmit(conn, {tcp_info{.flags = flags}, buf});
}

void tcp_receive(ipv4_packet p) {
	tcp_header* tcp = (tcp_header*)p.b.data_begin;

	uint16_t header_size = 4 * ((tcp->flags >> TCP_FLAG::DATA_OFFSET) & 0xf);
	uint16_t size = p.b.data_size - header_size;
	std::byte* contents = p.b.data_begin + header_size;

	bool fin = !!(tcp->flags & TCP_FLAG::FIN);
	bool syn = !!(tcp->flags & TCP_FLAG::SYN);
	bool rst = !!(tcp->flags & TCP_FLAG::RST);
	bool ack = !!(tcp->flags & TCP_FLAG::ACK);
	bool psh = !!(tcp->flags & TCP_FLAG::PSH);

	for (std::size_t i = 0; i < open_connections.size(); i++) {
		tcp_conn_t conn = open_connections.at(i);

		if (conn->state == TCP_STATE::LISTENING) {
			if ((!conn->cur_port || conn->cur_port == htons(tcp->dst_port)) && syn && !ack) {
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
				tcp_mss mss = {0x02, 0x04, htons(TCP_MSS)};
				conn->state = TCP_STATE::SYNACK_SENT;
				tcp_transmit(conn, span<std::byte>((std::byte*)&mss, 4),
					(6 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::SYN | TCP_FLAG::ACK);
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
			if (rst) {
				tcp_transmit(conn, span<std::byte>(), (6 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::RST);
				tcp_destroy(conn);
			}
			goto cleanup;
		}

		if (rst) {
			printf("[TCP] %I:%i->%i: RST recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
			tcp_transmit(conn, span<std::byte>(), (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::RST | TCP_FLAG::ACK);
			conn->state = TCP_STATE::CLOSED;
			goto cleanup;
		} else if (conn->state == TCP_STATE::SYN_SENT) {
			if (!syn || !ack) {
				print("[TCP] Spurious packet recieved during handshake, expected SYN/ACK\n");
			} else {
				conn->cur_seq++;
				conn->cur_ack = htonl(tcp->seq_num) + 1;
				tcp_transmit(conn, span<std::byte>(), (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::ACK);
				if (TCP_LOG_VERBOSE)
					printf("[TCP] %I:%i->%i: SYN/ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
				conn->state = TCP_STATE::ESTABLISHED;
			}
			goto cleanup;
		} else if (conn->state == TCP_STATE::SYNACK_SENT) {
			if (syn || !ack || psh) {
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
			if (fin) {
				conn->cur_ack = htonl(tcp->seq_num) + 1;
				conn->cur_seq++;
				tcp_transmit(conn, {span<std::byte>()}, (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::ACK);
				if (TCP_LOG_VERBOSE)
					printf("[TCP] %I:%i->%i: FIN/ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
				conn->state = TCP_STATE::CLOSED;
				goto cleanup;
			}
		} else if (conn->state == TCP_STATE::FINACK_SENT) {
			if (ack) {
				if (TCP_LOG_VERBOSE)
					printf("[TCP] %I:%i->%i: Final ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
				conn->state = TCP_STATE::CLOSED;
			}
			goto cleanup;
		}

		if (size) {
			if (conn->state != TCP_STATE::ESTABLISHED) {
				printf("[TCP] PSH recieved during invalid state %i.\n", conn->state);
				goto cleanup;
			}
			if (TCP_LOG_VERBOSE)
				printf(
					"[TCP] %I:%i->%i: PSH recieved: %i bytes.\n", conn->cli_ip, conn->cli_port, conn->cur_port, size);
			uint32_t tmp_ack = conn->cur_ack;

			conn->cur_ack = htonl(tcp->seq_num) + size;
			tcp_transmit(conn, {span<std::byte>()}, (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::ACK);

			if (htonl(tcp->seq_num) != tmp_ack || conn->partial.start_seq) {
				if (!conn->partial.start_seq) {
					conn->partial.start_seq = tmp_ack;
					conn->partial.end_seq = htonl(tcp->seq_num) + size;
					conn->partial.contents = vector<char>(conn->partial.end_seq - conn->partial.start_seq);
				}
				conn->partial.contents.reserve(htonl(tcp->seq_num) + size - conn->partial.start_seq);
				ranges::copy(ranges::subrange(conn->partial.contents, htonl(tcp->seq_num) - conn->partial.start_seq),
					span((char*)contents, size));
				if (htonl(tcp->seq_num) + size == conn->partial.end_seq)
					conn->partial.end_seq = htonl(tcp->seq_num);
				if (htonl(tcp->seq_num) == conn->partial.start_seq)
					conn->partial.start_seq = htonl(tcp->seq_num);
				if (conn->partial.start_seq == conn->partial.end_seq) {
					char* buf = conn->partial.contents.c_arr();
					conn->partial.contents.clear();
					conn->partial.start_seq = conn->partial.end_seq = 0;

					conn->received_packets.push_back({buf, buf + size});
				}
			} else {
				conn->received_packets.push_back({(char*)contents, (char*)contents + size});
			}
			if (!fin)
				goto cleanup;
		}
		if (fin) {
			conn->cur_ack = htonl(tcp->seq_num) + 1;
			if (TCP_LOG_VERBOSE)
				printf("[TCP] %I:%i->%i: FIN recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
			if (TCP_RST_ON_CLOSE) {
				tcp_transmit(conn, {span<std::byte>()}, (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::RST);
				conn->state = TCP_STATE::CLOSED;
			} else {
				tcp_transmit(conn, {span<std::byte>()}, (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::FIN | TCP_FLAG::ACK);
				conn->state = TCP_STATE::FINACK_SENT;
			}
			goto cleanup;
		}
		if (!size && ack && conn->state != TCP_STATE::CLOSED) {
			if (htonl(tcp->seq_num) == conn->cur_ack - 1)
				tcp_transmit(conn, span<std::byte>(), (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::ACK);
			else if (conn->cur_seq != conn->cli_ack)
				conn->cli_ack = htonl(tcp->ack_num);
			else if (TCP_LOG_VERBOSE)
				printf("[TCP] %I:%i->%i: Unknown ACK. CURSEQ %i CLIACK %i), tcp (SEQ %i ACK %i).\n", conn->cli_ip,
					conn->cli_port, conn->cur_port, conn->cur_seq, conn->cli_ack, htonl(tcp->seq_num),
					htonl(tcp->ack_num));
			goto cleanup;
		}
	}

	if (syn) {
		tcp_conn_t conn = new tcp_connection();
		conn->cli_ip = p.i.src_ip;
		conn->cur_ip = p.i.dst_ip;
		conn->cli_port = htons(tcp->src_port);
		conn->cur_port = htons(tcp->dst_port);
		conn->start_ack = htonl(tcp->seq_num);
		conn->state = TCP_STATE::WAITING;
		open_connections.push_back((tcp_conn_t)conn);
		if (TCP_LOG_VERBOSE)
			printf("[TCP] %I:%i->%i: SYN recieved, waiting.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
		goto cleanup;
	} else {
		printf("[TCP] Invalid packet: SRC %i, Flags=%02x, SYN=%i, ACK=%i\n", htons(tcp->src_port), tcp->flags >> 8,
			htonl(tcp->seq_num), htonl(tcp->ack_num));
		tcp_conn_t conn = new tcp_connection();
		conn->cli_ip = p.i.src_ip;
		conn->cur_ip = p.i.dst_ip;
		conn->cli_port = htons(tcp->src_port);
		conn->cur_port = htons(tcp->dst_port);
		conn->cur_ack = htonl(tcp->seq_num);
		conn->cur_seq = htonl(tcp->ack_num);
		tcp_transmit(conn, {span<std::byte>()}, (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::RST);
		delete conn;
	}

cleanup:
	//kfree(p.b.frame_begin);
}

tcp_conn_t tcp_accept(uint16_t port) {
	net_fwdall();
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
		tcp_mss mss = {0x02, 0x04, htons(TCP_MSS)};
		tcp_transmit((tcp_conn_t)conn, {span((std::byte*)&mss, 4)},
			(6 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::SYN | TCP_FLAG::ACK);

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
	open_connections.push_back((tcp_conn_t)conn);
	tcp_mss mss = {0x02, 0x04, htons(TCP_MSS)};
	tcp_transmit(conn, span<std::byte>((std::byte*)&mss, 4), (6 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::SYN);
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
			tcp_transmit((tcp_conn_t)this, {span((std::byte*)p.begin() + offset, size)},
				(5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::PSH | TCP_FLAG::ACK);
			cur_seq += size;
			offset += size;
			if (offset == p.size())
				break;
		}
		return this;
	} else {
		tcp_transmit((tcp_conn_t)this, span<std::byte>((std::byte*)p.begin(), p.size()),
			(5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::PSH | TCP_FLAG::ACK);
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
optional<tcp_fragment> tcp_connection::get() {
	if (received_packets.size() == 0)
		return {};
	tcp_fragment p = std::move(received_packets.at(0));
	received_packets.erase(0);
	return p;
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
	} else if (state == TCP_STATE::ESTABLISHED) {
		if (TCP_LOG_VERBOSE)
			printf("[TCP] %I:%i->%i: Sending FIN.\n", cli_ip, cli_port, cur_port);
		if (TCP_RST_ON_CLOSE) {
			tcp_transmit((tcp_conn_t)this, {}, (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::RST);
			state = TCP_STATE::CLOSED;
		} else {
			tcp_transmit((tcp_conn_t)this, {}, (5 << TCP_FLAG::DATA_OFFSET) | TCP_FLAG::FIN | TCP_FLAG::ACK);
			state = TCP_STATE::FIN_SENT;
		}
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
	while (conn->cur_seq != conn->cli_ack)
		net_fwdall();
}
void tcp_send_span(tcp_conn_t conn, span<const char> data) { tcp_await(conn->send(data)); }
void tcp_send_zstr(tcp_conn_t conn, const char* data) { tcp_send_span(conn, span(data, data + strlen(data))); }

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
constexpr bool tcp_input_sentinel::operator==(const tcp_input_iterator& it) const {
	return it.conn->state != TCP_STATE::ESTABLISHED && it.conn->received_packets.size() == 0;
}