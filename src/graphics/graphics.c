#include <math.h>
#include <vector.h>
#include <vesa.h>
#include <graphics.h>
#include <kernel.h>

void scanline(int x1, int x2, int y, Vec3 color, float depth) {
    int xl = min(x1, x2);
    int xr = max(x1, x2);
    for(int x = xl; x < xr; x++) {
        set_pixel_rgbd(x, y, color.x, color.y, color.z, depth);
    }
}

void point2(Vec2 p1, Vec3 color) {
    set_pixel_rgb(p1.x, p1.y, color.x, color.y, color.z);
}
void line2(Vec2 p1, Vec2 p2, Vec3 color)
{
    float dy12 = p2.y - p1.y;
	float mi12 = (p2.x - p1.x) / dy12;
    float bi12 = p1.x - p1.y * mi12;
    
    for (int y = (int)p1.y; y < p2.y; y++) {
        int x1 = max(p1.y, y) * mi12 + bi12;
        int x2 = min(p2.y, y + 1) * mi12 + bi12;
        if(x1 == x2) x2++;
        int xl = min(x1, x2);
        int xr = max(x1, x2);
        for(int x = xl; x < xr; x++) {
            set_pixel_rgb(x, y, color.x, color.y, color.z);
        }
    }
}
void tri2(Vec2 p1, Vec2 p2, Vec2 p3, Vec3 color) {
    if (p2.y < p1.y) { Vec2 tmp = p1; p1 = p2; p2 = tmp; }
	if (p3.y < p1.y) { Vec2 tmp = p1; p1 = p3; p3 = tmp; }
	if (p3.y < p2.y) { Vec2 tmp = p2; p2 = p3; p3 = tmp; }
    if(p2.y == p1.y) p2.y += 0.001f;
    if(p3.y == p1.y) p3.y += 0.001f;
    if(p3.y == p2.y) p3.y += 0.001f;
    #ifdef pointcloud
    set_pixel_rgb(p1.x, p1.y, color.x, color.y, color.z);
    set_pixel_rgb(p2.x, p2.y, color.x, color.y, color.z);
    set_pixel_rgb(p3.x, p3.y, color.x, color.y, color.z);
    #else
    #ifdef wireframe
	line2(p1, p2, color);
	line2(p1, p3, color);
	line2(p2, p3, color);
    #else
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
    
    for (int y = (int)p1.y + 1; y < p2.y; y++) {
        float x12 = y * mi12 + bi12;
        float x13 = y * mi13 + bi13;
        scanline(x12, x13, y, color, 0);
    }
    float x13mid = p2.y * mi13 + bi13;
    scanline(x13mid, p2.x, (int)p2.y, color, 0);
    for (int y = (int)p2.y + 1; y < p3.y; y++) {
        float x23 = y * mi23 + bi23;
        float x13 = y * mi13 + bi13;
        scanline(x23, x13, y, color, 0);
    }
    #endif
    #endif
}

void point3(Vec3 v1, Vec3 color) {
    Vec2 p1 = pixelSpace(project(v1), SCREEN_W, SCREEN_H);
    set_pixel_rgbd(p1.x, p1.y, color.x, color.y, color.z, v1.z);
}
void line3(Vec3 v1, Vec3 v2, Vec3 color) {
    float depth = (v1.z + v2.z) / 2;
    Vec2 p1 = pixelSpace(project(v1), SCREEN_W, SCREEN_H);
    Vec2 p2 = pixelSpace(project(v2), SCREEN_W, SCREEN_H);
    float dy12 = p2.y - p1.y;
	float mi12 = (p2.x - p1.x) / dy12;
    float bi12 = p1.x - p1.y * mi12;
    
    for (int y = (int)p1.y; y < p2.y; y++) {
        int x1 = max(p1.y, y) * mi12 + bi12;
        int x2 = min(p2.y, y + 1) * mi12 + bi12;
        if(x1 == x2) x2++;
        scanline(x1, x2, y, color, depth);
    }
}
void tri3(Vec3 v1, Vec3 v2, Vec3 v3, Vec3 color)
{
    float depth = (v1.z + v2.z + v3.z) / 3;
    Vec2 p1 = pixelSpace(project(v1), SCREEN_W, SCREEN_H);
    Vec2 p2 = pixelSpace(project(v2), SCREEN_W, SCREEN_H);
    Vec2 p3 = pixelSpace(project(v3), SCREEN_W, SCREEN_H);
    
	if (p2.y < p1.y) { Vec2 tmp = p1; p1 = p2; p2 = tmp; }
	if (p3.y < p1.y) { Vec2 tmp = p1; p1 = p3; p3 = tmp; }
	if (p3.y < p2.y) { Vec2 tmp = p2; p2 = p3; p3 = tmp; }
    if(p2.y == p1.y) p2.y += 0.001f;
    if(p3.y == p1.y) p3.y += 0.001f;
    if(p3.y == p2.y) p3.y += 0.001f;
    #ifdef pointcloud
    set_pixel_rgb(p1.x, p1.y, color.x, color.y, color.z);
    set_pixel_rgb(p2.x, p2.y, color.x, color.y, color.z);
    set_pixel_rgb(p3.x, p3.y, color.x, color.y, color.z);
    #else
    #ifdef wireframe
	line3(v1, v2, color);
	line3(v1, v3, color);
	line3(v2, v3, color);
    #else
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
    
    for (int y = (int)p1.y + 1; y < p2.y; y++) {
        float x12 = y * mi12 + bi12;
        float x13 = y * mi13 + bi13;
        scanline(x12, x13, y, color, depth);
    }
    float x13mid = p2.y * mi13 + bi13;
    scanline(x13mid, p2.x, (int)p2.y, color, depth);
    for (int y = (int)p2.y + 1; y < p3.y; y++) {
        float x23 = y * mi23 + bi23;
        float x13 = y * mi13 + bi13;
        scanline(x23, x13, y, color, depth);
    }
    #endif
    #endif
}
