#pragma once
#include <cstdint>
#include <kfile.hpp>
#include <stl/pointer.hpp>
#include <stl/vector.hpp>

namespace FAT_ATTRIBS {
enum FAT_ATTRIBS {
	READONLY = 0x01,
	HIDDEN = 0x02,
	SYSTEM = 0x04,
	VOL_ID = 0x08,
	DIRECTORY = 0x10,
	ARCHIVE = 0x20,
	LFN = 0x0f,
};
}

struct fat_disk_span {
	uint32_t cluster_start;
	uint32_t span_length;
};

struct fat_sys_data {
	uint16_t sectors_per_cluster;
	uint16_t bytes_per_sector;
	uint16_t bytes_per_cluster;
	uint32_t cluster_lba_offset;

	vector<pointer<uint32_t, unique>> fat_tables;

	uint32_t bpb_lba_offset;
	pointer<struct fat32_bpb, unique> bpb;

	file_t root_directory;
};

void fat_init();

void fat_read_directory(pointer<file_inode> dir);
void fat_write_directory(pointer<file_inode> dir);
void fat_read_file(pointer<file_inode> file);
void fat_write_file(pointer<file_inode> file);