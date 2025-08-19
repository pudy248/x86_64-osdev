#include <cstdint>
#include <graphics/graphics.hpp>
#include <graphics/math.hpp>
#include <graphics/pipeline.hpp>
#include <graphics/vectypes.hpp>
#include <kstddef.hpp>

static char clip(Vec4 p) {
	return abs(p.x) > 1 || abs(p.y) > 1 || p.w < 0;
}

static Vec4 screenspace(RenderPipeline* pipeline, Vec4 p) {
	p.x = (p.x * 0.5f + 0.5f) * (float)pipeline->display_w;
	p.y = (p.y * -0.5f + 0.5f) * (float)pipeline->display_h;
	return p;
}

static void create_frag(RenderPipeline* pipeline, int x, int y, Vec4 color, float depth) {
	uint32_t idx = pipeline->display_w * (uint32_t)y + (uint32_t)x;
	//if (pipeline->fragBuffer[idx].depth != 0 && pipeline->fragBuffer[idx].depth < depth) return;
	//pipeline->fragBuffer[idx] = (Fragment){depth};
	pipeline->fragTexture[idx] = rgba2u32(color);
	//printf("%i:%i\n", idx, pipeline->fragTexture[idx]);
}

void raster_point(RenderPipeline* pipeline, uint32_t p) {
	ProjectedVertex& v = pipeline->projVertBuffer[p];
	//if (clip(v.spos))
	//	return;
	Vec4 ss = screenspace(pipeline, v.spos);
	create_frag(pipeline, (int)ss.x, (int)ss.y, v.color, ss.w);
}

void raster_line(RenderPipeline* pipeline, uint32_t p1, uint32_t p2) {
	raster_point(pipeline, p1);
	raster_point(pipeline, p2);

	ProjectedVertex v1 = pipeline->projVertBuffer[p1];
	ProjectedVertex v2 = pipeline->projVertBuffer[p2];
	if (clip(v1.spos) || clip(v2.spos))
		return;

	if (v1.spos.y < v2.spos.y) {
		ProjectedVertex tmp = v1;
		v1 = v2;
		v2 = tmp;
	}

	Vec4 ss1 = screenspace(pipeline, v1.spos);
	Vec4 ss2 = screenspace(pipeline, v2.spos);

	float yp = 0;
	float dy12 = ss2.y - ss1.y;
	float mi12 = (ss2.x - ss1.x) / dy12;
	float bi12 = ss1.x - ss1.y * mi12;

	for (int y = (int)ss1.y; y < ss2.y; y++) {
		int x1 = max(ss1.y, y) * mi12 + bi12;
		int x2 = min(ss2.y, y + 1) * mi12 + bi12;
		if (x1 == x2)
			x2++;
		int xl = min(x1, x2);
		int xr = max(x1, x2);
		for (int x = xl; x < xr; x++) {
			if (x < 0 || x > (int)pipeline->display_w)
				continue;
			create_frag(pipeline, x, y, v1.color, v1.wpos.w);
			//float xf = (float)(x - x1) / (float)(x2 - x1);
			//Vec4 col = lerp4(color1, color2, xf);
			//create_frag(pipeline, x, (int)pos1.y, col, lerpf(pos1.w, pos2.w, xf));
		}
	}
}

static void scanline(RenderPipeline* pipeline, int x1, int x2, int y, Vec4 color1, Vec4 color2, float depth1,
					 float depth2) {
	if (x2 < x1) {
		int tmp1 = x1;
		x1 = x2;
		x2 = tmp1;
		Vec4 tmp2 = color1;
		color1 = color2;
		color2 = tmp2;
		float tmp3 = depth1;
		depth1 = depth2;
		depth2 = tmp3;
	}

	for (int x = x1; x <= x2; x++) {
		float xf = (float)(x - x1) / (float)(x2 - x1);
		Vec4 col = lerp4(color1, color2, xf);
		create_frag(pipeline, x, y, col, lerpf(depth1, depth2, xf));
	}
}

void raster_triangle(RenderPipeline* pipeline, uint32_t tri) {
	uint32_t p1 = pipeline->triangleBuffer[3 * tri];
	uint32_t p3 = pipeline->triangleBuffer[3 * tri + 1];
	uint32_t p2 = pipeline->triangleBuffer[3 * tri + 2];
	raster_point(pipeline, p1);
	raster_point(pipeline, p2);
	raster_point(pipeline, p3);
	//raster_line(pipeline, p1, p2);
	//raster_line(pipeline, p1, p3);
	//raster_line(pipeline, p2, p3);
	return;

	ProjectedVertex v1 = pipeline->projVertBuffer[p1];
	ProjectedVertex v2 = pipeline->projVertBuffer[p2];
	ProjectedVertex v3 = pipeline->projVertBuffer[p3];
	if (clip(v1.spos) || clip(v2.spos) || clip(v3.spos))
		return;

	if (v1.spos.y < v2.spos.y) {
		ProjectedVertex tmp = v1;
		v1 = v2;
		v2 = tmp;
	}
	if (v1.spos.y < v3.spos.y) {
		ProjectedVertex tmp = v1;
		v1 = v3;
		v3 = tmp;
	}
	if (v2.spos.y < v3.spos.y) {
		ProjectedVertex tmp = v2;
		v2 = v3;
		v3 = tmp;
	}

	Vec4 ss1 = screenspace(pipeline, v1.spos);
	Vec4 ss2 = screenspace(pipeline, v2.spos);
	Vec4 ss3 = screenspace(pipeline, v3.spos);

	float yp = 0;
	float dy12 = ss2.y - ss1.y;
	float dy13 = ss3.y - ss1.y;
	float dy23 = ss3.y - ss2.y;

	for (; yp < dy12; yp++) {
		float yf12 = min(1, yp / dy12);
		float yf13 = min(1, yp / dy13);

		Vec4 pos1 = lerp4(ss1, ss2, yf12);
		Vec4 pos2 = lerp4(ss1, ss3, yf13);
		Vec4 color1 = lerp4(v1.color, v2.color, yf12);
		Vec4 color2 = lerp4(v1.color, v3.color, yf13);
		scanline(pipeline, (int)pos1.x, (int)pos2.x, (int)pos1.y, color1, color2, pos1.w, pos2.w);
	}

	for (yp = dy12; yp < dy12 + dy23; yp++) {
		float yf23 = min(1, (yp - dy12) / dy23);
		float yf13 = min(1, yp / dy13);

		Vec4 pos1 = lerp4(ss2, ss3, yf23);
		Vec4 pos2 = lerp4(ss1, ss3, yf13);
		Vec4 color1 = lerp4(v2.color, v3.color, yf23);
		Vec4 color2 = lerp4(v1.color, v3.color, yf13);
		scanline(pipeline, (int)pos1.x, (int)pos2.x, (int)pos1.y, color1, color2, pos1.w, pos2.w);
	}
}

/*
void tri2(Vec2 p1, Vec2 p2, Vec2 p3, Vec3 color) {
    float dy12 = p2.y - p1.y;
    float dy13 = p3.y - p1.y;
    float dy23 = p3.y - p2.y;
    //x = my + b
	float mi12 = (p2.x - p1.x) / dy12;
	float mi13 = (p3.x - p1.x) / dy13;
	float mi23 = (p3.x - p2.x) / dy23;
    float bi12 = p1.x - p1.y * mi12;
    float bi13 = p1.x - p1.y * mi13;
    float bi23 = p2.x - p2.y * mi23;
    
    for (int y = (int)p1.y + 1; (float)y < p2.y; y++) {
        float x12 = (float)y * mi12 + bi12;
        float x13 = (float)y * mi13 + bi13;
        scanline((int)x12, (int)x13, y, color, 0);
    }
    float x13mid = p2.y * mi13 + bi13;
    scanline((int)x13mid, (int)p2.x, (int)p2.y, color, 0);
    for (int y = (int)p2.y + 1; (float)y < p3.y; y++) {
        float x23 = (float)y * mi23 + bi23;
        float x13 = (float)y * mi13 + bi13;
        scanline((int)x23, (int)x13, y, color, 0);
    }
    #endif
    #endif
}
*/
