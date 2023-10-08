CC=clang
ASM=nasm
ASMFLAGS=-f elf32 -g
CCREQUIREDFLAGS=-nostdlib -nostdinc -ffreestanding -fno-pie -Iinclude -fdata-sections -ffunction-sections
CCOPTIONALFLAGS=-Oz -Wall -Wextra -Wshadow -pedantic
# -Wconversion
CC32FLAGS=-m32

QEMU_STORAGE=-drive id=disk,file=disk.img,if=none -device ahci,id=ahci -device ide-hd,drive=disk,bus=ahci.0
QEMU_VIDEO=-vga qxl
QEMU_AUDIO=-audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97
QEMU_MISC=-m 4G -smp 2
QEMU_FLAGS=$(QEMU_STORAGE) $(QEMU_VIDEO) $(QEMU_AUDIO) $(QEMU_MISC)

ASM_SRCS=$(wildcard src/**/*.asm) $(wildcard src/*.asm)
C32_SRCS=$(wildcard src/**/*.c) $(wildcard src/*.c)
ASM_OBJS=$(patsubst src/%.asm,tmp/%.o,$(ASM_SRCS))
C32_OBJS=$(patsubst src/%.c,tmp/%.o,$(C32_SRCS))
FOLDERS=$(sort $(dir $(wildcard src/* src/**/*)))

.PHONY: start start-trace start-gdb clean size flash
default: .depend disk.img
-include .depend

.depend: $(C32_SRCS)
	$(CC) -Iinclude -MM $^ > "$@"

start: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS)

start-trace: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -d int,cpu_reset

start-gdb: disk.img tmp/main.bin
	qemu-system-i386.exe $(QEMU_FLAGS) -s -S &
	gf2 tmp/main.elf

flash: disk.img
	./FlashDisk.exe

size: tmp/main.bin
	@echo Kernel size:
	@wc -c < tmp/main.bin
	@echo Source line count:
	@wc -l src/**/* src/*

clean:
	rm -f main.elf disk.img .depend
	rm -rf tmp/*
	mkdir $(addprefix tmp/,$(FOLDERS:src/%=%))

$(ASM_OBJS): tmp/%.o : src/%.asm
	$(ASM) $< -o $@ $(ASMFLAGS)

$(C32_OBJS): tmp/%.o : src/%.c
	$(CC) $(CCREQUIREDFLAGS) $(CCOPTIONALFLAGS) $(CC32FLAGS) -o $@ -c $<

kernelsize: kernelsize.c
	clang kernelsize.c -o kernelsize

tmp/main.bin: $(C32_OBJS) $(ASM_OBJS) link.ld kernelsize
	ld -melf_i386 -N --build-id=none -T link.ld -static -gc-sections $(C32_OBJS) $(ASM_OBJS) -o main.elf
	objcopy -O binary main.elf tmp/main.bin
	./kernelsize

disk.img: tmp/main.bin Makefile
	cp tmp/main.bin disk.img
	truncate -s 32M disk.img