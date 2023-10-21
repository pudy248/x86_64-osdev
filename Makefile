COMPONENTS=$(filter-out template,$(patsubst files/%/make.cfg,%,$(wildcard files/**/make.cfg)))

ADDITIONAL_FILES=models/cow.obj

QEMU_STORAGE=-drive id=disk,format=raw,file=disk.img,if=none -device ahci,id=ahci -device ide-hd,drive=disk,bus=ahci.0
QEMU_VIDEO=-vga qxl
QEMU_AUDIO=-audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97
QEMU_MISC=-m 4G -smp 2
QEMU_FLAGS=$(QEMU_STORAGE) $(QEMU_VIDEO) $(QEMU_AUDIO) $(QEMU_MISC)

.PHONY: default clean bootloader $(COMPONENTS) start start-trace start-gdb

default: disk.img
tmp/init:
	@mkdir tmp/bootloader $(addprefix tmp/,$(COMPONENTS))
	@touch tmp/init
clean:
	@rm -f disk.img
	@rm -rf tmp/*

bootloader: $(COMPONENTS)
	@make -f bootloader/Makefile --no-print-directory
$(COMPONENTS) : % : tmp/init
	@make -f Makefile_template THIS_FILE=$@ --no-print-directory

fattener: fattener.c
	@$(CC) fattener.c -o fattener -g $(CCOPTIONALFLAGS)
tmp/diskflasher.img: diskflasher.asm
	nasm diskflasher.asm -f bin -o tmp/diskflasher.img
disk.img: fattener bootloader $(COMPONENTS)
	./fattener $(patsubst %,tmp/%.img,$(COMPONENTS)) $(ADDITIONAL_FILES)
	@truncate -s 64M disk.img
disk_2.img: disk.img tmp/diskflasher.img
	cat tmp/diskflasher.img disk.img > disk_2.img


start: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS)
start-trace: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -d int,cpu_reset
start-gdb: disk.img tmp/main.bin
	qemu-system-i386.exe $(QEMU_FLAGS) -s -S &
	gf2 tmp/main.elf