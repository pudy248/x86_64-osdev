bits 16
extern start

jmp short mbr_entry
nop

FAT_BPB:
    oem_name: db "kefka-os"
    bytes_per_sector: dw 512
    sectors_per_cluster: db 8
    reserved_sectors: dw 32
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
    sectors_per_fat32: dd 1
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
    volume_label: db "TEST VOL   "
    volume_identifier: db "FAT32   "

global mbr_entry
mbr_entry:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov sp, 0x3000
    

    xor bx, bx
    mov ds, bx
    mov ah, 0x42
    mov si, drive_packet
    int 0x13

    jmp start

drive_packet:
    db 0x10
    db 0
    num_sectors:
        dw 7
    drive_address:
        dw 0
        dw 0x07e0
    drive_segment:
        dd 1
        dd 0

times 510 - ($ - $$) db 0
dw 0xaa55

FAT32_FSINFO:
    sig1: dd 0x41615252
    times 512+484 - ($ - $$) db 0
    sig2: dd 0x61417272
    free_cluster_count: dd 0xffffffff
    cluster_number: dd 0xffffffff
    reserved3: dd 0,0,0
    sig3: dd 0xaa550000