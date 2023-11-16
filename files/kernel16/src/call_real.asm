bits 32
;void call_real(void* fnPtr);
global call_real
call_real:
    mov edx, dword [esp + 4]
    push ebx
    push esi
    push edi
    push ebp
    mov dword [old_esp], esp
    cli
    jmp 0x8:callreal_prot16
bits 16
    callreal_prot16:
    mov bx, 0x10
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov ss, bx

    mov eax, cr0
    and eax, 0xfe
    mov cr0, eax
    jmp 0x0:callreal_real
    callreal_real:
        xor bx, bx
        mov ds, bx
        mov es, bx
        mov fs, bx
        mov ss, bx
        mov sp, 0x4000

        lidt [idt_real]
        sti
        call dx
        cli
        mov eax, cr0
        or eax, 1
        mov cr0, eax
    jmp 0x18:callreal_protected
bits 32
    callreal_protected:
    mov bx, 0x20
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    mov ss, bx
    mov esp, dword [old_esp]
    pop ebp
    pop edi
    pop esi
    pop ebx
    ret

old_esp: dd 0
idt_real: 
    dw 0x3ff
    dd 0
