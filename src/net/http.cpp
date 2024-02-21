#include <kstddefs.h>
#include <kstring.hpp>
#include <kstdio.hpp>
#include <stl/vector.hpp>
#include <lib/fat.hpp>
#include <net/tcp.hpp>
#include <net/http.hpp>

bool http_process(tcp_connection* conn, tcp_packet p) {
    vector<rostring> lines = rostring(p.contents).split("\n");
    vector<rostring> args = lines[0].split(' ');

    if (args[0] != "GET"_RO) {
        http_error(conn, "400 Bad Request");
        return true;
    }

    FILE file = file_open(args[1]);
    if (!file.inode) {
        http_error(conn, "404 Not Found");
        return true;
    }
    if (file.inode->attributes & FAT_ATTRIBS::DIR) {
        file = file_open(file, "index.html");
        if (!file.inode) {
            http_error(conn, "404 Not Found");
            return true;
        }
    }
    printf("%S\n", &file.inode->filename);
    if (file.inode->filename.ends_with(rostring(".png")))
        http_send(conn, rostring("image/png"), rostring(file.inode->data));
    else if (file.inode->filename.ends_with(rostring(".webp")))
        http_send(conn, rostring("image/webp"), rostring(file.inode->data));
    else if (file.inode->filename.ends_with(rostring(".wasm")))
        http_send(conn, rostring("application/wasm"), rostring(file.inode->data));
    else if (file.inode->filename.ends_with(rostring(".css")))
        http_send(conn, rostring("text/css"), rostring(file.inode->data));
    else if (file.inode->filename.ends_with(rostring(".js")))
        http_send(conn, rostring("text/javascript"), rostring(file.inode->data));
    else
        http_send(conn, rostring("text/html"), rostring(file.inode->data));

    return false;
}

void http_send(tcp_connection* conn, rostring type, rostring response) {
    rostring fstr(
        "HTTP/1.1 200 OK\n"
        "Content-Type: %S\n"
        "Content-Length: %i\n"
        "Accept-Ranges: bytes\n"
        "Connection: keep-alive\n"
        "\n%S"
    );
    
    string fresponse = format(fstr, &type, response.size(), &response);
    conn->send({ span<char>(fresponse) });
}

void http_error(tcp_connection* conn, rostring code) {
    rostring fstr(
        "HTTP/1.1 %S\n"
        "Content-Length: 0\n"
        "Connection: close\n"
    );
    string fresponse = format(fstr, &code);
    conn->send({ span<char>(fresponse) });
}