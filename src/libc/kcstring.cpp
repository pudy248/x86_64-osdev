#include <kcstring.hpp>

void strcpy(char* __restrict dest, const char* __restrict source) {
	while (*source != 0) {
		*dest = *source;
		dest = dest + 1;
		++source;
	}
	*dest = 0;
}
char streql(const char* __restrict lhs, const char* __restrict rhs) {
	int i;
	for (i = 0; lhs[i]; i++) {
		if (rhs[i] != lhs[i])
			return 0;
	}
	if (rhs[i] != lhs[i])
		return 0;
	return 1;
}
