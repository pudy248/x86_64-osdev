bits 32

extern _screenW
extern _screenH
extern _framebuffer

global inb
inb:
    xor eax, eax
    mov edx, [esp + 4]
    in al, dx
    ret

global outb
outb:
    mov edx, [esp + 4]
    mov eax, [esp + 8]
    out dx, al
    ret

global rdtscp_low
rdtscp_low:
    lfence
    rdtsc
    ret

global rdtscp_high
rdtscp_high:
    lfence
    rdtsc
    mov eax, edx
    ret

global testFunc
testFunc:
    mov eax, dword [esp + 4]
    ret;


global loadIDT
loadIDT:
    mov eax, dword [esp + 4]
    lidt [eax]

    ;disable PIC
    mov al, 0xff
    out 0xa1, al
    out 0x21, al

    sti
    ret

global divErr
divErr:
    mov eax, 0
    idiv eax
    ret

global memcpyl
memcpyl:
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov edi, dword [ebp + 8]
    mov esi, dword [ebp + 12]
    mov ecx, dword [ebp + 16]
    mov edx, ecx
    cld
    
    shr ecx, 2
    rep movsd

    mov ecx, edx
    and ecx, 3
    rep movsb

    pop edi
    pop esi
    pop ebp
    ret


global vsync
vsync:
    mov dx, 0x3DA
    vsync_l1:
        in al, dx
        test al, 8
    jnz vsync_l1
    vsync_l2:
        in al, dx
        test al, 8
    jz vsync_l2
    ret