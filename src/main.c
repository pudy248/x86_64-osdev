#include <taskStructs.h>
#include <kernel.h>
#include <memory.h>

#include <idt.h>
#include <pic.h>
#include <assembly.h>

#include <console.h>
#include <serial_console.h>
#include <vesa_console.h>

#include <vesa.h>
#include <math.h>
#include <graphics.h>

#include <beep.h>
#include <string.h>

#include <vim.h>

void draw_loop() {
    vesa_init();
    clearscreen();

    #ifdef singlebuffer
    backBuffer = screen;
    #endif

    Heap* h = AllocPages(1<<14); //64MB of memory
    char* text = (char*)0x80000000 + 0x10000;
    Vec3* vertices = (Vec3*)malloc(sizeof(Vec3) * 300000, h);
    int* triangles = (int*)malloc(sizeof(int) * 2000000, h);
    if((uint32_t)triangles == 0) {
        serial_printf("Failed to allocate mesh memory.\r\n");
        while(1);
    }
    
    int vi = 0;
    int ti = 0;
    int i;
    for(i = 0; text[i] != 0; i++) {
        //serial_printf("'%c%c'\r\n", text[i], text[i + 1]);
        if (text[i] == 'v' && text[i + 1] == ' ') {
            i++; while(text[i] == ' ') i++;
            float x = fparse(text + i);
            while(text[i] != ' '  && text[i] != 0) i++; while(text[i] == ' ') i++;
            float y = fparse(text + i) + 0.25f;
            while(text[i] != ' '  && text[i] != 0) i++; while(text[i] == ' ') i++;
            float z = fparse(text + i);
            while(text[i] != '\n' && text[i] != 0) i++;
            vertices[vi++] = (Vec3){x, y, z};
            //printf("vert %f %f %f       \n", x, y, z);
        }
        else if (text[i] == 'f' && text[i + 1] == ' ') {
            i++; while(text[i] == ' ') i++;
            int v1 = iparse(text + i) - 1;
            while(text[i] != ' '  && text[i] != 0) i++; while(text[i] == ' ') i++;
            int v2 = iparse(text + i) - 1;
            while(text[i] != ' '  && text[i] != 0) i++; while(text[i] == ' ') i++;
            int v3 = iparse(text + i) - 1;
            while(text[i] != '\n' && text[i] != 0) i++;
            triangles[3 * ti] = v1;
            triangles[3 * ti + 1] = v2;
            triangles[3 * ti + 2] = v3;
            //serial_printf("tri %i %i %i\r\n", v1, v2, v3);
            ti++;
        }
        else {
            while(text[i] != '\n' && text[i] != 0) i++;
        }
    }
    serial_printf("loaded model with %i verts, %i tris\r\n", vi, ti);
    
    uint64_t cycleCtr = rdtscp();

    rotationX = 0;
    rotationY = 0;
    rotationZ = 0;

    while(1) {
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

        uint64_t lastCycle = cycleCtr;
        cycleCtr = rdtscp();
        vesa_printf(10, 10, "%l cycles", cycleCtr - lastCycle);
        #ifndef singlebuffer
        //vsync();
        display();
        #endif
    }
}

void elephant() {
    uint16_t G4 = 392;
    uint16_t A4 = 440;
    uint16_t B4 = 493;
    uint16_t C5 = 523;
    uint16_t D5 = 587;
    uint16_t E5 = 659;
    uint16_t F5 = 698;
    uint16_t G5 = 784;

    uint64_t quarter = 1ULL << 30;
    uint64_t eighth = 1ULL << 29;
    uint64_t sixteenth = 1ULL << 28;
    uint64_t articulate = 1ULL << 26;

    beep(G4);
    delay(quarter);
    beep(C5);
    delay(eighth);
    beep(G5);
    delay(eighth);
    beep(E5);
    delay(quarter);
    beep(A4);
    delay(quarter);
    beep(F5);
    delay(quarter);
    beep(C5);
    delay(quarter);
    beep(D5);
    delay(eighth);
    beep(F5);
    delay(eighth);
    beep(B4);
    delay(quarter);
    beep(G4);
    delay(quarter);
    beep(C5);
    delay(eighth);
    beep(G5);
    delay(eighth);
    beep(E5);
    delay(quarter);
    beep(A4);
    delay(quarter);
    beep(F5);
    delay(quarter);
    beep(C5);
    delay(quarter);
    beep(D5);
    delay(eighth);
    beep(F5);
    delay(eighth);
    beep(B4);
    delay(quarter);
    beep_off();
    delay(articulate);
    beep(B4);
    delay(quarter);
    beep(D5);
    delay(quarter);
    beep(F5);
    delay(eighth);
    beep(G4);
    delay(eighth);
    beep(E5);
    delay(eighth);
    beep(B4);
    delay(sixteenth);
    beep(A4);
    delay(sixteenth);
    beep(B4);
    delay(quarter);
    beep(A4);
    delay(quarter);

    beep_off();
}

void text_editor() {
    console_init();
    clearconsole();

    Heap* h = AllocPages(256);
    globalBuffer = (TextBuffer){(char*)h};
    buffer_init(&globalBuffer);

    outb(0x21, 1);
    //outb(0xa1, 0);
}

int main() {
    pic_init();
    idt_init();
    gks->pgWaterline = 0;

    text_editor();

    while(1);
}
