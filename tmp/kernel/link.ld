OUTPUT_FORMAT("elf32-i386");
ENTRY(_start);
SECTIONS
{
    .text 0x80000000 - 4 : {
        LONG(0x80000000);
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
