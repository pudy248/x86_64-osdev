#include <kstddefs.h>
#include <kstdlib.hpp>
#include <sys/pic.h>

#define ICW1_ICW4			(uint8_t)0x01	/* Indicates that ICW4 will be present */
//#define ICW1_SINGLE			(uint8_t)0x02	/* Single (cascade) mode */
//#define ICW1_INTERVAL4		(uint8_t)0x04	/* Call address interval 4 (8) */
//#define ICW1_LEVEL			(uint8_t)0x08	/* Level triggered (edge) mode */
#define ICW1_INIT			(uint8_t)0x10	/* Initialization - required! */

#define ICW4_8086			(uint8_t)0x01	/* 8086/88 (MCS-80/85) mode */
//#define ICW4_AUTO			(uint8_t)0x02	/* Auto (normal) EOI */
//#define ICW4_BUF_SLAVE		(uint8_t)0x08	/* Buffered mode/slave */
//#define ICW4_BUF_MASTER		(uint8_t)0x0C	/* Buffered mode/master */
//#define ICW4_SFNM			(uint8_t)0x10	/* Special fully nested (not) */

#define PIC1_CMD            (uint8_t)0x20
#define PIC1_DATA           (uint8_t)0x21
#define PIC2_CMD            (uint8_t)0xA0
#define PIC2_DATA           (uint8_t)0xA1
#define PIC_READ_IRR        (uint8_t)0x0a    /* OCW3 irq ready next CMD read */
#define PIC_READ_ISR        (uint8_t)0x0b    /* OCW3 irq service next CMD read */

#define PIC_EOI		0x20		/* End-of-interrupt command code */

#define io_wait() outb(0x80, 0)

void pic_init()
{
    uint8_t a1, a2;
 
    a1 = inb(PIC1_DATA);                        // save masks
    a2 = inb(PIC2_DATA);
 
    outb(PIC1_CMD, ICW1_INIT | ICW1_ICW4);  // starts the initialization sequence (in cascade mode)
    io_wait();
    outb(PIC2_CMD, ICW1_INIT | ICW1_ICW4);
    io_wait();
    outb(PIC1_DATA, MASTER_OFFSET);                 // ICW2: Master PIC vector offset
    io_wait();
    outb(PIC2_DATA, SLAVE_OFFSET);                 // ICW2: Slave PIC vector offset
    io_wait();
    outb(PIC1_DATA, 4);                       // ICW3: tell Master PIC that there is a slave PIC at IRQ2 (0000 0100)
    io_wait();
    outb(PIC2_DATA, 2);                       // ICW3: tell Slave PIC its cascade identity (0000 0010)
    io_wait();
 
    outb(PIC1_DATA, ICW4_8086);               // ICW4: have the PICs use 8086 mode (and not 8080 mode)
    io_wait();
    outb(PIC2_DATA, ICW4_8086);
    io_wait();
 
    outb(PIC1_DATA, a1);   // restore saved masks.
    outb(PIC2_DATA, a2);
}

void pic_eoi(uint8_t irq)
{
    if (irq >= 8)
        outb(PIC2_CMD,PIC_EOI);
 
    outb(PIC1_CMD,PIC_EOI);
}

/* Helper func */
static uint16_t __pic_get_irq_reg(uint8_t ocw3)
{
    /* OCW3 to PIC CMD to get the register values.  PIC2 is chained, and
     * represents IRQs 8-15.  PIC1 is IRQs 0-7, with 2 being the chain */
    outb(PIC1_CMD, ocw3);
    outb(PIC2_CMD, ocw3);
    return (uint16_t)((uint16_t)inb(PIC2_CMD) << 8) | inb(PIC1_CMD);
}
 
/* Returns the combined value of the cascaded PICs irq request register */
uint16_t pic_get_irr()
{
    return __pic_get_irq_reg(PIC_READ_IRR);
}
 
/* Returns the combined value of the cascaded PICs in-service register */
uint16_t pic_get_isr()
{
    return __pic_get_irq_reg(PIC_READ_ISR);
}
