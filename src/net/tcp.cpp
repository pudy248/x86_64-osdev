#include <cstddef>
#include <cstdint>
#include <kstddefs.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <stl/vector.hpp>
#include <stl/view.hpp>
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

vector<tcp_connection*> open_connections;

#define TCP_MSS 8000UL
#define TCP_CLI_MSS 8000UL

constexpr bool TCP_VERBOSE_LOGGING = false;

struct tcp_mss {
	uint8_t op = 0x02;
	uint8_t len = 0x04;
	uint16_t mss;
};
static void tcp_checksum(const ipv4_header& ip, tcp_header* tcp) {
	unsigned long sum = 0;
	unsigned short tcp_len = htons(ip.total_length) - ((ip.ver_ihl & 0xf) << 2);
	sum += (ip.src_ip >> 16) & 0xFFFF;
	sum += (ip.src_ip) & 0xFFFF;
	sum += (ip.dst_ip >> 16) & 0xFFFF;
	sum += (ip.dst_ip) & 0xFFFF;
	sum += htons(6);
	sum += htons(tcp_len);

	tcp->checksum = 0;
	uint16_t* ip_payload = (uint16_t*)tcp;
	while (tcp_len > 1) {
		sum += *ip_payload++;
		tcp_len -= 2;
	}
	if (tcp_len > 0) { sum += ((*ip_payload) & htons(0xFF00)); }
	while (sum >> 16) { sum = (sum & 0xffff) + (sum >> 16); }
	sum = ~sum;
	tcp->checksum = sum;
}
constexpr bool TCP_STATE::valid(int s) { return s == ESTABLISHED; }
tcp_flags::tcp_flags(uint16_t f) { *(uint16_t*)this = f; }

net_buffer_t tcp_new(std::size_t data_size) {
	net_buffer_t buf = ipv4_new(data_size + sizeof(tcp_header));
	return { buf.frame_begin, buf.data_begin + sizeof(tcp_header), data_size };
}
net_async_t tcp_transmit(tcp_connection* conn, tcp_packet packet) {
	tcp_header* tcp = (tcp_header*)(packet.buf.data_begin - sizeof(tcp_header));
	tcp->src_port = htons(conn->cur_port);
	tcp->dst_port = htons(conn->cli_port);
	tcp->ack_num = htonl(conn->cur_ack);
	tcp->seq_num = htonl(conn->cur_seq);
	tcp->flags = tcp_flags(packet.flags);
	tcp->window_size = 0xffff;
	tcp->checksum = 0;
	tcp->urgent = 0;

	ipv4_header ip;
	ip.ver_ihl = 0x45;
	ip.total_length = htons(20 + packet.buf.data_size + sizeof(tcp_header));
	ip.src_ip = conn->cur_ip;
	ip.dst_ip = conn->cli_ip;
	tcp_checksum(ip, tcp);

	ipv4_packet p_ip;
	p_ip.src = ip.src_ip;
	p_ip.dst = ip.dst_ip;
	p_ip.protocol = IPv4::PROTOCOL_TCP;
	p_ip.buf = { packet.buf.frame_begin, packet.buf.data_begin - sizeof(tcp_header),
				 packet.buf.data_size + sizeof(tcp_header) };
	return ipv4_send(p_ip);
}
static net_async_t tcp_transmit(tcp_connection* conn, span<uint8_t> data, uint16_t flags) {
	net_buffer_t buf = tcp_new(data.size());
	ispan(buf.data_begin).blit(data);
	return tcp_transmit(conn, { flags, buf });
}

void tcp_receive(ipv4_packet packet) {
	tcp_header* tcp = (tcp_header*)packet.buf.data_begin;

	uint16_t header_size = 4 * tcp->flags.data_offset;
	uint16_t size = packet.buf.data_size - header_size;
	uint8_t* contents = packet.buf.data_begin + header_size;

	for (std::size_t i = 0; i < open_connections.size(); i++) {
		tcp_connection* conn = open_connections.at(i);

		if (conn->state == TCP_STATE::LISTENING) {
			if ((!conn->cur_port || conn->cur_port == htons(tcp->dst_port)) && tcp->flags.syn &&
				!tcp->flags.ack) {
				conn->cli_ip = packet.src;
				conn->cur_ip = packet.dst;
				conn->cli_port = htons(tcp->src_port);
				conn->cur_port = htons(tcp->dst_port);
				conn->start_seq = htonl(open_connections.size());
				conn->start_ack = htonl(tcp->seq_num);
				conn->cur_ack = conn->start_ack + 1;
				conn->cur_seq = conn->start_seq;
				conn->cli_ack = conn->start_seq;

				if (TCP_VERBOSE_LOGGING)
					printf("[TCP] Opening connection to port %i with %I:%i.\n", conn->cur_port,
						   conn->cli_ip, conn->cli_port);
				tcp_mss mss = { 0x02, 0x04, htons(TCP_MSS) };
				conn->state = TCP_STATE::SYNACK_SENT;
				tcp_transmit(conn, span<uint8_t>((uint8_t*)&mss, 4),
							 TCP_DATA_OFFSET(1) | TCP_FLAG_SYN | TCP_FLAG_ACK);
				goto cleanup;
			}
		}

		if (conn->state == TCP_STATE::UNINITIALIZED) continue;
		if (conn->cur_port != htons(tcp->dst_port)) continue;
		if (conn->cli_ip != packet.src) continue;
		if (conn->cli_port != htons(tcp->src_port))
			continue;

		else if (conn->state == TCP_STATE::WAITING) {
			if (tcp->flags.rst) {
				tcp_transmit(conn, span<uint8_t>(), TCP_DATA_OFFSET(1) | TCP_FLAG_RST);
				tcp_destroy(conn);
			}
			goto cleanup;
		}

		if (tcp->flags.rst) {
			printf("[TCP] %I:%i->%i: RST recieved.\n", conn->cli_ip, conn->cli_port,
				   conn->cur_port);
			tcp_transmit(conn, span<uint8_t>(), TCP_DATA_OFFSET(0) | TCP_FLAG_RST | TCP_FLAG_ACK);
			conn->state = TCP_STATE::CLOSED;
			goto cleanup;
		} else if (conn->state == TCP_STATE::SYN_SENT) {
			if (!tcp->flags.syn || !tcp->flags.ack) {
				print("[TCP] Spurious packet recieved during handshake, expected SYN/ACK\n");
			} else {
				conn->cur_ack = htonl(tcp->seq_num) + 1;
				tcp_transmit(conn, span<uint8_t>(), TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);
				if (TCP_VERBOSE_LOGGING)
					printf("[TCP] %I:%i->%i: SYN/ACK recieved.\n", conn->cli_ip, conn->cli_port,
						   conn->cur_port);
			}
			goto cleanup;
		} else if (conn->state == TCP_STATE::SYNACK_SENT) {
			if (tcp->flags.syn || !tcp->flags.ack || tcp->flags.psh) {
				print("[TCP] Spurious packet recieved during handshake, expected ACK\n");
			} else {
				if (TCP_VERBOSE_LOGGING)
					printf("[TCP] %I:%i->%i: Handshake ACK recieved.\n", conn->cli_ip,
						   conn->cli_port, conn->cur_port);
				conn->cur_seq++;
				conn->packet_offset = 0;
				conn->state = TCP_STATE::ESTABLISHED;
			}
			goto cleanup;
		} else if (conn->state == TCP_STATE::FIN_SENT) {
			if (tcp->flags.fin) {
				conn->cur_ack = htonl(tcp->seq_num) + 1;
				tcp_transmit(conn, { span<uint8_t>() }, TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);
				if (TCP_VERBOSE_LOGGING)
					printf("[TCP] %I:%i->%i: FIN/ACK recieved.\n", conn->cli_ip, conn->cli_port,
						   conn->cur_port);
				conn->state = TCP_STATE::CLOSED;
				goto cleanup;
			}
		} else if (conn->state == TCP_STATE::FINACK_SENT) {
			if (tcp->flags.ack) {
				if (TCP_VERBOSE_LOGGING)
					printf("[TCP] %I:%i->%i: Final ACK recieved.\n", conn->cli_ip, conn->cli_port,
						   conn->cur_port);
				conn->state = TCP_STATE::CLOSED;
			}
			goto cleanup;
		}

		if (tcp->flags.psh) {
			if (conn->state != TCP_STATE::ESTABLISHED) {
				printf("[TCP] PSH recieved during invalid state %i.\n", conn->state);
				goto cleanup;
			}
			if (TCP_VERBOSE_LOGGING)
				printf("[TCP] %I:%i->%i: PSH recieved: %i bytes.\n", conn->cli_ip, conn->cli_port,
					   conn->cur_port, size);
			uint32_t tmp_ack = conn->cur_ack;

			conn->cur_ack = htonl(tcp->seq_num) + size;
			tcp_transmit(conn, { span<uint8_t>() }, TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);

			if (htonl(tcp->seq_num) != tmp_ack || conn->partial.start_seq) {
				if (!conn->partial.start_seq) {
					conn->partial.start_seq = tmp_ack;
					conn->partial.end_seq = htonl(tcp->seq_num) + size;
					conn->partial.contents =
						vector<uint8_t>(conn->partial.end_seq - conn->partial.start_seq);
				}
				view(conn->partial.contents)
					.blit(span(contents, size), htonl(tcp->seq_num) - conn->partial.start_seq);
				if (htonl(tcp->seq_num) + size == conn->partial.end_seq)
					conn->partial.end_seq = htonl(tcp->seq_num);
				if (htonl(tcp->seq_num) == conn->partial.start_seq)
					conn->partial.start_seq = htonl(tcp->seq_num);
				if (conn->partial.start_seq == conn->partial.end_seq) {
					uint8_t* buf = conn->partial.contents.c_arr();
					conn->partial.contents.clear();
					conn->partial.start_seq = conn->partial.end_seq = 0;

					conn->received_packets.append({ vector(buf, size) });
				}
			} else {
				//tcp_send(conn, { span(contents, size) }, set_flags(TCP_DATA_OFFSET(0) | TCP_FLAG_PSH | TCP_FLAG_ACK));
				conn->received_packets.append({ contents, size });
			}
		} else if (tcp->flags.fin) {
			conn->cur_ack = htonl(tcp->seq_num) + 1;
			tcp_transmit(conn, { span<uint8_t>() },
						 TCP_DATA_OFFSET(0) | TCP_FLAG_FIN | TCP_FLAG_ACK);
			if (TCP_VERBOSE_LOGGING)
				printf("[TCP] %I:%i->%i: FIN recieved.\n", conn->cli_ip, conn->cli_port,
					   conn->cur_port);
			conn->state = TCP_STATE::FINACK_SENT;
		} else if (tcp->flags.ack && conn->state != TCP_STATE::CLOSED) {
			if (htonl(tcp->seq_num) == conn->cur_ack - 1) {
				tcp_transmit(conn, span<uint8_t>(), TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);
			} else if (conn->cur_seq != conn->cli_ack) {
				conn->cli_ack = htonl(tcp->ack_num);
			} else {
				if (TCP_VERBOSE_LOGGING)
					printf(
						"[TCP] %I:%i->%i: Unknown ACK. CURSEQ %i CLIACK %i), tcp (SEQ %i ACK %i).\n",
						conn->cli_ip, conn->cli_port, conn->cur_port, conn->cur_seq, conn->cli_ack,
						htonl(tcp->seq_num), htonl(tcp->ack_num));
			}
		} else
			continue;
		goto cleanup;
	}

	if (tcp->flags.syn) {
		tcp_connection* conn = (tcp_connection*)tcp_create();
		conn->cli_ip = packet.src;
		conn->cur_ip = packet.dst;
		conn->cli_port = htons(tcp->src_port);
		conn->cur_port = htons(tcp->dst_port);
		conn->start_ack = htonl(tcp->seq_num);
		conn->state = TCP_STATE::WAITING;
		if (TCP_VERBOSE_LOGGING)
			printf("[TCP] %I:%i->%i: SYN recieved, waiting.\n", conn->cli_ip, conn->cli_port,
				   conn->cur_port);
		goto cleanup;
	}
	printf("[TCP] Invalid packet: SRC %i, Flags=%02x, SYN=%i, ACK=%i\n", htons(tcp->src_port),
		   *(uint16_t*)&tcp->flags >> 8, htonl(tcp->seq_num), htonl(tcp->ack_num));

cleanup:
	kfree(packet.buf.frame_begin);
}

tcp_connection* tcp_create() {
	tcp_connection* conn = new tcp_connection();
	conn->state = TCP_STATE::UNINITIALIZED;
	open_connections.append((tcp_connection*)conn);
	return conn;
}

tcp_connection* tcp_accept(uint16_t port) {
	for (std::size_t i = 0; i < open_connections.size(); i++) {
		tcp_connection* conn = (tcp_connection*)open_connections.at(i);
		if (conn->state != TCP_STATE::WAITING) continue;
		if (port && conn->cur_port != port) continue;

		conn->start_seq = htonl(open_connections.size());
		conn->cur_ack = conn->start_ack + 1;
		conn->cur_seq = conn->start_seq;
		conn->cli_ack = conn->cur_seq;
		conn->state = TCP_STATE::SYNACK_SENT;

		if (TCP_VERBOSE_LOGGING)
			printf("[TCP] %I:%i->%i: Accepting SYN.\n", conn->cli_ip, conn->cli_port,
				   conn->cur_port);
		tcp_mss mss = { 0x02, 0x04, htons(TCP_MSS) };
		tcp_transmit((tcp_connection*)conn, { span((uint8_t*)&mss, 4) },
					 TCP_DATA_OFFSET(1) | TCP_FLAG_SYN | TCP_FLAG_ACK);

		while (conn->state != TCP_STATE::ESTABLISHED && conn->state != TCP_STATE::CLOSED)
			net_process();
		if (conn->state == TCP_STATE::CLOSED) {
			tcp_destroy(conn);
			return NULL;
		} else
			return conn;
	}
	return NULL;
}

void tcp_connection::listen(uint16_t port) {
	cur_port = port;
	state = TCP_STATE::LISTENING;
	while (state != TCP_STATE::ESTABLISHED) net_process();
}
tcp_async_t tcp_connection::send(tcp_fragment&& p) {
	if (p.size() > TCP_CLI_MSS) {
		if (TCP_VERBOSE_LOGGING) printf("[TCP] LARGE PACKET: %i bytes\n", p.size());
		std::size_t offset = 0;
		while (true) {
			std::size_t size = min(p.size() - offset, TCP_CLI_MSS);
			tcp_transmit((tcp_connection*)this, { span(p.begin()() + offset, size) },
						 TCP_DATA_OFFSET(0) | TCP_FLAG_PSH | TCP_FLAG_ACK);
			cur_seq += size;
			offset += size;
			if (offset == p.size()) break;
		}
		return this;
	} else {
		tcp_transmit((tcp_connection*)this, span<uint8_t>(p.begin()(), p.end()()),
					 TCP_DATA_OFFSET(0) | TCP_FLAG_PSH | TCP_FLAG_ACK);
		cur_seq += p.size();
		return this;
	}
}
void tcp_connection::await_packet(std::size_t target_count) {
	while (received_packets.size() < target_count) {
		net_process();
		if (state == TCP_STATE::CLOSED) return;
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
		if (TCP_VERBOSE_LOGGING)
			printf("[TCP] %I:%i->%i: Already closing.\n", cli_ip, cli_port, cur_port);
	} else {
		if (TCP_VERBOSE_LOGGING)
			printf("[TCP] %I:%i->%i: Sending FIN.\n", cli_ip, cli_port, cur_port);
		tcp_transmit((tcp_connection*)this, {}, TCP_DATA_OFFSET(0) | TCP_FLAG_FIN | TCP_FLAG_ACK);
		state = TCP_STATE::FIN_SENT;
	}
	while (state != TCP_STATE::CLOSED) net_process();
}

void tcp_destroy(tcp_connection* conn) {
	for (std::size_t i = 0; i < open_connections.size(); i++) {
		if (open_connections[i] == conn) {
			open_connections.erase(i);
			break;
		}
	}
	delete conn;
}
void tcp_await(tcp_connection* conn) {
	while (conn->cur_seq != conn->cli_ack) { net_process(); }
}

tcp_input_iterator::tcp_input_iterator(tcp_connection* conn)
	: conn(conn)
	, fragment_index(conn->packet_offset)
	, fragment_offset(0) {
	get_packet();
}
tcp_input_iterator::tcp_input_iterator(tcp_connection* conn, std::size_t fragment_index,
									   std::size_t fragment_offset)
	: conn(conn)
	, fragment_index(fragment_index)
	, fragment_offset(fragment_offset) {}
void tcp_input_iterator::get_packet() const {
	conn->await_packet(fragment_index + 1 - conn->packet_offset);
}
bool tcp_input_iterator::in_bounds() const {
	return fragment_index - conn->packet_offset < conn->received_packets.size();
}
tcp_fragment& tcp_input_iterator::cur_frag() const {
	return conn->received_packets.at(fragment_index - conn->packet_offset);
}
void tcp_input_iterator::flush() {
	conn->received_packets.erase(0, fragment_index);
	conn->packet_offset += fragment_index;
	fragment_index = 0;
}
uint8_t& tcp_input_iterator::operator*() const {
	get_packet();
	return cur_frag().at(fragment_offset);
}
//uint8_t* tcp_input_iterator::operator()() const {
//	if (in_bounds() && fragment_offset < cur_frag().size())
//		return &**this;
//	else if (in_bounds())
//		return tcp_input_iterator{ conn, fragment_index, 0 }() + fragment_offset;
//	else if (fragment_index - conn->packet_offset == conn->received_packets.size())
//		return tcp_input_iterator{ conn, fragment_index - 1, 0 }() +
//			   conn->received_packets.at(conn->received_packets.size() - 1).size();
//	else
//		return NULL;
//}
//tcp_input_iterator::operator void*() const { return (void*)(*this)(); }
tcp_input_iterator& tcp_input_iterator::operator+=(int n) {
	fragment_offset += n;
	while (fragment_offset >= cur_frag().size()) {
		fragment_offset -= cur_frag().size();
		fragment_index++;
		if (!in_bounds()) break;
	}
	return *this;
}
bool tcp_input_iterator::operator==(const tcp_input_iterator& other) const {
	return conn == other.conn && fragment_index == other.fragment_index &&
		   fragment_offset == other.fragment_offset;
}
bool tcp_sentinel::operator==(const tcp_input_iterator& other) const {
	return !TCP_STATE::valid(other.conn->state);
}
