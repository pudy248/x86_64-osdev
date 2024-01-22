#include "sys/global.h"
#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/fat.hpp>
#include <sys/ktime.hpp>
#include <stl/vector.hpp>
#include <drivers/ahci.h>


struct a_packed partition_entry {
    uint8_t     attributes;
    uint8_t     chs_start[3];
    uint8_t     sysid;
    uint8_t     chs_end[3];
    uint32_t    lba_start;
    uint32_t    lba_size;
};

struct a_packed partition_table {
    uint32_t    disk_id;
    uint16_t    reserved;
    partition_entry entries[4];
};

struct a_packed fat32_bpb {
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
};
struct fat_date {
    uint16_t    day:5;
    uint16_t    month:4;
    uint16_t    year:7; //since 1980
};
struct fat_time {
    uint16_t    dseconds:5; //double-seconds, 1-30
    uint16_t    minute:6;
    uint16_t    hour:5;
};

struct a_packed fat_file_entry {
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
};

struct a_packed fat_file_lfn {
    uint8_t position; //Last entry masked with 0x40
    uint16_t chars_1[5];
    uint8_t flags; //Always 0x0f
    uint8_t entry_type; //Always 0
    uint8_t checksum;
    uint16_t chars_2[6];
    uint16_t reserved2;
    uint16_t chars_3[2];
};

#define MBR_PARTITION_START     0x1b8
#define PARTITION_ATTR_ACTIVE   0x80
#define SIG_MBR_FAT32           0x0c
#define SIG_BPB_FAT32           0x29

#define FAT_TABLE_CHAIN_STOP    0x0ffffff8

static uint64_t cluster_lba(uint32_t cluster) {
    return (uint64_t)(cluster - 2) * globals->fat_data.sectors_per_cluster + globals->fat_data.cluster_lba_offset;
}
static uint32_t count_consecutive_clusters(uint32_t cluster) {
    uint32_t c = cluster;
    while (globals->fat_data.primary_fat_table[c] == c + 1)
        c++;
    return c - cluster + 1;
}
static vector<fat_disk_span> read_file_layout(uint32_t cluster) {
    vector<fat_disk_span> layout(1);
    do {
        uint32_t count = count_consecutive_clusters(cluster);
        layout.append( {cluster, count} );
        cluster = globals->fat_data.primary_fat_table[cluster + count - 1];
    } while (cluster != FAT_TABLE_CHAIN_STOP);
    return layout;
}

void fat_init() {
    partition_table* partTable = (partition_table*)(0x7c00 + MBR_PARTITION_START);
    int i = 0;
    for (; i < 4; i++)
        if (partTable->entries[i].sysid == SIG_MBR_FAT32) break;
    kassert(i < 4, "No FAT32 partition found, was the MBR corrupted?\r\n");
    fat32_bpb* bpb = new fat32_bpb();
    read_disk(bpb, partTable->entries[i].lba_start, 1);
    kassert(bpb->signature == SIG_BPB_FAT32, "Partition not recognized as FAT32.\r\n");
    globals->fat_data.sectors_per_cluster = bpb->sectors_per_cluster;
    globals->fat_data.bytes_per_sector = bpb->bytes_per_sector;
    globals->fat_data.bytes_per_cluster = globals->fat_data.bytes_per_sector * globals->fat_data.sectors_per_cluster;
    globals->fat_data.cluster_lba_offset = partTable->entries[i].lba_start + (bpb->reserved_sectors + bpb->fat_tables * bpb->sectors_per_fat32);
    globals->fat_data.primary_fat_table = (uint32_t*)((uint64_t)(partTable->entries[i].lba_start + bpb->reserved_sectors) * bpb->bytes_per_sector);

    globals->fat_data.root_directory = new fat_inode();
    globals->fat_data.working_directory = globals->fat_data.root_directory;
    *globals->fat_data.root_directory = { string(), FAT_ATTRIBS::VOL_ID | FAT_ATTRIBS::SYSTEM | FAT_ATTRIBS::DIR,
        {}, {}, {}, true, false, false, 
        vector<char>(), vector<fat_inode*>(), NULL, (uint32_t)bpb->root_dir_entries * 32, 
        read_file_layout(bpb->root_cluster_num)};
    
    globals->fat_data.root_directory->read();
}

void fat_inode::read() {
    
}