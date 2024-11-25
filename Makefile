LLVM_VERSION:=20

CC:=clang-$(LLVM_VERSION)
LLVM_TOOLS_SUFFIX=
LD:=ld.lld$(LLVM_TOOLS_SUFFIX)

CFLAGS_CC_SPECIFIC:=-Xclang -fmerge-functions -fno-cxx-exceptions -fnew-alignment=16
CFLAGS_CC_SPECIFIC_DBG:=-fdebug-macro -mno-omit-leaf-frame-pointer
CFLAGS_DBG:=-g -fno-omit-frame-pointer -DDEBUG $(CFLAGS_CC_SPECIFIC_DBG)

CFLAGS_OPT_TARGETS=

CFLAGS:=\
-m64 -march=haswell -std=c++26 -ffreestanding -ffunction-sections -fdata-sections -flto=thin -funified-lto \
-nostdlib -mno-red-zone -fno-pie -fno-rtti -fno-stack-protector -fno-use-cxa-atexit -fwrapv \
-Oz -ffast-math -fno-finite-loops -felide-constructors -fno-exceptions \
-Isrc -Isrc/std -Wall -Wextra -ftemplate-backtrace-limit=0 \
-Wno-pointer-arith -Wstrict-aliasing -Wno-writable-strings -Wno-unused-parameter \
$(CFLAGS_CC_SPECIFIC) $(CFLAGS_DBG) $(CFLAGS_OPT_TARGETS)
CFLAGS_KERNEL:=-DKERNEL

LDFLAGS_INC:=--lto=thin --ignore-data-address-equality --ignore-function-address-equality
LDFLAGS_FIN:=-gc-sections --lto=thin --icf=all --ignore-data-address-equality --ignore-function-address-equality

ASM:=nasm
ASMFLAGS:=-f elf64

IWYUFLAGS:=-std=c++26 -Isrc -Isrc/std -I/usr/lib/llvm-$(LLVM_VERSION)/lib/clang/$(LLVM_VERSION)/include
CLANG_TIDY_CHECKS_EXTRA:=*,-llvmlibc-callee-namespace,$(CLANG_TIDY_CHECKS)
CLANG_TIDY_CHECKS:=-bugprone-suspicious-include,-clang-analyzer-valist.Uninitialized
CLANG_TIDY_FLAGS:=-checks=$(CLANG_TIDY_CHECKS_EXTRA) -header-filter=.*
CLANG_TIDY_CC_FLAGS:=-std=c++26 -Isrc -Isrc/std

OBJDUMP_FLAGS:=-M intel --print-imm-hex --show-all-symbols --demangle --disassemble --source

ASM_SRC:=$(shell find ./src -name "*.asm" | sed -e "s/^\.\///g")
C_HDR:=$(shell find ./src -name "*.hpp" | sed -e "s/^\.\///g")
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
QEMU_MISC:=-m 4G -cpu Haswell -smp 1
QEMU_FLAGS:=$(QEMU_STORAGE) $(QEMU_NETWORK) $(QEMU_VIDEO) $(QEMU_AUDIO) $(QEMU_MISC)

LOCAL_IP:=192.168.1.203

.PHONY: default clean start start-trace start-trace-2 start-dbg iwyu tidy format
default: disk.img
clean:
	@rm -f disk.img disk_2.img
	@rm -rf tmp/*

disk.img: tmp/kernel.img tmp/bootloader.img fattener.cpp tmp/diskflasher.img
	$(CC) fattener.cpp -o tmp/fattener
	./tmp/fattener tmp/kernel.img tmp/symbols.txt tmp/symbols2.txt $(shell echo disk_include/*)
	@truncate -s 80M disk.img
	cat tmp/diskflasher.img disk.img > disk_2.img

start: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS)
start-flash: disk_2.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) $(QEMU_STORAGE_AUX)
start-trace: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -d cpu_reset
start-trace-2: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -d int,cpu_reset
start-dbg: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -s -S > /dev/null -d cpu_reset &
	lldb -O "gdb-remote $(LOCAL_IP):1234" -s lldb/lldb-commands.txt
start-ping: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) &
	telnet $(LOCAL_IP) 5555

tmp/diskflasher.img: diskflasher.asm
	nasm $< -f bin -o $@

$(ASM_OBJ) : tmp/%.o : src/%.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
tmp/obj.o : $(C_SRC) $(C_HDR)
	echo "$(patsubst %,#include \"../%\"\n,$(C_SRC))\n#include \"../bootloader/stage2.cpp\"" > tmp/all.cpp
	$(CC) $(CFLAGS) $(CFLAGS_KERNEL) -o $@ -c tmp/all.cpp

tmp/kernel.elf: $(ASM_OBJ) tmp/obj.o
	$(LD) $(LDFLAGS_INC) -e kernel_main -r -o $@ $^
#	llvm-objdump $(OBJDUMP_FLAGS) $@ > tmp/base.S

tmp/kernel.img.elf: tmp/kernel.elf link.ld
	$(LD) $(LDFLAGS_FIN) -e kernel_main -T link.ld -o $@ tmp/kernel.elf

tmp/kernel.img: tmp/kernel.img.elf
	llvm-objdump$(LLVM_TOOLS_SUFFIX) $(OBJDUMP_FLAGS) $^ > tmp/kernel.S
	llvm-objdump$(LLVM_TOOLS_SUFFIX) --syms --demangle $^ > tmp/symbols.txt
	llvm-objcopy$(LLVM_TOOLS_SUFFIX) -O binary $< $@

$(BOOTLOADER_ASM_OBJ) : tmp/%.o : bootloader/%.asm bootloader/constants.asm
	$(ASM) $(ASMFLAGS) -o $@ $<
$(BOOTLOADER_C_OBJ): tmp/%.o : bootloader/%.cpp
	$(CC) $(CFLAGS) -o $@ -c $<

tmp/bootloader.img: $(BOOTLOADER_ASM_OBJ) $(BOOTLOADER_C_OBJ) bootloader/bootloader.ld tmp/kernel.img.elf
#	llvm-objcopy$(LLVM_TOOLS_SUFFIX) -SxK kernel_main tmp/kernel.img.elf tmp/kernel_entry.elf
	llvm-objcopy$(LLVM_TOOLS_SUFFIX) --weaken -N kernel_main tmp/kernel.elf tmp/kernel_noentry.elf
	$(LD) $(LDFLAGS_FIN) -e stage2_main -T bootloader/bootloader.ld -o tmp/bootloader.img.elf $(BOOTLOADER_ASM_OBJ) $(BOOTLOADER_C_OBJ) tmp/kernel_noentry.elf
	
	llvm-objdump$(LLVM_TOOLS_SUFFIX) $(OBJDUMP_FLAGS) tmp/bootloader.img.elf > tmp/bootloader.S
	llvm-objdump$(LLVM_TOOLS_SUFFIX) --syms --demangle tmp/bootloader.img.elf > tmp/symbols2.txt
	objcopy -O binary tmp/bootloader.img.elf tmp/bootloader.img

format:
	clang-format$(LLVM_TOOLS_SUFFIX) -i $(C_SRC) $(C_HDR) $(BOOTLOADER_SRC)

tidy: tmp/obj.o
	clang-tidy$(LLVM_TOOLS_SUFFIX) $(CLANG_TIDY_FLAGS) tmp/all.cpp -- $(CLANG_TIDY_CC_FLAGS) > tmp/tidy_spam.txt

iwyu: $(C_SRC) $(C_HDR) $(BOOTLOADER_SRC)
	for file in $^; do \
		iwyu $(IWYUFLAGS) $$file; \
	done