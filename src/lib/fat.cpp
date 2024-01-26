#include <cstddef>
#include <cstdint>

#include <kstddefs.h>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <kprint.h>
#include <lib/fat.hpp>
#include <sys/ktime.hpp>
#include <sys/global.h>
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
    
    char padding[512 - 90];
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
    uint8_t     attributes;
    uint16_t     user_attributes;
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

struct a_packed fat_dir_ent {
    union {
        fat_file_entry file;
        fat_file_lfn lfn;
    };
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
    while (globals->fat_data.fat_tables[0][c] == c + 1)
        c++;
    return c - cluster + 1;
}
static vector<fat_disk_span> read_file_layout(uint32_t cluster) {
    vector<fat_disk_span> layout(1);
    do {
        uint32_t count = count_consecutive_clusters(cluster);
        layout.append( {cluster, count} );
        cluster = globals->fat_data.fat_tables[0][cluster + count - 1];
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
    
    bpb->fat_tables = 1;
    globals->fat_data.fat_tables.unsafe_set(NULL, 0, 0);
    for (int i = 0; i < bpb->fat_tables; i++) {
        globals->fat_data.fat_tables.append((uint32_t*)walloc(bpb->sectors_per_fat32 * bpb->bytes_per_sector, 0x10));
        read_disk(globals->fat_data.fat_tables[i], partTable->entries[i].lba_start + (bpb->reserved_sectors + i * bpb->sectors_per_fat32), bpb->sectors_per_fat32);
    }

    memset(&globals->fat_data.root_directory, 0, 2 * sizeof(FILE));

    globals->fat_data.root_directory = FILE(new fat_inode(bpb->root_dir_entries * 32, FAT_ATTRIBS::VOL_ID | FAT_ATTRIBS::SYSTEM | FAT_ATTRIBS::DIR, NULL, bpb->root_cluster_num));
    globals->fat_data.working_directory = globals->fat_data.root_directory;
    delete bpb;
}

fat_inode::fat_inode(uint32_t filesize, uint8_t attributes, fat_inode* parent, uint32_t start_cluster) :
    filename(), filesize(filesize), attributes(attributes), opened(0), loaded(0), edited(0), references(0), parent(parent), start_cluster(start_cluster), disk_layout() {
    data.unsafe_set(NULL, 0, 0);
}
/*
fat_inode::fat_inode(fat_inode&& other) {
    *this = std::move(other);
}
fat_inode& fat_inode::operator=(fat_inode&& other) {
    print("FAT inode move assignment called!\r\n");
    filename = other.filename;
    filesize = other.filesize;
    attributes = other.attributes;
    opened = other.opened;
    references = other.references;
    loaded = other.loaded;
    edited = other.edited;
    parent = other.parent;
    disk_layout = other.disk_layout;
    if (attributes & FAT_ATTRIBS::DIR) this->children = other.children;
    else this->data = other.data;
    return *this;
}*/
fat_inode::~fat_inode() {
    close();
}

static fat_inode* from_dir_ents(fat_inode* parent, fat_dir_ent* entries, int nLFNs) {
    fat_file_entry* file = &entries[nLFNs].file;
    fat_inode* inode = new fat_inode(file->file_size, file->attributes, parent, (uint32_t)file->cluster_high << 16 | file->cluster_low);
    for (int lfnIdx = 0; lfnIdx < nLFNs; lfnIdx++) {
        fat_file_lfn* lfn = &entries[lfnIdx].lfn;
        int offset = ((lfn->position & 0x3f) - 1) * 13;
        bool br = false;
        for (int i = 0; !br && i < 5; i++) 
            if (lfn->chars_1[i]) inode->filename.at(offset + i) = lfn->chars_1[i];
            else br = true;
        for (int i = 0; !br && i < 6; i++) 
            if (lfn->chars_2[i]) inode->filename.at(offset + i + 5) = lfn->chars_2[i];
            else br = true;
        for (int i = 0; !br && i < 2; i++) 
            if (lfn->chars_3[i]) inode->filename.at(offset + i + 11) = lfn->chars_3[i];
            else br = true;
        
    }
    //printf("name: %S\r\n", &inode->filename);
    return inode;
}
static void* read_from_disk_layout(fat_inode* inode) {
    int cluster_idx = 0;
    for (int i = 0; i < inode->disk_layout.size(); i++)
        cluster_idx += inode->disk_layout.at(i).span_length;
    void* dat = malloc(cluster_idx * globals->fat_data.bytes_per_cluster);
    cluster_idx = 0;
    int cluster = inode->disk_layout.at(0).sector_start;
    for (int i = 0; i < inode->disk_layout.size(); i++) {
        int sectors = inode->disk_layout.at(i).span_length * globals->fat_data.sectors_per_cluster;
        int lba = cluster_lba(cluster);
        read_disk((void*)((uint64_t)dat + cluster_idx * globals->fat_data.bytes_per_cluster), lba, sectors);
        cluster_idx += inode->disk_layout.at(i).span_length;
    }
    return dat;
}

void fat_inode::open() {
    if (opened) return;
    disk_layout = read_file_layout(start_cluster);
    opened = 1;
}
void fat_inode::read() {
    if (loaded) return;
    if(!opened) open();
    void* dat = read_from_disk_layout(this);

    if (attributes & FAT_ATTRIBS::DIR) {
        fat_dir_ent* entries = (fat_dir_ent*)dat;
        int idx = 0;
        while (entries[idx].file.attributes) {
            if ((entries[idx].file.attributes & FAT_ATTRIBS::VOL_ID) && entries[idx].file.attributes != FAT_ATTRIBS::LFN) {
                idx++;
                continue;
            }
            int sidx = idx;
            //printf("%i:%i\r\n", sidx, idx);
            while (entries[idx].file.attributes == FAT_ATTRIBS::LFN) idx++;
            int nLFNs = idx - sidx;
            children.append(from_dir_ents(this, &entries[sidx], nLFNs));
            //print("\r\n");
            //pit_delay(1);
            idx++;
        }
    }
    else data = vector<char>((char*)dat, filesize);
    free(dat);
    loaded = 1;
}
void fat_inode::close() {
    if (!opened) return;
    if (attributes & FAT_ATTRIBS::DIR) {
        for (int i = 0; i < children.size(); i++) {
            if(!children.at(i)->references) delete children.at(i);
        }
        children.clear();
    }
    else data.clear();
    disk_layout.clear();

    opened = 0;
    loaded = 0;
}
void fat_inode::purge() {
    if (attributes & FAT_ATTRIBS::DIR) {
        for (int i = 0; i < children.size(); i++) children.at(i)->purge();
         
    }
    if (!references) {
        if (attributes & FAT_ATTRIBS::DIR) children.clear();
        else data.clear();
        disk_layout.clear();

        opened = 0;
        loaded = 0;
    }
}

FILE::FILE() : FILE(NULL) { };
FILE::FILE(fat_inode* inode) : inode(inode) {
    if (inode) {
        inode->read();
        inode->references++;
    }
}
FILE::FILE(const FILE& other) : inode(other.inode) {
    if (inode) inode->references++;
}
FILE::FILE(FILE&& other) : inode(other.inode) {
    other.inode = NULL;
}
FILE& FILE::operator=(const FILE& other) {
    inode = other.inode;
    if (inode) inode->references++;
    return *this;
}
FILE& FILE::operator=(FILE&& other) {
    inode = other.inode;
    other.inode = NULL;
    return *this;
}
FILE::~FILE() {
    if (inode) {
        inode->references--;
        //if (!inode->references) inode->close();
    }
}

FILE file_open(FILE& directory, rostring filename) {
    if (!directory.inode) return FILE();
    if (!(directory.inode->attributes & FAT_ATTRIBS::DIR)) return FILE();
    for (int i = 0; i < directory.inode->children.size(); i++) {
        if (directory.inode->children[i]->filename == filename) return FILE(directory.inode->children[i]);
    }
    return NULL;
}
FILE file_open(rostring absolute_path) {
    vector<rostring> parts = absolute_path.split("\\/");
    FILE file = globals->fat_data.root_directory;
    for (int i = 0; i < parts.size(); i++) {
        if (!file.inode) return FILE();
        if (!parts[i].size()) continue;
        if (parts[i] == ".") continue;
        if (parts[i] == "..") {
            file = FILE(file.inode->parent);
            continue;
        }
        file = file_open(file, parts[i]);
    }
    return file;
}
