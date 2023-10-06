#pragma once
#include <typedefs.h>
#define max(a, b) (a > b ? a : b)
#define min(a, b) (a > b ? b : a)
#define abs(a) (a < 0 ? -a : a)

uint8_t rand();
float sqrtf(float x);
float rsqrtf(float number);
double fmod(double n, double m);
double angle_shift ( double alpha, double beta );
void cossin_cordic ( double beta, int n, double *c, double *s );
float sinf(float theta);
float cosf(float theta);
