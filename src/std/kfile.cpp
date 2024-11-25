#include <cstddef>
#include <cstdint>
#include <drivers/ahci.hpp>
#include <kassert.hpp>
#include <kfile.hpp>
#include <kstring.hpp>
#include <stl/vector.hpp>
#include <sys/global.hpp>

file_inode::file_inode(uint64_t filesize, uint64_t attributes, pointer<file_inode> parent, uint64_t fs_attribs,
					   uint64_t fs_reference)
	: filesize(filesize)
	, attributes(attributes)
	, loaded(0)
	, fs_attribs(fs_attribs)
	, fs_reference(fs_reference)
	, references()
	, child()
	, sibling()
	, parent(parent) {}
file_inode::~file_inode() { close(); }

void file_inode::open() {
	if (loaded)
		return;
	loaded = 1;
	if (is_directory)
		globals->fs->_read_directory(this);
	else
		globals->fs->_read_file(this);
}
void file_inode::close() { purge(); }
void file_inode::write() {
	if (is_directory)
		globals->fs->_write_directory(this);
	else
		globals->fs->_write_file(this);
}

void file_inode::purge() {
	if (!loaded)
		return;
}

void file_inode::move(pointer<file_inode> new_dir, bool no_write) {
	if (parent) {
		if (parent->child == pointer(this))
			parent->child = sibling;
		else
			for (file_t it = file_t(parent->child); it; it = it.safe_sibling())
				if (it.safe_sibling().n == pointer(this)) {
					it.n->sibling = sibling;
					break;
				}
		if (!no_write)
			parent->write();
		parent = 0;
		sibling = 0;
	}
	if (new_dir && (new_dir->is_directory)) {
		parent = new_dir;
		pointer<file_inode>* it = &new_dir->child;
		while (*it)
			it = &((*it)->sibling);
		*it = this;
		sibling = 0;
		if (!no_write)
			new_dir->write();
	}
}

static file_t file_open_nocheck(const file_t& directory, const rostring& filename) {
	for (file_t it = directory.safe_child(); it; it = it.safe_sibling())
		if (it.n->filename == filename)
			return it;
	kassert(ALWAYS_ACTIVE, ERROR, 0, "File not found - nocheck.");
	return {};
}

ACCESS_RESULT file_access(const file_t& directory, const rostring& filename, int flags) {
	if (!directory)
		return ACCESS_RESULT::ERR_PATH_NOT_FOUND;
	//printf("FILE ACCESS %s -> %S\n", directory.n->filename.c_str(), &filename);
	//wait_until_kbhit();
	if (!(directory.n->is_directory))
		return ACCESS_RESULT::ERR_TYPE_FILE;
	for (file_t it = directory.safe_child(); it; it = it.safe_sibling()) {
		if (it.n->filename == filename) {
			if ((flags & ACCESS_FLAGS::CREATE) && !(flags & ACCESS_FLAGS::CREATE_IF_MISSING))
				return ACCESS_RESULT::ERR_EXISTS;
			else if (it.n->is_directory && (flags & ACCESS_FLAGS::FILE))
				return ACCESS_RESULT::ERR_TYPE_FILE;
			else if (!it.n->is_directory && (flags & ACCESS_FLAGS::DIRECTORY))
				return ACCESS_RESULT::ERR_TYPE_DIRECTORY;
			else if (it.n->is_readonly && (flags & ACCESS_FLAGS::WRITE))
				return ACCESS_RESULT::ERR_READONLY;
			else
				return ACCESS_RESULT::SUCCESS;
		}
	}
	if (flags & (ACCESS_FLAGS::CREATE_RECURSIVE)) {
		pointer<file_inode> fp = new file_inode(0, 0, 0, 0, 0);
		fp->filename = filename;
		if (flags & ACCESS_FLAGS::DIRECTORY)
			fp->attributes |= FILE_ATTRIBS::DIRECTORY;
		fp->move(directory);
		return ACCESS_RESULT::SUCCESS;
	}
	return ACCESS_RESULT::ERR_NOT_FOUND;
}
ACCESS_RESULT file_access_rel(const file_t& directory, const path& relative_path, int flags) {
	file_t file(directory);

	int intermediate_flags = ACCESS_FLAGS::DIRECTORY | ACCESS_FLAGS::READ;
	if ((flags & ACCESS_FLAGS::CREATE_RECURSIVE) == ACCESS_FLAGS::CREATE_RECURSIVE)
		intermediate_flags |= ACCESS_FLAGS::CREATE_IF_MISSING;

	for (std::size_t i = 0; i < relative_path.fragments.size(); i++) {
		rostring frag = relative_path.fragments[i];
		if (!file)
			return ACCESS_RESULT::ERR_PATH_NOT_FOUND;
		if (!frag.size() && i != relative_path.fragments.size() - 1) {
			kassertf(DEBUG_ONLY, COMMENT, 0, "Empty path fragment (in path %s).",
					 concat(relative_path.fragments).c_str());
			continue;
		}
		if (frag == "."_RO)
			continue;
		if (frag == ".."_RO) {
			file = file_t(file.n->parent);
			continue;
		}
		if (i == relative_path.fragments.size() - 1)
			intermediate_flags = flags;
		ACCESS_RESULT result = file_access(file, frag, intermediate_flags);
		if (result != ACCESS_RESULT::SUCCESS) {
			if (i != relative_path.fragments.size() - 1) {
				if (result == ACCESS_RESULT::ERR_NOT_FOUND)
					return ACCESS_RESULT::ERR_PATH_NOT_FOUND;
				if (result == ACCESS_RESULT::ERR_TYPE_FILE)
					return ACCESS_RESULT::ERR_PATH_TYPE;
			}
			return result;
		}
		file = file_open_nocheck(file, frag);
	}
	return ACCESS_RESULT::SUCCESS;
}
ACCESS_RESULT file_access(const path& path, int flags) {
	if (path.fragments.size() && path.fragments[0] == ""_RO)
		return file_access_rel(file_t(globals->fs->root), path, flags);
	else if (path.fragments.size() && path.fragments[0] == "."_RO)
		return file_access_rel(file_t(globals->fs->current), path, flags);
	else
		return file_access_rel(file_t(globals->fs->current), path, flags);
	//kassertf(DEBUG_VERBOSE, COMMENT, 0, "Ambiguous absolute/relative path %s.", concat(path.fragments).c_str());
}

file_t file_open(const file_t& directory, const rostring& filename, int flags) {
	if (file_access(directory, filename, flags) != ACCESS_RESULT::SUCCESS)
		return {};
	return file_open_nocheck(directory, filename);
}
file_t file_open_rel(const file_t& directory, const path& relative_path, int flags) {
	if (file_access_rel(directory, relative_path, flags) != ACCESS_RESULT::SUCCESS)
		return {};
	file_t file(directory);

	int intermediate_flags = ACCESS_FLAGS::DIRECTORY | ACCESS_FLAGS::READ;
	if ((flags & ACCESS_FLAGS::CREATE_RECURSIVE) == ACCESS_FLAGS::CREATE_RECURSIVE)
		intermediate_flags |= ACCESS_FLAGS::CREATE_IF_MISSING;

	for (std::size_t i = 0; i < relative_path.fragments.size(); i++) {
		rostring frag = relative_path.fragments[i];
		if (!file)
			break;
		if (!frag.size() && i != relative_path.fragments.size() - 1) {
			kassertf(DEBUG_ONLY, COMMENT, 0, "Empty path fragment (in path %s).",
					 concat(relative_path.fragments).c_str());
			continue;
		}
		if (frag == "."_RO)
			continue;
		if (frag == ".."_RO) {
			file = file_t(file.n->parent);
			continue;
		}
		if (i == relative_path.fragments.size() - 1)
			intermediate_flags = flags;
		file = file_open(file, frag, intermediate_flags);
	}
	return file;
}
file_t file_open(const path& path, int flags) {
	if (file_access(path, flags) != ACCESS_RESULT::SUCCESS)
		return {};
	if (path.fragments.size() && path.fragments[0] == ""_RO)
		return file_open_rel(file_t(globals->fs->root), path, flags);
	else if (path.fragments.size() && path.fragments[0] == "."_RO)
		return file_open_rel(file_t(globals->fs->current), path, flags);
	else
		return file_open_rel(file_t(globals->fs->current), path, flags);
	//kassertf(DEBUG_VERBOSE, COMMENT, 0, "Ambiguous absolute/relative path %s.", concat(path.fragments).c_str());
}

ACCESS_RESULT file_move(const file_t& file, const file_t& directory, const rostring& filename, int flags) {
	ACCESS_RESULT a = file_access(directory, filename, flags);
	if (a == ACCESS_RESULT::ERR_NOT_FOUND) {
		file.n->filename = filename;
		file.n->move(directory);
		return ACCESS_RESULT::SUCCESS;
	} else if (a != ACCESS_RESULT::SUCCESS)
		return a;
	file_t dst_file = file_open(directory, filename, flags);
	if (dst_file.n->is_directory)
		return file_move(file, dst_file, file.n->filename, flags | ACCESS_FLAGS::FILE);
	else if (file.n->is_directory)
		return ACCESS_RESULT::ERR_TYPE_FILE;
	else {
		file_delete(dst_file);
		file.n->move(directory);
		return ACCESS_RESULT::SUCCESS;
	}
}
ACCESS_RESULT file_move(const path& src, const path& dst, int flags) {
	ACCESS_RESULT a = file_access(src, flags);
	if (a != ACCESS_RESULT::SUCCESS)
		return a;
	path dir = dst.parent();
	rostring f = dst.fragments.back();
	a = file_access(dir, flags);
	if (a != ACCESS_RESULT::SUCCESS)
		return a;
	return file_move(file_open(src, flags), file_open(dir, flags), f, flags);
}

ACCESS_RESULT file_delete(file_t& file) {
	if (!file)
		return ACCESS_RESULT::ERR_NOT_FOUND;
	if (file.safe_child())
		return ACCESS_RESULT::ERR_NOT_EMPTY;
	if (file.n->references[0] > 1) // file itself is a reference
		return ACCESS_RESULT::ERR_IN_USE;

	file.n->move(nullptr);
	file.data().clear();
	file.n->write();
	file.n->close();
	delete file.n;
	file.n = nullptr;
	return ACCESS_RESULT::SUCCESS;
}
ACCESS_RESULT file_delete_rel(const file_t& directory, const path& relative_path, int flags) {
	file_t file(directory);

	int intermediate_flags = ACCESS_FLAGS::DIRECTORY | ACCESS_FLAGS::READ;
	if ((flags & ACCESS_FLAGS::CREATE_RECURSIVE) == ACCESS_FLAGS::CREATE_RECURSIVE)
		intermediate_flags |= ACCESS_FLAGS::CREATE_IF_MISSING;

	for (std::size_t i = 0; i < relative_path.fragments.size(); i++) {
		rostring frag = relative_path.fragments[i];
		if (!file)
			return ACCESS_RESULT::ERR_PATH_NOT_FOUND;
		if (!frag.size() && i != relative_path.fragments.size() - 1) {
			kassertf(DEBUG_ONLY, COMMENT, 0, "Empty path fragment (in path %s).",
					 concat(relative_path.fragments).c_str());
			continue;
		}
		if (frag == "."_RO)
			continue;
		if (frag == ".."_RO) {
			file = file_t(file.n->parent);
			continue;
		}
		if (i == relative_path.fragments.size() - 1)
			intermediate_flags = flags;
		ACCESS_RESULT result = file_access(file, frag, intermediate_flags);
		if (result != ACCESS_RESULT::SUCCESS) {
			if (i != relative_path.fragments.size() - 1) {
				if (result == ACCESS_RESULT::ERR_NOT_FOUND)
					return ACCESS_RESULT::ERR_PATH_NOT_FOUND;
				if (result == ACCESS_RESULT::ERR_TYPE_FILE)
					return ACCESS_RESULT::ERR_PATH_TYPE;
			}
			return result;
		}
		file = file_open_nocheck(file, frag);
	}
	file_delete(file);
	return ACCESS_RESULT::SUCCESS;
}
ACCESS_RESULT file_delete(const path& path, int flags) {
	if (path.fragments.size() && path.fragments[0] == ""_RO)
		return file_delete_rel(file_t(globals->fs->root), path, flags);
	else if (path.fragments.size() && path.fragments[0] == "."_RO)
		return file_delete_rel(file_t(globals->fs->current), path, flags);
	else
		return file_delete_rel(file_t(globals->fs->current), path, flags);
	//kassertf(DEBUG_VERBOSE, COMMENT, 0, "Ambiguous absolute/relative path %s.", concat(path.fragments).c_str());
}