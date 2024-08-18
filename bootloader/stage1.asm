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

    ;Enable A20
    mov ax, 0x2402
    int 0x15
    cmp al, 1
    jz a20_activated
    mov ax, 0x2401
    int 0x15
    a20_activated:

    ; Disable IRQs
    mov al, 0xFF
    out 0xA1, al
    out 0x21, al

    lidt [IDT]

    ; Enter long mode.
    mov eax, 10100000b                ; Set the PAE and PGE bit.
    mov cr4, eax
    mov edx, 0x70000                  ; Point CR3 at the PML4.
    mov cr3, edx
    mov ecx, 0xC0000080               ; Read from the EFER MSR. 
    rdmsr
    or eax, 0x00000100                ; Set the LME bit.
    wrmsr
    mov ebx, cr0                      ; Activate long mode -
    or ebx,0x80000001                 ; - by enabling paging and protection simultaneously.
    mov cr0, ebx                    

    lgdt [GDT]

    jmp 0x18:LongMode             ; Load CS with 64 bit segment and flush the instruction cache

bits 64

LongMode:
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    mov rsp, 0x1ffff0
    mov rbp, rsp
    mov qword [rbp], 0

    ; Blank out the screen to a blue color.
    mov edi, 0xB8000
    mov rcx, 500                      ; Since we are clearing uint64_t over here, we put the count as Count/4.
    mov rax, 0x1F201F201F201F20       ; Set the value to set the screen to: Blue background, white foreground, blank spaces.
    rep stosq                         ; Clear the entire screen. 
 
    ; Display "Hello World!"
    mov edi, 0x00b8000              
 
    mov rax, 0x1F6C1F6C1F651F48    
    mov [edi],rax
 
    mov rax, 0x1F6F1F571F201F6F
    mov [edi + 8], rax
 
    mov rax, 0x1F211F641F6C1F72
    mov [edi + 16], rax

    call enable_sse
    call enable_avx
    
    call stage2_main
    sub rsp, 8
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