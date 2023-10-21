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

#include <pci.h>
#include <ahci.h>

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

    pic_init();
    idt_init();

    void* h = AllocHeap(256);
    globalBuffer = (TextBuffer){(char*)h};
    buffer_init(&globalBuffer);

    outb(0x21, 1);
    //outb(0xa1, 0);
    inb(0x60);
    inb(0x60);
}

void ahci_test() {
    console_init();
    clearconsole();
    void* heap = AllocHeap(256);
    
    pci_devices devs = pci_scan_devices();

    int ahci_idx = 0;

    for(int i = 0; i < devs.numDevs; i++) {
        if(devs.devices[i].class_id == 1) ahci_idx = i;
        console_printf("(%i:%i:%i) dev:%04x vendor:%04x class %02x:%02x:%02x:%02x\r\n", 
            devs.devices[i].address.bus, devs.devices[i].address.slot, devs.devices[i].address.func,
            devs.devices[i].device_id, devs.devices[i].vendor_id,
            devs.devices[i].class_id, devs.devices[i].subclass, devs.devices[i].prog_if, devs.devices[i].rev_id
        );
    }
    ahci_device ahci_dev = ahci_init(devs.devices[ahci_idx]);
    ahci_read(ahci_dev, 0, 1, (void*)0x9000);

    console_printf("%x\r\n", *(uint16_t*)0x91FE);
}

int main() {
    beep(1000);
    delay(1 << 28);
    beep_off();

    ahci_test();
    //text_editor();
    //draw_loop();

    while(1);
}
