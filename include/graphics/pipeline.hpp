#pragma once
#include <cstdint>
#include <graphics/vectypes.hpp>

struct Vertex {
	Vec4 pos;
	Vec4 color;
};
struct ProjectedVertex {
	Vec4 wpos;
	Vec4 spos;
	Vec4 color;
};

struct Fragment {
	float depth;
};

typedef uint32_t* __attribute__((align_value(64))) uint32_ptr_a64;
typedef Vertex* __attribute__((align_value(64))) vertex_ptr_a64;
typedef ProjectedVertex* __attribute__((align_value(64))) proj_vertex_ptr_a64;
typedef Fragment* __attribute__((align_value(64))) fragment_ptr_a64;

void _default_vertex_shader(struct RenderPipeline* pipeline, void** params);
void _default_raster_shader(struct RenderPipeline* pipeline, void** params);
void _default_fragment_shader(struct RenderPipeline* pipeline, void** params);

struct RenderPipeline {
	uint32_t nTriangles;
	uint32_t nVertices;
	uint32_t display_w;
	uint32_t display_h;

	uint32_ptr_a64 triangleBuffer;
	vertex_ptr_a64 vertexBuffer;
	proj_vertex_ptr_a64 projVertBuffer;
	fragment_ptr_a64 fragBuffer;
	uint32_ptr_a64 fragTexture;
	uint32_ptr_a64 renderTexture;

	void (*vertexShader)(struct RenderPipeline* pipeline, void** params) = &_default_vertex_shader;
	void (*rasterShader)(struct RenderPipeline* pipeline, void** params) = &_default_raster_shader;
	void (*fragmentShader)(struct RenderPipeline* pipeline, void** params) = &_default_fragment_shader;
};

extern Mat4x4 projectionMatrix;

void pipeline_execute(RenderPipeline* pipeline, void** shaderParams);
void pipeline_flush(RenderPipeline* pipeline);
void pipeline_reset(RenderPipeline* pipeline);