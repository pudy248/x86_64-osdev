#pragma once
#include <typedefs.h>
#include <vector.h>

//#define singlebuffer
//#define pointcloud
#define wireframe

int rotationX;
int rotationY;
int rotationZ;

void point2(Vec2 p1, Vec3 color);
void line2(Vec2 p1, Vec2 p2, Vec3 color);
void tri2(Vec2 p1, Vec2 p2, Vec2 p3, Vec3 color);

void point3(Vec3 v1, Vec3 color);
void line3(Vec3 v1, Vec3 v2, Vec3 color);
void tri3(Vec3 v1, Vec3 v2, Vec3 v3, Vec3 color);