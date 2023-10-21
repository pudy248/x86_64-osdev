bits 32

global vsync
vsync:
    mov dx, 0x3DA
    vsync_l1:
        in al, dx
        test al, 8
    jnz vsync_l1
    vsync_l2:
        in al, dx
        test al, 8
    jz vsync_l2
    ret