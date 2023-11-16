bits 32

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

global memset
memset:
    push ebp
    mov ebp, esp
    push edi

    mov edi, dword [ebp + 8]
    mov eax, dword [ebp + 12]
    mov ecx, dword [ebp + 16]
    mov edx, ecx
    cld
    
    shr ecx, 2
    rep stosd

    mov ecx, edx
    and ecx, 3
    rep stosb

    pop edi
    pop ebp
    ret

global memcpy_sse
memcpy_sse:
    push ebp
    mov ebp, esp
    push esi
    push edi
    fwait
    fxsave [0x10000]

    mov edi, dword [ebp + 8]
    mov esi, dword [ebp + 12]
    mov ecx, dword [ebp + 16]

    shr ecx, 7
    jz .loop_end
    .loop:
        movdqa      xmm0, [esi+00h] 
        movdqa      xmm1, [esi+10h] 
        movdqa      [edi+00h], xmm0 
        movdqa      [edi+10h], xmm1 
        movdqa      xmm2, [esi+20h] 
        movdqa      xmm3, [esi+30h] 
        movdqa      [edi+20h], xmm2 
        movdqa      [edi+30h], xmm3 
        movdqa      xmm4, [esi+40h] 
        movdqa      xmm5, [esi+50h] 
        movdqa      [edi+40h], xmm4 
        movdqa      [edi+50h], xmm5 
        movdqa      xmm6, [esi+60h] 
        movdqa      xmm7, [esi+70h] 
        add         esi,80h
        movdqa      [edi+60h], xmm6 
        movdqa      [edi+70h], xmm7
        add         edi,80h
        dec         ecx
        jnz .loop
    .loop_end:
    mov ecx, dword [ebp + 16]
    shr ecx, 4
    and ecx, 7
    jz .loop2_end
    .loop2:
        movdqa      xmm0, [esi+00h] 
        movdqa      [edi+00h], xmm0 
        add         esi,10h
        add         edi,10h
        dec         ecx
        jnz .loop2
    .loop2_end:
    
    fxrstor [0x10000]
    pop edi
    pop esi
    pop ebp
    ret

align 16
memset_xmm_buffer: dq 0,0

global memset_sse
memset_sse:
    push ebp
    mov ebp, esp
    push edi
    fwait
    fxsave [0x10000]

    mov edi, dword [ebp + 8]
    mov eax, dword [ebp + 12]
    
    mov dword [memset_xmm_buffer], eax
    mov dword [memset_xmm_buffer+4], eax
    mov dword [memset_xmm_buffer+8], eax
    mov dword [memset_xmm_buffer+12], eax
    
    mov ecx, dword [ebp + 16]

    shr ecx, 7
    jz .loop_end
    movdqa      xmm0, [memset_xmm_buffer] 
    movdqa      xmm1, [memset_xmm_buffer] 
    movdqa      xmm2, [memset_xmm_buffer] 
    movdqa      xmm3, [memset_xmm_buffer] 
    movdqa      xmm4, [memset_xmm_buffer] 
    movdqa      xmm5, [memset_xmm_buffer] 
    movdqa      xmm6, [memset_xmm_buffer] 
    movdqa      xmm7, [memset_xmm_buffer] 
    .loop:
        movdqa      [edi+00h], xmm0 
        movdqa      [edi+10h], xmm1 
        movdqa      [edi+20h], xmm2 
        movdqa      [edi+30h], xmm3 
        movdqa      [edi+40h], xmm4 
        movdqa      [edi+50h], xmm5 
        movdqa      [edi+60h], xmm6 
        movdqa      [edi+70h], xmm7
        add         edi,80h
        dec         ecx
        jnz .loop
    .loop_end:
    mov ecx, dword [ebp + 16]
    shr ecx, 4
    and ecx, 7
    jz .loop2_end
    movdqa      xmm0, [memset_xmm_buffer] 
    .loop2:
        movdqa      [edi+00h], xmm0 
        add         edi,10h
        dec         ecx
        jnz .loop2
    .loop2_end:
    
    fxrstor [0x10000]
    pop edi
    pop ebp
    ret
