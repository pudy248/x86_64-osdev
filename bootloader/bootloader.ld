OUTPUT_FORMAT("elf32-i386");
ENTRY(stage0_main);
SECTIONS
{
    .bootloader 0x7C00: AT(0) {
        KEEP(tmp/bootloader/stage0.o(.text));
        *(.text);
        *(.data);
        *(.data.*);
        *(.rodata);
        *(.rodata.*);
        *(.bss);
        *(.bss.*);
    }

    .fat 0x9C00: AT(0x2000) {
        KEEP(*(.fat));
    }

    /DISCARD/: {
        *(.eh_frame)
        *(.comment)
    }
}