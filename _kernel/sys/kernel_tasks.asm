bits 32

%define TASK_TABLE 0x11000
%define INDEX_TABLE 0x11800
%define FLAG_OFFSET 0x4

global yield
yield:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    xor eax, eax
    mov al, byte [INDEX_TABLE]
    shl eax, 4
    add eax, TASK_TABLE

    mov dword [eax], esp

    ;Pick new task
    xor ecx, ecx
    xor edx, edx
    mov cl, byte [INDEX_TABLE]
    taskLoop:
    inc cl
    cmp cl, byte [taskCount]
    cmove ecx, edx
    mov eax, ecx
    shl eax, 4
    add eax, TASK_TABLE + FLAG_OFFSET
    mov al, byte [eax]
    and al, 1 ;present flag
    jz taskLoop

    mov byte [INDEX_TABLE], cl ;select task

    ;Resume selected task
    xor eax, eax
    mov al, byte [INDEX_TABLE]
    shl eax, 4
    add eax, TASK_TABLE

    mov esp, dword [eax]
    
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


global yield_noreturn
yield_noreturn:
    mov eax, [esp + 4] ;param 1: task index
    mov byte [INDEX_TABLE], al
    shl eax, 4
    add eax, TASK_TABLE

    mov esp, dword [eax]
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


global _die
_die:
    xor eax, eax
    mov al, byte [INDEX_TABLE]
    shl eax, 4
    add eax, TASK_TABLE + FLAG_OFFSET
    mov byte [eax], 0

    ;Pick new task
    xor ecx, ecx
    xor edx, edx
    mov cl, byte [INDEX_TABLE]
    taskLoop2:
    inc cl
    cmp cl, byte [taskCount]
    cmove ecx, edx
    mov eax, ecx
    shl eax, 4
    add eax, TASK_TABLE + FLAG_OFFSET
    mov al, byte [eax]
    and al, 1 ;present flag
    jz taskLoop2

    mov byte [INDEX_TABLE], cl ;select task

    ;Resume selected task
    xor eax, eax
    mov al, byte [INDEX_TABLE]
    shl eax, 4
    add eax, TASK_TABLE

    mov esp, dword [eax]
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


global taskTablePtr
taskTablePtr: dd TASK_TABLE
global indexTablePtr
indexTablePtr: dd INDEX_TABLE
global taskCount
taskCount: dd 0