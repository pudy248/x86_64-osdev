#include <cstdint>
#include <sys/paging.hpp>

//static PML4E* pml4 = (PML4E*)0x70000;
//static PDPTE* pdpts = (PDPTE*)0x71000;
static PDTE* directories = (PDTE*)0x72000;

void set_page_flags(void* addr, uint8_t flags) {
	uintptr_t idx = (uintptr_t)addr >> 21;
	directories[idx] |= flags;
}
void unset_page_flags(void* addr, uint8_t flags) {
	uintptr_t idx = (uintptr_t)addr >> 21;
	directories[idx] &= ~(uint64_t)flags;
}
