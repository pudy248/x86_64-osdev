#pragma once
#include <cstdint>
#include <kstring.hpp>
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
    uint32_t filesize;
    uint8_t attributes;
    uint8_t opened:1;
    uint8_t loaded:1;
    uint8_t edited:1;

    //timepoint created;
    //timepoint modified;
    //timepoint accessed;

    uint16_t references;

    union {
        vector<char> data;
        vector<fat_inode*> children;
    };

    fat_inode* parent;
    uint32_t start_cluster;
    vector<fat_disk_span> disk_layout;

    fat_inode(uint32_t filesize, uint8_t attributes, fat_inode* parent, uint32_t start_cluster);
    //fat_inode(fat_inode&& other);
    //fat_inode& operator=(fat_inode&& other);
    ~fat_inode();

    void open();
    void read();
    void write();
    void close();
    void purge();
};

struct FILE {
    fat_inode* inode;

    FILE();
    FILE(fat_inode* inode);
    FILE(const FILE& other);
    FILE(FILE&& other);
    FILE& operator=(const FILE& other);
    FILE& operator=(FILE&& other);
    ~FILE();
};

struct fat_sys_data {
    uint16_t sectors_per_cluster;
    uint16_t bytes_per_sector;
    uint16_t bytes_per_cluster;
    uint32_t cluster_lba_offset;
    string volume_id;

    vector<uint32_t*> fat_tables;

    FILE root_directory;
    FILE working_directory;
};

void fat_init();

//bool file_exists(FILE& directory, rostring filename);
//bool file_exists(rostring absolute_path);
//bool file_exists_rel(rostring relative_path);

FILE file_open(FILE& directory, rostring filename);
FILE file_open(rostring absolute_path);
FILE file_open_rel(rostring relative_path);

FILE file_create(FILE& directory, rostring filename);
FILE file_create(rostring absolute_path);
FILE file_create_rel(rostring relative_path);

void file_close(FILE& file);