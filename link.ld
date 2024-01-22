OUTPUT_FORMAT("elf64-x86-64");
ENTRY(_start);
SECTIONS
{
    .text 0x1000000 : {
        QUAD(0x1000000);
        *(.text);
        *(.text.*);
    }
    .data : {
        *(.data);
        *(.data.*);
        *(.rodata);
        *(.rodata.*);
    }
    .bss : {
        *(.bss);
        *(.bss.*);
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
    }
}