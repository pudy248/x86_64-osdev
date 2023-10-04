CC=clang
ASM=nasm
ASMFLAGS=-f elf32 -g
CCREQUIREDFLAGS=-nostdlib -nostdinc -ffreestanding -fno-pie -Wno-attributes
CCOPTIONALFLAGS=-Iinclude -Oz -g
CC32FLAGS=-m32

ASM_SRCS=$(wildcard src/**/*.asm) $(wildcard src/*.asm)
C32_SRCS=$(wildcard src/**/*.c) $(wildcard src/*.c)
ASM_OBJS=$(patsubst %.asm,tmp/%.o,$(notdir $(ASM_SRCS)))
C32_OBJS=$(patsubst %.c,tmp/%.o,$(notdir $(C32_SRCS)))
OBJS=$(ASM_OBJS) $(C16_OBJS) $(C32_OBJS)

_pos = $(if $(findstring $1,$2),$(call _pos,$1,\
       $(wordlist 2,$(words $2),$2),x $3),$3)
pos = $(words $(call _pos,$1,$2))

.PHONY: clean size echo
default: .depend disk.img
-include .depend

all: disk.img

.depend:
	$(CC) -Iinclude -MM $(C32_SRCS) -MT "$(patsubst %.c,tmp/%.o,$(notdir $<))" > "$@"

start: disk.img
	qemu-system-x86_64.exe -m 4G -smp 1 -vga qxl -audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97 -drive format=raw,file=disk.img

start-trace: disk.img
	qemu-system-x86_64.exe -m 4G -smp 1 -vga qxl -audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97 -drive format=raw,file=disk.img -d int,cpu_reset

start-gdb: disk.img main.bin
	qemu-system-i386.exe -m 4G -smp 1 -vga qxl -audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97 -drive format=raw,file=disk.img -s -S &
	gf2 tmp/main.elf
	#target remote 172.29.247.158:1234

size: main.bin
	@wc -c < main.bin

clean:
	rm -f .depend
	rm -f tmp/*
	rm -f main.bin main.img

$(ASM_OBJS): $(ASM_SRCS)
	$(ASM) $(word $(call pos,$@,$(ASM_OBJS)),$(ASM_SRCS)) -o $@ $(ASMFLAGS)

$(C32_OBJS): $(C32_SRCS)
	$(CC) $(CCREQUIREDFLAGS) $(CCOPTIONALFLAGS) $(CC32FLAGS) -o $@ -c $(word $(call pos,$@,$(C32_OBJS)),$(C32_SRCS))

main.bin: $(OBJS)
	ld -melf_i386 -N --build-id=none -T link.ld $(OBJS) -o tmp/main.elf
	objcopy -O binary tmp/main.elf main.bin

floppy.img: main.bin
	cp main.bin floppy.img
	truncate -s 1440k floppy.img
disk.img: main.bin
	cp main.bin disk.img
	truncate -s 32M disk.img