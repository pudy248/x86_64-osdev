#include <kstddefs.h>
#include <kmath.h>

static uint16_t lfsr = 0xACE1u;
static uint8_t bit;
uint8_t krand()
{
    bit  = (uint8_t)(((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5) ) & 1);
    return (uint8_t)(lfsr =  (lfsr >> 1) | (uint16_t)(bit << 15));
}
