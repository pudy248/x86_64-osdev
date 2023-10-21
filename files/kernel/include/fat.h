#pragma once
#include <typedefs.h>

#define MBR_PARTITION_START     0x1b8
#define PARTITION_ATTR_ACTIVE   0x80
#define SIG_MBR_FAT32           0x0c
#define SIG_BPB_FAT32           0x29


// __ prefix indicates ignored by driver
typedef struct partition_entry {
    uint8_t     attributes;
    uint8_t     __chs_start[3];
    uint8_t     sysid;
    uint8_t     __chs_end[3];
    uint32_t    lba_start;
    uint32_t    lba_size;
} __attribute__((packed)) partition_entry;

typedef struct partition_table {
    uint32_t    disk_id;
    uint16_t    __reserved;
    partition_entry entries[4];
} __attribute__((packed)) partition_table;

typedef struct fat32_bpb {
    //FAT BPB
    char        __jump[3];
    char        oem_name[8];
    uint16_t    bytes_per_sector;
    uint8_t     sectors_per_cluster;
    uint16_t    reserved_sectors;
    uint8_t     fat_tables;
    uint16_t    root_dir_entries;
    uint16_t    __total_sectors_short;
    uint8_t     __media_descriptor_type;
    uint16_t    __sectors_per_fat;
    uint16_t    __sectors_per_track;
    uint16_t    __num_heads;
    uint32_t    __num_hidden_sectors;
    uint32_t    total_sectors_long;
    //FAT32 EBPB
    uint32_t    sectors_per_fat32;
    uint16_t    fat_flags;
    uint16_t    __fat_version;
    uint32_t    root_cluster_num;
    uint16_t    fsinfo_sector;
    uint16_t    __backup_boot_sector;
    uint8_t     __reserved[12];
    uint8_t     __drive_num;
    uint8_t     __reserved2;
    uint8_t     signature;
    uint32_t    volume_id;
    char        volume_label[11];
    char        volume_identifier[8];
} __attribute__((packed)) fat32_bpb;

typedef uint32_t* fat_table;

typedef struct fat_date {
    uint16_t    day:5;
    uint16_t    month:4;
    uint16_t    year:7; //since 1980
} fat_date;
typedef struct fat_time {
    uint16_t    dseconds:5; //double-seconds, 1-30
    uint16_t    minute:6;
    uint16_t    hour:5;
} fat_time;

typedef struct fat_file {
    char        filename[8];
    char        extension[3];
    uint8_t     flags;
    //uint8_t     reserved;
    //uint8_t     creation_tenths;
    //fat_time    creation_time;
    //fat_date    creation_date;
    //fat_date    accessed_date;
    uint64_t    load_address;
    uint16_t    cluster_high;
    fat_time    modified_time;
    fat_date    modified_date;
    uint16_t    cluster_low;  
    uint32_t    file_size;
} __attribute__((packed)) fat_file;

#define file_func(retType, name, params, file, index) \
    retType (*name) params = ( retType(*) params )(((uint32_t*)file)[index])

//This is not defined in fat.c, but is expected to be defined somewhere. This should essentially be a stub which invokes the relevant driver.
void read_disk(void* address, uint32_t lbaStart, uint32_t lbaCount);

void set_fat_constants(partition_entry* partition, fat32_bpb* bpb);
uint32_t get_cluster_lba(uint32_t cluster);
void* get_cluster_addr(uint32_t cluster);
int search_dir(fat_file* directory, const char* name);

void read_cluster_chain(uint32_t address, uint32_t cluster);
void read_file(void* address, fat_file file);
int read_file_from_name(void* address, fat_file* directory, const char* name);
int read_code_file_from_name(fat_file* directory, const char* name);
void read_code_file(fat_file file);

uint32_t code_fn_addr(fat_file file, uint32_t index);
