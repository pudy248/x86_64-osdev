OUTPUT_FORMAT("elf64-x86-64");
ENTRY(_start);
SECTIONS
{
    .text 0x1000000 : {
        QUAD(0x1000000);
        *(.text*);
        start_ctors = .;
        *(SORT(.ctors*))
        end_ctors = .;
        start_dtors = .;
        *(SORT(.dtors*))
        end_dtors = .;
    }
    .data : {
        *(.data*);
        *(.rodata*);
    }
    .bss : {
        *(.bss*);
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
    }
}