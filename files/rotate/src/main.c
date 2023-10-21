#include <vesa.h>
#include <vector.h>
#include <math.h>
#include <graphics.h>

#include <kernel/exports.h>

void rotate_main(char* obj);

void rotate_main(char* obj) {
    //while(1);
    vesa_init(0x11B);
    clearscreen();
    basic_printf("%x %x %x %x\r\n", vesa_screen, pitch, SCREEN_W, SCREEN_H);

    #ifdef singlebuffer
    backBuffer = vesa_screen;
    #endif

    Vec3* vertices = (Vec3*)0x40000000;
    int* triangles = (int*)0x41000000;
    
    int vi = 0;
    int ti = 0;
    for(int i = 0; obj[i] != 0; i++) {
        //serial_printf("'%c%c'\r\n", obj[i], obj[i + 1]);
        if (obj[i] == 'v' && obj[i + 1] == ' ') {
            i++; while(obj[i] == ' ') i++;
            float x = fparse(obj + i);
            while(obj[i] != ' '  && obj[i] != 0) i++; while(obj[i] == ' ') i++;
            float y = fparse(obj + i) + 0.25f;
            while(obj[i] != ' '  && obj[i] != 0) i++; while(obj[i] == ' ') i++;
            float z = fparse(obj + i);
            while(obj[i] != '\n' && obj[i] != 0) i++;
            vertices[vi++] = (Vec3){x, y, z};
            //printf("vert %f %f %f       \n", x, y, z);
        }
        else if (obj[i] == 'f' && obj[i + 1] == ' ') {
            i++; while(obj[i] == ' ') i++;
            int v1 = iparse(obj + i) - 1;
            while(obj[i] != ' '  && obj[i] != 0) i++; while(obj[i] == ' ') i++;
            int v2 = iparse(obj + i) - 1;
            while(obj[i] != ' '  && obj[i] != 0) i++; while(obj[i] == ' ') i++;
            int v3 = iparse(obj + i) - 1;
            while(obj[i] != '\n' && obj[i] != 0) i++;
            triangles[3 * ti] = v1;
            triangles[3 * ti + 1] = v2;
            triangles[3 * ti + 2] = v3;
            //serial_printf("tri %i %i %i\r\n", v1, v2, v3);
            ti++;
        }
        else {
            while(obj[i] != '\n' && obj[i] != 0) i++;
        }
    }
    //serial_printf("loaded model with %i verts, %i tris\r\n", vi, ti);
    
    //uint64_t cycleCtr = rdtscp();

    rotationX = 0;
    rotationY = 0;
    rotationZ = 0;

    while(1) {
        rotationX++;
        rotationY++;
        rotationZ++;

        int local_rotX = rotationX;
        int local_rotY = rotationY;
        int local_rotZ = rotationZ;

        clearscreen();
        double sx, cx, sy, cy, sz, cz;
        cossin_cordic(local_rotX * 0.1f, 20, &cx, &sx);
        cossin_cordic(local_rotY * 0.1f, 20, &cy, &sy);
        cossin_cordic(local_rotZ * 0.1f, 20, &cz, &sz);

        for(int i = 0; i < ti; i++) {
            Vec3 w1 = vertices[triangles[3 * i]];
            Vec3 w2 = vertices[triangles[3 * i + 1]];
            Vec3 w3 = vertices[triangles[3 * i + 2]];
            w1 = rotateZsc(rotateYsc(rotateXsc(w1, sx, cx), sy, cy), sz, cz);
            w2 = rotateZsc(rotateYsc(rotateXsc(w2, sx, cx), sy, cy), sz, cz);
            w3 = rotateZsc(rotateYsc(rotateXsc(w3, sx, cx), sy, cy), sz, cz);

            w1.z += 10;
            w2.z += 10;
            w3.z += 10;

            #ifdef pointcloud
            float lighting = 255;
            #else
            Vec3 norm = normalize(cross(sub3(w2, w1), sub3(w3, w1)));
            float lighting = dot(norm, (Vec3){0, 0, -1});
            if(lighting < 0) continue;
            lighting *= 224;
            lighting += 32;
            #endif

            tri3(w1, w2, w3, (Vec3){lighting, lighting, lighting});
        }

        #ifndef singlebuffer
        vsync();
        display();
        #endif
    }
}
