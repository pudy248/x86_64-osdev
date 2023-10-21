#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

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
    uint16_t    modified_time;
    uint16_t    modified_date;
    uint16_t    cluster_low;  
    uint32_t    file_size;
} __attribute__((packed)) fat_file;

size_t fsize(char* file) {
    FILE* f = fopen(file, "rb");
    fseek(f, 0, SEEK_END);
    size_t sz = ftell(f);
    fclose(f);
    return sz;
}

#define SECTORS_PER_CLUSTER 4
#define SECTORS_PER_FAT32 4

int main(int argc, char** argv) {
    if(argc == 1) {
        printf("Not enough args for fattener.\n");
        return 1;
    }
    for(int i = 0; i < argc - 1; i++) {
        FILE* f = fopen(argv[i + 1], "r");
        if(!f) {
            printf("File %s not found.\n", argv[i + 1]);
            return 1;
        }
        fclose(f);
    }

    uint32_t clusterCount = 1;
    size_t* fileSizes = (size_t*)malloc(2 * sizeof(size_t) * (argc - 1));
    for(int i = 0; i < argc - 1; i++) {
        size_t sz = fsize(argv[i + 1]) - 4;
        size_t cc = ((sz - 1) / (512 * SECTORS_PER_CLUSTER)) + 1;
        clusterCount += cc;
        fileSizes[2 * i] = sz;
        fileSizes[2 * i + 1] = cc;
    }

    uint32_t fatTable[128 * SECTORS_PER_FAT32];
    memset(fatTable, 0, 512 * SECTORS_PER_FAT32);
    
    uint32_t cluster = 0;
    fatTable[cluster++] = 0x0ffffff8;
    fatTable[cluster++] = 0xffffffff;
    fatTable[cluster++] = 0x0ffffff8;

    void* fatData = malloc(clusterCount * 512 * SECTORS_PER_CLUSTER);
    memset(fatData, 0, clusterCount * 512 * SECTORS_PER_CLUSTER);
    fat_file* rootDir = (fat_file*)fatData;

    rootDir[0] = (fat_file){"TEST VOL", "UME", 8, 0, 0, 0, 0, 0, 0};
    
    for(int i = 0; i < argc - 1; i++) {
        fat_file f;
        memcpy(f.filename, "        ", 8);
        memcpy(f.extension, "   ", 3);
        int lastSlash = 0;
        int ctr = 0;
        int j;
        for(int j = 0; argv[i + 1][j] != 0; j++) {
            if(argv[i + 1][j] == '/') lastSlash = j + 1;
        }
        for(j = lastSlash; argv[i + 1][j] != '.' && ctr < 8; j++) {
            f.filename[ctr++] = argv[i + 1][j];
        }
        ctr = 0;
        for(; argv[i + 1][j] != '.'; j++); j++;
        for(; argv[i + 1][j] != 0 && ctr < 3; j++) {
            f.extension[ctr++] = argv[i + 1][j];
        }
        
        f.flags = 0x20;
        f.load_address = 0;
        f.cluster_high = cluster >> 16;
        f.modified_time = 0;
        f.modified_date = 0;
        f.cluster_low = cluster & 0xffff;
        f.file_size = fileSizes[2 * i];

        void* startAddr = (void*)((size_t)fatData + 512 * SECTORS_PER_CLUSTER * (cluster - 2));
        for(uint32_t j = 0; j < fileSizes[2 * i + 1] - 1; j++) {
            fatTable[cluster] = cluster + 1;
            cluster++;
        }
        fatTable[cluster++] = 0x0ffffff8;

        FILE* file = fopen(argv[i + 1], "rb");
        fread(&f.load_address, 4, 1, file);
        fread(startAddr, 1, fileSizes[2 * i], file);
        fclose(file);

        rootDir[i + 1] = f;
    }
    FILE* output = fopen("disk.img", "wb");


    //FILE* diskflasher_f = fopen("tmp/diskflasher.img", "rb");
    //uint8_t diskflasher[512];
    //fread(diskflasher, 1, 512, diskflasher_f);
    //fwrite(diskflasher, 1, 512, output);
    //fclose(diskflasher_f);
        
    size_t bootloaderSize = fsize("tmp/bootloader.img");
    void* bootBuffer = malloc(bootloaderSize);
    FILE* bootloader = fopen("tmp/bootloader.img", "rb");
    fread(bootBuffer, 1, bootloaderSize, bootloader);
    fwrite(bootBuffer, 1, bootloaderSize, output);
    fclose(bootloader);

    fwrite(fatTable, 1, 512 * SECTORS_PER_FAT32, output);
    fwrite(fatTable, 1, 512 * SECTORS_PER_FAT32, output);
    fwrite(fatData, 1, clusterCount * 512 * SECTORS_PER_CLUSTER, output);
    fclose(output);

    free(fileSizes);
    free(fatData);
    free(bootBuffer);

    return 0;
}
