bits 16
extern stage1_main
%include "bootloader/constants.asm"

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
    
    ;mov byte [drive_num], dl
    ;mov dl, byte [drive_num]

    mov si, drive_packet
    cmp word [required_block_count], 0
    jz load_sectors
    load_block:
        ;mov ah, 0x0e
        ;mov si, block_err_msg
        ;print_loop:
        ;    mov al, byte [si]
        ;    inc si
        ;    or al, al
        ;    jz print_end
        ;    int 0x10
        ;    jmp print_loop
        ;print_end:
        ;jmp $
        mov ah, 0x42
        int 0x13
        add word [drive_sector], 0x800
        add dword [drive_lba], 64
        dec word [required_block_count]
        jnz load_block
    load_sectors:
        mov ah, 0x42
        mov cx, word [required_sector_count]
        mov word [drive_num_sectors], cx
        int 0x13


    ; Build page structures
    mov ax, 0x7000
    mov es, ax
    mov di, 0
    push di
    mov ecx, 0x1000
    xor eax, eax
    rep stosd
    pop di
    
    ; Build the Page Map Level 4.
    mov eax, 0x71000 | PAGE_FLAGS     ; Put the address of the Page Directory Pointer Table in to EAX.
    mov [es:di], eax                  ; Store the value of EAX as the first PML4E.
    
    ; Build the Page Directory Pointer Table.
    ; mov ecx, 1
    mov eax, 0x72000 | PAGE_FLAGS     ; Put the address of the Page Directory in to EAX.
    mov di, 0x1000
    ; .PDPLoop:
        mov [es:di], eax
    ;    add eax, 0x1000
    ;    add di, 8
    ;    dec ecx
    ; jnz .PDPLoop
    
    ; Build the Page Directory Tables.
    ; mov ecx, 1
    mov eax, PAGE_FLAGS | PAGE_SIZE
    mov di, 0x2000
    ; .PDLoop:
        mov [es:di], eax
    ;    add eax, 0x200000
    ;    add di, 8
    ;    dec ecx
    ; jnz .PDLoop
    
    jmp stage1_main

block_err_msg: db "Loading more than 64 sectors in bootstrap not supported.", 0
drive_num: db 0

; load bootstrap code
required_sector_count:
    dw (PARTITION_LBA - 1) % 64
required_block_count:
    dw (PARTITION_LBA - 1) / 64

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
    disk_id: dd 0x12345678
    reserved: dw 0
    partition1:
        attrs: db 0x80
        chs_start: db 0xff, 0xff, 0xff
        sysid: db 0x0c ;fat32 LBA
        chs_end: db 0xff, 0xff, 0xff
        lba_start: dd PARTITION_LBA
        lba_size: dd 0x01f000
    partitions2to4: times 48 db 0
    dw 0xaa55
