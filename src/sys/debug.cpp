#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <sys/debug.hpp>
#include <stl/vector.hpp>
#include <lib/fat.hpp>

vector<debug_symbol> symbol_table;

void load_debug_symbs(const char* filename) {
    FILE f = file_open(filename);
    istringstream str(rostring(f.inode->data));

    str.read_c();
    str.read_until_v<rostring>('\n', true);
    str.read_until_v<rostring>('\n', true);
    
    while (str.readable()) {
        debug_symbol symb;
        str.read_while_v(' ');
        str.read_until_v<rostring>(' ');
        str.read_while_v(' ');
        symb.addr = (void*)str.read_x();
        str.read_while_v(' ');
        symb.size = str.read_x();
        for (int i = 0; i < 4; i++) {
            str.read_while_v(' ');
            str.read_until_v<rostring>(' ');
        }
        str.read_while_v(' ');
        rostring tmp = str.read_until_v<rostring>('\n');
        memcpy(symb.name.begin(), tmp.begin(), tmp.size());
        symb.name[tmp.size()] = 0;
        str.read_c();

        symbol_table.append(symb);
        //printf("%08x %04x %10s\n", symb.addr, symb.size, symb.name.begin());
    }

    f.inode->close();
}

debug_symbol& nearest_symbol(void* address, bool* out_contains) {
    int bestIdx = 0;
    uint64_t bestDistance = INT64_MAX;
    for (int i = 0; i < symbol_table.size(); i++) {
        uint64_t distance = (uint64_t)address - (uint64_t)symbol_table[i].addr;
        if (distance < bestDistance || (distance == bestDistance && symbol_table[i].size > symbol_table[bestIdx].size)) {
            bestIdx = i;
            bestDistance = distance;
        }
    }
    if (out_contains) *out_contains = bestDistance < symbol_table[bestIdx].size;
    return symbol_table[bestIdx];
}

void stacktrace() {
    uint64_t* rbp = (uint64_t*)__builtin_frame_address(0);
    print("IDX:   RETURN STACKPTR NAME\n");
    printf("  0: %08x %08x %s\n", get_rip(), rbp, nearest_symbol(get_rip()).name.begin());
    for (int i = 1; rbp[1]; i++) {
        printf("% 3i: %08x %08x %s\n", i, rbp[1], rbp, nearest_symbol((void*)rbp[1]).name.begin());
        rbp = (uint64_t*)*rbp;
    }
    print("\n");
}