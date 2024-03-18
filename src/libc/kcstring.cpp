#include <kstddefs.hpp>
#include <kcstring.hpp>

/*constexpr int strlen(const char* str) {
    int i = 0;
    while (str[i]) i++;
    return i;
}*/
void strcpy(char* a_restrict dest, const char* a_restrict source) {
    while (*source != 0) {
        *dest = *source;
        dest = dest + 1; ++source;
    }
    *dest = 0;
}
char streql(const char* a_restrict lhs, const char* a_restrict rhs) {
    int i;
    for(i = 0; lhs[i]; i++) {
        if(rhs[i] != lhs[i]) return 0;
    }
    if(rhs[i] != lhs[i]) return 0;
    return 1;
}
