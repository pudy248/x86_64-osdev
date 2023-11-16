#include <common.h>
#include <fat.h>
#include <disk.h>
#include <rtc.h>
#include <idt.h>
#include <basic_console.h>
#include <kernel16/exports.h>

__attribute__((noreturn)) void kernel_main(void);
void init_protected(void);

void read_disk(void* address, uint32_t lbaStart, uint32_t lbaCount) {
    basic_printf("read disk %x %x %x\r\n", address, lbaStart, lbaCount);
    bios_disk_load(address, lbaStart, (uint16_t)lbaCount);
    init_protected();
    //hexdump(address, 32);
}

static void keyboard_delay() {
    bios_int_regs regs = {0, 0, 0, 0, 0, 0, 0, 0};
    bios_interrupt(0x16, regs);
}

void init_protected() {
    load_idt(idtptr);
}

static fat_file* rootDir;
static fat_file require(const char* filename) {
    int file = search_dir(rootDir, filename);
    if(file < 0) {
        basic_printf("Error loading required file: %s\r\n", filename);
        while(1);
    }
    read_code_file(rootDir[file]);
    return rootDir[file];
}
static fat_file require_dat(const char* filename, void* address) {
    int file = search_dir(rootDir, filename);
    if(file < 0) {
        basic_printf("Error loading required file: %s\r\n", filename);
        while(1);
    }
    read_file(address, rootDir[file]);
    return rootDir[file];
}

__attribute__((noreturn)) void kernel_main() {
    basic_console_init();
    basic_putstr("Kernel entry point reached.\r\n");
    idt_init();
    init_protected();

    partition_table* partTable = (partition_table*)(0x7c00 + MBR_PARTITION_START);
    int activeEntry = 0;
    fat32_bpb* bpb = (fat32_bpb*)0x200000;
    set_fat_constants(&partTable->entries[activeEntry], bpb);
    rootDir = (fat_file*)get_cluster_addr(bpb->root_cluster_num);
    basic_putstr("Kernel FAT table loaded.\r\n");
    
    fat_file rotate = require("rendererimg");
    require_dat("cow     obj", 0x60000000);

    longcall(code_fn_addr(rotate, 0), 4, 0x60000000);
    basic_putstr("exit\r\n");
    
    while(1);
}
