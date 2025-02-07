#include <kfile.hpp>
#include <kstddef.hpp>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <net/http.hpp>
#include <net/tcp.hpp>
#include <stl/vector.hpp>

http_response http_get(tcp_conn_t conn) {
	tcp_istringstream stream({ conn }, { conn });
	vector<char> http_header = stream.read_until_cv<view<tcp_input_iterator, tcp_input_iterator>>("\r\n\r\n"_RO, true);
	istringstream s{ http_header };

	bool chunked = false;
	int64_t length = 0;
	int status = 0;

	while (true) {
		if (s.match_cv("\r\n"_RO)) {
			break;
		} else if (s.match_cv("HTTP/1.1 "_RO)) {
			status = s.read_i();
			s.read_until_cv<rostring>("\r\n"_RO, true);
		} else if (s.match_cv("Content-Length: "_RO)) {
			length = s.read_i();
			s.read_until_cv<rostring>("\r\n"_RO, true);
		} else if (s.match_cv("Transfer-Encoding: "_RO)) {
			chunked = s.match_cv("chunked"_RO);
			s.read_until_cv<rostring>("\r\n"_RO, true);
		} else {
			s.read_until_cv<rostring>("\r\n"_RO, true);
		}
	}

	vector<char> output;

	if (chunked) {
		while (1) {
			int64_t frag_length = stream.read_x();
			stream.match_cv("\r\n"_RO);
			if (!frag_length)
				break;
			length += frag_length + 2;
			output.reserve(output.size() + frag_length);
			while (frag_length--)
				output.append(stream.read_c());
			stream.match_cv("\r\n"_RO);
		}
	} else {
		int64_t frag_length = length;
		output.reserve(output.size() + frag_length);
		while (frag_length--)
			output.append(stream.read_c());
	}
	return { status, std::move(http_header), std::move(output) };
}

bool http_process(tcp_conn_t conn, rostring p) {
	vector<rostring> lines = p.split<vector>("\n");
	vector<rostring> args = lines[0].split<vector>(' ');

	if (args[0] != "GET"_RO) {
		http_error(conn, "400 Bad Request");
		return true;
	}

	file_t file = file_open(args[1]);
	if (!file) {
		http_error(conn, "404 Not Found");
		return true;
	}
	if (file.n->is_directory) {
		file = file_open("/index.html");
		if (!file) {
			http_error(conn, "404 Not Found");
			return true;
		}
	}

	auto filename_view = view(file.n->filename);
	rostring file_data = file.rodata();

	if (filename_view.ends_with(".png"_RO))
		http_send(conn, "image/png"_RO, file_data);
	else if (filename_view.ends_with(".webp"_RO))
		http_send(conn, "image/webp"_RO, file_data);
	else if (filename_view.ends_with(".wasm"_RO))
		http_send(conn, "application/wasm"_RO, file_data);
	else if (filename_view.ends_with(".css"_RO))
		http_send(conn, "text/css"_RO, file_data);
	else if (filename_view.ends_with(".js"_RO))
		http_send(conn, "text/javascript"_RO, file_data);
	else
		http_send(conn, "text/html"_RO, file_data);

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
