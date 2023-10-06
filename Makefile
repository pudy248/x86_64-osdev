CC=clang
ASM=nasm
ASMFLAGS=-f elf32 -g
CCREQUIREDFLAGS=-nostdlib -nostdinc -ffreestanding -fno-pie -Iinclude
CCOPTIONALFLAGS=-Oz -g -Wall -Wextra -pedantic
CC32FLAGS=-m32

ASM_SRCS=$(wildcard src/**/*.asm) $(wildcard src/*.asm)
C32_SRCS=$(wildcard src/**/*.c) $(wildcard src/*.c)
ASM_OBJS=$(patsubst src/%.asm,tmp/%.o,$(ASM_SRCS))
C32_OBJS=$(patsubst src/%.c,tmp/%.o,$(C32_SRCS))
FOLDERS=$(sort $(dir $(wildcard src/* src/**/*)))

.PHONY: clean size echo
default: .depend disk.img
-include .depend

all: disk.img

.depend:
	$(CC) -Iinclude -MM $(C32_SRCS) -MT "$<" > "$@"

start: disk.img
	qemu-system-x86_64.exe -m 4G -smp 1 -vga qxl -audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97 -drive format=raw,file=disk.img

start-trace: disk.img
	qemu-system-x86_64.exe -m 4G -smp 1 -vga qxl -audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97 -drive format=raw,file=disk.img -d int,cpu_reset

start-gdb: disk.img main.bin
	qemu-system-i386.exe -m 4G -smp 1 -vga qxl -audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97 -drive format=raw,file=disk.img -s -S &
	gf2 tmp/main.elf

size: main.bin
	@wc -c < main.bin

clean:
	rm -f main.bin main.img disk.img .depend
	rm -rf tmp/*
	mkdir $(addprefix tmp/,$(FOLDERS:src/%=%))

$(ASM_OBJS): tmp/%.o : src/%.asm
	$(ASM) $< -o $@ $(ASMFLAGS)

$(C32_OBJS): tmp/%.o : src/%.c
	$(CC) $(CCREQUIREDFLAGS) $(CCOPTIONALFLAGS) $(CC32FLAGS) -o $@ -c $<

main.bin: $(C32_OBJS) $(ASM_OBJS)
	ld -melf_i386 -N --build-id=none -T link.ld $(C32_OBJS) $(ASM_OBJS) -o tmp/main.elf
	objcopy -O binary tmp/main.elf main.bin

disk.img: main.bin
	cp main.bin disk.img
	truncate -s 32M disk.img