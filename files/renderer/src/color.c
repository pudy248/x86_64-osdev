#include <color.h>
#include <inttypes.h>
#include <vectors.h>
#include <math.h>

#define MIN(a,b) ((a)<(b)?(a):(b))
#define MAX(a,b) ((a)>(b)?(a):(b))

Vec3 rgb2hsl(Vec3 rgb) {
    Vec3 result;

    rgb.x /= 255;
    rgb.y /= 255;
    rgb.z /= 255;

    float max = MAX(MAX(rgb.x,rgb.y),rgb.z);
    float min = MIN(MIN(rgb.x,rgb.y),rgb.z);

    result.x = result.y = result.z = (max + min) / 2;

    if (abs(max - min) < 0.0001f) {
        result.x = result.y = 0; // achromatic
    }
    else {
        float d = max - min;
        result.y = (result.z > 0.5f) ? d / (2 - max - min) : d / (max + min);

        if (abs(max - rgb.x) < 0.0001f) {
            result.x = (rgb.y - rgb.z) / d + (rgb.y < rgb.z ? 6 : 0);
        }
        else if (abs(max - rgb.y) < 0.0001f) {
            result.x = (rgb.z - rgb.x) / d + 2;
        }
        else if (abs(max - rgb.z) < 0.0001f) {
            result.x = (rgb.x - rgb.y) / d + 4;
        }

        result.x /= 6;
    }

    return result;
}

static float hue2rgb(float p, float q, float t) {
    if (t < 0) 
    t += 1;
    if (t > 1) 
    t -= 1;
    if (t < 1.f/6) 
    return p + (q - p) * 6 * t;
    if (t < 1.f/2) 
    return q;
    if (t < 2.f/3)   
    return p + (q - p) * (2.f/3 - t) * 6;

    return p;
}

Vec3 hsl2rgb(Vec3 hsl) {
    Vec3 result;

    if (abs(hsl.y) < 0.0001f) {
        result.x = result.y = result.z = 255; // achromatic
    }
    else {
        float q = hsl.z < 0.5f ? hsl.z * (1 + hsl.y) : hsl.z + hsl.y - hsl.z * hsl.y;
        float p = 2 * hsl.z - q;
        result.x = hue2rgb(p, q, hsl.x + 1.f/3) * 255;
        result.y = hue2rgb(p, q, hsl.x) * 255;
        result.z = hue2rgb(p, q, hsl.x - 1.f/3) * 255;
    }

    return result;
}
uint32_t rgba2u32(Vec4 c) {
    return (((uint32_t)c.x & 0xff) << 16) | (((uint32_t)c.y & 0xff) << 8) | (((uint32_t)c.z & 0xff) << 0);
}
