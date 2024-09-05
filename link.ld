OUTPUT_FORMAT("elf64-x86-64");
ENTRY(_start);
SECTIONS
{
    .text 0x1000000 : {
        QUAD(0x1000000);
        QUAD(end_bss);
        QUAD(kernel_main);
        . = ALIGN(8);
        start_ctors = .;
        *(.init_array*);
        *(SORT(.ctors*));
        . = ALIGN(8);
        end_ctors = .;
        start_dtors = .;
        *(.fini_array*);
        *(SORT(.dtors*));
        end_dtors = .;
        QUAD(0);
        *(.text.*);
    }
    .data : {
        *(.data*);
        *(.rodata*);
    }
    .bss : {
        *(.bss*);
    }
    end_bss = .;

    /DISCARD/ : {
        *(.comment)
    }
}