CC:=/usr/bin/clang-18
LD:=/usr/bin/ld.lld-18
CFLAGS_CC:=-Xclang -fmerge-functions -fno-cxx-exceptions -fnew-alignment=16
CFLAGS_CC_DBG:=-fdebug-macro -mno-omit-leaf-frame-pointer
# 

ASM:=nasm
ASMFLAGS:=-f elf64

CFLAGS_DBG:= -g -fno-omit-frame-pointer $(CFLAGS_CC_DBG)
# 

CFLAGS:=\
-m64 -march=haswell -std=c++23 -ffreestanding -ffunction-sections -fdata-sections -flto=thin -funified-lto \
-nostdlib -mno-red-zone -fno-pie -fno-rtti -fno-stack-protector -fno-use-cxa-atexit \
-fno-finite-loops -felide-constructors -fno-exceptions \
-Oz -Iinclude -Iinclude/std -Wall -Wextra \
-Wno-pointer-arith -Wno-strict-aliasing -Wno-writable-strings -Wno-unused-parameter \
$(CFLAGS_CC) $(CFLAGS_DBG)
CFLAGS_WEVERYTHING:=-Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-c++14-compat -Wno-old-style-cast -Wno-unsafe-buffer-usage

IWYUFLAGS:=-std=c++23 -Iinclude -Iinclude/std -I/usr/lib/llvm-18/lib/clang/18/include

LDFLAGS_INC:=--lto=thin
LDFLAGS_FIN:=-gc-sections --lto=thin

ASM_SRC:=$(shell find ./src -name "*.asm" | sed -e "s/^\.\///g")
C_HDR:=$(shell find ./include -name "*.hpp" | sed -e "s/^\.\///g")
C_SRC:=$(shell find ./src -name "*.cpp" | sed -e "s/^\.\///g")
ASM_OBJ:=$(patsubst src/%.asm,tmp/%.o,$(ASM_SRC))
DISK_INCLUDES=$(shell cd disk_include && echo * && cd ..)

BOOTLOADER_ASM:=$(shell find ./bootloader -name "*.asm" | sed -e "s/^\.\///g")
BOOTLOADER_ASM_OBJ:=$(patsubst bootloader/%.asm,tmp/%.o,$(BOOTLOADER_ASM))
BOOTLOADER_SRC:=$(shell find ./bootloader -name "*.cpp" | sed -e "s/^\.\///g")
BOOTLOADER_C_OBJ:=$(patsubst bootloader/%.cpp,tmp/%.o,$(BOOTLOADER_SRC))

QEMU_STORAGE:=-drive id=disk,format=raw,file=disk.img,if=none -device ahci,id=ahci -device ide-hd,drive=disk,bus=ahci.0
QEMU_STORAGE_AUX:=-drive id=disk2,format=raw,file=disk_2.img,if=ide
QEMU_NETWORK:=-netdev user,id=u1,hostfwd=tcp::5555-:80,hostfwd=udp::5556-:80 -device e1000,netdev=u1 -object filter-dump,id=f1,netdev=u1,file=tmp/dump.pcap
QEMU_VIDEO:=-vga vmware
QEMU_AUDIO:=-audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97
QEMU_MISC:=-m 4G -cpu Haswell
QEMU_FLAGS:=$(QEMU_STORAGE) $(QEMU_NETWORK) $(QEMU_VIDEO) $(QEMU_AUDIO) $(QEMU_MISC)

#LOCAL_IP:=192.168.0.15
LOCAL_IP:=172.29.244.210

.PHONY: default clean start start-trace start-db include-check
default: disk_2.img
clean:
	@rm -f disk.img disk_2.img dump.pcap fattener
	@rm -rf tmp/*

disk.img: tmp/kernel.img tmp/bootloader.img fattener.cpp
	$(CC) fattener.cpp -o fattener
	./fattener tmp/kernel.img tmp/symbols.txt tmp/symbols2.txt $(shell echo disk_include/*)
#	@truncate -s 64M disk.img
disk_2.img: disk.img tmp/diskflasher.img
	cat tmp/diskflasher.img disk.img > disk_2.img

start: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS)
start-flash: disk_2.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) $(QEMU_STORAGE_AUX)
start-trace: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -d int,cpu_reset
start-db: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -s -S > /dev/null 2> /dev/null &
	lldb-18 -O "gdb-remote $(LOCAL_IP):1234" -s lldb/lldb-commands.txt
start-ping: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) &
	telnet $(LOCAL_IP) 5556

tmp/diskflasher.img: diskflasher.asm
	nasm $< -f bin -o $@

$(ASM_OBJ) : tmp/%.o : src/%.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
tmp/obj.o : $(C_SRC)
	echo "$(patsubst %,#include \"../%\"\n,$(C_SRC))\n#include \"../bootloader/stage2.cpp\"\n" > tmp/all.cpp
	$(CC) $(CFLAGS) -D KERNEL -o $@ -c tmp/all.cpp

tmp/kernel.elf: $(ASM_OBJ) tmp/obj.o
	$(LD) $(LDFLAGS_INC) -e kernel_main -r -o $@ $^
#	llvm-objdump --x86-asm-syntax=intel --demangle -d $@ > tmp/base.S

tmp/kernel.img.elf: tmp/kernel.elf link.ld
	$(LD) $(LDFLAGS_FIN) -e kernel_main -T link.ld -o $@ tmp/kernel.elf

tmp/kernel.img: tmp/kernel.img.elf
	llvm-objdump --x86-asm-syntax=intel --demangle -d $^ > tmp/kernel.S
	llvm-objdump --syms --demangle $^ > tmp/symbols.txt
	llvm-objcopy -O binary $< $@

$(BOOTLOADER_ASM_OBJ) : tmp/%.o : bootloader/%.asm bootloader/constants.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
$(BOOTLOADER_C_OBJ): tmp/%.o : bootloader/%.cpp
	$(CC) $(CFLAGS) -o $@ -c $<

tmp/bootloader.img: $(BOOTLOADER_ASM_OBJ) $(BOOTLOADER_C_OBJ) bootloader/bootloader.ld tmp/kernel.img.elf
#	llvm-objcopy -SxK kernel_main tmp/kernel.img.elf tmp/kernel_entry.elf
	llvm-objcopy --weaken -N kernel_main tmp/kernel.elf tmp/kernel_noentry.elf
	$(LD) $(LDFLAGS_FIN) -e stage2_main -T bootloader/bootloader.ld -o tmp/bootloader.img.elf $(BOOTLOADER_ASM_OBJ) $(BOOTLOADER_C_OBJ) tmp/kernel_noentry.elf
	
	llvm-objdump --x86-asm-syntax=intel --demangle -d tmp/bootloader.img.elf > tmp/bootloader.S
	llvm-objdump --syms --demangle tmp/bootloader.img.elf > tmp/symbols2.txt
	objcopy -O binary tmp/bootloader.img.elf tmp/bootloader.img

format:
	clang-format -i $(C_SRC) $(C_HDR) $(BOOTLOADER_SRC)

iwyu: 
	for file in $(C_SRC) $(C_HDR) $(BOOTLOADER_SRC); do \
		iwyu $(IWYUFLAGS) $$file; \
	done