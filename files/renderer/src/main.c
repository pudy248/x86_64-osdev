#include <kernel/exports.h>
#include <vesa.h>
#include <transform.h>
#include <graphics.h>
#include <pipeline.h>

void rotate_main(char* obj);
void rotate_exit(void);

void rotate_main(char* obj) {
    RenderPipeline p = vesa_init(0x118);
    p.vertexBuffer = (aVertex_p)0x40000000;
    p.projVertBuffer = (aProjVertex_p)0x41000000;
    p.triangleBuffer = (auint32_p)0x42000000;

    projectionMatrix = project(4, 3, 2);

    uint32_t vi = 0;
    uint32_t ti = 0;
    for (uint32_t i = 0; obj[i] != 0; i++) {
        if (obj[i] == 'v' && obj[i + 1] == ' ') {
            i++; while (obj[i] == ' ') i++;
            float x = fparse(obj + i);
            while (obj[i] != ' '  && obj[i] != 0) i++; while (obj[i] == ' ') i++;
            float y = fparse(obj + i) + 0.25f;
            while (obj[i] != ' '  && obj[i] != 0) i++; while (obj[i] == ' ') i++;
            float z = fparse(obj + i);
            while (obj[i] != '\n' && obj[i] != 0) i++;
            p.vertexBuffer[vi++] = (Vertex){(Vec4){x, y, z, 0}, (Vec4){255.f, 255.f, 255.f, 0}};
        }
        else if (obj[i] == 'f' && obj[i + 1] == ' ') {
            i++; while (obj[i] == ' ') i++;
            uint32_t v1 = iparse(obj + i) - 1;
            while (obj[i] != ' '  && obj[i] != 0) i++; while (obj[i] == ' ') i++;
            uint32_t v2 = iparse(obj + i) - 1;
            while (obj[i] != ' '  && obj[i] != 0) i++; while (obj[i] == ' ') i++;
            uint32_t v3 = iparse(obj + i) - 1;
            while (obj[i] != '\n' && obj[i] != 0) i++;
            p.triangleBuffer[3 * ti] = v1;
            p.triangleBuffer[3 * ti + 1] = v2;
            p.triangleBuffer[3 * ti + 2] = v3;
            ti++;
        }
        else {
            while (obj[i] != '\n' && obj[i] != 0) i++;
        }
    }
    p.nVertices = vi;
    p.nTriangles = ti;
    printf("loaded model with %i verts, %i tris\r\n", vi, ti);
    
    int iters = 0;
    int frameStart = 0;
    int fps = 0;
    int second = get_rtc_second();


    while (1) {
        iters++;

        //double thetaX = sin((double)iters * 0.0281);
        //double thetaY = cos((double)iters * 0.1) + (double)iters * 0.05;
        //double thetaZ = sin((double)iters * 0.0314);
        double thetaX = iters * 0.01f;
        double thetaY = iters * 0.01f;
        double thetaZ = iters * 0.01f;


        Mat4x4 rot = rotate(thetaX, thetaY, thetaZ);

        void* params[] = {&iters, &rot};
        pipeline_flush(&p);
        pipeline_execute(&p, params);
        /*
        for (int i = 0; i < ti; i++) {
            Vec3 w1 = vertices[triangles[3 * i]];
            Vec3 w2 = vertices[triangles[3 * i + 1]];
            Vec3 w3 = vertices[triangles[3 * i + 2]];
            
            //tri3(w1, w2, w3, color);
        }
        
        int now = get_rtc_second();
        if (now != second) {
            second = now;
            fps = iters - frameStart;
            frameStart = iters;
        }
        vesa_printf(10, 10, "frame %i (%i fps)", iters2, fps);
        */
    }
}

void rotate_exit() {
    vesa_init(0);
    return;
}
