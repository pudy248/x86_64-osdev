#include <cstdint>
#include <kstdlib.hpp>
#include <kstdio.hpp>
#include <kstring.hpp>
#include <sys/debug.hpp>
#include <stl/container.hpp>
#include <stl/vector.hpp>
#include <lib/fat.hpp>
#include <drivers/keyboard.hpp>

vector<debug_symbol> symbol_table;
static bool is_enabled = false;

void load_debug_symbs(const char* filename) {
    FILE f = file_open(filename);
    istringstream str(rostring(f.inode->data));

    
    /* // readelf -s
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
        char* name = (char*)walloc(tmp.size() + 1, 0x10);
        memcpy(name, tmp.begin(), tmp.size());
        name[tmp.size()] = 0;
        symb.name = name;
        str.read_c();

        symbol_table.append(symb);
        //printf("%08x %04x %10s\n", symb.addr, symb.size, symb.name.begin());
    } */

    // llvm-objdump --syms
    str.read_c();
    str.read_until_v<rostring>('\n', true);
    str.read_c();
    str.read_until_v<rostring>('\n', true);
    
    while (str.readable()) {
        debug_symbol symb;
        symb.addr = (void*)str.read_x();
        char tmp2[16];
        str.bzread(tmp2, 9);
        str.read_until_v<rostring>('\t', true);
        symb.size = str.read_x();
        str.read_c();
        rostring tmp = str.read_until_v<rostring>('\n');
        char* name = (char*)walloc(tmp.size() + 1, 0x10);
        memcpy(name, tmp.begin(), tmp.size());
        name[tmp.size()] = 0;
        symb.name = name;
        str.read_c();

        symbol_table.append(symb);
        //printf("%08x %04x %10s\n", symb.addr, symb.size, symb.name.begin());
    }

    f.inode->close();
    is_enabled = true;
}

debug_symbol& nearest_symbol(void* address, bool* out_contains) {
    int bestIdx = 0;
    uint64_t bestDistance = INT64_MAX;
    for (int i = 0; i < symbol_table.size(); i++) {
        uint64_t distance = (uint64_t)address - (uint64_t)symbol_table[i].addr - 5;
        if (distance < bestDistance || (distance == bestDistance && symbol_table[i].size > symbol_table[bestIdx].size)) {
            bestIdx = i;
            bestDistance = distance;
        }
    }
    if (out_contains) *out_contains = bestDistance < symbol_table[bestIdx].size;
    return symbol_table[bestIdx];
}

void stacktrace() {
    if(!is_enabled) return;
    uint64_t* rbp = (uint64_t*)__builtin_frame_address(0);
    print("\nIDX:  RETURN    STACKPTR  NAME\n");
    qprintf<512>("  0:  %08x  %08x  %s\n", get_rip(), rbp, nearest_symbol(get_rip()).name);
    for (int i = 1; rbp[1]; i++) {
        qprintf<512>("% 3i:  %08x  %08x  %s\n", i, rbp[1], rbp, nearest_symbol((void*)rbp[1]).name);
        rbp = (uint64_t*)*rbp;
    }
    print("\n");
    wait_until_kbhit();
}

void wait_until_kbhit() {
    while (true) {
        if (*(volatile uint8_t*)&keyboardInput.pushIdx == keyboardInput.popIdx) continue;
        else if (key_to_ascii(keyboardInput.loopqueue[keyboardInput.popIdx]) != 'c') {
            keyboardInput.popIdx = keyboardInput.pushIdx;
            continue;
        }
        else break;
    }
    keyboardInput.popIdx = keyboardInput.pushIdx;
}