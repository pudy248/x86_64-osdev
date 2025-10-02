#include <iterator>
#include <kfile.hpp>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <net/http.hpp>
#include <net/tcp.hpp>
#include <stl/ranges.hpp>
#include <stl/vector.hpp>

http_response http_get(tcp_conn_t conn) {
	vector<char> http_header;
	ranges::val::copy_through_block(
		ranges::unbounded_range{std::back_inserter(http_header)}, tcp_range{conn}, "\r\n\r\n"_RO);
	istringstream s{http_header};

	bool chunked = false;
	int64_t length = 0;
	int status = 0;

	while (s.readable()) {
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
	basic_istringstream<char, tcp_input_iterator, tcp_input_sentinel> stream2{{conn}, {}};

	if (chunked) {
		while (stream2.readable()) {
			int64_t frag_length = stream2.read_x();
			if (!stream2.match("\r\n"_RO))
				print("HTTP chunked encoding error.\n");
			if (!frag_length)
				break;
			length += frag_length + 2;
			ranges::mut::copy_n(ranges::unbounded_range(std::back_inserter(output)), stream2, frag_length);
			if (!stream2.match("\r\n"_RO))
				print("HTTP chunked encoding error 2.\n");
		}
	} else
		ranges::mut::copy_n(ranges::unbounded_range(std::back_inserter(output)), stream2, length);
	return {status, std::move(http_header), std::move(output)};
}

bool http_process(tcp_conn_t conn, rostring p) {
	vector<rostring> lines = p.split<vector>("\n");
	vector<rostring> args = lines[0].split<vector>(' ');

	if (!ranges::equal(args[0], "GET"_RO)) {
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

	if (ranges::ends_with(file.n->filename, ".jpg"_RO))
		http_send(conn, "image/png"_RO, file.rodata());
	else if (ranges::ends_with(file.n->filename, ".webp"_RO))
		http_send(conn, "image/webp"_RO, file.rodata());
	else if (ranges::ends_with(file.n->filename, ".wasm"_RO))
		http_send(conn, "application/wasm"_RO, file.rodata());
	else if (ranges::ends_with(file.n->filename, ".css"_RO))
		http_send(conn, "text/css"_RO, file.rodata());
	else if (ranges::ends_with(file.n->filename, ".js"_RO))
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
	tcp_await(conn->send({span(fresponse.begin(), fresponse.end() - 1)}));
}

void http_error(tcp_conn_t conn, rostring code) {
	rostring fstr("HTTP/1.1 %S\r\n"
				  "Content-Type: text/html\r\n"
				  "Content-Length: 0\r\n"
				  "Connection: close\r\n\r\n");
	string fresponse = format(fstr, &code);
	tcp_await(conn->send({span(fresponse.begin(), fresponse.end() - 1)}));
}

http_response http_req_get(tcp_conn_t conn, rostring uri) {
	rostring fstr("GET / HTTP/1.1\r\n"
				  "Host: %S\r\n"
				  "Connection: keep-alive\r\n"
				  "Accept: text/html\r\n\r\n");
	string fresponse = format(fstr, &uri);
	tcp_await(conn->send({span(fresponse.begin(), fresponse.end() - 1)}));
	return http_get(conn);
}
