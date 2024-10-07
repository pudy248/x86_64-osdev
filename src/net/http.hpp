#pragma once
#include <kstring.hpp>
#include <net/tcp.hpp>

constexpr uint16_t HTTP_PORT = 80;

struct http_response {
	int code;
	vector<uint8_t> header;
	vector<uint8_t> content;
};

http_response http_get(tcp_conn_t conn);

bool http_process(tcp_conn_t conn, rostring p);
void http_send(tcp_conn_t conn, rostring type, rostring response);
void http_error(tcp_conn_t conn, rostring code);

http_response http_req_get(tcp_conn_t conn, rostring uri);
