#include <kcstring.hpp>

void strcpy(cstr_t __restrict dest, const cstr_t __restrict source) {
	cstr_t it = source;
	while (*it != 0) {
		*dest = *it;
		dest = dest + 1;
		++it;
	}
	*dest = 0;
}
