bits 32

extern isr_err
extern isr_no_err
extern irq_isr

%macro isr_err_stub 1
isr_stub_%+%1:
    mov eax, %1
    push eax
    call isr_err
    add esp, 8
    iret 
%endmacro

%macro isr_no_err_stub 1
isr_stub_%+%1:
    mov eax, %1
    push eax
    call isr_no_err
    add esp, 4
    iret
%endmacro

%macro irq_stub 1
isr_stub_%+%1:
    mov eax, %1
    push eax
    call irq_isr
    add esp, 4
    iret 
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

global isr_stub_table
isr_stub_table:
%assign i 0 
%rep    40 
    dd isr_stub_%+i
%assign i i+1 
%endrep