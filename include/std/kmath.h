#pragma once
#include <kstddefs.h>

#define abs(a) (a < 0 ? -a : a)
#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

uint8_t krand(void);
