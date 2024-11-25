#include <cctype>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <inttypes.h>

#define FAT_ATTRIB_RO 0x01
#define FAT_ATTRIB_HIDDEN 0x02
#define FAT_ATTRIB_SYSTEM 0x04
#define FAT_ATTRIB_VOL_ID 0x08
#define FAT_ATTRIB_DIR 0x10
#define FAT_ATTRIB_ARCHIVE 0x20
#define FAT_ATTRIB_LFN 0x0f

#define FAT_TABLE_CHAIN_STOP 0x0ffffff8

typedef struct fat_date {
	uint16_t day : 5;
	uint16_t month : 4;
	uint16_t year : 7; //since 1980
} fat_date;
typedef struct fat_time {
	uint16_t dseconds : 5; //double-seconds, 1-30
	uint16_t minute : 6;
	uint16_t hour : 5;
} fat_time;

typedef struct fat_disk_entry {
	char filename[8];
	char extension[3];
	uint8_t flags;
	uint8_t reserved;
	uint8_t creation_tenths;
	fat_time creation_time;
	fat_date creation_date;
	fat_date accessed_date;
	uint16_t cluster_high;
	fat_time modified_time;
	fat_date modified_date;
	uint16_t cluster_low;
	uint32_t file_size;
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

uint64_t fsize(const char* file) {
	FILE* f = fopen(file, "rb");
	fseek(f, 0, SEEK_END);
	uint64_t sz = ftell(f);
	fclose(f);
	return sz;
}

uint8_t fat_lfn_checksum(const uint8_t* pFCBName) {
	uint8_t sum = 0;
	for (int i = 11; i; i--)
		sum = ((sum & 1) << 7) + (sum >> 1) + *pFCBName++;
	return sum;
}

#define SECTORS_PER_CLUSTER 8
#define SECTORS_PER_FAT32 64

int main(int argc, char** argv) {
	if (argc == 1) {
		printf("Not enough args for fattener.\n");
		return 1;
	}
	for (int i = 0; i < argc - 1; i++) {
		FILE* f = fopen(argv[i + 1], "r");
		if (!f) {
			printf("File %s not found.\n", argv[i + 1]);
			return 1;
		}
		fclose(f);
	}

	uint32_t clusterCount = 1;
	uint64_t* fileSizes = (uint64_t*)malloc(2 * sizeof(uint64_t) * (argc - 1));
	for (int i = 0; i < argc - 1; i++) {
		uint64_t sz = fsize(argv[i + 1]);
		uint64_t cc = ((sz - 1) / (512 * SECTORS_PER_CLUSTER)) + 1;
		clusterCount += cc;
		fileSizes[2 * i] = sz;
		fileSizes[2 * i + 1] = cc;
	}

	uint32_t fatTable[128UL * SECTORS_PER_FAT32];
	memset(fatTable, 0, 512UL * SECTORS_PER_FAT32);

	uint32_t cluster = 0;
	fatTable[cluster++] = 0x0ffffff8;
	fatTable[cluster++] = 0xffffffff;
	fatTable[cluster++] = 0x0ffffff8;

	void* fatData = malloc(clusterCount * 512 * SECTORS_PER_CLUSTER);
	memset(fatData, 0, clusterCount * 512 * SECTORS_PER_CLUSTER);
	fat_disk_entry* rootDir = (fat_disk_entry*)fatData;

	int rootCtr = 1;
	memset(rootDir, 0, sizeof(fat_disk_entry));
	memcpy(rootDir->filename, "TEST VOLUME", 11);
	rootDir->flags = FAT_ATTRIB_VOL_ID;

	for (int i = 0; i < argc - 1; i++) {
		int j = 0;
		int nameStart = 0;
		for (j = 0; argv[i + 1][j] != 0; j++) {
			if (argv[i + 1][j] == '/')
				nameStart = j + 1;
		}
		int extStart = 0;
		for (j = nameStart; argv[i + 1][j] != 0; j++) {
			if (argv[i + 1][j] == '.')
				extStart = j + 1;
		}

		printf("%s: %i %i; ", argv[i + 1], nameStart, extStart);

		fat_disk_entry f;
		f.flags = 0x20;
		f.reserved = 0;
		f.creation_tenths = 0;
		f.creation_time = (fat_time){ 1, 0, 0 };
		f.creation_date = (fat_date){ 1, 1, 0 };
		f.accessed_date = (fat_date){ 1, 1, 0 };
		f.cluster_high = cluster >> 16;
		f.modified_time = (fat_time){ 1, 0, 0 };
		f.modified_date = (fat_date){ 1, 1, 0 };
		f.cluster_low = cluster & 0xffff;
		f.file_size = fileSizes[2 * i];

		memset(f.filename, ' ', 8);
		memset(f.extension, ' ', 3);

		int ctr = 0;
		for (j = nameStart; j < extStart - 1 && ctr < 6; j++) {
			f.filename[ctr++] = toupper(argv[i + 1][j]);
		}
		if (ctr == 6 && j < extStart) {
			f.filename[ctr++] = '~';
			char idx = '1';
			for (int k = 0; k < rootCtr; k++) {
				f.filename[ctr] = idx;
				if (!strncmp(f.filename, rootDir[k].filename, 8)) {
					idx++;
					k = -1;
				}
			}
			ctr++;
		}
		ctr = 0;
		for (j = extStart; argv[i + 1][j] != 0 && ctr < 3; j++) {
			f.extension[ctr++] = toupper(argv[i + 1][j]);
		}

		printf("%11s; ", f.filename);

		//if (!strncmp(f.extension, "IMG", 3)) f.file_size -= 4;

		int nameLen = strlen(&argv[i + 1][nameStart]);
		int nLFNs = (nameLen + 12) / 13;
		fat_disk_lfn* names = (fat_disk_lfn*)malloc(sizeof(fat_disk_lfn) * nLFNs);

		j = nameStart;
		for (int k = 0; k < nLFNs; k++) {
			int lfnIdx = nLFNs - k - 1;
			names[lfnIdx].flags = 0x0f;
			names[lfnIdx].entry_type = 0;
			names[lfnIdx].position = (k + 1) | (!lfnIdx ? 0x40 : 0);
			names[lfnIdx].checksum = fat_lfn_checksum((const uint8_t*)f.filename);
			names[lfnIdx].reserved2 = 0;
			memset(names[lfnIdx].chars_1, 0xff, 10);
			memset(names[lfnIdx].chars_2, 0xff, 12);
			memset(names[lfnIdx].chars_3, 0xff, 4);

			int lfnCtr = 0;
			for (; argv[i + 1][j - 1] != 0 && lfnCtr < 5; printf("%c", argv[i + 1][j]), j++)
				names[lfnIdx].chars_1[lfnCtr++] = argv[i + 1][j];
			for (; argv[i + 1][j - 1] != 0 && lfnCtr < 11; printf("%c", argv[i + 1][j]), j++)
				names[lfnIdx].chars_2[lfnCtr++ - 5] = argv[i + 1][j];
			for (; argv[i + 1][j - 1] != 0 && lfnCtr < 13; printf("%c", argv[i + 1][j]), j++)
				names[lfnIdx].chars_3[lfnCtr++ - 11] = argv[i + 1][j];
		}

		void* startAddr = (void*)((uint64_t)fatData + 512 * SECTORS_PER_CLUSTER * (cluster - 2));
		for (uint32_t j = 0; j < fileSizes[2 * i + 1] - 1; j++) {
			fatTable[cluster] = cluster + 1;
			cluster++;
		}
		fatTable[cluster++] = FAT_TABLE_CHAIN_STOP;

		FILE* file = fopen(argv[i + 1], "rb");
		fread(startAddr, 1, fileSizes[2 * i], file);
		fclose(file);

		for (j = 0; j < nLFNs; j++)
			((fat_disk_lfn*)rootDir)[rootCtr++] = names[j];
		free(names);
		rootDir[rootCtr++] = f;

		printf("; %" PRIu64 "\n", fileSizes[2 * i]);
	}
	FILE* output = fopen("disk.img", "wb");

	uint64_t bootloaderSize = fsize("tmp/bootloader.img");
	void* bootBuffer = malloc(bootloaderSize);
	FILE* bootloader = fopen("tmp/bootloader.img", "rb");
	fread(bootBuffer, 1, bootloaderSize, bootloader);
	fwrite(bootBuffer, 1, bootloaderSize, output);
	fclose(bootloader);

	fwrite(fatTable, 1, 512UL * SECTORS_PER_FAT32, output);
	fwrite(fatTable, 1, 512UL * SECTORS_PER_FAT32, output);
	fwrite(fatData, 1, clusterCount * 512 * SECTORS_PER_CLUSTER, output);
	fclose(output);

	free(fileSizes);
	free(fatData);
	free(bootBuffer);

	return 0;
}
