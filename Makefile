LLVM_VERSION:=22

CC:=clang-$(LLVM_VERSION)
LLVM_TOOLS_SUFFIX=
LD:=ld.lld$(LLVM_TOOLS_SUFFIX)
ASM:=nasm

BOOTLOADER_CONFIG:=\
-DBOOTLOADER_RESERVED_SECTORS=512 \
-DSECTORS_PER_CLUSTER=8 \
-DSECTORS_PER_FAT32=512 \
-DFAT32_RESERVED_SECTORS=16 \

CFLAGS_CC_SPECIFIC:=-Xclang -fmerge-functions -fno-cxx-exceptions -fnew-alignment=16
CFLAGS_CC_SPECIFIC_DBG:=-fdebug-macro -mno-omit-leaf-frame-pointer
CFLAGS_DBG:=-g -fno-omit-frame-pointer -DDEBUG $(CFLAGS_CC_SPECIFIC_DBG)

CFLAGS_OPT_TARGETS=

CFLAGS:=\
-m64 -march=haswell -std=c++26 -stdlib=libstdc++ -ffreestanding -ffunction-sections -fdata-sections -flto=thin -funified-lto \
-nostdlib -mno-red-zone -fno-pie -fno-rtti -fno-stack-protector -fno-use-cxa-atexit \
-Oz -fwrapv -fno-finite-loops -felide-constructors -fno-exceptions \
-Isrc -Isrc/std -Wall -Wextra -ftemplate-backtrace-limit=0 -ferror-limit=0 -Werror=return-type \
-Wno-pointer-arith -Wstrict-aliasing -Wno-writable-strings -Wno-unused-parameter -Wno-unused-function -Wno-nontrivial-memcall \
$(CFLAGS_CC_SPECIFIC) $(CFLAGS_DBG) $(CFLAGS_OPT_TARGETS)
# -fsanitize=alignment,nonnull-attribute,object-size,return,shift,unreachable -fsanitize-trap=alignment,nonnull-attribute,object-size,return,shift,unreachable \

CFLAGS_HOST:=-Og -march=native -std=c++26 -lstdc++ -g

LDFLAGS_INC:=--lto=thin --ignore-data-address-equality --ignore-function-address-equality
LDFLAGS_FIN:=-gc-sections --lto=thin --icf=all --ignore-data-address-equality --ignore-function-address-equality

IWYUFLAGS:=-std=c++26 -Isrc -Isrc/std -I/usr/lib/llvm-$(LLVM_VERSION)/lib/clang/$(LLVM_VERSION)/include
CLANG_TIDY_CHECKS_EXTRA:=*,-llvmlibc-callee-namespace,$(CLANG_TIDY_CHECKS)
CLANG_TIDY_CHECKS:=-bugprone-suspicious-include,-clang-analyzer-valist.Uninitialized
CLANG_TIDY_FLAGS:=-checks=$(CLANG_TIDY_CHECKS_EXTRA) -header-filter=.*
CLANG_TIDY_CC_FLAGS:=-std=c++26 -Isrc -Isrc/std
OBJDUMP_FLAGS:=-M intel --print-imm-hex --show-all-symbols --demangle --disassemble --source --debug-inlined-funcs=ascii --debug-vars=ascii --debug-indent=0

ASM_SRC:=$(shell find ./src -name "*.asm" | sed -e "s/^\.\///g")
C_HDR:=$(shell find ./src -name "*.hpp" | sed -e "s/^\.\///g")
C_SRC:=$(shell find ./src -name "*.cpp" | sed -e "s/^\.\///g")
ASM_OBJ:=$(patsubst src/%.asm,tmp/%.o,$(ASM_SRC))
DISK_INCLUDES=$(shell cd disk_include && echo * && cd ..)

QEMU_STORAGE:=-drive id=disk,format=raw,file=disk.img,if=none -device ahci,id=ahci -device ide-hd,drive=disk,bus=ahci.0
QEMU_STORAGE_AUX:=-drive id=disk2,format=raw,file=disk_2.img,if=ide
QEMU_NETWORK:=-netdev user,id=u1,hostfwd=tcp::5555-:80,hostfwd=udp::5556-:80 -device e1000,netdev=u1 -object filter-dump,id=f1,netdev=u1,file=tmp/dump.pcap
QEMU_VIDEO:=-vga vmware
QEMU_AUDIO:=-audiodev sdl,id=pa1 -machine pcspk-audiodev=pa1 -device AC97
QEMU_MISC:=-m 4G -cpu Haswell -smp 1
QEMU_FLAGS:=$(QEMU_STORAGE) $(QEMU_NETWORK) $(QEMU_VIDEO) $(QEMU_AUDIO) $(QEMU_MISC)

LOCAL_IP:=192.168.0.28
#192.168.1.2

.PHONY: default clean start start-trace start-trace-2 start-dbg iwyu tidy format
default: disk.img
clean:
	@rm -rf tmp/*
	@rm -f disk.img disk_2.img

# Final assembly
disk.img: tmp/fattener tmp/kernel.img tmp/bootloader.img tmp/fat32.img tmp/fsinfo.img tmp/flash.img
	@mkdir -p tmp/root
	@cp -r disk_include/* tmp/root
	@cp tmp/kernel.img tmp/root
	@cp tmp/symbols.txt tmp/root
	@cp tmp/symbols2.txt tmp/root
	./tmp/fattener tmp/root
	@truncate -s 128M disk.img
#	cat tmp/flash.img disk.img > disk_2.img

start: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) &
start-flash: disk_2.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) $(QEMU_STORAGE_AUX) &
start-trace: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -d cpu_reset &
start-trace-2: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -d int,cpu_reset &
start-dbg-noattatch: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) -s -S -d cpu_reset -monitor telnet:$(LOCAL_IP):5557,server,nowait > /dev/null &
start-dbg: start-dbg-noattatch attatch
start-ping: disk.img
	qemu-system-x86_64.exe $(QEMU_FLAGS) &
	telnet $(LOCAL_IP) 5555

attatch: 
	lldb -O "gdb-remote $(LOCAL_IP):1234" -s lldb/lldb-commands.txt

monitor:
	telnet $(LOCAL_IP) 5557 | tee -a tmp/monitor.log

$(ASM_OBJ) : tmp/%.o : src/%.asm
	$(ASM) -f elf64 -o $@ $<
tmp/obj.o : $(C_SRC) $(C_HDR)
	echo "$(patsubst %,#include \"../%\"\n,$(C_SRC))\n#include \"../bootloader/stage2.cpp\"" > tmp/all.cpp
	$(CC) $(CFLAGS) -DKERNEL -o $@ -c tmp/all.cpp

tmp/kernel.elf: $(ASM_OBJ) tmp/obj.o
	$(LD) $(LDFLAGS_INC) -e kernel_main -r -o $@ $^
#	llvm-objdump $(OBJDUMP_FLAGS) $@ > tmp/base.S
tmp/kernel_noentry.elf: tmp/kernel.elf
	llvm-objcopy$(LLVM_TOOLS_SUFFIX) --weaken -N kernel_main $^ $@
tmp/kernel.img.elf: tmp/kernel.elf link.ld
	$(LD) $(LDFLAGS_FIN) -e kernel_main -T link.ld -o $@ tmp/kernel.elf

tmp/kernel.img: tmp/kernel.img.elf
	llvm-objdump$(LLVM_TOOLS_SUFFIX) $(OBJDUMP_FLAGS) $^ > tmp/kernel.S
	llvm-objdump$(LLVM_TOOLS_SUFFIX) --syms --demangle $^ > tmp/symbols.txt
	llvm-objcopy$(LLVM_TOOLS_SUFFIX) -O binary $^ $@

tmp/bootloader.img: tmp/kernel_noentry.elf tmp/stage0.o tmp/stage1.o tmp/stage2.o
	$(LD) $(LDFLAGS_FIN) -e stage2_main -T bootloader/bootloader.ld $^ -o $@.elf 
	llvm-objdump$(LLVM_TOOLS_SUFFIX) $(OBJDUMP_FLAGS) $@.elf > tmp/bootloader.S
	llvm-objdump$(LLVM_TOOLS_SUFFIX) --syms --demangle $@.elf > tmp/symbols2.txt
	objcopy -O binary $@.elf $@

tmp/flash.img tmp/fat32.img tmp/fsinfo.img: tmp/%.img : bootloader/%.asm
	$(ASM) $(BOOTLOADER_CONFIG) -f bin $< -o $@
tmp/stage0.o tmp/stage1.o: tmp/%.o : bootloader/%.asm
	$(ASM) $(BOOTLOADER_CONFIG) -f elf64 $< -o $@
tmp/stage2.o : bootloader/stage2.cpp
	$(CC) $(CFLAGS) -o $@ -c $<
tmp/fattener: bootloader/fattener.cpp
	$(CC) $(CFLAGS_HOST) $(BOOTLOADER_CONFIG) $< -o $@

format:
	clang-format$(LLVM_TOOLS_SUFFIX) -i $(C_SRC) $(C_HDR) $(BOOTLOADER_SRC)
tidy: tmp/obj.o
	clang-tidy$(LLVM_TOOLS_SUFFIX) $(CLANG_TIDY_FLAGS) tmp/all.cpp -- $(CLANG_TIDY_CC_FLAGS) > tmp/tidy_spam.txt
iwyu: $(C_SRC) $(C_HDR) $(BOOTLOADER_SRC)
	for file in $^; do \
		iwyu $(IWYUFLAGS) $$file; \
	done