#pragma once
#include <cstdint>
#include <graphics/vectypes.h>
#include <graphics/pipeline.h>

void raster_point(RenderPipeline* pipeline, uint32_t v);
void raster_line(RenderPipeline* pipeline, uint32_t v1, uint32_t v2);
void raster_triangle(RenderPipeline* pipeline, uint32_t tri);
