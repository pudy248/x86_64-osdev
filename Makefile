CLANG_ENABLE:=1
ifdef CLANG_ENABLE
	CC:=$(wildcard /usr/bin/clang) $(wildcard /usr/bin/clang-1*)
	LD:=$(wildcard /usr/bin/ld.lld) $(wildcard /usr/bin/ld.lld-1*)
	CFLAGS_CC:=-Xclang -fmerge-functions -fno-cxx-exceptions -fnew-alignment=16
	CFLAGS_CC_DBG:=-fdebug-macro
else
	CC:=gcc
	LD:=ld
	CFLAGS_CC:=
	CFLAGS_CC_DBG:=
endif

ASM:=nasm
ASMFLAGS:=-f elf64

CFLAGS_DBG:= -g $(CFLAGS_CC_DBG)
CFLAGS_WEVERYTHING:=-Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-c++14-compat -Wno-old-style-cast -Wno-unsafe-buffer-usage
CFLAGS:=\
-m64 -march=haswell -std=c++23 -ffreestanding -ffunction-sections -fdata-sections \
-nostdlib -mno-red-zone -fno-pie -fno-rtti -fno-stack-protector -fno-use-cxa-atexit \
-fno-exceptions -fno-finite-loops -felide-constructors \
-Os -Iinclude -Iinclude/std \
-Wall -Wextra \
-Wno-pointer-arith -Wno-strict-aliasing -Wno-writable-strings -Wno-unused-parameter \
$(CFLAGS_CC) $(CFLAGS_DBG)

LDFLAGS_I:=
LDFLAGS_F:=-gc-sections

ASM_SRC:=$(wildcard src/**/*.asm) $(wildcard src/*.asm)
C_SRC:=$(wildcard src/**/*.cpp) $(wildcard src/*.cpp)
ASM_OBJ:=$(patsubst src/%.asm,tmp/%.o,$(ASM_SRC))
DISK_INCLUDES=$(shell cd disk_include && echo * && cd ..)

QEMU_STORAGE:=-drive id=disk,format=raw,file=disk.img,if=none -device ahci,id=ahci -device ide-hd,drive=disk,bus=ahci.0
QEMU_STORAGE_AUX:=-drive id=disk2,format=raw,file=disk_2.img,if=ide
QEMU_NETWORK:=-netdev user,id=u1,hostfwd=tcp::5555-:80,hostfwd=udp::5556-:80 -device e1000,netdev=u1 -object filter-dump,id=f1,netdev=u1,file=dump.pcap
QEMU_VIDEO:=-vga vmware
QEMU_AUDIO:=-audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97
QEMU_MISC:=-m 4G -cpu Haswell
QEMU_FLAGS:=$(QEMU_STORAGE) $(QEMU_NETWORK) $(QEMU_VIDEO) $(QEMU_AUDIO) $(QEMU_MISC)

#LOCAL_IP:=192.168.0.15
LOCAL_IP:=172.29.244.210

.PHONY: default clean start start-trace start-gdb
default: disk_2.img
clean:
	@rm -f disk.img disk_2.img dump.pcap fattener
	@rm -rf tmp/*

disk.img: tmp/kernel.img tmp/bootloader.img fattener.cpp
	$(CC) fattener.cpp -o fattener
	./fattener tmp/kernel.img $(shell echo disk_include/*)
	@truncate -s 64M disk.img
disk_2.img: disk.img tmp/diskflasher.img
	cat tmp/diskflasher.img disk.img > disk_2.img

start: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS)
start-flash: disk_2.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) $(QEMU_STORAGE_AUX)
start-trace: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -d int,cpu_reset
start-gdb: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -s -S > /dev/null 2> /dev/null &
	gdb -tui -ex "add-symbol-file tmp/kernel.img.elf" -ex "add-symbol-file tmp/bootloader.img.elf" -ex "target remote $(LOCAL_IP):1234"
#	gdbfrontend -G "-s tmp/bootloader.img.elf -s tmp/kernel.img.elf -ex \"target remote $(LOCAL_IP):1234\""
start-ping: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) &
	telnet $(LOCAL_IP) 5556

tmp/diskflasher.img: diskflasher.asm
	nasm $< -f bin -o $@

$(ASM_OBJ) : tmp/%.o : src/%.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
tmp/obj.o : $(C_SRC)
	echo "$(patsubst %,#include \"../%\"\n,$(C_SRC))" > tmp/all.cpp
	$(CC) $(CFLAGS) -o $@ -c tmp/all.cpp

tmp/kernel.elf: $(ASM_OBJ) tmp/obj.o
	$(LD) $(LDFLAGS_I) -e kernel_main -r -o $@ $^
	@objdump -d $^ > tmp/base.S 2> /dev/null

tmp/kernel.img.elf: tmp/kernel.elf link.ld
	$(LD) $(LDFLAGS_F) -e kernel_main -T link.ld -o $@ tmp/kernel.elf

tmp/kernel.img: tmp/kernel.img.elf
	@objdump -d $^ > tmp/kernel.S 2> /dev/null
	@objcopy -O binary $< $@

BOOTLOADER_ASM:=$(wildcard bootloader/**/*.asm) $(wildcard bootloader/*.asm)
BOOTLOADER_ASM_OBJ:=$(patsubst bootloader/%.asm,tmp/%.o,$(BOOTLOADER_ASM))
BOOTLOADER_SRC:=$(wildcard bootloader/**/*.cpp) $(wildcard bootloader/*.cpp)
BOOTLOADER_C_OBJ:=$(patsubst bootloader/%.cpp,tmp/%.o,$(BOOTLOADER_SRC))

$(BOOTLOADER_ASM_OBJ) : tmp/%.o : bootloader/%.asm bootloader/constants.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
$(BOOTLOADER_C_OBJ): tmp/%.o : bootloader/%.cpp
	$(CC) $(CFLAGS) -o $@ -c $<

tmp/bootloader.img: $(BOOTLOADER_ASM_OBJ) $(BOOTLOADER_C_OBJ) bootloader/bootloader.ld tmp/kernel.img.elf
	objcopy -S -x -K kernel_main tmp/kernel.img.elf tmp/kernel_entry.elf
	objcopy -N kernel_main tmp/kernel.elf tmp/kernel_noentry.elf
	ld $(LDFLAGS_F) -e stage2_main -T bootloader/bootloader.ld -o tmp/bootloader.img.elf $(BOOTLOADER_ASM_OBJ) $(BOOTLOADER_C_OBJ) tmp/kernel_noentry.elf -R tmp/kernel_entry.elf
	@objdump -d tmp/bootloader.img.elf > tmp/bootloader.S 2> /dev/null
	@objcopy -O binary tmp/bootloader.img.elf tmp/bootloader.img
