#pragma once
#include <kstddefs.h>
#include <kstring.hpp>
#include <sys/ktime.hpp>
#include <stl/vector.hpp>

namespace FAT_ATTRIBS {
    enum FAT_ATTRIBS {
        READONLY = 0x01,
        HIDDEN = 0x02,
        SYSTEM = 0x04,
        VOL_ID = 0x08,
        DIR = 0x10,
        ARCHIVE = 0x20,
        LFN = 0x0f,
    };
}

struct fat_disk_span {
    uint32_t sector_start;
    uint32_t span_length;
};

struct fat_inode {
    string filename;
    uint8_t attributes;
    timepoint created;
    timepoint modified;
    timepoint accessed;

    bool opened;
    bool loaded;
    bool edited;
    vector<char> data;           //file
    vector<fat_inode*> children; //directory
    fat_inode* parent;
    
    uint32_t filesize;
    vector<fat_disk_span> disk_layout;

    void read();
    void write();
};

struct fat_sys_data {
    uint16_t sectors_per_cluster;
    uint16_t bytes_per_sector;
    uint16_t bytes_per_cluster;
    uint32_t cluster_lba_offset;
    uint32_t* primary_fat_table;

    string volume_id;
    span<uint32_t> table;

    fat_inode* root_directory;
    fat_inode* working_directory;
};

void fat_init();

bool file_exists(fat_inode* directory, rostring filename);
fat_inode* file_open(fat_inode* directory, rostring filename);
fat_inode* file_create(fat_inode* directory, rostring filename);
void file_close(fat_inode* file);