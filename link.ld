OUTPUT_FORMAT("elf32-i386");
ENTRY(start);
SECTIONS
{
    .bootloader1 0x7C00: AT(0) {
        KEEP(tmp/sys/bootloaderloader.o(.text));
        KEEP(tmp/sys/bootloader.o(.text));
    }

    .text 0x80001000: AT(0x10000) {
        *(.text.startup);
        *(.text);
        *(.data);
        *(.rodata*);
    }

    .bss : {
        *(.bss)
    }

    /DISCARD/: {
        *(.eh_frame)
        *(.comment)
    }
}