#include <cstddef>
#include <cstdint>
#include <drivers/ahci.hpp>
#include <kassert.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/fat.hpp>
#include <stl/vector.hpp>
#include <sys/global.hpp>

struct [[gnu::packed]] partition_entry {
	uint8_t attributes;
	uint8_t chs_start[3];
	uint8_t sysid;
	uint8_t chs_end[3];
	uint32_t lba_start;
	uint32_t lba_size;
};

struct [[gnu::packed]] partition_table {
	uint32_t disk_id;
	uint16_t reserved;
	partition_entry entries[4];
};

struct [[gnu::packed]] fat32_bpb {
	//FAT BPB
	char jump[3];
	char oem_name[8];
	uint16_t bytes_per_sector;
	uint8_t sectors_per_cluster;
	uint16_t reserved_sectors;
	uint8_t fat_tables;
	uint16_t root_dir_entries;
	uint16_t total_sectors_short;
	uint8_t media_descriptor_type;
	uint16_t sectors_per_fat;
	uint16_t sectors_per_track;
	uint16_t num_heads;
	uint32_t num_hidden_sectors;
	uint32_t total_sectors_long;
	//FAT32 EBPB
	uint32_t sectors_per_fat32;
	uint16_t fat_flags;
	uint16_t fat_version;
	uint32_t root_cluster_num;
	uint16_t fsinfo_sector;
	uint16_t backup_boot_sector;
	uint8_t reserved[12];
	uint8_t drive_num;
	uint8_t reserved2;
	uint8_t signature;
	uint32_t volume_id;
	char volume_label[11];
	char volume_identifier[8];

	char padding[512 - 90];
};
struct fat_date {
	uint16_t day : 5;
	uint16_t month : 4;
	uint16_t year : 7; //since 1980
};
struct fat_time {
	uint16_t dseconds : 5; //double-seconds, 1-30
	uint16_t minute : 6;
	uint16_t hour : 5;
};

struct [[gnu::packed]] fat_file_entry {
	char filename[8];
	char extension[3];
	uint8_t attributes;
	uint8_t user_attributes;
	uint8_t creation_tenths;
	fat_time creation_time;
	fat_date creation_date;
	fat_date accessed_date;
	uint16_t cluster_high;
	fat_time modified_time;
	fat_date modified_date;
	uint16_t cluster_low;
	uint32_t file_size;
};

struct [[gnu::packed]] fat_file_lfn {
	uint8_t position; //Last entry masked with 0x40
	uint16_t chars_1[5];
	uint8_t flags; //Always 0x0f
	uint8_t entry_type; //Always 0
	uint8_t checksum;
	uint16_t chars_2[6];
	uint16_t reserved2;
	uint16_t chars_3[2];
};

struct fat_dir_ent {
	union {
		fat_file_entry file;
		fat_file_lfn lfn;
	};
};

#define MBR_PARTITION_START 0x1b8
#define PARTITION_ATTR_ACTIVE 0x80
#define SIG_MBR_FAT32 0x0c
#define SIG_BPB_FAT32 0x29

#define FAT_TABLE_CHAIN_STOP 0x0ffffff8

static uint64_t cluster_lba(uint32_t cluster) {
	return (uint64_t)(cluster - 2) * globals->fat_data.sectors_per_cluster + globals->fat_data.cluster_lba_offset;
}
static uint32_t count_consecutive_clusters(uint32_t cluster) {
	uint32_t c = cluster;
	while (globals->fat_data.fat_tables[0][c] == c + 1) c++;
	return c - cluster + 1;
}
static vector<fat_disk_span> read_file_layout(uint32_t cluster) {
	vector<fat_disk_span> layout(1);
	do {
		uint32_t count = count_consecutive_clusters(cluster);
		layout.append({ cluster, count });
		cluster = globals->fat_data.fat_tables[0][cluster + count - 1];
	} while (cluster != FAT_TABLE_CHAIN_STOP);
	return layout;
}

void fat_init() {
	partition_table* partTable = (partition_table*)(0x7c00 + MBR_PARTITION_START);
	int i = 0;
	for (; i < 4; i++)
		if (partTable->entries[i].sysid == SIG_MBR_FAT32) break;
	kassert(ALWAYS_ACTIVE, ERROR, i < 4, "No FAT32 partition found, was the MBR corrupted?\n");
	fat32_bpb* bpb = new fat32_bpb();
	read_disk(bpb, partTable->entries[i].lba_start, 1);
	kassert(ALWAYS_ACTIVE, ERROR, bpb->signature == SIG_BPB_FAT32, "Partition not recognized as FAT32.\n");

	globals->fat_data.sectors_per_cluster = bpb->sectors_per_cluster;
	globals->fat_data.bytes_per_sector = bpb->bytes_per_sector;
	globals->fat_data.bytes_per_cluster = globals->fat_data.bytes_per_sector * globals->fat_data.sectors_per_cluster;
	globals->fat_data.cluster_lba_offset =
		partTable->entries[i].lba_start + (bpb->reserved_sectors + bpb->fat_tables * bpb->sectors_per_fat32);

	//bpb->fat_tables = 1;

	new (&globals->fat_data.fat_tables) vector<uint32_t*>(1);
	for (int i = 0; i < bpb->fat_tables; i++) {
		globals->fat_data.fat_tables.append((uint32_t*)walloc(bpb->sectors_per_fat32 * bpb->bytes_per_sector, 0x10));
		read_disk(globals->fat_data.fat_tables[i],
				  partTable->entries[i].lba_start + (bpb->reserved_sectors + i * bpb->sectors_per_fat32),
				  bpb->sectors_per_fat32);
	}

	new (&globals->fat_data.root_directory) fat_file(
		new fat_inode(bpb->root_dir_entries * 32, FAT_ATTRIBS::VOL_ID | FAT_ATTRIBS::SYSTEM | FAT_ATTRIBS::DIRECTORY,
					  NULL, bpb->root_cluster_num));
	globals->fat_data.root_directory.inode->filename = "ROOT"_RO;
	new (&globals->fat_data.working_directory) fat_file(globals->fat_data.root_directory);
	delete bpb;
}

fat_inode::fat_inode(uint32_t filesize, uint8_t attributes, fat_inode* parent, uint32_t start_cluster)
	: filesize(filesize)
	, attributes(attributes)
	, loaded(0)
	, references()
	, parent(parent)
	, start_cluster(start_cluster)
	, disk_layout() {
	filename.unsafe_clear();
	data.unsafe_clear();
}
fat_inode::~fat_inode() { close(); }

static fat_inode* from_dir_ents(fat_inode* parent, fat_dir_ent* entries, std::size_t nLFNs) {
	fat_file_entry* file = &entries[nLFNs].file;
	fat_inode* inode = new fat_inode(file->file_size, file->attributes, parent,
									 (uint32_t)file->cluster_high << 16 | file->cluster_low);
	inode->filename.reserve(nLFNs * 13);
	for (std::size_t lfnIdx = 0; lfnIdx < nLFNs; lfnIdx++) {
		fat_file_lfn* lfn = &entries[lfnIdx].lfn;
		std::size_t offset = ((lfn->position & 0x3f) - 1) * 13;
		bool br = false;
		for (int i = 0; !br && i < 5; i++)
			if (lfn->chars_1[i])
				inode->filename.at(offset + i) = lfn->chars_1[i];
			else
				br = true;
		for (int i = 0; !br && i < 6; i++)
			if (lfn->chars_2[i])
				inode->filename.at(offset + i + 5) = lfn->chars_2[i];
			else
				br = true;
		for (int i = 0; !br && i < 2; i++)
			if (lfn->chars_3[i])
				inode->filename.at(offset + i + 11) = lfn->chars_3[i];
			else
				br = true;
	}
	//qprintf<64>("name: %S\n", &inode->filename);
	return inode;
}
static void* read_from_disk_layout(fat_inode* inode, std::size_t* out_sz) {
	std::size_t cluster_idx = 0;
	for (std::size_t i = 0; i < inode->disk_layout.size(); i++) cluster_idx += inode->disk_layout.at(i).span_length;
	std::size_t sz = cluster_idx * globals->fat_data.bytes_per_cluster;
	if (out_sz) *out_sz = sz;
	void* dat = kmalloc(sz);
	cluster_idx = 0;
	std::size_t cluster = inode->disk_layout.at(0).sector_start;
	for (std::size_t i = 0; i < inode->disk_layout.size(); i++) {
		std::size_t sectors = inode->disk_layout.at(i).span_length * globals->fat_data.sectors_per_cluster;
		std::size_t lba = cluster_lba(cluster);
		read_disk((void*)((uint64_t)dat + cluster_idx * globals->fat_data.bytes_per_cluster), lba, sectors);
		cluster_idx += inode->disk_layout.at(i).span_length;
	}
	return dat;
}

void fat_inode::_add_child(fat_inode* child) {
	uint8_t buf[sizeof(fat_inode*)];
	memcpy(buf, &child, sizeof(fat_inode*));
	for (size_t i = 0; i < sizeof(fat_inode*); i++) data.append(buf[i]);
}
fat_inode* fat_inode::_get_child(size_t idx) { return span(data).reinterpret_as<fat_inode*>()[idx]; }
size_t fat_inode::_num_children() { return data.size() / sizeof(fat_inode*); }

void fat_inode::open() {
	if (loaded) return;
	disk_layout = read_file_layout(start_cluster);
	std::size_t sz = 0;
	void* dat = read_from_disk_layout(this, &sz);
	if (attributes & FAT_ATTRIBS::DIRECTORY) {
		fat_dir_ent* entries = (fat_dir_ent*)dat;
		std::size_t idx = 0;
		while (entries[idx].file.attributes) {
			if ((entries[idx].file.attributes & FAT_ATTRIBS::VOL_ID) &&
				entries[idx].file.attributes != FAT_ATTRIBS::LFN) {
				idx++;
				continue;
			}
			std::size_t sidx = idx;
			while (entries[idx].file.attributes == FAT_ATTRIBS::LFN) idx++;
			std::size_t nLFNs = idx - sidx;
			_add_child(from_dir_ents(this, &entries[sidx], nLFNs));
			idx++;
		}
		kfree(dat);
	} else
		data.unsafe_set(dat, sz, sz);
	loaded = 1;
	if (parent) parent->references[1]++;
}

void fat_inode::close() {
	if (!loaded) return;
	purge();
}

void fat_inode::purge() {
	if (!loaded) return;
	if (attributes & FAT_ATTRIBS::DIRECTORY) {
		for (fat_inode* n : span(data).reinterpret_as<fat_inode*>()) n->purge();
	}
	if (!references[0] && !references[1]) {
		if (attributes & FAT_ATTRIBS::DIRECTORY) {
			for (fat_inode* n : span(data).reinterpret_as<fat_inode*>()) delete n;
		}
		data.clear();
		disk_layout.clear();

		if (parent && loaded) parent->references[1]--;
		loaded = 0;
	}
}

fat_file::fat_file()
	: inode(NULL) {};
fat_file::fat_file(fat_inode* inode)
	: inode(inode) {
	if (inode) {
		inode->open();
		inode->references[0]++;
	}
}
fat_file::fat_file(const fat_file& other)
	: inode(other.inode) {
	if (inode) inode->references[0]++;
}
fat_file::fat_file(fat_file&& other)
	: inode(other.inode) {
	other.inode = NULL;
}
fat_file& fat_file::operator=(const fat_file& other) {
	destroy();
	inode = other.inode;
	if (inode) inode->references[0]++;
	return *this;
}
fat_file& fat_file::operator=(fat_file&& other) {
	destroy();
	inode = other.inode;
	other.inode = NULL;
	return *this;
}
void fat_file::destroy() {
	if (inode) {
		inode->references[0]--;
		if (!inode->references[0]) inode->close();
	}
	inode = NULL;
}
fat_file::~fat_file() { destroy(); }
vector<uint8_t>& fat_file::data() const { return inode->data; }
span<const uint8_t> fat_file::rodata() const {
	return span<const uint8_t>(&*data().begin(), &*data().begin() + inode->filesize);
}

fat_file file_open(fat_file& directory, rostring filename) {
	if (!directory.inode) return fat_file();
	if (!(directory.inode->attributes & FAT_ATTRIBS::DIRECTORY)) return fat_file();
	for (size_t i = 0; i < directory.inode->_num_children(); i++) {
		if (directory.inode->_get_child(i)->filename == filename) return fat_file(directory.inode->_get_child(i));
	}
	return NULL;
}
fat_file file_open(rostring absolute_path) {
	vector<rostring> parts = absolute_path.split("\\/");
	fat_file file;
	if (!parts[0].size())
		file = globals->fat_data.root_directory;
	else
		file = globals->fat_data.working_directory;
	for (std::size_t i = 0; i < parts.size(); i++) {
		if (!file.inode) return fat_file();
		if (!parts[i].size()) {
			kassert(DEBUG_ONLY, COMMENT, 0, "Empty path fragment.");
			continue;
		}
		if (parts[i] == "."_RO) continue;
		if (parts[i] == ".."_RO) {
			file = fat_file(file.inode->parent);
			continue;
		}
		file = file_open(file, parts[i]);
	}
	return file;
}
