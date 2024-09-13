#include <kcstring.hpp>

void strcpy(char* __restrict dest, const char* __restrict source) {
	while (*source != 0) {
		*dest = *source;
		dest = dest + 1;
		++source;
	}
	*dest = 0;
}
