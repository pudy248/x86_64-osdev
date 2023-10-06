extern main
bits 16

;%define VESA
;%define VESA_MODES
%define UNREAL_DISK_LOAD
%define A20
%define PROTECTED_32

global start
start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov sp, 0x3000
    mov byte [drive_num], dl

%ifdef A20
    cli
    mov ax, 0x2402
    int 0x15
    cmp al, 1
    jz a20_activated
    
    mov ax, 0x2401
    int 0x15
    a20_activated:
    sti
%endif

%ifdef UNREAL_DISK_LOAD
    cli
    push ds

    mov eax, cr0
    or al,1
    mov cr0, eax
    
    lgdt [gdtinfo]
    jmp 0x8:pmode
    pmode:
        mov bx, 0x18
        mov ds, bx
        and al,0xFE
        mov cr0, eax
        jmp 0x0:unreal
    unreal:
        pop es
        sti
    ;compute disk size
    mov eax, dword [0x7df6]
    shr eax, 15 ;numblocks
    inc eax
    mov word [block_count], ax

    disk_loop:
        xor bx, bx
        mov ds, bx
        mov ah, 0x42
        mov dl, byte [drive_num]
        mov si, drive_packet
        int 0x13
        jnc noerr
            mov bh, 0x0f
            mov eax, 0xb8000
            mov bl, 'E'
            mov word [ds:eax], bx
            mov eax, 0xb8002
            mov bl, 'R'
            mov word [ds:eax], bx
            mov eax, 0xb8004
            mov word [ds:eax], bx
            jmp $
        noerr:

        mov eax, dword [mem_index]
        mov ebx, 0x10000
        mov ecx, 0x2000
        memcpy:
            mov edx, dword [ebx]
            mov dword [es:eax], edx
            add eax, 4
            add ebx, 4
            dec ecx
        jnz memcpy
        mov dword [mem_index], eax
        
        ;move to next cylinder
        add dword [drive_segment], 64
        dec word [block_count]
    jnz disk_loop
    
    mov bx, 0x0f41
    mov eax, 0xb8000
    mov word [ds:eax], bx
%else
    ;        |   DH   |   DL   |   CH   |   CL   |
    ;HEAD    |xxxxxx  |        |        |        |
    ;DRIVE   |        |xxxxxxxx|        |        |
    ;CYLINDER|      ??|        |xxxxxxxx|xx      |
    ;SECTOR  |        |        |        |  xxxxxx|
    ;
    ;ADDRESS |        ES       |        BX       |
    mov bx, 0x1000 ;segment
    mov es, bx
    mov bx, 0x0000 ;offset
    mov ax, 0x0212 ;read sectors
    mov cx, 1 ;sector index (1 indexed???)
    mov dh, 0 ;zero
    int 0x13
%endif

%ifdef VESA
    ;10F = 320x200
    ;112 = 640x480
    ;118 = 1024x768
    ;11B = 1280x1024
    %define VMODE 0x017F
    ;get framebuffer addr
	mov di, 0x2000
	mov cx, VMODE
	mov ax, 0x4f01
	int 0x10
    mov ax, word [0x2010]
    mov word [_pitch], ax
    mov ax, word [0x2012]
    mov word [_screenW], ax
    mov ax, word [0x2014]
    mov word [_screenH], ax
    mov eax, dword [0x2028]
    mov dword [_framebuffer], eax
    
    ;set mode
	mov ax, 0x4F02	; set VBE mode
    mov bx, 0x4000 | VMODE	; VBE mode number; notice that bits 0-13 contain the mode number and bit 14 (LFB) is set and bit 15 (DM) is clear.
    int 0x10
%endif
%ifdef VESA_MODES
    ;get modes
    mov byte [0x2000], 'V'
    mov byte [0x2001], 'E'
    mov byte [0x2002], 'S'
    mov byte [0x2003], 'A'
    mov ax, 0
    mov ds, ax
    mov es, ax

	mov di, 0x2000
	mov ax, 0x4f00
	int 0x10

    mov ax, word [0x2010]
    mov fs, ax
    mov si, word [0x200e]
    vesa_mode_loop:
        mov ax, word [fs:si]
        add si, 2
        push ax
        call printWord
        mov al, ':'
        int 0x10
        mov al, ' '
        int 0x10

        mov di, 0x3000
        mov cx, word [esp]
        mov ax, 0x4f01
        int 0x10
        mov ax, word [0x3012]
        call printWord
        mov al, 'x'
        int 0x10
        mov ax, word [0x3014]
        call printWord
        mov al, 'x'
        int 0x10
        mov dl, byte [0x3019]
        call printByte
        
        mov al, 0xd
        int 0x10
        mov al, 0xa
        int 0x10

        mov ecx, 0x20000000
        call nop_ecx

        pop ax
        cmp ax, 0xffff
    jne vesa_mode_loop
    jmp $


    ;delays for ~10xECX cycles
    nop_ecx:
        nop_loop:
            nop
            dec ecx
        jnz nop_loop
        ret

    ;prints ax, clobbers bx, dx
    printWord:
        mov dx, ax
        xchg dh, dl
        call printByte
        xchg dh, dl
        call printByte
        ret

    ;prints dl
    printByte:
        mov ah, 0x0e
        
        mov bh, 0
        mov bl, dl
        shr bl, 4
        add bx, hexTable
        mov al, byte [es:bx]
        int 0x10

        mov bh, 0
        mov bl, dl
        and bl, 0xf
        add bx, hexTable
        mov al, byte [es:bx]
        int 0x10
        ret
%endif

%ifdef PROTECTED_32
    cli

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    lgdt [gdtinfo]

    mov ax, 0x18
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x1F0000
    mov ebp, esp

    
    mov bx, 0x0f42
    mov eax, 0xb8002
    mov word [ds:eax], bx

    jmp 0x10:entry32

bits 32
entry32:
    mov bx, 0x0f43
    mov eax, 0xb8004
    mov word [ds:eax], bx
    call main
    jmp $
bits 16
%else
    jmp $
%endif

hexTable:
    db "0123456789ABCDEF"

global _framebuffer
global _pitch
global _screenW
global _screenH
_framebuffer:
    dd 0
_pitch:
    dw 0
_screenW:
    dw 0
_screenH:
    dw 0

drive_num:
    db 0

;blocks are 32k, 0x100 blocks is 8MB
block_count:
    dw 0x80
mem_index:
    dd 0x80000000

drive_packet:
    db 0x10
    db 0
num_sectors:
    dw 64
drive_address:
    dw 0
    dw 0x1000
drive_segment:
    dd 0
    dd 0

gdtinfo:
   dw gdt_end - gdt - 1
   dd gdt
gdt         dd 0,0
flatcode    db 0xff, 0xff, 0, 0, 0, 10011010b, 10001111b, 0
protcode    db 0xff, 0xff, 0, 0, 0, 10011010b, 11001111b, 0
flatdata    db 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0
gdt_end:



db 0