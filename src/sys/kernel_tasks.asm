bits 32
extern kChooseTask

%define taskTable 0x1400
%define flagOffset 0x4
%define indexTable 0x1800
%define taskCount 0x1840

global Yield
Yield:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp

    xor eax, eax
    mov al, byte [indexTable]
    shl eax, 4
    add eax, taskTable

    mov dword [eax], esp

    ;Pick new task
    xor ecx, ecx
    xor edx, edx
    mov cl, byte [indexTable]
    taskLoop:
    inc cl
    cmp cl, byte [taskCount]
    cmove ecx, edx
    mov eax, ecx
    shl eax, 4
    add eax, taskTable + flagOffset
    mov al, byte [eax]
    and al, 1 ;present flag
    jz taskLoop

    mov byte [indexTable], cl ;select task

    ;Resume selected task
    xor eax, eax
    mov al, byte [indexTable]
    shl eax, 4
    add eax, taskTable

    mov esp, dword [eax]
    
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

global KillCurrentTask
KillCurrentTask:
    xor eax, eax
    mov al, byte [indexTable]
    shl eax, 4
    add eax, taskTable + flagOffset
    mov byte [eax], 0

    ;Pick new task
    xor ecx, ecx
    xor edx, edx
    mov cl, byte [indexTable]
    taskLoop2:
    inc cl
    cmp cl, byte [taskCount]
    cmove ecx, edx
    mov eax, ecx
    shl eax, 4
    add eax, taskTable + flagOffset
    mov al, byte [eax]
    and al, 1 ;present flag
    jz taskLoop2

    mov byte [indexTable], cl ;select task

    ;Resume selected task
    xor eax, eax
    mov al, byte [indexTable]
    shl eax, 4
    add eax, taskTable

    mov esp, dword [eax]
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


global ForceYield
ForceYield:
    mov eax, [esp + 4] ;param 1: task index
    mov byte [indexTable], al
    shl eax, 4
    add eax, taskTable

    mov esp, dword [eax]
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret