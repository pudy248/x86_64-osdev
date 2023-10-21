OUTPUT_FORMAT("elf32-i386");
ENTRY(_start);
SECTIONS
{
    .mem_offset MEM_OFFSET - 4 : {
        KEEP(*(.mem_offset))
    }
    .text MEM_OFFSET : {
        KEEP(*(.text));
    }

    /DISCARD/ : {
        *(.link_reloc.*);
    }
}