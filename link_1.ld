OUTPUT_FORMAT("elf32-i386");
ENTRY(_start);
SECTIONS
{
    .mem_offset MEM_OFFSET - 4 : {
        LONG(MEM_OFFSET);
    }
    
    .text MEM_OFFSET : {
        KEEP(THIS_FILE(.exec_header));
        KEEP(THIS_FILE(.text));
    }
    THIS_FILE_OFFSET = ADDR(.text) + SIZEOF(.text);
    DEFINE OFFSET THIS_FILE_OFFSET
    GEN_INCLUDE
}