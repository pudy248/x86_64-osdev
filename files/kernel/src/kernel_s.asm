bits 32


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

global load_idt
load_idt:
    mov eax, dword [esp + 4]
    lidt [eax]
    ;disable PIC
    mov al, 0xff
    out 0xa1, al
    out 0x21, al
    sti
    ret