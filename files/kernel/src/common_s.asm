bits 32

global longjmp
longjmp:
    mov eax, [esp + 4]
    jmp eax

global longcall
longcall:
    mov ebp, esp
    sub esp, dword [ebp + 8]

    push dword [ebp + 8]
    mov eax, ebp
    add eax, 12
    push eax
    mov eax, ebp
    sub eax, dword [ebp + 8]
    push eax
    call memcpy
    add esp, 12
    
    mov eax, dword [ebp + 4]
    call eax
    add esp, dword [ebp + 8]
    ret

global memcpy
memcpy:
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
