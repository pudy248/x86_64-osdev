#include <cstddef>
#include <cstdint>
#include <kstddefs.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/ipv4.hpp>
#include <net/net.hpp>
#include <net/tcp.hpp>
#include <stl/container.hpp>
#include <stl/vector.hpp>

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

#define TCP_MSS 8000
#define TCP_CLI_MSS 8000

constexpr bool TCP_VERBOSE_LOGGING = false;

struct tcp_mss {
	uint8_t op;
	uint8_t len;
	uint16_t mss;
};
static void tcp_checksum(ip_header ip, tcp_header* tcp) {
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
	if (tcp_len > 0) {
		sum += ((*ip_payload) & htons(0xFF00));
	}
	while (sum >> 16) {
		sum = (sum & 0xffff) + (sum >> 16);
	}
	sum = ~sum;
	tcp->checksum = sum;
}
static tcp_flags set_flags(uint16_t dat) {
	tcp_flags f = {};
	*(uint16_t*)&f = dat;
	return f;
}
constexpr bool TCP_STATE::valid(TCP_STATE s) {
	return s == ESTABLISHED;
}

static int tcp_transmit(tcp_connection* conn, tcp_packet packet, uint16_t flags) {
	void* buf = malloc(packet.contents.size() + sizeof(tcp_header));
	tcp_header* tcp = (tcp_header*)buf;
	tcp->src_port = htons(conn->cur_port);
	tcp->dst_port = htons(conn->cli_port);
	tcp->ack_num = htonl(conn->cur_ack);
	tcp->seq_num = htonl(conn->cur_seq);
	tcp->flags = set_flags(flags);
	tcp->window_size = 0xffff;
	tcp->checksum = 0;
	tcp->urgent = 0;

	ip_header ip;
	ip.ver_ihl = 0x45;
	ip.total_length = htons(20 + packet.contents.size() + sizeof(tcp_header));
	ip.src_ip = conn->cur_ip;
	ip.dst_ip = conn->cli_ip;
	memcpy((void*)((uint64_t)buf + sizeof(tcp_header)), packet.contents.begin(), packet.contents.size());
	tcp_checksum(ip, tcp);

	ip_packet p_ip;
	p_ip.src = ip.src_ip;
	p_ip.dst = ip.dst_ip;
	p_ip.protocol = IP_PROTOCOL_TCP;
	p_ip.contents = span<char>((char*)buf, packet.contents.size() + sizeof(tcp_header));
	int handle = ipv4_send(p_ip);
	free(buf);
	return handle;
}

void tcp_process(ip_packet packet) {
	tcp_header* tcp = (tcp_header*)packet.contents.begin();

	uint16_t header_size = 4 * tcp->flags.data_offset;
	uint16_t size = packet.contents.size() - header_size;
	void* contents = (void*)((uint64_t)packet.contents.begin() + header_size);

	for (int i = 0; i < open_connections.size(); i++) {
		tcp_connection* conn = open_connections.at(i);

		if (conn->state == TCP_STATE::LISTENING) {
			if ((!conn->cur_port || conn->cur_port == htons(tcp->dst_port)) && tcp->flags.syn && !tcp->flags.ack) {
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
					printf("[TCP] Opening connection to port %i with %I:%i.\n", conn->cur_port, conn->cli_ip,
						   conn->cli_port);
				tcp_mss mss = { 0x02, 0x04, htons(TCP_MSS) };
				conn->state = TCP_STATE::SYNACK_SENT;
				tcp_transmit(conn, { span<char>((char*)&mss, 4) }, TCP_DATA_OFFSET(1) | TCP_FLAG_SYN | TCP_FLAG_ACK);
				return;
			}
		}

		if (conn->state == TCP_STATE::UNINITIALIZED)
			continue;
		if (conn->cur_port != htons(tcp->dst_port))
			continue;
		if (conn->cli_ip != packet.src)
			continue;
		if (conn->cli_port != htons(tcp->src_port))
			continue;

		else if (conn->state == TCP_STATE::WAITING) {
			if (tcp->flags.rst) {
				tcp_transmit(conn, { span<char>() }, TCP_DATA_OFFSET(1) | TCP_FLAG_RST);
				tcp_destroy(conn);
			}
			return;
		}

		if (tcp->flags.rst) {
			printf("[TCP] %I:%i->%i: RST recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
			tcp_packet p_ack = { span<char>() };
			tcp_transmit(conn, p_ack, TCP_DATA_OFFSET(0) | TCP_FLAG_RST | TCP_FLAG_ACK);
			conn->state = TCP_STATE::CLOSED;
			return;
		}

		if (conn->state == TCP_STATE::SYN_SENT) {
			if (!tcp->flags.syn || !tcp->flags.ack) {
				print("[TCP] Spurious packet recieved during handshake, expected SYN/ACK\n");
				return;
			}
			conn->cur_ack = htonl(tcp->seq_num) + 1;
			tcp_packet p_ack = { span<char>() };
			tcp_transmit(conn, p_ack, TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);
			if (TCP_VERBOSE_LOGGING)
				printf("[TCP] %I:%i->%i: SYN/ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
			return;
		} else if (conn->state == TCP_STATE::SYNACK_SENT) {
			if (tcp->flags.syn || !tcp->flags.ack || tcp->flags.psh) {
				print("[TCP] Spurious packet recieved during handshake, expected ACK\n");
				return;
			}
			conn->cur_seq++;
			if (TCP_VERBOSE_LOGGING)
				printf("[TCP] %I:%i->%i: Handshake ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
			conn->state = TCP_STATE::ESTABLISHED;
			return;
		} else if (conn->state == TCP_STATE::FIN_SENT) {
			if (tcp->flags.fin) {
				conn->cur_ack++;
				tcp_transmit(conn, { span<char>() }, TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);
				if (TCP_VERBOSE_LOGGING)
					printf("[TCP] %I:%i->%i: FIN/ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
				conn->state = TCP_STATE::CLOSED;
				return;
			}
		} else if (conn->state == TCP_STATE::FINACK_SENT) {
			if (tcp->flags.ack) {
				if (TCP_VERBOSE_LOGGING)
					printf("[TCP] %I:%i->%i: Final ACK recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
				conn->state = TCP_STATE::CLOSED;
			}
			return;
		}

		if (tcp->flags.psh) {
			if (conn->state != TCP_STATE::ESTABLISHED) {
				printf("[TCP] PSH recieved during invalid state %i.\n", conn->state);
				return;
			}
			if (TCP_VERBOSE_LOGGING)
				printf("[TCP] %I:%i->%i: PSH recieved: %i bytes.\n", conn->cli_ip, conn->cli_port, conn->cur_port,
					   size);
			uint32_t tmp_ack = conn->cur_ack;

			conn->cur_ack = htonl(tcp->seq_num) + size;
			tcp_transmit(conn, { span<char>() }, TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);

			if (htonl(tcp->seq_num) != tmp_ack || conn->partial.start_seq) {
				if (!conn->partial.start_seq) {
					conn->partial.start_seq = tmp_ack;
					conn->partial.end_seq = htonl(tcp->seq_num) + size;
					conn->partial.contents = vector<char>(conn->partial.end_seq - conn->partial.start_seq);
				}
				conn->partial.contents.blit(span<char>((char*)contents, size),
											htonl(tcp->seq_num) - conn->partial.start_seq);
				if (htonl(tcp->seq_num) + size == conn->partial.end_seq)
					conn->partial.end_seq = htonl(tcp->seq_num);
				if (htonl(tcp->seq_num) == conn->partial.start_seq)
					conn->partial.start_seq = htonl(tcp->seq_num);
				if (conn->partial.start_seq == conn->partial.end_seq) {
					char* buf = conn->partial.contents.c_arr();
					conn->partial.contents.clear();
					conn->partial.start_seq = conn->partial.end_seq = 0;

					conn->recieved_packets.append({ span<char>((char*)buf, size) });
				}
			} else {
				//tcp_send(conn, { span<char>((uint8_t*)contents, size) }, set_flags(TCP_DATA_OFFSET(0) | TCP_FLAG_PSH | TCP_FLAG_ACK));
				void* buf = malloc(size);
				memcpy(buf, contents, size);
				conn->recieved_packets.append({ span<char>((char*)buf, size) });
			}
			return;
		}
		if (tcp->flags.ack) {
			if (htonl(tcp->seq_num) == conn->cur_ack - 1) {
				tcp_packet p_ack = { span<char>() };
				tcp_transmit(conn, p_ack, TCP_DATA_OFFSET(0) | TCP_FLAG_ACK);
				return;
			} else if (conn->cur_seq != conn->cli_ack) {
				conn->cli_ack = htonl(tcp->ack_num);
				return;
			} else {
				//if (TCP_VERBOSE_LOGGING) printf("[TCP] %I:%i->%i: Unknown ACK. CURSEQ %i CLIACK %i), tcp (SEQ %i ACK %i).\n",
				//    conn->cli_ip, conn->cli_port, conn->cur_port, conn->cur_seq, conn->cli_ack, htonl(tcp->seq_num), htonl(tcp->ack_num));
				return;
			}
		}
		if (tcp->flags.fin) {
			conn->cur_ack++;
			tcp_transmit(conn, { span<char>() }, TCP_DATA_OFFSET(0) | TCP_FLAG_FIN | TCP_FLAG_ACK);
			if (TCP_VERBOSE_LOGGING)
				printf("[TCP] %I:%i->%i: FIN recieved.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
			conn->state = TCP_STATE::FINACK_SENT;
			return;
		}
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
			printf("[TCP] %I:%i->%i: SYN recieved, waiting.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
		return;
	}
	printf("[TCP] Invalid packet: SRC %i, Flags=%02x, SYN=%i, ACK=%i\n", htons(tcp->src_port),
		   *(uint16_t*)&tcp->flags >> 8, htonl(tcp->seq_num), htonl(tcp->ack_num));
}

tcp_connection* tcp_create() {
	tcp_connection* conn = new tcp_connection();
	conn->state = TCP_STATE::UNINITIALIZED;
	open_connections.append((tcp_connection*)conn);
	return conn;
}

tcp_connection* tcp_accept(uint16_t port) {
	for (int i = 0; i < open_connections.size(); i++) {
		tcp_connection* conn = (tcp_connection*)open_connections.at(i);
		if (conn->state != TCP_STATE::WAITING)
			continue;
		if (port && conn->cur_port != port)
			continue;

		conn->start_seq = htonl(open_connections.size());
		conn->cur_ack = conn->start_ack + 1;
		conn->cur_seq = conn->start_seq;
		conn->cli_ack = conn->cur_seq;
		conn->state = TCP_STATE::SYNACK_SENT;

		if (TCP_VERBOSE_LOGGING)
			printf("[TCP] %I:%i->%i: Accepting SYN.\n", conn->cli_ip, conn->cli_port, conn->cur_port);
		tcp_mss mss = { 0x02, 0x04, htons(TCP_MSS) };
		tcp_transmit((tcp_connection*)conn, { span<char>((char*)&mss, 4) },
					 TCP_DATA_OFFSET(1) | TCP_FLAG_SYN | TCP_FLAG_ACK);

		while (conn->state != TCP_STATE::ESTABLISHED)
			net_process();
		return conn;
	}
	return NULL;
}

void tcp_connection::listen(uint16_t port) {
	this->cur_port = port;
	this->state = TCP_STATE::LISTENING;
	while (this->state != TCP_STATE::ESTABLISHED)
		net_process();
}
int tcp_connection::send(tcp_packet p) {
	if (p.contents.size() > TCP_CLI_MSS) {
		if (TCP_VERBOSE_LOGGING)
			printf("LARGE PACKET: %i bytes\n", p.contents.size());
		int offset = 0;
		int handle = 0;
		while (true) {
			int size = min(p.contents.size() - offset, TCP_CLI_MSS);
			handle = tcp_transmit((tcp_connection*)this, { span<char>(p.contents, size, offset) },
								  TCP_DATA_OFFSET(0) | TCP_FLAG_PSH | TCP_FLAG_ACK);
			this->cur_seq += size;
			offset += size;
			if (offset == p.contents.size())
				break;
		}
		while (this->cur_seq != this->cli_ack)
			net_process();
		return handle;
	} else {
		int handle = tcp_transmit((tcp_connection*)this, p, TCP_DATA_OFFSET(0) | TCP_FLAG_PSH | TCP_FLAG_ACK);
		this->cur_seq += p.contents.size();
		return handle;
	}
}
tcp_packet tcp_connection::recv() {
	while (!this->recieved_packets.size()) {
		net_process();
		if (this->state == TCP_STATE::CLOSED)
			return { span<char>() };
	}
	tcp_packet p = this->recieved_packets.at(0);
	((tcp_connection*)this)->recieved_packets.erase(0);
	return p;
}
void tcp_connection::close() {
	if (TCP_VERBOSE_LOGGING)
		printf("[TCP] %I:%i->%i: Sending FIN.\n", this->cli_ip, this->cli_port, this->cur_port);
	tcp_transmit((tcp_connection*)this, { span<char>() }, TCP_DATA_OFFSET(0) | TCP_FLAG_FIN | TCP_FLAG_ACK);
	this->state = TCP_STATE::FIN_SENT;
	while (this->state != TCP_STATE::CLOSED)
		net_process();
	return;
}

void tcp_destroy(tcp_connection* conn) {
	for (int i = 0; i < conn->recieved_packets.size(); i++)
		free(conn->recieved_packets.at(i).contents.begin());
	for (int i = 0; i < open_connections.size(); i++) {
		if (open_connections[i] == conn) {
			open_connections.erase(i);
			break;
		}
	}
	delete conn;
}
