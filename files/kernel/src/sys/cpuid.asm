bits 64

global cpu_id:
cpu_id:
    push rbp
    mov rbp, rsp
    push rbx

    mov rax, rdi
    cpuid
    push rdx
    push rcx
    push rbx
    push rax
    
    mov rdx, rsi
    
    mov ecx, dword [rsp]
    mov dword [edx], ecx
    pop rax

    mov ecx, dword [rsp]
    mov dword [edx + 4], ecx
    pop rax

    mov ecx, dword [rsp]
    mov dword [edx + 8], ecx
    pop rax

    mov ecx, dword [rsp]
    mov dword [edx + 12], ecx
    pop rax

    pop rbx
    pop rbp
    ret
