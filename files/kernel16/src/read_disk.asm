bits 32
extern call_real

global set_disk_num_bios
set_disk_num_bios:
    mov eax, dword [esp + 4]
    mov byte [drive_num], al
    ret

global read_disk_bios
read_disk_bios:
    mov eax, dword [esp + 4]
    mov dword [mem_ctr], eax
    mov eax, dword [esp + 8]
    mov dword [drive_lba], eax
    mov eax, dword [esp + 12]
    mov word [sec_ctr], ax

    push esi
    push dword read_disk_real
    call call_real
    add esp, 4

    pop esi
    ret

bits 16
read_disk_real:
    xor bx, bx
    mov ds, bx
    mov dl, byte [drive_num]
    mov si, drive_packet

    cmp dword [sec_ctr], 64
    jl disk_loop_end

    mov word [drive_num_sectors], 64
    disk_loop:
        mov ah, 0x42
        int 0x13
        
        mov eax, dword [mem_ctr]
        mov ebx, 0x40000
        mov ecx, 0x8000
        memcpy:
            mov edx, dword [ebx]
            mov dword [gs:eax], edx
            add eax, 4
            add ebx, 4
            dec ecx
        jnz memcpy
        mov dword [mem_ctr], eax
        
        ;move to next block
        add dword [drive_lba], 64
        sub dword [sec_ctr], 64
        cmp dword [sec_ctr], 64
        jmp $
    jge disk_loop
    disk_loop_end:
    cmp dword [sec_ctr], 0
    je read_disk_ret

    mov ebx, dword [sec_ctr]
    mov word [drive_num_sectors], bx
    mov ah, 0x42
    int 0x13
    
    mov eax, dword [mem_ctr]
    mov ebx, 0x40000
    mov ecx, dword [sec_ctr]
    shl ecx, 9
    memcpy2:
        mov edx, dword [ebx]
        mov dword [gs:eax], edx
        add eax, 4
        add ebx, 4
        dec ecx
    jnz memcpy2
    mov dword [mem_ctr], eax

    read_disk_ret:
    ret


mem_ctr: dd 0
sec_ctr: dd 0

drive_num: db 0x80

drive_packet:
    db 0x10
    db 0
    drive_num_sectors:
        dw 64
    drive_address:
        dw 0
    drive_sector:
        dw 0x4000
    drive_lba:
        dd 1
        dd 0