#pragma once
#include <kstring.hpp>

struct tcp_connection;

bool http_process(tcp_connection* conn, struct tcp_fragment p);
void http_send(tcp_connection* conn, rostring type, rostring response);
void http_error(tcp_connection* conn, rostring code);