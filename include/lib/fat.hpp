#pragma once
#include <cstdint>
#include <kassert.hpp>
#include <kstring.hpp>
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
	uint32_t sector_start;
	uint32_t span_length;
};

struct fat_file {
	struct fat_inode* inode;

	fat_file();
	fat_file(struct fat_inode* inode);
	fat_file(const fat_file& other);
	fat_file(fat_file&& other);
	fat_file& operator=(const fat_file& other);
	fat_file& operator=(fat_file&& other);
	~fat_file();

	vector<char>& data() const;
	vector<fat_file>& children() const;
};

struct fat_inode {
	string filename;
	uint32_t filesize;
	uint8_t attributes;
	uint8_t loaded : 1;

	//timepoint created;
	//timepoint modified;
	//timepoint accessed;

	uint16_t references[2];

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
	void write();
	void close();
	void purge();
};

struct fat_sys_data {
	uint16_t sectors_per_cluster;
	uint16_t bytes_per_sector;
	uint16_t bytes_per_cluster;
	uint32_t cluster_lba_offset;
	string volume_id;

	vector<uint32_t*> fat_tables;

	fat_file root_directory;
	fat_file working_directory;
};

void fat_init();

//bool file_exists(fat_file& directory, rostring filename);
//bool file_exists(rostring absolute_path);
//bool file_exists_rel(rostring relative_path);

fat_file file_open(fat_file& directory, rostring filename);
fat_file file_open(rostring absolute_path);
fat_file file_open_rel(rostring relative_path);

fat_file file_create(fat_file& directory, rostring filename);
fat_file file_create(rostring absolute_path);
fat_file file_create_rel(rostring relative_path);

void file_close(fat_file& file);