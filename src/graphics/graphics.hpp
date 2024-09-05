#pragma once
#include <cstdint>

struct RenderPipeline;

void raster_point(RenderPipeline* pipeline, uint32_t v);
void raster_line(RenderPipeline* pipeline, uint32_t v1, uint32_t v2);
void raster_triangle(RenderPipeline* pipeline, uint32_t tri);
