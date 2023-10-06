#include <vector.h>
#include <math.h>

Vec2 add2(Vec2 a, Vec2 b) {
    return (Vec2) {a.x + b.x, a.y + b.y};
}
Vec3 add3(Vec3 a, Vec3 b) {
    return (Vec3) {a.x + b.x, a.y + b.y, a.z + b.z};
}
Vec2 sub2(Vec2 a, Vec2 b) {
    return (Vec2) {a.x - b.x, a.y - b.y};
}
Vec3 sub3(Vec3 a, Vec3 b) {
    return (Vec3) {a.x - b.x, a.y - b.y, a.z - b.z};
}
Vec2 mul2(Vec2 a, float b) {
    return (Vec2) {a.x * b, a.y * b};
}
Vec3 mul3(Vec3 a, float b) {
    return (Vec3) {a.x * b, a.y * b, a.z * b};
}

Vec3 cross(Vec3 a, Vec3 b) {
    return (Vec3){a.y * b.z - a.z * b.y, a.x * b.z - a.z * b.x, a.x * b.y - a.y * b.x};
}
float dot(Vec3 a, Vec3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}
Vec3 normalize(Vec3 v) {
    float len = rsqrtf(dot(v, v));
    return (Vec3){v.x * len, v.y * len, v.z * len};
}

Vec3 rotateXsc(Vec3 v, float s, float c) {
    return (Vec3){v.x, v.y * c + v.z * s, v.z * c - v.y * s};
}
Vec3 rotateYsc(Vec3 v, float s, float c) {
    return (Vec3){v.x * c + v.z * s, v.y, v.z * c - v.x * s};
}
Vec3 rotateZsc(Vec3 v, float s, float c) {
    return (Vec3){v.x * c + v.y * s, v.y * c - v.x * s, v.z};
}

float lerpf(float a, float b, float factor) {
    return a + (b - a) * factor;
}
Vec3 lerp3(Vec3 a, Vec3 b, float factor) {
    return (Vec3) {lerpf(a.x, b.x, factor), lerpf(a.y, b.y, factor), lerpf(a.z, b.z, factor)};
}

Vec2 project(Vec3 v) {
    return (Vec2) {v.x / v.z, v.y / v.z};
}
Vec2 pixelSpace(Vec2 screenSpace, int w, int h) {
    return (Vec2) { (screenSpace.x + 1) * 0.5f * h + (w - h) / 2, (-screenSpace.y + 1) * 0.5f * h };
}
