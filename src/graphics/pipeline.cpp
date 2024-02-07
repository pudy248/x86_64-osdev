#include <kstdio.hpp>

#include <graphics/math.h>
#include <graphics/pipeline.h>
#include <graphics/vectypes.h>
#include <graphics/transform.h>
#include <graphics/graphics.h>
#include <graphics/color.h>

Mat4x4 projectionMatrix;

void _default_vertex_shader(RenderPipeline* pipeline, void** params) {
    for (uint32_t index = 0; index < pipeline->nVertices; index++) {
        int frameCtr = *(int*)(params[0]);
        Vec4 basePos = pipeline->vertexBuffer[index].pos;
        basePos = vmul4x4(*(Mat4x4*)(params[1]), basePos); //rotation matrix
        if (0) {
            basePos.x += 0.5f * sinf(basePos.x + (float)frameCtr * 0.1274f);
            basePos.y += 1.0f * sinf(basePos.y + (float)frameCtr * 0.1f);
            basePos.z += 0.5f * sinf(basePos.z + (float)frameCtr * 0.0867f);
        }
        basePos.z -= 12;
        Vec4 projected = vnormw(vmul4x4(projectionMatrix, basePos));
        pipeline->projVertBuffer[index] = (ProjectedVertex){basePos, projected, pipeline->vertexBuffer[index].color};
    }
}
void _default_raster_shader(RenderPipeline* pipeline, void** params) {
    for (uint32_t index = 0; index < pipeline->nTriangles; index++) {
        ProjectedVertex v1 = pipeline->projVertBuffer[pipeline->triangleBuffer[3 * index + 0]];
        ProjectedVertex v2 = pipeline->projVertBuffer[pipeline->triangleBuffer[3 * index + 1]];
        ProjectedVertex v3 = pipeline->projVertBuffer[pipeline->triangleBuffer[3 * index + 2]];
        
        if (0) {
            Vec3 lookdir = norm3(mul3(vtrunc43(add4(add4(v1.wpos, v2.wpos), v3.wpos)), 0.3333f));
            Vec3 normal = norm3(cross(sub3(vtrunc43(v2.wpos), vtrunc43(v1.wpos)), sub3(vtrunc43(v3.wpos), vtrunc43(v1.wpos))));
            Mat4x4 rebaseMat = rebase((Vec3){0, 1, 0}, lookdir, (Vec3){0, 0, 0});
            Vec3 normB = vtrunc43(vmul4x4(rebaseMat, vpad34(normal, 1)));
            float lighting = dot(normal, lookdir);
            //if (lighting < 0.f) continue;
            if (lighting > 1.f) {
                printf("%f %f %f dot %f %f %f = %f\r\n", lookdir.x, lookdir.y, lookdir.z, normal.x, normal.y, normal.z, lighting);
                continue;
            }

            int frameCtr = *(int*)(params[0]);

            Vec3 baseColorHSL = {fmodf((float)frameCtr * 0.01f, 1.f), 0.5f, 0.3f};
            baseColorHSL.x += (1.f - lighting) * .3f;
            baseColorHSL.y += (1.f - lighting) * 0.4f;
            baseColorHSL.z += (1.f - lighting) * 0.4f + (1.f - lighting * 1.f - lighting) * 0.2f;
            Vec3 color = hsl2rgb(baseColorHSL);
            
            //color = (Vec3){lighting * 255, lighting * 255, lighting * 255};
            color = (Vec3){abs(normB.x) * 255, abs(normB.y) * 255, abs(normB.z) * 255};


            pipeline->projVertBuffer[pipeline->triangleBuffer[3 * index + 0]].color = vpad34(color, 0);
            pipeline->projVertBuffer[pipeline->triangleBuffer[3 * index + 1]].color = vpad34(color, 0);
            pipeline->projVertBuffer[pipeline->triangleBuffer[3 * index + 2]].color = vpad34(color, 0);
        }

        raster_triangle(pipeline, index);
    }
}
void _default_fragment_shader(RenderPipeline* pipeline, void** params) {
    for (uint32_t index = 0; index < pipeline->display_w * pipeline->display_h; index++) {
        pipeline->renderTexture[index] = pipeline->fragTexture[index];
        pipeline->fragTexture[index] = 0;
    }
}

void pipeline_execute(RenderPipeline* pipeline, void** params) {
    uint64_t tp1 = rdtsc();
    
    _default_vertex_shader(pipeline, params);
    //pipeline->vertexShader(pipeline, params);
    
    uint64_t tp2 = rdtsc();

    _default_raster_shader(pipeline, params);
    //pipeline->rasterShader(pipeline, params);

    uint64_t tp3 = rdtsc();

    _default_fragment_shader(pipeline, params);
    //pipeline->fragmentShader(pipeline, params);

    uint64_t tp4 = rdtsc();
    printf("times: %i %i %i | %i\r\n", (uint32_t)(tp2 - tp1), (uint32_t)(tp3 - tp2), (uint32_t)(tp4 - tp3), (uint32_t)(tp4 - tp1));
}

void pipeline_flush(RenderPipeline* pipeline) {
    //memset(pipeline->fragBuffer, 0, pipeline->display_w * pipeline->display_h * sizeof(Fragment));
    //memset(pipeline->fragTexture, 0, 4 * pipeline->display_w * pipeline->display_h);
}
