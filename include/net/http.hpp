#pragma once
#include <kstddefs.h>
#include <kstring.hpp>
#include <net/tcp.hpp>

bool http_process(tcp_connection* conn, tcp_packet p);
void http_send(tcp_connection* conn, rostring type, rostring response);
void http_error(tcp_connection* conn, rostring code);