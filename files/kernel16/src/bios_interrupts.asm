bits 32
extern call_real
global bios_interrupt
bios_interrupt:
    mov eax, dword [esp + 4]
    mov byte [interrupt], al
    mov eax, dword [esp + 8]
    mov word [int_ax], ax
    mov eax, dword [esp + 10]
    mov word [int_bx], ax
    mov eax, dword [esp + 12]
    mov word [int_cx], ax
    mov eax, dword [esp + 14]
    mov word [int_dx], ax
    mov eax, dword [esp + 16]
    mov word [int_si], ax
    mov eax, dword [esp + 18]
    mov word [int_di], ax
    mov eax, dword [esp + 20]
    mov word [int_ds], ax
    mov eax, dword [esp + 22]
    mov word [int_es], ax
    
    push dword bios_interrupt_real
    call call_real
    add esp, 4
    ret

bits 16
bios_interrupt_real:
    mov al, byte [interrupt]
    mov byte [intL+1], al

    mov ax, word [int_ax]
    push ax
    mov bx, word [int_bx]
    mov cx, word [int_cx]
    mov dx, word [int_dx]
    mov si, word [int_si]
    mov di, word [int_di]

    mov ax, word [int_es]
    mov es, ax
    mov ax, word [int_ds]
    mov ds, ax
    pop ax

    intL:
    int 0
    ret

int_ax: dw 0
int_bx: dw 0
int_cx: dw 0
int_dx: dw 0
int_si: dw 0
int_di: dw 0
int_ds: dw 0
int_es: dw 0
interrupt: db 0
