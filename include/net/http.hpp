#pragma once
#include <kstring.hpp>

struct tcp_connection;
struct tcp_packet;

bool http_process(tcp_connection* conn, tcp_packet p);
void http_send(tcp_connection* conn, rostring type, rostring response);
void http_error(tcp_connection* conn, rostring code);