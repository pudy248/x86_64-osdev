#include <kstddefs.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <kcstring.hpp>
#include <drivers/ahci.hpp>
#include <lib/fat.hpp>

static uint16_t sectorsPerCluster;
static uint32_t firstClusterLBA;
static uint16_t bytesPerCluster;
static uint32_t firstClusterAddr;
static fat_table fatTable;

static fat32_bpb* bpb = (fat32_bpb*)0x200000;

static fat_table get_fat_addr(fat32_bpb* bpb, uint8_t fat_index) {
    if (fat_index > bpb->fat_tables) return (fat_table)0;
    uint32_t baseAddr = (uint64_t)bpb + bpb->bytes_per_sector * bpb->reserved_sectors;
    uint32_t tableSize = (uint64_t)bpb->bytes_per_sector * bpb->sectors_per_fat32;
    return (fat_table)(uint64_t)(baseAddr + tableSize * fat_index);
}
void fat_init(partition_entry* partition, fat32_bpb* bpb) {
    sectorsPerCluster = bpb->sectors_per_cluster;
    firstClusterLBA = partition->lba_start + (bpb->reserved_sectors + bpb->fat_tables * bpb->sectors_per_fat32);
    bytesPerCluster = sectorsPerCluster * bpb->bytes_per_sector;
    firstClusterAddr = (uint64_t)bpb + bpb->bytes_per_sector * (bpb->reserved_sectors + bpb->fat_tables * bpb->sectors_per_fat32);
    fatTable = get_fat_addr(bpb, 0);
}
static uint32_t get_cluster_lba(uint32_t cluster) {
    return firstClusterLBA + (cluster - 2) * sectorsPerCluster;
}
void* get_cluster_addr(uint32_t cluster) {
    return (void*)(uint64_t)(firstClusterAddr + (cluster - 2) * bytesPerCluster);
}

static uint32_t count_consecutive_clusters(uint32_t startCluster) {
    uint32_t c = startCluster;
    uint32_t i = 0;
    while (fatTable[c] == c + 1) {
        i++;
        c++;
    }
    return i + 1;
}
void read_cluster_chain(void* address, uint32_t clusterStart, uint32_t clusterCount) {
    while (clusterCount && clusterStart && (clusterStart & 0x0fffffff) < 0x0ffffff7) {
        uint32_t count = count_consecutive_clusters(clusterStart);
        count = min(clusterCount, count);
        clusterCount -= count;

        uint32_t lbaStart = get_cluster_lba(clusterStart);
        uint32_t lbaCount = count * sectorsPerCluster;
        read_disk(address, lbaStart, lbaCount);
        *(uint64_t*)&address += count * bytesPerCluster;
        clusterStart = fatTable[clusterStart + count - 1];
    }

}

static uint8_t fat_lfn_checksum(const uint8_t *pFCBName)
{
   uint8_t sum = 0;
   for (int i = 11; i; i--)
      sum = ((sum & 1) << 7) + (sum >> 1) + *pFCBName++;
   return sum;
}

static char toupper(char c) { return c; }

fat_file create_file(fat_file dir, const char* name, uint8_t flags, uint64_t reserve_size) {
    //--------------------+
    //  Allocate clusters |
    //--------------------+
    uint32_t clusterCount = (reserve_size + bytesPerCluster - 1) / bytesPerCluster;
    uint32_t firstCluster = 0;
    uint32_t lastCluster = 0;
    uint32_t nextCluster = 3;
    while (clusterCount) {
        while (fatTable[nextCluster++]);
        if (!firstCluster) firstCluster = nextCluster;
        if (lastCluster) fatTable[lastCluster] = nextCluster;
        lastCluster = nextCluster;
        clusterCount--;
    }
    if (lastCluster) fatTable[lastCluster] = FAT_TABLE_CHAIN_STOP;
    else firstCluster = FAT_TABLE_CHAIN_STOP;

    //-------------------+
    //  Create FAT entry |
    //-------------------+
    fat_disk_entry f;
    memset(f.filename, ' ', 8);
    memset(f.extension, ' ', 3);
    f.flags = flags;
    f.reserved = 0;
    f.creation_tenths = 0;
    f.creation_time = {1, 0, 0};
    f.creation_date = {1, 1, 0};
    f.accessed_date = {1, 1, 0};
    f.cluster_high = firstCluster >> 16;
    f.modified_time = {1, 0, 0};
    f.modified_date = {1, 1, 0};
    f.cluster_low = firstCluster & 0xffff;
    f.file_size = reserve_size;
    
    int ctr = 0;
    int j;
    for (j = 0; name[j] != '.' && name[j] && ctr < 6; j++)
        f.filename[ctr++] = toupper(name[j]);
    if (ctr == 6 && name[j] != '.' && name[j]) {
        f.filename[ctr++] = '~';
        f.filename[ctr++] = '1';
    }
    ctr = 0;
    for (; name[j] != '.' && name[j]; j++); 
    if (name[j]) j++;
    for (; name[j] && ctr < 3; j++)
        f.extension[ctr++] = toupper(name[j]);
    
    //---------------------+
    //  Create LFN entries |
    //---------------------+
    int nameLen = strlen(name);
    int nLFNs = (nameLen + 12) / 13;
    fat_disk_lfn names[16];
    j = 0;
    for (int i = 0; i < nLFNs; i++) {
        int lfnIdx = nLFNs - i - 1;
        names[lfnIdx].flags = 0x0f;
        names[lfnIdx].entry_type = 0;
        names[lfnIdx].position = (i + 1) | (!lfnIdx ? 0x40 : 0);
        names[lfnIdx].checksum = fat_lfn_checksum((uint8_t*)f.filename);
        names[lfnIdx].reserved2 = 0;
        memset(names[lfnIdx].chars_1, 0xff, 10);
        memset(names[lfnIdx].chars_2, 0xff, 12);
        memset(names[lfnIdx].chars_3, 0xff, 4);
                
        char stop = 0;
        for (int lfnCtr = 0; lfnCtr < 5 && !stop; j++) {
            names[lfnIdx].chars_1[lfnCtr++] = name[j];
            if (!name[j]) stop = 1;
        }
        if (stop) break;
        for (int lfnCtr = 0; lfnCtr < 6 && !stop; j++) {
            names[lfnIdx].chars_2[lfnCtr++] = name[j];
            if (!name[j]) stop = 1;
        }
        if (stop) break;
        for (int lfnCtr = 0; lfnCtr < 2 && !stop; j++) {
            names[lfnIdx].chars_3[lfnCtr++] = name[j];
            if (!name[j]) stop = 1;
        }
        if (stop) break;
    }
    
    //-----------------------+
    //  Write entries to dir |
    //-----------------------+
    fat_disk_entry* entries = (fat_disk_entry*)dir.dataPtr;
    int dirIdx = 0;
    int nConsecutive = 0;
    while (nConsecutive < nLFNs + 1) {
        if (!entries[dirIdx].filename[0])
            nConsecutive++;
        else nConsecutive = 0;
        dirIdx++;
    }
    dirIdx -= nConsecutive;
    for (int i = 0; i < nLFNs; i++)
        ((fat_disk_lfn*)entries)[dirIdx++] = names[i];
    entries[dirIdx++] = f;
    
    fat_file ret;
    strcpy(ret.filename, name);
    ret.entry = &entries[dirIdx - 1];
    ret.dataPtr = get_cluster_addr(((uint32_t)ret.entry->cluster_high << 16) | ret.entry->cluster_low);
    memset(ret.dataPtr, 0, reserve_size);
    return ret;
}
fat_file create_directory(fat_file dir, const char* name, uint8_t flags) {
    fat_file newDir = create_file(dir, name, flags | FAT_ATTRIB_DIR, 512);
    create_symlink(dir, ".", newDir.entry->flags | FAT_ATTRIB_HIDDEN, newDir);
    create_symlink(dir, "..", dir.entry->flags | FAT_ATTRIB_HIDDEN, dir);
    return newDir;
}
fat_file create_symlink(fat_file dir, const char* name, uint8_t flags, fat_file link) {
    fat_file f = create_file(dir, name, flags, 0);
    if (!link.entry) {
        f.entry->file_size = 512;
        f.entry->cluster_high = bpb->root_cluster_num >> 16;
        f.entry->cluster_low = bpb->root_cluster_num & 0xffff;
    }
    f.entry->file_size = link.entry->file_size;
    f.entry->cluster_high = link.entry->cluster_high;
    f.entry->cluster_low = link.entry->cluster_low;
    return f;
}

void delete_file(fat_file file) {
    uint32_t clusterStart = ((uint32_t)file.entry->cluster_high << 16) | file.entry->cluster_low;
    while (clusterStart && (clusterStart & 0x0fffffff) < 0x0ffffff7) {
        uint32_t tmp = clusterStart;
        clusterStart = fatTable[clusterStart];
        fatTable[tmp] = 0;
    }

    int nLFNs = 0;
    for (int dirIdx = -1; file.entry[dirIdx].flags == FAT_ATTRIB_LFN; dirIdx--)
        nLFNs++;
    
    int i;
    for (i = -nLFNs; file.entry[i + nLFNs + 1].filename[0]; i++)
        file.entry[i] = file.entry[i + nLFNs + 1];
    for (; file.entry[i].filename[0]; i++)
        memset((void*)&file.entry[i], 0, sizeof(fat_disk_entry));
}

void read_file(fat_file file, void* dest, uint64_t size) {
    uint32_t clusterCount = (size + bytesPerCluster - 1) / bytesPerCluster;
    read_cluster_chain(dest, ((uint32_t)file.entry->cluster_high << 16) | file.entry->cluster_low, clusterCount);
}
void write_file(fat_file file, void* src, uint64_t size) {
    uint32_t clusterCount = (size + bytesPerCluster - 1) / bytesPerCluster;
    uint32_t nextCluster = ((uint32_t)file.entry->cluster_high) << 16 | file.entry->cluster_low;
    while (clusterCount && nextCluster != FAT_TABLE_CHAIN_STOP) {

    }
}

fat_file get_fat_metadata(fat_disk_entry* entries) {
    fat_file f;
    fat_disk_lfn lfns[16];
    f.entry = entries;
    int nLFNs = 0;
    for (int dirIdx = -1; entries[dirIdx].flags == FAT_ATTRIB_LFN; dirIdx--)
        lfns[nLFNs++] = ((fat_disk_lfn*)entries)[dirIdx];
    if (nLFNs > 0) {
        for (int i = 0; i < nLFNs; i++) {
            char stop = 0;
            for (int j = 0; j < 5 && !stop; j++) {
                f.filename[13 * ((lfns[i].position & 0x1f) - 1) + j] = lfns[i].chars_1[j];
                if (!lfns[i].chars_1[j]) stop = 1;
            }
            if (stop) continue;
            for (int j = 0; j < 6 && !stop; j++) {
                f.filename[13 * ((lfns[i].position & 0x1f) - 1) + j + 5] = lfns[i].chars_2[j];
                if (!lfns[i].chars_2[j]) stop = 1;
            }
            if (stop) continue;
            for (int j = 0; j < 2 && !stop; j++) {
                f.filename[13 * ((lfns[i].position & 0x1f) - 1) + j + 11] = lfns[i].chars_3[j];
                if (!lfns[i].chars_3[j]) stop = 1;
            }
        }
    }
    else {
        int ctr = 0;
        for (int i = 0; i < 8 && entries->filename[i] != ' '; i++) f.filename[ctr++] = entries->filename[i];
        if (entries->extension[0] != ' ') {
            f.filename[ctr++] = '.';
            for(int i = 0; i < 3 && entries->extension[i] != ' '; i++) f.filename[ctr++] = entries->extension[i];
        }
        f.filename[ctr++] = 0;
    }
    char shortname[12];
    shortname[11] = 0;
    memcpy(shortname, entries->filename, 11);
    //printf("%08x - %s : %i lfns -> %s\n", (uint32_t)entries, shortname, nLFNs, f.filename);
    return f;
}
int enum_dir(fat_file dir, fat_file* dest) {
    int destIdx = 0;
    fat_disk_entry* entries = (fat_disk_entry*)dir.dataPtr;
    for (int dirIdx = 0; entries[dirIdx].filename[0]; dirIdx++) {
        if (entries[dirIdx].flags == FAT_ATTRIB_LFN) continue;
        dest[destIdx++] = get_fat_metadata(&entries[dirIdx]);
    }
    return destIdx;
}
