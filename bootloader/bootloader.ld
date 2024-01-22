OUTPUT_FORMAT("elf64-x86-64");
ENTRY(stage0_main);
SECTIONS
{
    .bootloader 0x7C00: AT(0) {
        KEEP(tmp/stage0.o(.text));
        KEEP(tmp/stage1.o(.text));
        *(.text);
        *(.data);
        *(.data.*);
        *(.rodata);
        *(.rodata.*);
        *(.bss);
        *(.bss.*);
    }

    .fat 0x7C00 + 0x8000: AT(0x8000) {
        KEEP(*(.fat));
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
    }
}