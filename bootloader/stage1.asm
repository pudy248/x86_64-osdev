bits 16
extern stage2_main

global stage1_main
stage1_main:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov sp, 0x7c00

    mov ax, 0x2402
    int 0x15
    cmp al, 1
    jz a20_activated
    mov ax, 0x2401
    int 0x15
    a20_activated:

    mov al, 0xFF
    out 0xA1, al
    out 0x21, al

    lidt [IDT]

    ; Arcane incantation
    mov eax, 10100000b
    mov cr4, eax
    mov edx, 0x70000
    mov cr3, edx
    mov ecx, 0xC0000080
    rdmsr
    or eax, 0x00000100
    wrmsr
    mov ebx, cr0
    or ebx,0x80000001
    mov cr0, ebx                    

    lgdt [GDT]

    jmp 0x18:stage1_and_a_half

bits 64
stage1_and_a_half:
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    mov rsp, 0x1fffe0
    mov rbp, rsp
    mov qword [rbp], 0
    mov qword [rbp + 8], 0
    mov qword [rbp + 16], 0
    mov qword [rbp + 24], 0

    call enable_sse
    call enable_avx
    
    call stage2_main
    add rsp, 8
    jmp rax

enable_sse:
    mov rax, cr0
    and al, 0xfb
    or rax, 0x2
    mov cr0, rax
    mov rax, cr4
    or rax, 0x600
    mov cr4, rax
    ret

enable_avx:
    mov rax, cr4
    or rax, 0x40000
    mov cr4, rax

    xor rcx, rcx
    xgetbv
    or rax, 7
    xsetbv
    ret

ALIGN 4
IDT:
    .Length       dw 0
    .Base         dd 0
dw 0

GDT:
   dw GDT_END - GDT_START - 1
   dd GDT_START

GDT_START:       
            dd 0,0
    code16  db 0xff, 0xff, 0, 0, 0, 10011011b, 00001111b, 0
    data16  db 0xff, 0xff, 0, 0, 0, 10010011b, 00001111b, 0
    code64  db 0xff, 0xff, 0, 0, 0, 10011011b, 10101111b, 0
    data64  db 0xff, 0xff, 0, 0, 0, 10010011b, 10101111b, 0
GDT_END: