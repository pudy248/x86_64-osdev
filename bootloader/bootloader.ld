OUTPUT_FORMAT("elf64-x86-64");
ENTRY(stage0_main);
SECTIONS
{
    .bootloader 0x7C00: AT(0) {
        KEEP(tmp/stage0.o(.text));
        KEEP(tmp/stage1.o(.text));
        . = ALIGN(8);
        start_ctors = .;
        *(.init_array*);
        *(SORT(.ctors*));
        end_ctors = .;
        . = ALIGN(8);
        start_dtors = .;
        *(.fini_array*);
        *(SORT(.dtors*));
        end_dtors = .;
        QUAD(0);
        *(.text*);
        *(.data*);
        *(.rodata*);
        . = ALIGN(8);
        start_bss = .;
        *(.bss*);
        . = ALIGN(8);
        end_bss = .;
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
    }
}