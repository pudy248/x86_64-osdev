#pragma once
#include <inttypes.hpp>

#define ELF_TYPE_NONE       0x00
#define ELF_TYPE_REL        0x01
#define ELF_TYPE_EXEC       0x02
#define ELF_TYPE_DYN        0x03

#define ELF_MARCH_x86_64    0x3E

#define ELF_PT_NULL         0x00
#define ELF_PT_LOAD         0x01
#define ELF_PT_PHDR         0x06

#define ELF_PF_X            0x01
#define ELF_PF_R            0x02
#define ELF_PF_W            0x04

#define ELF_SHT_NULL        0x00
#define ELF_SHT_PROGBITS    0x01
#define ELF_SHT_SYMTAB      0x02
#define ELF_SHT_STRTAB      0x03
#define ELF_SHT_NOBITS      0x08

#define ELF_SHF_WRITE       0x01
#define ELF_SHF_ALLOC       0x02
#define ELF_SHF_EXECINSTR   0x04
#define ELF_SHF_MERGE       0x10
#define ELF_SHF_STRINGS     0x20

typedef struct {
    uint8_t magic[4];       //0x7f 0x45 0x4c 0x46
    uint8_t x64;            //1 or 2
    uint8_t big_endian;     //1 or 2
    uint8_t version;        //1
    uint8_t abi;            //0 for System-V
    uint8_t abi_ver;        //Ignored
    uint8_t pad_0[7];
    uint16_t type;          //ELF_TYPE_*
    uint16_t machine;       //ELF_MARCH_*
    uint32_t version_2;     //1
    uint64_t entry;         //Mem offset of entry
    uint64_t phoff;         //File offset of program headers
    uint64_t shoff;         //File offset of section headers
    uint32_t flags;         //Architecture-specific
    uint16_t header_size;   //sizeof(elf_header)
    uint16_t phent_size;    //sizeof(elf_program)
    uint16_t phnum;         //Number of program headers
    uint16_t shent_size;    //sizoef(elf_section)
    uint16_t shnum;         //Number of sections
    uint16_t shstridx;      //Section index of section name section
} __attribute__((packed)) elf_header;

typedef struct {
    uint32_t type;          //ELF_PT_*
    uint32_t flags;         //ELF_PF_*
    uint64_t offset;        //File offset of section
    uint64_t vaddr;         //Virtual memory offset of section
    uint64_t paddr;         //Physical memory offset of section
    uint64_t filesize;      //File size of segment in bytes
    uint64_t memsize;       //Memory size of segment in bytes
    uint64_t alignment;     //A power-of-two alignment boundary
} __attribute__((packed)) elf_program;

typedef struct {
    uint32_t name;          //Offset in shstrtab to name
    uint32_t type;          //ELF_SHT_*
    uint64_t sh_flags;      //ELF_SHF_*
    uint64_t addr;          //Virtual memory address of section
    uint64_t offset;        //File offset of section
    uint64_t size;          //File size of segment in bytes
    uint32_t link;          //Unused
    uint32_t info;          //Unused
    uint64_t alignment;     //A power-of-two alignment boundary
    uint64_t entsize;       //Size in bytes of entries for sections with fixed-size entries
} __attribute__((packed)) elf_section;