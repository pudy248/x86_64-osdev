#include <basic_console.h>
#include <fat.h>
#include <common.h>

#include <kernel16/exports.h>

__attribute__((noreturn)) void kernel_main(void);

static uint32_t read_disk_addr;

void read_disk(void* address, uint32_t lbaStart, uint32_t lbaCount) {
    basic_printf("read disk %x %x %x\r\n", address, lbaStart, lbaCount);
    longcall(read_disk_addr, 12, address, lbaStart, lbaCount);
    hexdump((uint32_t)address, 32);
}

__attribute__((noreturn)) void kernel_main() {
    basic_console_init();
    basic_putstr("Kernel entry point reached.\r\n");
    
    partition_table* partTable = (partition_table*)(0x7c00 + MBR_PARTITION_START);
    int activeEntry = 0;
    fat32_bpb* bpb = (fat32_bpb*)0x200000;
    set_fat_constants(&partTable->entries[activeEntry], bpb);
    fat_file* rootDir = (fat_file*)get_cluster_addr(bpb->root_cluster_num);
    basic_putstr("Kernel FAT table loaded.\r\n");
    
    read_disk_addr = code_fn_addr(rootDir[search_dir(rootDir, "kernel16img")], 0);

    int rotate = read_code_file_from_name(rootDir, "rotate  img");
    if(rotate < 0) {
        basic_putstr("Error loading cow rotation.");
        while(1);
    }
    int cow = search_dir(rootDir, "cow     obj");
    if(cow < 0) {
        basic_putstr("No cow mesh found.");
        while(1);
    }
    read_file(0x60000000, rootDir[cow]);

    longcall(code_fn_addr(rootDir[rotate], 0), 4, 0x60000000);
    basic_putstr("exit\r\n");

    while(1);
}
