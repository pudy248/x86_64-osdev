#pragma once
#include <graphics/vectypes.hpp>

Mat4x4 identity(void);
Mat4x4 translate(float dx, float dy, float dz);
Mat4x4 rotate(float tx, float ty, float tz);
Mat4x4 scale(float f);
Mat4x4 rebase(Vec3 up, Vec3 forward, Vec3 pos);
Mat4x4 project(float nw, float nh, float n);
Vec4 vnormw(Vec4 a);
