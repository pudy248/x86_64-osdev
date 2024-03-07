#pragma once
#include <cstdint>
#include <stl/vector.hpp>

class text_buffer {
    vector<char> before_cursor;
    vector<char> after_cursor;
    vector<int> line_starts;
    int cursor_partition_offset;
    int display_offset;
};