#pragma once
#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <stl/allocator.hpp>

#define HEAP_MERGE_FREE_BLOCKS
//#define HEAP_ALLOC_PROTECTOR
//#define HEAP_VERBOSE_LISTS

class heap_allocator;
template <> class allocator_traits<heap_allocator> {
public:
	using ptr_t = void*;
};
class heap_allocator : public default_allocator {
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

	static constexpr uint64_t protector_head_magic = 0xF0F1F2F3F4F5F6F7LL;
	static constexpr uint64_t protector_tail_magic = 0x08090A0B0C0D0E0FLL;

	static inline heap_blk* heap_next(heap_blk* blk) {
		return (heap_blk*)(blk->data + blk->blk_size - sizeof(heap_blk));
	}
	static inline uint64_t heap_alloc_size(uint64_t requested_size) {
		return (requested_size + sizeof(heap_meta_head) + sizeof(heap_meta_tail) + (sizeof(heap_blk) - 1)) & ~0xFLLU;
	}

public:
	using ptr_t = allocator_traits<heap_allocator>::ptr_t;
	ptr_t begin;
	ptr_t end;
	uint64_t used;

	heap_allocator(ptr_t begin, ptr_t end)
		: begin(begin)
		, end(end)
		, used(0) {
		((heap_blk*)begin)->blk_size = (uint64_t)end - (uint64_t)begin - sizeof(heap_blk);
		((heap_blk*)begin)->data = (uint64_t) & ((heap_blk*)begin)[1];
		heap_next((heap_blk*)begin)->data = 0;
		heap_next((heap_blk*)begin)->blk_size = 0;
	}
	heap_allocator(ptr_t begin, uint64_t size)
		: heap_allocator(begin, (ptr_t)((uint64_t)begin + size)) {
	}

	bool contains(ptr_t ptr) {
		return ptr >= begin && ptr < end;
	}
	uint64_t mem_used() {
		return used;
	}

	ptr_t alloc(uint64_t size, uint16_t alignment = 0x10) {
		alignment = min(alignment, sizeof(heap_blk));
		uint64_t adj_size = heap_alloc_size(size);
#ifdef HEAP_VERBOSE_LISTS
		qprintf<64>("\nMALLOC HEAP DUMP: REQUESTED %08p BYTES\n", count);
		heap_blk* dbg_block = (heap_blk*)begin;
		while (dbg_block->data) {
			qprintf<64>("%08p [%08p bytes]\n", dbg_block->data, dbg_block->blk_size);
			dbg_block = heap_next(dbg_block);
		}
#endif
		heap_blk* target_block = (heap_blk*)begin;
		uint64_t aligned_addr;
		uint64_t align_offset;
		while (true) {
			uint64_t block_ptr = (uint64_t)target_block->data;
			aligned_addr = align_to(block_ptr + sizeof(heap_meta_head), alignment) - sizeof(heap_meta_head);

			uint64_t blk_size_aligned = target_block->blk_size - (aligned_addr - block_ptr);
			if (blk_size_aligned >= adj_size) {
				align_offset = (aligned_addr - block_ptr);
				break;
			}
			if (!target_block->data) {
				qprintf<32>("\nMALLOC FAIL! HEAP DUMP:\n");
				target_block = (heap_blk*)begin;
				while (target_block->data) {
					qprintf<64>("%08p [%08p bytes]\n", target_block->data, target_block->blk_size);
					target_block = heap_next(target_block);
				}
				kassert(false, "");
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

		heap_meta_head* head_ptr = (heap_meta_head*)aligned_addr;
		heap_meta_tail* tail_ptr = (heap_meta_tail*)(aligned_addr + sizeof(heap_meta_head) + blk_size);
		head_ptr->size = blk_size;
		head_ptr->alignment_offset = align_offset;
		tail_ptr->flags = 0;

#ifdef HEAP_ALLOC_PROTECTOR
		head_ptr->protector = protector_head_magic;
		tail_ptr->protector = protector_tail_magic;
#endif

		used += alloc_size;
		return (ptr_t)(head_ptr + 1);
	}

	void dealloc(ptr_t ptr) {
		if (!ptr)
			return;
		kassert((uint64_t)ptr >= (uint64_t)begin && (uint64_t)ptr <= (uint64_t)end,
				"Tried to free pointer out of range of heap.");
#ifdef HEAP_VERBOSE_LISTS
		qprintf<64>("\nFREE HEAP DUMP: PTR %08p\n", ptr);
		heap_blk* dbg_block = (heap_blk*)begin;
		while (dbg_block->data) {
			qprintf<64>("%08p [%08p bytes]\n", dbg_block->data, dbg_block->blk_size);
			dbg_block = heap_next(dbg_block);
		}
#endif
		heap_meta_head* head_ptr = (heap_meta_head*)((uint64_t)ptr - sizeof(heap_meta_head));
		heap_meta_tail* tail_ptr = (heap_meta_tail*)((uint64_t)ptr + head_ptr->size);
		kassert(!tail_ptr->flags, "Double free in heap.");
		tail_ptr->flags = 1;
#ifdef HEAP_ALLOC_PROTECTOR
		if (head_ptr->protector != protector_head_magic) {
			qprintf<256>("FREE %08p: Heap alloc protector bytes corrupted! [%08X] found at head, expected [%08X].\n",
						 ptr, head_ptr->protector, protector_head_magic);
			kassert(false, "");
		}
		if (tail_ptr->protector != protector_tail_magic) {
			qprintf<256>("FREE %08p: Heap alloc protector bytes corrupted! [%08X] found at tail, expected [%08X].\n",
						 ptr, tail_ptr->protector, protector_tail_magic);
			kassert(false, "");
		}
		if (head_ptr->protector != protector_head_magic || tail_ptr->protector != protector_tail_magic)
			inf_wait();
#endif
		uint64_t base_addr = (uint64_t)head_ptr - head_ptr->alignment_offset;
		uint64_t end_addr = (uint64_t)tail_ptr + sizeof(heap_meta_tail);
#ifdef HEAP_MERGE_FREE_BLOCKS
		heap_blk* heap_iter = (heap_blk*)begin;
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
#endif
		heap_blk orig = *(heap_blk*)begin;
		((heap_blk*)begin)->data = base_addr;
		((heap_blk*)begin)->blk_size = end_addr - base_addr, *heap_next((heap_blk*)begin) = orig;

		used -= head_ptr->alignment_offset + sizeof(heap_meta_head) + head_ptr->size + sizeof(heap_meta_tail);
	}

	void destroy(){};
};
