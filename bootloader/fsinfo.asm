bits 64
%include "bootloader/include.asm"

FAT32_FSINFO:
    sig1: dd 0x41615252
    SETORG 0x1E4
    sig2: dd 0x61417272
    free_cluster_count: dd 0xffffffff
    cluster_number: dd 0xffffffff
    reserved3: dd 0,0,0
    sig3: dd 0xaa550000