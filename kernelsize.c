#include <stdio.h>
#include <stdint.h>
#include <string.h>

int main() {
    FILE* f = fopen("tmp/main.bin", "r+b");
    fseek(f, 0, SEEK_END);
    uint64_t sz = ftell(f);
    uint8_t szc[8];
    memcpy(szc, &sz, 8);
    fseek(f, 0x1F6, SEEK_SET);
    fwrite(szc, 1, 8, f);
    fclose(f);
}