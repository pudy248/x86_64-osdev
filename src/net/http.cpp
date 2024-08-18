#include <kstddefs.hpp>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <lib/fat.hpp>
#include <net/http.hpp>
#include <net/tcp.hpp>
#include <stl/vector.hpp>

bool http_process(tcp_connection* conn, tcp_packet p) {
	vector<rostring> lines = rostring(p.contents).split<vector>("\n");
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
		file = file_open(file, "index.html");
		if (!file.inode) {
			http_error(conn, "404 Not Found");
			return true;
		}
	}
	printf("%S\n", &file.inode->filename);
	if (view(file.inode->filename).ends_with(rostring(".png")))
		http_send(conn, rostring("image/png"), rostring(file.inode->data));
	else if (view(file.inode->filename).ends_with(rostring(".webp")))
		http_send(conn, rostring("image/webp"), rostring(file.inode->data));
	else if (view(file.inode->filename).ends_with(rostring(".wasm")))
		http_send(conn, rostring("application/wasm"), rostring(file.inode->data));
	else if (view(file.inode->filename).ends_with(rostring(".css")))
		http_send(conn, rostring("text/css"), rostring(file.inode->data));
	else if (view(file.inode->filename).ends_with(rostring(".js")))
		http_send(conn, rostring("text/javascript"), rostring(file.inode->data));
	else
		http_send(conn, rostring("text/html"), rostring(file.inode->data));

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
	conn->send({ span<char>(fresponse.begin(), fresponse.end()) });
}

void http_error(tcp_connection* conn, rostring code) {
	rostring fstr("HTTP/1.1 %S\r\n"
				  "Content-Type: text/html\r\n"
				  "Content-Length: 0\r\n"
				  "Connection: close\r\n\r\n");
	string fresponse = format(fstr, &code);
	conn->send({ span<char>(fresponse.begin(), fresponse.end()) });
}