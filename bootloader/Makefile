-include Makefile_flags
-include make.cfg

CC:=clang
ASM:=nasm

ASMFLAGS:=-f elf
CFLAGS:=$(CC_REQUIRED_FLAGS) $(patsubst -Ofast,-Oz,$(CC_OPTIONAL_FLAGS)) -Ifiles/kernel/include -Ifiles -ffunction-sections -fdata-sections
LDFLAGS:=$(LD_DEFAULT_FLAGS) -gc-sections

BOOTLOADER_ASM:=$(wildcard bootloader/**/*.asm) $(wildcard bootloader/*.asm)
BOOTLOADER_ASM_MISC:=$(wildcard files/kernel/src/**/*.asm) $(wildcard files/kernel/src/*.asm) files/kernel16/src/call_real.asm files/kernel16/src/bios_interrupts.asm
BOOTLOADER_SRC:=$(wildcard bootloader/**/*.c) $(wildcard bootloader/*.c)
BOOTLOADER_SRC_MISC:=$(wildcard files/kernel/src/**/*.c) $(filter-out files/kernel/src/main.c,$(wildcard files/kernel/src/*.c))
BOOTLOADER_ASMOBJ:=$(patsubst %.asm,tmp/%.o,$(BOOTLOADER_ASM))
BOOTLOADER_ASMOBJ_MISC:=$(patsubst files/kernel16/src/%.asm,tmp/bootloader/%.o,$(patsubst files/kernel/src/%.asm,tmp/bootloader/%.o,$(BOOTLOADER_ASM_MISC)))
BOOTLOADER_OBJ:=$(patsubst %.c,tmp/%.o,$(BOOTLOADER_SRC))
BOOTLOADER_OBJ_MISC:=$(patsubst files/kernel/src/%.c,tmp/bootloader/%.o,$(BOOTLOADER_SRC_MISC))

default: tmp/bootloader.img

$(BOOTLOADER_ASMOBJ) : tmp/%.o : %.asm bootloader/constants.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
$(BOOTLOADER_OBJ): tmp/%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $<
tmp/bootloader/%.o : files/kernel/src/%.c
	$(CC) $(CFLAGS) -o $@ -c $<
tmp/bootloader/%.o : files/kernel/src/%.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
tmp/bootloader/%.o : files/kernel16/src/%.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

tmp/bootloader.img: $(BOOTLOADER_ASMOBJ) $(BOOTLOADER_OBJ) $(BOOTLOADER_ASMOBJ_MISC) $(BOOTLOADER_OBJ_MISC) bootloader/bootloader.ld
	ld $(LDFLAGS) -T bootloader/bootloader.ld -o tmp/bootloader.img.elf $(BOOTLOADER_ASMOBJ) $(BOOTLOADER_OBJ) $(BOOTLOADER_ASMOBJ_MISC) $(BOOTLOADER_OBJ_MISC)
	@objcopy -O binary tmp/bootloader.img.elf tmp/bootloader.img
