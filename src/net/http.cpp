#include <kstddefs.hpp>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <lib/fat.hpp>
#include <net/http.hpp>
#include <net/tcp.hpp>
#include <stl/vector.hpp>

bool http_process(tcp_connection* conn, rostring p) {
	vector<rostring> lines = p.split<vector>("\n");
	vector<rostring> args = lines[0].split<vector>(' ');

	if (args[0] != "GET"_RO) {
		http_error(conn, "400 Bad Request");
		return true;
	}

	fat_file file = file_open(args[1]);
	if (!file.inode) {
		http_error(conn, "404 Not Found");
		return true;
	}
	if (file.inode->attributes & FAT_ATTRIBS::DIRECTORY) {
		fat_file file2 = file_open("/index.html");
		file = file2;
		if (!file.inode) {
			http_error(conn, "404 Not Found");
			return true;
		}
	}
	// printf("%S\n", &file.inode->filename);
	if (view(file.inode->filename).ends_with(".png"_RO))
		http_send(conn, "image/png"_RO, file.rodata().reinterpret_as<char>());
	else if (view(file.inode->filename).ends_with(".webp"_RO))
		http_send(conn, "image/webp"_RO, file.rodata().reinterpret_as<char>());
	else if (view(file.inode->filename).ends_with(".wasm"_RO))
		http_send(conn, "application/wasm"_RO, file.rodata().reinterpret_as<char>());
	else if (view(file.inode->filename).ends_with(".css"_RO))
		http_send(conn, "text/css"_RO, file.rodata().reinterpret_as<char>());
	else if (view(file.inode->filename).ends_with(".js"_RO))
		http_send(conn, "text/javascript"_RO, file.rodata().reinterpret_as<char>());
	else
		http_send(conn, "text/html"_RO, file.rodata().reinterpret_as<char>());

	return false;
}

void http_send(tcp_connection* conn, rostring type, rostring response) {
	rostring fstr("HTTP/1.1 200 OK\r\n"
				  "Content-Type: %S\r\n"
				  "Content-Length: %i\r\n"
				  "Accept-Ranges: bytes\r\n"
				  "Connection: keep-alive\r\n"
				  "\r\n%S");

	string fresponse = format(fstr, &type, response.size(), &response);
	tcp_await(conn->send({ span((uint8_t*)fresponse.begin()(), (uint8_t*)fresponse.end()() - 1) }));
}

void http_error(tcp_connection* conn, rostring code) {
	rostring fstr("HTTP/1.1 %S\r\n"
				  "Content-Type: text/html\r\n"
				  "Content-Length: 0\r\n"
				  "Connection: close\r\n\r\n");
	string fresponse = format(fstr, &code);
	tcp_await(conn->send({ span((uint8_t*)fresponse.begin()(), (uint8_t*)fresponse.end()() - 1) }));
}