#pragma once
#include <kstddefs.h>

typedef uint64_t PML4E;
typedef uint64_t PDPTE;
typedef uint64_t PDTE;
typedef uint64_t PTBE;

#define PAGE_P  0x01
#define PAGE_RW 0x02
#define PAGE_US 0x04
#define PAGE_WT 0x08
#define PAGE_UC 0x10
#define PAGE_A  0x20
#define PAGE_D  0x40
#define PAGE_SZ 0x80

typedef struct {
    PML4E entries[512];
} PML4;

typedef struct {
    PDPTE entries[512];
} PDPT;
typedef struct {
    PDTE entries[512];
} PDT;

typedef struct {
    PTBE entries[512];
} PTB;

void set_page_flags(void* addr, uint8_t flags);
void unset_page_flags(void* addr, uint8_t flags);
