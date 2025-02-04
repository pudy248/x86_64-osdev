#include <cstring>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <numeric>
#include <ranges>
#include <vector>

namespace fs = std::filesystem;

constexpr uint8_t FAT_ATTRIB_RO = 0x01;
constexpr uint8_t FAT_ATTRIB_HIDDEN = 0x02;
constexpr uint8_t FAT_ATTRIB_SYSTEM = 0x04;
constexpr uint8_t FAT_ATTRIB_VOL_ID = 0x08;
constexpr uint8_t FAT_ATTRIB_DIR = 0x10;
constexpr uint8_t FAT_ATTRIB_ARCHIVE = 0x20;
constexpr uint8_t FAT_ATTRIB_LFN = 0x0f;

constexpr uint32_t FAT_TABLE_CHAIN_STOP = 0x0ffffff8;

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

struct [[gnu::packed]] fat_disk_entry {
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
};
struct [[gnu::packed]] fat_disk_lfn {
	uint8_t position; //Last entry masked with 0x40
	uint16_t chars_1[5];
	uint8_t flags; //Always 0x0f
	uint8_t entry_type; //Always 0
	uint8_t checksum;
	uint16_t chars_2[6];
	uint16_t reserved2;
	uint16_t chars_3[2];
};

uint8_t fat_lfn_checksum(const uint8_t* pFCBName) {
	uint8_t sum = 0;
	for (int i = 11; i; i--)
		sum = ((sum & 1) << 7) + (sum >> 1) + *pFCBName++;
	return sum;
}
template <typename T>
void pad_to(std::vector<T>& v, std::size_t size) {
	if (v.size() > size) {
		fprintf(stderr, "ERROR!!!! pad_to size smaller than existing size. %zu vs %zu\n", v.size(), size);
		exit(-1);
	}
	while (v.size() < size)
		v.push_back(0);
}

std::vector<uint32_t> fat_table = { FAT_TABLE_CHAIN_STOP, FAT_TABLE_CHAIN_STOP };
std::vector<uint8_t> output;

[[gnu::const]] std::size_t entry_sizeof(const fs::path& p) { return 16 * ((std::string{ p }.size() + 25) / 13); }

[[gnu::const]] constexpr uint32_t num_clusters(std::size_t size) {
	return (size + 512 * SECTORS_PER_CLUSTER - !!size) / (512 * SECTORS_PER_CLUSTER);
}

uint32_t reserve_buffer(std::size_t size) {
	uint32_t ret = fat_table.size();
	for (uint32_t i = 0; i < num_clusters(size) - 1; i++) {
		fat_table.emplace_back(fat_table.size() + 1);
	}
	fat_table.emplace_back(FAT_TABLE_CHAIN_STOP);
	return ret;
}

uint32_t reserve_path(const fs::path& p) {
	if (fs::is_directory(p)) {
		std::vector<fs::path> entries{ fs::directory_iterator(p), fs::directory_iterator() };
		std::size_t total_size =
			std::transform_reduce(entries.begin(), entries.end(), std::size_t{ 0 }, std::plus{}, entry_sizeof);
		return reserve_buffer(total_size);
	} else
		return reserve_buffer(fs::file_size(p));
}

std::vector<uint8_t> load_file(const fs::path& p) {
	std::vector<uint8_t> data(fs::file_size(p));
	std::ifstream f(p, std::ios::binary);
	f.read((char*)data.data(), data.size());
	return data;
}

void write_file(const fs::path& p) {
	printf("FILE %s\n", p.c_str());
	std::vector<uint8_t> data{ load_file(p) };
	pad_to(data, num_clusters(data.size()) * SECTORS_PER_CLUSTER * 512);
	output.insert(output.end(), data.begin(), data.end());
}

void write_dir(const fs::path& p) {
	printf("DIR %s\n", p.c_str());
	std::vector<fs::path> entries{ fs::directory_iterator(p), fs::directory_iterator() };
	std::size_t total_size =
		std::transform_reduce(entries.begin(), entries.end(), std::size_t{ 0 }, std::plus{}, entry_sizeof);
	uint32_t start_cluster = reserve_buffer(total_size);
	printf("Sizeof %s: %zu\nStart cluster: %u\n", p.c_str(), total_size, start_cluster);

	std::vector<uint32_t> child_clusters;
	for (const fs::path& path : entries)
		child_clusters.emplace_back(reserve_path(path));

	std::vector<uint8_t> data;

	for (int pidx = 0; pidx < entries.size(); pidx++) {
		const fs::path& path = entries[pidx];
		std::string fname = path.filename();
		std::string stem = path.stem();
		std::string ext = path.extension();

		fat_disk_entry f{ "",
						  "",
						  fs::is_directory(path) ? FAT_ATTRIB_DIR : FAT_ATTRIB_ARCHIVE,
						  0,
						  0,
						  (fat_time){ 1, 0, 0 },
						  (fat_date){ 1, 1, 0 },
						  (fat_date){ 1, 1, 0 },
						  (uint16_t)(child_clusters[pidx] >> 16),
						  (fat_time){ 1, 0, 0 },
						  (fat_date){ 1, 1, 0 },
						  (uint16_t)(child_clusters[pidx] & 0xffff),
						  (uint32_t)fs::file_size(path) };
		memset(f.filename, ' ', 11);

		if (stem.size() > 7) {
			for (int i = 0; i < 6; i++)
				f.filename[i] = toupper(stem[i]);
			f.filename[6] = '~';
			f.filename[7] = '1';
			//for (int k = 0; k < rootCtr; k++) {
			//	f.filename[ctr] = idx;
			//	if (!strncmp(f.filename, rootDir[k].filename, 8)) {
			//		idx++;
			//		k = -1;
			//	}
			//}
		} else
			for (int i = 0; i < 8 && i < stem.size(); i++)
				f.filename[i] = toupper(stem[i]);

		for (int i = 0; i < 8 && i < ext.size(); i++)
			f.extension[i] = toupper(ext[i]);

		int nLFNs = (fname.size() + 12) / 13;
		fat_disk_lfn* names = new fat_disk_lfn[nLFNs];
		uint8_t checksum = fat_lfn_checksum((const uint8_t*)f.filename);

		int j = 0;
		for (int i = 0; i < nLFNs; i++) {
			int lfnIdx = nLFNs - i - 1;
			names[lfnIdx].flags = FAT_ATTRIB_LFN;
			names[lfnIdx].entry_type = 0;
			names[lfnIdx].position = (i + 1) | (!lfnIdx ? 0x40 : 0);
			names[lfnIdx].checksum = checksum;
			names[lfnIdx].reserved2 = 0;
			memset((char*)names[lfnIdx].chars_1, 0xff, 10);
			memset((char*)names[lfnIdx].chars_2, 0xff, 12);
			memset((char*)names[lfnIdx].chars_3, 0xff, 4);

			for (int k = 0; k < 5; j++) {
				names[lfnIdx].chars_1[k++] = fname[j];
				if (fname[j] == 0)
					goto end;
			}
			for (int k = 0; k < 6; j++) {
				names[lfnIdx].chars_2[k++] = fname[j];
				if (fname[j] == 0)
					goto end;
			}
			for (int k = 0; k < 2; j++) {
				names[lfnIdx].chars_3[k++] = fname[j];
				if (fname[j] == 0)
					goto end;
			}
		}
end:
		data.insert(data.end(), (uint8_t*)names, (uint8_t*)(names + nLFNs));
		data.insert(data.end(), (uint8_t*)&f, (uint8_t*)(&f + 1));
		delete[] names;
	}

	pad_to(data, num_clusters(total_size) * SECTORS_PER_CLUSTER * 512);
	output.insert(output.end(), data.begin(), data.end());

	for (const fs::path& path : entries) {
		if (fs::is_directory(path))
			write_dir(path);
		else
			write_file(path);
	}
}

constexpr uint32_t FAT32_FSINFO_SECTOR = 1;
constexpr uint32_t FAT32_BACKUP_BPB = 2;
constexpr uint32_t FAT_TABLES = 2;

int main(int argc, char** argv) {
	write_dir(argv[1]);

	// Stage 0, 1, 2, before 1st partition
	std::vector<uint8_t> bootloader{ load_file("tmp/bootloader.img") };
	pad_to(bootloader, BOOTLOADER_RESERVED_SECTORS * 512);

	// Fat32 BPB
	std::vector<uint8_t> fat32{ load_file("tmp/fat32.img") };
	pad_to(fat32, 512);
	std::vector<uint8_t> fsinfo{ load_file("tmp/fsinfo.img") };
	pad_to(fsinfo, 512);

	pad_to(fat_table, SECTORS_PER_FAT32 * 128);

	static_assert(FAT32_FSINFO_SECTOR < FAT32_BACKUP_BPB, "Misordered FAT32 fragments.");
	std::vector<uint8_t> fat32_reserved_section;
	fat32_reserved_section.insert(fat32_reserved_section.end(), fat32.begin(), fat32.end());
	pad_to(fat32_reserved_section, FAT32_FSINFO_SECTOR * 512);
	fat32_reserved_section.insert(fat32_reserved_section.end(), fsinfo.begin(), fsinfo.end());
	pad_to(fat32_reserved_section, FAT32_BACKUP_BPB * 512);
	fat32_reserved_section.insert(fat32_reserved_section.end(), fat32.begin(), fat32.end());
	pad_to(fat32_reserved_section, FAT32_RESERVED_SECTORS * 512);

	std::ofstream img("disk.img", std::ios::binary);
	img.write((char*)bootloader.data(), bootloader.size());
	img.write((char*)fat32_reserved_section.data(), fat32_reserved_section.size());
	for (int i = 0; i < FAT_TABLES; i++)
		img.write((char*)fat_table.data(), fat_table.size() * 4);
	img.write((char*)output.data(), output.size());

	return 0;
}