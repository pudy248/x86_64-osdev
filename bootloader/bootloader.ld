OUTPUT_FORMAT("elf32-i386");
ENTRY(start);
SECTIONS
{
    .bootloader 0x7C00: AT(0) {
        tmp/bootloader/mbr.o(.text);
        *(.text);
        *(.text16);
        *(.data);
        *(.rodata);
        *(.rodata.*);
    }
    .bss : {
        *(.bss);
    }

    .fat 0x9C00: AT(0x2000) {
        KEEP(*(.fat));
    }

    /DISCARD/: {
        *(.eh_frame)
        *(.comment)
    }
}