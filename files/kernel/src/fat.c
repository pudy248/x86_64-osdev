#include <typedefs.h>
#include <common.h>
#include <fat.h>
#include <basic_console.h>

static uint16_t sectorsPerCluster;
static uint32_t firstClusterLBA;
static uint16_t bytesPerCluster;
static uint32_t firstClusterAddr;
static fat_table fatTable;

static fat_table get_fat_addr(fat32_bpb* bpb, uint8_t fat_index) {
    if(fat_index > bpb->fat_tables) return (fat_table)0;
    uint32_t baseAddr = (uint32_t)bpb + bpb->bytes_per_sector * bpb->reserved_sectors;
    uint32_t tableSize = (uint32_t)bpb->bytes_per_sector * bpb->sectors_per_fat32;
    return (fat_table)(baseAddr + tableSize * fat_index);
}

void set_fat_constants(partition_entry* partition, fat32_bpb* bpb) {
    sectorsPerCluster = bpb->sectors_per_cluster;
    firstClusterLBA = partition->lba_start + (bpb->reserved_sectors + bpb->fat_tables * bpb->sectors_per_fat32);
    bytesPerCluster = sectorsPerCluster * bpb->bytes_per_sector;
    firstClusterAddr = (uint32_t)bpb + bpb->bytes_per_sector * (bpb->reserved_sectors + bpb->fat_tables * bpb->sectors_per_fat32);
    fatTable = get_fat_addr(bpb, 0);
}

uint32_t get_cluster_lba(uint32_t cluster) {
    return firstClusterLBA + (cluster - 2) * sectorsPerCluster;
}
void* get_cluster_addr(uint32_t cluster) {
    return (void*)(firstClusterAddr + (cluster - 2) * bytesPerCluster);
}

static char filenamecmp(const char* fn1, const char* fn2) {
    for(int i = 0; i < 11; i++) {
        if(fn1[i] != fn2[i]) return 0;
    }
    return 1;
}
int search_dir(fat_file* directory, const char* name) {
    int fileIdx = -1;
    for(int i = 1; directory[i].filename[0] != 0; i++) {
        if(filenamecmp(&directory[i].filename[0], name))
            fileIdx = i;
    }
    return fileIdx;
}

static uint32_t count_consecutive_clusters(uint32_t startCluster) {
    uint32_t c = startCluster;
    uint32_t i = 0;
    while(fatTable[c] == c + 1) {
        i++;
        c++;
    }
    return i + 1;
}
void read_cluster_chain(uint32_t address, uint32_t cluster) {
    while((cluster & 0x0fffffff) < 0x0ffffff7 && cluster != 0) {
        uint32_t count = count_consecutive_clusters(cluster);
        uint32_t lbaStart = get_cluster_lba(cluster);
        uint32_t lbaCount = count * sectorsPerCluster;
        basic_printf("Reading clusters %x+%x to addr %x\r\n", cluster, count, address);
        read_disk((void*)address, lbaStart, lbaCount);
        address += count * bytesPerCluster;
        cluster = fatTable[cluster + count - 1];
    }
}
void read_file(void* address, fat_file file) {
    read_cluster_chain((uint32_t)address, ((uint32_t)file.cluster_high << 16) | file.cluster_low);
}
int read_file_from_name(void* address, fat_file* directory, const char* name) {
    int idx = search_dir(directory, name);
    if(idx >= 0) read_file(address, directory[idx]);
    return idx;
}

void read_code_file(fat_file file) {
    read_file((void*)file.load_address, file);
}
int read_code_file_from_name(fat_file* directory, const char* name) {
    int idx = search_dir(directory, name);
    if(idx >= 0) read_code_file(directory[idx]);
    return idx;
}
uint32_t code_fn_addr(fat_file file, uint32_t index) {
    return ((uint32_t*)file.load_address)[index];
}
