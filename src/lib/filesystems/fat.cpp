#include <cstddef>
#include <cstdint>
#include <drivers/ahci.hpp>
#include <kassert.hpp>
#include <kctype.hpp>
#include <kfile.hpp>
#include <kstdlib.hpp>
#include <kstring.hpp>
#include <lib/filesystems/fat.hpp>
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

	char pad[510 - 90];
	char sig[2];
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

constexpr uint32_t MBR_PARTITION_START = 0x1b8;
constexpr uint8_t PARTITION_ATTR_ACTIVE = 0x80;
constexpr uint8_t SIG_MBR_FAT32 = 0x0c;
constexpr uint8_t SIG_BPB_FAT32 = 0x29;

constexpr uint32_t FAT_TABLE_FREE = 0x00000000;
constexpr uint32_t FAT_TABLE_CHAIN_STOP = 0x0ffffff8;

static constexpr uint32_t fat_lba() { return globals->fat32->bpb_lba_offset + globals->fat32->bpb->reserved_sectors; }
static constexpr uint32_t fat_entries() {
	return globals->fat32->bpb->sectors_per_fat32 * globals->fat32->bytes_per_sector / sizeof(uint32_t);
}
static constexpr uint32_t& fat_entry(uint32_t cluster) { return globals->fat32->fat_tables[0][cluster]; }
static constexpr uint64_t cluster_lba(uint32_t cluster) {
	return (uint64_t)(cluster - 2) * globals->fat32->sectors_per_cluster + globals->fat32->cluster_lba_offset;
}
static constexpr uint8_t fat_lfn_checksum(const char* pFCBName) {
	uint8_t sum = 0;
	for (int i = 11; i; i--)
		sum = ((sum & 1) << 7) + (sum >> 1) + *(uint8_t*)pFCBName++;
	return sum;
}

void fat_init() {
	pointer<partition_table, integer> partTable = 0x7c00 + MBR_PARTITION_START;
	int i = 0;
	for (; i < 4; i++)
		if (partTable->entries[i].sysid == SIG_MBR_FAT32)
			break;
	kassert(ALWAYS_ACTIVE, ERROR, i < 4, "No FAT32 partition found, was the MBR corrupted?\n");
	globals->fat32 = pointer<fat_sys_data, unique>::make_unique(new fat_sys_data());
	globals->fat32->bpb = pointer<fat32_bpb, unique>::make_unique(new fat32_bpb());
	read_disk(globals->fat32->bpb, partTable->entries[i].lba_start, 1);
	kassert(ALWAYS_ACTIVE, ERROR, globals->fat32->bpb->signature == SIG_BPB_FAT32,
			"Partition not recognized as FAT32.\n");

	globals->fat32->bpb_lba_offset = partTable->entries[i].lba_start;
	globals->fat32->sectors_per_cluster = globals->fat32->bpb->sectors_per_cluster;
	globals->fat32->bytes_per_sector = globals->fat32->bpb->bytes_per_sector;
	globals->fat32->bytes_per_cluster = globals->fat32->bytes_per_sector * globals->fat32->sectors_per_cluster;
	globals->fat32->cluster_lba_offset = globals->fat32->bpb_lba_offset + globals->fat32->bpb->reserved_sectors +
										 globals->fat32->bpb->fat_tables * globals->fat32->bpb->sectors_per_fat32;

	new (&globals->fat32->fat_tables) vector<pointer<uint32_t, unique>>(1);
	for (int i = 0; i < globals->fat32->bpb->fat_tables; i++) {
		globals->fat32->fat_tables.emplace_back(pointer<uint32_t, unique, type_cast>::make_unique(
			globals->global_mmap_alloc.alloc(fat_entries() * sizeof(uint32_t))));
		read_disk(globals->fat32->fat_tables[i], fat_lba() + i * globals->fat32->bpb->sectors_per_fat32,
				  globals->fat32->bpb->sectors_per_fat32);
	}

	new (&globals->fat32->root_directory)
		file_t(new file_inode(0, FILE_ATTRIBS::SYSTEM | FILE_ATTRIBS::DIRECTORY, NULL,
							  FAT_ATTRIBS::VOL_ID | FAT_ATTRIBS::SYSTEM | FAT_ATTRIBS::DIRECTORY,
							  globals->fat32->bpb->root_cluster_num));
	globals->fat32->root_directory.n->filename = "ROOT"_RO;

	globals->fs = pointer<filesystem, unique>::make_unique(new filesystem());
	*globals->fs = { &fat_read_directory, &fat_write_directory,			  &fat_read_file,
					 &fat_write_file,	  globals->fat32->root_directory, globals->fat32->root_directory };
}

static constexpr uint32_t count_consecutive_clusters(uint32_t cluster) {
	uint32_t c = cluster;
	while (fat_entry(c) == c + 1)
		c++;
	return c - cluster + 1;
}
static vector<fat_disk_span> read_file_layout(uint32_t cluster) {
	vector<fat_disk_span> layout(1);
	do {
		kassert(ALWAYS_ACTIVE, ERROR, cluster < fat_entries(), "Cluster out of range.");
		kassert(ALWAYS_ACTIVE, ERROR, cluster, "Unexpected null cluster.");

		uint32_t count = count_consecutive_clusters(cluster);
		layout.append({ cluster, count });
		cluster = fat_entry(cluster + count - 1);
	} while (cluster != FAT_TABLE_CHAIN_STOP);
	return layout;
}
static vector<char> from_disk_layout(const vector<fat_disk_span>& disk_layout) {
	std::size_t cluster_idx = 0;
	for (std::size_t i = 0; i < disk_layout.size(); i++)
		cluster_idx += disk_layout.at(i).span_length;
	std::size_t sz = cluster_idx * globals->fat32->bytes_per_cluster;
	vector<char> res = vector<char>(sz, vec_resize{});
	cluster_idx = 0;
	for (std::size_t i = 0; i < disk_layout.size(); i++) {
		std::size_t sectors = disk_layout.at(i).span_length * globals->fat32->sectors_per_cluster;
		std::size_t lba = cluster_lba(disk_layout.at(i).cluster_start);
		read_disk(pointer<void, integer>((uint64_t)res.cbegin() + cluster_idx * globals->fat32->bytes_per_cluster), lba,
				  sectors);
		cluster_idx += disk_layout.at(i).span_length;
	}
	return res;
}

static constexpr uint32_t next_free_cluster(uint32_t start) {
	for (uint32_t i = start; i < fat_entries(); i++) {
		if (!fat_entry(i))
			return i;
	}
	return 0;
}
static void alloc_disk_layout(vector<fat_disk_span>& disk_layout, std::size_t sz) {
	if (!sz) {
		disk_layout.clear();
		return;
	}
	std::size_t num_clusters = (sz + globals->fat32->bytes_per_cluster - 1) / globals->fat32->bytes_per_cluster;
	for (std::size_t i = 0; i < disk_layout.size(); i++) {
		if (num_clusters < disk_layout[i].span_length) {
			// Free spare cluster space
			fat_entry(disk_layout[i].cluster_start + num_clusters - 1) = FAT_TABLE_CHAIN_STOP;
			for (std::size_t j = num_clusters; j < disk_layout[i].span_length; j++)
				fat_entry(disk_layout[i].cluster_start + j) = FAT_TABLE_FREE;
			for (std::size_t j = i + 1; j < disk_layout.size(); j++)
				for (std::size_t k = 0; k < disk_layout[j].span_length; k++)
					fat_entry(disk_layout[j].cluster_start + k) = FAT_TABLE_FREE;
			disk_layout[i].span_length = num_clusters;
			disk_layout.erase(i + 1, disk_layout.size() - i - 1);
		}
		num_clusters -= disk_layout[i].span_length;
	}
	if (num_clusters > 0) {
		// Allocate new cluster space
		while (num_clusters) {
			uint32_t start_cluster = next_free_cluster(2);
			uint32_t span_length = 0;
			while (num_clusters) {
				uint32_t next_cluster = next_free_cluster(start_cluster + span_length + 1);
				fat_entry(start_cluster + span_length) = next_cluster;
				span_length++;
				num_clusters--;
				if (next_cluster != start_cluster + span_length + 1)
					break;
			}
			disk_layout.append({ start_cluster, span_length });
		}
		fat_disk_span last = disk_layout.back();
		fat_entry(last.cluster_start + last.span_length - 1) = FAT_TABLE_CHAIN_STOP;
	}
}
static void to_disk_layout(vector<fat_disk_span>& disk_layout, pointer<const void, reinterpret> ptr) {
	for (std::size_t i = 0; i < disk_layout.size(); i++) {
		write_disk(ptr, cluster_lba(disk_layout[i].cluster_start),
				   disk_layout[i].span_length * globals->fat32->sectors_per_cluster);
		ptr = (uint64_t)ptr + disk_layout[i].span_length * globals->fat32->bytes_per_cluster;
	}
}

static pointer<file_inode> from_dir_ent(pointer<file_inode> parent, pointer<const fat_dir_ent> entries,
										std::size_t nLFNs) {
	const fat_file_entry* file = &entries[nLFNs].file;
	pointer<file_inode> inode = new file_inode(file->file_size, 0, parent, file->attributes,
											   (uint64_t)file->cluster_high << 16 | file->cluster_low);
	if (inode->fs_attribs & FAT_ATTRIBS::READONLY)
		inode->attributes |= FILE_ATTRIBS::READONLY;
	if (inode->fs_attribs & FAT_ATTRIBS::HIDDEN)
		inode->attributes |= FILE_ATTRIBS::HIDDEN;
	if (inode->fs_attribs & FAT_ATTRIBS::SYSTEM)
		inode->attributes |= FILE_ATTRIBS::SYSTEM;
	if (inode->fs_attribs & FAT_ATTRIBS::DIRECTORY)
		inode->attributes |= FILE_ATTRIBS::DIRECTORY;

	inode->filename.reserve(nLFNs * 13);
	for (std::size_t lfnIdx = 0; lfnIdx < nLFNs; lfnIdx++) {
		const fat_file_lfn* lfn = &entries[lfnIdx].lfn;
		std::size_t offset = ((lfn->position & 0x3f) - 1) * 13;
		for (int i = 0; i < 5; i++) {
			inode->filename.at(offset + i) = lfn->chars_1[i];
			if (!lfn->chars_1[i])
				goto end;
		}
		for (int i = 0; i < 6; i++) {
			inode->filename.at(offset + i + 5) = lfn->chars_2[i];
			if (!lfn->chars_2[i])
				goto end;
		}
		for (int i = 0; i < 2; i++) {
			inode->filename.at(offset + i + 11) = lfn->chars_3[i];
			if (!lfn->chars_3[i])
				goto end;
		}
end:
	}
	//qprintf<64>("name: %S\n", &inode->filename);
	return inode;
}
static void to_dir_ents(pointer<file_inode> directory) {
	directory->data.clear();
	auto tmp = directory->data.obegin();
	obinstream out{ *(vector_iterator<std::byte, default_allocator>*)&tmp };
	vector<file_t> children = file_t(directory).children();
	vector<fat_file_entry> files(children.size(), vec_resize{});
	for (std::size_t i = 0; i < children.size(); i++) {
		if (!children[i].n->fs_attribs) {
			if (children[i].n->is_directory)
				children[i].n->fs_attribs |= FAT_ATTRIBS::DIRECTORY;
			else
				children[i].n->fs_attribs |= FAT_ATTRIBS::ARCHIVE;
			if (children[i].n->is_readonly)
				children[i].n->fs_attribs |= FAT_ATTRIBS::READONLY;
			if (children[i].n->is_hidden)
				children[i].n->fs_attribs |= FAT_ATTRIBS::HIDDEN;
			if (children[i].n->is_system)
				children[i].n->fs_attribs |= FAT_ATTRIBS::SYSTEM;
		}

		files[i].attributes = children[i].n->fs_attribs;
		files[i].creation_time = (fat_time){ 1, 0, 0 };
		files[i].creation_date = (fat_date){ 1, 1, 0 };
		files[i].accessed_date = (fat_date){ 1, 1, 0 };
		files[i].cluster_high = children[i].n->fs_reference >> 16;
		files[i].cluster_low = children[i].n->fs_reference & 0xffff;
		files[i].file_size = children[i].n->filesize;

		memset(files[i].filename, ' ', 8);
		memset(files[i].extension, ' ', 3);

		istringstream ns = { children[i].n->filename };
		int extStart = 0;
		if (files[i].attributes & FAT_ATTRIBS::VOL_ID) {
			for (int j = 0; j < 11 && ns.readable() && ns.peek(); j++)
				files[i].filename[j] = toupper(ns.read_c());
			continue;
		}
		for (char c : children[i].n->filename) {
			extStart++;
			if (!c || c == '.')
				break;
		}
		for (std::size_t j = 0; j < 3 && j < children[i].n->filename.size() - extStart; j++) {
			files[i].extension[j] = toupper(children[i].n->filename[extStart + j]);
		}
		if (extStart < 7)
			for (int j = 0; ns.readable() && ns.peek() && ns.peek() != '.'; j++)
				files[i].filename[j] = toupper(ns.read_c());
		else {
			for (int j = 0; j < 6; j++)
				files[i].filename[j] = toupper(ns.read_c());

			files[i].filename[6] = '~';
			char idx = '1';
			for (std::size_t j = 0; j < i; j++) {
				if (!memcmp(files[j].filename, files[i].filename, 6) &&
					!memcmp(files[j].extension, files[i].extension, 3))
					idx++;
			}
			files[i].filename[7] = idx;
		}
	}

	for (std::size_t i = 0; i < children.size(); i++) {
		if (files[i].attributes & FAT_ATTRIBS::VOL_ID) {
			out.write(&files[i], sizeof(fat_file_entry));
			continue;
		}
		int nLFNs = (children[i].n->filename.size() + 12) / 13;
		istringstream ns = { children[i].n->filename };
		for (int k = 0; k < nLFNs; k++) {
			fat_file_lfn lfn;
			lfn.flags = 0x0f;
			lfn.entry_type = 0;
			lfn.position = (k + 1) | (k == nLFNs - 1 ? 0x40 : 0);
			lfn.checksum = fat_lfn_checksum(files[i].filename);
			lfn.reserved2 = 0;
			memset(lfn.chars_1, 0xff, 10);
			memset(lfn.chars_2, 0xff, 12);
			memset(lfn.chars_3, 0xff, 4);

			int lfnCtr = 0;
			while (lfnCtr < 5) {
				lfn.chars_1[lfnCtr++] = ns.read_c();
				if (!lfn.chars_1[lfnCtr - 1])
					goto end_lfn;
			}
			while (lfnCtr < 11) {
				lfn.chars_2[lfnCtr++ - 5] = ns.read_c();
				if (!lfn.chars_2[lfnCtr - 6])
					goto end_lfn;
			}
			while (lfnCtr < 13) {
				lfn.chars_3[lfnCtr++ - 11] = ns.read_c();
				if (!lfn.chars_3[lfnCtr - 12])
					goto end_lfn;
			}
end_lfn:
			out.write(&lfn, sizeof(fat_file_lfn));
		}
		out.write(&files[i], sizeof(fat_file_entry));
	}
	std::size_t sz = directory->data.size();
	std::size_t nsz =
		((directory->data.size() + globals->fat32->bytes_per_cluster - 1) / globals->fat32->bytes_per_cluster) *
		globals->fat32->bytes_per_cluster;
	directory->data.resize(nsz);
	memset(directory->data.begin() + sz, 0, nsz - sz);
}

static void write_bpb_fats() {
	//globals->fat32->bpb->root_cluster_num = globals->fat32->root_directory.n->fs_reference;
	//globals->fat32->bpb->root_dir_entries = globals->fat32->root_directory.children().size();
	write_disk(globals->fat32->bpb, globals->fat32->bpb_lba_offset, 1);
	write_disk(globals->fat32->bpb, globals->fat32->bpb_lba_offset + globals->fat32->bpb->backup_boot_sector, 1);

	for (std::size_t i = 1; i < globals->fat32->fat_tables.size(); i++) {
		kmemcpy<4096>(globals->fat32->fat_tables[i], globals->fat32->fat_tables[0], fat_entries() * sizeof(uint32_t));
	}
	for (std::size_t i = 0; i < globals->fat32->fat_tables.size(); i++) {
		write_disk(globals->fat32->fat_tables[i], fat_lba() + i * globals->fat32->bpb->sectors_per_fat32,
				   globals->fat32->bpb->sectors_per_fat32);
	}
}

void fat_read_directory(pointer<file_inode> dir) {
	fat_read_file(dir);
	span<const char> dat = file_t(dir).rodata();
	if (!dat.size())
		return;
	pointer<const fat_dir_ent, type_cast> entries = dat.begin();
	for (std::size_t idx = 0; entries[idx].file.attributes; idx++) {
		if ((entries[idx].file.attributes & FAT_ATTRIBS::VOL_ID) && entries[idx].file.attributes != FAT_ATTRIBS::LFN) {
			pointer<file_inode> vol = from_dir_ent(dir, &entries[idx], 0);
			vol->attributes = FILE_ATTRIBS::HIDDEN | FILE_ATTRIBS::SYSTEM;
			vol->filename = rostring(entries[idx].file.filename, 11);
			vol->move(dir, true);
			continue;
		}
		std::size_t sidx = idx;
		while (entries[idx].file.attributes == FAT_ATTRIBS::LFN)
			idx++;
		std::size_t nLFNs = idx - sidx;
		pointer<file_inode> new_child = from_dir_ent(dir, &entries[sidx], nLFNs);
		new_child->move(dir, true);
	}
}
void fat_write_directory(pointer<file_inode> dir) {
	to_dir_ents(dir);
	fat_write_file(dir);
}
void fat_read_file(pointer<file_inode> file) {
	if (file->fs_reference)
		file->data = from_disk_layout(read_file_layout(file->fs_reference));
	else
		file->data.clear();
	if (!(file->fs_attribs & FAT_ATTRIBS::DIRECTORY))
		file->data.resize(file->filesize);
}
void fat_write_file(pointer<file_inode> file) {
	file->filesize = file->fs_attribs & FAT_ATTRIBS::DIRECTORY ? 0 : file->data.size();
	vector<fat_disk_span> layout = file->fs_reference ? read_file_layout(file->fs_reference) : vector<fat_disk_span>();
	alloc_disk_layout(layout, file->data.size());
	file->fs_reference = layout.size() ? layout[0].cluster_start : 0;
	to_disk_layout(layout, file_t(file).rodata().begin());

	if (!file->is_directory)
		fat_write_directory(file->parent);

	write_bpb_fats();
}
