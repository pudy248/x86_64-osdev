#pragma once
#include <cstdint>
#include <kstring.hpp>
#include <stl/pointer.hpp>
#include <stl/vector.hpp>

struct path {
	vector<string> fragments;
	constexpr path() = default;
	constexpr path(const rostring& s) : fragments(std::move(s.split('/'))) {
		while (fragments.size() && !fragments[(fragments.size() - 1)].size()) {
			fragments.erase(fragments.size() - 1);
		}
		if (!fragments.size())
			fragments.append("");
	}
	constexpr path(ccstr_t s) : path(rostring(s)) {}
	template <ranges::range R>
	constexpr path(const R& frags) : fragments(frags) {}
	constexpr path& operator+=(const path& other) {
		fragments.append(other.fragments);
		return (*this);
	}
	constexpr path operator+(const path& other) const { return path(*this) += other; }
	constexpr path parent() const { return path(ranges::subrange(fragments, 0, fragments.size() - 1)); }
};

struct file_inode {
	string filename;

	uint64_t filesize;
	union {
		struct {
			uint64_t attributes : 63;
			uint64_t loaded : 1;
		};
		struct {
			uint64_t is_readonly : 1;
			uint64_t is_hidden : 1;
			uint64_t is_system : 1;
			uint64_t is_directory : 1;
		};
	};

	uint64_t fs_attribs;
	uint64_t fs_reference;

	uint32_t references[2];

	//timepoint created;
	//timepoint modified;
	//timepoint accessed;

	pointer<file_inode> child;
	pointer<file_inode> sibling;
	pointer<file_inode> parent;

	vector<char> data;

	file_inode(uint64_t filesize, uint64_t attributes, pointer<file_inode> parent, uint64_t fs_attribs,
			   uint64_t fs_reference);
	~file_inode();

	void open();
	void write();
	void close();
	void purge();

	void move(pointer<file_inode> new_dir, bool no_write = false);

	path get_path() const;
};

struct file_t {
	pointer<file_inode> n;

	constexpr file_t() = default;
	constexpr file_t(pointer<file_inode> inode) : n(inode) {
		if (n)
			n->references[0]++;
	}
	constexpr file_t(const file_t& other) : n(other.n) {
		if (n)
			n->references[0]++;
	}
	constexpr file_t(file_t&& other) : n(other.n) { other.n = NULL; }
	constexpr file_t& operator=(const file_t& other) {
		this->~file_t();
		n = other.n;
		if (n)
			n->references[0]++;
		return *this;
	}
	constexpr file_t& operator=(file_t&& other) {
		this->~file_t();
		n = other.n;
		other.n = NULL;
		return *this;
	}
	constexpr ~file_t() {
		if (n) {
			n->references[0]--;
			if (!n->references[0])
				n->close();
		}
		n = NULL;
	}
	constexpr file_t safe_child() const {
		if (!n->loaded)
			n->open();
		return file_t(n->child);
	}
	constexpr file_t safe_sibling() const {
		//if (!n->loaded)
		//	n->open();
		return file_t(n->sibling);
	}

	constexpr vector<char>& data() const {
		if (!n->loaded)
			n->open();
		return n->data;
	}
	constexpr span<const char> rodata() const {
		if (!n->loaded)
			n->open();
		return data();
	}
	constexpr vector<file_t> children() const {
		if (!n->loaded)
			n->open();
		vector<file_t> result;
		for (file_t it = safe_child(); it; it = it.safe_sibling())
			result.emplace_back(it);
		return result;
	}

	constexpr operator bool() const { return n; }
	constexpr operator pointer<file_inode>() const { return n; }
};

struct filesystem {
	void (*_read_directory)(pointer<file_inode> dir);
	void (*_write_directory)(pointer<file_inode> dir);
	void (*_read_file)(pointer<file_inode> file);
	void (*_write_file)(pointer<file_inode> file);

	file_t root;
	file_t current;
};

namespace fs {
namespace FILE_ATTRIBS {
enum FILE_ATTRIBS {
	READONLY = 0x01,
	HIDDEN = 0x02,
	SYSTEM = 0x04,
	DIRECTORY = 0x08,
};
}

namespace ACCESS_FLAGS {
enum ACCESS_FLAGS {
	READ = 0x01,
	WRITE = 0x02,
	MODIFY = 0x03,
	APPEND = 0x04,
	FILE = 0x08,
	DIRECTORY = 0x10,
	CREATE = 0x20,
	CREATE_IF_MISSING = 0x40,
	CREATE_RECURSIVE = 0x60,
};
}
enum class ACCESS_RESULT {
	SUCCESS,
	ERR_NOT_FOUND,
	ERR_EXISTS,
	ERR_PATH_NOT_FOUND,
	ERR_PATH_TYPE,
	ERR_TYPE_FILE,
	ERR_TYPE_DIRECTORY,
	ERR_READONLY,
	ERR_FLAGS,
	ERR_IN_USE,
	ERR_NOT_EMPTY,
};

ACCESS_RESULT access(const file_t& directory, const rostring& filename, int flags = ACCESS_FLAGS::READ);
ACCESS_RESULT access_rel(const file_t& directory, const path& relative_path, int flags = ACCESS_FLAGS::READ);
ACCESS_RESULT access(const path& path, int flags = ACCESS_FLAGS::READ);

file_t open(const file_t& directory, const rostring& filename, int flags = ACCESS_FLAGS::READ);
file_t open_rel(const file_t& directory, const path& relative_path, int flags = ACCESS_FLAGS::READ);
file_t open(const path& path, int flags = ACCESS_FLAGS::READ);

ACCESS_RESULT move(const file_t& file, const file_t& directory, const rostring& filename,
				   int flags = ACCESS_FLAGS::MODIFY);
ACCESS_RESULT move(const path& src, const path& dst, int flags = ACCESS_FLAGS::MODIFY);

ACCESS_RESULT remove(file_t& file);
ACCESS_RESULT remove_rel(const file_t& directory, const path& relative_path, int flags = ACCESS_FLAGS::READ);
ACCESS_RESULT remove(const path& path, int flags = ACCESS_FLAGS::READ);

namespace unsafe {
file_t open(const file_t& directory, const rostring& filename, int flags = ACCESS_FLAGS::READ);
file_t open_rel(const file_t& directory, const path& relative_path, int flags = ACCESS_FLAGS::READ);
file_t open(const path& path, int flags = ACCESS_FLAGS::READ);

//ACCESS_RESULT move(const file_t& file, const file_t& directory, const rostring& filename,
//				   int flags = ACCESS_FLAGS::MODIFY);
//ACCESS_RESULT move(const path& src, const path& dst, int flags = ACCESS_FLAGS::MODIFY);

//ACCESS_RESULT remove(file_t& file);
//ACCESS_RESULT remove_rel(const file_t& directory, const path& relative_path, int flags = ACCESS_FLAGS::READ);
//ACCESS_RESULT remove(const path& path, int flags = ACCESS_FLAGS::READ);
}
}