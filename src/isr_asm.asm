bits 64

extern isr_err
extern isr_no_err
extern irq_isr

save_regs:
    push rdx
    mov rdx, 0x10000
    mov qword [rdx], rax
    mov qword [rdx + 8], rbx
    mov qword [rdx + 16], rcx
    mov rax, rdx
    pop rdx
    mov qword [rax + 24], rdx
    mov qword [rax + 32], rsi
    mov qword [rax + 40], rdi
    mov qword [rax + 48], rbp
    mov qword [rax + 64], r8
    mov qword [rax + 72], r9
    mov qword [rax + 80], r10
    mov qword [rax + 88], r11
    mov qword [rax + 96], r12
    mov qword [rax + 104], r13
    mov qword [rax + 112], r14
    mov qword [rax + 120], r15

    mov rdx, qword [rsp + 8]
    mov qword [rax + 128], rdx ;CS
    mov rdx, qword [rsp + 16]
    mov qword [rax + 144], rdx ;RIP
    mov rdx, qword [rsp + 24]
    mov qword [rax + 136], rdx ;RFLAGS
    mov rdx, qword [rsp + 32]
    mov qword [rax + 56], rdx  ;RSP
    mov rdx, qword [rsp + 40]
    mov qword [rax + 152], rdx ;SS
    ret

stor_regs:
    mov rax, 0x10000
    mov r15, qword [rax + 120]
    mov r14, qword [rax + 112]
    mov r13, qword [rax + 104]
    mov r12, qword [rax + 96]
    mov r11, qword [rax + 88]
    mov r10, qword [rax + 80]
    mov r9, qword [rax + 72]
    mov r8, qword [rax + 64]
    mov rbp, qword [rax + 48]
    mov rdi, qword [rax + 40]
    mov rsi, qword [rax + 32]
    mov rdx, qword [rax + 24]
    mov rcx, qword [rax + 16]
    mov rbx, qword [rax + 8]
    push qword [rax]
    pop rax
    ret
    
%macro isr_err_stub 1
isr_stub_%+%1:
    push rax
    mov rax, qword [rsp + 8]
    mov qword [rsp - 8], rax
    pop rax
    add rsp, 8

    call save_regs

    mov rdi, %1
    mov rdx, qword [rsp - 24]

    mov rsi, 0x10000
    push rbp
    mov rbp, rsp
    call isr_err
    pop rbp

    call stor_regs

    iretq
%endmacro

%macro isr_no_err_stub 1
isr_stub_%+%1:
    call save_regs

    mov rdi, %1
    mov rsi, rbx
    push rbp
    mov rbp, rsp
    call isr_no_err
    pop rbp

    call stor_regs

    iretq
%endmacro

%macro irq_stub 1
isr_stub_%+%1:
    call save_regs

    mov rdi, %1
    mov rsi, rbx
    push rbp
    mov rbp, rsp
    call irq_isr
    pop rbp

    call stor_regs

    iretq
%endmacro

isr_no_err_stub 0
isr_no_err_stub 1
isr_no_err_stub 2
isr_no_err_stub 3
isr_no_err_stub 4
isr_no_err_stub 5
isr_no_err_stub 6
isr_no_err_stub 7
isr_err_stub    8
isr_no_err_stub 9
isr_err_stub    10
isr_err_stub    11
isr_err_stub    12
isr_err_stub    13
isr_err_stub    14
isr_no_err_stub 15
isr_no_err_stub 16
isr_err_stub    17
isr_no_err_stub 18
isr_no_err_stub 19
isr_no_err_stub 20
isr_no_err_stub 21
isr_no_err_stub 22
isr_no_err_stub 23
isr_no_err_stub 24
isr_no_err_stub 25
isr_no_err_stub 26
isr_no_err_stub 27
isr_no_err_stub 28
isr_no_err_stub 29
isr_err_stub    30
isr_no_err_stub 31
irq_stub        32
irq_stub        33
irq_stub        34
irq_stub        35
irq_stub        36
irq_stub        37
irq_stub        38
irq_stub        39
irq_stub        40
irq_stub        41
irq_stub        42
irq_stub        43
irq_stub        44
irq_stub        45
irq_stub        46
irq_stub        47

global isr_stub_table
isr_stub_table:
%assign i 0 
%rep    48
    dd isr_stub_%+i
%assign i i+1 
%endrep

global load_idt
load_idt:
    cli
    lidt [rdi]
    ;disable PIC
    mov al, 0xff
    out 0x21, al
    out 0xa1, al
    sti
    ret