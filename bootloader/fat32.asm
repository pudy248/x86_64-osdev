section .fat
bits 16

%include "bootloader/constants.asm"

%macro SETORG 1
    times (%1) - ($ - $$) db 0
%endmacro

jmp short start
nop

FAT_BPB:
    oem_name: db "kefka-os"
    bytes_per_sector: dw 512
    sectors_per_cluster: db SECTORS_PER_CLUSTER
    reserved_sectors: dw RESERVED_SECTORS
    fat_tables: db 2
    root_dir_entries: dw 0
    total_sectors: dw 0
    media_descriptor_type: db 0xF8
    sectors_per_fat: dw 0
    sectors_per_track: dw 63
    num_heads: dw 255
    num_hidden_sectors: dd 0
    large_sector_count: dd 0xffe000
FAT32_EBPB:
    sectors_per_fat32: dd SECTORS_PER_FAT32
    flags: dw 0
    fat_version: dw 0
    root_cluster_number: dd 2
    fsinfo_sector: dw 1
    backup_boot_sector: dw 6
    reserved1: dd 0,0,0
    drive_num: db 0x80
    reserved2: db 0
    signature: db 0x29
    volume_id: dd 0x12345678
    volume_label: db "TEST VOLUME"
    volume_identifier: db "FAT32   "

start:
    mov si, errstr
    mov ah, 0x0e
    xor bx, bx
    strLoop:
    mov al, byte [si]
    cmp al, 0
    je strEnd
    int 0x10
    inc si
    jmp strLoop
    strEnd:
    jmp $
    errstr: db "Attempted to boot to FAT partition header!", 0

SETORG 0x1FE
dw 0xaa55

FAT32_FSINFO:
    sig1: dd 0x41615252
    SETORG 0x3E4
    ;times 512+484 - ($ - $$) db 0
    sig2: dd 0x61417272
    free_cluster_count: dd 0xffffffff
    cluster_number: dd 0xffffffff
    reserved3: dd 0,0,0
    sig3: dd 0xaa550000
