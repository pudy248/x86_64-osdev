#include "stl/ranges/algorithms.hpp"
#include <kfile.hpp>
#include <kstddef.hpp>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <net/http.hpp>
#include <net/tcp.hpp>
#include <stl/ranges.hpp>
#include <stl/vector.hpp>

http_response http_get(tcp_conn_t conn) {
	vector<char> http_header;
	ranges::copy_through_block(ranges::unbounded_range{ http_header.oend() },
							   ranges::unbounded_range{ tcp_input_iterator{ conn } }, "\r\n\r\n"_RO);
	istringstream s{ http_header };

	bool chunked = false;
	int64_t length = 0;
	int status = 0;

	while (true) {
		if (s.match("\r\n"_RO)) {
			break;
		} else if (s.match("HTTP/1.1 "_RO)) {
			status = s.read_i();
			ranges::mut::iterate_through_block(s, "\r\n"_RO);
		} else if (s.match("Content-Length: "_RO)) {
			length = s.read_i();
			ranges::mut::iterate_through_block(s, "\r\n"_RO);
		} else if (s.match("Transfer-Encoding: "_RO)) {
			chunked = s.match("chunked"_RO);
			ranges::mut::iterate_through_block(s, "\r\n"_RO);
		} else {
			ranges::mut::iterate_through_block(s, "\r\n"_RO);
		}
	}

	vector<char> output;
	basic_istringstream<char, tcp_input_iterator, std::unreachable_sentinel_t> stream2{ { conn }, {} };

	if (chunked) {
		while (1) {
			int64_t frag_length = stream2.read_x();
			stream2.match("\r\n"_RO);
			if (!frag_length)
				break;
			length += frag_length + 2;
			output.reserve(output.size() + frag_length);
			while (frag_length--)
				output.append(stream2.read_c());
			stream2.match("\r\n"_RO);
		}
	} else {
		int64_t frag_length = length;
		output.reserve(output.size() + frag_length);
		while (frag_length--)
			output.append(stream2.read_c());
	}
	return { status, std::move(http_header), std::move(output) };
}

bool http_process(tcp_conn_t conn, rostring p) {
	vector<rostring> lines = p.split<vector>("\n");
	vector<rostring> args = lines[0].split<vector>(' ');

	if (!ranges::equal(args[0], "GET")) {
		http_error(conn, "400 Bad Request");
		return true;
	}

	file_t file = fs::open(args[1]);
	if (!file) {
		http_error(conn, "404 Not Found");
		return true;
	}
	if (file.n->is_directory) {
		file = fs::open("/index.html");
		if (!file) {
			http_error(conn, "404 Not Found");
			return true;
		}
	}

	if (ranges::ends_with(file.n->filename, ".jpg"))
		http_send(conn, "image/png"_RO, file.rodata());
	else if (ranges::ends_with(file.n->filename, ".webp"))
		http_send(conn, "image/webp"_RO, file.rodata());
	else if (ranges::ends_with(file.n->filename, ".wasm"))
		http_send(conn, "application/wasm"_RO, file.rodata());
	else if (ranges::ends_with(file.n->filename, ".css"))
		http_send(conn, "text/css"_RO, file.rodata());
	else if (ranges::ends_with(file.n->filename, ".js"))
		http_send(conn, "text/javascript"_RO, file.rodata());
	else
		http_send(conn, "text/html"_RO, file.rodata());

	return false;
}

void http_send(tcp_conn_t conn, rostring type, rostring response) {
	rostring fstr("HTTP/1.1 200 OK\r\n"
				  "Content-Type: %S\r\n"
				  "Content-Length: %i\r\n"
				  "Accept-Ranges: bytes\r\n"
				  "Connection: keep-alive\r\n"
				  "\r\n%S");

	string fresponse = format(fstr, &type, response.size(), &response);
	tcp_await(conn->send({ span(fresponse.begin(), fresponse.end() - 1) }));
}

void http_error(tcp_conn_t conn, rostring code) {
	rostring fstr("HTTP/1.1 %S\r\n"
				  "Content-Type: text/html\r\n"
				  "Content-Length: 0\r\n"
				  "Connection: close\r\n\r\n");
	string fresponse = format(fstr, &code);
	tcp_await(conn->send({ span(fresponse.begin(), fresponse.end() - 1) }));
}

http_response http_req_get(tcp_conn_t conn, rostring uri) {
	rostring fstr("GET / HTTP/1.1\r\n"
				  "Host: %S\r\n"
				  "Connection: keep-alive\r\n"
				  "Accept: text/html\r\n\r\n");
	string fresponse = format(fstr, &uri);
	tcp_await(conn->send({ span(fresponse.begin(), fresponse.end() - 1) }));
	return http_get(conn);
}
