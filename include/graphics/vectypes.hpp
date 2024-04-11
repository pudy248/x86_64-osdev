#pragma once

struct Vec2 {
    float x;
    float y;
};
struct Vec3 {
    float x;
    float y;
    float z;
};
struct Vec4 {
    float x;
    float y;
    float z;
    float w;
};

struct Mat3x3 {
    float m[9];
};
struct Mat4x3 {
    float m[12];
};
struct Mat4x4 {
    float m[16];
};

Vec3 vtrunc43(Vec4 a);
Vec4 vpad34(Vec3 a, float w);

Vec2 add2(Vec2 a, Vec2 b);
Vec3 add3(Vec3 a, Vec3 b);
Vec4 add4(Vec4 a, Vec4 b);

Vec2 sub2(Vec2 a, Vec2 b);
Vec3 sub3(Vec3 a, Vec3 b);
Vec4 sub4(Vec4 a, Vec4 b);

Vec2 mul2(Vec2 a, float b);
Vec3 mul3(Vec3 a, float b);
Vec4 mul4(Vec4 a, float b);

float dot(Vec3 a, Vec3 b);
Vec3 cross(Vec3 a, Vec3 b);
Vec2 norm2(Vec2 v);
Vec3 norm3(Vec3 v);
Vec4 norm4(Vec4 v);

Vec3 pivotX(Vec3 v, float s, float c);
Vec3 pivotY(Vec3 v, float s, float c);
Vec3 pivotZ(Vec3 v, float s, float c);

Vec2 lerp2(Vec2 a, Vec2 b, float f);
Vec3 lerp3(Vec3 a, Vec3 b, float f);
Vec4 lerp4(Vec4 a, Vec4 b, float f);

Mat3x3 smul3x3(Mat3x3 a, float b);
Mat4x3 smul4x3(Mat4x3 a, float b);
Mat4x4 smul4x4(Mat4x4 a, float b);

Vec3 vmul3x3(Mat3x3 a, Vec3 b);
Vec3 vmul4x3(Mat4x3 a, Vec4 b);
Vec4 vmul4x4(Mat4x4 a, Vec4 b);

Mat3x3 mmul3333(Mat3x3 a, Mat3x3 b);
Mat4x3 mmul3343(Mat3x3 a, Mat4x3 b);
Mat4x3 mmul4344(Mat4x3 a, Mat4x4 b);
Mat4x4 mmul4444(Mat4x4 a, Mat4x4 b);

Mat4x3 mpad3343(Mat3x3 a);
Mat4x4 mpad3344(Mat3x3 a);
Mat4x4 mpad4344(Mat4x3 a);
