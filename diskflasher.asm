bits 16

%define DISK_SIZE_MB 8

org 0x7c00

start:
    jmp 0x0:set_cs
    set_cs:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    ;call print_byte

    mov si, str1
    call print_str
    xor ax, ax
    int 0x16
    cmp al, '2'
    jne .L1
    mov dl, byte [SRC_DISK]
    xchg dl, byte [DEST_DISK]
    mov byte [SRC_DISK], dl
    .L1:

    mov si, str2
    call print_str

    mov si, drive_packet
    loop_start:
        xor al, al
        mov ah, 0x42
        mov dl, byte [SRC_DISK]
        int 0x13
        jc handle_err
        dec word [drive_lba]
        mov dl, byte [DEST_DISK]
        mov ah, 0x43
        int 0x13
        jc handle_err
        add dword [drive_lba], 65
        dec dword [block_ctr]
    jnz loop_start
    loop_end:

    mov si, str3
    call print_str

    reboot:
    ;pause for keypress
    xor ax, ax
    int 0x16
    ;reboot
    int 0x19

handle_err:
    push ax
    mov si, strerr
    call print_str
    pop dx
    call print_word
    jmp $

print_str:
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
    ret

print_word:
    xchg dh, dl
    call print_byte
    xchg dh, dl
    call print_byte
    ret

print_byte:
    mov ah, 0x0e
    
    mov bh, 0
    mov bl, dl
    shr bl, 4
    add bx, hexTable
    mov al, byte [bx]
    xor bx, bx
    int 0x10

    mov bh, 0
    mov bl, dl
    and bl, 0xf
    add bx, hexTable
    mov al, byte [bx]
    xor bx, bx
    int 0x10
    ret

align 4
block_ctr: dd DISK_SIZE_MB * 32
drive_packet:
    db 0x10
    db 0
    drive_num_sectors:
        dw 64
    drive_address:
        dw 0
    drive_sector:
        dw 0x1000
    drive_lba:
        dd 1
        dd 0

SRC_DISK: db 0x80
DEST_DISK: db 0x81

hexTable: db "0123456789ABCDEF"
str1: db "Press 1 to write, 2 to read.", 0xa, 0xd, 0
str2: db "Flashing USB contents...", 0xa, 0xd, 0
str3: db "Write complete. Remove source media and press any key to continue...", 0xa, 0xd, 0
strerr: db "A disk error has occured: ", 0

; =============================================================
; Partition table is required on real hardware!!!
; Apparently the USB is emulated as a floppy if no bootable parts
; are detected, which breaks the extended disk functions.
; I spent way too long debugging this.
times 0x1b8 - ($ - $$) db 0
partitionTable:
    disk_id: dd 0x12345678
    reserved: dw 0
    partition1:
        attrs: db 0x80
        chs_start: db 0xff, 0xff, 0xff
        sysid: db 0x00
        chs_end: db 0xff, 0xff, 0xff
        lba_start: dd 1
        lba_size: dd 0x1000
    partitions2to4: times 48 db 0
    dw 0xaa55
