bits 64

%define KEEP_YMMS

%define REGISTER_FILE_PTR 0x60030
%define REGISTER_FILE_PTR_SWAP 0x60038

extern handle_exception ; (uint64_t int_num, uregister_file* registers, int64_t err_code, bool is_fatal)
extern pic_eoi
extern isr_fns

global swap_context

save_regs:
    mov qword [rsp-0x28], rdx
    mov rdx, qword [REGISTER_FILE_PTR]
    mov qword [rdx], rax
    mov rax, rdx
    mov rdx, qword [rsp-0x28]
    mov qword [rax + 8], rbx
    mov qword [rax + 16], rcx
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
    mov qword [rax + 128], rdx ;RIP
    mov rdx, qword [rsp + 24]
    mov qword [rax + 136], rdx ;RFLAGS
    mov rdx, qword [rsp + 32]
    mov qword [rax + 56], rdx  ;RSP
    mov qword [rax + 144], rsp
    
%ifdef KEEP_YMMS
    vmovdqa [rax + 160], ymm0
    vmovdqa [rax + 192], ymm1
    vmovdqa [rax + 224], ymm2
    vmovdqa [rax + 256], ymm3
    vmovdqa [rax + 288], ymm4
    vmovdqa [rax + 320], ymm5
    vmovdqa [rax + 352], ymm6
    vmovdqa [rax + 384], ymm7
    vmovdqa [rax + 416], ymm8
    vmovdqa [rax + 448], ymm9
    vmovdqa [rax + 480], ymm10
    vmovdqa [rax + 512], ymm11
    vmovdqa [rax + 544], ymm12
    vmovdqa [rax + 576], ymm13
    vmovdqa [rax + 608], ymm14
    vmovdqa [rax + 640], ymm15
    vzeroupper
%endif

    ret

restore_regs:
    mov rax, qword [REGISTER_FILE_PTR]
    mov rdi, qword [rsp]

%ifdef KEEP_YMMS
    vmovdqa ymm15, [rax + 640]
    vmovdqa ymm14, [rax + 608]
    vmovdqa ymm13, [rax + 576]
    vmovdqa ymm12, [rax + 544]
    vmovdqa ymm11, [rax + 512]
    vmovdqa ymm10, [rax + 480]
    vmovdqa ymm9, [rax + 448]
    vmovdqa ymm8, [rax + 416]
    vmovdqa ymm7, [rax + 384]
    vmovdqa ymm6, [rax + 352]
    vmovdqa ymm5, [rax + 320]
    vmovdqa ymm4, [rax + 288]
    vmovdqa ymm3, [rax + 256]
    vmovdqa ymm2, [rax + 224]
    vmovdqa ymm1, [rax + 192]
    vmovdqa ymm0, [rax + 160]
%endif

    ; Just in case, don't touch the frame!
    ; In case of stack movement in the saved register file we need this, but our case doesn't do that

    mov rsp, qword [rax + 144] ; ISR RSP
    mov qword [rsp], rdi
    mov rdx, qword [rax + 128]
    mov qword [rsp + 8], rdx ; RIP
    mov qword [rsp + 16], 0x18
    mov rdx, qword [rax + 136]
    mov qword [rsp + 24], rdx ; RFLAGS
    mov rdx, qword [rax + 56]
    mov qword [rsp + 32], rdx  ; RSP
    mov qword [rsp + 40], 0x20

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
    mov rax, qword [rax]
    ret

; frame: 
; rsp+0x30: interrupt stack frame
; rsp+0x28: save/rstor return address
; rsp+0x20: int num
; rsp+0x18: err num
; rsp+0x10: is_fatal
; rsp+0x08: virtual_ret_addr
; rsp+0x00: virtual_rbp
handle_interrupt:
    call save_regs ;rax := frame ptr
    sub rsp, 0x38
    mov rdx, qword [rsp + 0x38] ; ret rip
    mov qword [rsp + 0x00], rdx
    mov rdx, qword [rsp + 0x50] ; ret rsp
    mov qword [rsp + 0x08], rdx

    mov rdi, qword [rsp + 0x28]
    mov rsi, rax
    mov rax, qword [isr_fns + 8 * rdi]
    test rax, rax
    jz .no_interrupt_handler
        call rax
        jmp .end_handler_switch
    .no_interrupt_handler:
        mov rdx, qword [rsp + 0x20]
        mov rcx, qword [rsp + 0x18]
        call handle_exception
    .end_handler_switch:
    mov rdi, qword [rsp + 0x28]
    cmp rdi, 32
    jl .not_pic
    sub rdi, 32
    cli
    call pic_eoi
    .not_pic:
    add rsp, 0x40
    call restore_regs
    iretq

isr_stub_30:
    call save_regs
    mov rax, qword [REGISTER_FILE_PTR]
    xchg rax, qword [REGISTER_FILE_PTR_SWAP]
    mov qword [REGISTER_FILE_PTR], rax
    call restore_regs
    iretq

isr_stub_31:
    iretq

swap_context:
    mov rax, qword [REGISTER_FILE_PTR]
    mov qword [rax + 8], rbx
    mov qword [rax + 48], rbp
    mov qword [rax + 56], rsp
    mov qword [rax + 96], r12
    mov qword [rax + 104], r13
    mov qword [rax + 112], r14
    mov qword [rax + 120], r15
    mov rdx, qword [rsp]
    mov qword [rax + 128], rdx

    xchg rax, qword [REGISTER_FILE_PTR_SWAP]
    mov rbx, qword [rax + 8]
    mov rdi, qword [rax + 40]
    mov rbp, qword [rax + 48]
    mov rsp, qword [rax + 56]
    mov r12, qword [rax + 96]
    mov r13, qword [rax + 104]
    mov r14, qword [rax + 112]
    mov r15, qword [rax + 120]
    mov rdx, qword [rax + 128]
    mov qword [rsp], rdx

    mov qword [REGISTER_FILE_PTR], rax
    ret

%macro isr_err_stub 1
isr_stub_%+%1:
    xchg rax, qword [rsp]
    mov qword [rsp - 0x08], %1
    mov qword [rsp - 0x10], rax
    mov qword [rsp - 0x18], 1
    pop rax
    jmp handle_interrupt
%endmacro

%macro isr_no_err_stub 1
isr_stub_%+%1:
    mov qword [rsp - 0x10], %1
    mov qword [rsp - 0x18], 0
    mov qword [rsp - 0x20], 0
    jmp handle_interrupt
%endmacro

%macro irq_stub 1
isr_stub_%+%1:
    mov qword [rsp - 0x10], %1
    mov qword [rsp - 0x18], 0
    mov qword [rsp - 0x20], 0
    jmp handle_interrupt
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
; Context switch
; Debug no-op
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
    mov al, 0x7b ; Allow fallthrough
    out 0x21, al
    mov al, 0xff
    out 0xa1, al
    sti
    ret