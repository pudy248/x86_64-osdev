OUTPUT_FORMAT("elf32-i386");
ENTRY(_start);
SECTIONS
{
    .text MEM_OFFSET - 4 : {
        LONG(MEM_OFFSET);
        KEEP(*(.exec_header));
        *(.text);
        *(.text.*);
        *(.data);
        *(.data.*);
        *(.rodata);
        *(.rodata.*);
        *(.bss);
        *(.bss.*);
    }

    /DISCARD/: {
        *(.eh_frame)
        *(.comment)
    }
}