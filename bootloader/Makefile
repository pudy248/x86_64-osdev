CC=clang
ASM=nasm

ASMFLAGS=-f elf32 -g
CCREQUIREDFLAGS=-m32 -nostdlib -nostdinc -ffreestanding -fno-pie -Ibootloader/include -Ifiles/kernel/include -Ifiles
CCOPTIONALFLAGS=-Oz -Wall -Wextra -Wshadow -pedantic -Wconversion -Wno-cast-align
LDFLAGS=-melf_i386 -N --build-id=none

BOOTLOADER_ASM=$(wildcard bootloader/**/*.asm) $(wildcard bootloader/*.asm)
BOOTLOADER_ASM_MISC=files/kernel/src/common_s.asm files/kernel16/src/call_real.asm files/kernel16/src/read_disk.asm
BOOTLOADER_SRC=$(wildcard bootloader/**/*.c) $(wildcard bootloader/*.c)
BOOTLOADER_SRC_MISC=files/kernel/src/basic_console.c files/kernel/src/common.c files/kernel/src/pci.c files/kernel/src/ahci.c files/kernel/src/fat.c files/kernel/src/string.c
BOOTLOADER_ASMOBJ=$(patsubst %.asm,tmp/%.o,$(BOOTLOADER_ASM))
BOOTLOADER_ASMOBJ_MISC=tmp/bootloader/common_s.o tmp/bootloader/call_real.o tmp/bootloader/read_disk.o
BOOTLOADER_OBJ=$(patsubst %.c,tmp/%.o,$(BOOTLOADER_SRC))
BOOTLOADER_OBJ_MISC=tmp/bootloader/basic_console.o tmp/bootloader/common.o tmp/bootloader/pci.o tmp/bootloader/ahci.o tmp/bootloader/fat.o tmp/kernel/string.o

default: tmp/bootloader.img

$(BOOTLOADER_ASMOBJ) : tmp/%.o : %.asm bootloader/constants.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
$(BOOTLOADER_OBJ): tmp/%.o : %.c
	$(CC) $(CCREQUIREDFLAGS) $(CCOPTIONALFLAGS) $(CCBOOTLOADERFLAGS) -o $@ -c $<
tmp/bootloader/%.o : files/kernel/src/%.c
	$(CC) $(CCREQUIREDFLAGS) $(CCOPTIONALFLAGS) $(CCBOOTLOADERFLAGS) -o $@ -c $<
tmp/bootloader/%.o : files/kernel/src/%.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
tmp/bootloader/%.o : files/kernel16/src/%.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

tmp/bootloader.img: $(BOOTLOADER_ASMOBJ) $(BOOTLOADER_OBJ) $(BOOTLOADER_ASMOBJ_MISC) $(BOOTLOADER_OBJ_MISC) bootloader/bootloader.ld
	ld $(LDFLAGS) -T bootloader/bootloader.ld -o tmp/bootloader.img.elf $(BOOTLOADER_ASMOBJ) $(BOOTLOADER_OBJ) $(BOOTLOADER_ASMOBJ_MISC) $(BOOTLOADER_OBJ_MISC)
	@objcopy -O binary tmp/bootloader.img.elf tmp/bootloader.img
