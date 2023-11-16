bits 32

extern memcpy

global longjmp
longjmp:
    mov eax, [esp + 4]
    jmp eax

global longcall
longcall:
    mov ebp, esp
    sub esp, dword [ebp + 8]
    and esp, 0xfffffff0

    push dword [ebp + 8] ;size
    mov eax, ebp
    add eax, 12
    push eax ;source
    mov eax, esp
    add eax, 8
    push eax ;dest
    call memcpy
    add esp, 12
    
    mov eax, dword [ebp + 4]
    call eax
    add esp, dword [ebp + 8]
    ret

global cpu_id:
cpu_id:
    push ebp
    mov ebp, esp
    push ebx

    mov eax, dword [ebp + 8]
    cpuid
    push edx
    push ecx
    push ebx
    push eax
    
    mov edx, dword [ebp + 12]
    
    mov ecx, dword [esp]
    mov dword [edx], ecx
    pop eax

    mov ecx, dword [esp]
    mov dword [edx + 4], ecx
    pop eax

    mov ecx, dword [esp]
    mov dword [edx + 8], ecx
    pop eax

    mov ecx, dword [esp]
    mov dword [edx + 12], ecx
    pop eax

    pop ebx
    pop ebp
    ret

global enable_avx
enable_avx:
    xor ecx, ecx
    xgetbv
    or eax, 7
    xsetbv
    ret

global get_cr_reg
get_cr_reg:
    mov edx, dword [esp + 4]
    mov ecx, dword [_get_cr_operands+edx]
    mov byte [_get_cr_instr+2], cl

    _get_cr_instr:
    mov eax, cr0
    ret

global set_cr_reg
set_cr_reg:
    mov eax, dword [esp + 8]
    mov edx, dword [esp + 4]
    mov ecx, dword [_get_cr_operands+edx]
    mov byte [_set_cr_instr+2], cl

    _set_cr_instr:
    mov cr0, eax
    ret

_get_cr_operands: db 0xc0, 0xd0, 0xd8, 0xe0
_set_cr_operands: db 0xc1, 0xd1, 0xd9, 0xe1

global inb
inb:
    xor eax, eax
    mov edx, [esp + 4]
    in al, dx
    ret
    
global inw
inw:
    xor eax, eax
    mov edx, [esp + 4]
    in ax, dx
    ret
    
global inl
inl:
    xor eax, eax
    mov edx, [esp + 4]
    in eax, dx
    ret

global outb
outb:
    mov edx, [esp + 4]
    mov eax, [esp + 8]
    out dx, al
    ret
    
global outw
outw:
    mov edx, [esp + 4]
    mov eax, [esp + 8]
    out dx, ax
    ret
    
global outl
outl:
    mov edx, [esp + 4]
    mov eax, [esp + 8]
    out dx, eax
    ret
