OUTPUT_FORMAT("elf64-x86-64");
ENTRY(stage0_main);
SECTIONS
{
    .bootloader 0x7C00: AT(0) {
        KEEP(tmp/stage0.o(.text));
        KEEP(tmp/stage1.o(.text));
        *(.text*);
        start_ctors = .;
        *(SORT(.ctors*))
        end_ctors = .;
        start_dtors = .;
        *(SORT(.dtors*))
        end_dtors = .;
        *(.data*);
        *(.rodata*);
        *(.bss*);
    }

    .fat 0x7C00 + 0x20000: AT(0x20000) {
        KEEP(*(.fat));
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
    }
}