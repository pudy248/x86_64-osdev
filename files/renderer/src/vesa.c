#include <typedefs.h>
#include <vesa.h>
#include <kernel16/exports.h>
#include <kernel/exports.h>

RenderPipeline vesa_init(uint16_t mode) {
    struct vbe_mode_info_structure* info = (struct vbe_mode_info_structure*)0x1000;
    bios_int_regs regs = {0x4f01, 0, mode, 0, 0, (uint16_t)info, 0, 0};
    bios_interrupt(0x10, regs);
    regs = (bios_int_regs){0x4f02, 0x4000 | mode, 0, 0, 0, 0, 0, 0};
    bios_interrupt(0x10, regs);
    
    init_protected();
    basic_printf("%ix%i\r\n", info->width, info->height);
    
    RenderPipeline p;
    p.fragBuffer = (aFragment_p)0x10000000;
    p.fragTexture = (auint32_p)0x11000000;
    p.renderTexture = (auint32_p)info->framebuffer;

    p.display_w = info->width;
    p.display_h = info->height;
    p.vertexShader = _default_vertex_shader;
    p.rasterShader = _default_raster_shader;
    p.fragmentShader = _default_fragment_shader;
    return p;
}
