#pragma once
#include "kstddef.hpp"
#include <config.hpp>
#include <cstdint>
#include <kassert.hpp>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>

constexpr static bool HEAP_MERGE_FREE_BLOCKS = true;
constexpr static bool HEAP_VERBOSE_LISTS = false;
//#define HEAP_ALLOC_PROTECTOR

template <typename T>
class heap_allocator;
template <typename T>
class allocator_traits<heap_allocator<T>> {
public:
	using ptr_t = T*;
};
template <typename T>
class heap_allocator : public default_allocator<T> {
private:
	struct heap_blk {
		uint64_t data;
		uint64_t blk_size;
	};
	struct heap_meta_head {
		uint64_t size;
		uint64_t alignment_offset;
#ifdef HEAP_ALLOC_PROTECTOR
		uint64_t protector;
#endif
	};
	struct heap_meta_tail {
#ifdef HEAP_ALLOC_PROTECTOR
		uint64_t protector;
#endif
		uint64_t flags;
	};
	using blk_ptr = pointer<heap_blk, reinterpret, nonnull>;
	using head_ptr = pointer<heap_meta_head, reinterpret, nonnull>;
	using tail_ptr = pointer<heap_meta_tail, reinterpret, nonnull>;

	static constexpr uint64_t protector_head_magic = 0xF0F1F2F3F4F5F6F7ULL;
	static constexpr uint64_t protector_tail_magic = 0x08090A0B0C0D0E0FULL;

	static inline blk_ptr heap_next(blk_ptr blk) { return blk_ptr(blk->data + blk->blk_size - sizeof(heap_blk)); }
	static inline uint64_t heap_alloc_size(uint64_t requested_size) {
		return (requested_size + sizeof(heap_meta_head) + sizeof(heap_meta_tail) + (sizeof(heap_blk) - 1)) & ~0xFLLU;
	}

public:
	using ptr_t = allocator_traits<heap_allocator>::ptr_t;
	ptr_t begin;
	ptr_t end;
	uint64_t used;

	heap_allocator(ptr_t begin, ptr_t end) : begin(begin), end(end), used(0) {
		blk_ptr begin_ptr = begin;
		blk_ptr end_ptr = end;
		begin_ptr->blk_size = (uint64_t)end_ptr - (uint64_t)begin_ptr - sizeof(heap_blk);
		begin_ptr->data = (uint64_t)&begin_ptr[1];
		heap_next(begin_ptr)->data = 0;
		heap_next(begin_ptr)->blk_size = 0;
	}
	heap_allocator(ptr_t begin, uint64_t size) : heap_allocator(begin, ptr_offset(begin, size)) {}

	bool contains(ptr_t ptr) { return ptr >= begin && ptr < end; }
	uint64_t mem_used() { return used; }

	ptr_t alloc(uint64_t size, uint16_t alignment = 0x10) {
		alignment = max(alignment, sizeof(heap_blk));
		uint64_t adj_size = heap_alloc_size(size);
		kassert(
			ALWAYS_ACTIVE, TASK_EXCEPTION, (uint64_t)end - (uint64_t)begin - used > adj_size, "Malloc out of space!");
		if constexpr (HEAP_VERBOSE_LISTS) {
			errorf<64>("\nMALLOC HEAP DUMP: REQUESTED %08p BYTES\n", adj_size);
			blk_ptr dbg_block = begin;
			while (dbg_block->data) {
				errorf<64>("%08p [%08p bytes]\n", dbg_block->data, dbg_block->blk_size);
				dbg_block = heap_next(dbg_block);
			}
		}
		blk_ptr target_block = begin;
		uint64_t aligned_addr;
		uint64_t align_offset;
		while (true) {
			uint64_t block_ptr = target_block->data;
			aligned_addr = align_to(block_ptr + sizeof(heap_meta_head), alignment) - sizeof(heap_meta_head);

			uint64_t blk_size_aligned = target_block->blk_size - (aligned_addr - block_ptr);
			if (blk_size_aligned >= adj_size) {
				align_offset = (aligned_addr - block_ptr);
				break;
			}
			if (!target_block->data) {
				errorf<64>("\nMALLOC HEAP DUMP: REQUESTED %08p BYTES\n", adj_size);
				//target_block = begin;
				//while (target_block->data) {
				//	errorf<64>("%08p [%08p bytes]\n", target_block->data, target_block->blk_size);
				//	target_block = heap_next(target_block);
				//}
				kassert_trace(UNMASKABLE, TASK_EXCEPTION);
			}
			target_block = heap_next(target_block);
		}
		uint64_t alloc_size = adj_size + align_offset;
		uint64_t blk_size = adj_size - sizeof(heap_meta_head) - sizeof(heap_meta_tail);

		if (alloc_size - target_block->blk_size < sizeof(heap_blk)) {
			*target_block = *heap_next(target_block);
		} else {
			target_block->blk_size -= alloc_size;
			target_block->data += alloc_size;
		}

		head_ptr head = head_ptr(aligned_addr);
		tail_ptr tail = tail_ptr((aligned_addr + sizeof(heap_meta_head) + blk_size));
		head->size = blk_size;
		head->alignment_offset = align_offset;
		tail->flags = 0;

#ifdef HEAP_ALLOC_PROTECTOR
		head->protector = protector_head_magic;
		tail->protector = protector_tail_magic;
#endif

		used += alloc_size;
		return (ptr_t)(&head[1]);
	}

	void dealloc(ptr_t ptr) {
		if (!ptr)
			return;
		kassert(ALWAYS_ACTIVE, ERROR, (uint64_t)ptr >= (uint64_t)begin && (uint64_t)ptr <= (uint64_t)end,
			"Tried to free pointer out of range of heap.");
		if constexpr (HEAP_VERBOSE_LISTS) {
			errorf<64>("\nFREE HEAP DUMP: PTR %08p\n", ptr);
			blk_ptr dbg_block = begin;
			while (dbg_block->data) {
				errorf<64>("%08p [%08p bytes]\n", dbg_block->data, dbg_block->blk_size);
				dbg_block = heap_next(dbg_block);
			}
		}
		head_ptr head = (head_ptr)ptr_offset(ptr, -sizeof(heap_meta_head));
		tail_ptr tail = (tail_ptr)ptr_offset(ptr, head->size);
		kassert(ALWAYS_ACTIVE, ERROR, !tail->flags, "Double free in heap.");
		tail->flags = 1;
#ifdef HEAP_ALLOC_PROTECTOR
		if (head->protector != protector_head_magic) {
			errorf<256>("FREE %08p: Heap alloc protector bytes corrupted! [%08X] found at head, expected [%08X].\n",
				ptr, head->protector, protector_head_magic);
			kassert_trace(DEBUG_ONLY, ERROR);
		}
		if (tail->protector != protector_tail_magic) {
			errorf<256>("FREE %08p: Heap alloc protector bytes corrupted! [%08X] found at tail, expected [%08X].\n",
				ptr, tail->protector, protector_tail_magic);
			kassert(false, "");
		}
		if (head->protector != protector_head_magic || tail->protector != protector_tail_magic)
			inf_wait();
#endif
		uint64_t base_addr = (uint64_t)ptr_offset(head, head->alignment_offset);
		uint64_t end_addr = (uint64_t)ptr_offset(tail, sizeof(heap_meta_tail));
		if constexpr (HEAP_MERGE_FREE_BLOCKS) {
			heap_blk* heap_iter = (blk_ptr)begin;
			while (heap_iter->blk_size) {
				uint64_t blk_base = heap_iter->data;
				uint64_t blk_end = blk_base + heap_iter->blk_size;
				if (blk_end == base_addr) { //Merge backwards
					*heap_iter = *heap_next(heap_iter);
					base_addr = blk_base;
					continue;
				}
				if (blk_base == end_addr) { //Merge forwards
					*heap_iter = *heap_next(heap_iter);
					end_addr = blk_end;
					continue;
				}
				heap_iter = heap_next(heap_iter);
			}
		}
		heap_blk orig = *(blk_ptr)begin;
		((blk_ptr)begin)->data = base_addr;
		((blk_ptr)begin)->blk_size = end_addr - base_addr, *heap_next((blk_ptr)begin) = orig;

		used -= head->alignment_offset + sizeof(heap_meta_head) + head->size + sizeof(heap_meta_tail);
	}

	void destroy() {};
};
