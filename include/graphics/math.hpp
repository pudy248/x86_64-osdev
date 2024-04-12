#pragma once
#include <cstdint>

#define sign(a) (a < 0 ? -1 : 1)

uint8_t rand(void);

float sqrtf(float x);
float rsqrtf(float number);

void cossin_cordic(double beta, int n, double* c, double* s);

//double fabs(double n);
double fmod(double n, double m);
double sin(double theta);
double cos(double theta);
char isnan(double f);

//float fabsf(float n);
float fmodf(float n, float m);
float sinf(float theta);
float cosf(float theta);
void cossinf(float theta, float* c, float* s);
float lerpf(float a, float b, float f);
char isnanf(float f);
