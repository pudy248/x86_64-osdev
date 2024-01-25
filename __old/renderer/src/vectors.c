#include <vectors.h>
#include <math.h>

Vec3 vtrunc43(Vec4 a) {
    return (Vec3){a.x, a.y, a.z};
}
Vec4 vpad34(Vec3 a, float w) {
    return (Vec4){a.x, a.y, a.z, w};
}

Vec2 add2(Vec2 a, Vec2 b) {
    return (Vec2) {a.x + b.x, a.y + b.y};
}
Vec3 add3(Vec3 a, Vec3 b) {
    return (Vec3) {a.x + b.x, a.y + b.y, a.z + b.z};
}
Vec4 add4(Vec4 a, Vec4 b) {
    return (Vec4) {a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w};
}

Vec2 sub2(Vec2 a, Vec2 b) {
    return (Vec2) {a.x - b.x, a.y - b.y};
}
Vec3 sub3(Vec3 a, Vec3 b) {
    return (Vec3) {a.x - b.x, a.y - b.y, a.z - b.z};
}
Vec4 sub4(Vec4 a, Vec4 b) {
    return (Vec4) {a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w};
}

Vec2 mul2(Vec2 a, float b) {
    return (Vec2) {a.x * b, a.y * b};
}
Vec3 mul3(Vec3 a, float b) {
    return (Vec3) {a.x * b, a.y * b, a.z * b};
}
Vec4 mul4(Vec4 a, float b) {
    return (Vec4) {a.x * b, a.y * b, a.z * b, a.w * b};
}

Vec3 cross(Vec3 a, Vec3 b) {
    return (Vec3){a.y * b.z - a.z * b.y, a.x * b.z - a.z * b.x, a.x * b.y - a.y * b.x};
}
float dot(Vec3 a, Vec3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}


Vec2 norm2(Vec2 v) {
    float len = rsqrtf(v.x * v.x + v.y * v.y);
    return (Vec2){v.x * len, v.y * len};
}
Vec3 norm3(Vec3 v) {
    float len = rsqrtf(v.x * v.x + v.y * v.y + v.z * v.z);
    return (Vec3){v.x * len, v.y * len, v.z * len};
}
Vec4 norm4(Vec4 v) {
    float len = rsqrtf(v.x * v.x + v.y * v.y + v.z * v.z + v.w * v.w);
    return (Vec4){v.x * len, v.y * len, v.z * len, v.w * len};
}

Vec3 pivotX(Vec3 v, float s, float c) {
    return (Vec3){v.x, v.y * c + v.z * s, v.z * c - v.y * s};
}
Vec3 pivotY(Vec3 v, float s, float c) {
    return (Vec3){v.x * c + v.z * s, v.y, v.z * c - v.x * s};
}
Vec3 pivotZ(Vec3 v, float s, float c) {
    return (Vec3){v.x * c + v.y * s, v.y * c - v.x * s, v.z};
}

Vec2 lerp2(Vec2 a, Vec2 b, float f) {
    return (Vec2) {lerpf(a.x, b.x, f), lerpf(a.y, b.y, f)};
}
Vec3 lerp3(Vec3 a, Vec3 b, float f) {
    return (Vec3) {lerpf(a.x, b.x, f), lerpf(a.y, b.y, f), lerpf(a.z, b.z, f)};
}
Vec4 lerp4(Vec4 a, Vec4 b, float f) {
    return (Vec4) {lerpf(a.x, b.x, f), lerpf(a.y, b.y, f), lerpf(a.z, b.z, f), lerpf(a.w, b.w, f)};
}

Mat3x3 smul3x3(Mat3x3 a, float b) {
    for (int i = 0; i < 9; i++) a.m[i] *= b;
    return a;
}
Mat4x3 smul4x3(Mat4x3 a, float b) {
    for (int i = 0; i < 12; i++) a.m[i] *= b;
    return a;
}
Mat4x4 smul4x4(Mat4x4 a, float b) {
    for (int i = 0; i < 16; i++) a.m[i] *= b;
    return a;
}

Vec3 vmul3x3(Mat3x3 a, Vec3 b) {
    Vec3 res = {0, 0, 0};
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            (&res.x)[i] += a.m[3 * i + j] * (&b.x)[j];
        }
    }
    return res;
}
Vec3 vmul4x3(Mat4x3 a, Vec4 b) {
    Vec3 res = {0, 0, 0};
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            (&res.x)[i] += a.m[4 * i + j] * (&b.x)[j];
        }
    }
    return res;
}
Vec4 vmul4x4(Mat4x4 a, Vec4 b) {
    Vec4 res = {0, 0, 0, 0};
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            (&res.x)[i] += a.m[4 * i + j] * (&b.x)[j];
        }
    }
    return res;
}

Mat3x3 mmul3333(Mat3x3 a, Mat3x3 b) {
    Mat3x3 res = {0, 0, 0, 0, 0, 0, 0, 0, 0};
    #define outwidth 3
    #define outheight 3
    #define numk 3
    for (int y = 0; y < outheight; y++) {
        for (int x = 0; x < outwidth; x++) {
            for (int k = 0; k < numk; k++) {
                res.m[outwidth * y + x] += a.m[numk * x + k] * b.m[outheight * k + y];
            }
        }
    }
    #undef outwidth
    #undef outheight
    #undef numk
    return res;
}
Mat4x3 mmul3343(Mat3x3 a, Mat4x3 b) {
    Mat4x3 res = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    #define outwidth 4
    #define outheight 3
    #define numk 3
    for (int y = 0; y < outheight; y++) {
        for (int x = 0; x < outwidth; x++) {
            for (int k = 0; k < numk; k++) {
                res.m[outwidth * y + x] += a.m[numk * x + k] * b.m[outheight * k + y];
            }
        }
    }
    #undef outwidth
    #undef outheight
    #undef numk
    return res;
}
Mat4x3 mmul4344(Mat4x3 a, Mat4x4 b) {
    Mat4x3 res = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    #define outwidth 4
    #define outheight 3
    #define numk 4
    for (int y = 0; y < outheight; y++) {
        for (int x = 0; x < outwidth; x++) {
            for (int k = 0; k < numk; k++) {
                res.m[outwidth * y + x] += a.m[numk * x + k] * b.m[outheight * k + y];
            }
        }
    }
    #undef outwidth
    #undef outheight
    #undef numk
    return res;
}
Mat4x4 mmul4444(Mat4x4 a, Mat4x4 b) {
    Mat4x4 res = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    #define outwidth 4
    #define outheight 4
    #define numk 4
    for (int y = 0; y < outheight; y++) {
        for (int x = 0; x < outwidth; x++) {
            for (int k = 0; k < numk; k++) {
                res.m[outwidth * y + x] += a.m[numk * x + k] * b.m[outheight * k + y];
            }
        }
    }
    #undef outwidth
    #undef outheight
    #undef numk
    return res;
}

Mat4x3 mpad3343(Mat3x3 a) {
    return (Mat4x3) {{ 
        a.m[0], a.m[1], a.m[2], 0,
        a.m[3], a.m[4], a.m[5], 0,
        a.m[6], a.m[7], a.m[8], 0,          
    }};
}
Mat4x4 mpad3344(Mat3x3 a) {
    return (Mat4x4) {{ 
        a.m[0], a.m[1], a.m[2], 0,
        a.m[3], a.m[4], a.m[5], 0,
        a.m[6], a.m[7], a.m[8], 0,          
        0,      0,      0,      1,
    }};
}
Mat4x4 mpad4344(Mat4x3 a) {
    return (Mat4x4) {{ 
        a.m[0], a.m[1], a.m[2], a.m[3],
        a.m[4], a.m[5], a.m[6], a.m[7],
        a.m[8], a.m[9], a.m[10],a.m[11],
        0,      0,      0,      1,         
    }};
}
