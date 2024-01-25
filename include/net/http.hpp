#pragma once
#include <kstddefs.h>
#include <kstring.hpp>
#include <net/tcp.hpp>

bool http_process(volatile tcp_connection* conn, tcp_packet p);
void http_send(volatile tcp_connection* conn, rostring type, rostring response);
void http_error(volatile tcp_connection* conn, rostring code);