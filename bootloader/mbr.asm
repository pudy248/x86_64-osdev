bits 16
extern callreal
extern bootstrap_main
%include "bootloader/constants.asm"

global start
start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    mov byte [drive_num], dl

    lgdt [gdtinfo]

    cli
    mov ax, 0x2402
    int 0x15
    cmp al, 1
    jz a20_activated
    mov ax, 0x2401
    int 0x15
    a20_activated:
    sti
    
    xor bx, bx
    mov ds, bx
    mov ah, 0x42
    mov dl, byte [drive_num]
    mov si, drive_packet
    cmp word [required_block_count], 0
    jz load_sectors
    load_block:
        mov ah, 0x0e
        mov si, block_err_msg
        print_loop:
            mov al, byte [si]
            inc si
            or al, al
            jz print_end
            int 0x10
            jmp print_loop
        print_end:
        jmp $
    load_sectors:
        mov cx, word [required_sector_count]
        mov word [drive_num_sectors], cx
        int 0x13
    
    cli
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x200000
    mov ebp, esp

    jmp 0x18:entry32

bits 32
entry32:
    xor edx, edx
    mov dl, byte [drive_num]
    push edx
    call bootstrap_main
    jmp $
bits 16

block_err_msg: db "Loading more than 64 sectors in bootstrap not supported.", 0

drive_num: db 0

; load bootstrap code, FAT BPB, tables, and root dir
required_sector_count:
    dw (PARTITION_LBA - 1) % 64
    ;dw (PARTITION_LBA - 1 + RESERVED_SECTORS + SECTORS_PER_FAT32 * 2 + SECTORS_PER_CLUSTER) % 64
required_block_count:
    dw (PARTITION_LBA - 1) / 64
    ;dw (PARTITION_LBA - 1 + RESERVED_SECTORS + SECTORS_PER_FAT32 * 2 + SECTORS_PER_CLUSTER) / 64

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

gdtinfo:
   dw gdt_end - gdt - 1
   dd gdt
gdt:        dd 0,0
    code16  db 0xff, 0xff, 0, 0, 0, 10011011b, 0x0f, 0
    data16  db 0xff, 0xff, 0, 0, 0, 10010011b, 0x0f, 0
    code32  db 0xff, 0xff, 0, 0, 0, 10011011b, 11001111b, 0
    data32  db 0xff, 0xff, 0, 0, 0, 10010011b, 11001111b, 0
gdt_end:

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
        lba_size: dd 0x1000
    partitions2to4: times 48 db 0
    dw 0xaa55
