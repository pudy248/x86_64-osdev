#pragma once
#include <cstdint>

#define MBR_PARTITION_START     0x1b8
#define PARTITION_ATTR_ACTIVE   0x80
#define SIG_MBR_FAT32           0x0c
#define SIG_BPB_FAT32           0x29

#define FAT_ATTRIB_RO           0x01
#define FAT_ATTRIB_HIDDEN       0x02
#define FAT_ATTRIB_SYSTEM       0x04
#define FAT_ATTRIB_VOL_ID       0x08
#define FAT_ATTRIB_DIR          0x10
#define FAT_ATTRIB_ARCHIVE      0x20
#define FAT_ATTRIB_LFN          0x0f

#define FAT_TABLE_CHAIN_STOP    0x0ffffff8

typedef struct partition_entry {
    uint8_t     attributes;
    uint8_t     chs_start[3];
    uint8_t     sysid;
    uint8_t     chs_end[3];
    uint32_t    lba_start;
    uint32_t    lba_size;
} __attribute__((packed)) partition_entry;

typedef struct partition_table {
    uint32_t    disk_id;
    uint16_t    reserved;
    partition_entry entries[4];
} __attribute__((packed)) partition_table;

typedef struct fat32_bpb {
    //FAT BPB
    char        jump[3];
    char        oem_name[8];
    uint16_t    bytes_per_sector;
    uint8_t     sectors_per_cluster;
    uint16_t    reserved_sectors;
    uint8_t     fat_tables;
    uint16_t    root_dir_entries;
    uint16_t    total_sectors_short;
    uint8_t     media_descriptor_type;
    uint16_t    sectors_per_fat;
    uint16_t    sectors_per_track;
    uint16_t    num_heads;
    uint32_t    num_hidden_sectors;
    uint32_t    total_sectors_long;
    //FAT32 EBPB
    uint32_t    sectors_per_fat32;
    uint16_t    fat_flags;
    uint16_t    fat_version;
    uint32_t    root_cluster_num;
    uint16_t    fsinfo_sector;
    uint16_t    backup_boot_sector;
    uint8_t     reserved[12];
    uint8_t     drive_num;
    uint8_t     reserved2;
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

typedef struct fat_disk_entry {
    char        filename[8];
    char        extension[3];
    uint8_t     flags;
    uint8_t     reserved;
    uint8_t     creation_tenths;
    fat_time    creation_time;
    fat_date    creation_date;
    fat_date    accessed_date;
    uint16_t    cluster_high;
    fat_time    modified_time;
    fat_date    modified_date;
    uint16_t    cluster_low;  
    uint32_t    file_size;
} __attribute__((packed)) fat_disk_entry;

typedef struct fat_disk_lfn {
    uint8_t position; //Last entry masked with 0x40
    uint16_t chars_1[5];
    uint8_t flags; //Always 0x0f
    uint8_t entry_type; //Always 0
    uint8_t checksum;
    uint16_t chars_2[6];
    uint16_t reserved2;
    uint16_t chars_3[2];
} __attribute__((packed)) fat_disk_lfn;

typedef struct fat_file {
    char filename[64];
    fat_disk_entry* entry;
    void* dataPtr;
} fat_file;

void fat_init(partition_entry* partition, fat32_bpb* bpb);
void* get_cluster_addr(uint32_t cluster);
void read_cluster_chain(void* address, uint32_t clusterStart, uint32_t clusterCount);

void read_file(fat_file file, void* dest, uint64_t size);
void write_file(fat_file file, void* src, uint64_t size);

fat_file create_file(fat_file dir, const char* name, uint8_t flags, uint64_t reserve_size);
fat_file create_directory(fat_file dir, const char* name, uint8_t flags);
fat_file create_symlink(fat_file dir, const char* name, uint8_t flags, fat_file link);
void delete_file(fat_file file);

fat_file get_fat_metadata(fat_disk_entry* entry);
int enum_dir(fat_file dir, fat_file* dest);
