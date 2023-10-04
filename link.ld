OUTPUT_FORMAT("elf32-i386");
ENTRY(start);
SECTIONS
{
    .bootloader 0x7C00: AT(0) {
        tmp/bootloader.o(.text);
    }

    .sig 0x7DFE: AT(0x1FE) {
        SHORT(0xaa55);
    }

    .text 0x80000200: AT(0x200) {
        *(.text.startup);
        *(.text);
        *(.data);
        *(.rodata*);
    }

    .bss : {
        *(.bss)
    }

    .rawdata 0x80010000: AT(0x10000) {
        *(.rawdata)
    }

    /DISCARD/: {
        *(.eh_frame)
        *(.comment)
    }
}