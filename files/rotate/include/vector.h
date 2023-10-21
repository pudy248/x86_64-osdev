#pragma once

typedef struct Vec2 {
    float x;
    float y;
} Vec2;

typedef struct Vec3 {
    float x;
    float y;
    float z;
} Vec3;

Vec2 add2(Vec2 a, Vec2 b);
Vec3 add3(Vec3 a, Vec3 b);
Vec2 sub2(Vec2 a, Vec2 b);
Vec3 sub3(Vec3 a, Vec3 b);
Vec2 mul2(Vec2 a, float b);
Vec3 mul3(Vec3 a, float b);

float dot(Vec3 a, Vec3 b);
Vec3 cross(Vec3 a, Vec3 b);
Vec3 normalize(Vec3 v);

Vec3 rotateXsc(Vec3 v, float s, float c);
Vec3 rotateYsc(Vec3 v, float s, float c);
Vec3 rotateZsc(Vec3 v, float s, float c);

Vec2 project(Vec3 v);
Vec2 pixelSpace(Vec2 screenSpace, int w, int h);
