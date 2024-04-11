#pragma once
#include <cstdint>
#include <graphics/vectypes.hpp>

Vec3 rgb2hsl(Vec3 rgb);
Vec3 hsl2rgb(Vec3 hsl);
uint32_t rgba2u32(Vec4 c);
