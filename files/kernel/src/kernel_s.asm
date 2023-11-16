bits 32

global rdtsc_low
rdtsc_low:
    ;lfence
    rdtsc
    ret

global rdtsc_high
rdtsc_high:
    ;lfence
    rdtsc
    mov eax, edx
    ret
