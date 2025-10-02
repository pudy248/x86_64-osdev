bits 16
extern stage1_main
%include "bootloader/include.asm"

;PRESENT | WRITE
%define PAGE_FLAGS 0x01 | 0x02
%define PAGE_SIZE 128

global stage0_main
stage0_main:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    
    ; mov byte [drive_num], dl

    mov si, drive_packet
    cmp word [required_block_count], 0
    jz load_sectors
    load_block:
        mov ah, 0x42
        int 0x13
        jc print_error
        add word [drive_sector], 0x800
        add dword [drive_lba], 64
        dec word [required_block_count]
        jnz load_block
    load_sectors:
        mov ah, 0x42
        mov cx, word [required_sector_count]
        mov word [drive_num_sectors], cx
        int 0x13
        jc print_error

    mov ax, 0x7000
    mov es, ax
    xor di, di
    mov ecx, 0x1000
    xor eax, eax
    rep stosd

    xor di, di
    mov eax, 0x71000 | PAGE_FLAGS
    mov [es:di], eax
    
    mov eax, PAGE_SIZE | PAGE_FLAGS
    mov di, 0x1000
    ; .PDPLoop:
        mov [es:di], eax
    ;    add eax, 0x1000
    ;    add di, 8
    ;    dec ecx
    ; jnz .PDPLoop
    
    mov ax, 0x6F00
    mov es, ax
    xor edi, edi
    
    xor eax, eax
    mov ecx, 0x400
    rep stosd
    xor edi, edi
    xor ebx, ebx
    mov edx, 0x534D4150
    .e820:
        mov eax, 0xe820
        mov ecx, 24
        int 0x15
        jc .e820_end
        test ebx, ebx
        jz .e820_end
        add edi, 24
        jmp .e820
    .e820_end:

    jmp stage1_main

print_error:
    mov al, ah
    shr al, 4
    xor bx, bx
    mov bl, al
    mov al, byte [hex + bx]
    mov [err_msg], al
    mov al, ah
    and al, 0xf
    mov bl, al
    mov al, byte [hex + bx]
    mov [err_msg + 1], al
    mov ah, 0x0e
    mov si, err_msg
    .print_loop:
        mov al, byte [si]
        inc si
        or al, al
        jz .print_end
        int 0x10
        jmp .print_loop
    .print_end:
    jmp $

msg: db "   ", 0
err_msg: db "   ERR", 0
hex: db "0123456789abcdef"
drive_num: db 0

; load bootstrap code
required_sector_count:
    dw (BOOTLOADER_RESERVED_SECTORS - 1) % 64
required_block_count:
    dw (BOOTLOADER_RESERVED_SECTORS - 1) / 64

drive_packet:
    db 0x10
    db 0
    drive_num_sectors:
        dw 64
    drive_address:
        dw 0
    drive_sector:
        dw 0x07E0
    drive_lba:
        dd 1
        dd 0

times 0x1b8 - ($ - $$) db 0
partitionTable:
    disk_id: dd 0 ;0xa8124232
    reserved: dw 0
    partition1:
        attrs: db 0x80
        chs_start: db 0xff, 0xff, 0xff
        sysid: db 0x0c ;fat32 LBA
        chs_end: db 0xff, 0xff, 0xff
        lba_start: dd BOOTLOADER_RESERVED_SECTORS
        lba_size: dd TOTAL_SECTORS
    partitions2to4: times 48 db 0
    dw 0xaa55
