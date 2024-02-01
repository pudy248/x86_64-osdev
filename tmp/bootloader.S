
tmp/bootloader.img.elf:     file format elf64-x86-64


Disassembly of section .bootloader:

0000000000007c00 <stage0_main>:
    7c00:	31 c0                	xor    %eax,%eax
    7c02:	8e d8                	mov    %eax,%ds
    7c04:	8e c0                	mov    %eax,%es
    7c06:	8e d0                	mov    %eax,%ss
    7c08:	bc 00 7c be d8       	mov    $0xd8be7c00,%esp
    7c0d:	7c 83                	jl     7b92 <stage0_main-0x6e>
    7c0f:	3e d6                	ds (bad) 
    7c11:	7c 00                	jl     7c13 <stage0_main+0x13>
    7c13:	74 16                	je     7c2b <load_sectors>

0000000000007c15 <load_block>:
    7c15:	b4 42                	mov    $0x42,%ah
    7c17:	cd 13                	int    $0x13
    7c19:	81 06 de 7c 00 08    	addl   $0x8007cde,(%rsi)
    7c1f:	66 83 06 e0          	addw   $0xffe0,(%rsi)
    7c23:	7c 40                	jl     7c65 <load_sectors+0x3a>
    7c25:	ff 0e                	decl   (%rsi)
    7c27:	d6                   	(bad)  
    7c28:	7c 75                	jl     7c9f <block_err_msg+0x5>
    7c2a:	ea                   	(bad)  

0000000000007c2b <load_sectors>:
    7c2b:	b4 42                	mov    $0x42,%ah
    7c2d:	8b 0e                	mov    (%rsi),%ecx
    7c2f:	d4                   	(bad)  
    7c30:	7c 89                	jl     7bbb <stage0_main-0x45>
    7c32:	0e                   	(bad)  
    7c33:	da 7c cd 13          	fidivrl 0x13(%rbp,%rcx,8)
    7c37:	b8 00 70 8e c0       	mov    $0xc08e7000,%eax
    7c3c:	bf 00 00 57 66       	mov    $0x66570000,%edi
    7c41:	b9 00 10 00 00       	mov    $0x1000,%ecx
    7c46:	66 31 c0             	xor    %ax,%ax
    7c49:	f3 66 ab             	rep stos %ax,%es:(%rdi)
    7c4c:	5f                   	pop    %rdi
    7c4d:	66 b8 03 10          	mov    $0x1003,%ax
    7c51:	07                   	(bad)  
    7c52:	00 26                	add    %ah,(%rsi)
    7c54:	66 89 05 66 b9 04 00 	mov    %ax,0x4b966(%rip)        # 535c1 <sig3+0x2b5c5>
    7c5b:	00 00                	add    %al,(%rax)
    7c5d:	66 b8 03 20          	mov    $0x2003,%ax
    7c61:	07                   	(bad)  
    7c62:	00                   	.byte 0x0
    7c63:	bf                   	.byte 0xbf
    7c64:	00 10                	add    %dl,(%rax)

0000000000007c66 <load_sectors.PDPLoop>:
    7c66:	26 66 89 05 66 05 00 	es mov %ax,0x10000566(%rip)        # 100081d4 <kernel_main+0xfdf3fb4>
    7c6d:	10 
    7c6e:	00 00                	add    %al,(%rax)
    7c70:	83 c7 08             	add    $0x8,%edi
    7c73:	66 49 75 ef          	data16 rex.WB jne 7c66 <load_sectors.PDPLoop>
    7c77:	66 b9 00 08          	mov    $0x800,%cx
    7c7b:	00 00                	add    %al,(%rax)
    7c7d:	66 b8 83 00          	mov    $0x83,%ax
    7c81:	00 00                	add    %al,(%rax)
    7c83:	bf                   	.byte 0xbf
    7c84:	00 20                	add    %ah,(%rax)

0000000000007c86 <load_sectors.PDLoop>:
    7c86:	26 66 89 05 66 05 00 	es mov %ax,0x566(%rip)        # 81f4 <stor_regs+0xa2>
    7c8d:	00 
    7c8e:	20 00                	and    %al,(%rax)
    7c90:	83 c7 08             	add    $0x8,%edi
    7c93:	66 49 75 ef          	data16 rex.WB jne 7c86 <load_sectors.PDLoop>
    7c97:	e9                   	.byte 0xe9
    7c98:	66                   	data16
    7c99:	01                   	.byte 0x1

0000000000007c9a <block_err_msg>:
    7c9a:	4c 6f                	rex.WR outsl %ds:(%rsi),(%dx)
    7c9c:	61                   	(bad)  
    7c9d:	64 69 6e 67 20 6d 6f 	imul   $0x726f6d20,%fs:0x67(%rsi),%ebp
    7ca4:	72 
    7ca5:	65 20 74 68 61       	and    %dh,%gs:0x61(%rax,%rbp,2)
    7caa:	6e                   	outsb  %ds:(%rsi),(%dx)
    7cab:	20 36                	and    %dh,(%rsi)
    7cad:	34 20                	xor    $0x20,%al
    7caf:	73 65                	jae    7d16 <drive_lba+0x36>
    7cb1:	63 74 6f 72          	movsxd 0x72(%rdi,%rbp,2),%esi
    7cb5:	73 20                	jae    7cd7 <required_block_count+0x1>
    7cb7:	69 6e 20 62 6f 6f 74 	imul   $0x746f6f62,0x20(%rsi),%ebp
    7cbe:	73 74                	jae    7d34 <drive_lba+0x54>
    7cc0:	72 61                	jb     7d23 <drive_lba+0x43>
    7cc2:	70 20                	jo     7ce4 <drive_lba+0x4>
    7cc4:	6e                   	outsb  %ds:(%rsi),(%dx)
    7cc5:	6f                   	outsl  %ds:(%rsi),(%dx)
    7cc6:	74 20                	je     7ce8 <drive_lba+0x8>
    7cc8:	73 75                	jae    7d3f <drive_lba+0x5f>
    7cca:	70 70                	jo     7d3c <drive_lba+0x5c>
    7ccc:	6f                   	outsl  %ds:(%rsi),(%dx)
    7ccd:	72 74                	jb     7d43 <drive_lba+0x63>
    7ccf:	65                   	gs
    7cd0:	64                   	fs
    7cd1:	2e                   	cs
	...

0000000000007cd3 <drive_num>:
	...

0000000000007cd4 <required_sector_count>:
    7cd4:	3f                   	(bad)  
	...

0000000000007cd6 <required_block_count>:
    7cd6:	03 00                	add    (%rax),%eax

0000000000007cd8 <drive_packet>:
    7cd8:	10 00                	adc    %al,(%rax)

0000000000007cda <drive_num_sectors>:
    7cda:	40                   	rex
	...

0000000000007cdc <drive_address>:
	...

0000000000007cde <drive_sector>:
    7cde:	e0 07                	loopne 7ce7 <drive_lba+0x7>

0000000000007ce0 <drive_lba>:
    7ce0:	01 00                	add    %eax,(%rax)
	...

0000000000007db8 <disk_id>:
    7db8:	78 56                	js     7e10 <stage1_main+0x10>
    7dba:	34 12                	xor    $0x12,%al

0000000000007dbc <reserved>:
	...

0000000000007dbe <attrs>:
    7dbe:	80                   	.byte 0x80

0000000000007dbf <chs_start>:
    7dbf:	ff                   	(bad)  
    7dc0:	ff                   	(bad)  
    7dc1:	ff                   	.byte 0xff

0000000000007dc2 <sysid>:
    7dc2:	0c                   	.byte 0xc

0000000000007dc3 <chs_end>:
    7dc3:	ff                   	(bad)  
    7dc4:	ff                   	(bad)  
    7dc5:	ff                   	.byte 0xff

0000000000007dc6 <lba_start>:
    7dc6:	00 01                	add    %al,(%rcx)
	...

0000000000007dca <lba_size>:
    7dca:	00 00                	add    %al,(%rax)
    7dcc:	10 00                	adc    %al,(%rax)

0000000000007dce <partitions2to4>:
	...
    7dfe:	55                   	push   %rbp
    7dff:	aa                   	stos   %al,%es:(%rdi)

0000000000007e00 <stage1_main>:
    7e00:	31 c0                	xor    %eax,%eax
    7e02:	8e d8                	mov    %eax,%ds
    7e04:	8e c0                	mov    %eax,%es
    7e06:	8e e0                	mov    %eax,%fs
    7e08:	8e e8                	mov    %eax,%gs
    7e0a:	8e d0                	mov    %eax,%ss
    7e0c:	bc 00 7c b8 02       	mov    $0x2b87c00,%esp
    7e11:	24 cd                	and    $0xcd,%al
    7e13:	15 3c 01 74 05       	adc    $0x574013c,%eax
    7e18:	b8 01 24 cd 15       	mov    $0x15cd2401,%eax

0000000000007e1d <a20_activated>:
    7e1d:	b0 ff                	mov    $0xff,%al
    7e1f:	e6 a1                	out    %al,$0xa1
    7e21:	e6 21                	out    %al,$0x21
    7e23:	0f 01 1e             	lidt   (%rsi)
    7e26:	f8                   	clc    
    7e27:	7e 66                	jle    7e8f <LongMode+0x2e>
    7e29:	b8 a0 00 00 00       	mov    $0xa0,%eax
    7e2e:	0f 22 e0             	mov    %rax,%cr4
    7e31:	66 ba 00 00          	mov    $0x0,%dx
    7e35:	07                   	(bad)  
    7e36:	00 0f                	add    %cl,(%rdi)
    7e38:	22 da                	and    %dl,%bl
    7e3a:	66 b9 80 00          	mov    $0x80,%cx
    7e3e:	00 c0                	add    %al,%al
    7e40:	0f 32                	rdmsr  
    7e42:	66 0d 00 01          	or     $0x100,%ax
    7e46:	00 00                	add    %al,(%rax)
    7e48:	0f 30                	wrmsr  
    7e4a:	0f 20 c3             	mov    %cr0,%rbx
    7e4d:	66 81 cb 01 00       	or     $0x1,%bx
    7e52:	00 80 0f 22 c3 0f    	add    %al,0xfc3220f(%rax)
    7e58:	01 16                	add    %edx,(%rsi)
    7e5a:	00 7f ea             	add    %bh,-0x16(%rdi)
    7e5d:	61                   	(bad)  
    7e5e:	7e 18                	jle    7e78 <LongMode+0x17>
	...

0000000000007e61 <LongMode>:
    7e61:	66 b8 20 00          	mov    $0x20,%ax
    7e65:	8e d8                	mov    %eax,%ds
    7e67:	8e c0                	mov    %eax,%es
    7e69:	8e e0                	mov    %eax,%fs
    7e6b:	8e e8                	mov    %eax,%gs
    7e6d:	8e d0                	mov    %eax,%ss
    7e6f:	bc f8 ff 1f 00       	mov    $0x1ffff8,%esp
    7e74:	bd f8 ff 1f 00       	mov    $0x1ffff8,%ebp
    7e79:	bf 00 80 0b 00       	mov    $0xb8000,%edi
    7e7e:	b9 f4 01 00 00       	mov    $0x1f4,%ecx
    7e83:	48 b8 20 1f 20 1f 20 	movabs $0x1f201f201f201f20,%rax
    7e8a:	1f 20 1f 
    7e8d:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    7e90:	bf 00 80 0b 00       	mov    $0xb8000,%edi
    7e95:	48 b8 48 1f 65 1f 6c 	movabs $0x1f6c1f6c1f651f48,%rax
    7e9c:	1f 6c 1f 
    7e9f:	67 48 89 07          	mov    %rax,(%edi)
    7ea3:	48 b8 6f 1f 20 1f 57 	movabs $0x1f6f1f571f201f6f,%rax
    7eaa:	1f 6f 1f 
    7ead:	67 48 89 47 08       	mov    %rax,0x8(%edi)
    7eb2:	48 b8 72 1f 6c 1f 64 	movabs $0x1f211f641f6c1f72,%rax
    7eb9:	1f 21 1f 
    7ebc:	67 48 89 47 10       	mov    %rax,0x10(%edi)
    7ec1:	e8 0a 00 00 00       	call   7ed0 <enable_sse>
    7ec6:	e8 1e 00 00 00       	call   7ee9 <enable_avx>
    7ecb:	e9 60 00 00 00       	jmp    7f30 <stage2_main>

0000000000007ed0 <enable_sse>:
    7ed0:	0f 20 c0             	mov    %cr0,%rax
    7ed3:	24 fb                	and    $0xfb,%al
    7ed5:	48 83 c8 02          	or     $0x2,%rax
    7ed9:	0f 22 c0             	mov    %rax,%cr0
    7edc:	0f 20 e0             	mov    %cr4,%rax
    7edf:	48 0d 00 06 04 00    	or     $0x40600,%rax
    7ee5:	0f 22 e0             	mov    %rax,%cr4
    7ee8:	c3                   	ret    

0000000000007ee9 <enable_avx>:
    7ee9:	48 31 c9             	xor    %rcx,%rcx
    7eec:	0f 01 d0             	xgetbv 
    7eef:	48 83 c8 07          	or     $0x7,%rax
    7ef3:	0f 01 d1             	xsetbv 
    7ef6:	c3                   	ret    
    7ef7:	90                   	nop

0000000000007ef8 <IDT>:
	...

0000000000007efa <IDT.Base>:
    7efa:	00 00                	add    %al,(%rax)
    7efc:	00 00                	add    %al,(%rax)
	...

0000000000007f00 <GDT>:
    7f00:	27                   	(bad)  
    7f01:	00 06                	add    %al,(%rsi)
    7f03:	7f 00                	jg     7f05 <GDT+0x5>
	...

0000000000007f06 <GDT_START>:
	...

0000000000007f0e <code16>:
    7f0e:	ff                   	(bad)  
    7f0f:	ff 00                	incl   (%rax)
    7f11:	00 00                	add    %al,(%rax)
    7f13:	9b                   	fwait
    7f14:	0f                   	.byte 0xf
	...

0000000000007f16 <data16>:
    7f16:	ff                   	(bad)  
    7f17:	ff 00                	incl   (%rax)
    7f19:	00 00                	add    %al,(%rax)
    7f1b:	93                   	xchg   %eax,%ebx
    7f1c:	0f                   	.byte 0xf
	...

0000000000007f1e <code64>:
    7f1e:	ff                   	(bad)  
    7f1f:	ff 00                	incl   (%rax)
    7f21:	00 00                	add    %al,(%rax)
    7f23:	9b                   	fwait
    7f24:	af                   	scas   %es:(%rdi),%eax
	...

0000000000007f26 <data64>:
    7f26:	ff                   	(bad)  
    7f27:	ff 00                	incl   (%rax)
    7f29:	00 00                	add    %al,(%rax)
    7f2b:	93                   	xchg   %eax,%ebx
    7f2c:	af                   	scas   %es:(%rdi),%eax
	...

0000000000007f2e <GDT_END>:
    7f2e:	66 90                	xchg   %ax,%ax

0000000000007f30 <stage2_main>:
    7f30:	53                   	push   %rbx
    7f31:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
    7f38:	e8 23 73 00 00       	call   f260 <_Z11init_libcppv>
    7f3d:	e8 8e 67 00 00       	call   e6d0 <_Z8idt_initv>
    7f42:	e8 79 7c 00 00       	call   fbc0 <_Z8pic_initv>
    7f47:	be b0 f7 00 00       	mov    $0xf7b0,%esi
    7f4c:	31 ff                	xor    %edi,%edi
    7f4e:	e8 ed 1e 00 00       	call   9e40 <_Z7irq_sethPFvvE>
    7f53:	e8 b8 7a 00 00       	call   fa10 <_Z9time_initv>
    7f58:	e8 e3 1f 00 00       	call   9f40 <_Z8pci_initv>
    7f5d:	bf 01 00 00 00       	mov    $0x1,%edi
    7f62:	be 06 00 00 00       	mov    $0x6,%esi
    7f67:	ba ff 00 00 00       	mov    $0xff,%edx
    7f6c:	e8 af 23 00 00       	call   a320 <_Z9pci_matchhhh>
    7f71:	48 85 c0             	test   %rax,%rax
    7f74:	0f 84 88 00 00 00    	je     8002 <stage2_main+0xd2>
    7f7a:	c5 fc 10 00          	vmovups (%rax),%ymm0
    7f7e:	c5 fc 10 48 10       	vmovups 0x10(%rax),%ymm1
    7f83:	c5 fc 11 4c 24 50    	vmovups %ymm1,0x50(%rsp)
    7f89:	c5 fc 11 44 24 40    	vmovups %ymm0,0x40(%rsp)
    7f8f:	c5 fc 10 44 24 40    	vmovups 0x40(%rsp),%ymm0
    7f95:	c5 fc 10 4c 24 50    	vmovups 0x50(%rsp),%ymm1
    7f9b:	c5 fc 11 4c 24 10    	vmovups %ymm1,0x10(%rsp)
    7fa1:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    7fa6:	c5 f8 77             	vzeroupper 
    7fa9:	e8 92 09 00 00       	call   8940 <_Z9ahci_init10pci_device>
    7fae:	e8 4d 24 00 00       	call   a400 <_Z8fat_initv>
    7fb3:	48 8d 5c 24 70       	lea    0x70(%rsp),%rbx
    7fb8:	be ff 02 01 00       	mov    $0x102ff,%esi
    7fbd:	48 89 df             	mov    %rbx,%rdi
    7fc0:	e8 5b 46 00 00       	call   c620 <_ZN8rostringC1EPKc>
    7fc5:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
    7fca:	48 89 de             	mov    %rbx,%rsi
    7fcd:	e8 1e 39 00 00       	call   b8f0 <_Z9file_open8rostring>
    7fd2:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
    7fd7:	48 85 c0             	test   %rax,%rax
    7fda:	74 46                	je     8022 <stage2_main+0xf2>
    7fdc:	48 8b 48 18          	mov    0x18(%rax),%rcx
    7fe0:	48 8b 39             	mov    (%rcx),%rdi
    7fe3:	48 8b 70 18          	mov    0x18(%rax),%rsi
    7fe7:	48 63 50 20          	movslq 0x20(%rax),%rdx
    7feb:	e8 90 1e 00 00       	call   9e80 <memcpy>
    7ff0:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
    7ff5:	e8 a6 37 00 00       	call   b7a0 <_ZN4FILED1Ev>
    7ffa:	e8 21 c2 20 00       	call   214220 <kernel_main>
    7fff:	90                   	nop
    8000:	eb fe                	jmp    8000 <stage2_main+0xd0>
    8002:	bf 00 00 11 00       	mov    $0x110000,%edi
    8007:	be e0 02 01 00       	mov    $0x102e0,%esi
    800c:	e8 4f 0d 00 00       	call   8d60 <_ZN7console6putstrEPKc>
    8011:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    8018:	0f 1f 84 00 00 00 00 
    801f:	00 
    8020:	eb fe                	jmp    8020 <stage2_main+0xf0>
    8022:	bf 00 00 11 00       	mov    $0x110000,%edi
    8027:	be 0b 03 01 00       	mov    $0x1030b,%esi
    802c:	e8 2f 0d 00 00       	call   8d60 <_ZN7console6putstrEPKc>
    8031:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    8038:	0f 1f 84 00 00 00 00 
    803f:	00 
    8040:	eb fe                	jmp    8040 <stage2_main+0x110>
    8042:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    8049:	00 00 00 
    804c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000008050 <save_regs>:
    8050:	52                   	push   %rdx
    8051:	ba 00 00 05 00       	mov    $0x50000,%edx
    8056:	48 89 02             	mov    %rax,(%rdx)
    8059:	48 89 5a 08          	mov    %rbx,0x8(%rdx)
    805d:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
    8061:	48 89 d0             	mov    %rdx,%rax
    8064:	5a                   	pop    %rdx
    8065:	48 89 50 18          	mov    %rdx,0x18(%rax)
    8069:	48 89 70 20          	mov    %rsi,0x20(%rax)
    806d:	48 89 78 28          	mov    %rdi,0x28(%rax)
    8071:	48 89 68 30          	mov    %rbp,0x30(%rax)
    8075:	4c 89 40 40          	mov    %r8,0x40(%rax)
    8079:	4c 89 48 48          	mov    %r9,0x48(%rax)
    807d:	4c 89 50 50          	mov    %r10,0x50(%rax)
    8081:	4c 89 58 58          	mov    %r11,0x58(%rax)
    8085:	4c 89 60 60          	mov    %r12,0x60(%rax)
    8089:	4c 89 68 68          	mov    %r13,0x68(%rax)
    808d:	4c 89 70 70          	mov    %r14,0x70(%rax)
    8091:	4c 89 78 78          	mov    %r15,0x78(%rax)
    8095:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
    809a:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
    80a1:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
    80a6:	48 89 90 90 00 00 00 	mov    %rdx,0x90(%rax)
    80ad:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
    80b2:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
    80b9:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
    80be:	48 89 50 38          	mov    %rdx,0x38(%rax)
    80c2:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
    80c7:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    80ce:	c5 fd 7f 80 a0 00 00 	vmovdqa %ymm0,0xa0(%rax)
    80d5:	00 
    80d6:	c5 fd 7f 88 c0 00 00 	vmovdqa %ymm1,0xc0(%rax)
    80dd:	00 
    80de:	c5 fd 7f 90 e0 00 00 	vmovdqa %ymm2,0xe0(%rax)
    80e5:	00 
    80e6:	c5 fd 7f 98 00 01 00 	vmovdqa %ymm3,0x100(%rax)
    80ed:	00 
    80ee:	c5 fd 7f a0 20 01 00 	vmovdqa %ymm4,0x120(%rax)
    80f5:	00 
    80f6:	c5 fd 7f a8 40 01 00 	vmovdqa %ymm5,0x140(%rax)
    80fd:	00 
    80fe:	c5 fd 7f b0 60 01 00 	vmovdqa %ymm6,0x160(%rax)
    8105:	00 
    8106:	c5 fd 7f b8 80 01 00 	vmovdqa %ymm7,0x180(%rax)
    810d:	00 
    810e:	c5 7d 7f 80 a0 01 00 	vmovdqa %ymm8,0x1a0(%rax)
    8115:	00 
    8116:	c5 7d 7f 88 c0 01 00 	vmovdqa %ymm9,0x1c0(%rax)
    811d:	00 
    811e:	c5 7d 7f 90 e0 01 00 	vmovdqa %ymm10,0x1e0(%rax)
    8125:	00 
    8126:	c5 7d 7f 98 00 02 00 	vmovdqa %ymm11,0x200(%rax)
    812d:	00 
    812e:	c5 7d 7f a0 20 02 00 	vmovdqa %ymm12,0x220(%rax)
    8135:	00 
    8136:	c5 7d 7f a8 40 02 00 	vmovdqa %ymm13,0x240(%rax)
    813d:	00 
    813e:	c5 7d 7f b0 60 02 00 	vmovdqa %ymm14,0x260(%rax)
    8145:	00 
    8146:	c5 7d 7f b8 80 02 00 	vmovdqa %ymm15,0x280(%rax)
    814d:	00 
    814e:	c5 f8 77             	vzeroupper 
    8151:	c3                   	ret    

0000000000008152 <stor_regs>:
    8152:	b8 00 00 05 00       	mov    $0x50000,%eax
    8157:	c5 7d 6f b8 80 02 00 	vmovdqa 0x280(%rax),%ymm15
    815e:	00 
    815f:	c5 7d 6f b0 60 02 00 	vmovdqa 0x260(%rax),%ymm14
    8166:	00 
    8167:	c5 7d 6f a8 40 02 00 	vmovdqa 0x240(%rax),%ymm13
    816e:	00 
    816f:	c5 7d 6f a0 20 02 00 	vmovdqa 0x220(%rax),%ymm12
    8176:	00 
    8177:	c5 7d 6f 98 00 02 00 	vmovdqa 0x200(%rax),%ymm11
    817e:	00 
    817f:	c5 7d 6f 90 e0 01 00 	vmovdqa 0x1e0(%rax),%ymm10
    8186:	00 
    8187:	c5 7d 6f 88 c0 01 00 	vmovdqa 0x1c0(%rax),%ymm9
    818e:	00 
    818f:	c5 7d 6f 80 a0 01 00 	vmovdqa 0x1a0(%rax),%ymm8
    8196:	00 
    8197:	c5 fd 6f b8 80 01 00 	vmovdqa 0x180(%rax),%ymm7
    819e:	00 
    819f:	c5 fd 6f b0 60 01 00 	vmovdqa 0x160(%rax),%ymm6
    81a6:	00 
    81a7:	c5 fd 6f a8 40 01 00 	vmovdqa 0x140(%rax),%ymm5
    81ae:	00 
    81af:	c5 fd 6f a0 20 01 00 	vmovdqa 0x120(%rax),%ymm4
    81b6:	00 
    81b7:	c5 fd 6f 98 00 01 00 	vmovdqa 0x100(%rax),%ymm3
    81be:	00 
    81bf:	c5 fd 6f 90 e0 00 00 	vmovdqa 0xe0(%rax),%ymm2
    81c6:	00 
    81c7:	c5 fd 6f 88 c0 00 00 	vmovdqa 0xc0(%rax),%ymm1
    81ce:	00 
    81cf:	c5 fd 6f 80 a0 00 00 	vmovdqa 0xa0(%rax),%ymm0
    81d6:	00 
    81d7:	4c 8b 78 78          	mov    0x78(%rax),%r15
    81db:	4c 8b 70 70          	mov    0x70(%rax),%r14
    81df:	4c 8b 68 68          	mov    0x68(%rax),%r13
    81e3:	4c 8b 60 60          	mov    0x60(%rax),%r12
    81e7:	4c 8b 58 58          	mov    0x58(%rax),%r11
    81eb:	4c 8b 50 50          	mov    0x50(%rax),%r10
    81ef:	4c 8b 48 48          	mov    0x48(%rax),%r9
    81f3:	4c 8b 40 40          	mov    0x40(%rax),%r8
    81f7:	48 8b 68 30          	mov    0x30(%rax),%rbp
    81fb:	48 8b 78 28          	mov    0x28(%rax),%rdi
    81ff:	48 8b 70 20          	mov    0x20(%rax),%rsi
    8203:	48 8b 50 18          	mov    0x18(%rax),%rdx
    8207:	48 8b 48 10          	mov    0x10(%rax),%rcx
    820b:	48 8b 58 08          	mov    0x8(%rax),%rbx
    820f:	ff 30                	push   (%rax)
    8211:	58                   	pop    %rax
    8212:	c3                   	ret    

0000000000008213 <isr_stub_0>:
    8213:	e8 38 fe ff ff       	call   8050 <save_regs>
    8218:	bf 00 00 00 00       	mov    $0x0,%edi
    821d:	48 89 de             	mov    %rbx,%rsi
    8220:	55                   	push   %rbp
    8221:	48 89 e5             	mov    %rsp,%rbp
    8224:	e8 37 64 00 00       	call   e660 <isr_no_err>
    8229:	5d                   	pop    %rbp
    822a:	e8 23 ff ff ff       	call   8152 <stor_regs>
    822f:	48 cf                	iretq  

0000000000008231 <isr_stub_1>:
    8231:	e8 1a fe ff ff       	call   8050 <save_regs>
    8236:	bf 01 00 00 00       	mov    $0x1,%edi
    823b:	48 89 de             	mov    %rbx,%rsi
    823e:	55                   	push   %rbp
    823f:	48 89 e5             	mov    %rsp,%rbp
    8242:	e8 19 64 00 00       	call   e660 <isr_no_err>
    8247:	5d                   	pop    %rbp
    8248:	e8 05 ff ff ff       	call   8152 <stor_regs>
    824d:	48 cf                	iretq  

000000000000824f <isr_stub_2>:
    824f:	e8 fc fd ff ff       	call   8050 <save_regs>
    8254:	bf 02 00 00 00       	mov    $0x2,%edi
    8259:	48 89 de             	mov    %rbx,%rsi
    825c:	55                   	push   %rbp
    825d:	48 89 e5             	mov    %rsp,%rbp
    8260:	e8 fb 63 00 00       	call   e660 <isr_no_err>
    8265:	5d                   	pop    %rbp
    8266:	e8 e7 fe ff ff       	call   8152 <stor_regs>
    826b:	48 cf                	iretq  

000000000000826d <isr_stub_3>:
    826d:	e8 de fd ff ff       	call   8050 <save_regs>
    8272:	bf 03 00 00 00       	mov    $0x3,%edi
    8277:	48 89 de             	mov    %rbx,%rsi
    827a:	55                   	push   %rbp
    827b:	48 89 e5             	mov    %rsp,%rbp
    827e:	e8 dd 63 00 00       	call   e660 <isr_no_err>
    8283:	5d                   	pop    %rbp
    8284:	e8 c9 fe ff ff       	call   8152 <stor_regs>
    8289:	48 cf                	iretq  

000000000000828b <isr_stub_4>:
    828b:	e8 c0 fd ff ff       	call   8050 <save_regs>
    8290:	bf 04 00 00 00       	mov    $0x4,%edi
    8295:	48 89 de             	mov    %rbx,%rsi
    8298:	55                   	push   %rbp
    8299:	48 89 e5             	mov    %rsp,%rbp
    829c:	e8 bf 63 00 00       	call   e660 <isr_no_err>
    82a1:	5d                   	pop    %rbp
    82a2:	e8 ab fe ff ff       	call   8152 <stor_regs>
    82a7:	48 cf                	iretq  

00000000000082a9 <isr_stub_5>:
    82a9:	e8 a2 fd ff ff       	call   8050 <save_regs>
    82ae:	bf 05 00 00 00       	mov    $0x5,%edi
    82b3:	48 89 de             	mov    %rbx,%rsi
    82b6:	55                   	push   %rbp
    82b7:	48 89 e5             	mov    %rsp,%rbp
    82ba:	e8 a1 63 00 00       	call   e660 <isr_no_err>
    82bf:	5d                   	pop    %rbp
    82c0:	e8 8d fe ff ff       	call   8152 <stor_regs>
    82c5:	48 cf                	iretq  

00000000000082c7 <isr_stub_6>:
    82c7:	e8 84 fd ff ff       	call   8050 <save_regs>
    82cc:	bf 06 00 00 00       	mov    $0x6,%edi
    82d1:	48 89 de             	mov    %rbx,%rsi
    82d4:	55                   	push   %rbp
    82d5:	48 89 e5             	mov    %rsp,%rbp
    82d8:	e8 83 63 00 00       	call   e660 <isr_no_err>
    82dd:	5d                   	pop    %rbp
    82de:	e8 6f fe ff ff       	call   8152 <stor_regs>
    82e3:	48 cf                	iretq  

00000000000082e5 <isr_stub_7>:
    82e5:	e8 66 fd ff ff       	call   8050 <save_regs>
    82ea:	bf 07 00 00 00       	mov    $0x7,%edi
    82ef:	48 89 de             	mov    %rbx,%rsi
    82f2:	55                   	push   %rbp
    82f3:	48 89 e5             	mov    %rsp,%rbp
    82f6:	e8 65 63 00 00       	call   e660 <isr_no_err>
    82fb:	5d                   	pop    %rbp
    82fc:	e8 51 fe ff ff       	call   8152 <stor_regs>
    8301:	48 cf                	iretq  

0000000000008303 <isr_stub_8>:
    8303:	50                   	push   %rax
    8304:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    8309:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    830e:	58                   	pop    %rax
    830f:	48 83 c4 08          	add    $0x8,%rsp
    8313:	e8 38 fd ff ff       	call   8050 <save_regs>
    8318:	bf 08 00 00 00       	mov    $0x8,%edi
    831d:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8322:	be 00 00 05 00       	mov    $0x50000,%esi
    8327:	55                   	push   %rbp
    8328:	48 89 e5             	mov    %rsp,%rbp
    832b:	e8 10 63 00 00       	call   e640 <isr_err>
    8330:	5d                   	pop    %rbp
    8331:	e8 1c fe ff ff       	call   8152 <stor_regs>
    8336:	48 cf                	iretq  

0000000000008338 <isr_stub_9>:
    8338:	e8 13 fd ff ff       	call   8050 <save_regs>
    833d:	bf 09 00 00 00       	mov    $0x9,%edi
    8342:	48 89 de             	mov    %rbx,%rsi
    8345:	55                   	push   %rbp
    8346:	48 89 e5             	mov    %rsp,%rbp
    8349:	e8 12 63 00 00       	call   e660 <isr_no_err>
    834e:	5d                   	pop    %rbp
    834f:	e8 fe fd ff ff       	call   8152 <stor_regs>
    8354:	48 cf                	iretq  

0000000000008356 <isr_stub_10>:
    8356:	50                   	push   %rax
    8357:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    835c:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    8361:	58                   	pop    %rax
    8362:	48 83 c4 08          	add    $0x8,%rsp
    8366:	e8 e5 fc ff ff       	call   8050 <save_regs>
    836b:	bf 0a 00 00 00       	mov    $0xa,%edi
    8370:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8375:	be 00 00 05 00       	mov    $0x50000,%esi
    837a:	55                   	push   %rbp
    837b:	48 89 e5             	mov    %rsp,%rbp
    837e:	e8 bd 62 00 00       	call   e640 <isr_err>
    8383:	5d                   	pop    %rbp
    8384:	e8 c9 fd ff ff       	call   8152 <stor_regs>
    8389:	48 cf                	iretq  

000000000000838b <isr_stub_11>:
    838b:	50                   	push   %rax
    838c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    8391:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    8396:	58                   	pop    %rax
    8397:	48 83 c4 08          	add    $0x8,%rsp
    839b:	e8 b0 fc ff ff       	call   8050 <save_regs>
    83a0:	bf 0b 00 00 00       	mov    $0xb,%edi
    83a5:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    83aa:	be 00 00 05 00       	mov    $0x50000,%esi
    83af:	55                   	push   %rbp
    83b0:	48 89 e5             	mov    %rsp,%rbp
    83b3:	e8 88 62 00 00       	call   e640 <isr_err>
    83b8:	5d                   	pop    %rbp
    83b9:	e8 94 fd ff ff       	call   8152 <stor_regs>
    83be:	48 cf                	iretq  

00000000000083c0 <isr_stub_12>:
    83c0:	50                   	push   %rax
    83c1:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    83c6:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    83cb:	58                   	pop    %rax
    83cc:	48 83 c4 08          	add    $0x8,%rsp
    83d0:	e8 7b fc ff ff       	call   8050 <save_regs>
    83d5:	bf 0c 00 00 00       	mov    $0xc,%edi
    83da:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    83df:	be 00 00 05 00       	mov    $0x50000,%esi
    83e4:	55                   	push   %rbp
    83e5:	48 89 e5             	mov    %rsp,%rbp
    83e8:	e8 53 62 00 00       	call   e640 <isr_err>
    83ed:	5d                   	pop    %rbp
    83ee:	e8 5f fd ff ff       	call   8152 <stor_regs>
    83f3:	48 cf                	iretq  

00000000000083f5 <isr_stub_13>:
    83f5:	50                   	push   %rax
    83f6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    83fb:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    8400:	58                   	pop    %rax
    8401:	48 83 c4 08          	add    $0x8,%rsp
    8405:	e8 46 fc ff ff       	call   8050 <save_regs>
    840a:	bf 0d 00 00 00       	mov    $0xd,%edi
    840f:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8414:	be 00 00 05 00       	mov    $0x50000,%esi
    8419:	55                   	push   %rbp
    841a:	48 89 e5             	mov    %rsp,%rbp
    841d:	e8 1e 62 00 00       	call   e640 <isr_err>
    8422:	5d                   	pop    %rbp
    8423:	e8 2a fd ff ff       	call   8152 <stor_regs>
    8428:	48 cf                	iretq  

000000000000842a <isr_stub_14>:
    842a:	50                   	push   %rax
    842b:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    8430:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    8435:	58                   	pop    %rax
    8436:	48 83 c4 08          	add    $0x8,%rsp
    843a:	e8 11 fc ff ff       	call   8050 <save_regs>
    843f:	bf 0e 00 00 00       	mov    $0xe,%edi
    8444:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8449:	be 00 00 05 00       	mov    $0x50000,%esi
    844e:	55                   	push   %rbp
    844f:	48 89 e5             	mov    %rsp,%rbp
    8452:	e8 e9 61 00 00       	call   e640 <isr_err>
    8457:	5d                   	pop    %rbp
    8458:	e8 f5 fc ff ff       	call   8152 <stor_regs>
    845d:	48 cf                	iretq  

000000000000845f <isr_stub_15>:
    845f:	e8 ec fb ff ff       	call   8050 <save_regs>
    8464:	bf 0f 00 00 00       	mov    $0xf,%edi
    8469:	48 89 de             	mov    %rbx,%rsi
    846c:	55                   	push   %rbp
    846d:	48 89 e5             	mov    %rsp,%rbp
    8470:	e8 eb 61 00 00       	call   e660 <isr_no_err>
    8475:	5d                   	pop    %rbp
    8476:	e8 d7 fc ff ff       	call   8152 <stor_regs>
    847b:	48 cf                	iretq  

000000000000847d <isr_stub_16>:
    847d:	e8 ce fb ff ff       	call   8050 <save_regs>
    8482:	bf 10 00 00 00       	mov    $0x10,%edi
    8487:	48 89 de             	mov    %rbx,%rsi
    848a:	55                   	push   %rbp
    848b:	48 89 e5             	mov    %rsp,%rbp
    848e:	e8 cd 61 00 00       	call   e660 <isr_no_err>
    8493:	5d                   	pop    %rbp
    8494:	e8 b9 fc ff ff       	call   8152 <stor_regs>
    8499:	48 cf                	iretq  

000000000000849b <isr_stub_17>:
    849b:	50                   	push   %rax
    849c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    84a1:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    84a6:	58                   	pop    %rax
    84a7:	48 83 c4 08          	add    $0x8,%rsp
    84ab:	e8 a0 fb ff ff       	call   8050 <save_regs>
    84b0:	bf 11 00 00 00       	mov    $0x11,%edi
    84b5:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    84ba:	be 00 00 05 00       	mov    $0x50000,%esi
    84bf:	55                   	push   %rbp
    84c0:	48 89 e5             	mov    %rsp,%rbp
    84c3:	e8 78 61 00 00       	call   e640 <isr_err>
    84c8:	5d                   	pop    %rbp
    84c9:	e8 84 fc ff ff       	call   8152 <stor_regs>
    84ce:	48 cf                	iretq  

00000000000084d0 <isr_stub_18>:
    84d0:	e8 7b fb ff ff       	call   8050 <save_regs>
    84d5:	bf 12 00 00 00       	mov    $0x12,%edi
    84da:	48 89 de             	mov    %rbx,%rsi
    84dd:	55                   	push   %rbp
    84de:	48 89 e5             	mov    %rsp,%rbp
    84e1:	e8 7a 61 00 00       	call   e660 <isr_no_err>
    84e6:	5d                   	pop    %rbp
    84e7:	e8 66 fc ff ff       	call   8152 <stor_regs>
    84ec:	48 cf                	iretq  

00000000000084ee <isr_stub_19>:
    84ee:	e8 5d fb ff ff       	call   8050 <save_regs>
    84f3:	bf 13 00 00 00       	mov    $0x13,%edi
    84f8:	48 89 de             	mov    %rbx,%rsi
    84fb:	55                   	push   %rbp
    84fc:	48 89 e5             	mov    %rsp,%rbp
    84ff:	e8 5c 61 00 00       	call   e660 <isr_no_err>
    8504:	5d                   	pop    %rbp
    8505:	e8 48 fc ff ff       	call   8152 <stor_regs>
    850a:	48 cf                	iretq  

000000000000850c <isr_stub_20>:
    850c:	e8 3f fb ff ff       	call   8050 <save_regs>
    8511:	bf 14 00 00 00       	mov    $0x14,%edi
    8516:	48 89 de             	mov    %rbx,%rsi
    8519:	55                   	push   %rbp
    851a:	48 89 e5             	mov    %rsp,%rbp
    851d:	e8 3e 61 00 00       	call   e660 <isr_no_err>
    8522:	5d                   	pop    %rbp
    8523:	e8 2a fc ff ff       	call   8152 <stor_regs>
    8528:	48 cf                	iretq  

000000000000852a <isr_stub_21>:
    852a:	e8 21 fb ff ff       	call   8050 <save_regs>
    852f:	bf 15 00 00 00       	mov    $0x15,%edi
    8534:	48 89 de             	mov    %rbx,%rsi
    8537:	55                   	push   %rbp
    8538:	48 89 e5             	mov    %rsp,%rbp
    853b:	e8 20 61 00 00       	call   e660 <isr_no_err>
    8540:	5d                   	pop    %rbp
    8541:	e8 0c fc ff ff       	call   8152 <stor_regs>
    8546:	48 cf                	iretq  

0000000000008548 <isr_stub_22>:
    8548:	e8 03 fb ff ff       	call   8050 <save_regs>
    854d:	bf 16 00 00 00       	mov    $0x16,%edi
    8552:	48 89 de             	mov    %rbx,%rsi
    8555:	55                   	push   %rbp
    8556:	48 89 e5             	mov    %rsp,%rbp
    8559:	e8 02 61 00 00       	call   e660 <isr_no_err>
    855e:	5d                   	pop    %rbp
    855f:	e8 ee fb ff ff       	call   8152 <stor_regs>
    8564:	48 cf                	iretq  

0000000000008566 <isr_stub_23>:
    8566:	e8 e5 fa ff ff       	call   8050 <save_regs>
    856b:	bf 17 00 00 00       	mov    $0x17,%edi
    8570:	48 89 de             	mov    %rbx,%rsi
    8573:	55                   	push   %rbp
    8574:	48 89 e5             	mov    %rsp,%rbp
    8577:	e8 e4 60 00 00       	call   e660 <isr_no_err>
    857c:	5d                   	pop    %rbp
    857d:	e8 d0 fb ff ff       	call   8152 <stor_regs>
    8582:	48 cf                	iretq  

0000000000008584 <isr_stub_24>:
    8584:	e8 c7 fa ff ff       	call   8050 <save_regs>
    8589:	bf 18 00 00 00       	mov    $0x18,%edi
    858e:	48 89 de             	mov    %rbx,%rsi
    8591:	55                   	push   %rbp
    8592:	48 89 e5             	mov    %rsp,%rbp
    8595:	e8 c6 60 00 00       	call   e660 <isr_no_err>
    859a:	5d                   	pop    %rbp
    859b:	e8 b2 fb ff ff       	call   8152 <stor_regs>
    85a0:	48 cf                	iretq  

00000000000085a2 <isr_stub_25>:
    85a2:	e8 a9 fa ff ff       	call   8050 <save_regs>
    85a7:	bf 19 00 00 00       	mov    $0x19,%edi
    85ac:	48 89 de             	mov    %rbx,%rsi
    85af:	55                   	push   %rbp
    85b0:	48 89 e5             	mov    %rsp,%rbp
    85b3:	e8 a8 60 00 00       	call   e660 <isr_no_err>
    85b8:	5d                   	pop    %rbp
    85b9:	e8 94 fb ff ff       	call   8152 <stor_regs>
    85be:	48 cf                	iretq  

00000000000085c0 <isr_stub_26>:
    85c0:	e8 8b fa ff ff       	call   8050 <save_regs>
    85c5:	bf 1a 00 00 00       	mov    $0x1a,%edi
    85ca:	48 89 de             	mov    %rbx,%rsi
    85cd:	55                   	push   %rbp
    85ce:	48 89 e5             	mov    %rsp,%rbp
    85d1:	e8 8a 60 00 00       	call   e660 <isr_no_err>
    85d6:	5d                   	pop    %rbp
    85d7:	e8 76 fb ff ff       	call   8152 <stor_regs>
    85dc:	48 cf                	iretq  

00000000000085de <isr_stub_27>:
    85de:	e8 6d fa ff ff       	call   8050 <save_regs>
    85e3:	bf 1b 00 00 00       	mov    $0x1b,%edi
    85e8:	48 89 de             	mov    %rbx,%rsi
    85eb:	55                   	push   %rbp
    85ec:	48 89 e5             	mov    %rsp,%rbp
    85ef:	e8 6c 60 00 00       	call   e660 <isr_no_err>
    85f4:	5d                   	pop    %rbp
    85f5:	e8 58 fb ff ff       	call   8152 <stor_regs>
    85fa:	48 cf                	iretq  

00000000000085fc <isr_stub_28>:
    85fc:	e8 4f fa ff ff       	call   8050 <save_regs>
    8601:	bf 1c 00 00 00       	mov    $0x1c,%edi
    8606:	48 89 de             	mov    %rbx,%rsi
    8609:	55                   	push   %rbp
    860a:	48 89 e5             	mov    %rsp,%rbp
    860d:	e8 4e 60 00 00       	call   e660 <isr_no_err>
    8612:	5d                   	pop    %rbp
    8613:	e8 3a fb ff ff       	call   8152 <stor_regs>
    8618:	48 cf                	iretq  

000000000000861a <isr_stub_29>:
    861a:	e8 31 fa ff ff       	call   8050 <save_regs>
    861f:	bf 1d 00 00 00       	mov    $0x1d,%edi
    8624:	48 89 de             	mov    %rbx,%rsi
    8627:	55                   	push   %rbp
    8628:	48 89 e5             	mov    %rsp,%rbp
    862b:	e8 30 60 00 00       	call   e660 <isr_no_err>
    8630:	5d                   	pop    %rbp
    8631:	e8 1c fb ff ff       	call   8152 <stor_regs>
    8636:	48 cf                	iretq  

0000000000008638 <isr_stub_30>:
    8638:	50                   	push   %rax
    8639:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    863e:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    8643:	58                   	pop    %rax
    8644:	48 83 c4 08          	add    $0x8,%rsp
    8648:	e8 03 fa ff ff       	call   8050 <save_regs>
    864d:	bf 1e 00 00 00       	mov    $0x1e,%edi
    8652:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8657:	be 00 00 05 00       	mov    $0x50000,%esi
    865c:	55                   	push   %rbp
    865d:	48 89 e5             	mov    %rsp,%rbp
    8660:	e8 db 5f 00 00       	call   e640 <isr_err>
    8665:	5d                   	pop    %rbp
    8666:	e8 e7 fa ff ff       	call   8152 <stor_regs>
    866b:	48 cf                	iretq  

000000000000866d <isr_stub_31>:
    866d:	e8 de f9 ff ff       	call   8050 <save_regs>
    8672:	bf 1f 00 00 00       	mov    $0x1f,%edi
    8677:	48 89 de             	mov    %rbx,%rsi
    867a:	55                   	push   %rbp
    867b:	48 89 e5             	mov    %rsp,%rbp
    867e:	e8 dd 5f 00 00       	call   e660 <isr_no_err>
    8683:	5d                   	pop    %rbp
    8684:	e8 c9 fa ff ff       	call   8152 <stor_regs>
    8689:	48 cf                	iretq  

000000000000868b <isr_stub_32>:
    868b:	e8 c0 f9 ff ff       	call   8050 <save_regs>
    8690:	bf 20 00 00 00       	mov    $0x20,%edi
    8695:	48 89 de             	mov    %rbx,%rsi
    8698:	55                   	push   %rbp
    8699:	48 89 e5             	mov    %rsp,%rbp
    869c:	e8 df 5f 00 00       	call   e680 <irq_isr>
    86a1:	5d                   	pop    %rbp
    86a2:	e8 ab fa ff ff       	call   8152 <stor_regs>
    86a7:	48 cf                	iretq  

00000000000086a9 <isr_stub_33>:
    86a9:	e8 a2 f9 ff ff       	call   8050 <save_regs>
    86ae:	bf 21 00 00 00       	mov    $0x21,%edi
    86b3:	48 89 de             	mov    %rbx,%rsi
    86b6:	55                   	push   %rbp
    86b7:	48 89 e5             	mov    %rsp,%rbp
    86ba:	e8 c1 5f 00 00       	call   e680 <irq_isr>
    86bf:	5d                   	pop    %rbp
    86c0:	e8 8d fa ff ff       	call   8152 <stor_regs>
    86c5:	48 cf                	iretq  

00000000000086c7 <isr_stub_34>:
    86c7:	e8 84 f9 ff ff       	call   8050 <save_regs>
    86cc:	bf 22 00 00 00       	mov    $0x22,%edi
    86d1:	48 89 de             	mov    %rbx,%rsi
    86d4:	55                   	push   %rbp
    86d5:	48 89 e5             	mov    %rsp,%rbp
    86d8:	e8 a3 5f 00 00       	call   e680 <irq_isr>
    86dd:	5d                   	pop    %rbp
    86de:	e8 6f fa ff ff       	call   8152 <stor_regs>
    86e3:	48 cf                	iretq  

00000000000086e5 <isr_stub_35>:
    86e5:	e8 66 f9 ff ff       	call   8050 <save_regs>
    86ea:	bf 23 00 00 00       	mov    $0x23,%edi
    86ef:	48 89 de             	mov    %rbx,%rsi
    86f2:	55                   	push   %rbp
    86f3:	48 89 e5             	mov    %rsp,%rbp
    86f6:	e8 85 5f 00 00       	call   e680 <irq_isr>
    86fb:	5d                   	pop    %rbp
    86fc:	e8 51 fa ff ff       	call   8152 <stor_regs>
    8701:	48 cf                	iretq  

0000000000008703 <isr_stub_36>:
    8703:	e8 48 f9 ff ff       	call   8050 <save_regs>
    8708:	bf 24 00 00 00       	mov    $0x24,%edi
    870d:	48 89 de             	mov    %rbx,%rsi
    8710:	55                   	push   %rbp
    8711:	48 89 e5             	mov    %rsp,%rbp
    8714:	e8 67 5f 00 00       	call   e680 <irq_isr>
    8719:	5d                   	pop    %rbp
    871a:	e8 33 fa ff ff       	call   8152 <stor_regs>
    871f:	48 cf                	iretq  

0000000000008721 <isr_stub_37>:
    8721:	e8 2a f9 ff ff       	call   8050 <save_regs>
    8726:	bf 25 00 00 00       	mov    $0x25,%edi
    872b:	48 89 de             	mov    %rbx,%rsi
    872e:	55                   	push   %rbp
    872f:	48 89 e5             	mov    %rsp,%rbp
    8732:	e8 49 5f 00 00       	call   e680 <irq_isr>
    8737:	5d                   	pop    %rbp
    8738:	e8 15 fa ff ff       	call   8152 <stor_regs>
    873d:	48 cf                	iretq  

000000000000873f <isr_stub_38>:
    873f:	e8 0c f9 ff ff       	call   8050 <save_regs>
    8744:	bf 26 00 00 00       	mov    $0x26,%edi
    8749:	48 89 de             	mov    %rbx,%rsi
    874c:	55                   	push   %rbp
    874d:	48 89 e5             	mov    %rsp,%rbp
    8750:	e8 2b 5f 00 00       	call   e680 <irq_isr>
    8755:	5d                   	pop    %rbp
    8756:	e8 f7 f9 ff ff       	call   8152 <stor_regs>
    875b:	48 cf                	iretq  

000000000000875d <isr_stub_39>:
    875d:	e8 ee f8 ff ff       	call   8050 <save_regs>
    8762:	bf 27 00 00 00       	mov    $0x27,%edi
    8767:	48 89 de             	mov    %rbx,%rsi
    876a:	55                   	push   %rbp
    876b:	48 89 e5             	mov    %rsp,%rbp
    876e:	e8 0d 5f 00 00       	call   e680 <irq_isr>
    8773:	5d                   	pop    %rbp
    8774:	e8 d9 f9 ff ff       	call   8152 <stor_regs>
    8779:	48 cf                	iretq  

000000000000877b <isr_stub_40>:
    877b:	e8 d0 f8 ff ff       	call   8050 <save_regs>
    8780:	bf 28 00 00 00       	mov    $0x28,%edi
    8785:	48 89 de             	mov    %rbx,%rsi
    8788:	55                   	push   %rbp
    8789:	48 89 e5             	mov    %rsp,%rbp
    878c:	e8 ef 5e 00 00       	call   e680 <irq_isr>
    8791:	5d                   	pop    %rbp
    8792:	e8 bb f9 ff ff       	call   8152 <stor_regs>
    8797:	48 cf                	iretq  

0000000000008799 <isr_stub_41>:
    8799:	e8 b2 f8 ff ff       	call   8050 <save_regs>
    879e:	bf 29 00 00 00       	mov    $0x29,%edi
    87a3:	48 89 de             	mov    %rbx,%rsi
    87a6:	55                   	push   %rbp
    87a7:	48 89 e5             	mov    %rsp,%rbp
    87aa:	e8 d1 5e 00 00       	call   e680 <irq_isr>
    87af:	5d                   	pop    %rbp
    87b0:	e8 9d f9 ff ff       	call   8152 <stor_regs>
    87b5:	48 cf                	iretq  

00000000000087b7 <isr_stub_42>:
    87b7:	e8 94 f8 ff ff       	call   8050 <save_regs>
    87bc:	bf 2a 00 00 00       	mov    $0x2a,%edi
    87c1:	48 89 de             	mov    %rbx,%rsi
    87c4:	55                   	push   %rbp
    87c5:	48 89 e5             	mov    %rsp,%rbp
    87c8:	e8 b3 5e 00 00       	call   e680 <irq_isr>
    87cd:	5d                   	pop    %rbp
    87ce:	e8 7f f9 ff ff       	call   8152 <stor_regs>
    87d3:	48 cf                	iretq  

00000000000087d5 <isr_stub_43>:
    87d5:	e8 76 f8 ff ff       	call   8050 <save_regs>
    87da:	bf 2b 00 00 00       	mov    $0x2b,%edi
    87df:	48 89 de             	mov    %rbx,%rsi
    87e2:	55                   	push   %rbp
    87e3:	48 89 e5             	mov    %rsp,%rbp
    87e6:	e8 95 5e 00 00       	call   e680 <irq_isr>
    87eb:	5d                   	pop    %rbp
    87ec:	e8 61 f9 ff ff       	call   8152 <stor_regs>
    87f1:	48 cf                	iretq  

00000000000087f3 <isr_stub_44>:
    87f3:	e8 58 f8 ff ff       	call   8050 <save_regs>
    87f8:	bf 2c 00 00 00       	mov    $0x2c,%edi
    87fd:	48 89 de             	mov    %rbx,%rsi
    8800:	55                   	push   %rbp
    8801:	48 89 e5             	mov    %rsp,%rbp
    8804:	e8 77 5e 00 00       	call   e680 <irq_isr>
    8809:	5d                   	pop    %rbp
    880a:	e8 43 f9 ff ff       	call   8152 <stor_regs>
    880f:	48 cf                	iretq  

0000000000008811 <isr_stub_45>:
    8811:	e8 3a f8 ff ff       	call   8050 <save_regs>
    8816:	bf 2d 00 00 00       	mov    $0x2d,%edi
    881b:	48 89 de             	mov    %rbx,%rsi
    881e:	55                   	push   %rbp
    881f:	48 89 e5             	mov    %rsp,%rbp
    8822:	e8 59 5e 00 00       	call   e680 <irq_isr>
    8827:	5d                   	pop    %rbp
    8828:	e8 25 f9 ff ff       	call   8152 <stor_regs>
    882d:	48 cf                	iretq  

000000000000882f <isr_stub_46>:
    882f:	e8 1c f8 ff ff       	call   8050 <save_regs>
    8834:	bf 2e 00 00 00       	mov    $0x2e,%edi
    8839:	48 89 de             	mov    %rbx,%rsi
    883c:	55                   	push   %rbp
    883d:	48 89 e5             	mov    %rsp,%rbp
    8840:	e8 3b 5e 00 00       	call   e680 <irq_isr>
    8845:	5d                   	pop    %rbp
    8846:	e8 07 f9 ff ff       	call   8152 <stor_regs>
    884b:	48 cf                	iretq  

000000000000884d <isr_stub_47>:
    884d:	e8 fe f7 ff ff       	call   8050 <save_regs>
    8852:	bf 2f 00 00 00       	mov    $0x2f,%edi
    8857:	48 89 de             	mov    %rbx,%rsi
    885a:	55                   	push   %rbp
    885b:	48 89 e5             	mov    %rsp,%rbp
    885e:	e8 1d 5e 00 00       	call   e680 <irq_isr>
    8863:	5d                   	pop    %rbp
    8864:	e8 e9 f8 ff ff       	call   8152 <stor_regs>
    8869:	48 cf                	iretq  

000000000000886b <isr_stub_table>:
    886b:	13 82 00 00 31 82    	adc    -0x7dcf0000(%rdx),%eax
    8871:	00 00                	add    %al,(%rax)
    8873:	4f 82                	rex.WRXB (bad) 
    8875:	00 00                	add    %al,(%rax)
    8877:	6d                   	insl   (%dx),%es:(%rdi)
    8878:	82                   	(bad)  
    8879:	00 00                	add    %al,(%rax)
    887b:	8b 82 00 00 a9 82    	mov    -0x7d570000(%rdx),%eax
    8881:	00 00                	add    %al,(%rax)
    8883:	c7 82 00 00 e5 82 00 	movl   $0x83030000,-0x7d1b0000(%rdx)
    888a:	00 03 83 
    888d:	00 00                	add    %al,(%rax)
    888f:	38 83 00 00 56 83    	cmp    %al,-0x7caa0000(%rbx)
    8895:	00 00                	add    %al,(%rax)
    8897:	8b 83 00 00 c0 83    	mov    -0x7c400000(%rbx),%eax
    889d:	00 00                	add    %al,(%rax)
    889f:	f5                   	cmc    
    88a0:	83 00 00             	addl   $0x0,(%rax)
    88a3:	2a 84 00 00 5f 84 00 	sub    0x845f00(%rax,%rax,1),%al
    88aa:	00 7d 84             	add    %bh,-0x7c(%rbp)
    88ad:	00 00                	add    %al,(%rax)
    88af:	9b                   	fwait
    88b0:	84 00                	test   %al,(%rax)
    88b2:	00 d0                	add    %dl,%al
    88b4:	84 00                	test   %al,(%rax)
    88b6:	00 ee                	add    %ch,%dh
    88b8:	84 00                	test   %al,(%rax)
    88ba:	00 0c 85 00 00 2a 85 	add    %cl,-0x7ad60000(,%rax,4)
    88c1:	00 00                	add    %al,(%rax)
    88c3:	48 85 00             	test   %rax,(%rax)
    88c6:	00 66 85             	add    %ah,-0x7b(%rsi)
    88c9:	00 00                	add    %al,(%rax)
    88cb:	84 85 00 00 a2 85    	test   %al,-0x7a5e0000(%rbp)
    88d1:	00 00                	add    %al,(%rax)
    88d3:	c0 85 00 00 de 85 00 	rolb   $0x0,-0x7a220000(%rbp)
    88da:	00 fc                	add    %bh,%ah
    88dc:	85 00                	test   %eax,(%rax)
    88de:	00 1a                	add    %bl,(%rdx)
    88e0:	86 00                	xchg   %al,(%rax)
    88e2:	00 38                	add    %bh,(%rax)
    88e4:	86 00                	xchg   %al,(%rax)
    88e6:	00 6d 86             	add    %ch,-0x7a(%rbp)
    88e9:	00 00                	add    %al,(%rax)
    88eb:	8b 86 00 00 a9 86    	mov    -0x79570000(%rsi),%eax
    88f1:	00 00                	add    %al,(%rax)
    88f3:	c7 86 00 00 e5 86 00 	movl   $0x87030000,-0x791b0000(%rsi)
    88fa:	00 03 87 
    88fd:	00 00                	add    %al,(%rax)
    88ff:	21 87 00 00 3f 87    	and    %eax,-0x78c10000(%rdi)
    8905:	00 00                	add    %al,(%rax)
    8907:	5d                   	pop    %rbp
    8908:	87 00                	xchg   %eax,(%rax)
    890a:	00 7b 87             	add    %bh,-0x79(%rbx)
    890d:	00 00                	add    %al,(%rax)
    890f:	99                   	cltd   
    8910:	87 00                	xchg   %eax,(%rax)
    8912:	00 b7 87 00 00 d5    	add    %dh,-0x2affff79(%rdi)
    8918:	87 00                	xchg   %eax,(%rax)
    891a:	00 f3                	add    %dh,%bl
    891c:	87 00                	xchg   %eax,(%rax)
    891e:	00 11                	add    %dl,(%rcx)
    8920:	88 00                	mov    %al,(%rax)
    8922:	00 2f                	add    %ch,(%rdi)
    8924:	88 00                	mov    %al,(%rax)
    8926:	00 4d 88             	add    %cl,-0x78(%rbp)
	...

000000000000892b <load_idt>:
    892b:	fa                   	cli    
    892c:	0f 01 1f             	lidt   (%rdi)
    892f:	b0 ff                	mov    $0xff,%al
    8931:	e6 21                	out    %al,$0x21
    8933:	e6 a1                	out    %al,$0xa1
    8935:	fb                   	sti    
    8936:	c3                   	ret    
    8937:	cc                   	int3   
    8938:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    893f:	00 

0000000000008940 <_Z9ahci_init10pci_device>:
    8940:	53                   	push   %rbx
    8941:	48 83 ec 20          	sub    $0x20,%rsp
    8945:	48 8d 44 24 30       	lea    0x30(%rsp),%rax
    894a:	bf e0 33 05 00       	mov    $0x533e0,%edi
    894f:	48 8b 0c 25 20 00 11 	mov    0x110020,%rcx
    8956:	00 
    8957:	48 83 c1 0f          	add    $0xf,%rcx
    895b:	48 83 e1 f0          	and    $0xfffffffffffffff0,%rcx
    895f:	48 8d 51 28          	lea    0x28(%rcx),%rdx
    8963:	48 89 14 25 20 00 11 	mov    %rdx,0x110020
    896a:	00 
    896b:	48 89 0c 25 d0 00 11 	mov    %rcx,0x1100d0
    8972:	00 
    8973:	31 c9                	xor    %ecx,%ecx
    8975:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    8979:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    8980:	c5 fc 29 84 0f 20 fc 	vmovaps %ymm0,-0x3e0(%rdi,%rcx,1)
    8987:	ff ff 
    8989:	c5 fc 29 84 0f 40 fc 	vmovaps %ymm0,-0x3c0(%rdi,%rcx,1)
    8990:	ff ff 
    8992:	c5 fc 29 84 0f 60 fc 	vmovaps %ymm0,-0x3a0(%rdi,%rcx,1)
    8999:	ff ff 
    899b:	c5 fc 29 84 0f 80 fc 	vmovaps %ymm0,-0x380(%rdi,%rcx,1)
    89a2:	ff ff 
    89a4:	c5 fc 29 84 0f a0 fc 	vmovaps %ymm0,-0x360(%rdi,%rcx,1)
    89ab:	ff ff 
    89ad:	c5 fc 29 84 0f c0 fc 	vmovaps %ymm0,-0x340(%rdi,%rcx,1)
    89b4:	ff ff 
    89b6:	c5 fc 29 84 0f e0 fc 	vmovaps %ymm0,-0x320(%rdi,%rcx,1)
    89bd:	ff ff 
    89bf:	c5 fc 29 84 0f 00 fd 	vmovaps %ymm0,-0x300(%rdi,%rcx,1)
    89c6:	ff ff 
    89c8:	c5 fc 29 84 0f 20 fd 	vmovaps %ymm0,-0x2e0(%rdi,%rcx,1)
    89cf:	ff ff 
    89d1:	c5 fc 29 84 0f 40 fd 	vmovaps %ymm0,-0x2c0(%rdi,%rcx,1)
    89d8:	ff ff 
    89da:	c5 fc 29 84 0f 60 fd 	vmovaps %ymm0,-0x2a0(%rdi,%rcx,1)
    89e1:	ff ff 
    89e3:	c5 fc 29 84 0f 80 fd 	vmovaps %ymm0,-0x280(%rdi,%rcx,1)
    89ea:	ff ff 
    89ec:	c5 fc 29 84 0f a0 fd 	vmovaps %ymm0,-0x260(%rdi,%rcx,1)
    89f3:	ff ff 
    89f5:	c5 fc 29 84 0f c0 fd 	vmovaps %ymm0,-0x240(%rdi,%rcx,1)
    89fc:	ff ff 
    89fe:	c5 fc 29 84 0f e0 fd 	vmovaps %ymm0,-0x220(%rdi,%rcx,1)
    8a05:	ff ff 
    8a07:	c5 fc 29 84 0f 00 fe 	vmovaps %ymm0,-0x200(%rdi,%rcx,1)
    8a0e:	ff ff 
    8a10:	c5 fc 29 84 0f 20 fe 	vmovaps %ymm0,-0x1e0(%rdi,%rcx,1)
    8a17:	ff ff 
    8a19:	c5 fc 29 84 0f 40 fe 	vmovaps %ymm0,-0x1c0(%rdi,%rcx,1)
    8a20:	ff ff 
    8a22:	c5 fc 29 84 0f 60 fe 	vmovaps %ymm0,-0x1a0(%rdi,%rcx,1)
    8a29:	ff ff 
    8a2b:	c5 fc 29 84 0f 80 fe 	vmovaps %ymm0,-0x180(%rdi,%rcx,1)
    8a32:	ff ff 
    8a34:	c5 fc 29 84 0f a0 fe 	vmovaps %ymm0,-0x160(%rdi,%rcx,1)
    8a3b:	ff ff 
    8a3d:	c5 fc 29 84 0f c0 fe 	vmovaps %ymm0,-0x140(%rdi,%rcx,1)
    8a44:	ff ff 
    8a46:	c5 fc 29 84 0f e0 fe 	vmovaps %ymm0,-0x120(%rdi,%rcx,1)
    8a4d:	ff ff 
    8a4f:	c5 fc 29 84 0f 00 ff 	vmovaps %ymm0,-0x100(%rdi,%rcx,1)
    8a56:	ff ff 
    8a58:	c5 fc 29 84 0f 20 ff 	vmovaps %ymm0,-0xe0(%rdi,%rcx,1)
    8a5f:	ff ff 
    8a61:	c5 fc 29 84 0f 40 ff 	vmovaps %ymm0,-0xc0(%rdi,%rcx,1)
    8a68:	ff ff 
    8a6a:	c5 fc 29 84 0f 60 ff 	vmovaps %ymm0,-0xa0(%rdi,%rcx,1)
    8a71:	ff ff 
    8a73:	c5 fc 29 44 0f 80    	vmovaps %ymm0,-0x80(%rdi,%rcx,1)
    8a79:	c5 fc 29 44 0f a0    	vmovaps %ymm0,-0x60(%rdi,%rcx,1)
    8a7f:	c5 fc 29 44 0f c0    	vmovaps %ymm0,-0x40(%rdi,%rcx,1)
    8a85:	c5 fc 29 44 0f e0    	vmovaps %ymm0,-0x20(%rdi,%rcx,1)
    8a8b:	c5 fc 29 04 0f       	vmovaps %ymm0,(%rdi,%rcx,1)
    8a90:	48 81 c1 00 04 00 00 	add    $0x400,%rcx
    8a97:	48 81 f9 00 20 00 00 	cmp    $0x2000,%rcx
    8a9e:	0f 85 dc fe ff ff    	jne    8980 <_Z9ahci_init10pci_device+0x40>
    8aa4:	44 8b 48 24          	mov    0x24(%rax),%r9d
    8aa8:	45 89 c8             	mov    %r9d,%r8d
    8aab:	44 89 c9             	mov    %r9d,%ecx
    8aae:	c1 e9 15             	shr    $0x15,%ecx
    8ab1:	48 83 8c cf 20 ec 01 	orq    $0x8,0x1ec20(%rdi,%rcx,8)
    8ab8:	00 08 
    8aba:	41 83 e0 f0          	and    $0xfffffff0,%r8d
    8abe:	0f b6 48 02          	movzbl 0x2(%rax),%ecx
    8ac2:	0f b7 00             	movzwl (%rax),%eax
    8ac5:	89 c2                	mov    %eax,%edx
    8ac7:	c1 e2 10             	shl    $0x10,%edx
    8aca:	c1 e0 03             	shl    $0x3,%eax
    8acd:	25 00 f8 07 00       	and    $0x7f800,%eax
    8ad2:	c1 e1 08             	shl    $0x8,%ecx
    8ad5:	09 d1                	or     %edx,%ecx
    8ad7:	09 c1                	or     %eax,%ecx
    8ad9:	81 e1 00 ff ff 00    	and    $0xffff00,%ecx
    8adf:	81 c9 04 00 00 80    	or     $0x80000004,%ecx
    8ae5:	89 c8                	mov    %ecx,%eax
    8ae7:	66 ba f8 0c          	mov    $0xcf8,%dx
    8aeb:	ef                   	out    %eax,(%dx)
    8aec:	66 ba fc 0c          	mov    $0xcfc,%dx
    8af0:	ed                   	in     (%dx),%eax
    8af1:	89 c6                	mov    %eax,%esi
    8af3:	83 ce 07             	or     $0x7,%esi
    8af6:	89 c8                	mov    %ecx,%eax
    8af8:	66 ba f8 0c          	mov    $0xcf8,%dx
    8afc:	ef                   	out    %eax,(%dx)
    8afd:	89 f0                	mov    %esi,%eax
    8aff:	66 ba fc 0c          	mov    $0xcfc,%dx
    8b03:	ef                   	out    %eax,(%dx)
    8b04:	41 81 c1 00 01 00 00 	add    $0x100,%r9d
    8b0b:	49 8d 81 a8 01 00 00 	lea    0x1a8(%r9),%rax
    8b12:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    8b17:	31 c9                	xor    %ecx,%ecx
    8b19:	eb 15                	jmp    8b30 <_Z9ahci_init10pci_device+0x1f0>
    8b1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    8b20:	48 83 c1 04          	add    $0x4,%rcx
    8b24:	48 05 00 02 00 00    	add    $0x200,%rax
    8b2a:	48 83 f9 20          	cmp    $0x20,%rcx
    8b2e:	74 5c                	je     8b8c <_Z9ahci_init10pci_device+0x24c>
    8b30:	41 8b 70 0c          	mov    0xc(%r8),%esi
    8b34:	0f a3 ce             	bt     %ecx,%esi
    8b37:	73 0a                	jae    8b43 <_Z9ahci_init10pci_device+0x203>
    8b39:	83 b8 80 fe ff ff 00 	cmpl   $0x0,-0x180(%rax)
    8b40:	0f 45 d1             	cmovne %ecx,%edx
    8b43:	45 8b 50 0c          	mov    0xc(%r8),%r10d
    8b47:	48 8d 71 01          	lea    0x1(%rcx),%rsi
    8b4b:	41 0f a3 f2          	bt     %esi,%r10d
    8b4f:	73 0c                	jae    8b5d <_Z9ahci_init10pci_device+0x21d>
    8b51:	83 b8 00 ff ff ff 00 	cmpl   $0x0,-0x100(%rax)
    8b58:	0f 44 f2             	cmove  %edx,%esi
    8b5b:	89 f2                	mov    %esi,%edx
    8b5d:	45 8b 50 0c          	mov    0xc(%r8),%r10d
    8b61:	48 8d 71 02          	lea    0x2(%rcx),%rsi
    8b65:	41 0f a3 f2          	bt     %esi,%r10d
    8b69:	73 09                	jae    8b74 <_Z9ahci_init10pci_device+0x234>
    8b6b:	83 78 80 00          	cmpl   $0x0,-0x80(%rax)
    8b6f:	0f 44 f2             	cmove  %edx,%esi
    8b72:	89 f2                	mov    %esi,%edx
    8b74:	45 8b 50 0c          	mov    0xc(%r8),%r10d
    8b78:	48 8d 71 03          	lea    0x3(%rcx),%rsi
    8b7c:	41 0f a3 f2          	bt     %esi,%r10d
    8b80:	73 9e                	jae    8b20 <_Z9ahci_init10pci_device+0x1e0>
    8b82:	83 38 00             	cmpl   $0x0,(%rax)
    8b85:	0f 44 f2             	cmove  %edx,%esi
    8b88:	89 f2                	mov    %esi,%edx
    8b8a:	eb 94                	jmp    8b20 <_Z9ahci_init10pci_device+0x1e0>
    8b8c:	48 63 d2             	movslq %edx,%rdx
    8b8f:	48 c1 e2 07          	shl    $0x7,%rdx
    8b93:	49 8d 04 11          	lea    (%r9,%rdx,1),%rax
    8b97:	48 83 c0 18          	add    $0x18,%rax
    8b9b:	41 83 64 11 18 ee    	andl   $0xffffffee,0x18(%r9,%rdx,1)
    8ba1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    8ba8:	0f 1f 84 00 00 00 00 
    8baf:	00 
    8bb0:	f7 00 00 c0 00 00    	testl  $0xc000,(%rax)
    8bb6:	75 f8                	jne    8bb0 <_Z9ahci_init10pci_device+0x270>
    8bb8:	49 8d 0c 11          	lea    (%r9,%rdx,1),%rcx
    8bbc:	41 c7 04 11 00 20 05 	movl   $0x52000,(%r9,%rdx,1)
    8bc3:	00 
    8bc4:	41 c7 44 11 04 00 00 	movl   $0x0,0x4(%r9,%rdx,1)
    8bcb:	00 00 
    8bcd:	41 c7 44 11 08 00 28 	movl   $0x52800,0x8(%r9,%rdx,1)
    8bd4:	05 00 
    8bd6:	41 c7 44 11 0c 00 00 	movl   $0x0,0xc(%r9,%rdx,1)
    8bdd:	00 00 
    8bdf:	ba 00 33 05 00       	mov    $0x53300,%edx
    8be4:	31 f6                	xor    %esi,%esi
    8be6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    8bed:	00 00 00 
    8bf0:	44 8d 8a 00 fd ff ff 	lea    -0x300(%rdx),%r9d
    8bf7:	44 89 8c 37 28 ec ff 	mov    %r9d,-0x13d8(%rdi,%rsi,1)
    8bfe:	ff 
    8bff:	c7 84 37 2c ec ff ff 	movl   $0x0,-0x13d4(%rdi,%rsi,1)
    8c06:	00 00 00 00 
    8c0a:	66 c7 84 37 22 ec ff 	movw   $0x8,-0x13de(%rdi,%rsi,1)
    8c11:	ff 08 00 
    8c14:	44 8d 8a 00 fe ff ff 	lea    -0x200(%rdx),%r9d
    8c1b:	44 89 8c 37 48 ec ff 	mov    %r9d,-0x13b8(%rdi,%rsi,1)
    8c22:	ff 
    8c23:	c7 84 37 4c ec ff ff 	movl   $0x0,-0x13b4(%rdi,%rsi,1)
    8c2a:	00 00 00 00 
    8c2e:	66 c7 84 37 42 ec ff 	movw   $0x8,-0x13be(%rdi,%rsi,1)
    8c35:	ff 08 00 
    8c38:	44 8d 8a 00 ff ff ff 	lea    -0x100(%rdx),%r9d
    8c3f:	44 89 8c 37 68 ec ff 	mov    %r9d,-0x1398(%rdi,%rsi,1)
    8c46:	ff 
    8c47:	c7 84 37 6c ec ff ff 	movl   $0x0,-0x1394(%rdi,%rsi,1)
    8c4e:	00 00 00 00 
    8c52:	66 c7 84 37 62 ec ff 	movw   $0x8,-0x139e(%rdi,%rsi,1)
    8c59:	ff 08 00 
    8c5c:	89 94 37 88 ec ff ff 	mov    %edx,-0x1378(%rdi,%rsi,1)
    8c63:	c7 84 37 8c ec ff ff 	movl   $0x0,-0x1374(%rdi,%rsi,1)
    8c6a:	00 00 00 00 
    8c6e:	66 c7 84 37 82 ec ff 	movw   $0x8,-0x137e(%rdi,%rsi,1)
    8c75:	ff 08 00 
    8c78:	48 83 ee 80          	sub    $0xffffffffffffff80,%rsi
    8c7c:	81 c2 00 04 00 00    	add    $0x400,%edx
    8c82:	48 81 fe 00 04 00 00 	cmp    $0x400,%rsi
    8c89:	0f 85 61 ff ff ff    	jne    8bf0 <_Z9ahci_init10pci_device+0x2b0>
    8c8f:	83 08 11             	orl    $0x11,(%rax)
    8c92:	8b 10                	mov    (%rax),%edx
    8c94:	f7 d2                	not    %edx
    8c96:	f7 c2 00 c0 00 00    	test   $0xc000,%edx
    8c9c:	74 2f                	je     8ccd <_Z9ahci_init10pci_device+0x38d>
    8c9e:	ba 02 00 00 02       	mov    $0x2000002,%edx
    8ca3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    8caa:	84 00 00 00 00 00 
    8cb0:	8b 30                	mov    (%rax),%esi
    8cb2:	f7 d6                	not    %esi
    8cb4:	f7 c6 00 c0 00 00    	test   $0xc000,%esi
    8cba:	74 11                	je     8ccd <_Z9ahci_init10pci_device+0x38d>
    8cbc:	83 c2 fe             	add    $0xfffffffe,%edx
    8cbf:	74 3c                	je     8cfd <_Z9ahci_init10pci_device+0x3bd>
    8cc1:	8b 30                	mov    (%rax),%esi
    8cc3:	f7 d6                	not    %esi
    8cc5:	f7 c6 00 c0 00 00    	test   $0xc000,%esi
    8ccb:	75 e3                	jne    8cb0 <_Z9ahci_init10pci_device+0x370>
    8ccd:	48 8b 04 25 d0 00 11 	mov    0x1100d0,%rax
    8cd4:	00 
    8cd5:	4c 89 00             	mov    %r8,(%rax)
    8cd8:	48 89 48 08          	mov    %rcx,0x8(%rax)
    8cdc:	48 c7 40 10 00 20 05 	movq   $0x52000,0x10(%rax)
    8ce3:	00 
    8ce4:	48 c7 40 18 00 28 05 	movq   $0x52800,0x18(%rax)
    8ceb:	00 
    8cec:	48 c7 40 20 00 30 05 	movq   $0x53000,0x20(%rax)
    8cf3:	00 
    8cf4:	48 83 c4 20          	add    $0x20,%rsp
    8cf8:	5b                   	pop    %rbx
    8cf9:	c5 f8 77             	vzeroupper 
    8cfc:	c3                   	ret    
    8cfd:	48 c7 04 24 07 0c 01 	movq   $0x10c07,(%rsp)
    8d04:	00 
    8d05:	c7 44 24 08 19 00 00 	movl   $0x19,0x8(%rsp)
    8d0c:	00 
    8d0d:	8b 10                	mov    (%rax),%edx
    8d0f:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
    8d14:	48 89 e6             	mov    %rsp,%rsi
    8d17:	48 89 df             	mov    %rbx,%rdi
    8d1a:	31 c0                	xor    %eax,%eax
    8d1c:	c5 f8 77             	vzeroupper 
    8d1f:	e8 7c 00 00 00       	call   8da0 <_Z6format8rostringz>
    8d24:	48 89 df             	mov    %rbx,%rdi
    8d27:	e8 a4 0e 00 00       	call   9bd0 <_ZN6string10c_str_thisEv>
    8d2c:	bf 00 00 11 00       	mov    $0x110000,%edi
    8d31:	48 89 c6             	mov    %rax,%rsi
    8d34:	e8 27 00 00 00       	call   8d60 <_ZN7console6putstrEPKc>
    8d39:	48 89 df             	mov    %rbx,%rdi
    8d3c:	e8 3f 28 00 00       	call   b580 <_ZN6vectorIcED2Ev>
    8d41:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    8d48:	0f 1f 84 00 00 00 00 
    8d4f:	00 
    8d50:	eb fe                	jmp    8d50 <_Z9ahci_init10pci_device+0x410>
    8d52:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    8d59:	00 00 00 
    8d5c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000008d60 <_ZN7console6putstrEPKc>:
    8d60:	0f b6 06             	movzbl (%rsi),%eax
    8d63:	84 c0                	test   %al,%al
    8d65:	74 35                	je     8d9c <_ZN7console6putstrEPKc+0x3c>
    8d67:	41 56                	push   %r14
    8d69:	53                   	push   %rbx
    8d6a:	50                   	push   %rax
    8d6b:	48 89 f3             	mov    %rsi,%rbx
    8d6e:	49 89 fe             	mov    %rdi,%r14
    8d71:	48 ff c3             	inc    %rbx
    8d74:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    8d7b:	00 00 00 00 00 
    8d80:	0f be f0             	movsbl %al,%esi
    8d83:	4c 89 f7             	mov    %r14,%rdi
    8d86:	e8 e5 31 00 00       	call   bf70 <_ZN7console7putcharEc>
    8d8b:	0f b6 03             	movzbl (%rbx),%eax
    8d8e:	48 ff c3             	inc    %rbx
    8d91:	84 c0                	test   %al,%al
    8d93:	75 eb                	jne    8d80 <_ZN7console6putstrEPKc+0x20>
    8d95:	48 83 c4 08          	add    $0x8,%rsp
    8d99:	5b                   	pop    %rbx
    8d9a:	41 5e                	pop    %r14
    8d9c:	c3                   	ret    
    8d9d:	0f 1f 00             	nopl   (%rax)

0000000000008da0 <_Z6format8rostringz>:
    8da0:	55                   	push   %rbp
    8da1:	41 57                	push   %r15
    8da3:	41 56                	push   %r14
    8da5:	41 55                	push   %r13
    8da7:	41 54                	push   %r12
    8da9:	53                   	push   %rbx
    8daa:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
    8db1:	48 89 94 24 c0 00 00 	mov    %rdx,0xc0(%rsp)
    8db8:	00 
    8db9:	48 89 8c 24 c8 00 00 	mov    %rcx,0xc8(%rsp)
    8dc0:	00 
    8dc1:	4c 89 84 24 d0 00 00 	mov    %r8,0xd0(%rsp)
    8dc8:	00 
    8dc9:	4c 89 8c 24 d8 00 00 	mov    %r9,0xd8(%rsp)
    8dd0:	00 
    8dd1:	84 c0                	test   %al,%al
    8dd3:	74 48                	je     8e1d <_Z6format8rostringz+0x7d>
    8dd5:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
    8ddc:	00 00 
    8dde:	c5 f8 29 8c 24 f0 00 	vmovaps %xmm1,0xf0(%rsp)
    8de5:	00 00 
    8de7:	c5 f8 29 94 24 00 01 	vmovaps %xmm2,0x100(%rsp)
    8dee:	00 00 
    8df0:	c5 f8 29 9c 24 10 01 	vmovaps %xmm3,0x110(%rsp)
    8df7:	00 00 
    8df9:	c5 f8 29 a4 24 20 01 	vmovaps %xmm4,0x120(%rsp)
    8e00:	00 00 
    8e02:	c5 f8 29 ac 24 30 01 	vmovaps %xmm5,0x130(%rsp)
    8e09:	00 00 
    8e0b:	c5 f8 29 b4 24 40 01 	vmovaps %xmm6,0x140(%rsp)
    8e12:	00 00 
    8e14:	c5 f8 29 bc 24 50 01 	vmovaps %xmm7,0x150(%rsp)
    8e1b:	00 00 
    8e1d:	48 8d 84 24 b0 00 00 	lea    0xb0(%rsp),%rax
    8e24:	00 
    8e25:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
    8e2a:	48 8d 84 24 a0 01 00 	lea    0x1a0(%rsp),%rax
    8e31:	00 
    8e32:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
    8e37:	48 b8 10 00 00 00 30 	movabs $0x3000000010,%rax
    8e3e:	00 00 00 
    8e41:	48 89 04 24          	mov    %rax,(%rsp)
    8e45:	8b 46 08             	mov    0x8(%rsi),%eax
    8e48:	48 8b 0e             	mov    (%rsi),%rcx
    8e4b:	89 44 24 58          	mov    %eax,0x58(%rsp)
    8e4f:	8b 44 24 58          	mov    0x58(%rsp),%eax
    8e53:	89 44 24 30          	mov    %eax,0x30(%rsp)
    8e57:	8b 44 24 30          	mov    0x30(%rsp),%eax
    8e5b:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
    8e60:	89 44 24 68          	mov    %eax,0x68(%rsp)
    8e64:	c7 44 24 70 00 00 00 	movl   $0x0,0x70(%rsp)
    8e6b:	00 
    8e6c:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    8e70:	c5 f8 11 44 24 18    	vmovups %xmm0,0x18(%rsp)
    8e76:	8b 46 08             	mov    0x8(%rsi),%eax
    8e79:	85 c0                	test   %eax,%eax
    8e7b:	48 89 bc 24 80 00 00 	mov    %rdi,0x80(%rsp)
    8e82:	00 
    8e83:	0f 8e ce 00 00 00    	jle    8f57 <_Z6format8rostringz+0x1b7>
    8e89:	48 8d 48 1f          	lea    0x1f(%rax),%rcx
    8e8d:	48 83 e1 f0          	and    $0xfffffffffffffff0,%rcx
    8e91:	ba 10 00 00 00       	mov    $0x10,%edx
    8e96:	48 0f 45 d1          	cmovne %rcx,%rdx
    8e9a:	4c 8b 0c 25 00 00 00 	mov    0x1000000,%r9
    8ea1:	01 
    8ea2:	be 00 00 00 01       	mov    $0x1000000,%esi
    8ea7:	49 39 d1             	cmp    %rdx,%r9
    8eaa:	73 10                	jae    8ebc <_Z6format8rostringz+0x11c>
    8eac:	0f 1f 40 00          	nopl   0x0(%rax)
    8eb0:	48 8b 76 08          	mov    0x8(%rsi),%rsi
    8eb4:	4c 8b 0e             	mov    (%rsi),%r9
    8eb7:	49 39 d1             	cmp    %rdx,%r9
    8eba:	72 f4                	jb     8eb0 <_Z6format8rostringz+0x110>
    8ebc:	48 8b 4e 08          	mov    0x8(%rsi),%rcx
    8ec0:	4d 89 c8             	mov    %r9,%r8
    8ec3:	49 29 d0             	sub    %rdx,%r8
    8ec6:	49 83 f8 10          	cmp    $0x10,%r8
    8eca:	0f 83 9c 00 00 00    	jae    8f6c <_Z6format8rostringz+0x1cc>
    8ed0:	c5 f8 10 01          	vmovups (%rcx),%xmm0
    8ed4:	c5 f8 11 06          	vmovups %xmm0,(%rsi)
    8ed8:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
    8edd:	4c 89 09             	mov    %r9,(%rcx)
    8ee0:	48 83 c1 10          	add    $0x10,%rcx
    8ee4:	4c 01 0c 25 28 00 11 	add    %r9,0x110028
    8eeb:	00 
    8eec:	48 85 d2             	test   %rdx,%rdx
    8eef:	0f 84 99 00 00 00    	je     8f8e <_Z6format8rostringz+0x1ee>
    8ef5:	83 7c 24 20 00       	cmpl   $0x0,0x20(%rsp)
    8efa:	7e 28                	jle    8f24 <_Z6format8rostringz+0x184>
    8efc:	31 d2                	xor    %edx,%edx
    8efe:	66 90                	xchg   %ax,%ax
    8f00:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
    8f05:	0f b6 34 16          	movzbl (%rsi,%rdx,1),%esi
    8f09:	40 88 34 11          	mov    %sil,(%rcx,%rdx,1)
    8f0d:	48 ff c2             	inc    %rdx
    8f10:	48 63 74 24 20       	movslq 0x20(%rsp),%rsi
    8f15:	48 39 f2             	cmp    %rsi,%rdx
    8f18:	7c e6                	jl     8f00 <_Z6format8rostringz+0x160>
    8f1a:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
    8f1f:	48 85 d2             	test   %rdx,%rdx
    8f22:	74 6a                	je     8f8e <_Z6format8rostringz+0x1ee>
    8f24:	48 8d 72 f0          	lea    -0x10(%rdx),%rsi
    8f28:	48 8b 7a f0          	mov    -0x10(%rdx),%rdi
    8f2c:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    8f33:	00 01 
    8f35:	c5 f8 11 42 f0       	vmovups %xmm0,-0x10(%rdx)
    8f3a:	48 89 3c 25 00 00 00 	mov    %rdi,0x1000000
    8f41:	01 
    8f42:	48 89 34 25 08 00 00 	mov    %rsi,0x1000008
    8f49:	01 
    8f4a:	48 8b 14 25 28 00 11 	mov    0x110028,%rdx
    8f51:	00 
    8f52:	48 29 fa             	sub    %rdi,%rdx
    8f55:	eb 2f                	jmp    8f86 <_Z6format8rostringz+0x1e6>
    8f57:	31 c0                	xor    %eax,%eax
    8f59:	c7 44 24 28 0a 00 00 	movl   $0xa,0x28(%rsp)
    8f60:	00 
    8f61:	3b 44 24 68          	cmp    0x68(%rsp),%eax
    8f65:	7c 46                	jl     8fad <_Z6format8rostringz+0x20d>
    8f67:	e9 25 0a 00 00       	jmp    9991 <_Z6format8rostringz+0xbf1>
    8f6c:	4c 89 06             	mov    %r8,(%rsi)
    8f6f:	49 c1 e0 04          	shl    $0x4,%r8
    8f73:	4a 89 14 01          	mov    %rdx,(%rcx,%r8,1)
    8f77:	4c 01 c1             	add    %r8,%rcx
    8f7a:	48 83 c1 10          	add    $0x10,%rcx
    8f7e:	48 03 14 25 28 00 11 	add    0x110028,%rdx
    8f85:	00 
    8f86:	48 89 14 25 28 00 11 	mov    %rdx,0x110028
    8f8d:	00 
    8f8e:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
    8f93:	89 44 24 24          	mov    %eax,0x24(%rsp)
    8f97:	8b 44 24 70          	mov    0x70(%rsp),%eax
    8f9b:	c7 44 24 28 0a 00 00 	movl   $0xa,0x28(%rsp)
    8fa2:	00 
    8fa3:	3b 44 24 68          	cmp    0x68(%rsp),%eax
    8fa7:	0f 8d e4 09 00 00    	jge    9991 <_Z6format8rostringz+0xbf1>
    8fad:	4c 8d 74 24 18       	lea    0x18(%rsp),%r14
    8fb2:	48 8d 6c 24 30       	lea    0x30(%rsp),%rbp
    8fb7:	eb 3c                	jmp    8ff5 <_Z6format8rostringz+0x255>
    8fb9:	48 89 31             	mov    %rsi,(%rcx)
    8fbc:	48 c1 e6 04          	shl    $0x4,%rsi
    8fc0:	48 01 f2             	add    %rsi,%rdx
    8fc3:	b8 20 00 00 00       	mov    $0x20,%eax
    8fc8:	48 89 02             	mov    %rax,(%rdx)
    8fcb:	48 01 04 25 28 00 11 	add    %rax,0x110028
    8fd2:	00 
    8fd3:	c6 42 10 00          	movb   $0x0,0x10(%rdx)
    8fd7:	31 db                	xor    %ebx,%ebx
    8fd9:	8b 74 24 20          	mov    0x20(%rsp),%esi
    8fdd:	4c 89 f7             	mov    %r14,%rdi
    8fe0:	e8 7b 6d 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    8fe5:	88 18                	mov    %bl,(%rax)
    8fe7:	8b 44 24 70          	mov    0x70(%rsp),%eax
    8feb:	3b 44 24 68          	cmp    0x68(%rsp),%eax
    8fef:	0f 8d 9c 09 00 00    	jge    9991 <_Z6format8rostringz+0xbf1>
    8ff5:	8d 48 01             	lea    0x1(%rax),%ecx
    8ff8:	89 4c 24 70          	mov    %ecx,0x70(%rsp)
    8ffc:	83 7c 24 68 00       	cmpl   $0x0,0x68(%rsp)
    9001:	0f 84 99 03 00 00    	je     93a0 <_Z6format8rostringz+0x600>
    9007:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
    900c:	48 98                	cltq   
    900e:	0f b6 1c 01          	movzbl (%rcx,%rax,1),%ebx
    9012:	80 fb 25             	cmp    $0x25,%bl
    9015:	75 c2                	jne    8fd9 <_Z6format8rostringz+0x239>
    9017:	8b 44 24 28          	mov    0x28(%rsp),%eax
    901b:	48 c7 84 24 90 00 00 	movq   $0x10cb9,0x90(%rsp)
    9022:	00 b9 0c 01 00 
    9027:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
    902e:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
    9035:	00 
    9036:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
    903b:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
    9042:	00 
    9043:	e8 28 48 00 00       	call   d870 <_ZN13istringstream18read_until_any_incE8rostring>
    9048:	8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%eax
    904f:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
    9056:	00 
    9057:	89 44 24 48          	mov    %eax,0x48(%rsp)
    905b:	8b 44 24 48          	mov    0x48(%rsp),%eax
    905f:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
    9064:	89 44 24 38          	mov    %eax,0x38(%rsp)
    9068:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
    906f:	00 
    9070:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    9075:	0f 8e 71 03 00 00    	jle    93ec <_Z6format8rostringz+0x64c>
    907b:	41 bc 03 00 00 00    	mov    $0x3,%r12d
    9081:	41 b5 20             	mov    $0x20,%r13b
    9084:	31 c9                	xor    %ecx,%ecx
    9086:	45 31 ff             	xor    %r15d,%r15d
    9089:	eb 2d                	jmp    90b8 <_Z6format8rostringz+0x318>
    908b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    9090:	ff 44 24 40          	incl   0x40(%rsp)
    9094:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    9099:	0f 84 03 02 00 00    	je     92a2 <_Z6format8rostringz+0x502>
    909f:	48 89 ef             	mov    %rbp,%rdi
    90a2:	e8 c9 44 00 00       	call   d570 <_ZN13istringstream4readIlEET_v>
    90a7:	49 89 c4             	mov    %rax,%r12
    90aa:	8b 4c 24 40          	mov    0x40(%rsp),%ecx
    90ae:	3b 4c 24 38          	cmp    0x38(%rsp),%ecx
    90b2:	0f 8d 40 03 00 00    	jge    93f8 <_Z6format8rostringz+0x658>
    90b8:	8d 41 01             	lea    0x1(%rcx),%eax
    90bb:	89 44 24 40          	mov    %eax,0x40(%rsp)
    90bf:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    90c4:	74 2a                	je     90f0 <_Z6format8rostringz+0x350>
    90c6:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
    90cb:	48 63 d1             	movslq %ecx,%rdx
    90ce:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax
    90d2:	89 4c 24 40          	mov    %ecx,0x40(%rsp)
    90d6:	83 7c 24 28 00       	cmpl   $0x0,0x28(%rsp)
    90db:	0f 8f 83 00 00 00    	jg     9164 <_Z6format8rostringz+0x3c4>
    90e1:	e9 32 01 00 00       	jmp    9218 <_Z6format8rostringz+0x478>
    90e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    90ed:	00 00 00 
    90f0:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    90f7:	01 
    90f8:	ba 00 00 00 01       	mov    $0x1000000,%edx
    90fd:	48 83 f8 1f          	cmp    $0x1f,%rax
    9101:	77 1a                	ja     911d <_Z6format8rostringz+0x37d>
    9103:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    910a:	84 00 00 00 00 00 
    9110:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    9114:	48 8b 02             	mov    (%rdx),%rax
    9117:	48 83 f8 20          	cmp    $0x20,%rax
    911b:	72 f3                	jb     9110 <_Z6format8rostringz+0x370>
    911d:	48 8b 72 08          	mov    0x8(%rdx),%rsi
    9121:	48 8d 78 e0          	lea    -0x20(%rax),%rdi
    9125:	48 83 ff 0f          	cmp    $0xf,%rdi
    9129:	77 0a                	ja     9135 <_Z6format8rostringz+0x395>
    912b:	c5 f8 10 06          	vmovups (%rsi),%xmm0
    912f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    9133:	eb 0f                	jmp    9144 <_Z6format8rostringz+0x3a4>
    9135:	48 89 3a             	mov    %rdi,(%rdx)
    9138:	48 c1 e7 04          	shl    $0x4,%rdi
    913c:	48 01 fe             	add    %rdi,%rsi
    913f:	b8 20 00 00 00       	mov    $0x20,%eax
    9144:	48 89 06             	mov    %rax,(%rsi)
    9147:	48 01 04 25 28 00 11 	add    %rax,0x110028
    914e:	00 
    914f:	c6 46 10 00          	movb   $0x0,0x10(%rsi)
    9153:	31 c0                	xor    %eax,%eax
    9155:	89 4c 24 40          	mov    %ecx,0x40(%rsp)
    9159:	83 7c 24 28 00       	cmpl   $0x0,0x28(%rsp)
    915e:	0f 8e b4 00 00 00    	jle    9218 <_Z6format8rostringz+0x478>
    9164:	31 c9                	xor    %ecx,%ecx
    9166:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    916d:	00 00 00 
    9170:	83 7c 24 28 00       	cmpl   $0x0,0x28(%rsp)
    9175:	74 19                	je     9190 <_Z6format8rostringz+0x3f0>
    9177:	0f b6 91 b9 0c 01 00 	movzbl 0x10cb9(%rcx),%edx
    917e:	38 c2                	cmp    %al,%dl
    9180:	75 77                	jne    91f9 <_Z6format8rostringz+0x459>
    9182:	e9 89 00 00 00       	jmp    9210 <_Z6format8rostringz+0x470>
    9187:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    918e:	00 00 
    9190:	48 8b 14 25 00 00 00 	mov    0x1000000,%rdx
    9197:	01 
    9198:	be 00 00 00 01       	mov    $0x1000000,%esi
    919d:	48 83 fa 1f          	cmp    $0x1f,%rdx
    91a1:	77 1a                	ja     91bd <_Z6format8rostringz+0x41d>
    91a3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    91aa:	84 00 00 00 00 00 
    91b0:	48 8b 76 08          	mov    0x8(%rsi),%rsi
    91b4:	48 8b 16             	mov    (%rsi),%rdx
    91b7:	48 83 fa 20          	cmp    $0x20,%rdx
    91bb:	72 f3                	jb     91b0 <_Z6format8rostringz+0x410>
    91bd:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
    91c1:	4c 8d 42 e0          	lea    -0x20(%rdx),%r8
    91c5:	49 83 f8 0f          	cmp    $0xf,%r8
    91c9:	77 0a                	ja     91d5 <_Z6format8rostringz+0x435>
    91cb:	c5 f8 10 07          	vmovups (%rdi),%xmm0
    91cf:	c5 f8 11 06          	vmovups %xmm0,(%rsi)
    91d3:	eb 0f                	jmp    91e4 <_Z6format8rostringz+0x444>
    91d5:	4c 89 06             	mov    %r8,(%rsi)
    91d8:	49 c1 e0 04          	shl    $0x4,%r8
    91dc:	4c 01 c7             	add    %r8,%rdi
    91df:	ba 20 00 00 00       	mov    $0x20,%edx
    91e4:	48 89 17             	mov    %rdx,(%rdi)
    91e7:	48 01 14 25 28 00 11 	add    %rdx,0x110028
    91ee:	00 
    91ef:	c6 47 10 00          	movb   $0x0,0x10(%rdi)
    91f3:	31 d2                	xor    %edx,%edx
    91f5:	38 c2                	cmp    %al,%dl
    91f7:	74 17                	je     9210 <_Z6format8rostringz+0x470>
    91f9:	48 ff c1             	inc    %rcx
    91fc:	48 63 54 24 28       	movslq 0x28(%rsp),%rdx
    9201:	48 39 d1             	cmp    %rdx,%rcx
    9204:	0f 8c 66 ff ff ff    	jl     9170 <_Z6format8rostringz+0x3d0>
    920a:	eb 0c                	jmp    9218 <_Z6format8rostringz+0x478>
    920c:	0f 1f 40 00          	nopl   0x0(%rax)
    9210:	85 c9                	test   %ecx,%ecx
    9212:	0f 89 e0 01 00 00    	jns    93f8 <_Z6format8rostringz+0x658>
    9218:	3c 2e                	cmp    $0x2e,%al
    921a:	0f 84 70 fe ff ff    	je     9090 <_Z6format8rostringz+0x2f0>
    9220:	0f b6 c0             	movzbl %al,%eax
    9223:	83 f8 7a             	cmp    $0x7a,%eax
    9226:	74 05                	je     922d <_Z6format8rostringz+0x48d>
    9228:	83 f8 6c             	cmp    $0x6c,%eax
    922b:	75 53                	jne    9280 <_Z6format8rostringz+0x4e0>
    922d:	ff 44 24 40          	incl   0x40(%rsp)
    9231:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    9236:	0f 85 6e fe ff ff    	jne    90aa <_Z6format8rostringz+0x30a>
    923c:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    9243:	01 
    9244:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    9249:	48 83 f8 1f          	cmp    $0x1f,%rax
    924d:	77 0e                	ja     925d <_Z6format8rostringz+0x4bd>
    924f:	90                   	nop
    9250:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    9254:	48 8b 01             	mov    (%rcx),%rax
    9257:	48 83 f8 20          	cmp    $0x20,%rax
    925b:	72 f3                	jb     9250 <_Z6format8rostringz+0x4b0>
    925d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    9261:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    9265:	48 83 fe 0f          	cmp    $0xf,%rsi
    9269:	77 7a                	ja     92e5 <_Z6format8rostringz+0x545>
    926b:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    926f:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    9273:	eb 7f                	jmp    92f4 <_Z6format8rostringz+0x554>
    9275:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    927c:	00 00 00 00 
    9280:	48 63 44 24 40       	movslq 0x40(%rsp),%rax
    9285:	8d 48 01             	lea    0x1(%rax),%ecx
    9288:	89 4c 24 40          	mov    %ecx,0x40(%rsp)
    928c:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    9291:	74 75                	je     9308 <_Z6format8rostringz+0x568>
    9293:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
    9298:	44 0f b6 2c 01       	movzbl (%rcx,%rax,1),%r13d
    929d:	e9 e7 00 00 00       	jmp    9389 <_Z6format8rostringz+0x5e9>
    92a2:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    92a9:	01 
    92aa:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    92af:	48 83 f8 1f          	cmp    $0x1f,%rax
    92b3:	77 18                	ja     92cd <_Z6format8rostringz+0x52d>
    92b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    92bc:	00 00 00 00 
    92c0:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    92c4:	48 8b 01             	mov    (%rcx),%rax
    92c7:	48 83 f8 20          	cmp    $0x20,%rax
    92cb:	72 f3                	jb     92c0 <_Z6format8rostringz+0x520>
    92cd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    92d1:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    92d5:	48 83 fe 0f          	cmp    $0xf,%rsi
    92d9:	77 6a                	ja     9345 <_Z6format8rostringz+0x5a5>
    92db:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    92df:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    92e3:	eb 6f                	jmp    9354 <_Z6format8rostringz+0x5b4>
    92e5:	48 89 31             	mov    %rsi,(%rcx)
    92e8:	48 c1 e6 04          	shl    $0x4,%rsi
    92ec:	48 01 f2             	add    %rsi,%rdx
    92ef:	b8 20 00 00 00       	mov    $0x20,%eax
    92f4:	48 89 02             	mov    %rax,(%rdx)
    92f7:	48 01 04 25 28 00 11 	add    %rax,0x110028
    92fe:	00 
    92ff:	c6 42 10 00          	movb   $0x0,0x10(%rdx)
    9303:	e9 a2 fd ff ff       	jmp    90aa <_Z6format8rostringz+0x30a>
    9308:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    930f:	01 
    9310:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    9315:	48 83 f8 1f          	cmp    $0x1f,%rax
    9319:	77 12                	ja     932d <_Z6format8rostringz+0x58d>
    931b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    9320:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    9324:	48 8b 01             	mov    (%rcx),%rax
    9327:	48 83 f8 20          	cmp    $0x20,%rax
    932b:	72 f3                	jb     9320 <_Z6format8rostringz+0x580>
    932d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    9331:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    9335:	48 83 fe 0f          	cmp    $0xf,%rsi
    9339:	77 2d                	ja     9368 <_Z6format8rostringz+0x5c8>
    933b:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    933f:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    9343:	eb 32                	jmp    9377 <_Z6format8rostringz+0x5d7>
    9345:	48 89 31             	mov    %rsi,(%rcx)
    9348:	48 c1 e6 04          	shl    $0x4,%rsi
    934c:	48 01 f2             	add    %rsi,%rdx
    934f:	b8 20 00 00 00       	mov    $0x20,%eax
    9354:	48 89 02             	mov    %rax,(%rdx)
    9357:	48 01 04 25 28 00 11 	add    %rax,0x110028
    935e:	00 
    935f:	c6 42 10 00          	movb   $0x0,0x10(%rdx)
    9363:	e9 37 fd ff ff       	jmp    909f <_Z6format8rostringz+0x2ff>
    9368:	48 89 31             	mov    %rsi,(%rcx)
    936b:	48 c1 e6 04          	shl    $0x4,%rsi
    936f:	48 01 f2             	add    %rsi,%rdx
    9372:	b8 20 00 00 00       	mov    $0x20,%eax
    9377:	48 89 02             	mov    %rax,(%rdx)
    937a:	48 01 04 25 28 00 11 	add    %rax,0x110028
    9381:	00 
    9382:	c6 42 10 00          	movb   $0x0,0x10(%rdx)
    9386:	45 31 ed             	xor    %r13d,%r13d
    9389:	48 89 ef             	mov    %rbp,%rdi
    938c:	e8 df 41 00 00       	call   d570 <_ZN13istringstream4readIlEET_v>
    9391:	49 89 c7             	mov    %rax,%r15
    9394:	e9 11 fd ff ff       	jmp    90aa <_Z6format8rostringz+0x30a>
    9399:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    93a0:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    93a7:	01 
    93a8:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    93ad:	48 83 f8 1f          	cmp    $0x1f,%rax
    93b1:	77 1a                	ja     93cd <_Z6format8rostringz+0x62d>
    93b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    93ba:	84 00 00 00 00 00 
    93c0:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    93c4:	48 8b 01             	mov    (%rcx),%rax
    93c7:	48 83 f8 20          	cmp    $0x20,%rax
    93cb:	72 f3                	jb     93c0 <_Z6format8rostringz+0x620>
    93cd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    93d1:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    93d5:	48 83 fe 0f          	cmp    $0xf,%rsi
    93d9:	0f 87 da fb ff ff    	ja     8fb9 <_Z6format8rostringz+0x219>
    93df:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    93e3:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    93e7:	e9 dc fb ff ff       	jmp    8fc8 <_Z6format8rostringz+0x228>
    93ec:	45 31 ff             	xor    %r15d,%r15d
    93ef:	41 b5 20             	mov    $0x20,%r13b
    93f2:	41 bc 03 00 00 00    	mov    $0x3,%r12d
    93f8:	48 63 44 24 38       	movslq 0x38(%rsp),%rax
    93fd:	83 7c 24 38 00       	cmpl   $0x0,0x38(%rsp)
    9402:	74 3d                	je     9441 <_Z6format8rostringz+0x6a1>
    9404:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
    9409:	0f b6 44 08 ff       	movzbl -0x1(%rax,%rcx,1),%eax
    940e:	83 c0 b7             	add    $0xffffffb7,%eax
    9411:	83 f8 2f             	cmp    $0x2f,%eax
    9414:	0f 87 cd fb ff ff    	ja     8fe7 <_Z6format8rostringz+0x247>
    941a:	ff 24 c5 28 03 01 00 	jmp    *0x10328(,%rax,8)
    9421:	8b 0c 24             	mov    (%rsp),%ecx
    9424:	48 83 f9 28          	cmp    $0x28,%rcx
    9428:	0f 87 c2 01 00 00    	ja     95f0 <_Z6format8rostringz+0x850>
    942e:	48 89 c8             	mov    %rcx,%rax
    9431:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9436:	83 c1 08             	add    $0x8,%ecx
    9439:	89 0c 24             	mov    %ecx,(%rsp)
    943c:	e9 bd 01 00 00       	jmp    95fe <_Z6format8rostringz+0x85e>
    9441:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    9448:	01 
    9449:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    944e:	48 83 f8 1f          	cmp    $0x1f,%rax
    9452:	77 19                	ja     946d <_Z6format8rostringz+0x6cd>
    9454:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    945b:	00 00 00 00 00 
    9460:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    9464:	48 8b 01             	mov    (%rcx),%rax
    9467:	48 83 f8 20          	cmp    $0x20,%rax
    946b:	72 f3                	jb     9460 <_Z6format8rostringz+0x6c0>
    946d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    9471:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    9475:	48 83 fe 0f          	cmp    $0xf,%rsi
    9479:	77 0a                	ja     9485 <_Z6format8rostringz+0x6e5>
    947b:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    947f:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    9483:	eb 0f                	jmp    9494 <_Z6format8rostringz+0x6f4>
    9485:	48 89 31             	mov    %rsi,(%rcx)
    9488:	48 c1 e6 04          	shl    $0x4,%rsi
    948c:	48 01 f2             	add    %rsi,%rdx
    948f:	b8 20 00 00 00       	mov    $0x20,%eax
    9494:	48 89 02             	mov    %rax,(%rdx)
    9497:	48 01 04 25 28 00 11 	add    %rax,0x110028
    949e:	00 
    949f:	c6 42 10 00          	movb   $0x0,0x10(%rdx)
    94a3:	e9 3f fb ff ff       	jmp    8fe7 <_Z6format8rostringz+0x247>
    94a8:	8b 0c 24             	mov    (%rsp),%ecx
    94ab:	48 83 f9 28          	cmp    $0x28,%rcx
    94af:	0f 87 ff 01 00 00    	ja     96b4 <_Z6format8rostringz+0x914>
    94b5:	48 89 c8             	mov    %rcx,%rax
    94b8:	48 03 44 24 10       	add    0x10(%rsp),%rax
    94bd:	83 c1 08             	add    $0x8,%ecx
    94c0:	89 0c 24             	mov    %ecx,(%rsp)
    94c3:	e9 fa 01 00 00       	jmp    96c2 <_Z6format8rostringz+0x922>
    94c8:	8b 0c 24             	mov    (%rsp),%ecx
    94cb:	48 83 f9 28          	cmp    $0x28,%rcx
    94cf:	0f 87 26 03 00 00    	ja     97fb <_Z6format8rostringz+0xa5b>
    94d5:	48 89 c8             	mov    %rcx,%rax
    94d8:	48 03 44 24 10       	add    0x10(%rsp),%rax
    94dd:	83 c1 08             	add    $0x8,%ecx
    94e0:	89 0c 24             	mov    %ecx,(%rsp)
    94e3:	e9 21 03 00 00       	jmp    9809 <_Z6format8rostringz+0xa69>
    94e8:	8b 0c 24             	mov    (%rsp),%ecx
    94eb:	48 83 f9 28          	cmp    $0x28,%rcx
    94ef:	0f 87 6c 03 00 00    	ja     9861 <_Z6format8rostringz+0xac1>
    94f5:	48 89 c8             	mov    %rcx,%rax
    94f8:	48 03 44 24 10       	add    0x10(%rsp),%rax
    94fd:	83 c1 08             	add    $0x8,%ecx
    9500:	89 0c 24             	mov    %ecx,(%rsp)
    9503:	e9 67 03 00 00       	jmp    986f <_Z6format8rostringz+0xacf>
    9508:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
    950c:	48 81 f9 a0 00 00 00 	cmp    $0xa0,%rcx
    9513:	0f 87 73 03 00 00    	ja     988c <_Z6format8rostringz+0xaec>
    9519:	48 89 c8             	mov    %rcx,%rax
    951c:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9521:	83 c1 10             	add    $0x10,%ecx
    9524:	89 4c 24 04          	mov    %ecx,0x4(%rsp)
    9528:	e9 6d 03 00 00       	jmp    989a <_Z6format8rostringz+0xafa>
    952d:	8b 0c 24             	mov    (%rsp),%ecx
    9530:	48 83 f9 28          	cmp    $0x28,%rcx
    9534:	0f 87 7b 03 00 00    	ja     98b5 <_Z6format8rostringz+0xb15>
    953a:	48 89 c8             	mov    %rcx,%rax
    953d:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9542:	83 c1 08             	add    $0x8,%ecx
    9545:	89 0c 24             	mov    %ecx,(%rsp)
    9548:	4c 8b 20             	mov    (%rax),%r12
    954b:	4d 85 e4             	test   %r12,%r12
    954e:	0f 89 89 03 00 00    	jns    98dd <_Z6format8rostringz+0xb3d>
    9554:	e9 72 03 00 00       	jmp    98cb <_Z6format8rostringz+0xb2b>
    9559:	8b 74 24 20          	mov    0x20(%rsp),%esi
    955d:	4c 89 f7             	mov    %r14,%rdi
    9560:	e8 fb 67 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9565:	c6 00 30             	movb   $0x30,(%rax)
    9568:	8b 74 24 20          	mov    0x20(%rsp),%esi
    956c:	4c 89 f7             	mov    %r14,%rdi
    956f:	e8 ec 67 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9574:	c6 00 78             	movb   $0x78,(%rax)
    9577:	8b 0c 24             	mov    (%rsp),%ecx
    957a:	48 83 f9 28          	cmp    $0x28,%rcx
    957e:	77 50                	ja     95d0 <_Z6format8rostringz+0x830>
    9580:	48 89 c8             	mov    %rcx,%rax
    9583:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9588:	83 c1 08             	add    $0x8,%ecx
    958b:	89 0c 24             	mov    %ecx,(%rsp)
    958e:	eb 4e                	jmp    95de <_Z6format8rostringz+0x83e>
    9590:	8b 0c 24             	mov    (%rsp),%ecx
    9593:	48 83 f9 28          	cmp    $0x28,%rcx
    9597:	0f 87 5d 03 00 00    	ja     98fa <_Z6format8rostringz+0xb5a>
    959d:	48 89 c8             	mov    %rcx,%rax
    95a0:	48 03 44 24 10       	add    0x10(%rsp),%rax
    95a5:	83 c1 08             	add    $0x8,%ecx
    95a8:	89 0c 24             	mov    %ecx,(%rsp)
    95ab:	e9 58 03 00 00       	jmp    9908 <_Z6format8rostringz+0xb68>
    95b0:	8b 0c 24             	mov    (%rsp),%ecx
    95b3:	48 83 f9 28          	cmp    $0x28,%rcx
    95b7:	0f 87 a4 03 00 00    	ja     9961 <_Z6format8rostringz+0xbc1>
    95bd:	48 89 c8             	mov    %rcx,%rax
    95c0:	48 03 44 24 10       	add    0x10(%rsp),%rax
    95c5:	83 c1 08             	add    $0x8,%ecx
    95c8:	89 0c 24             	mov    %ecx,(%rsp)
    95cb:	e9 9f 03 00 00       	jmp    996f <_Z6format8rostringz+0xbcf>
    95d0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    95d5:	48 8d 48 08          	lea    0x8(%rax),%rcx
    95d9:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    95de:	48 8b 30             	mov    (%rax),%rsi
    95e1:	45 0f be c5          	movsbl %r13b,%r8d
    95e5:	41 b9 40 09 01 00    	mov    $0x10940,%r9d
    95eb:	e9 8c 03 00 00       	jmp    997c <_Z6format8rostringz+0xbdc>
    95f0:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    95f5:	48 8d 48 08          	lea    0x8(%rax),%rcx
    95f9:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    95fe:	8b 18                	mov    (%rax),%ebx
    9600:	41 89 dc             	mov    %ebx,%r12d
    9603:	41 c1 ec 10          	shr    $0x10,%r12d
    9607:	41 89 df             	mov    %ebx,%r15d
    960a:	41 c1 ef 18          	shr    $0x18,%r15d
    960e:	0f b6 f3             	movzbl %bl,%esi
    9611:	41 b9 40 09 01 00    	mov    $0x10940,%r9d
    9617:	4c 89 f7             	mov    %r14,%rdi
    961a:	31 d2                	xor    %edx,%edx
    961c:	b9 0a 00 00 00       	mov    $0xa,%ecx
    9621:	41 b8 20 00 00 00    	mov    $0x20,%r8d
    9627:	e8 e4 39 00 00       	call   d010 <_ZN13ostringstream7write_uEmiicPKc>
    962c:	8b 74 24 20          	mov    0x20(%rsp),%esi
    9630:	4c 89 f7             	mov    %r14,%rdi
    9633:	e8 28 67 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9638:	c6 00 2e             	movb   $0x2e,(%rax)
    963b:	0f b6 f7             	movzbl %bh,%esi
    963e:	41 b9 40 09 01 00    	mov    $0x10940,%r9d
    9644:	4c 89 f7             	mov    %r14,%rdi
    9647:	31 d2                	xor    %edx,%edx
    9649:	b9 0a 00 00 00       	mov    $0xa,%ecx
    964e:	41 b8 20 00 00 00    	mov    $0x20,%r8d
    9654:	e8 b7 39 00 00       	call   d010 <_ZN13ostringstream7write_uEmiicPKc>
    9659:	8b 74 24 20          	mov    0x20(%rsp),%esi
    965d:	4c 89 f7             	mov    %r14,%rdi
    9660:	e8 fb 66 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9665:	c6 00 2e             	movb   $0x2e,(%rax)
    9668:	41 0f b6 f4          	movzbl %r12b,%esi
    966c:	41 b9 40 09 01 00    	mov    $0x10940,%r9d
    9672:	4c 89 f7             	mov    %r14,%rdi
    9675:	31 d2                	xor    %edx,%edx
    9677:	b9 0a 00 00 00       	mov    $0xa,%ecx
    967c:	41 b8 20 00 00 00    	mov    $0x20,%r8d
    9682:	e8 89 39 00 00       	call   d010 <_ZN13ostringstream7write_uEmiicPKc>
    9687:	8b 74 24 20          	mov    0x20(%rsp),%esi
    968b:	4c 89 f7             	mov    %r14,%rdi
    968e:	e8 cd 66 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9693:	c6 00 2e             	movb   $0x2e,(%rax)
    9696:	41 b9 40 09 01 00    	mov    $0x10940,%r9d
    969c:	4c 89 f7             	mov    %r14,%rdi
    969f:	4c 89 fe             	mov    %r15,%rsi
    96a2:	31 d2                	xor    %edx,%edx
    96a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
    96a9:	41 b8 20 00 00 00    	mov    $0x20,%r8d
    96af:	e9 d3 02 00 00       	jmp    9987 <_Z6format8rostringz+0xbe7>
    96b4:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    96b9:	48 8d 48 08          	lea    0x8(%rax),%rcx
    96bd:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    96c2:	48 8b 18             	mov    (%rax),%rbx
    96c5:	41 89 dc             	mov    %ebx,%r12d
    96c8:	41 c1 ec 10          	shr    $0x10,%r12d
    96cc:	41 89 df             	mov    %ebx,%r15d
    96cf:	41 c1 ef 18          	shr    $0x18,%r15d
    96d3:	49 89 dd             	mov    %rbx,%r13
    96d6:	49 c1 ed 20          	shr    $0x20,%r13
    96da:	48 89 d8             	mov    %rbx,%rax
    96dd:	48 c1 e8 28          	shr    $0x28,%rax
    96e1:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
    96e6:	0f b6 f3             	movzbl %bl,%esi
    96e9:	41 b9 04 0e 01 00    	mov    $0x10e04,%r9d
    96ef:	4c 89 f7             	mov    %r14,%rdi
    96f2:	ba 02 00 00 00       	mov    $0x2,%edx
    96f7:	b9 10 00 00 00       	mov    $0x10,%ecx
    96fc:	41 b8 30 00 00 00    	mov    $0x30,%r8d
    9702:	e8 09 39 00 00       	call   d010 <_ZN13ostringstream7write_uEmiicPKc>
    9707:	8b 74 24 20          	mov    0x20(%rsp),%esi
    970b:	4c 89 f7             	mov    %r14,%rdi
    970e:	e8 4d 66 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9713:	c6 00 3a             	movb   $0x3a,(%rax)
    9716:	0f b6 f7             	movzbl %bh,%esi
    9719:	41 b9 04 0e 01 00    	mov    $0x10e04,%r9d
    971f:	4c 89 f7             	mov    %r14,%rdi
    9722:	ba 02 00 00 00       	mov    $0x2,%edx
    9727:	b9 10 00 00 00       	mov    $0x10,%ecx
    972c:	41 b8 30 00 00 00    	mov    $0x30,%r8d
    9732:	e8 d9 38 00 00       	call   d010 <_ZN13ostringstream7write_uEmiicPKc>
    9737:	8b 74 24 20          	mov    0x20(%rsp),%esi
    973b:	4c 89 f7             	mov    %r14,%rdi
    973e:	e8 1d 66 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9743:	c6 00 3a             	movb   $0x3a,(%rax)
    9746:	41 0f b6 f4          	movzbl %r12b,%esi
    974a:	41 b9 04 0e 01 00    	mov    $0x10e04,%r9d
    9750:	4c 89 f7             	mov    %r14,%rdi
    9753:	ba 02 00 00 00       	mov    $0x2,%edx
    9758:	b9 10 00 00 00       	mov    $0x10,%ecx
    975d:	41 b8 30 00 00 00    	mov    $0x30,%r8d
    9763:	e8 a8 38 00 00       	call   d010 <_ZN13ostringstream7write_uEmiicPKc>
    9768:	8b 74 24 20          	mov    0x20(%rsp),%esi
    976c:	4c 89 f7             	mov    %r14,%rdi
    976f:	e8 ec 65 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9774:	c6 00 3a             	movb   $0x3a,(%rax)
    9777:	41 b9 04 0e 01 00    	mov    $0x10e04,%r9d
    977d:	4c 89 f7             	mov    %r14,%rdi
    9780:	4c 89 fe             	mov    %r15,%rsi
    9783:	ba 02 00 00 00       	mov    $0x2,%edx
    9788:	b9 10 00 00 00       	mov    $0x10,%ecx
    978d:	41 b8 30 00 00 00    	mov    $0x30,%r8d
    9793:	e8 78 38 00 00       	call   d010 <_ZN13ostringstream7write_uEmiicPKc>
    9798:	8b 74 24 20          	mov    0x20(%rsp),%esi
    979c:	4c 89 f7             	mov    %r14,%rdi
    979f:	e8 bc 65 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    97a4:	c6 00 3a             	movb   $0x3a,(%rax)
    97a7:	41 0f b6 f5          	movzbl %r13b,%esi
    97ab:	41 b9 04 0e 01 00    	mov    $0x10e04,%r9d
    97b1:	4c 89 f7             	mov    %r14,%rdi
    97b4:	ba 02 00 00 00       	mov    $0x2,%edx
    97b9:	b9 10 00 00 00       	mov    $0x10,%ecx
    97be:	41 b8 30 00 00 00    	mov    $0x30,%r8d
    97c4:	e8 47 38 00 00       	call   d010 <_ZN13ostringstream7write_uEmiicPKc>
    97c9:	8b 74 24 20          	mov    0x20(%rsp),%esi
    97cd:	4c 89 f7             	mov    %r14,%rdi
    97d0:	e8 8b 65 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    97d5:	c6 00 3a             	movb   $0x3a,(%rax)
    97d8:	0f b6 74 24 78       	movzbl 0x78(%rsp),%esi
    97dd:	41 b9 04 0e 01 00    	mov    $0x10e04,%r9d
    97e3:	4c 89 f7             	mov    %r14,%rdi
    97e6:	ba 02 00 00 00       	mov    $0x2,%edx
    97eb:	b9 10 00 00 00       	mov    $0x10,%ecx
    97f0:	41 b8 30 00 00 00    	mov    $0x30,%r8d
    97f6:	e9 8c 01 00 00       	jmp    9987 <_Z6format8rostringz+0xbe7>
    97fb:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9800:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9804:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9809:	48 8b 00             	mov    (%rax),%rax
    980c:	8b 48 08             	mov    0x8(%rax),%ecx
    980f:	48 8b 00             	mov    (%rax),%rax
    9812:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
    9819:	00 
    981a:	89 4c 24 50          	mov    %ecx,0x50(%rsp)
    981e:	48 8b 9c 24 88 00 00 	mov    0x88(%rsp),%rbx
    9825:	00 
    9826:	44 8b 7c 24 50       	mov    0x50(%rsp),%r15d
    982b:	45 85 ff             	test   %r15d,%r15d
    982e:	0f 8e b3 f7 ff ff    	jle    8fe7 <_Z6format8rostringz+0x247>
    9834:	45 31 e4             	xor    %r12d,%r12d
    9837:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    983e:	00 00 
    9840:	46 0f b6 2c 23       	movzbl (%rbx,%r12,1),%r13d
    9845:	8b 74 24 20          	mov    0x20(%rsp),%esi
    9849:	4c 89 f7             	mov    %r14,%rdi
    984c:	e8 0f 65 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9851:	44 88 28             	mov    %r13b,(%rax)
    9854:	49 ff c4             	inc    %r12
    9857:	4d 39 e7             	cmp    %r12,%r15
    985a:	75 e4                	jne    9840 <_Z6format8rostringz+0xaa0>
    985c:	e9 86 f7 ff ff       	jmp    8fe7 <_Z6format8rostringz+0x247>
    9861:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9866:	48 8d 48 08          	lea    0x8(%rax),%rcx
    986a:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    986f:	48 8b 30             	mov    (%rax),%rsi
    9872:	45 0f be c5          	movsbl %r13b,%r8d
    9876:	41 b9 40 09 01 00    	mov    $0x10940,%r9d
    987c:	4c 89 f7             	mov    %r14,%rdi
    987f:	44 89 fa             	mov    %r15d,%edx
    9882:	b9 02 00 00 00       	mov    $0x2,%ecx
    9887:	e9 fb 00 00 00       	jmp    9987 <_Z6format8rostringz+0xbe7>
    988c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9891:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9895:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    989a:	c5 fb 10 00          	vmovsd (%rax),%xmm0
    989e:	41 0f be cd          	movsbl %r13b,%ecx
    98a2:	4c 89 f7             	mov    %r14,%rdi
    98a5:	44 89 fe             	mov    %r15d,%esi
    98a8:	44 89 e2             	mov    %r12d,%edx
    98ab:	e8 a0 2d 00 00       	call   c650 <_ZN13ostringstream7write_dEdiic>
    98b0:	e9 32 f7 ff ff       	jmp    8fe7 <_Z6format8rostringz+0x247>
    98b5:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    98ba:	48 8d 48 08          	lea    0x8(%rax),%rcx
    98be:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    98c3:	4c 8b 20             	mov    (%rax),%r12
    98c6:	4d 85 e4             	test   %r12,%r12
    98c9:	79 12                	jns    98dd <_Z6format8rostringz+0xb3d>
    98cb:	49 f7 dc             	neg    %r12
    98ce:	8b 74 24 20          	mov    0x20(%rsp),%esi
    98d2:	4c 89 f7             	mov    %r14,%rdi
    98d5:	e8 86 64 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    98da:	c6 00 2d             	movb   $0x2d,(%rax)
    98dd:	45 0f be c5          	movsbl %r13b,%r8d
    98e1:	41 b9 40 09 01 00    	mov    $0x10940,%r9d
    98e7:	4c 89 f7             	mov    %r14,%rdi
    98ea:	4c 89 e6             	mov    %r12,%rsi
    98ed:	44 89 fa             	mov    %r15d,%edx
    98f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
    98f5:	e9 8d 00 00 00       	jmp    9987 <_Z6format8rostringz+0xbe7>
    98fa:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    98ff:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9903:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9908:	48 8b 18             	mov    (%rax),%rbx
    990b:	48 c7 c1 ff ff ff ff 	mov    $0xffffffffffffffff,%rcx
    9912:	31 d2                	xor    %edx,%edx
    9914:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    991b:	00 00 00 00 00 
    9920:	89 d0                	mov    %edx,%eax
    9922:	80 7c 0b 01 00       	cmpb   $0x0,0x1(%rbx,%rcx,1)
    9927:	48 8d 49 01          	lea    0x1(%rcx),%rcx
    992b:	8d 50 01             	lea    0x1(%rax),%edx
    992e:	75 f0                	jne    9920 <_Z6format8rostringz+0xb80>
    9930:	85 c9                	test   %ecx,%ecx
    9932:	0f 8e af f6 ff ff    	jle    8fe7 <_Z6format8rostringz+0x247>
    9938:	41 89 c7             	mov    %eax,%r15d
    993b:	45 31 e4             	xor    %r12d,%r12d
    993e:	66 90                	xchg   %ax,%ax
    9940:	46 0f b6 2c 23       	movzbl (%rbx,%r12,1),%r13d
    9945:	8b 74 24 20          	mov    0x20(%rsp),%esi
    9949:	4c 89 f7             	mov    %r14,%rdi
    994c:	e8 0f 64 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9951:	44 88 28             	mov    %r13b,(%rax)
    9954:	49 ff c4             	inc    %r12
    9957:	4d 39 e7             	cmp    %r12,%r15
    995a:	75 e4                	jne    9940 <_Z6format8rostringz+0xba0>
    995c:	e9 86 f6 ff ff       	jmp    8fe7 <_Z6format8rostringz+0x247>
    9961:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9966:	48 8d 48 08          	lea    0x8(%rax),%rcx
    996a:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    996f:	48 8b 30             	mov    (%rax),%rsi
    9972:	45 0f be c5          	movsbl %r13b,%r8d
    9976:	41 b9 04 0e 01 00    	mov    $0x10e04,%r9d
    997c:	4c 89 f7             	mov    %r14,%rdi
    997f:	44 89 fa             	mov    %r15d,%edx
    9982:	b9 10 00 00 00       	mov    $0x10,%ecx
    9987:	e8 84 36 00 00       	call   d010 <_ZN13ostringstream7write_uEmiicPKc>
    998c:	e9 56 f6 ff ff       	jmp    8fe7 <_Z6format8rostringz+0x247>
    9991:	8b 44 24 20          	mov    0x20(%rsp),%eax
    9995:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
    999a:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
    999f:	89 44 24 48          	mov    %eax,0x48(%rsp)
    99a3:	4c 8b 54 24 30       	mov    0x30(%rsp),%r10
    99a8:	48 63 4c 24 48       	movslq 0x48(%rsp),%rcx
    99ad:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
    99b4:	00 
    99b5:	89 48 0c             	mov    %ecx,0xc(%rax)
    99b8:	48 8d 51 1f          	lea    0x1f(%rcx),%rdx
    99bc:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
    99c0:	be 10 00 00 00       	mov    $0x10,%esi
    99c5:	48 0f 45 f2          	cmovne %rdx,%rsi
    99c9:	89 48 08             	mov    %ecx,0x8(%rax)
    99cc:	48 8b 3c 25 00 00 00 	mov    0x1000000,%rdi
    99d3:	01 
    99d4:	41 b8 00 00 00 01    	mov    $0x1000000,%r8d
    99da:	48 39 f7             	cmp    %rsi,%rdi
    99dd:	73 0d                	jae    99ec <_Z6format8rostringz+0xc4c>
    99df:	90                   	nop
    99e0:	4d 8b 40 08          	mov    0x8(%r8),%r8
    99e4:	49 8b 38             	mov    (%r8),%rdi
    99e7:	48 39 f7             	cmp    %rsi,%rdi
    99ea:	72 f4                	jb     99e0 <_Z6format8rostringz+0xc40>
    99ec:	49 8b 50 08          	mov    0x8(%r8),%rdx
    99f0:	49 89 f9             	mov    %rdi,%r9
    99f3:	49 29 f1             	sub    %rsi,%r9
    99f6:	49 83 f9 0f          	cmp    $0xf,%r9
    99fa:	77 0b                	ja     9a07 <_Z6format8rostringz+0xc67>
    99fc:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    9a00:	c4 c1 78 11 00       	vmovups %xmm0,(%r8)
    9a05:	eb 0d                	jmp    9a14 <_Z6format8rostringz+0xc74>
    9a07:	4d 89 08             	mov    %r9,(%r8)
    9a0a:	49 c1 e1 04          	shl    $0x4,%r9
    9a0e:	4c 01 ca             	add    %r9,%rdx
    9a11:	48 89 f7             	mov    %rsi,%rdi
    9a14:	48 89 3a             	mov    %rdi,(%rdx)
    9a17:	48 01 3c 25 28 00 11 	add    %rdi,0x110028
    9a1e:	00 
    9a1f:	48 83 c2 10          	add    $0x10,%rdx
    9a23:	48 89 10             	mov    %rdx,(%rax)
    9a26:	85 c9                	test   %ecx,%ecx
    9a28:	0f 8e 51 01 00 00    	jle    9b7f <_Z6format8rostringz+0xddf>
    9a2e:	31 f6                	xor    %esi,%esi
    9a30:	83 f9 10             	cmp    $0x10,%ecx
    9a33:	0f 82 b4 00 00 00    	jb     9aed <_Z6format8rostringz+0xd4d>
    9a39:	48 89 d7             	mov    %rdx,%rdi
    9a3c:	4c 29 d7             	sub    %r10,%rdi
    9a3f:	48 81 ff 80 00 00 00 	cmp    $0x80,%rdi
    9a46:	0f 82 a1 00 00 00    	jb     9aed <_Z6format8rostringz+0xd4d>
    9a4c:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
    9a52:	73 04                	jae    9a58 <_Z6format8rostringz+0xcb8>
    9a54:	31 f6                	xor    %esi,%esi
    9a56:	eb 61                	jmp    9ab9 <_Z6format8rostringz+0xd19>
    9a58:	48 89 ce             	mov    %rcx,%rsi
    9a5b:	48 83 e6 80          	and    $0xffffffffffffff80,%rsi
    9a5f:	31 ff                	xor    %edi,%edi
    9a61:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    9a68:	0f 1f 84 00 00 00 00 
    9a6f:	00 
    9a70:	c4 c1 7c 10 04 3a    	vmovups (%r10,%rdi,1),%ymm0
    9a76:	c4 c1 7c 10 4c 3a 20 	vmovups 0x20(%r10,%rdi,1),%ymm1
    9a7d:	c4 c1 7c 10 54 3a 40 	vmovups 0x40(%r10,%rdi,1),%ymm2
    9a84:	c4 c1 7c 10 5c 3a 60 	vmovups 0x60(%r10,%rdi,1),%ymm3
    9a8b:	c5 fc 11 04 3a       	vmovups %ymm0,(%rdx,%rdi,1)
    9a90:	c5 fc 11 4c 3a 20    	vmovups %ymm1,0x20(%rdx,%rdi,1)
    9a96:	c5 fc 11 54 3a 40    	vmovups %ymm2,0x40(%rdx,%rdi,1)
    9a9c:	c5 fc 11 5c 3a 60    	vmovups %ymm3,0x60(%rdx,%rdi,1)
    9aa2:	48 83 ef 80          	sub    $0xffffffffffffff80,%rdi
    9aa6:	48 39 fe             	cmp    %rdi,%rsi
    9aa9:	75 c5                	jne    9a70 <_Z6format8rostringz+0xcd0>
    9aab:	48 39 ce             	cmp    %rcx,%rsi
    9aae:	0f 84 cb 00 00 00    	je     9b7f <_Z6format8rostringz+0xddf>
    9ab4:	f6 c1 70             	test   $0x70,%cl
    9ab7:	74 34                	je     9aed <_Z6format8rostringz+0xd4d>
    9ab9:	48 89 f7             	mov    %rsi,%rdi
    9abc:	48 89 ce             	mov    %rcx,%rsi
    9abf:	48 83 e6 f0          	and    $0xfffffffffffffff0,%rsi
    9ac3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    9aca:	84 00 00 00 00 00 
    9ad0:	c4 c1 78 10 04 3a    	vmovups (%r10,%rdi,1),%xmm0
    9ad6:	c5 f8 11 04 3a       	vmovups %xmm0,(%rdx,%rdi,1)
    9adb:	48 83 c7 10          	add    $0x10,%rdi
    9adf:	48 39 fe             	cmp    %rdi,%rsi
    9ae2:	75 ec                	jne    9ad0 <_Z6format8rostringz+0xd30>
    9ae4:	48 39 ce             	cmp    %rcx,%rsi
    9ae7:	0f 84 92 00 00 00    	je     9b7f <_Z6format8rostringz+0xddf>
    9aed:	48 89 f7             	mov    %rsi,%rdi
    9af0:	48 f7 d7             	not    %rdi
    9af3:	48 01 cf             	add    %rcx,%rdi
    9af6:	49 89 c8             	mov    %rcx,%r8
    9af9:	49 83 e0 07          	and    $0x7,%r8
    9afd:	74 12                	je     9b11 <_Z6format8rostringz+0xd71>
    9aff:	90                   	nop
    9b00:	45 0f b6 0c 32       	movzbl (%r10,%rsi,1),%r9d
    9b05:	44 88 0c 32          	mov    %r9b,(%rdx,%rsi,1)
    9b09:	48 ff c6             	inc    %rsi
    9b0c:	49 ff c8             	dec    %r8
    9b0f:	75 ef                	jne    9b00 <_Z6format8rostringz+0xd60>
    9b11:	48 83 ff 07          	cmp    $0x7,%rdi
    9b15:	72 68                	jb     9b7f <_Z6format8rostringz+0xddf>
    9b17:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    9b1e:	00 00 
    9b20:	41 0f b6 3c 32       	movzbl (%r10,%rsi,1),%edi
    9b25:	40 88 3c 32          	mov    %dil,(%rdx,%rsi,1)
    9b29:	41 0f b6 7c 32 01    	movzbl 0x1(%r10,%rsi,1),%edi
    9b2f:	40 88 7c 32 01       	mov    %dil,0x1(%rdx,%rsi,1)
    9b34:	41 0f b6 7c 32 02    	movzbl 0x2(%r10,%rsi,1),%edi
    9b3a:	40 88 7c 32 02       	mov    %dil,0x2(%rdx,%rsi,1)
    9b3f:	41 0f b6 7c 32 03    	movzbl 0x3(%r10,%rsi,1),%edi
    9b45:	40 88 7c 32 03       	mov    %dil,0x3(%rdx,%rsi,1)
    9b4a:	41 0f b6 7c 32 04    	movzbl 0x4(%r10,%rsi,1),%edi
    9b50:	40 88 7c 32 04       	mov    %dil,0x4(%rdx,%rsi,1)
    9b55:	41 0f b6 7c 32 05    	movzbl 0x5(%r10,%rsi,1),%edi
    9b5b:	40 88 7c 32 05       	mov    %dil,0x5(%rdx,%rsi,1)
    9b60:	41 0f b6 7c 32 06    	movzbl 0x6(%r10,%rsi,1),%edi
    9b66:	40 88 7c 32 06       	mov    %dil,0x6(%rdx,%rsi,1)
    9b6b:	41 0f b6 7c 32 07    	movzbl 0x7(%r10,%rsi,1),%edi
    9b71:	40 88 7c 32 07       	mov    %dil,0x7(%rdx,%rsi,1)
    9b76:	48 83 c6 08          	add    $0x8,%rsi
    9b7a:	48 39 f1             	cmp    %rsi,%rcx
    9b7d:	75 a1                	jne    9b20 <_Z6format8rostringz+0xd80>
    9b7f:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
    9b84:	48 85 f6             	test   %rsi,%rsi
    9b87:	74 2e                	je     9bb7 <_Z6format8rostringz+0xe17>
    9b89:	48 8d 4e f0          	lea    -0x10(%rsi),%rcx
    9b8d:	48 8b 56 f0          	mov    -0x10(%rsi),%rdx
    9b91:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    9b98:	00 01 
    9b9a:	c5 f8 11 46 f0       	vmovups %xmm0,-0x10(%rsi)
    9b9f:	48 89 14 25 00 00 00 	mov    %rdx,0x1000000
    9ba6:	01 
    9ba7:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    9bae:	01 
    9baf:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    9bb6:	00 
    9bb7:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
    9bbe:	5b                   	pop    %rbx
    9bbf:	41 5c                	pop    %r12
    9bc1:	41 5d                	pop    %r13
    9bc3:	41 5e                	pop    %r14
    9bc5:	41 5f                	pop    %r15
    9bc7:	5d                   	pop    %rbp
    9bc8:	c5 f8 77             	vzeroupper 
    9bcb:	c3                   	ret    
    9bcc:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000009bd0 <_ZN6string10c_str_thisEv>:
    9bd0:	53                   	push   %rbx
    9bd1:	48 89 fb             	mov    %rdi,%rbx
    9bd4:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    9bd8:	74 14                	je     9bee <_ZN6string10c_str_thisEv+0x1e>
    9bda:	48 63 43 08          	movslq 0x8(%rbx),%rax
    9bde:	83 7b 08 00          	cmpl   $0x0,0x8(%rbx)
    9be2:	74 17                	je     9bfb <_ZN6string10c_str_thisEv+0x2b>
    9be4:	48 8b 0b             	mov    (%rbx),%rcx
    9be7:	80 7c 08 ff 00       	cmpb   $0x0,-0x1(%rax,%rcx,1)
    9bec:	74 68                	je     9c56 <_ZN6string10c_str_thisEv+0x86>
    9bee:	8b 73 08             	mov    0x8(%rbx),%esi
    9bf1:	48 89 df             	mov    %rbx,%rdi
    9bf4:	e8 67 61 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    9bf9:	eb 58                	jmp    9c53 <_ZN6string10c_str_thisEv+0x83>
    9bfb:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    9c02:	01 
    9c03:	ba 00 00 00 01       	mov    $0x1000000,%edx
    9c08:	48 83 f9 1f          	cmp    $0x1f,%rcx
    9c0c:	77 0f                	ja     9c1d <_ZN6string10c_str_thisEv+0x4d>
    9c0e:	66 90                	xchg   %ax,%ax
    9c10:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    9c14:	48 8b 0a             	mov    (%rdx),%rcx
    9c17:	48 83 f9 20          	cmp    $0x20,%rcx
    9c1b:	72 f3                	jb     9c10 <_ZN6string10c_str_thisEv+0x40>
    9c1d:	48 8b 42 08          	mov    0x8(%rdx),%rax
    9c21:	48 8d 71 e0          	lea    -0x20(%rcx),%rsi
    9c25:	48 83 fe 0f          	cmp    $0xf,%rsi
    9c29:	77 0a                	ja     9c35 <_ZN6string10c_str_thisEv+0x65>
    9c2b:	c5 f8 10 00          	vmovups (%rax),%xmm0
    9c2f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    9c33:	eb 0f                	jmp    9c44 <_ZN6string10c_str_thisEv+0x74>
    9c35:	48 89 32             	mov    %rsi,(%rdx)
    9c38:	48 c1 e6 04          	shl    $0x4,%rsi
    9c3c:	48 01 f0             	add    %rsi,%rax
    9c3f:	b9 20 00 00 00       	mov    $0x20,%ecx
    9c44:	48 89 08             	mov    %rcx,(%rax)
    9c47:	48 83 c0 10          	add    $0x10,%rax
    9c4b:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    9c52:	00 
    9c53:	c6 00 00             	movb   $0x0,(%rax)
    9c56:	48 8b 03             	mov    (%rbx),%rax
    9c59:	5b                   	pop    %rbx
    9c5a:	c3                   	ret    
    9c5b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000009c60 <_Z9ahci_read11ahci_devicemtPv>:
    9c60:	50                   	push   %rax
    9c61:	89 f0                	mov    %esi,%eax
    9c63:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    9c68:	8b 31                	mov    (%rcx),%esi
    9c6a:	83 e6 a0             	and    $0xffffffa0,%esi
    9c6d:	83 ce 05             	or     $0x5,%esi
    9c70:	66 89 31             	mov    %si,(%rcx)
    9c73:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
    9c78:	89 91 80 00 00 00    	mov    %edx,0x80(%rcx)
    9c7e:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%rcx)
    9c85:	00 00 00 
    9c88:	89 c2                	mov    %eax,%edx
    9c8a:	c1 e2 09             	shl    $0x9,%edx
    9c8d:	ff ca                	dec    %edx
    9c8f:	81 e2 ff ff 3f 00    	and    $0x3fffff,%edx
    9c95:	be 00 00 c0 7f       	mov    $0x7fc00000,%esi
    9c9a:	23 b1 8c 00 00 00    	and    0x8c(%rcx),%esi
    9ca0:	01 f2                	add    %esi,%edx
    9ca2:	81 c2 00 00 00 80    	add    $0x80000000,%edx
    9ca8:	89 91 8c 00 00 00    	mov    %edx,0x8c(%rcx)
    9cae:	c6 01 27             	movb   $0x27,(%rcx)
    9cb1:	80 49 01 80          	orb    $0x80,0x1(%rcx)
    9cb5:	48 89 fa             	mov    %rdi,%rdx
    9cb8:	c6 41 02 25          	movb   $0x25,0x2(%rcx)
    9cbc:	88 51 04             	mov    %dl,0x4(%rcx)
    9cbf:	88 71 05             	mov    %dh,0x5(%rcx)
    9cc2:	89 d6                	mov    %edx,%esi
    9cc4:	c1 ee 10             	shr    $0x10,%esi
    9cc7:	40 88 71 06          	mov    %sil,0x6(%rcx)
    9ccb:	c6 41 07 40          	movb   $0x40,0x7(%rcx)
    9ccf:	89 d6                	mov    %edx,%esi
    9cd1:	c1 ee 18             	shr    $0x18,%esi
    9cd4:	40 88 71 08          	mov    %sil,0x8(%rcx)
    9cd8:	48 89 fe             	mov    %rdi,%rsi
    9cdb:	48 c1 ee 20          	shr    $0x20,%rsi
    9cdf:	40 88 71 09          	mov    %sil,0x9(%rcx)
    9ce3:	48 c1 ea 28          	shr    $0x28,%rdx
    9ce7:	88 51 0a             	mov    %dl,0xa(%rcx)
    9cea:	88 41 0c             	mov    %al,0xc(%rcx)
    9ced:	88 61 0d             	mov    %ah,0xd(%rcx)
    9cf0:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    9cf5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    9cfc:	00 00 00 00 
    9d00:	f7 40 20 84 00 00 00 	testl  $0x84,0x20(%rax)
    9d07:	75 f7                	jne    9d00 <_Z9ahci_read11ahci_devicemtPv+0xa0>
    9d09:	83 48 38 01          	orl    $0x1,0x38(%rax)
    9d0d:	0f 1f 00             	nopl   (%rax)
    9d10:	f7 40 38 01 00 00 00 	testl  $0x1,0x38(%rax)
    9d17:	74 09                	je     9d22 <_Z9ahci_read11ahci_devicemtPv+0xc2>
    9d19:	f7 40 10 00 00 00 40 	testl  $0x40000000,0x10(%rax)
    9d20:	74 ee                	je     9d10 <_Z9ahci_read11ahci_devicemtPv+0xb0>
    9d22:	f7 40 10 00 00 00 40 	testl  $0x40000000,0x10(%rax)
    9d29:	75 02                	jne    9d2d <_Z9ahci_read11ahci_devicemtPv+0xcd>
    9d2b:	58                   	pop    %rax
    9d2c:	c3                   	ret    
    9d2d:	bf 00 00 11 00       	mov    $0x110000,%edi
    9d32:	be 44 00 00 00       	mov    $0x44,%esi
    9d37:	e8 34 22 00 00       	call   bf70 <_ZN7console7putcharEc>
    9d3c:	bf 00 00 11 00       	mov    $0x110000,%edi
    9d41:	be 69 00 00 00       	mov    $0x69,%esi
    9d46:	e8 25 22 00 00       	call   bf70 <_ZN7console7putcharEc>
    9d4b:	bf 00 00 11 00       	mov    $0x110000,%edi
    9d50:	be 73 00 00 00       	mov    $0x73,%esi
    9d55:	e8 16 22 00 00       	call   bf70 <_ZN7console7putcharEc>
    9d5a:	bf 00 00 11 00       	mov    $0x110000,%edi
    9d5f:	be 6b 00 00 00       	mov    $0x6b,%esi
    9d64:	e8 07 22 00 00       	call   bf70 <_ZN7console7putcharEc>
    9d69:	bf 00 00 11 00       	mov    $0x110000,%edi
    9d6e:	be 20 00 00 00       	mov    $0x20,%esi
    9d73:	e8 f8 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9d78:	bf 00 00 11 00       	mov    $0x110000,%edi
    9d7d:	be 72 00 00 00       	mov    $0x72,%esi
    9d82:	e8 e9 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9d87:	bf 00 00 11 00       	mov    $0x110000,%edi
    9d8c:	be 65 00 00 00       	mov    $0x65,%esi
    9d91:	e8 da 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9d96:	bf 00 00 11 00       	mov    $0x110000,%edi
    9d9b:	be 61 00 00 00       	mov    $0x61,%esi
    9da0:	e8 cb 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9da5:	bf 00 00 11 00       	mov    $0x110000,%edi
    9daa:	be 64 00 00 00       	mov    $0x64,%esi
    9daf:	e8 bc 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9db4:	bf 00 00 11 00       	mov    $0x110000,%edi
    9db9:	be 20 00 00 00       	mov    $0x20,%esi
    9dbe:	e8 ad 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9dc3:	bf 00 00 11 00       	mov    $0x110000,%edi
    9dc8:	be 65 00 00 00       	mov    $0x65,%esi
    9dcd:	e8 9e 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9dd2:	bf 00 00 11 00       	mov    $0x110000,%edi
    9dd7:	be 72 00 00 00       	mov    $0x72,%esi
    9ddc:	e8 8f 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9de1:	bf 00 00 11 00       	mov    $0x110000,%edi
    9de6:	be 72 00 00 00       	mov    $0x72,%esi
    9deb:	e8 80 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9df0:	bf 00 00 11 00       	mov    $0x110000,%edi
    9df5:	be 6f 00 00 00       	mov    $0x6f,%esi
    9dfa:	e8 71 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9dff:	bf 00 00 11 00       	mov    $0x110000,%edi
    9e04:	be 72 00 00 00       	mov    $0x72,%esi
    9e09:	e8 62 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9e0e:	bf 00 00 11 00       	mov    $0x110000,%edi
    9e13:	be 21 00 00 00       	mov    $0x21,%esi
    9e18:	e8 53 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9e1d:	bf 00 00 11 00       	mov    $0x110000,%edi
    9e22:	be 0d 00 00 00       	mov    $0xd,%esi
    9e27:	e8 44 21 00 00       	call   bf70 <_ZN7console7putcharEc>
    9e2c:	bf 00 00 11 00       	mov    $0x110000,%edi
    9e31:	be 0a 00 00 00       	mov    $0xa,%esi
    9e36:	58                   	pop    %rax
    9e37:	e9 34 21 00 00       	jmp    bf70 <_ZN7console7putcharEc>
    9e3c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000009e40 <_Z7irq_sethPFvvE>:
    9e40:	89 f8                	mov    %edi,%eax
    9e42:	48 89 34 c5 40 00 11 	mov    %rsi,0x110040(,%rax,8)
    9e49:	00 
    9e4a:	40 80 ff 07          	cmp    $0x7,%dil
    9e4e:	77 13                	ja     9e63 <_Z7irq_sethPFvvE+0x23>
    9e50:	e4 21                	in     $0x21,%al
    9e52:	b9 01 00 00 00       	mov    $0x1,%ecx
    9e57:	c4 e2 41 f7 c9       	shlx   %edi,%ecx,%ecx
    9e5c:	f6 d1                	not    %cl
    9e5e:	20 c8                	and    %cl,%al
    9e60:	e6 21                	out    %al,$0x21
    9e62:	c3                   	ret    
    9e63:	e4 a1                	in     $0xa1,%al
    9e65:	40 80 c7 f8          	add    $0xf8,%dil
    9e69:	b9 01 00 00 00       	mov    $0x1,%ecx
    9e6e:	c4 e2 41 f7 c9       	shlx   %edi,%ecx,%ecx
    9e73:	f6 d1                	not    %cl
    9e75:	20 c8                	and    %cl,%al
    9e77:	e6 a1                	out    %al,$0xa1
    9e79:	c3                   	ret    
    9e7a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000009e80 <memcpy>:
    9e80:	48 85 d2             	test   %rdx,%rdx
    9e83:	0f 84 a6 00 00 00    	je     9f2f <memcpy+0xaf>
    9e89:	48 83 fa 10          	cmp    $0x10,%rdx
    9e8d:	73 07                	jae    9e96 <memcpy+0x16>
    9e8f:	31 c0                	xor    %eax,%eax
    9e91:	e9 8a 00 00 00       	jmp    9f20 <memcpy+0xa0>
    9e96:	48 81 fa 80 00 00 00 	cmp    $0x80,%rdx
    9e9d:	73 04                	jae    9ea3 <memcpy+0x23>
    9e9f:	31 c0                	xor    %eax,%eax
    9ea1:	eb 4e                	jmp    9ef1 <memcpy+0x71>
    9ea3:	48 89 d0             	mov    %rdx,%rax
    9ea6:	48 83 e0 80          	and    $0xffffffffffffff80,%rax
    9eaa:	31 c9                	xor    %ecx,%ecx
    9eac:	0f 1f 40 00          	nopl   0x0(%rax)
    9eb0:	c5 fc 10 04 0e       	vmovups (%rsi,%rcx,1),%ymm0
    9eb5:	c5 fc 10 4c 0e 20    	vmovups 0x20(%rsi,%rcx,1),%ymm1
    9ebb:	c5 fc 10 54 0e 40    	vmovups 0x40(%rsi,%rcx,1),%ymm2
    9ec1:	c5 fc 10 5c 0e 60    	vmovups 0x60(%rsi,%rcx,1),%ymm3
    9ec7:	c5 fc 11 04 0f       	vmovups %ymm0,(%rdi,%rcx,1)
    9ecc:	c5 fc 11 4c 0f 20    	vmovups %ymm1,0x20(%rdi,%rcx,1)
    9ed2:	c5 fc 11 54 0f 40    	vmovups %ymm2,0x40(%rdi,%rcx,1)
    9ed8:	c5 fc 11 5c 0f 60    	vmovups %ymm3,0x60(%rdi,%rcx,1)
    9ede:	48 83 e9 80          	sub    $0xffffffffffffff80,%rcx
    9ee2:	48 39 c8             	cmp    %rcx,%rax
    9ee5:	75 c9                	jne    9eb0 <memcpy+0x30>
    9ee7:	48 39 d0             	cmp    %rdx,%rax
    9eea:	74 43                	je     9f2f <memcpy+0xaf>
    9eec:	f6 c2 70             	test   $0x70,%dl
    9eef:	74 2f                	je     9f20 <memcpy+0xa0>
    9ef1:	48 89 c1             	mov    %rax,%rcx
    9ef4:	48 89 d0             	mov    %rdx,%rax
    9ef7:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
    9efb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    9f00:	c5 f8 10 04 0e       	vmovups (%rsi,%rcx,1),%xmm0
    9f05:	c5 f8 11 04 0f       	vmovups %xmm0,(%rdi,%rcx,1)
    9f0a:	48 83 c1 10          	add    $0x10,%rcx
    9f0e:	48 39 c8             	cmp    %rcx,%rax
    9f11:	75 ed                	jne    9f00 <memcpy+0x80>
    9f13:	48 39 d0             	cmp    %rdx,%rax
    9f16:	74 17                	je     9f2f <memcpy+0xaf>
    9f18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    9f1f:	00 
    9f20:	0f b6 0c 06          	movzbl (%rsi,%rax,1),%ecx
    9f24:	88 0c 07             	mov    %cl,(%rdi,%rax,1)
    9f27:	48 ff c0             	inc    %rax
    9f2a:	48 39 c2             	cmp    %rax,%rdx
    9f2d:	75 f1                	jne    9f20 <memcpy+0xa0>
    9f2f:	c5 f8 77             	vzeroupper 
    9f32:	c3                   	ret    
    9f33:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    9f3a:	00 00 00 
    9f3d:	0f 1f 00             	nopl   (%rax)

0000000000009f40 <_Z8pci_initv>:
    9f40:	55                   	push   %rbp
    9f41:	41 57                	push   %r15
    9f43:	41 56                	push   %r14
    9f45:	41 55                	push   %r13
    9f47:	41 54                	push   %r12
    9f49:	53                   	push   %rbx
    9f4a:	48 8b 04 25 20 00 11 	mov    0x110020,%rax
    9f51:	00 
    9f52:	48 83 c0 0f          	add    $0xf,%rax
    9f56:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
    9f5a:	48 8d 88 04 18 00 00 	lea    0x1804(%rax),%rcx
    9f61:	48 89 0c 25 20 00 11 	mov    %rcx,0x110020
    9f68:	00 
    9f69:	48 89 04 25 c8 00 11 	mov    %rax,0x1100c8
    9f70:	00 
    9f71:	c7 44 24 e4 00 00 00 	movl   $0x0,-0x1c(%rsp)
    9f78:	00 
    9f79:	31 c9                	xor    %ecx,%ecx
    9f7b:	eb 17                	jmp    9f94 <_Z8pci_initv+0x54>
    9f7d:	0f 1f 00             	nopl   (%rax)
    9f80:	8b 4c 24 e8          	mov    -0x18(%rsp),%ecx
    9f84:	ff c1                	inc    %ecx
    9f86:	0f b7 c1             	movzwl %cx,%eax
    9f89:	3d 00 01 00 00       	cmp    $0x100,%eax
    9f8e:	0f 84 66 03 00 00    	je     a2fa <_Z8pci_initv+0x3ba>
    9f94:	0f b7 c1             	movzwl %cx,%eax
    9f97:	89 44 24 e8          	mov    %eax,-0x18(%rsp)
    9f9b:	c1 e1 10             	shl    $0x10,%ecx
    9f9e:	31 f6                	xor    %esi,%esi
    9fa0:	89 4c 24 f0          	mov    %ecx,-0x10(%rsp)
    9fa4:	eb 1b                	jmp    9fc1 <_Z8pci_initv+0x81>
    9fa6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    9fad:	00 00 00 
    9fb0:	8b 74 24 f4          	mov    -0xc(%rsp),%esi
    9fb4:	40 fe c6             	inc    %sil
    9fb7:	40 80 fe 20          	cmp    $0x20,%sil
    9fbb:	8b 4c 24 f0          	mov    -0x10(%rsp),%ecx
    9fbf:	74 bf                	je     9f80 <_Z8pci_initv+0x40>
    9fc1:	40 0f b6 fe          	movzbl %sil,%edi
    9fc5:	41 89 fc             	mov    %edi,%r12d
    9fc8:	41 c1 e4 0b          	shl    $0xb,%r12d
    9fcc:	41 09 cc             	or     %ecx,%r12d
    9fcf:	41 81 e4 ff ff ff 00 	and    $0xffffff,%r12d
    9fd6:	41 8d 8c 24 00 00 00 	lea    -0x80000000(%r12),%ecx
    9fdd:	80 
    9fde:	89 c8                	mov    %ecx,%eax
    9fe0:	66 ba f8 0c          	mov    $0xcf8,%dx
    9fe4:	ef                   	out    %eax,(%dx)
    9fe5:	66 ba fc 0c          	mov    $0xcfc,%dx
    9fe9:	ed                   	in     (%dx),%eax
    9fea:	83 f8 ff             	cmp    $0xffffffff,%eax
    9fed:	89 74 24 f4          	mov    %esi,-0xc(%rsp)
    9ff1:	74 bd                	je     9fb0 <_Z8pci_initv+0x70>
    9ff3:	c1 e7 08             	shl    $0x8,%edi
    9ff6:	41 89 ff             	mov    %edi,%r15d
    9ff9:	89 7c 24 f8          	mov    %edi,-0x8(%rsp)
    9ffd:	44 0b 7c 24 e8       	or     -0x18(%rsp),%r15d
    a002:	89 c8                	mov    %ecx,%eax
    a004:	66 ba f8 0c          	mov    $0xcf8,%dx
    a008:	ef                   	out    %eax,(%dx)
    a009:	66 ba fc 0c          	mov    $0xcfc,%dx
    a00d:	ed                   	in     (%dx),%eax
    a00e:	89 44 24 ec          	mov    %eax,-0x14(%rsp)
    a012:	44 89 e0             	mov    %r12d,%eax
    a015:	0d 08 00 00 80       	or     $0x80000008,%eax
    a01a:	66 ba f8 0c          	mov    $0xcf8,%dx
    a01e:	ef                   	out    %eax,(%dx)
    a01f:	66 ba fc 0c          	mov    $0xcfc,%dx
    a023:	ed                   	in     (%dx),%eax
    a024:	89 c6                	mov    %eax,%esi
    a026:	44 89 e0             	mov    %r12d,%eax
    a029:	0d 0c 00 00 80       	or     $0x8000000c,%eax
    a02e:	66 ba f8 0c          	mov    $0xcf8,%dx
    a032:	ef                   	out    %eax,(%dx)
    a033:	66 ba fc 0c          	mov    $0xcfc,%dx
    a037:	ed                   	in     (%dx),%eax
    a038:	89 c7                	mov    %eax,%edi
    a03a:	44 89 e0             	mov    %r12d,%eax
    a03d:	0d 10 00 00 80       	or     $0x80000010,%eax
    a042:	66 ba f8 0c          	mov    $0xcf8,%dx
    a046:	ef                   	out    %eax,(%dx)
    a047:	66 ba fc 0c          	mov    $0xcfc,%dx
    a04b:	ed                   	in     (%dx),%eax
    a04c:	41 89 c0             	mov    %eax,%r8d
    a04f:	44 89 e0             	mov    %r12d,%eax
    a052:	0d 14 00 00 80       	or     $0x80000014,%eax
    a057:	66 ba f8 0c          	mov    $0xcf8,%dx
    a05b:	ef                   	out    %eax,(%dx)
    a05c:	66 ba fc 0c          	mov    $0xcfc,%dx
    a060:	ed                   	in     (%dx),%eax
    a061:	41 89 c1             	mov    %eax,%r9d
    a064:	44 89 e0             	mov    %r12d,%eax
    a067:	0d 18 00 00 80       	or     $0x80000018,%eax
    a06c:	66 ba f8 0c          	mov    $0xcf8,%dx
    a070:	ef                   	out    %eax,(%dx)
    a071:	66 ba fc 0c          	mov    $0xcfc,%dx
    a075:	ed                   	in     (%dx),%eax
    a076:	41 89 c2             	mov    %eax,%r10d
    a079:	44 89 e0             	mov    %r12d,%eax
    a07c:	0d 1c 00 00 80       	or     $0x8000001c,%eax
    a081:	66 ba f8 0c          	mov    $0xcf8,%dx
    a085:	ef                   	out    %eax,(%dx)
    a086:	66 ba fc 0c          	mov    $0xcfc,%dx
    a08a:	ed                   	in     (%dx),%eax
    a08b:	41 89 c3             	mov    %eax,%r11d
    a08e:	44 89 e0             	mov    %r12d,%eax
    a091:	0d 20 00 00 80       	or     $0x80000020,%eax
    a096:	66 ba f8 0c          	mov    $0xcf8,%dx
    a09a:	ef                   	out    %eax,(%dx)
    a09b:	66 ba fc 0c          	mov    $0xcfc,%dx
    a09f:	ed                   	in     (%dx),%eax
    a0a0:	89 c3                	mov    %eax,%ebx
    a0a2:	44 89 e0             	mov    %r12d,%eax
    a0a5:	0d 24 00 00 80       	or     $0x80000024,%eax
    a0aa:	66 ba f8 0c          	mov    $0xcf8,%dx
    a0ae:	ef                   	out    %eax,(%dx)
    a0af:	66 ba fc 0c          	mov    $0xcfc,%dx
    a0b3:	ed                   	in     (%dx),%eax
    a0b4:	89 c5                	mov    %eax,%ebp
    a0b6:	44 89 e0             	mov    %r12d,%eax
    a0b9:	0d 2c 00 00 80       	or     $0x8000002c,%eax
    a0be:	66 ba f8 0c          	mov    $0xcf8,%dx
    a0c2:	ef                   	out    %eax,(%dx)
    a0c3:	66 ba fc 0c          	mov    $0xcfc,%dx
    a0c7:	ed                   	in     (%dx),%eax
    a0c8:	41 89 c6             	mov    %eax,%r14d
    a0cb:	44 89 e0             	mov    %r12d,%eax
    a0ce:	0d 3c 00 00 80       	or     $0x8000003c,%eax
    a0d3:	66 ba f8 0c          	mov    $0xcf8,%dx
    a0d7:	ef                   	out    %eax,(%dx)
    a0d8:	66 ba fc 0c          	mov    $0xcfc,%dx
    a0dc:	ed                   	in     (%dx),%eax
    a0dd:	48 8b 14 25 c8 00 11 	mov    0x1100c8,%rdx
    a0e4:	00 
    a0e5:	44 8b 6c 24 e4       	mov    -0x1c(%rsp),%r13d
    a0ea:	4c 89 e1             	mov    %r12,%rcx
    a0ed:	4d 63 e5             	movslq %r13d,%r12
    a0f0:	49 c1 e4 04          	shl    $0x4,%r12
    a0f4:	4f 8d 24 64          	lea    (%r12,%r12,2),%r12
    a0f8:	66 46 89 3c 22       	mov    %r15w,(%rdx,%r12,1)
    a0fd:	42 c6 44 22 02 00    	movb   $0x0,0x2(%rdx,%r12,1)
    a103:	44 8b 7c 24 ec       	mov    -0x14(%rsp),%r15d
    a108:	46 89 7c 22 04       	mov    %r15d,0x4(%rdx,%r12,1)
    a10d:	42 89 74 22 08       	mov    %esi,0x8(%rdx,%r12,1)
    a112:	42 89 7c 22 0c       	mov    %edi,0xc(%rdx,%r12,1)
    a117:	46 89 44 22 10       	mov    %r8d,0x10(%rdx,%r12,1)
    a11c:	46 89 4c 22 14       	mov    %r9d,0x14(%rdx,%r12,1)
    a121:	46 89 54 22 18       	mov    %r10d,0x18(%rdx,%r12,1)
    a126:	46 89 5c 22 1c       	mov    %r11d,0x1c(%rdx,%r12,1)
    a12b:	42 89 5c 22 20       	mov    %ebx,0x20(%rdx,%r12,1)
    a130:	42 89 6c 22 24       	mov    %ebp,0x24(%rdx,%r12,1)
    a135:	46 89 74 22 28       	mov    %r14d,0x28(%rdx,%r12,1)
    a13a:	66 42 89 44 22 2c    	mov    %ax,0x2c(%rdx,%r12,1)
    a140:	41 ff c5             	inc    %r13d
    a143:	44 89 6c 24 e4       	mov    %r13d,-0x1c(%rsp)
    a148:	48 8b 04 25 c8 00 11 	mov    0x1100c8,%rax
    a14f:	00 
    a150:	42 80 7c 20 0e 00    	cmpb   $0x0,0xe(%rax,%r12,1)
    a156:	0f 89 54 fe ff ff    	jns    9fb0 <_Z8pci_initv+0x70>
    a15c:	40 b7 01             	mov    $0x1,%dil
    a15f:	49 89 cc             	mov    %rcx,%r12
    a162:	eb 19                	jmp    a17d <_Z8pci_initv+0x23d>
    a164:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    a16b:	00 00 00 00 00 
    a170:	40 fe c7             	inc    %dil
    a173:	40 80 ff 07          	cmp    $0x7,%dil
    a177:	0f 84 33 fe ff ff    	je     9fb0 <_Z8pci_initv+0x70>
    a17d:	44 0f b6 ef          	movzbl %dil,%r13d
    a181:	44 89 e9             	mov    %r13d,%ecx
    a184:	c1 e1 08             	shl    $0x8,%ecx
    a187:	44 09 e1             	or     %r12d,%ecx
    a18a:	8d b1 00 00 00 80    	lea    -0x80000000(%rcx),%esi
    a190:	89 f0                	mov    %esi,%eax
    a192:	66 ba f8 0c          	mov    $0xcf8,%dx
    a196:	ef                   	out    %eax,(%dx)
    a197:	66 ba fc 0c          	mov    $0xcfc,%dx
    a19b:	ed                   	in     (%dx),%eax
    a19c:	83 f8 ff             	cmp    $0xffffffff,%eax
    a19f:	74 cf                	je     a170 <_Z8pci_initv+0x230>
    a1a1:	89 f0                	mov    %esi,%eax
    a1a3:	66 ba f8 0c          	mov    $0xcf8,%dx
    a1a7:	ef                   	out    %eax,(%dx)
    a1a8:	66 ba fc 0c          	mov    $0xcfc,%dx
    a1ac:	ed                   	in     (%dx),%eax
    a1ad:	89 44 24 ec          	mov    %eax,-0x14(%rsp)
    a1b1:	89 c8                	mov    %ecx,%eax
    a1b3:	0d 08 00 00 80       	or     $0x80000008,%eax
    a1b8:	66 ba f8 0c          	mov    $0xcf8,%dx
    a1bc:	ef                   	out    %eax,(%dx)
    a1bd:	66 ba fc 0c          	mov    $0xcfc,%dx
    a1c1:	ed                   	in     (%dx),%eax
    a1c2:	89 44 24 fc          	mov    %eax,-0x4(%rsp)
    a1c6:	89 c8                	mov    %ecx,%eax
    a1c8:	0d 0c 00 00 80       	or     $0x8000000c,%eax
    a1cd:	66 ba f8 0c          	mov    $0xcf8,%dx
    a1d1:	ef                   	out    %eax,(%dx)
    a1d2:	66 ba fc 0c          	mov    $0xcfc,%dx
    a1d6:	ed                   	in     (%dx),%eax
    a1d7:	41 89 c0             	mov    %eax,%r8d
    a1da:	89 c8                	mov    %ecx,%eax
    a1dc:	0d 10 00 00 80       	or     $0x80000010,%eax
    a1e1:	66 ba f8 0c          	mov    $0xcf8,%dx
    a1e5:	ef                   	out    %eax,(%dx)
    a1e6:	66 ba fc 0c          	mov    $0xcfc,%dx
    a1ea:	ed                   	in     (%dx),%eax
    a1eb:	41 89 c1             	mov    %eax,%r9d
    a1ee:	89 c8                	mov    %ecx,%eax
    a1f0:	0d 14 00 00 80       	or     $0x80000014,%eax
    a1f5:	66 ba f8 0c          	mov    $0xcf8,%dx
    a1f9:	ef                   	out    %eax,(%dx)
    a1fa:	66 ba fc 0c          	mov    $0xcfc,%dx
    a1fe:	ed                   	in     (%dx),%eax
    a1ff:	41 89 c2             	mov    %eax,%r10d
    a202:	89 c8                	mov    %ecx,%eax
    a204:	0d 18 00 00 80       	or     $0x80000018,%eax
    a209:	66 ba f8 0c          	mov    $0xcf8,%dx
    a20d:	ef                   	out    %eax,(%dx)
    a20e:	66 ba fc 0c          	mov    $0xcfc,%dx
    a212:	ed                   	in     (%dx),%eax
    a213:	41 89 c3             	mov    %eax,%r11d
    a216:	89 c8                	mov    %ecx,%eax
    a218:	0d 1c 00 00 80       	or     $0x8000001c,%eax
    a21d:	66 ba f8 0c          	mov    $0xcf8,%dx
    a221:	ef                   	out    %eax,(%dx)
    a222:	66 ba fc 0c          	mov    $0xcfc,%dx
    a226:	ed                   	in     (%dx),%eax
    a227:	89 c3                	mov    %eax,%ebx
    a229:	89 c8                	mov    %ecx,%eax
    a22b:	0d 20 00 00 80       	or     $0x80000020,%eax
    a230:	66 ba f8 0c          	mov    $0xcf8,%dx
    a234:	ef                   	out    %eax,(%dx)
    a235:	66 ba fc 0c          	mov    $0xcfc,%dx
    a239:	ed                   	in     (%dx),%eax
    a23a:	89 c5                	mov    %eax,%ebp
    a23c:	89 c8                	mov    %ecx,%eax
    a23e:	0d 24 00 00 80       	or     $0x80000024,%eax
    a243:	66 ba f8 0c          	mov    $0xcf8,%dx
    a247:	ef                   	out    %eax,(%dx)
    a248:	66 ba fc 0c          	mov    $0xcfc,%dx
    a24c:	ed                   	in     (%dx),%eax
    a24d:	41 89 c6             	mov    %eax,%r14d
    a250:	89 c8                	mov    %ecx,%eax
    a252:	0d 2c 00 00 80       	or     $0x8000002c,%eax
    a257:	66 ba f8 0c          	mov    $0xcf8,%dx
    a25b:	ef                   	out    %eax,(%dx)
    a25c:	66 ba fc 0c          	mov    $0xcfc,%dx
    a260:	ed                   	in     (%dx),%eax
    a261:	41 89 c7             	mov    %eax,%r15d
    a264:	81 c9 3c 00 00 80    	or     $0x8000003c,%ecx
    a26a:	89 c8                	mov    %ecx,%eax
    a26c:	66 ba f8 0c          	mov    $0xcf8,%dx
    a270:	ef                   	out    %eax,(%dx)
    a271:	66 ba fc 0c          	mov    $0xcfc,%dx
    a275:	ed                   	in     (%dx),%eax
    a276:	89 c6                	mov    %eax,%esi
    a278:	48 8b 0c 25 c8 00 11 	mov    0x1100c8,%rcx
    a27f:	00 
    a280:	4c 89 e0             	mov    %r12,%rax
    a283:	44 8b 64 24 e4       	mov    -0x1c(%rsp),%r12d
    a288:	49 63 d4             	movslq %r12d,%rdx
    a28b:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
    a28f:	48 c1 e2 04          	shl    $0x4,%rdx
    a293:	44 88 6c 11 02       	mov    %r13b,0x2(%rcx,%rdx,1)
    a298:	41 c1 e5 10          	shl    $0x10,%r13d
    a29c:	44 03 6c 24 f8       	add    -0x8(%rsp),%r13d
    a2a1:	44 0b 6c 24 e8       	or     -0x18(%rsp),%r13d
    a2a6:	66 44 89 2c 11       	mov    %r13w,(%rcx,%rdx,1)
    a2ab:	44 8b 6c 24 ec       	mov    -0x14(%rsp),%r13d
    a2b0:	44 89 6c 11 04       	mov    %r13d,0x4(%rcx,%rdx,1)
    a2b5:	44 8b 6c 24 fc       	mov    -0x4(%rsp),%r13d
    a2ba:	44 89 6c 11 08       	mov    %r13d,0x8(%rcx,%rdx,1)
    a2bf:	44 89 44 11 0c       	mov    %r8d,0xc(%rcx,%rdx,1)
    a2c4:	44 89 4c 11 10       	mov    %r9d,0x10(%rcx,%rdx,1)
    a2c9:	44 89 54 11 14       	mov    %r10d,0x14(%rcx,%rdx,1)
    a2ce:	44 89 5c 11 18       	mov    %r11d,0x18(%rcx,%rdx,1)
    a2d3:	89 5c 11 1c          	mov    %ebx,0x1c(%rcx,%rdx,1)
    a2d7:	89 6c 11 20          	mov    %ebp,0x20(%rcx,%rdx,1)
    a2db:	44 89 74 11 24       	mov    %r14d,0x24(%rcx,%rdx,1)
    a2e0:	44 89 7c 11 28       	mov    %r15d,0x28(%rcx,%rdx,1)
    a2e5:	66 89 74 11 2c       	mov    %si,0x2c(%rcx,%rdx,1)
    a2ea:	41 ff c4             	inc    %r12d
    a2ed:	44 89 64 24 e4       	mov    %r12d,-0x1c(%rsp)
    a2f2:	49 89 c4             	mov    %rax,%r12
    a2f5:	e9 76 fe ff ff       	jmp    a170 <_Z8pci_initv+0x230>
    a2fa:	48 8b 04 25 c8 00 11 	mov    0x1100c8,%rax
    a301:	00 
    a302:	8b 4c 24 e4          	mov    -0x1c(%rsp),%ecx
    a306:	89 88 00 18 00 00    	mov    %ecx,0x1800(%rax)
    a30c:	5b                   	pop    %rbx
    a30d:	41 5c                	pop    %r12
    a30f:	41 5d                	pop    %r13
    a311:	41 5e                	pop    %r14
    a313:	41 5f                	pop    %r15
    a315:	5d                   	pop    %rbp
    a316:	c3                   	ret    
    a317:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    a31e:	00 00 

000000000000a320 <_Z9pci_matchhhh>:
    a320:	48 8b 04 25 c8 00 11 	mov    0x1100c8,%rax
    a327:	00 
    a328:	8b 88 00 18 00 00    	mov    0x1800(%rax),%ecx
    a32e:	85 c9                	test   %ecx,%ecx
    a330:	0f 8e bc 00 00 00    	jle    a3f2 <_Z9pci_matchhhh+0xd2>
    a336:	80 fa ff             	cmp    $0xff,%dl
    a339:	74 38                	je     a373 <_Z9pci_matchhhh+0x53>
    a33b:	40 80 fe ff          	cmp    $0xff,%sil
    a33f:	0f 84 7e 00 00 00    	je     a3c3 <_Z9pci_matchhhh+0xa3>
    a345:	4c 8d 48 0b          	lea    0xb(%rax),%r9
    a349:	45 31 c0             	xor    %r8d,%r8d
    a34c:	eb 12                	jmp    a360 <_Z9pci_matchhhh+0x40>
    a34e:	66 90                	xchg   %ax,%ax
    a350:	49 ff c0             	inc    %r8
    a353:	49 83 c1 30          	add    $0x30,%r9
    a357:	4c 39 c1             	cmp    %r8,%rcx
    a35a:	0f 84 92 00 00 00    	je     a3f2 <_Z9pci_matchhhh+0xd2>
    a360:	41 38 39             	cmp    %dil,(%r9)
    a363:	75 eb                	jne    a350 <_Z9pci_matchhhh+0x30>
    a365:	41 38 71 ff          	cmp    %sil,-0x1(%r9)
    a369:	75 e5                	jne    a350 <_Z9pci_matchhhh+0x30>
    a36b:	41 38 51 fe          	cmp    %dl,-0x2(%r9)
    a36f:	75 df                	jne    a350 <_Z9pci_matchhhh+0x30>
    a371:	eb 73                	jmp    a3e6 <_Z9pci_matchhhh+0xc6>
    a373:	48 8d 50 0b          	lea    0xb(%rax),%rdx
    a377:	45 31 c0             	xor    %r8d,%r8d
    a37a:	40 80 fe ff          	cmp    $0xff,%sil
    a37e:	75 1c                	jne    a39c <_Z9pci_matchhhh+0x7c>
    a380:	eb 3a                	jmp    a3bc <_Z9pci_matchhhh+0x9c>
    a382:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    a389:	1f 84 00 00 00 00 00 
    a390:	49 ff c0             	inc    %r8
    a393:	48 83 c2 30          	add    $0x30,%rdx
    a397:	4c 39 c1             	cmp    %r8,%rcx
    a39a:	74 56                	je     a3f2 <_Z9pci_matchhhh+0xd2>
    a39c:	40 38 3a             	cmp    %dil,(%rdx)
    a39f:	75 ef                	jne    a390 <_Z9pci_matchhhh+0x70>
    a3a1:	40 38 72 ff          	cmp    %sil,-0x1(%rdx)
    a3a5:	75 e9                	jne    a390 <_Z9pci_matchhhh+0x70>
    a3a7:	eb 3d                	jmp    a3e6 <_Z9pci_matchhhh+0xc6>
    a3a9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    a3b0:	49 ff c0             	inc    %r8
    a3b3:	48 83 c2 30          	add    $0x30,%rdx
    a3b7:	4c 39 c1             	cmp    %r8,%rcx
    a3ba:	74 36                	je     a3f2 <_Z9pci_matchhhh+0xd2>
    a3bc:	40 38 3a             	cmp    %dil,(%rdx)
    a3bf:	75 ef                	jne    a3b0 <_Z9pci_matchhhh+0x90>
    a3c1:	eb 23                	jmp    a3e6 <_Z9pci_matchhhh+0xc6>
    a3c3:	48 8d 70 0b          	lea    0xb(%rax),%rsi
    a3c7:	45 31 c0             	xor    %r8d,%r8d
    a3ca:	eb 10                	jmp    a3dc <_Z9pci_matchhhh+0xbc>
    a3cc:	0f 1f 40 00          	nopl   0x0(%rax)
    a3d0:	49 ff c0             	inc    %r8
    a3d3:	48 83 c6 30          	add    $0x30,%rsi
    a3d7:	4c 39 c1             	cmp    %r8,%rcx
    a3da:	74 16                	je     a3f2 <_Z9pci_matchhhh+0xd2>
    a3dc:	40 38 3e             	cmp    %dil,(%rsi)
    a3df:	75 ef                	jne    a3d0 <_Z9pci_matchhhh+0xb0>
    a3e1:	38 56 fe             	cmp    %dl,-0x2(%rsi)
    a3e4:	75 ea                	jne    a3d0 <_Z9pci_matchhhh+0xb0>
    a3e6:	4b 8d 0c 40          	lea    (%r8,%r8,2),%rcx
    a3ea:	48 c1 e1 04          	shl    $0x4,%rcx
    a3ee:	48 01 c8             	add    %rcx,%rax
    a3f1:	c3                   	ret    
    a3f2:	31 c0                	xor    %eax,%eax
    a3f4:	c3                   	ret    
    a3f5:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    a3fc:	00 00 00 
    a3ff:	90                   	nop

000000000000a400 <_Z8fat_initv>:
    a400:	41 57                	push   %r15
    a402:	41 56                	push   %r14
    a404:	41 55                	push   %r13
    a406:	41 54                	push   %r12
    a408:	53                   	push   %rbx
    a409:	48 83 ec 30          	sub    $0x30,%rsp
    a40d:	80 3c 25 c2 7d 00 00 	cmpb   $0xc,0x7dc2
    a414:	0c 
    a415:	75 05                	jne    a41c <_Z8fat_initv+0x1c>
    a417:	45 31 ff             	xor    %r15d,%r15d
    a41a:	eb 34                	jmp    a450 <_Z8fat_initv+0x50>
    a41c:	41 bf 01 00 00 00    	mov    $0x1,%r15d
    a422:	80 3c 25 d2 7d 00 00 	cmpb   $0xc,0x7dd2
    a429:	0c 
    a42a:	74 24                	je     a450 <_Z8fat_initv+0x50>
    a42c:	41 bf 02 00 00 00    	mov    $0x2,%r15d
    a432:	80 3c 25 e2 7d 00 00 	cmpb   $0xc,0x7de2
    a439:	0c 
    a43a:	74 14                	je     a450 <_Z8fat_initv+0x50>
    a43c:	41 bf 03 00 00 00    	mov    $0x3,%r15d
    a442:	80 3c 25 f2 7d 00 00 	cmpb   $0xc,0x7df2
    a449:	0c 
    a44a:	0f 85 54 04 00 00    	jne    a8a4 <_Z8fat_initv+0x4a4>
    a450:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    a457:	01 
    a458:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    a45d:	48 3d 0f 02 00 00    	cmp    $0x20f,%rax
    a463:	77 1a                	ja     a47f <_Z8fat_initv+0x7f>
    a465:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    a46c:	00 00 00 00 
    a470:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    a474:	48 8b 01             	mov    (%rcx),%rax
    a477:	48 3d 10 02 00 00    	cmp    $0x210,%rax
    a47d:	72 f1                	jb     a470 <_Z8fat_initv+0x70>
    a47f:	4c 8b 71 08          	mov    0x8(%rcx),%r14
    a483:	48 8d 90 f0 fd ff ff 	lea    -0x210(%rax),%rdx
    a48a:	48 83 fa 0f          	cmp    $0xf,%rdx
    a48e:	77 0b                	ja     a49b <_Z8fat_initv+0x9b>
    a490:	c4 c1 78 10 06       	vmovups (%r14),%xmm0
    a495:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    a499:	eb 0f                	jmp    a4aa <_Z8fat_initv+0xaa>
    a49b:	48 89 11             	mov    %rdx,(%rcx)
    a49e:	48 c1 e2 04          	shl    $0x4,%rdx
    a4a2:	49 01 d6             	add    %rdx,%r14
    a4a5:	b8 10 02 00 00       	mov    $0x210,%eax
    a4aa:	49 89 06             	mov    %rax,(%r14)
    a4ad:	48 01 04 25 28 00 11 	add    %rax,0x110028
    a4b4:	00 
    a4b5:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    a4b9:	c4 c1 7c 11 86 f0 01 	vmovups %ymm0,0x1f0(%r14)
    a4c0:	00 00 
    a4c2:	c4 c1 7c 11 86 d0 01 	vmovups %ymm0,0x1d0(%r14)
    a4c9:	00 00 
    a4cb:	c4 c1 7c 11 86 b0 01 	vmovups %ymm0,0x1b0(%r14)
    a4d2:	00 00 
    a4d4:	c4 c1 7c 11 86 90 01 	vmovups %ymm0,0x190(%r14)
    a4db:	00 00 
    a4dd:	c4 c1 7c 11 86 70 01 	vmovups %ymm0,0x170(%r14)
    a4e4:	00 00 
    a4e6:	c4 c1 7c 11 86 50 01 	vmovups %ymm0,0x150(%r14)
    a4ed:	00 00 
    a4ef:	c4 c1 7c 11 86 30 01 	vmovups %ymm0,0x130(%r14)
    a4f6:	00 00 
    a4f8:	c4 c1 7c 11 86 10 01 	vmovups %ymm0,0x110(%r14)
    a4ff:	00 00 
    a501:	c4 c1 7c 11 86 f0 00 	vmovups %ymm0,0xf0(%r14)
    a508:	00 00 
    a50a:	c4 c1 7c 11 86 d0 00 	vmovups %ymm0,0xd0(%r14)
    a511:	00 00 
    a513:	c4 c1 7c 11 86 b0 00 	vmovups %ymm0,0xb0(%r14)
    a51a:	00 00 
    a51c:	c4 c1 7c 11 86 90 00 	vmovups %ymm0,0x90(%r14)
    a523:	00 00 
    a525:	c4 c1 7c 11 46 70    	vmovups %ymm0,0x70(%r14)
    a52b:	c4 c1 7c 11 46 50    	vmovups %ymm0,0x50(%r14)
    a531:	c4 c1 7c 11 46 30    	vmovups %ymm0,0x30(%r14)
    a537:	c4 c1 7c 11 46 10    	vmovups %ymm0,0x10(%r14)
    a53d:	49 8d 5e 10          	lea    0x10(%r14),%rbx
    a541:	49 c1 e7 04          	shl    $0x4,%r15
    a545:	41 8b bf c6 7d 00 00 	mov    0x7dc6(%r15),%edi
    a54c:	48 8b 04 25 d0 00 11 	mov    0x1100d0,%rax
    a553:	00 
    a554:	48 8b 48 20          	mov    0x20(%rax),%rcx
    a558:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
    a55d:	c5 fc 10 00          	vmovups (%rax),%ymm0
    a561:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    a566:	be 01 00 00 00       	mov    $0x1,%esi
    a56b:	48 89 da             	mov    %rbx,%rdx
    a56e:	c5 f8 77             	vzeroupper 
    a571:	e8 ea f6 ff ff       	call   9c60 <_Z9ahci_read11ahci_devicemtPv>
    a576:	41 80 7e 52 29       	cmpb   $0x29,0x52(%r14)
    a57b:	0f 85 8d 01 00 00    	jne    a70e <_Z8fat_initv+0x30e>
    a581:	49 81 c7 be 7d 00 00 	add    $0x7dbe,%r15
    a588:	49 83 c7 08          	add    $0x8,%r15
    a58c:	0f b6 43 0d          	movzbl 0xd(%rbx),%eax
    a590:	66 89 04 25 d8 00 11 	mov    %ax,0x1100d8
    a597:	00 
    a598:	0f b7 4b 0b          	movzwl 0xb(%rbx),%ecx
    a59c:	66 89 0c 25 da 00 11 	mov    %cx,0x1100da
    a5a3:	00 
    a5a4:	0f af c8             	imul   %eax,%ecx
    a5a7:	66 89 0c 25 dc 00 11 	mov    %cx,0x1100dc
    a5ae:	00 
    a5af:	0f b7 43 0e          	movzwl 0xe(%rbx),%eax
    a5b3:	0f b6 4b 10          	movzbl 0x10(%rbx),%ecx
    a5b7:	0f af 4b 24          	imul   0x24(%rbx),%ecx
    a5bb:	41 03 07             	add    (%r15),%eax
    a5be:	41 bf be 7d 00 00    	mov    $0x7dbe,%r15d
    a5c4:	01 c8                	add    %ecx,%eax
    a5c6:	89 04 25 e0 00 11 00 	mov    %eax,0x1100e0
    a5cd:	c6 43 10 01          	movb   $0x1,0x10(%rbx)
    a5d1:	48 c7 04 25 f8 00 11 	movq   $0x0,0x1100f8
    a5d8:	00 00 00 00 00 
    a5dd:	c7 04 25 00 01 11 00 	movl   $0x0,0x110100
    a5e4:	00 00 00 00 
    a5e8:	c7 04 25 04 01 11 00 	movl   $0x0,0x110104
    a5ef:	00 00 00 00 
    a5f3:	45 31 e4             	xor    %r12d,%r12d
    a5f6:	eb 64                	jmp    a65c <_Z8fat_initv+0x25c>
    a5f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    a5ff:	00 
    a600:	48 8b 04 25 f8 00 11 	mov    0x1100f8,%rax
    a607:	00 
    a608:	4a 8b 14 e0          	mov    (%rax,%r12,8),%rdx
    a60c:	4c 89 e0             	mov    %r12,%rax
    a60f:	48 c1 e0 04          	shl    $0x4,%rax
    a613:	0f b7 7b 0e          	movzwl 0xe(%rbx),%edi
    a617:	8b 4b 24             	mov    0x24(%rbx),%ecx
    a61a:	44 89 e6             	mov    %r12d,%esi
    a61d:	0f af f1             	imul   %ecx,%esi
    a620:	41 03 7c 07 08       	add    0x8(%r15,%rax,1),%edi
    a625:	01 f7                	add    %esi,%edi
    a627:	48 8b 04 25 d0 00 11 	mov    0x1100d0,%rax
    a62e:	00 
    a62f:	48 8b 70 20          	mov    0x20(%rax),%rsi
    a633:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
    a638:	c5 fc 10 00          	vmovups (%rax),%ymm0
    a63c:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    a641:	0f b7 f1             	movzwl %cx,%esi
    a644:	c5 f8 77             	vzeroupper 
    a647:	e8 14 f6 ff ff       	call   9c60 <_Z9ahci_read11ahci_devicemtPv>
    a64c:	49 ff c4             	inc    %r12
    a64f:	0f b6 43 10          	movzbl 0x10(%rbx),%eax
    a653:	49 39 c4             	cmp    %rax,%r12
    a656:	0f 83 c6 00 00 00    	jae    a722 <_Z8fat_initv+0x322>
    a65c:	0f b7 43 0b          	movzwl 0xb(%rbx),%eax
    a660:	0f af 43 24          	imul   0x24(%rbx),%eax
    a664:	4c 8b 2c 25 20 00 11 	mov    0x110020,%r13
    a66b:	00 
    a66c:	49 83 c5 0f          	add    $0xf,%r13
    a670:	49 83 e5 f0          	and    $0xfffffffffffffff0,%r13
    a674:	4c 01 e8             	add    %r13,%rax
    a677:	48 89 04 25 20 00 11 	mov    %rax,0x110020
    a67e:	00 
    a67f:	8b 34 25 00 01 11 00 	mov    0x110100,%esi
    a686:	bf f8 00 11 00       	mov    $0x1100f8,%edi
    a68b:	e8 00 58 00 00       	call   fe90 <_ZN6vectorIPjE2atEi>
    a690:	4c 89 28             	mov    %r13,(%rax)
    a693:	83 3c 25 00 01 11 00 	cmpl   $0x0,0x110100
    a69a:	00 
    a69b:	0f 85 5f ff ff ff    	jne    a600 <_Z8fat_initv+0x200>
    a6a1:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    a6a8:	01 
    a6a9:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    a6ae:	48 83 f8 1f          	cmp    $0x1f,%rax
    a6b2:	77 19                	ja     a6cd <_Z8fat_initv+0x2cd>
    a6b4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    a6bb:	00 00 00 00 00 
    a6c0:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    a6c4:	48 8b 01             	mov    (%rcx),%rax
    a6c7:	48 83 f8 20          	cmp    $0x20,%rax
    a6cb:	72 f3                	jb     a6c0 <_Z8fat_initv+0x2c0>
    a6cd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    a6d1:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    a6d5:	48 83 fe 0f          	cmp    $0xf,%rsi
    a6d9:	77 0a                	ja     a6e5 <_Z8fat_initv+0x2e5>
    a6db:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    a6df:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    a6e3:	eb 0f                	jmp    a6f4 <_Z8fat_initv+0x2f4>
    a6e5:	48 89 31             	mov    %rsi,(%rcx)
    a6e8:	48 c1 e6 04          	shl    $0x4,%rsi
    a6ec:	48 01 f2             	add    %rsi,%rdx
    a6ef:	b8 20 00 00 00       	mov    $0x20,%eax
    a6f4:	48 89 02             	mov    %rax,(%rdx)
    a6f7:	48 01 04 25 28 00 11 	add    %rax,0x110028
    a6fe:	00 
    a6ff:	48 c7 42 10 00 00 00 	movq   $0x0,0x10(%rdx)
    a706:	00 
    a707:	31 d2                	xor    %edx,%edx
    a709:	e9 fe fe ff ff       	jmp    a60c <_Z8fat_initv+0x20c>
    a70e:	bf 00 00 11 00       	mov    $0x110000,%edi
    a713:	be c0 07 01 00       	mov    $0x107c0,%esi
    a718:	e8 43 e6 ff ff       	call   8d60 <_ZN7console6putstrEPKc>
    a71d:	0f 1f 00             	nopl   (%rax)
    a720:	eb fe                	jmp    a720 <_Z8fat_initv+0x320>
    a722:	c6 04 25 08 01 11 00 	movb   $0x0,0x110108
    a729:	00 
    a72a:	c6 04 25 09 01 11 00 	movb   $0x0,0x110109
    a731:	00 
    a732:	c6 04 25 0a 01 11 00 	movb   $0x0,0x11010a
    a739:	00 
    a73a:	c6 04 25 0b 01 11 00 	movb   $0x0,0x11010b
    a741:	00 
    a742:	c6 04 25 0c 01 11 00 	movb   $0x0,0x11010c
    a749:	00 
    a74a:	c6 04 25 0d 01 11 00 	movb   $0x0,0x11010d
    a751:	00 
    a752:	c6 04 25 0e 01 11 00 	movb   $0x0,0x11010e
    a759:	00 
    a75a:	c6 04 25 0f 01 11 00 	movb   $0x0,0x11010f
    a761:	00 
    a762:	c6 04 25 10 01 11 00 	movb   $0x0,0x110110
    a769:	00 
    a76a:	c6 04 25 11 01 11 00 	movb   $0x0,0x110111
    a771:	00 
    a772:	c6 04 25 12 01 11 00 	movb   $0x0,0x110112
    a779:	00 
    a77a:	c6 04 25 13 01 11 00 	movb   $0x0,0x110113
    a781:	00 
    a782:	c6 04 25 14 01 11 00 	movb   $0x0,0x110114
    a789:	00 
    a78a:	c6 04 25 15 01 11 00 	movb   $0x0,0x110115
    a791:	00 
    a792:	c6 04 25 16 01 11 00 	movb   $0x0,0x110116
    a799:	00 
    a79a:	c6 04 25 17 01 11 00 	movb   $0x0,0x110117
    a7a1:	00 
    a7a2:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    a7a9:	01 
    a7aa:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    a7af:	48 83 f8 5f          	cmp    $0x5f,%rax
    a7b3:	77 18                	ja     a7cd <_Z8fat_initv+0x3cd>
    a7b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    a7bc:	00 00 00 00 
    a7c0:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    a7c4:	48 8b 01             	mov    (%rcx),%rax
    a7c7:	48 83 f8 60          	cmp    $0x60,%rax
    a7cb:	72 f3                	jb     a7c0 <_Z8fat_initv+0x3c0>
    a7cd:	4c 8b 79 08          	mov    0x8(%rcx),%r15
    a7d1:	48 8d 50 a0          	lea    -0x60(%rax),%rdx
    a7d5:	48 83 fa 0f          	cmp    $0xf,%rdx
    a7d9:	77 0b                	ja     a7e6 <_Z8fat_initv+0x3e6>
    a7db:	c4 c1 78 10 07       	vmovups (%r15),%xmm0
    a7e0:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    a7e4:	eb 0f                	jmp    a7f5 <_Z8fat_initv+0x3f5>
    a7e6:	48 89 11             	mov    %rdx,(%rcx)
    a7e9:	48 c1 e2 04          	shl    $0x4,%rdx
    a7ed:	49 01 d7             	add    %rdx,%r15
    a7f0:	b8 60 00 00 00       	mov    $0x60,%eax
    a7f5:	49 89 07             	mov    %rax,(%r15)
    a7f8:	48 01 04 25 28 00 11 	add    %rax,0x110028
    a7ff:	00 
    a800:	41 0f b7 46 21       	movzwl 0x21(%r14),%eax
    a805:	c1 e0 05             	shl    $0x5,%eax
    a808:	41 8b 4e 3c          	mov    0x3c(%r14),%ecx
    a80c:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    a810:	c4 c1 78 11 47 10    	vmovups %xmm0,0x10(%r15)
    a816:	41 89 47 20          	mov    %eax,0x20(%r15)
    a81a:	41 c6 47 24 1c       	movb   $0x1c,0x24(%r15)
    a81f:	41 80 67 25 f8       	andb   $0xf8,0x25(%r15)
    a824:	49 8d 5f 10          	lea    0x10(%r15),%rbx
    a828:	66 41 c7 47 26 00 00 	movw   $0x0,0x26(%r15)
    a82f:	49 c7 47 38 00 00 00 	movq   $0x0,0x38(%r15)
    a836:	00 
    a837:	41 89 4f 40          	mov    %ecx,0x40(%r15)
    a83b:	c4 c1 78 11 47 48    	vmovups %xmm0,0x48(%r15)
    a841:	c4 c1 78 11 47 28    	vmovups %xmm0,0x28(%r15)
    a847:	48 89 df             	mov    %rbx,%rdi
    a84a:	e8 01 02 00 00       	call   aa50 <_ZN9fat_inode4readEv>
    a84f:	41 0f b7 47 26       	movzwl 0x26(%r15),%eax
    a854:	48 89 1c 25 08 01 11 	mov    %rbx,0x110108
    a85b:	00 
    a85c:	48 89 1c 25 10 01 11 	mov    %rbx,0x110110
    a863:	00 
    a864:	66 83 c0 02          	add    $0x2,%ax
    a868:	66 41 89 47 26       	mov    %ax,0x26(%r15)
    a86d:	49 8b 06             	mov    (%r14),%rax
    a870:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    a877:	00 01 
    a879:	c4 c1 78 11 06       	vmovups %xmm0,(%r14)
    a87e:	48 89 04 25 00 00 00 	mov    %rax,0x1000000
    a885:	01 
    a886:	4c 89 34 25 08 00 00 	mov    %r14,0x1000008
    a88d:	01 
    a88e:	48 29 04 25 28 00 11 	sub    %rax,0x110028
    a895:	00 
    a896:	48 83 c4 30          	add    $0x30,%rsp
    a89a:	5b                   	pop    %rbx
    a89b:	41 5c                	pop    %r12
    a89d:	41 5d                	pop    %r13
    a89f:	41 5e                	pop    %r14
    a8a1:	41 5f                	pop    %r15
    a8a3:	c3                   	ret    
    a8a4:	bf 00 00 11 00       	mov    $0x110000,%edi
    a8a9:	be 0f 08 01 00       	mov    $0x1080f,%esi
    a8ae:	e8 ad e4 ff ff       	call   8d60 <_ZN7console6putstrEPKc>
    a8b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    a8ba:	84 00 00 00 00 00 
    a8c0:	eb fe                	jmp    a8c0 <_Z8fat_initv+0x4c0>
    a8c2:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    a8c9:	00 00 00 
    a8cc:	0f 1f 40 00          	nopl   0x0(%rax)

000000000000a8d0 <_ZN9fat_inode4openEv>:
    a8d0:	41 57                	push   %r15
    a8d2:	41 56                	push   %r14
    a8d4:	41 54                	push   %r12
    a8d6:	53                   	push   %rbx
    a8d7:	48 83 ec 18          	sub    $0x18,%rsp
    a8db:	f6 47 15 01          	testb  $0x1,0x15(%rdi)
    a8df:	0f 85 32 01 00 00    	jne    aa17 <_ZN9fat_inode4openEv+0x147>
    a8e5:	48 89 fb             	mov    %rdi,%rbx
    a8e8:	8b 47 30             	mov    0x30(%rdi),%eax
    a8eb:	48 b9 00 00 00 00 01 	movabs $0x100000000,%rcx
    a8f2:	00 00 00 
    a8f5:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
    a8fa:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    a901:	01 
    a902:	ba 00 00 00 01       	mov    $0x1000000,%edx
    a907:	48 83 f9 1f          	cmp    $0x1f,%rcx
    a90b:	77 10                	ja     a91d <_ZN9fat_inode4openEv+0x4d>
    a90d:	0f 1f 00             	nopl   (%rax)
    a910:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    a914:	48 8b 0a             	mov    (%rdx),%rcx
    a917:	48 83 f9 20          	cmp    $0x20,%rcx
    a91b:	72 f3                	jb     a910 <_ZN9fat_inode4openEv+0x40>
    a91d:	48 8b 72 08          	mov    0x8(%rdx),%rsi
    a921:	48 8d 79 e0          	lea    -0x20(%rcx),%rdi
    a925:	48 83 ff 0f          	cmp    $0xf,%rdi
    a929:	77 0a                	ja     a935 <_ZN9fat_inode4openEv+0x65>
    a92b:	c5 f8 10 06          	vmovups (%rsi),%xmm0
    a92f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    a933:	eb 0f                	jmp    a944 <_ZN9fat_inode4openEv+0x74>
    a935:	48 89 3a             	mov    %rdi,(%rdx)
    a938:	48 c1 e7 04          	shl    $0x4,%rdi
    a93c:	48 01 fe             	add    %rdi,%rsi
    a93f:	b9 20 00 00 00       	mov    $0x20,%ecx
    a944:	48 89 0e             	mov    %rcx,(%rsi)
    a947:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    a94e:	00 
    a94f:	48 83 c6 10          	add    $0x10,%rsi
    a953:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
    a958:	4c 8d 74 24 08       	lea    0x8(%rsp),%r14
    a95d:	89 c2                	mov    %eax,%edx
    a95f:	90                   	nop
    a960:	83 3c 25 00 01 11 00 	cmpl   $0x0,0x110100
    a967:	00 
    a968:	0f 84 b5 00 00 00    	je     aa23 <_ZN9fat_inode4openEv+0x153>
    a96e:	89 d1                	mov    %edx,%ecx
    a970:	48 8b 14 25 f8 00 11 	mov    0x1100f8,%rdx
    a977:	00 
    a978:	48 8b 12             	mov    (%rdx),%rdx
    a97b:	41 89 cf             	mov    %ecx,%r15d
    a97e:	42 8b 14 ba          	mov    (%rdx,%r15,4),%edx
    a982:	8d 71 01             	lea    0x1(%rcx),%esi
    a985:	39 f2                	cmp    %esi,%edx
    a987:	74 d7                	je     a960 <_ZN9fat_inode4openEv+0x90>
    a989:	29 c1                	sub    %eax,%ecx
    a98b:	ff c1                	inc    %ecx
    a98d:	48 c1 e1 20          	shl    $0x20,%rcx
    a991:	41 89 c4             	mov    %eax,%r12d
    a994:	49 09 cc             	or     %rcx,%r12
    a997:	8b 74 24 10          	mov    0x10(%rsp),%esi
    a99b:	4c 89 f7             	mov    %r14,%rdi
    a99e:	e8 7d 52 00 00       	call   fc20 <_ZN6vectorI13fat_disk_spanE2atEi>
    a9a3:	4c 89 20             	mov    %r12,(%rax)
    a9a6:	83 3c 25 00 01 11 00 	cmpl   $0x0,0x110100
    a9ad:	00 
    a9ae:	0f 84 82 00 00 00    	je     aa36 <_ZN9fat_inode4openEv+0x166>
    a9b4:	48 8b 04 25 f8 00 11 	mov    0x1100f8,%rax
    a9bb:	00 
    a9bc:	48 8b 00             	mov    (%rax),%rax
    a9bf:	42 8b 04 b8          	mov    (%rax,%r15,4),%eax
    a9c3:	3d f8 ff ff 0f       	cmp    $0xffffff8,%eax
    a9c8:	75 93                	jne    a95d <_ZN9fat_inode4openEv+0x8d>
    a9ca:	48 8b 43 38          	mov    0x38(%rbx),%rax
    a9ce:	48 85 c0             	test   %rax,%rax
    a9d1:	74 2e                	je     aa01 <_ZN9fat_inode4openEv+0x131>
    a9d3:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    a9d7:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    a9db:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    a9e2:	00 01 
    a9e4:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    a9e9:	48 89 14 25 00 00 00 	mov    %rdx,0x1000000
    a9f0:	01 
    a9f1:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    a9f8:	01 
    a9f9:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    aa00:	00 
    aa01:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    aa06:	48 89 43 38          	mov    %rax,0x38(%rbx)
    aa0a:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    aa0f:	48 89 43 40          	mov    %rax,0x40(%rbx)
    aa13:	80 4b 15 01          	orb    $0x1,0x15(%rbx)
    aa17:	48 83 c4 18          	add    $0x18,%rsp
    aa1b:	5b                   	pop    %rbx
    aa1c:	41 5c                	pop    %r12
    aa1e:	41 5e                	pop    %r14
    aa20:	41 5f                	pop    %r15
    aa22:	c3                   	ret    
    aa23:	b8 00 00 00 01       	mov    $0x1000000,%eax
    aa28:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    aa2f:	00 
    aa30:	48 8b 40 08          	mov    0x8(%rax),%rax
    aa34:	eb fa                	jmp    aa30 <_ZN9fat_inode4openEv+0x160>
    aa36:	b8 00 00 00 01       	mov    $0x1000000,%eax
    aa3b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    aa40:	48 8b 40 08          	mov    0x8(%rax),%rax
    aa44:	eb fa                	jmp    aa40 <_ZN9fat_inode4openEv+0x170>
    aa46:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    aa4d:	00 00 00 

000000000000aa50 <_ZN9fat_inode4readEv>:
    aa50:	0f b6 47 15          	movzbl 0x15(%rdi),%eax
    aa54:	a8 02                	test   $0x2,%al
    aa56:	0f 85 13 0b 00 00    	jne    b56f <_ZN9fat_inode4readEv+0xb1f>
    aa5c:	55                   	push   %rbp
    aa5d:	41 57                	push   %r15
    aa5f:	41 56                	push   %r14
    aa61:	41 55                	push   %r13
    aa63:	41 54                	push   %r12
    aa65:	53                   	push   %rbx
    aa66:	48 83 ec 78          	sub    $0x78,%rsp
    aa6a:	49 89 fc             	mov    %rdi,%r12
    aa6d:	a8 01                	test   $0x1,%al
    aa6f:	75 08                	jne    aa79 <_ZN9fat_inode4readEv+0x29>
    aa71:	4c 89 e7             	mov    %r12,%rdi
    aa74:	e8 57 fe ff ff       	call   a8d0 <_ZN9fat_inode4openEv>
    aa79:	4d 8d 74 24 38       	lea    0x38(%r12),%r14
    aa7e:	41 83 7c 24 40 00    	cmpl   $0x0,0x40(%r12)
    aa84:	7e 22                	jle    aaa8 <_ZN9fat_inode4readEv+0x58>
    aa86:	31 db                	xor    %ebx,%ebx
    aa88:	31 ed                	xor    %ebp,%ebp
    aa8a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    aa90:	4c 89 f7             	mov    %r14,%rdi
    aa93:	89 ee                	mov    %ebp,%esi
    aa95:	e8 86 51 00 00       	call   fc20 <_ZN6vectorI13fat_disk_spanE2atEi>
    aa9a:	03 58 04             	add    0x4(%rax),%ebx
    aa9d:	ff c5                	inc    %ebp
    aa9f:	41 3b 6c 24 40       	cmp    0x40(%r12),%ebp
    aaa4:	7c ea                	jl     aa90 <_ZN9fat_inode4readEv+0x40>
    aaa6:	eb 02                	jmp    aaaa <_ZN9fat_inode4readEv+0x5a>
    aaa8:	31 db                	xor    %ebx,%ebx
    aaaa:	0f b7 04 25 dc 00 11 	movzwl 0x1100dc,%eax
    aab1:	00 
    aab2:	48 63 cb             	movslq %ebx,%rcx
    aab5:	48 0f af c8          	imul   %rax,%rcx
    aab9:	48 83 c1 1f          	add    $0x1f,%rcx
    aabd:	48 83 e1 f0          	and    $0xfffffffffffffff0,%rcx
    aac1:	b8 10 00 00 00       	mov    $0x10,%eax
    aac6:	48 0f 45 c1          	cmovne %rcx,%rax
    aaca:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    aad1:	01 
    aad2:	ba 00 00 00 01       	mov    $0x1000000,%edx
    aad7:	48 39 c1             	cmp    %rax,%rcx
    aada:	73 10                	jae    aaec <_ZN9fat_inode4readEv+0x9c>
    aadc:	0f 1f 40 00          	nopl   0x0(%rax)
    aae0:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    aae4:	48 8b 0a             	mov    (%rdx),%rcx
    aae7:	48 39 c1             	cmp    %rax,%rcx
    aaea:	72 f4                	jb     aae0 <_ZN9fat_inode4readEv+0x90>
    aaec:	48 8b 7a 08          	mov    0x8(%rdx),%rdi
    aaf0:	48 89 ce             	mov    %rcx,%rsi
    aaf3:	48 29 c6             	sub    %rax,%rsi
    aaf6:	48 83 fe 0f          	cmp    $0xf,%rsi
    aafa:	77 0a                	ja     ab06 <_ZN9fat_inode4readEv+0xb6>
    aafc:	c5 f8 10 07          	vmovups (%rdi),%xmm0
    ab00:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    ab04:	eb 0d                	jmp    ab13 <_ZN9fat_inode4readEv+0xc3>
    ab06:	48 89 32             	mov    %rsi,(%rdx)
    ab09:	48 c1 e6 04          	shl    $0x4,%rsi
    ab0d:	48 01 f7             	add    %rsi,%rdi
    ab10:	48 89 c1             	mov    %rax,%rcx
    ab13:	4c 8d 6f 10          	lea    0x10(%rdi),%r13
    ab17:	48 89 7c 24 50       	mov    %rdi,0x50(%rsp)
    ab1c:	48 89 0f             	mov    %rcx,(%rdi)
    ab1f:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    ab26:	00 
    ab27:	31 db                	xor    %ebx,%ebx
    ab29:	4c 89 f7             	mov    %r14,%rdi
    ab2c:	31 f6                	xor    %esi,%esi
    ab2e:	e8 ed 50 00 00       	call   fc20 <_ZN6vectorI13fat_disk_spanE2atEi>
    ab33:	44 8b 38             	mov    (%rax),%r15d
    ab36:	41 83 7c 24 40 00    	cmpl   $0x0,0x40(%r12)
    ab3c:	0f 8e 82 00 00 00    	jle    abc4 <_ZN9fat_inode4readEv+0x174>
    ab42:	41 83 c7 fe          	add    $0xfffffffe,%r15d
    ab46:	31 ed                	xor    %ebp,%ebp
    ab48:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    ab4f:	00 
    ab50:	4c 89 f7             	mov    %r14,%rdi
    ab53:	89 ee                	mov    %ebp,%esi
    ab55:	e8 c6 50 00 00       	call   fc20 <_ZN6vectorI13fat_disk_spanE2atEi>
    ab5a:	0f b7 0c 25 d8 00 11 	movzwl 0x1100d8,%ecx
    ab61:	00 
    ab62:	0f b7 40 04          	movzwl 0x4(%rax),%eax
    ab66:	66 0f af c1          	imul   %cx,%ax
    ab6a:	89 cf                	mov    %ecx,%edi
    ab6c:	41 0f af ff          	imul   %r15d,%edi
    ab70:	03 3c 25 e0 00 11 00 	add    0x1100e0,%edi
    ab77:	0f b7 14 25 dc 00 11 	movzwl 0x1100dc,%edx
    ab7e:	00 
    ab7f:	48 63 db             	movslq %ebx,%rbx
    ab82:	48 0f af d3          	imul   %rbx,%rdx
    ab86:	4c 01 ea             	add    %r13,%rdx
    ab89:	48 8b 0c 25 d0 00 11 	mov    0x1100d0,%rcx
    ab90:	00 
    ab91:	48 8b 71 20          	mov    0x20(%rcx),%rsi
    ab95:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
    ab9a:	c5 fc 10 01          	vmovups (%rcx),%ymm0
    ab9e:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    aba3:	0f b7 f0             	movzwl %ax,%esi
    aba6:	c5 f8 77             	vzeroupper 
    aba9:	e8 b2 f0 ff ff       	call   9c60 <_Z9ahci_read11ahci_devicemtPv>
    abae:	4c 89 f7             	mov    %r14,%rdi
    abb1:	89 ee                	mov    %ebp,%esi
    abb3:	e8 68 50 00 00       	call   fc20 <_ZN6vectorI13fat_disk_spanE2atEi>
    abb8:	03 58 04             	add    0x4(%rax),%ebx
    abbb:	ff c5                	inc    %ebp
    abbd:	41 3b 6c 24 40       	cmp    0x40(%r12),%ebp
    abc2:	7c 8c                	jl     ab50 <_ZN9fat_inode4readEv+0x100>
    abc4:	4c 89 6c 24 38       	mov    %r13,0x38(%rsp)
    abc9:	41 f6 44 24 14 10    	testb  $0x10,0x14(%r12)
    abcf:	4c 89 64 24 30       	mov    %r12,0x30(%rsp)
    abd4:	75 68                	jne    ac3e <_ZN9fat_inode4readEv+0x1ee>
    abd6:	41 8b 44 24 10       	mov    0x10(%r12),%eax
    abdb:	48 63 c8             	movslq %eax,%rcx
    abde:	48 8d 51 1f          	lea    0x1f(%rcx),%rdx
    abe2:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
    abe6:	be 10 00 00 00       	mov    $0x10,%esi
    abeb:	48 0f 45 f2          	cmovne %rdx,%rsi
    abef:	48 8b 3c 25 00 00 00 	mov    0x1000000,%rdi
    abf6:	01 
    abf7:	41 b8 00 00 00 01    	mov    $0x1000000,%r8d
    abfd:	48 39 f7             	cmp    %rsi,%rdi
    ac00:	4c 8b 54 24 38       	mov    0x38(%rsp),%r10
    ac05:	73 15                	jae    ac1c <_ZN9fat_inode4readEv+0x1cc>
    ac07:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    ac0e:	00 00 
    ac10:	4d 8b 40 08          	mov    0x8(%r8),%r8
    ac14:	49 8b 38             	mov    (%r8),%rdi
    ac17:	48 39 f7             	cmp    %rsi,%rdi
    ac1a:	72 f4                	jb     ac10 <_ZN9fat_inode4readEv+0x1c0>
    ac1c:	49 8b 50 08          	mov    0x8(%r8),%rdx
    ac20:	49 89 f9             	mov    %rdi,%r9
    ac23:	49 29 f1             	sub    %rsi,%r9
    ac26:	49 83 f9 0f          	cmp    $0xf,%r9
    ac2a:	0f 87 49 07 00 00    	ja     b379 <_ZN9fat_inode4readEv+0x929>
    ac30:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    ac34:	c4 c1 78 11 00       	vmovups %xmm0,(%r8)
    ac39:	e9 48 07 00 00       	jmp    b386 <_ZN9fat_inode4readEv+0x936>
    ac3e:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
    ac43:	0f b6 42 0b          	movzbl 0xb(%rdx),%eax
    ac47:	84 c0                	test   %al,%al
    ac49:	0f 84 dc 08 00 00    	je     b52b <_ZN9fat_inode4readEv+0xadb>
    ac4f:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
    ac54:	48 83 c1 18          	add    $0x18,%rcx
    ac58:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
    ac5d:	48 8d 4a 0b          	lea    0xb(%rdx),%rcx
    ac61:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
    ac66:	31 c9                	xor    %ecx,%ecx
    ac68:	41 bd 10 00 00 00    	mov    $0x10,%r13d
    ac6e:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
    ac73:	eb 52                	jmp    acc7 <_ZN9fat_inode4readEv+0x277>
    ac75:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    ac7c:	00 00 00 00 
    ac80:	48 8b 5c 24 68       	mov    0x68(%rsp),%rbx
    ac85:	01 cb                	add    %ecx,%ebx
    ac87:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
    ac8c:	8b 70 20             	mov    0x20(%rax),%esi
    ac8f:	48 8b 7c 24 60       	mov    0x60(%rsp),%rdi
    ac94:	e8 27 09 00 00       	call   b5c0 <_ZN6vectorIP9fat_inodeE2atEi>
    ac99:	48 89 d9             	mov    %rbx,%rcx
    ac9c:	4c 89 30             	mov    %r14,(%rax)
    ac9f:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
    aca4:	48 63 c1             	movslq %ecx,%rax
    aca7:	ff c1                	inc    %ecx
    aca9:	48 c1 e0 05          	shl    $0x5,%rax
    acad:	48 8d 34 10          	lea    (%rax,%rdx,1),%rsi
    acb1:	48 83 c6 20          	add    $0x20,%rsi
    acb5:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
    acba:	0f b6 44 10 2b       	movzbl 0x2b(%rax,%rdx,1),%eax
    acbf:	84 c0                	test   %al,%al
    acc1:	0f 84 64 08 00 00    	je     b52b <_ZN9fat_inode4readEv+0xadb>
    acc7:	3c 0f                	cmp    $0xf,%al
    acc9:	74 04                	je     accf <_ZN9fat_inode4readEv+0x27f>
    accb:	24 08                	and    $0x8,%al
    accd:	75 d5                	jne    aca4 <_ZN9fat_inode4readEv+0x254>
    accf:	48 89 4c 24 68       	mov    %rcx,0x68(%rsp)
    acd4:	48 63 c1             	movslq %ecx,%rax
    acd7:	48 c1 e0 05          	shl    $0x5,%rax
    acdb:	48 03 44 24 58       	add    0x58(%rsp),%rax
    ace0:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
    ace5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    acec:	00 00 00 00 
    acf0:	ff c1                	inc    %ecx
    acf2:	80 38 0f             	cmpb   $0xf,(%rax)
    acf5:	48 8d 40 20          	lea    0x20(%rax),%rax
    acf9:	74 f5                	je     acf0 <_ZN9fat_inode4readEv+0x2a0>
    acfb:	48 8b 34 25 00 00 00 	mov    0x1000000,%rsi
    ad02:	01 
    ad03:	b8 00 00 00 01       	mov    $0x1000000,%eax
    ad08:	48 83 fe 5f          	cmp    $0x5f,%rsi
    ad0c:	77 0f                	ja     ad1d <_ZN9fat_inode4readEv+0x2cd>
    ad0e:	66 90                	xchg   %ax,%ax
    ad10:	48 8b 40 08          	mov    0x8(%rax),%rax
    ad14:	48 8b 30             	mov    (%rax),%rsi
    ad17:	48 83 fe 60          	cmp    $0x60,%rsi
    ad1b:	72 f3                	jb     ad10 <_ZN9fat_inode4readEv+0x2c0>
    ad1d:	48 8b 50 08          	mov    0x8(%rax),%rdx
    ad21:	48 8d 7e a0          	lea    -0x60(%rsi),%rdi
    ad25:	48 83 ff 0f          	cmp    $0xf,%rdi
    ad29:	77 15                	ja     ad40 <_ZN9fat_inode4readEv+0x2f0>
    ad2b:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    ad2f:	c5 f8 11 00          	vmovups %xmm0,(%rax)
    ad33:	eb 1a                	jmp    ad4f <_ZN9fat_inode4readEv+0x2ff>
    ad35:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    ad3c:	00 00 00 00 
    ad40:	48 89 38             	mov    %rdi,(%rax)
    ad43:	48 c1 e7 04          	shl    $0x4,%rdi
    ad47:	48 01 fa             	add    %rdi,%rdx
    ad4a:	be 60 00 00 00       	mov    $0x60,%esi
    ad4f:	48 63 c1             	movslq %ecx,%rax
    ad52:	48 89 c7             	mov    %rax,%rdi
    ad55:	48 89 32             	mov    %rsi,(%rdx)
    ad58:	48 01 34 25 28 00 11 	add    %rsi,0x110028
    ad5f:	00 
    ad60:	48 c1 e7 05          	shl    $0x5,%rdi
    ad64:	48 03 7c 24 40       	add    0x40(%rsp),%rdi
    ad69:	8b 77 1c             	mov    0x1c(%rdi),%esi
    ad6c:	44 0f b6 47 0b       	movzbl 0xb(%rdi),%r8d
    ad71:	44 0f b7 4f 14       	movzwl 0x14(%rdi),%r9d
    ad76:	41 c1 e1 10          	shl    $0x10,%r9d
    ad7a:	0f b7 7f 1a          	movzwl 0x1a(%rdi),%edi
    ad7e:	44 09 cf             	or     %r9d,%edi
    ad81:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    ad85:	c5 f8 11 42 10       	vmovups %xmm0,0x10(%rdx)
    ad8a:	89 72 20             	mov    %esi,0x20(%rdx)
    ad8d:	44 88 42 24          	mov    %r8b,0x24(%rdx)
    ad91:	80 62 25 f8          	andb   $0xf8,0x25(%rdx)
    ad95:	66 c7 42 26 00 00    	movw   $0x0,0x26(%rdx)
    ad9b:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
    ada0:	48 89 72 38          	mov    %rsi,0x38(%rdx)
    ada4:	89 7a 40             	mov    %edi,0x40(%rdx)
    ada7:	c5 f8 11 42 48       	vmovups %xmm0,0x48(%rdx)
    adac:	4c 8d 72 10          	lea    0x10(%rdx),%r14
    adb0:	c5 f8 11 42 28       	vmovups %xmm0,0x28(%rdx)
    adb5:	85 c0                	test   %eax,%eax
    adb7:	0f 8e c3 fe ff ff    	jle    ac80 <_ZN9fat_inode4readEv+0x230>
    adbd:	89 c8                	mov    %ecx,%eax
    adbf:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
    adc4:	31 f6                	xor    %esi,%esi
    adc6:	eb 36                	jmp    adfe <_ZN9fat_inode4readEv+0x3ae>
    adc8:	4d 8b 16             	mov    (%r14),%r10
    adcb:	41 8b 46 08          	mov    0x8(%r14),%eax
    adcf:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
    add4:	39 d0                	cmp    %edx,%eax
    add6:	0f 4e c2             	cmovle %edx,%eax
    add9:	41 89 46 08          	mov    %eax,0x8(%r14)
    addd:	45 88 44 12 ff       	mov    %r8b,-0x1(%r10,%rdx,1)
    ade2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    ade9:	1f 84 00 00 00 00 00 
    adf0:	48 ff c6             	inc    %rsi
    adf3:	48 3b 74 24 70       	cmp    0x70(%rsp),%rsi
    adf8:	0f 84 82 fe ff ff    	je     ac80 <_ZN9fat_inode4readEv+0x230>
    adfe:	48 89 f0             	mov    %rsi,%rax
    ae01:	48 c1 e0 05          	shl    $0x5,%rax
    ae05:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
    ae0a:	4c 8d 04 02          	lea    (%rdx,%rax,1),%r8
    ae0e:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    ae12:	83 e0 3f             	and    $0x3f,%eax
    ae15:	48 8d 14 40          	lea    (%rax,%rax,2),%rdx
    ae19:	48 8d 3c 90          	lea    (%rax,%rdx,4),%rdi
    ae1d:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
    ae22:	4c 8d 0c 90          	lea    (%rax,%rdx,4),%r9
    ae26:	49 83 c1 f3          	add    $0xfffffffffffffff3,%r9
    ae2a:	45 31 d2             	xor    %r10d,%r10d
    ae2d:	eb 26                	jmp    ae55 <_ZN9fat_inode4readEv+0x405>
    ae2f:	90                   	nop
    ae30:	49 8b 2e             	mov    (%r14),%rbp
    ae33:	41 8b 46 08          	mov    0x8(%r14),%eax
    ae37:	8d 53 01             	lea    0x1(%rbx),%edx
    ae3a:	39 d0                	cmp    %edx,%eax
    ae3c:	0f 4f d0             	cmovg  %eax,%edx
    ae3f:	41 89 56 08          	mov    %edx,0x8(%r14)
    ae43:	44 88 5c 1d 00       	mov    %r11b,0x0(%rbp,%rbx,1)
    ae48:	49 ff c2             	inc    %r10
    ae4b:	49 83 fa 05          	cmp    $0x5,%r10
    ae4f:	0f 84 3b 01 00 00    	je     af90 <_ZN9fat_inode4readEv+0x540>
    ae55:	47 0f b7 5c 50 01    	movzwl 0x1(%r8,%r10,2),%r11d
    ae5b:	66 45 85 db          	test   %r11w,%r11w
    ae5f:	74 8f                	je     adf0 <_ZN9fat_inode4readEv+0x3a0>
    ae61:	4b 8d 1c 0a          	lea    (%r10,%r9,1),%rbx
    ae65:	49 63 46 0c          	movslq 0xc(%r14),%rax
    ae69:	48 39 c3             	cmp    %rax,%rbx
    ae6c:	7c c2                	jl     ae30 <_ZN9fat_inode4readEv+0x3e0>
    ae6e:	83 f8 02             	cmp    $0x2,%eax
    ae71:	ba 01 00 00 00       	mov    $0x1,%edx
    ae76:	0f 4c c2             	cmovl  %edx,%eax
    ae79:	48 39 c3             	cmp    %rax,%rbx
    ae7c:	7d 12                	jge    ae90 <_ZN9fat_inode4readEv+0x440>
    ae7e:	48 89 c2             	mov    %rax,%rdx
    ae81:	eb 21                	jmp    aea4 <_ZN9fat_inode4readEv+0x454>
    ae83:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    ae8a:	84 00 00 00 00 00 
    ae90:	c5 f2 2a c0          	vcvtsi2ss %eax,%xmm1,%xmm0
    ae94:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    ae98:	c5 fa 2c c0          	vcvttss2si %xmm0,%eax
    ae9c:	48 63 d0             	movslq %eax,%rdx
    ae9f:	48 39 d3             	cmp    %rdx,%rbx
    aea2:	7d ec                	jge    ae90 <_ZN9fat_inode4readEv+0x440>
    aea4:	48 83 c2 1f          	add    $0x1f,%rdx
    aea8:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
    aeac:	49 0f 44 d5          	cmove  %r13,%rdx
    aeb0:	4c 8b 24 25 00 00 00 	mov    0x1000000,%r12
    aeb7:	01 
    aeb8:	bf 00 00 00 01       	mov    $0x1000000,%edi
    aebd:	49 39 d4             	cmp    %rdx,%r12
    aec0:	73 1a                	jae    aedc <_ZN9fat_inode4readEv+0x48c>
    aec2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    aec9:	1f 84 00 00 00 00 00 
    aed0:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
    aed4:	4c 8b 27             	mov    (%rdi),%r12
    aed7:	49 39 d4             	cmp    %rdx,%r12
    aeda:	72 f4                	jb     aed0 <_ZN9fat_inode4readEv+0x480>
    aedc:	48 8b 6f 08          	mov    0x8(%rdi),%rbp
    aee0:	4d 89 e7             	mov    %r12,%r15
    aee3:	49 29 d7             	sub    %rdx,%r15
    aee6:	49 83 ff 0f          	cmp    $0xf,%r15
    aeea:	77 14                	ja     af00 <_ZN9fat_inode4readEv+0x4b0>
    aeec:	c5 f8 10 45 00       	vmovups 0x0(%rbp),%xmm0
    aef1:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    aef5:	eb 16                	jmp    af0d <_ZN9fat_inode4readEv+0x4bd>
    aef7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    aefe:	00 00 
    af00:	4c 89 3f             	mov    %r15,(%rdi)
    af03:	49 c1 e7 04          	shl    $0x4,%r15
    af07:	4c 01 fd             	add    %r15,%rbp
    af0a:	49 89 d4             	mov    %rdx,%r12
    af0d:	4c 89 65 00          	mov    %r12,0x0(%rbp)
    af11:	4c 01 24 25 28 00 11 	add    %r12,0x110028
    af18:	00 
    af19:	48 83 c5 10          	add    $0x10,%rbp
    af1d:	49 8b 16             	mov    (%r14),%rdx
    af20:	48 85 d2             	test   %rdx,%rdx
    af23:	74 59                	je     af7e <_ZN9fat_inode4readEv+0x52e>
    af25:	41 83 7e 08 00       	cmpl   $0x0,0x8(%r14)
    af2a:	7e 24                	jle    af50 <_ZN9fat_inode4readEv+0x500>
    af2c:	31 d2                	xor    %edx,%edx
    af2e:	66 90                	xchg   %ax,%ax
    af30:	49 8b 3e             	mov    (%r14),%rdi
    af33:	0f b6 3c 17          	movzbl (%rdi,%rdx,1),%edi
    af37:	40 88 7c 15 00       	mov    %dil,0x0(%rbp,%rdx,1)
    af3c:	48 ff c2             	inc    %rdx
    af3f:	49 63 7e 08          	movslq 0x8(%r14),%rdi
    af43:	48 39 fa             	cmp    %rdi,%rdx
    af46:	7c e8                	jl     af30 <_ZN9fat_inode4readEv+0x4e0>
    af48:	49 8b 16             	mov    (%r14),%rdx
    af4b:	48 85 d2             	test   %rdx,%rdx
    af4e:	74 2e                	je     af7e <_ZN9fat_inode4readEv+0x52e>
    af50:	48 8d 7a f0          	lea    -0x10(%rdx),%rdi
    af54:	4c 8b 7a f0          	mov    -0x10(%rdx),%r15
    af58:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    af5f:	00 01 
    af61:	c5 f8 11 42 f0       	vmovups %xmm0,-0x10(%rdx)
    af66:	4c 89 3c 25 00 00 00 	mov    %r15,0x1000000
    af6d:	01 
    af6e:	48 89 3c 25 08 00 00 	mov    %rdi,0x1000008
    af75:	01 
    af76:	4c 29 3c 25 28 00 11 	sub    %r15,0x110028
    af7d:	00 
    af7e:	49 89 2e             	mov    %rbp,(%r14)
    af81:	41 89 46 0c          	mov    %eax,0xc(%r14)
    af85:	e9 a9 fe ff ff       	jmp    ae33 <_ZN9fat_inode4readEv+0x3e3>
    af8a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    af90:	45 31 d2             	xor    %r10d,%r10d
    af93:	eb 34                	jmp    afc9 <_ZN9fat_inode4readEv+0x579>
    af95:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    af9c:	00 00 00 00 
    afa0:	4d 8b 26             	mov    (%r14),%r12
    afa3:	4b 8d 04 0a          	lea    (%r10,%r9,1),%rax
    afa7:	41 8b 56 08          	mov    0x8(%r14),%edx
    afab:	8d 78 06             	lea    0x6(%rax),%edi
    afae:	39 fa                	cmp    %edi,%edx
    afb0:	0f 4f fa             	cmovg  %edx,%edi
    afb3:	41 89 7e 08          	mov    %edi,0x8(%r14)
    afb7:	45 88 5c 04 05       	mov    %r11b,0x5(%r12,%rax,1)
    afbc:	49 ff c2             	inc    %r10
    afbf:	49 83 fa 06          	cmp    $0x6,%r10
    afc3:	0f 84 37 01 00 00    	je     b100 <_ZN9fat_inode4readEv+0x6b0>
    afc9:	47 0f b7 5c 50 0e    	movzwl 0xe(%r8,%r10,2),%r11d
    afcf:	66 45 85 db          	test   %r11w,%r11w
    afd3:	0f 84 17 fe ff ff    	je     adf0 <_ZN9fat_inode4readEv+0x3a0>
    afd9:	4b 8d 04 0a          	lea    (%r10,%r9,1),%rax
    afdd:	48 83 c0 05          	add    $0x5,%rax
    afe1:	49 63 5e 0c          	movslq 0xc(%r14),%rbx
    afe5:	48 39 d8             	cmp    %rbx,%rax
    afe8:	7c b6                	jl     afa0 <_ZN9fat_inode4readEv+0x550>
    afea:	83 fb 02             	cmp    $0x2,%ebx
    afed:	ba 01 00 00 00       	mov    $0x1,%edx
    aff2:	0f 4c da             	cmovl  %edx,%ebx
    aff5:	48 39 d8             	cmp    %rbx,%rax
    aff8:	7d 06                	jge    b000 <_ZN9fat_inode4readEv+0x5b0>
    affa:	48 89 da             	mov    %rbx,%rdx
    affd:	eb 15                	jmp    b014 <_ZN9fat_inode4readEv+0x5c4>
    afff:	90                   	nop
    b000:	c5 f2 2a c3          	vcvtsi2ss %ebx,%xmm1,%xmm0
    b004:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    b008:	c5 fa 2c d8          	vcvttss2si %xmm0,%ebx
    b00c:	48 63 d3             	movslq %ebx,%rdx
    b00f:	48 39 d0             	cmp    %rdx,%rax
    b012:	7d ec                	jge    b000 <_ZN9fat_inode4readEv+0x5b0>
    b014:	48 83 c2 1f          	add    $0x1f,%rdx
    b018:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
    b01c:	49 0f 44 d5          	cmove  %r13,%rdx
    b020:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    b027:	01 
    b028:	bf 00 00 00 01       	mov    $0x1000000,%edi
    b02d:	48 39 d0             	cmp    %rdx,%rax
    b030:	73 1a                	jae    b04c <_ZN9fat_inode4readEv+0x5fc>
    b032:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    b039:	1f 84 00 00 00 00 00 
    b040:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
    b044:	48 8b 07             	mov    (%rdi),%rax
    b047:	48 39 d0             	cmp    %rdx,%rax
    b04a:	72 f4                	jb     b040 <_ZN9fat_inode4readEv+0x5f0>
    b04c:	4c 8b 67 08          	mov    0x8(%rdi),%r12
    b050:	49 89 c7             	mov    %rax,%r15
    b053:	49 29 d7             	sub    %rdx,%r15
    b056:	49 83 ff 0f          	cmp    $0xf,%r15
    b05a:	77 14                	ja     b070 <_ZN9fat_inode4readEv+0x620>
    b05c:	c4 c1 78 10 04 24    	vmovups (%r12),%xmm0
    b062:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    b066:	eb 15                	jmp    b07d <_ZN9fat_inode4readEv+0x62d>
    b068:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    b06f:	00 
    b070:	4c 89 3f             	mov    %r15,(%rdi)
    b073:	49 c1 e7 04          	shl    $0x4,%r15
    b077:	4d 01 fc             	add    %r15,%r12
    b07a:	48 89 d0             	mov    %rdx,%rax
    b07d:	49 89 04 24          	mov    %rax,(%r12)
    b081:	48 01 04 25 28 00 11 	add    %rax,0x110028
    b088:	00 
    b089:	49 83 c4 10          	add    $0x10,%r12
    b08d:	49 8b 06             	mov    (%r14),%rax
    b090:	48 85 c0             	test   %rax,%rax
    b093:	74 58                	je     b0ed <_ZN9fat_inode4readEv+0x69d>
    b095:	41 83 7e 08 00       	cmpl   $0x0,0x8(%r14)
    b09a:	7e 23                	jle    b0bf <_ZN9fat_inode4readEv+0x66f>
    b09c:	31 c0                	xor    %eax,%eax
    b09e:	66 90                	xchg   %ax,%ax
    b0a0:	49 8b 16             	mov    (%r14),%rdx
    b0a3:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx
    b0a7:	41 88 14 04          	mov    %dl,(%r12,%rax,1)
    b0ab:	48 ff c0             	inc    %rax
    b0ae:	49 63 56 08          	movslq 0x8(%r14),%rdx
    b0b2:	48 39 d0             	cmp    %rdx,%rax
    b0b5:	7c e9                	jl     b0a0 <_ZN9fat_inode4readEv+0x650>
    b0b7:	49 8b 06             	mov    (%r14),%rax
    b0ba:	48 85 c0             	test   %rax,%rax
    b0bd:	74 2e                	je     b0ed <_ZN9fat_inode4readEv+0x69d>
    b0bf:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
    b0c3:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
    b0c7:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    b0ce:	00 01 
    b0d0:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b0d5:	48 89 3c 25 00 00 00 	mov    %rdi,0x1000000
    b0dc:	01 
    b0dd:	48 89 14 25 08 00 00 	mov    %rdx,0x1000008
    b0e4:	01 
    b0e5:	48 29 3c 25 28 00 11 	sub    %rdi,0x110028
    b0ec:	00 
    b0ed:	4d 89 26             	mov    %r12,(%r14)
    b0f0:	41 89 5e 0c          	mov    %ebx,0xc(%r14)
    b0f4:	e9 aa fe ff ff       	jmp    afa3 <_ZN9fat_inode4readEv+0x553>
    b0f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    b100:	45 0f b7 50 1c       	movzwl 0x1c(%r8),%r10d
    b105:	66 45 85 d2          	test   %r10w,%r10w
    b109:	0f 84 e1 fc ff ff    	je     adf0 <_ZN9fat_inode4readEv+0x3a0>
    b10f:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
    b114:	4c 8d 58 fe          	lea    -0x2(%rax),%r11
    b118:	49 63 5e 0c          	movslq 0xc(%r14),%rbx
    b11c:	49 39 db             	cmp    %rbx,%r11
    b11f:	7d 08                	jge    b129 <_ZN9fat_inode4readEv+0x6d9>
    b121:	4d 8b 26             	mov    (%r14),%r12
    b124:	e9 0b 01 00 00       	jmp    b234 <_ZN9fat_inode4readEv+0x7e4>
    b129:	83 fb 02             	cmp    $0x2,%ebx
    b12c:	b8 01 00 00 00       	mov    $0x1,%eax
    b131:	0f 4c d8             	cmovl  %eax,%ebx
    b134:	49 39 db             	cmp    %rbx,%r11
    b137:	7d 07                	jge    b140 <_ZN9fat_inode4readEv+0x6f0>
    b139:	48 89 da             	mov    %rbx,%rdx
    b13c:	eb 16                	jmp    b154 <_ZN9fat_inode4readEv+0x704>
    b13e:	66 90                	xchg   %ax,%ax
    b140:	c5 f2 2a c3          	vcvtsi2ss %ebx,%xmm1,%xmm0
    b144:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    b148:	c5 fa 2c d8          	vcvttss2si %xmm0,%ebx
    b14c:	48 63 d3             	movslq %ebx,%rdx
    b14f:	49 39 d3             	cmp    %rdx,%r11
    b152:	7d ec                	jge    b140 <_ZN9fat_inode4readEv+0x6f0>
    b154:	48 83 c2 1f          	add    $0x1f,%rdx
    b158:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
    b15c:	49 0f 44 d5          	cmove  %r13,%rdx
    b160:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    b167:	01 
    b168:	bf 00 00 00 01       	mov    $0x1000000,%edi
    b16d:	48 39 d0             	cmp    %rdx,%rax
    b170:	73 1a                	jae    b18c <_ZN9fat_inode4readEv+0x73c>
    b172:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    b179:	1f 84 00 00 00 00 00 
    b180:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
    b184:	48 8b 07             	mov    (%rdi),%rax
    b187:	48 39 d0             	cmp    %rdx,%rax
    b18a:	72 f4                	jb     b180 <_ZN9fat_inode4readEv+0x730>
    b18c:	4c 8b 67 08          	mov    0x8(%rdi),%r12
    b190:	49 89 c7             	mov    %rax,%r15
    b193:	49 29 d7             	sub    %rdx,%r15
    b196:	49 83 ff 0f          	cmp    $0xf,%r15
    b19a:	77 0c                	ja     b1a8 <_ZN9fat_inode4readEv+0x758>
    b19c:	c4 c1 78 10 04 24    	vmovups (%r12),%xmm0
    b1a2:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    b1a6:	eb 0d                	jmp    b1b5 <_ZN9fat_inode4readEv+0x765>
    b1a8:	4c 89 3f             	mov    %r15,(%rdi)
    b1ab:	49 c1 e7 04          	shl    $0x4,%r15
    b1af:	4d 01 fc             	add    %r15,%r12
    b1b2:	48 89 d0             	mov    %rdx,%rax
    b1b5:	49 89 04 24          	mov    %rax,(%r12)
    b1b9:	48 01 04 25 28 00 11 	add    %rax,0x110028
    b1c0:	00 
    b1c1:	49 83 c4 10          	add    $0x10,%r12
    b1c5:	49 8b 06             	mov    (%r14),%rax
    b1c8:	48 85 c0             	test   %rax,%rax
    b1cb:	74 60                	je     b22d <_ZN9fat_inode4readEv+0x7dd>
    b1cd:	41 83 7e 08 00       	cmpl   $0x0,0x8(%r14)
    b1d2:	7e 2b                	jle    b1ff <_ZN9fat_inode4readEv+0x7af>
    b1d4:	31 c0                	xor    %eax,%eax
    b1d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    b1dd:	00 00 00 
    b1e0:	49 8b 16             	mov    (%r14),%rdx
    b1e3:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx
    b1e7:	41 88 14 04          	mov    %dl,(%r12,%rax,1)
    b1eb:	48 ff c0             	inc    %rax
    b1ee:	49 63 56 08          	movslq 0x8(%r14),%rdx
    b1f2:	48 39 d0             	cmp    %rdx,%rax
    b1f5:	7c e9                	jl     b1e0 <_ZN9fat_inode4readEv+0x790>
    b1f7:	49 8b 06             	mov    (%r14),%rax
    b1fa:	48 85 c0             	test   %rax,%rax
    b1fd:	74 2e                	je     b22d <_ZN9fat_inode4readEv+0x7dd>
    b1ff:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
    b203:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
    b207:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    b20e:	00 01 
    b210:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b215:	48 89 3c 25 00 00 00 	mov    %rdi,0x1000000
    b21c:	01 
    b21d:	48 89 14 25 08 00 00 	mov    %rdx,0x1000008
    b224:	01 
    b225:	48 29 3c 25 28 00 11 	sub    %rdi,0x110028
    b22c:	00 
    b22d:	4d 89 26             	mov    %r12,(%r14)
    b230:	41 89 5e 0c          	mov    %ebx,0xc(%r14)
    b234:	41 8b 46 08          	mov    0x8(%r14),%eax
    b238:	41 83 c1 0c          	add    $0xc,%r9d
    b23c:	44 39 c8             	cmp    %r9d,%eax
    b23f:	44 0f 4f c8          	cmovg  %eax,%r9d
    b243:	45 89 4e 08          	mov    %r9d,0x8(%r14)
    b247:	47 88 14 1c          	mov    %r10b,(%r12,%r11,1)
    b24b:	45 0f b7 40 1e       	movzwl 0x1e(%r8),%r8d
    b250:	66 45 85 c0          	test   %r8w,%r8w
    b254:	0f 84 96 fb ff ff    	je     adf0 <_ZN9fat_inode4readEv+0x3a0>
    b25a:	4d 63 4e 0c          	movslq 0xc(%r14),%r9
    b25e:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
    b263:	4c 39 ca             	cmp    %r9,%rdx
    b266:	0f 8e 5c fb ff ff    	jle    adc8 <_ZN9fat_inode4readEv+0x378>
    b26c:	41 83 f9 02          	cmp    $0x2,%r9d
    b270:	b8 01 00 00 00       	mov    $0x1,%eax
    b275:	44 0f 4c c8          	cmovl  %eax,%r9d
    b279:	4c 39 ca             	cmp    %r9,%rdx
    b27c:	76 19                	jbe    b297 <_ZN9fat_inode4readEv+0x847>
    b27e:	66 90                	xchg   %ax,%ax
    b280:	c4 c1 72 2a c1       	vcvtsi2ss %r9d,%xmm1,%xmm0
    b285:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    b289:	c5 7a 2c c8          	vcvttss2si %xmm0,%r9d
    b28d:	4d 63 d9             	movslq %r9d,%r11
    b290:	4c 39 da             	cmp    %r11,%rdx
    b293:	7f eb                	jg     b280 <_ZN9fat_inode4readEv+0x830>
    b295:	eb 03                	jmp    b29a <_ZN9fat_inode4readEv+0x84a>
    b297:	4d 89 cb             	mov    %r9,%r11
    b29a:	49 83 c3 1f          	add    $0x1f,%r11
    b29e:	49 83 e3 f0          	and    $0xfffffffffffffff0,%r11
    b2a2:	4d 0f 44 dd          	cmove  %r13,%r11
    b2a6:	48 8b 14 25 00 00 00 	mov    0x1000000,%rdx
    b2ad:	01 
    b2ae:	b8 00 00 00 01       	mov    $0x1000000,%eax
    b2b3:	4c 39 da             	cmp    %r11,%rdx
    b2b6:	73 14                	jae    b2cc <_ZN9fat_inode4readEv+0x87c>
    b2b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    b2bf:	00 
    b2c0:	48 8b 40 08          	mov    0x8(%rax),%rax
    b2c4:	48 8b 10             	mov    (%rax),%rdx
    b2c7:	4c 39 da             	cmp    %r11,%rdx
    b2ca:	72 f4                	jb     b2c0 <_ZN9fat_inode4readEv+0x870>
    b2cc:	4c 8b 50 08          	mov    0x8(%rax),%r10
    b2d0:	48 89 d7             	mov    %rdx,%rdi
    b2d3:	4c 29 df             	sub    %r11,%rdi
    b2d6:	48 83 ff 10          	cmp    $0x10,%rdi
    b2da:	73 0e                	jae    b2ea <_ZN9fat_inode4readEv+0x89a>
    b2dc:	c4 c1 78 10 02       	vmovups (%r10),%xmm0
    b2e1:	c5 f8 11 00          	vmovups %xmm0,(%rax)
    b2e5:	49 89 d3             	mov    %rdx,%r11
    b2e8:	eb 0a                	jmp    b2f4 <_ZN9fat_inode4readEv+0x8a4>
    b2ea:	48 89 38             	mov    %rdi,(%rax)
    b2ed:	48 c1 e7 04          	shl    $0x4,%rdi
    b2f1:	49 01 fa             	add    %rdi,%r10
    b2f4:	4d 89 1a             	mov    %r11,(%r10)
    b2f7:	4c 01 1c 25 28 00 11 	add    %r11,0x110028
    b2fe:	00 
    b2ff:	49 83 c2 10          	add    $0x10,%r10
    b303:	49 8b 06             	mov    (%r14),%rax
    b306:	48 85 c0             	test   %rax,%rax
    b309:	74 62                	je     b36d <_ZN9fat_inode4readEv+0x91d>
    b30b:	41 83 7e 08 00       	cmpl   $0x0,0x8(%r14)
    b310:	7e 2d                	jle    b33f <_ZN9fat_inode4readEv+0x8ef>
    b312:	31 c0                	xor    %eax,%eax
    b314:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    b31b:	00 00 00 00 00 
    b320:	49 8b 16             	mov    (%r14),%rdx
    b323:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx
    b327:	41 88 14 02          	mov    %dl,(%r10,%rax,1)
    b32b:	48 ff c0             	inc    %rax
    b32e:	49 63 56 08          	movslq 0x8(%r14),%rdx
    b332:	48 39 d0             	cmp    %rdx,%rax
    b335:	7c e9                	jl     b320 <_ZN9fat_inode4readEv+0x8d0>
    b337:	49 8b 06             	mov    (%r14),%rax
    b33a:	48 85 c0             	test   %rax,%rax
    b33d:	74 2e                	je     b36d <_ZN9fat_inode4readEv+0x91d>
    b33f:	48 8d 50 f0          	lea    -0x10(%rax),%rdx
    b343:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
    b347:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    b34e:	00 01 
    b350:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b355:	48 89 3c 25 00 00 00 	mov    %rdi,0x1000000
    b35c:	01 
    b35d:	48 89 14 25 08 00 00 	mov    %rdx,0x1000008
    b364:	01 
    b365:	48 29 3c 25 28 00 11 	sub    %rdi,0x110028
    b36c:	00 
    b36d:	4d 89 16             	mov    %r10,(%r14)
    b370:	45 89 4e 0c          	mov    %r9d,0xc(%r14)
    b374:	e9 52 fa ff ff       	jmp    adcb <_ZN9fat_inode4readEv+0x37b>
    b379:	4d 89 08             	mov    %r9,(%r8)
    b37c:	49 c1 e1 04          	shl    $0x4,%r9
    b380:	4c 01 ca             	add    %r9,%rdx
    b383:	48 89 f7             	mov    %rsi,%rdi
    b386:	48 89 3a             	mov    %rdi,(%rdx)
    b389:	48 83 c2 10          	add    $0x10,%rdx
    b38d:	48 01 3c 25 28 00 11 	add    %rdi,0x110028
    b394:	00 
    b395:	85 c0                	test   %eax,%eax
    b397:	0f 8e 42 01 00 00    	jle    b4df <_ZN9fat_inode4readEv+0xa8f>
    b39d:	31 f6                	xor    %esi,%esi
    b39f:	83 f8 10             	cmp    $0x10,%eax
    b3a2:	0f 82 a5 00 00 00    	jb     b44d <_ZN9fat_inode4readEv+0x9fd>
    b3a8:	48 89 d7             	mov    %rdx,%rdi
    b3ab:	4c 29 d7             	sub    %r10,%rdi
    b3ae:	48 81 ff 80 00 00 00 	cmp    $0x80,%rdi
    b3b5:	0f 82 92 00 00 00    	jb     b44d <_ZN9fat_inode4readEv+0x9fd>
    b3bb:	3d 80 00 00 00       	cmp    $0x80,%eax
    b3c0:	73 04                	jae    b3c6 <_ZN9fat_inode4readEv+0x976>
    b3c2:	31 f6                	xor    %esi,%esi
    b3c4:	eb 53                	jmp    b419 <_ZN9fat_inode4readEv+0x9c9>
    b3c6:	48 89 ce             	mov    %rcx,%rsi
    b3c9:	48 83 e6 80          	and    $0xffffffffffffff80,%rsi
    b3cd:	31 ff                	xor    %edi,%edi
    b3cf:	90                   	nop
    b3d0:	c4 c1 7c 10 04 3a    	vmovups (%r10,%rdi,1),%ymm0
    b3d6:	c4 c1 7c 10 4c 3a 20 	vmovups 0x20(%r10,%rdi,1),%ymm1
    b3dd:	c4 c1 7c 10 54 3a 40 	vmovups 0x40(%r10,%rdi,1),%ymm2
    b3e4:	c4 c1 7c 10 5c 3a 60 	vmovups 0x60(%r10,%rdi,1),%ymm3
    b3eb:	c5 fc 11 04 3a       	vmovups %ymm0,(%rdx,%rdi,1)
    b3f0:	c5 fc 11 4c 3a 20    	vmovups %ymm1,0x20(%rdx,%rdi,1)
    b3f6:	c5 fc 11 54 3a 40    	vmovups %ymm2,0x40(%rdx,%rdi,1)
    b3fc:	c5 fc 11 5c 3a 60    	vmovups %ymm3,0x60(%rdx,%rdi,1)
    b402:	48 83 ef 80          	sub    $0xffffffffffffff80,%rdi
    b406:	48 39 fe             	cmp    %rdi,%rsi
    b409:	75 c5                	jne    b3d0 <_ZN9fat_inode4readEv+0x980>
    b40b:	48 39 ce             	cmp    %rcx,%rsi
    b40e:	0f 84 cb 00 00 00    	je     b4df <_ZN9fat_inode4readEv+0xa8f>
    b414:	f6 c1 70             	test   $0x70,%cl
    b417:	74 34                	je     b44d <_ZN9fat_inode4readEv+0x9fd>
    b419:	48 89 f7             	mov    %rsi,%rdi
    b41c:	48 89 ce             	mov    %rcx,%rsi
    b41f:	48 83 e6 f0          	and    $0xfffffffffffffff0,%rsi
    b423:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    b42a:	84 00 00 00 00 00 
    b430:	c4 c1 78 10 04 3a    	vmovups (%r10,%rdi,1),%xmm0
    b436:	c5 f8 11 04 3a       	vmovups %xmm0,(%rdx,%rdi,1)
    b43b:	48 83 c7 10          	add    $0x10,%rdi
    b43f:	48 39 fe             	cmp    %rdi,%rsi
    b442:	75 ec                	jne    b430 <_ZN9fat_inode4readEv+0x9e0>
    b444:	48 39 ce             	cmp    %rcx,%rsi
    b447:	0f 84 92 00 00 00    	je     b4df <_ZN9fat_inode4readEv+0xa8f>
    b44d:	48 89 f7             	mov    %rsi,%rdi
    b450:	48 f7 d7             	not    %rdi
    b453:	48 01 cf             	add    %rcx,%rdi
    b456:	49 89 c8             	mov    %rcx,%r8
    b459:	49 83 e0 07          	and    $0x7,%r8
    b45d:	74 12                	je     b471 <_ZN9fat_inode4readEv+0xa21>
    b45f:	90                   	nop
    b460:	45 0f b6 0c 32       	movzbl (%r10,%rsi,1),%r9d
    b465:	44 88 0c 32          	mov    %r9b,(%rdx,%rsi,1)
    b469:	48 ff c6             	inc    %rsi
    b46c:	49 ff c8             	dec    %r8
    b46f:	75 ef                	jne    b460 <_ZN9fat_inode4readEv+0xa10>
    b471:	48 83 ff 07          	cmp    $0x7,%rdi
    b475:	72 68                	jb     b4df <_ZN9fat_inode4readEv+0xa8f>
    b477:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    b47e:	00 00 
    b480:	41 0f b6 3c 32       	movzbl (%r10,%rsi,1),%edi
    b485:	40 88 3c 32          	mov    %dil,(%rdx,%rsi,1)
    b489:	41 0f b6 7c 32 01    	movzbl 0x1(%r10,%rsi,1),%edi
    b48f:	40 88 7c 32 01       	mov    %dil,0x1(%rdx,%rsi,1)
    b494:	41 0f b6 7c 32 02    	movzbl 0x2(%r10,%rsi,1),%edi
    b49a:	40 88 7c 32 02       	mov    %dil,0x2(%rdx,%rsi,1)
    b49f:	41 0f b6 7c 32 03    	movzbl 0x3(%r10,%rsi,1),%edi
    b4a5:	40 88 7c 32 03       	mov    %dil,0x3(%rdx,%rsi,1)
    b4aa:	41 0f b6 7c 32 04    	movzbl 0x4(%r10,%rsi,1),%edi
    b4b0:	40 88 7c 32 04       	mov    %dil,0x4(%rdx,%rsi,1)
    b4b5:	41 0f b6 7c 32 05    	movzbl 0x5(%r10,%rsi,1),%edi
    b4bb:	40 88 7c 32 05       	mov    %dil,0x5(%rdx,%rsi,1)
    b4c0:	41 0f b6 7c 32 06    	movzbl 0x6(%r10,%rsi,1),%edi
    b4c6:	40 88 7c 32 06       	mov    %dil,0x6(%rdx,%rsi,1)
    b4cb:	41 0f b6 7c 32 07    	movzbl 0x7(%r10,%rsi,1),%edi
    b4d1:	40 88 7c 32 07       	mov    %dil,0x7(%rdx,%rsi,1)
    b4d6:	48 83 c6 08          	add    $0x8,%rsi
    b4da:	48 39 f1             	cmp    %rsi,%rcx
    b4dd:	75 a1                	jne    b480 <_ZN9fat_inode4readEv+0xa30>
    b4df:	49 8b 4c 24 18       	mov    0x18(%r12),%rcx
    b4e4:	48 85 c9             	test   %rcx,%rcx
    b4e7:	74 2e                	je     b517 <_ZN9fat_inode4readEv+0xac7>
    b4e9:	48 8d 71 f0          	lea    -0x10(%rcx),%rsi
    b4ed:	48 8b 79 f0          	mov    -0x10(%rcx),%rdi
    b4f1:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    b4f8:	00 01 
    b4fa:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
    b4ff:	48 89 3c 25 00 00 00 	mov    %rdi,0x1000000
    b506:	01 
    b507:	48 89 34 25 08 00 00 	mov    %rsi,0x1000008
    b50e:	01 
    b50f:	48 29 3c 25 28 00 11 	sub    %rdi,0x110028
    b516:	00 
    b517:	49 89 54 24 18       	mov    %rdx,0x18(%r12)
    b51c:	41 89 44 24 24       	mov    %eax,0x24(%r12)
    b521:	41 89 44 24 20       	mov    %eax,0x20(%r12)
    b526:	4d 85 d2             	test   %r10,%r10
    b529:	74 2d                	je     b558 <_ZN9fat_inode4readEv+0xb08>
    b52b:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
    b530:	48 8b 01             	mov    (%rcx),%rax
    b533:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    b53a:	00 01 
    b53c:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    b540:	48 89 04 25 00 00 00 	mov    %rax,0x1000000
    b547:	01 
    b548:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    b54f:	01 
    b550:	48 29 04 25 28 00 11 	sub    %rax,0x110028
    b557:	00 
    b558:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
    b55d:	80 48 15 02          	orb    $0x2,0x15(%rax)
    b561:	48 83 c4 78          	add    $0x78,%rsp
    b565:	5b                   	pop    %rbx
    b566:	41 5c                	pop    %r12
    b568:	41 5d                	pop    %r13
    b56a:	41 5e                	pop    %r14
    b56c:	41 5f                	pop    %r15
    b56e:	5d                   	pop    %rbp
    b56f:	c5 f8 77             	vzeroupper 
    b572:	c3                   	ret    
    b573:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    b57a:	00 00 00 
    b57d:	0f 1f 00             	nopl   (%rax)

000000000000b580 <_ZN6vectorIcED2Ev>:
    b580:	48 8b 07             	mov    (%rdi),%rax
    b583:	48 85 c0             	test   %rax,%rax
    b586:	74 2e                	je     b5b6 <_ZN6vectorIcED2Ev+0x36>
    b588:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b58c:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b590:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    b597:	00 01 
    b599:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b59e:	48 89 14 25 00 00 00 	mov    %rdx,0x1000000
    b5a5:	01 
    b5a6:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    b5ad:	01 
    b5ae:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b5b5:	00 
    b5b6:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    b5ba:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    b5be:	c3                   	ret    
    b5bf:	90                   	nop

000000000000b5c0 <_ZN6vectorIP9fat_inodeE2atEi>:
    b5c0:	8b 4f 0c             	mov    0xc(%rdi),%ecx
    b5c3:	39 f1                	cmp    %esi,%ecx
    b5c5:	7e 08                	jle    b5cf <_ZN6vectorIP9fat_inodeE2atEi+0xf>
    b5c7:	48 8b 0f             	mov    (%rdi),%rcx
    b5ca:	e9 b0 01 00 00       	jmp    b77f <_ZN6vectorIP9fat_inodeE2atEi+0x1bf>
    b5cf:	83 f9 02             	cmp    $0x2,%ecx
    b5d2:	b8 01 00 00 00       	mov    $0x1,%eax
    b5d7:	0f 4d c1             	cmovge %ecx,%eax
    b5da:	39 f0                	cmp    %esi,%eax
    b5dc:	7f 12                	jg     b5f0 <_ZN6vectorIP9fat_inodeE2atEi+0x30>
    b5de:	66 90                	xchg   %ax,%ax
    b5e0:	c5 f2 2a c0          	vcvtsi2ss %eax,%xmm1,%xmm0
    b5e4:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    b5e8:	c5 fa 2c c0          	vcvttss2si %xmm0,%eax
    b5ec:	39 f0                	cmp    %esi,%eax
    b5ee:	7e f0                	jle    b5e0 <_ZN6vectorIP9fat_inodeE2atEi+0x20>
    b5f0:	89 c1                	mov    %eax,%ecx
    b5f2:	48 8d 14 cd 1f 00 00 	lea    0x1f(,%rcx,8),%rdx
    b5f9:	00 
    b5fa:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
    b5fe:	85 c0                	test   %eax,%eax
    b600:	b9 10 00 00 00       	mov    $0x10,%ecx
    b605:	48 0f 48 d1          	cmovs  %rcx,%rdx
    b609:	48 85 d2             	test   %rdx,%rdx
    b60c:	48 0f 44 d1          	cmove  %rcx,%rdx
    b610:	4c 8b 04 25 00 00 00 	mov    0x1000000,%r8
    b617:	01 
    b618:	41 b9 00 00 00 01    	mov    $0x1000000,%r9d
    b61e:	49 39 d0             	cmp    %rdx,%r8
    b621:	73 19                	jae    b63c <_ZN6vectorIP9fat_inodeE2atEi+0x7c>
    b623:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    b62a:	84 00 00 00 00 00 
    b630:	4d 8b 49 08          	mov    0x8(%r9),%r9
    b634:	4d 8b 01             	mov    (%r9),%r8
    b637:	49 39 d0             	cmp    %rdx,%r8
    b63a:	72 f4                	jb     b630 <_ZN6vectorIP9fat_inodeE2atEi+0x70>
    b63c:	49 8b 49 08          	mov    0x8(%r9),%rcx
    b640:	4d 89 c2             	mov    %r8,%r10
    b643:	49 29 d2             	sub    %rdx,%r10
    b646:	49 83 fa 0f          	cmp    $0xf,%r10
    b64a:	77 0b                	ja     b657 <_ZN6vectorIP9fat_inodeE2atEi+0x97>
    b64c:	c5 f8 10 01          	vmovups (%rcx),%xmm0
    b650:	c4 c1 78 11 01       	vmovups %xmm0,(%r9)
    b655:	eb 0d                	jmp    b664 <_ZN6vectorIP9fat_inodeE2atEi+0xa4>
    b657:	4d 89 11             	mov    %r10,(%r9)
    b65a:	49 c1 e2 04          	shl    $0x4,%r10
    b65e:	4c 01 d1             	add    %r10,%rcx
    b661:	49 89 d0             	mov    %rdx,%r8
    b664:	4c 89 01             	mov    %r8,(%rcx)
    b667:	4c 01 04 25 28 00 11 	add    %r8,0x110028
    b66e:	00 
    b66f:	48 83 c1 10          	add    $0x10,%rcx
    b673:	48 8b 17             	mov    (%rdi),%rdx
    b676:	48 85 d2             	test   %rdx,%rdx
    b679:	0f 84 fa 00 00 00    	je     b779 <_ZN6vectorIP9fat_inodeE2atEi+0x1b9>
    b67f:	44 8b 4f 08          	mov    0x8(%rdi),%r9d
    b683:	45 85 c9             	test   %r9d,%r9d
    b686:	0f 8e bf 00 00 00    	jle    b74b <_ZN6vectorIP9fat_inodeE2atEi+0x18b>
    b68c:	44 89 ca             	mov    %r9d,%edx
    b68f:	83 e2 07             	and    $0x7,%edx
    b692:	41 83 f9 08          	cmp    $0x8,%r9d
    b696:	73 08                	jae    b6a0 <_ZN6vectorIP9fat_inodeE2atEi+0xe0>
    b698:	45 31 c0             	xor    %r8d,%r8d
    b69b:	e9 7f 00 00 00       	jmp    b71f <_ZN6vectorIP9fat_inodeE2atEi+0x15f>
    b6a0:	41 83 e1 f8          	and    $0xfffffff8,%r9d
    b6a4:	45 31 c0             	xor    %r8d,%r8d
    b6a7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    b6ae:	00 00 
    b6b0:	4c 8b 17             	mov    (%rdi),%r10
    b6b3:	4f 8b 14 c2          	mov    (%r10,%r8,8),%r10
    b6b7:	4e 89 14 c1          	mov    %r10,(%rcx,%r8,8)
    b6bb:	4c 8b 17             	mov    (%rdi),%r10
    b6be:	4f 8b 54 c2 08       	mov    0x8(%r10,%r8,8),%r10
    b6c3:	4e 89 54 c1 08       	mov    %r10,0x8(%rcx,%r8,8)
    b6c8:	4c 8b 17             	mov    (%rdi),%r10
    b6cb:	4f 8b 54 c2 10       	mov    0x10(%r10,%r8,8),%r10
    b6d0:	4e 89 54 c1 10       	mov    %r10,0x10(%rcx,%r8,8)
    b6d5:	4c 8b 17             	mov    (%rdi),%r10
    b6d8:	4f 8b 54 c2 18       	mov    0x18(%r10,%r8,8),%r10
    b6dd:	4e 89 54 c1 18       	mov    %r10,0x18(%rcx,%r8,8)
    b6e2:	4c 8b 17             	mov    (%rdi),%r10
    b6e5:	4f 8b 54 c2 20       	mov    0x20(%r10,%r8,8),%r10
    b6ea:	4e 89 54 c1 20       	mov    %r10,0x20(%rcx,%r8,8)
    b6ef:	4c 8b 17             	mov    (%rdi),%r10
    b6f2:	4f 8b 54 c2 28       	mov    0x28(%r10,%r8,8),%r10
    b6f7:	4e 89 54 c1 28       	mov    %r10,0x28(%rcx,%r8,8)
    b6fc:	4c 8b 17             	mov    (%rdi),%r10
    b6ff:	4f 8b 54 c2 30       	mov    0x30(%r10,%r8,8),%r10
    b704:	4e 89 54 c1 30       	mov    %r10,0x30(%rcx,%r8,8)
    b709:	4c 8b 17             	mov    (%rdi),%r10
    b70c:	4f 8b 54 c2 38       	mov    0x38(%r10,%r8,8),%r10
    b711:	4e 89 54 c1 38       	mov    %r10,0x38(%rcx,%r8,8)
    b716:	49 83 c0 08          	add    $0x8,%r8
    b71a:	4d 39 c1             	cmp    %r8,%r9
    b71d:	75 91                	jne    b6b0 <_ZN6vectorIP9fat_inodeE2atEi+0xf0>
    b71f:	48 85 d2             	test   %rdx,%rdx
    b722:	74 1f                	je     b743 <_ZN6vectorIP9fat_inodeE2atEi+0x183>
    b724:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    b72b:	00 00 00 00 00 
    b730:	4c 8b 0f             	mov    (%rdi),%r9
    b733:	4f 8b 0c c1          	mov    (%r9,%r8,8),%r9
    b737:	4e 89 0c c1          	mov    %r9,(%rcx,%r8,8)
    b73b:	49 ff c0             	inc    %r8
    b73e:	48 ff ca             	dec    %rdx
    b741:	75 ed                	jne    b730 <_ZN6vectorIP9fat_inodeE2atEi+0x170>
    b743:	48 8b 17             	mov    (%rdi),%rdx
    b746:	48 85 d2             	test   %rdx,%rdx
    b749:	74 2e                	je     b779 <_ZN6vectorIP9fat_inodeE2atEi+0x1b9>
    b74b:	4c 8d 42 f0          	lea    -0x10(%rdx),%r8
    b74f:	4c 8b 4a f0          	mov    -0x10(%rdx),%r9
    b753:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    b75a:	00 01 
    b75c:	c5 f8 11 42 f0       	vmovups %xmm0,-0x10(%rdx)
    b761:	4c 89 0c 25 00 00 00 	mov    %r9,0x1000000
    b768:	01 
    b769:	4c 89 04 25 08 00 00 	mov    %r8,0x1000008
    b770:	01 
    b771:	4c 29 0c 25 28 00 11 	sub    %r9,0x110028
    b778:	00 
    b779:	48 89 0f             	mov    %rcx,(%rdi)
    b77c:	89 47 0c             	mov    %eax,0xc(%rdi)
    b77f:	8b 47 08             	mov    0x8(%rdi),%eax
    b782:	8d 56 01             	lea    0x1(%rsi),%edx
    b785:	39 d0                	cmp    %edx,%eax
    b787:	0f 4f d0             	cmovg  %eax,%edx
    b78a:	89 57 08             	mov    %edx,0x8(%rdi)
    b78d:	48 63 c6             	movslq %esi,%rax
    b790:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
    b794:	c3                   	ret    
    b795:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    b79c:	00 00 00 
    b79f:	90                   	nop

000000000000b7a0 <_ZN4FILED1Ev>:
    b7a0:	48 8b 07             	mov    (%rdi),%rax
    b7a3:	48 85 c0             	test   %rax,%rax
    b7a6:	74 04                	je     b7ac <_ZN4FILED1Ev+0xc>
    b7a8:	66 ff 48 16          	decw   0x16(%rax)
    b7ac:	c3                   	ret    
    b7ad:	0f 1f 00             	nopl   (%rax)

000000000000b7b0 <_Z9file_openR4FILE8rostring>:
    b7b0:	55                   	push   %rbp
    b7b1:	41 57                	push   %r15
    b7b3:	41 56                	push   %r14
    b7b5:	41 55                	push   %r13
    b7b7:	41 54                	push   %r12
    b7b9:	53                   	push   %rbx
    b7ba:	48 83 ec 18          	sub    $0x18,%rsp
    b7be:	48 89 fb             	mov    %rdi,%rbx
    b7c1:	48 8b 06             	mov    (%rsi),%rax
    b7c4:	48 85 c0             	test   %rax,%rax
    b7c7:	0f 84 0a 01 00 00    	je     b8d7 <_Z9file_openR4FILE8rostring+0x127>
    b7cd:	f6 40 14 10          	testb  $0x10,0x14(%rax)
    b7d1:	0f 84 00 01 00 00    	je     b8d7 <_Z9file_openR4FILE8rostring+0x127>
    b7d7:	83 78 20 00          	cmpl   $0x0,0x20(%rax)
    b7db:	0f 8e f6 00 00 00    	jle    b8d7 <_Z9file_openR4FILE8rostring+0x127>
    b7e1:	49 89 d7             	mov    %rdx,%r15
    b7e4:	49 89 f6             	mov    %rsi,%r14
    b7e7:	31 ed                	xor    %ebp,%ebp
    b7e9:	4c 8d 64 24 08       	lea    0x8(%rsp),%r12
    b7ee:	eb 13                	jmp    b803 <_Z9file_openR4FILE8rostring+0x53>
    b7f0:	48 ff c5             	inc    %rbp
    b7f3:	49 8b 06             	mov    (%r14),%rax
    b7f6:	48 63 48 20          	movslq 0x20(%rax),%rcx
    b7fa:	48 39 cd             	cmp    %rcx,%rbp
    b7fd:	0f 8d d4 00 00 00    	jge    b8d7 <_Z9file_openR4FILE8rostring+0x127>
    b803:	83 78 20 00          	cmpl   $0x0,0x20(%rax)
    b807:	74 62                	je     b86b <_Z9file_openR4FILE8rostring+0xbb>
    b809:	48 8b 40 18          	mov    0x18(%rax),%rax
    b80d:	4c 8b 2c e8          	mov    (%rax,%rbp,8),%r13
    b811:	41 8b 47 08          	mov    0x8(%r15),%eax
    b815:	49 8b 0f             	mov    (%r15),%rcx
    b818:	89 04 24             	mov    %eax,(%rsp)
    b81b:	8b 04 24             	mov    (%rsp),%eax
    b81e:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    b823:	89 44 24 10          	mov    %eax,0x10(%rsp)
    b827:	4c 89 ef             	mov    %r13,%rdi
    b82a:	4c 89 e6             	mov    %r12,%rsi
    b82d:	e8 9e 23 00 00       	call   dbd0 <_ZNK4spanIcE11starts_withES0_>
    b832:	84 c0                	test   %al,%al
    b834:	74 ba                	je     b7f0 <_Z9file_openR4FILE8rostring+0x40>
    b836:	41 8b 45 08          	mov    0x8(%r13),%eax
    b83a:	3b 04 24             	cmp    (%rsp),%eax
    b83d:	75 b1                	jne    b7f0 <_Z9file_openR4FILE8rostring+0x40>
    b83f:	49 8b 06             	mov    (%r14),%rax
    b842:	83 78 20 00          	cmpl   $0x0,0x20(%rax)
    b846:	74 2e                	je     b876 <_Z9file_openR4FILE8rostring+0xc6>
    b848:	48 8b 40 18          	mov    0x18(%rax),%rax
    b84c:	4c 8b 34 e8          	mov    (%rax,%rbp,8),%r14
    b850:	4c 89 33             	mov    %r14,(%rbx)
    b853:	4d 85 f6             	test   %r14,%r14
    b856:	0f 84 82 00 00 00    	je     b8de <_Z9file_openR4FILE8rostring+0x12e>
    b85c:	4c 89 f7             	mov    %r14,%rdi
    b85f:	e8 ec f1 ff ff       	call   aa50 <_ZN9fat_inode4readEv>
    b864:	66 41 ff 46 16       	incw   0x16(%r14)
    b869:	eb 73                	jmp    b8de <_Z9file_openR4FILE8rostring+0x12e>
    b86b:	b8 00 00 00 01       	mov    $0x1000000,%eax
    b870:	48 8b 40 08          	mov    0x8(%rax),%rax
    b874:	eb fa                	jmp    b870 <_Z9file_openR4FILE8rostring+0xc0>
    b876:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    b87d:	01 
    b87e:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    b883:	48 83 f8 1f          	cmp    $0x1f,%rax
    b887:	77 14                	ja     b89d <_Z9file_openR4FILE8rostring+0xed>
    b889:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    b890:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    b894:	48 8b 01             	mov    (%rcx),%rax
    b897:	48 83 f8 20          	cmp    $0x20,%rax
    b89b:	72 f3                	jb     b890 <_Z9file_openR4FILE8rostring+0xe0>
    b89d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    b8a1:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    b8a5:	48 83 fe 0f          	cmp    $0xf,%rsi
    b8a9:	77 0a                	ja     b8b5 <_Z9file_openR4FILE8rostring+0x105>
    b8ab:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    b8af:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    b8b3:	eb 0f                	jmp    b8c4 <_Z9file_openR4FILE8rostring+0x114>
    b8b5:	48 89 31             	mov    %rsi,(%rcx)
    b8b8:	48 c1 e6 04          	shl    $0x4,%rsi
    b8bc:	48 01 f2             	add    %rsi,%rdx
    b8bf:	b8 20 00 00 00       	mov    $0x20,%eax
    b8c4:	48 89 02             	mov    %rax,(%rdx)
    b8c7:	48 01 04 25 28 00 11 	add    %rax,0x110028
    b8ce:	00 
    b8cf:	48 c7 42 10 00 00 00 	movq   $0x0,0x10(%rdx)
    b8d6:	00 
    b8d7:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
    b8de:	48 89 d8             	mov    %rbx,%rax
    b8e1:	48 83 c4 18          	add    $0x18,%rsp
    b8e5:	5b                   	pop    %rbx
    b8e6:	41 5c                	pop    %r12
    b8e8:	41 5d                	pop    %r13
    b8ea:	41 5e                	pop    %r14
    b8ec:	41 5f                	pop    %r15
    b8ee:	5d                   	pop    %rbp
    b8ef:	c3                   	ret    

000000000000b8f0 <_Z9file_open8rostring>:
    b8f0:	55                   	push   %rbp
    b8f1:	41 57                	push   %r15
    b8f3:	41 56                	push   %r14
    b8f5:	41 55                	push   %r13
    b8f7:	41 54                	push   %r12
    b8f9:	53                   	push   %rbx
    b8fa:	48 83 ec 58          	sub    $0x58,%rsp
    b8fe:	48 89 fb             	mov    %rdi,%rbx
    b901:	48 c7 44 24 48 3f 0a 	movq   $0x10a3f,0x48(%rsp)
    b908:	01 00 
    b90a:	c7 44 24 50 02 00 00 	movl   $0x2,0x50(%rsp)
    b911:	00 
    b912:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
    b917:	48 8d 54 24 48       	lea    0x48(%rsp),%rdx
    b91c:	e8 7f 03 00 00       	call   bca0 <_ZNK8rostring5splitES_>
    b921:	4c 8b 2c 25 08 01 11 	mov    0x110108,%r13
    b928:	00 
    b929:	4c 89 6c 24 20       	mov    %r13,0x20(%rsp)
    b92e:	4d 85 ed             	test   %r13,%r13
    b931:	74 05                	je     b938 <_Z9file_open8rostring+0x48>
    b933:	66 41 ff 45 16       	incw   0x16(%r13)
    b938:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
    b93d:	0f 8e 0f 03 00 00    	jle    bc52 <_Z9file_open8rostring+0x362>
    b943:	4c 8d 74 24 28       	lea    0x28(%rsp),%r14
    b948:	4c 8d 64 24 38       	lea    0x38(%rsp),%r12
    b94d:	45 31 ff             	xor    %r15d,%r15d
    b950:	eb 64                	jmp    b9b6 <_Z9file_open8rostring+0xc6>
    b952:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    b959:	1f 84 00 00 00 00 00 
    b960:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
    b965:	0f 84 4a 01 00 00    	je     bab5 <_Z9file_open8rostring+0x1c5>
    b96b:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
    b970:	4c 89 fa             	mov    %r15,%rdx
    b973:	48 c1 e2 04          	shl    $0x4,%rdx
    b977:	48 8d 04 11          	lea    (%rcx,%rdx,1),%rax
    b97b:	48 8b 0c 11          	mov    (%rcx,%rdx,1),%rcx
    b97f:	8b 40 08             	mov    0x8(%rax),%eax
    b982:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
    b987:	89 44 24 40          	mov    %eax,0x40(%rsp)
    b98b:	4c 89 f7             	mov    %r14,%rdi
    b98e:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
    b993:	4c 89 e2             	mov    %r12,%rdx
    b996:	e8 15 fe ff ff       	call   b7b0 <_Z9file_openR4FILE8rostring>
    b99b:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
    b9a0:	4c 89 6c 24 20       	mov    %r13,0x20(%rsp)
    b9a5:	49 ff c7             	inc    %r15
    b9a8:	48 63 44 24 18       	movslq 0x18(%rsp),%rax
    b9ad:	49 39 c7             	cmp    %rax,%r15
    b9b0:	0f 8d 9c 02 00 00    	jge    bc52 <_Z9file_open8rostring+0x362>
    b9b6:	4d 85 ed             	test   %r13,%r13
    b9b9:	0f 84 90 02 00 00    	je     bc4f <_Z9file_open8rostring+0x35f>
    b9bf:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
    b9c4:	74 1a                	je     b9e0 <_Z9file_open8rostring+0xf0>
    b9c6:	4c 89 f8             	mov    %r15,%rax
    b9c9:	48 c1 e0 04          	shl    $0x4,%rax
    b9cd:	48 03 44 24 10       	add    0x10(%rsp),%rax
    b9d2:	83 78 08 00          	cmpl   $0x0,0x8(%rax)
    b9d6:	75 7e                	jne    ba56 <_Z9file_open8rostring+0x166>
    b9d8:	eb cb                	jmp    b9a5 <_Z9file_open8rostring+0xb5>
    b9da:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    b9e0:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    b9e7:	01 
    b9e8:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    b9ed:	48 83 f8 1f          	cmp    $0x1f,%rax
    b9f1:	77 1a                	ja     ba0d <_Z9file_open8rostring+0x11d>
    b9f3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    b9fa:	84 00 00 00 00 00 
    ba00:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    ba04:	48 8b 01             	mov    (%rcx),%rax
    ba07:	48 83 f8 20          	cmp    $0x20,%rax
    ba0b:	72 f3                	jb     ba00 <_Z9file_open8rostring+0x110>
    ba0d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    ba11:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    ba15:	48 83 fe 0f          	cmp    $0xf,%rsi
    ba19:	77 0a                	ja     ba25 <_Z9file_open8rostring+0x135>
    ba1b:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    ba1f:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    ba23:	eb 0f                	jmp    ba34 <_Z9file_open8rostring+0x144>
    ba25:	48 89 31             	mov    %rsi,(%rcx)
    ba28:	48 c1 e6 04          	shl    $0x4,%rsi
    ba2c:	48 01 f2             	add    %rsi,%rdx
    ba2f:	b8 20 00 00 00       	mov    $0x20,%eax
    ba34:	48 89 02             	mov    %rax,(%rdx)
    ba37:	48 01 04 25 28 00 11 	add    %rax,0x110028
    ba3e:	00 
    ba3f:	48 8d 42 10          	lea    0x10(%rdx),%rax
    ba43:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    ba47:	c5 f8 11 42 10       	vmovups %xmm0,0x10(%rdx)
    ba4c:	83 78 08 00          	cmpl   $0x0,0x8(%rax)
    ba50:	0f 84 4f ff ff ff    	je     b9a5 <_Z9file_open8rostring+0xb5>
    ba56:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
    ba5b:	74 13                	je     ba70 <_Z9file_open8rostring+0x180>
    ba5d:	4c 89 fd             	mov    %r15,%rbp
    ba60:	48 c1 e5 04          	shl    $0x4,%rbp
    ba64:	48 03 6c 24 10       	add    0x10(%rsp),%rbp
    ba69:	e9 b5 00 00 00       	jmp    bb23 <_Z9file_open8rostring+0x233>
    ba6e:	66 90                	xchg   %ax,%ax
    ba70:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    ba77:	01 
    ba78:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    ba7d:	48 83 f8 1f          	cmp    $0x1f,%rax
    ba81:	77 1a                	ja     ba9d <_Z9file_open8rostring+0x1ad>
    ba83:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    ba8a:	84 00 00 00 00 00 
    ba90:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    ba94:	48 8b 01             	mov    (%rcx),%rax
    ba97:	48 83 f8 20          	cmp    $0x20,%rax
    ba9b:	72 f3                	jb     ba90 <_Z9file_open8rostring+0x1a0>
    ba9d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    baa1:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    baa5:	48 83 fe 0f          	cmp    $0xf,%rsi
    baa9:	77 51                	ja     bafc <_Z9file_open8rostring+0x20c>
    baab:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    baaf:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    bab3:	eb 56                	jmp    bb0b <_Z9file_open8rostring+0x21b>
    bab5:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    babc:	01 
    babd:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    bac2:	48 83 f8 1f          	cmp    $0x1f,%rax
    bac6:	77 15                	ja     badd <_Z9file_open8rostring+0x1ed>
    bac8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    bacf:	00 
    bad0:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    bad4:	48 8b 01             	mov    (%rcx),%rax
    bad7:	48 83 f8 20          	cmp    $0x20,%rax
    badb:	72 f3                	jb     bad0 <_Z9file_open8rostring+0x1e0>
    badd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    bae1:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    bae5:	48 83 fe 0f          	cmp    $0xf,%rsi
    bae9:	0f 87 32 01 00 00    	ja     bc21 <_Z9file_open8rostring+0x331>
    baef:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    baf3:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    baf7:	e9 34 01 00 00       	jmp    bc30 <_Z9file_open8rostring+0x340>
    bafc:	48 89 31             	mov    %rsi,(%rcx)
    baff:	48 c1 e6 04          	shl    $0x4,%rsi
    bb03:	48 01 f2             	add    %rsi,%rdx
    bb06:	b8 20 00 00 00       	mov    $0x20,%eax
    bb0b:	48 89 02             	mov    %rax,(%rdx)
    bb0e:	48 01 04 25 28 00 11 	add    %rax,0x110028
    bb15:	00 
    bb16:	48 8d 6a 10          	lea    0x10(%rdx),%rbp
    bb1a:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    bb1e:	c5 f8 11 42 10       	vmovups %xmm0,0x10(%rdx)
    bb23:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%rsp)
    bb2a:	00 
    bb2b:	8b 44 24 08          	mov    0x8(%rsp),%eax
    bb2f:	48 c7 44 24 28 d1 0b 	movq   $0x10bd1,0x28(%rsp)
    bb36:	01 00 
    bb38:	89 44 24 30          	mov    %eax,0x30(%rsp)
    bb3c:	48 89 ef             	mov    %rbp,%rdi
    bb3f:	4c 89 f6             	mov    %r14,%rsi
    bb42:	e8 89 20 00 00       	call   dbd0 <_ZNK4spanIcE11starts_withES0_>
    bb47:	84 c0                	test   %al,%al
    bb49:	74 0d                	je     bb58 <_Z9file_open8rostring+0x268>
    bb4b:	8b 45 08             	mov    0x8(%rbp),%eax
    bb4e:	3b 44 24 08          	cmp    0x8(%rsp),%eax
    bb52:	0f 84 4d fe ff ff    	je     b9a5 <_Z9file_open8rostring+0xb5>
    bb58:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
    bb5d:	74 0e                	je     bb6d <_Z9file_open8rostring+0x27d>
    bb5f:	4c 89 fd             	mov    %r15,%rbp
    bb62:	48 c1 e5 04          	shl    $0x4,%rbp
    bb66:	48 03 6c 24 10       	add    0x10(%rsp),%rbp
    bb6b:	eb 5f                	jmp    bbcc <_Z9file_open8rostring+0x2dc>
    bb6d:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    bb74:	01 
    bb75:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    bb7a:	48 83 f8 1f          	cmp    $0x1f,%rax
    bb7e:	77 0d                	ja     bb8d <_Z9file_open8rostring+0x29d>
    bb80:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    bb84:	48 8b 01             	mov    (%rcx),%rax
    bb87:	48 83 f8 20          	cmp    $0x20,%rax
    bb8b:	72 f3                	jb     bb80 <_Z9file_open8rostring+0x290>
    bb8d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    bb91:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    bb95:	48 83 fe 0f          	cmp    $0xf,%rsi
    bb99:	77 0a                	ja     bba5 <_Z9file_open8rostring+0x2b5>
    bb9b:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    bb9f:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    bba3:	eb 0f                	jmp    bbb4 <_Z9file_open8rostring+0x2c4>
    bba5:	48 89 31             	mov    %rsi,(%rcx)
    bba8:	48 c1 e6 04          	shl    $0x4,%rsi
    bbac:	48 01 f2             	add    %rsi,%rdx
    bbaf:	b8 20 00 00 00       	mov    $0x20,%eax
    bbb4:	48 89 02             	mov    %rax,(%rdx)
    bbb7:	48 01 04 25 28 00 11 	add    %rax,0x110028
    bbbe:	00 
    bbbf:	48 8d 6a 10          	lea    0x10(%rdx),%rbp
    bbc3:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    bbc7:	c5 f8 11 42 10       	vmovups %xmm0,0x10(%rdx)
    bbcc:	c7 04 24 02 00 00 00 	movl   $0x2,(%rsp)
    bbd3:	8b 04 24             	mov    (%rsp),%eax
    bbd6:	48 c7 44 24 28 d0 0b 	movq   $0x10bd0,0x28(%rsp)
    bbdd:	01 00 
    bbdf:	89 44 24 30          	mov    %eax,0x30(%rsp)
    bbe3:	48 89 ef             	mov    %rbp,%rdi
    bbe6:	4c 89 f6             	mov    %r14,%rsi
    bbe9:	e8 e2 1f 00 00       	call   dbd0 <_ZNK4spanIcE11starts_withES0_>
    bbee:	84 c0                	test   %al,%al
    bbf0:	0f 84 6a fd ff ff    	je     b960 <_Z9file_open8rostring+0x70>
    bbf6:	8b 45 08             	mov    0x8(%rbp),%eax
    bbf9:	3b 04 24             	cmp    (%rsp),%eax
    bbfc:	0f 85 5e fd ff ff    	jne    b960 <_Z9file_open8rostring+0x70>
    bc02:	4d 8b 6d 28          	mov    0x28(%r13),%r13
    bc06:	4d 85 ed             	test   %r13,%r13
    bc09:	0f 84 91 fd ff ff    	je     b9a0 <_Z9file_open8rostring+0xb0>
    bc0f:	4c 89 ef             	mov    %r13,%rdi
    bc12:	e8 39 ee ff ff       	call   aa50 <_ZN9fat_inode4readEv>
    bc17:	66 41 ff 45 16       	incw   0x16(%r13)
    bc1c:	e9 7f fd ff ff       	jmp    b9a0 <_Z9file_open8rostring+0xb0>
    bc21:	48 89 31             	mov    %rsi,(%rcx)
    bc24:	48 c1 e6 04          	shl    $0x4,%rsi
    bc28:	48 01 f2             	add    %rsi,%rdx
    bc2b:	b8 20 00 00 00       	mov    $0x20,%eax
    bc30:	48 89 02             	mov    %rax,(%rdx)
    bc33:	48 01 04 25 28 00 11 	add    %rax,0x110028
    bc3a:	00 
    bc3b:	48 8d 42 10          	lea    0x10(%rdx),%rax
    bc3f:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    bc43:	c5 f8 11 42 10       	vmovups %xmm0,0x10(%rdx)
    bc48:	31 c9                	xor    %ecx,%ecx
    bc4a:	e9 30 fd ff ff       	jmp    b97f <_Z9file_open8rostring+0x8f>
    bc4f:	45 31 ed             	xor    %r13d,%r13d
    bc52:	4c 89 2b             	mov    %r13,(%rbx)
    bc55:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    bc5a:	48 85 c0             	test   %rax,%rax
    bc5d:	74 2e                	je     bc8d <_Z9file_open8rostring+0x39d>
    bc5f:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    bc63:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    bc67:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    bc6e:	00 01 
    bc70:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    bc75:	48 89 14 25 00 00 00 	mov    %rdx,0x1000000
    bc7c:	01 
    bc7d:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    bc84:	01 
    bc85:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    bc8c:	00 
    bc8d:	48 89 d8             	mov    %rbx,%rax
    bc90:	48 83 c4 58          	add    $0x58,%rsp
    bc94:	5b                   	pop    %rbx
    bc95:	41 5c                	pop    %r12
    bc97:	41 5d                	pop    %r13
    bc99:	41 5e                	pop    %r14
    bc9b:	41 5f                	pop    %r15
    bc9d:	5d                   	pop    %rbp
    bc9e:	c3                   	ret    
    bc9f:	90                   	nop

000000000000bca0 <_ZNK8rostring5splitES_>:
    bca0:	55                   	push   %rbp
    bca1:	41 57                	push   %r15
    bca3:	41 56                	push   %r14
    bca5:	41 55                	push   %r13
    bca7:	41 54                	push   %r12
    bca9:	53                   	push   %rbx
    bcaa:	48 83 ec 48          	sub    $0x48,%rsp
    bcae:	49 89 fe             	mov    %rdi,%r14
    bcb1:	8b 46 08             	mov    0x8(%rsi),%eax
    bcb4:	48 8b 0e             	mov    (%rsi),%rcx
    bcb7:	89 44 24 18          	mov    %eax,0x18(%rsp)
    bcbb:	8b 44 24 18          	mov    0x18(%rsp),%eax
    bcbf:	89 44 24 20          	mov    %eax,0x20(%rsp)
    bcc3:	8b 44 24 20          	mov    0x20(%rsp),%eax
    bcc7:	48 89 0c 24          	mov    %rcx,(%rsp)
    bccb:	89 44 24 08          	mov    %eax,0x8(%rsp)
    bccf:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
    bcd6:	00 
    bcd7:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    bcdb:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    bcdf:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    bce4:	0f 8e 72 02 00 00    	jle    bf5c <_ZNK8rostring5splitES_+0x2bc>
    bcea:	48 89 d3             	mov    %rdx,%rbx
    bced:	4c 8d 7c 24 38       	lea    0x38(%rsp),%r15
    bcf2:	49 89 e4             	mov    %rsp,%r12
    bcf5:	4c 8d 6c 24 28       	lea    0x28(%rsp),%r13
    bcfa:	eb 32                	jmp    bd2e <_ZNK8rostring5splitES_+0x8e>
    bcfc:	48 89 31             	mov    %rsi,(%rcx)
    bcff:	48 c1 e6 04          	shl    $0x4,%rsi
    bd03:	48 01 f2             	add    %rsi,%rdx
    bd06:	b8 20 00 00 00       	mov    $0x20,%eax
    bd0b:	48 89 02             	mov    %rax,(%rdx)
    bd0e:	48 01 04 25 28 00 11 	add    %rax,0x110028
    bd15:	00 
    bd16:	c6 42 10 00          	movb   $0x0,0x10(%rdx)
    bd1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    bd20:	8b 44 24 10          	mov    0x10(%rsp),%eax
    bd24:	3b 44 24 08          	cmp    0x8(%rsp),%eax
    bd28:	0f 8d 2e 02 00 00    	jge    bf5c <_ZNK8rostring5splitES_+0x2bc>
    bd2e:	8b 43 08             	mov    0x8(%rbx),%eax
    bd31:	48 8b 0b             	mov    (%rbx),%rcx
    bd34:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
    bd39:	89 44 24 30          	mov    %eax,0x30(%rsp)
    bd3d:	4c 89 ff             	mov    %r15,%rdi
    bd40:	4c 89 e6             	mov    %r12,%rsi
    bd43:	4c 89 ea             	mov    %r13,%rdx
    bd46:	e8 d5 1c 00 00       	call   da20 <_ZN13istringstream14read_until_anyE8rostring>
    bd4b:	41 8b 6e 08          	mov    0x8(%r14),%ebp
    bd4f:	41 8b 76 0c          	mov    0xc(%r14),%esi
    bd53:	89 e8                	mov    %ebp,%eax
    bd55:	39 ee                	cmp    %ebp,%esi
    bd57:	7f 33                	jg     bd8c <_ZNK8rostring5splitES_+0xec>
    bd59:	83 fe 02             	cmp    $0x2,%esi
    bd5c:	b8 01 00 00 00       	mov    $0x1,%eax
    bd61:	0f 4c f0             	cmovl  %eax,%esi
    bd64:	39 ee                	cmp    %ebp,%esi
    bd66:	7f 18                	jg     bd80 <_ZNK8rostring5splitES_+0xe0>
    bd68:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    bd6f:	00 
    bd70:	c5 f2 2a c6          	vcvtsi2ss %esi,%xmm1,%xmm0
    bd74:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    bd78:	c5 fa 2c f0          	vcvttss2si %xmm0,%esi
    bd7c:	39 f5                	cmp    %esi,%ebp
    bd7e:	7d f0                	jge    bd70 <_ZNK8rostring5splitES_+0xd0>
    bd80:	4c 89 f7             	mov    %r14,%rdi
    bd83:	e8 e8 42 00 00       	call   10070 <_ZN6vectorI8rostringE7reserveEi>
    bd88:	41 8b 46 08          	mov    0x8(%r14),%eax
    bd8c:	48 63 cd             	movslq %ebp,%rcx
    bd8f:	ff c5                	inc    %ebp
    bd91:	39 e8                	cmp    %ebp,%eax
    bd93:	0f 4f e8             	cmovg  %eax,%ebp
    bd96:	41 89 6e 08          	mov    %ebp,0x8(%r14)
    bd9a:	49 8b 06             	mov    (%r14),%rax
    bd9d:	48 c1 e1 04          	shl    $0x4,%rcx
    bda1:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
    bda6:	48 89 14 08          	mov    %rdx,(%rax,%rcx,1)
    bdaa:	8b 54 24 40          	mov    0x40(%rsp),%edx
    bdae:	89 54 08 08          	mov    %edx,0x8(%rax,%rcx,1)
    bdb2:	8b 4c 24 10          	mov    0x10(%rsp),%ecx
    bdb6:	8d 41 01             	lea    0x1(%rcx),%eax
    bdb9:	89 44 24 10          	mov    %eax,0x10(%rsp)
    bdbd:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    bdc2:	74 1c                	je     bde0 <_ZNK8rostring5splitES_+0x140>
    bdc4:	48 63 c1             	movslq %ecx,%rax
    bdc7:	48 8b 14 24          	mov    (%rsp),%rdx
    bdcb:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
    bdcf:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
    bdd3:	83 7b 08 00          	cmpl   $0x0,0x8(%rbx)
    bdd7:	7f 7a                	jg     be53 <_ZNK8rostring5splitES_+0x1b3>
    bdd9:	e9 42 ff ff ff       	jmp    bd20 <_ZNK8rostring5splitES_+0x80>
    bdde:	66 90                	xchg   %ax,%ax
    bde0:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    bde7:	01 
    bde8:	ba 00 00 00 01       	mov    $0x1000000,%edx
    bded:	48 83 f8 1f          	cmp    $0x1f,%rax
    bdf1:	77 1a                	ja     be0d <_ZNK8rostring5splitES_+0x16d>
    bdf3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    bdfa:	84 00 00 00 00 00 
    be00:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    be04:	48 8b 02             	mov    (%rdx),%rax
    be07:	48 83 f8 20          	cmp    $0x20,%rax
    be0b:	72 f3                	jb     be00 <_ZNK8rostring5splitES_+0x160>
    be0d:	48 8b 72 08          	mov    0x8(%rdx),%rsi
    be11:	48 8d 78 e0          	lea    -0x20(%rax),%rdi
    be15:	48 83 ff 0f          	cmp    $0xf,%rdi
    be19:	77 0a                	ja     be25 <_ZNK8rostring5splitES_+0x185>
    be1b:	c5 f8 10 06          	vmovups (%rsi),%xmm0
    be1f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    be23:	eb 0f                	jmp    be34 <_ZNK8rostring5splitES_+0x194>
    be25:	48 89 3a             	mov    %rdi,(%rdx)
    be28:	48 c1 e7 04          	shl    $0x4,%rdi
    be2c:	48 01 fe             	add    %rdi,%rsi
    be2f:	b8 20 00 00 00       	mov    $0x20,%eax
    be34:	48 89 06             	mov    %rax,(%rsi)
    be37:	48 01 04 25 28 00 11 	add    %rax,0x110028
    be3e:	00 
    be3f:	c6 46 10 00          	movb   $0x0,0x10(%rsi)
    be43:	31 c0                	xor    %eax,%eax
    be45:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
    be49:	83 7b 08 00          	cmpl   $0x0,0x8(%rbx)
    be4d:	0f 8e cd fe ff ff    	jle    bd20 <_ZNK8rostring5splitES_+0x80>
    be53:	31 c9                	xor    %ecx,%ecx
    be55:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    be5c:	00 00 00 00 
    be60:	83 7b 08 00          	cmpl   $0x0,0x8(%rbx)
    be64:	74 1a                	je     be80 <_ZNK8rostring5splitES_+0x1e0>
    be66:	48 8b 13             	mov    (%rbx),%rdx
    be69:	0f b6 14 0a          	movzbl (%rdx,%rcx,1),%edx
    be6d:	38 c2                	cmp    %al,%dl
    be6f:	75 78                	jne    bee9 <_ZNK8rostring5splitES_+0x249>
    be71:	e9 8a 00 00 00       	jmp    bf00 <_ZNK8rostring5splitES_+0x260>
    be76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    be7d:	00 00 00 
    be80:	48 8b 14 25 00 00 00 	mov    0x1000000,%rdx
    be87:	01 
    be88:	be 00 00 00 01       	mov    $0x1000000,%esi
    be8d:	48 83 fa 1f          	cmp    $0x1f,%rdx
    be91:	77 1a                	ja     bead <_ZNK8rostring5splitES_+0x20d>
    be93:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    be9a:	84 00 00 00 00 00 
    bea0:	48 8b 76 08          	mov    0x8(%rsi),%rsi
    bea4:	48 8b 16             	mov    (%rsi),%rdx
    bea7:	48 83 fa 20          	cmp    $0x20,%rdx
    beab:	72 f3                	jb     bea0 <_ZNK8rostring5splitES_+0x200>
    bead:	48 8b 7e 08          	mov    0x8(%rsi),%rdi
    beb1:	4c 8d 42 e0          	lea    -0x20(%rdx),%r8
    beb5:	49 83 f8 0f          	cmp    $0xf,%r8
    beb9:	77 0a                	ja     bec5 <_ZNK8rostring5splitES_+0x225>
    bebb:	c5 f8 10 07          	vmovups (%rdi),%xmm0
    bebf:	c5 f8 11 06          	vmovups %xmm0,(%rsi)
    bec3:	eb 0f                	jmp    bed4 <_ZNK8rostring5splitES_+0x234>
    bec5:	4c 89 06             	mov    %r8,(%rsi)
    bec8:	49 c1 e0 04          	shl    $0x4,%r8
    becc:	4c 01 c7             	add    %r8,%rdi
    becf:	ba 20 00 00 00       	mov    $0x20,%edx
    bed4:	48 89 17             	mov    %rdx,(%rdi)
    bed7:	48 01 14 25 28 00 11 	add    %rdx,0x110028
    bede:	00 
    bedf:	c6 47 10 00          	movb   $0x0,0x10(%rdi)
    bee3:	31 d2                	xor    %edx,%edx
    bee5:	38 c2                	cmp    %al,%dl
    bee7:	74 17                	je     bf00 <_ZNK8rostring5splitES_+0x260>
    bee9:	48 ff c1             	inc    %rcx
    beec:	48 63 53 08          	movslq 0x8(%rbx),%rdx
    bef0:	48 39 d1             	cmp    %rdx,%rcx
    bef3:	0f 8c 67 ff ff ff    	jl     be60 <_ZNK8rostring5splitES_+0x1c0>
    bef9:	e9 22 fe ff ff       	jmp    bd20 <_ZNK8rostring5splitES_+0x80>
    befe:	66 90                	xchg   %ax,%ax
    bf00:	85 c9                	test   %ecx,%ecx
    bf02:	0f 88 18 fe ff ff    	js     bd20 <_ZNK8rostring5splitES_+0x80>
    bf08:	ff 44 24 10          	incl   0x10(%rsp)
    bf0c:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    bf11:	0f 85 09 fe ff ff    	jne    bd20 <_ZNK8rostring5splitES_+0x80>
    bf17:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    bf1e:	01 
    bf1f:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    bf24:	48 83 f8 1f          	cmp    $0x1f,%rax
    bf28:	77 13                	ja     bf3d <_ZNK8rostring5splitES_+0x29d>
    bf2a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    bf30:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    bf34:	48 8b 01             	mov    (%rcx),%rax
    bf37:	48 83 f8 20          	cmp    $0x20,%rax
    bf3b:	72 f3                	jb     bf30 <_ZNK8rostring5splitES_+0x290>
    bf3d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    bf41:	48 8d 70 e0          	lea    -0x20(%rax),%rsi
    bf45:	48 83 fe 0f          	cmp    $0xf,%rsi
    bf49:	0f 87 ad fd ff ff    	ja     bcfc <_ZNK8rostring5splitES_+0x5c>
    bf4f:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    bf53:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    bf57:	e9 af fd ff ff       	jmp    bd0b <_ZNK8rostring5splitES_+0x6b>
    bf5c:	4c 89 f0             	mov    %r14,%rax
    bf5f:	48 83 c4 48          	add    $0x48,%rsp
    bf63:	5b                   	pop    %rbx
    bf64:	41 5c                	pop    %r12
    bf66:	41 5d                	pop    %r13
    bf68:	41 5e                	pop    %r14
    bf6a:	41 5f                	pop    %r15
    bf6c:	5d                   	pop    %rbp
    bf6d:	c3                   	ret    
    bf6e:	66 90                	xchg   %ax,%ax

000000000000bf70 <_ZN7console7putcharEc>:
    bf70:	55                   	push   %rbp
    bf71:	41 57                	push   %r15
    bf73:	41 56                	push   %r14
    bf75:	41 55                	push   %r13
    bf77:	41 54                	push   %r12
    bf79:	53                   	push   %rbx
    bf7a:	85 f6                	test   %esi,%esi
    bf7c:	0f 84 8d 06 00 00    	je     c60f <_ZN7console7putcharEc+0x69f>
    bf82:	83 fe 0a             	cmp    $0xa,%esi
    bf85:	74 15                	je     bf9c <_ZN7console7putcharEc+0x2c>
    bf87:	83 fe 0d             	cmp    $0xd,%esi
    bf8a:	0f 85 17 02 00 00    	jne    c1a7 <_ZN7console7putcharEc+0x237>
    bf90:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%rdi)
    bf97:	e9 73 06 00 00       	jmp    c60f <_ZN7console7putcharEc+0x69f>
    bf9c:	44 8b 47 0c          	mov    0xc(%rdi),%r8d
    bfa0:	8b 47 1c             	mov    0x1c(%rdi),%eax
    bfa3:	41 8d 50 01          	lea    0x1(%r8),%edx
    bfa7:	89 57 0c             	mov    %edx,0xc(%rdi)
    bfaa:	48 63 4f 14          	movslq 0x14(%rdi),%rcx
    bfae:	89 c6                	mov    %eax,%esi
    bfb0:	29 ce                	sub    %ecx,%esi
    bfb2:	39 f2                	cmp    %esi,%edx
    bfb4:	0f 85 4c 04 00 00    	jne    c406 <_ZN7console7putcharEc+0x496>
    bfba:	4c 89 44 24 c0       	mov    %r8,-0x40(%rsp)
    bfbf:	48 89 7c 24 b8       	mov    %rdi,-0x48(%rsp)
    bfc4:	01 c8                	add    %ecx,%eax
    bfc6:	ff c8                	dec    %eax
    bfc8:	39 c1                	cmp    %eax,%ecx
    bfca:	0f 8d 27 04 00 00    	jge    c3f7 <_ZN7console7putcharEc+0x487>
    bfd0:	48 8b 54 24 b8       	mov    -0x48(%rsp),%rdx
    bfd5:	8b 52 18             	mov    0x18(%rdx),%edx
    bfd8:	85 d2                	test   %edx,%edx
    bfda:	0f 8e 17 04 00 00    	jle    c3f7 <_ZN7console7putcharEc+0x487>
    bfe0:	48 8b 74 24 b8       	mov    -0x48(%rsp),%rsi
    bfe5:	4c 8b 0e             	mov    (%rsi),%r9
    bfe8:	4c 63 76 10          	movslq 0x10(%rsi),%r14
    bfec:	4c 63 c2             	movslq %edx,%r8
    bfef:	4d 01 f0             	add    %r14,%r8
    bff2:	48 98                	cltq   
    bff4:	48 89 44 24 e8       	mov    %rax,-0x18(%rsp)
    bff9:	48 89 c8             	mov    %rcx,%rax
    bffc:	48 0f af c2          	imul   %rdx,%rax
    c000:	4a 8d 34 30          	lea    (%rax,%r14,1),%rsi
    c004:	49 8d 34 71          	lea    (%r9,%rsi,2),%rsi
    c008:	48 89 74 24 e0       	mov    %rsi,-0x20(%rsp)
    c00d:	48 8d 71 01          	lea    0x1(%rcx),%rsi
    c011:	48 0f af f2          	imul   %rdx,%rsi
    c015:	48 01 d2             	add    %rdx,%rdx
    c018:	4a 8d 3c 36          	lea    (%rsi,%r14,1),%rdi
    c01c:	49 8d 3c 79          	lea    (%r9,%rdi,2),%rdi
    c020:	48 89 7c 24 c8       	mov    %rdi,-0x38(%rsp)
    c025:	49 8d 7e 01          	lea    0x1(%r14),%rdi
    c029:	49 39 f8             	cmp    %rdi,%r8
    c02c:	49 0f 4f f8          	cmovg  %r8,%rdi
    c030:	4c 29 f7             	sub    %r14,%rdi
    c033:	48 89 fb             	mov    %rdi,%rbx
    c036:	48 83 e3 c0          	and    $0xffffffffffffffc0,%rbx
    c03a:	4e 8d 14 33          	lea    (%rbx,%r14,1),%r10
    c03e:	4c 89 54 24 d0       	mov    %r10,-0x30(%rsp)
    c043:	49 89 fc             	mov    %rdi,%r12
    c046:	49 83 e4 f8          	and    $0xfffffffffffffff8,%r12
    c04a:	4f 8d 14 36          	lea    (%r14,%r14,1),%r10
    c04e:	4d 8d 1c 72          	lea    (%r10,%rsi,2),%r11
    c052:	4f 8d 2c 19          	lea    (%r9,%r11,1),%r13
    c056:	49 83 c5 60          	add    $0x60,%r13
    c05a:	49 8d 2c 42          	lea    (%r10,%rax,2),%rbp
    c05e:	4d 8d 3c 29          	lea    (%r9,%rbp,1),%r15
    c062:	49 83 c7 60          	add    $0x60,%r15
    c066:	4c 01 cd             	add    %r9,%rbp
    c069:	49 8d 04 41          	lea    (%r9,%rax,2),%rax
    c06d:	4d 8d 14 71          	lea    (%r9,%rsi,2),%r10
    c071:	4c 89 74 24 b0       	mov    %r14,-0x50(%rsp)
    c076:	4b 8d 34 34          	lea    (%r12,%r14,1),%rsi
    c07a:	48 89 74 24 d8       	mov    %rsi,-0x28(%rsp)
    c07f:	45 31 db             	xor    %r11d,%r11d
    c082:	4c 8b 4c 24 c8       	mov    -0x38(%rsp),%r9
    c087:	eb 2a                	jmp    c0b3 <_ZN7console7putcharEc+0x143>
    c089:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    c090:	48 ff c1             	inc    %rcx
    c093:	49 ff c3             	inc    %r11
    c096:	49 01 d5             	add    %rdx,%r13
    c099:	49 01 d7             	add    %rdx,%r15
    c09c:	49 01 d1             	add    %rdx,%r9
    c09f:	48 01 d5             	add    %rdx,%rbp
    c0a2:	48 01 d0             	add    %rdx,%rax
    c0a5:	49 01 d2             	add    %rdx,%r10
    c0a8:	48 3b 4c 24 e8       	cmp    -0x18(%rsp),%rcx
    c0ad:	0f 84 44 03 00 00    	je     c3f7 <_ZN7console7putcharEc+0x487>
    c0b3:	48 8b 74 24 b0       	mov    -0x50(%rsp),%rsi
    c0b8:	48 83 ff 08          	cmp    $0x8,%rdi
    c0bc:	0f 82 ce 00 00 00    	jb     c190 <_ZN7console7putcharEc+0x220>
    c0c2:	49 89 d6             	mov    %rdx,%r14
    c0c5:	4d 0f af f3          	imul   %r11,%r14
    c0c9:	48 8b 74 24 c8       	mov    -0x38(%rsp),%rsi
    c0ce:	4c 01 f6             	add    %r14,%rsi
    c0d1:	4c 03 74 24 e0       	add    -0x20(%rsp),%r14
    c0d6:	49 29 f6             	sub    %rsi,%r14
    c0d9:	48 8b 74 24 b0       	mov    -0x50(%rsp),%rsi
    c0de:	49 81 fe 80 00 00 00 	cmp    $0x80,%r14
    c0e5:	0f 82 a5 00 00 00    	jb     c190 <_ZN7console7putcharEc+0x220>
    c0eb:	48 83 ff 40          	cmp    $0x40,%rdi
    c0ef:	73 05                	jae    c0f6 <_ZN7console7putcharEc+0x186>
    c0f1:	45 31 f6             	xor    %r14d,%r14d
    c0f4:	eb 6a                	jmp    c160 <_ZN7console7putcharEc+0x1f0>
    c0f6:	31 f6                	xor    %esi,%esi
    c0f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    c0ff:	00 
    c100:	c4 c1 7c 10 44 75 a0 	vmovups -0x60(%r13,%rsi,2),%ymm0
    c107:	c4 c1 7c 10 4c 75 c0 	vmovups -0x40(%r13,%rsi,2),%ymm1
    c10e:	c4 c1 7c 10 54 75 e0 	vmovups -0x20(%r13,%rsi,2),%ymm2
    c115:	c4 c1 7c 10 5c 75 00 	vmovups 0x0(%r13,%rsi,2),%ymm3
    c11c:	c4 c1 7c 11 44 77 a0 	vmovups %ymm0,-0x60(%r15,%rsi,2)
    c123:	c4 c1 7c 11 4c 77 c0 	vmovups %ymm1,-0x40(%r15,%rsi,2)
    c12a:	c4 c1 7c 11 54 77 e0 	vmovups %ymm2,-0x20(%r15,%rsi,2)
    c131:	c4 c1 7c 11 1c 77    	vmovups %ymm3,(%r15,%rsi,2)
    c137:	48 83 c6 40          	add    $0x40,%rsi
    c13b:	48 39 f3             	cmp    %rsi,%rbx
    c13e:	75 c0                	jne    c100 <_ZN7console7putcharEc+0x190>
    c140:	48 39 df             	cmp    %rbx,%rdi
    c143:	0f 84 47 ff ff ff    	je     c090 <_ZN7console7putcharEc+0x120>
    c149:	49 89 de             	mov    %rbx,%r14
    c14c:	48 8b 74 24 d0       	mov    -0x30(%rsp),%rsi
    c151:	40 f6 c7 38          	test   $0x38,%dil
    c155:	74 39                	je     c190 <_ZN7console7putcharEc+0x220>
    c157:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    c15e:	00 00 
    c160:	c4 81 78 10 04 71    	vmovups (%r9,%r14,2),%xmm0
    c166:	c4 a1 78 11 44 75 00 	vmovups %xmm0,0x0(%rbp,%r14,2)
    c16d:	49 83 c6 08          	add    $0x8,%r14
    c171:	4d 39 f4             	cmp    %r14,%r12
    c174:	75 ea                	jne    c160 <_ZN7console7putcharEc+0x1f0>
    c176:	48 8b 74 24 d8       	mov    -0x28(%rsp),%rsi
    c17b:	4c 39 e7             	cmp    %r12,%rdi
    c17e:	0f 84 0c ff ff ff    	je     c090 <_ZN7console7putcharEc+0x120>
    c184:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    c18b:	00 00 00 00 00 
    c190:	45 0f b7 34 72       	movzwl (%r10,%rsi,2),%r14d
    c195:	66 44 89 34 70       	mov    %r14w,(%rax,%rsi,2)
    c19a:	48 ff c6             	inc    %rsi
    c19d:	4c 39 c6             	cmp    %r8,%rsi
    c1a0:	7c ee                	jl     c190 <_ZN7console7putcharEc+0x220>
    c1a2:	e9 e9 fe ff ff       	jmp    c090 <_ZN7console7putcharEc+0x120>
    c1a7:	48 63 57 08          	movslq 0x8(%rdi),%rdx
    c1ab:	44 8b 5f 0c          	mov    0xc(%rdi),%r11d
    c1af:	40 0f be c6          	movsbl %sil,%eax
    c1b3:	0d 00 0f 00 00       	or     $0xf00,%eax
    c1b8:	4c 8b 17             	mov    (%rdi),%r10
    c1bb:	44 8b 47 18          	mov    0x18(%rdi),%r8d
    c1bf:	44 89 c1             	mov    %r8d,%ecx
    c1c2:	41 0f af cb          	imul   %r11d,%ecx
    c1c6:	48 63 c9             	movslq %ecx,%rcx
    c1c9:	48 01 d1             	add    %rdx,%rcx
    c1cc:	66 41 89 04 4a       	mov    %ax,(%r10,%rcx,2)
    c1d1:	48 ff c2             	inc    %rdx
    c1d4:	89 57 08             	mov    %edx,0x8(%rdi)
    c1d7:	8b 47 10             	mov    0x10(%rdi),%eax
    c1da:	42 8d 0c 00          	lea    (%rax,%r8,1),%ecx
    c1de:	39 ca                	cmp    %ecx,%edx
    c1e0:	0f 85 29 04 00 00    	jne    c60f <_ZN7console7putcharEc+0x69f>
    c1e6:	48 98                	cltq   
    c1e8:	48 89 44 24 b0       	mov    %rax,-0x50(%rsp)
    c1ed:	89 47 08             	mov    %eax,0x8(%rdi)
    c1f0:	41 8d 43 01          	lea    0x1(%r11),%eax
    c1f4:	89 47 0c             	mov    %eax,0xc(%rdi)
    c1f7:	8b 4f 1c             	mov    0x1c(%rdi),%ecx
    c1fa:	4c 63 4f 14          	movslq 0x14(%rdi),%r9
    c1fe:	89 ce                	mov    %ecx,%esi
    c200:	44 29 ce             	sub    %r9d,%esi
    c203:	39 f0                	cmp    %esi,%eax
    c205:	0f 85 5c 02 00 00    	jne    c467 <_ZN7console7putcharEc+0x4f7>
    c20b:	4c 89 5c 24 d0       	mov    %r11,-0x30(%rsp)
    c210:	4c 89 44 24 c0       	mov    %r8,-0x40(%rsp)
    c215:	4c 89 54 24 d8       	mov    %r10,-0x28(%rsp)
    c21a:	48 89 7c 24 b8       	mov    %rdi,-0x48(%rsp)
    c21f:	42 8d 04 09          	lea    (%rcx,%r9,1),%eax
    c223:	ff c8                	dec    %eax
    c225:	41 39 c1             	cmp    %eax,%r9d
    c228:	0f 8d 20 02 00 00    	jge    c44e <_ZN7console7putcharEc+0x4de>
    c22e:	83 7c 24 c0 00       	cmpl   $0x0,-0x40(%rsp)
    c233:	0f 8e 15 02 00 00    	jle    c44e <_ZN7console7putcharEc+0x4de>
    c239:	48 8b 4c 24 b8       	mov    -0x48(%rsp),%rcx
    c23e:	48 8b 31             	mov    (%rcx),%rsi
    c241:	48 98                	cltq   
    c243:	48 89 44 24 e8       	mov    %rax,-0x18(%rsp)
    c248:	4c 89 cf             	mov    %r9,%rdi
    c24b:	48 8b 4c 24 c0       	mov    -0x40(%rsp),%rcx
    c250:	48 0f af f9          	imul   %rcx,%rdi
    c254:	4c 8b 54 24 b0       	mov    -0x50(%rsp),%r10
    c259:	4a 8d 04 17          	lea    (%rdi,%r10,1),%rax
    c25d:	48 8d 04 46          	lea    (%rsi,%rax,2),%rax
    c261:	48 89 44 24 c8       	mov    %rax,-0x38(%rsp)
    c266:	48 8d 1c 09          	lea    (%rcx,%rcx,1),%rbx
    c26a:	4d 8d 41 01          	lea    0x1(%r9),%r8
    c26e:	4c 0f af c1          	imul   %rcx,%r8
    c272:	4b 8d 04 10          	lea    (%r8,%r10,1),%rax
    c276:	4c 8d 24 46          	lea    (%rsi,%rax,2),%r12
    c27a:	49 8d 4a 01          	lea    0x1(%r10),%rcx
    c27e:	48 39 d1             	cmp    %rdx,%rcx
    c281:	48 0f 4e ca          	cmovle %rdx,%rcx
    c285:	4c 29 d1             	sub    %r10,%rcx
    c288:	49 89 cf             	mov    %rcx,%r15
    c28b:	49 83 e7 c0          	and    $0xffffffffffffffc0,%r15
    c28f:	4b 8d 04 17          	lea    (%r15,%r10,1),%rax
    c293:	48 89 44 24 f0       	mov    %rax,-0x10(%rsp)
    c298:	48 89 cd             	mov    %rcx,%rbp
    c29b:	48 83 e5 f8          	and    $0xfffffffffffffff8,%rbp
    c29f:	49 8d 04 2a          	lea    (%r10,%rbp,1),%rax
    c2a3:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    c2a8:	4b 8d 04 12          	lea    (%r10,%r10,1),%rax
    c2ac:	4e 8d 14 40          	lea    (%rax,%r8,2),%r10
    c2b0:	4e 8d 2c 16          	lea    (%rsi,%r10,1),%r13
    c2b4:	49 83 c5 60          	add    $0x60,%r13
    c2b8:	48 8d 04 78          	lea    (%rax,%rdi,2),%rax
    c2bc:	4c 8d 1c 06          	lea    (%rsi,%rax,1),%r11
    c2c0:	49 83 c3 60          	add    $0x60,%r11
    c2c4:	48 01 f0             	add    %rsi,%rax
    c2c7:	4c 8d 34 7e          	lea    (%rsi,%rdi,2),%r14
    c2cb:	4e 8d 04 46          	lea    (%rsi,%r8,2),%r8
    c2cf:	45 31 d2             	xor    %r10d,%r10d
    c2d2:	4c 89 64 24 e0       	mov    %r12,-0x20(%rsp)
    c2d7:	4c 89 e6             	mov    %r12,%rsi
    c2da:	eb 27                	jmp    c303 <_ZN7console7putcharEc+0x393>
    c2dc:	0f 1f 40 00          	nopl   0x0(%rax)
    c2e0:	49 ff c1             	inc    %r9
    c2e3:	49 ff c2             	inc    %r10
    c2e6:	49 01 dd             	add    %rbx,%r13
    c2e9:	49 01 db             	add    %rbx,%r11
    c2ec:	48 01 de             	add    %rbx,%rsi
    c2ef:	48 01 d8             	add    %rbx,%rax
    c2f2:	49 01 de             	add    %rbx,%r14
    c2f5:	49 01 d8             	add    %rbx,%r8
    c2f8:	4c 3b 4c 24 e8       	cmp    -0x18(%rsp),%r9
    c2fd:	0f 84 4b 01 00 00    	je     c44e <_ZN7console7putcharEc+0x4de>
    c303:	48 8b 7c 24 b0       	mov    -0x50(%rsp),%rdi
    c308:	48 83 f9 08          	cmp    $0x8,%rcx
    c30c:	0f 82 ce 00 00 00    	jb     c3e0 <_ZN7console7putcharEc+0x470>
    c312:	49 89 dc             	mov    %rbx,%r12
    c315:	4d 0f af e2          	imul   %r10,%r12
    c319:	48 8b 7c 24 e0       	mov    -0x20(%rsp),%rdi
    c31e:	4c 01 e7             	add    %r12,%rdi
    c321:	4c 03 64 24 c8       	add    -0x38(%rsp),%r12
    c326:	49 29 fc             	sub    %rdi,%r12
    c329:	48 8b 7c 24 b0       	mov    -0x50(%rsp),%rdi
    c32e:	49 81 fc 80 00 00 00 	cmp    $0x80,%r12
    c335:	0f 82 a5 00 00 00    	jb     c3e0 <_ZN7console7putcharEc+0x470>
    c33b:	48 83 f9 40          	cmp    $0x40,%rcx
    c33f:	73 05                	jae    c346 <_ZN7console7putcharEc+0x3d6>
    c341:	45 31 e4             	xor    %r12d,%r12d
    c344:	eb 6a                	jmp    c3b0 <_ZN7console7putcharEc+0x440>
    c346:	31 ff                	xor    %edi,%edi
    c348:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    c34f:	00 
    c350:	c4 c1 7c 10 44 7d a0 	vmovups -0x60(%r13,%rdi,2),%ymm0
    c357:	c4 c1 7c 10 4c 7d c0 	vmovups -0x40(%r13,%rdi,2),%ymm1
    c35e:	c4 c1 7c 10 54 7d e0 	vmovups -0x20(%r13,%rdi,2),%ymm2
    c365:	c4 c1 7c 10 5c 7d 00 	vmovups 0x0(%r13,%rdi,2),%ymm3
    c36c:	c4 c1 7c 11 44 7b a0 	vmovups %ymm0,-0x60(%r11,%rdi,2)
    c373:	c4 c1 7c 11 4c 7b c0 	vmovups %ymm1,-0x40(%r11,%rdi,2)
    c37a:	c4 c1 7c 11 54 7b e0 	vmovups %ymm2,-0x20(%r11,%rdi,2)
    c381:	c4 c1 7c 11 1c 7b    	vmovups %ymm3,(%r11,%rdi,2)
    c387:	48 83 c7 40          	add    $0x40,%rdi
    c38b:	49 39 ff             	cmp    %rdi,%r15
    c38e:	75 c0                	jne    c350 <_ZN7console7putcharEc+0x3e0>
    c390:	4c 39 f9             	cmp    %r15,%rcx
    c393:	0f 84 47 ff ff ff    	je     c2e0 <_ZN7console7putcharEc+0x370>
    c399:	4d 89 fc             	mov    %r15,%r12
    c39c:	48 8b 7c 24 f0       	mov    -0x10(%rsp),%rdi
    c3a1:	f6 c1 38             	test   $0x38,%cl
    c3a4:	74 3a                	je     c3e0 <_ZN7console7putcharEc+0x470>
    c3a6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    c3ad:	00 00 00 
    c3b0:	c4 a1 78 10 04 66    	vmovups (%rsi,%r12,2),%xmm0
    c3b6:	c4 a1 78 11 04 60    	vmovups %xmm0,(%rax,%r12,2)
    c3bc:	49 83 c4 08          	add    $0x8,%r12
    c3c0:	4c 39 e5             	cmp    %r12,%rbp
    c3c3:	75 eb                	jne    c3b0 <_ZN7console7putcharEc+0x440>
    c3c5:	48 8b 7c 24 f8       	mov    -0x8(%rsp),%rdi
    c3ca:	48 39 e9             	cmp    %rbp,%rcx
    c3cd:	0f 84 0d ff ff ff    	je     c2e0 <_ZN7console7putcharEc+0x370>
    c3d3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    c3da:	84 00 00 00 00 00 
    c3e0:	45 0f b7 24 78       	movzwl (%r8,%rdi,2),%r12d
    c3e5:	66 45 89 24 7e       	mov    %r12w,(%r14,%rdi,2)
    c3ea:	48 ff c7             	inc    %rdi
    c3ed:	48 39 d7             	cmp    %rdx,%rdi
    c3f0:	7c ee                	jl     c3e0 <_ZN7console7putcharEc+0x470>
    c3f2:	e9 e9 fe ff ff       	jmp    c2e0 <_ZN7console7putcharEc+0x370>
    c3f7:	48 8b 7c 24 b8       	mov    -0x48(%rsp),%rdi
    c3fc:	48 8b 44 24 c0       	mov    -0x40(%rsp),%rax
    c401:	89 47 0c             	mov    %eax,0xc(%rdi)
    c404:	89 c2                	mov    %eax,%edx
    c406:	48 63 47 18          	movslq 0x18(%rdi),%rax
    c40a:	48 85 c0             	test   %rax,%rax
    c40d:	0f 8e fc 01 00 00    	jle    c60f <_ZN7console7putcharEc+0x69f>
    c413:	89 c6                	mov    %eax,%esi
    c415:	4c 63 47 10          	movslq 0x10(%rdi),%r8
    c419:	4c 01 c0             	add    %r8,%rax
    c41c:	48 8b 0f             	mov    (%rdi),%rcx
    c41f:	0f af d6             	imul   %esi,%edx
    c422:	48 63 d2             	movslq %edx,%rdx
    c425:	49 8d 70 01          	lea    0x1(%r8),%rsi
    c429:	48 39 f0             	cmp    %rsi,%rax
    c42c:	48 0f 4f f0          	cmovg  %rax,%rsi
    c430:	4c 29 c6             	sub    %r8,%rsi
    c433:	48 83 fe 08          	cmp    $0x8,%rsi
    c437:	73 08                	jae    c441 <_ZN7console7putcharEc+0x4d1>
    c439:	4d 89 c1             	mov    %r8,%r9
    c43c:	e9 9a 01 00 00       	jmp    c5db <_ZN7console7putcharEc+0x66b>
    c441:	48 83 fe 40          	cmp    $0x40,%rsi
    c445:	73 61                	jae    c4a8 <_ZN7console7putcharEc+0x538>
    c447:	31 ff                	xor    %edi,%edi
    c449:	e9 b9 00 00 00       	jmp    c507 <_ZN7console7putcharEc+0x597>
    c44e:	48 8b 44 24 b8       	mov    -0x48(%rsp),%rax
    c453:	48 8b 4c 24 d0       	mov    -0x30(%rsp),%rcx
    c458:	89 48 0c             	mov    %ecx,0xc(%rax)
    c45b:	89 c8                	mov    %ecx,%eax
    c45d:	4c 8b 54 24 d8       	mov    -0x28(%rsp),%r10
    c462:	4c 8b 44 24 c0       	mov    -0x40(%rsp),%r8
    c467:	45 85 c0             	test   %r8d,%r8d
    c46a:	0f 8e 9f 01 00 00    	jle    c60f <_ZN7console7putcharEc+0x69f>
    c470:	41 0f af c0          	imul   %r8d,%eax
    c474:	48 63 f0             	movslq %eax,%rsi
    c477:	48 63 c2             	movslq %edx,%rax
    c47a:	4c 8b 44 24 b0       	mov    -0x50(%rsp),%r8
    c47f:	49 8d 50 01          	lea    0x1(%r8),%rdx
    c483:	48 39 c2             	cmp    %rax,%rdx
    c486:	48 0f 4e d0          	cmovle %rax,%rdx
    c48a:	4c 29 c2             	sub    %r8,%rdx
    c48d:	48 83 fa 08          	cmp    $0x8,%rdx
    c491:	0f 82 62 01 00 00    	jb     c5f9 <_ZN7console7putcharEc+0x689>
    c497:	48 83 fa 40          	cmp    $0x40,%rdx
    c49b:	0f 83 ac 00 00 00    	jae    c54d <_ZN7console7putcharEc+0x5dd>
    c4a1:	31 ff                	xor    %edi,%edi
    c4a3:	e9 f6 00 00 00       	jmp    c59e <_ZN7console7putcharEc+0x62e>
    c4a8:	48 89 f7             	mov    %rsi,%rdi
    c4ab:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
    c4af:	4d 8d 0c 10          	lea    (%r8,%rdx,1),%r9
    c4b3:	4e 8d 0c 49          	lea    (%rcx,%r9,2),%r9
    c4b7:	49 83 c1 60          	add    $0x60,%r9
    c4bb:	45 31 d2             	xor    %r10d,%r10d
    c4be:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    c4c2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    c4c9:	1f 84 00 00 00 00 00 
    c4d0:	c4 81 7c 11 44 51 a0 	vmovups %ymm0,-0x60(%r9,%r10,2)
    c4d7:	c4 81 7c 11 44 51 c0 	vmovups %ymm0,-0x40(%r9,%r10,2)
    c4de:	c4 81 7c 11 44 51 e0 	vmovups %ymm0,-0x20(%r9,%r10,2)
    c4e5:	c4 81 7c 11 04 51    	vmovups %ymm0,(%r9,%r10,2)
    c4eb:	49 83 c2 40          	add    $0x40,%r10
    c4ef:	4c 39 d7             	cmp    %r10,%rdi
    c4f2:	75 dc                	jne    c4d0 <_ZN7console7putcharEc+0x560>
    c4f4:	48 39 fe             	cmp    %rdi,%rsi
    c4f7:	0f 84 12 01 00 00    	je     c60f <_ZN7console7putcharEc+0x69f>
    c4fd:	40 f6 c6 38          	test   $0x38,%sil
    c501:	0f 84 ce 00 00 00    	je     c5d5 <_ZN7console7putcharEc+0x665>
    c507:	49 89 f2             	mov    %rsi,%r10
    c50a:	49 83 e2 f8          	and    $0xfffffffffffffff8,%r10
    c50e:	4f 8d 0c 02          	lea    (%r10,%r8,1),%r9
    c512:	4c 8d 1c 12          	lea    (%rdx,%rdx,1),%r11
    c516:	4f 8d 04 43          	lea    (%r11,%r8,2),%r8
    c51a:	49 01 c8             	add    %rcx,%r8
    c51d:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    c521:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    c528:	0f 1f 84 00 00 00 00 
    c52f:	00 
    c530:	c4 c1 78 11 04 78    	vmovups %xmm0,(%r8,%rdi,2)
    c536:	48 83 c7 08          	add    $0x8,%rdi
    c53a:	49 39 fa             	cmp    %rdi,%r10
    c53d:	75 f1                	jne    c530 <_ZN7console7putcharEc+0x5c0>
    c53f:	4c 39 d6             	cmp    %r10,%rsi
    c542:	0f 85 93 00 00 00    	jne    c5db <_ZN7console7putcharEc+0x66b>
    c548:	e9 c2 00 00 00       	jmp    c60f <_ZN7console7putcharEc+0x69f>
    c54d:	48 89 d7             	mov    %rdx,%rdi
    c550:	48 83 e7 c0          	and    $0xffffffffffffffc0,%rdi
    c554:	48 8b 4c 24 b0       	mov    -0x50(%rsp),%rcx
    c559:	48 01 f1             	add    %rsi,%rcx
    c55c:	49 8d 0c 4a          	lea    (%r10,%rcx,2),%rcx
    c560:	48 83 c1 60          	add    $0x60,%rcx
    c564:	45 31 c0             	xor    %r8d,%r8d
    c567:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    c56b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    c570:	c4 a1 7c 11 44 41 a0 	vmovups %ymm0,-0x60(%rcx,%r8,2)
    c577:	c4 a1 7c 11 44 41 c0 	vmovups %ymm0,-0x40(%rcx,%r8,2)
    c57e:	c4 a1 7c 11 44 41 e0 	vmovups %ymm0,-0x20(%rcx,%r8,2)
    c585:	c4 a1 7c 11 04 41    	vmovups %ymm0,(%rcx,%r8,2)
    c58b:	49 83 c0 40          	add    $0x40,%r8
    c58f:	4c 39 c7             	cmp    %r8,%rdi
    c592:	75 dc                	jne    c570 <_ZN7console7putcharEc+0x600>
    c594:	48 39 fa             	cmp    %rdi,%rdx
    c597:	74 76                	je     c60f <_ZN7console7putcharEc+0x69f>
    c599:	f6 c2 38             	test   $0x38,%dl
    c59c:	74 53                	je     c5f1 <_ZN7console7putcharEc+0x681>
    c59e:	49 89 d1             	mov    %rdx,%r9
    c5a1:	49 83 e1 f8          	and    $0xfffffffffffffff8,%r9
    c5a5:	4c 8b 5c 24 b0       	mov    -0x50(%rsp),%r11
    c5aa:	4f 8d 04 19          	lea    (%r9,%r11,1),%r8
    c5ae:	48 8d 0c 36          	lea    (%rsi,%rsi,1),%rcx
    c5b2:	4a 8d 0c 59          	lea    (%rcx,%r11,2),%rcx
    c5b6:	4c 01 d1             	add    %r10,%rcx
    c5b9:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    c5bd:	0f 1f 00             	nopl   (%rax)
    c5c0:	c5 f8 11 04 79       	vmovups %xmm0,(%rcx,%rdi,2)
    c5c5:	48 83 c7 08          	add    $0x8,%rdi
    c5c9:	49 39 f9             	cmp    %rdi,%r9
    c5cc:	75 f2                	jne    c5c0 <_ZN7console7putcharEc+0x650>
    c5ce:	4c 39 ca             	cmp    %r9,%rdx
    c5d1:	75 26                	jne    c5f9 <_ZN7console7putcharEc+0x689>
    c5d3:	eb 3a                	jmp    c60f <_ZN7console7putcharEc+0x69f>
    c5d5:	4c 01 c7             	add    %r8,%rdi
    c5d8:	49 89 f9             	mov    %rdi,%r9
    c5db:	48 8d 0c 51          	lea    (%rcx,%rdx,2),%rcx
    c5df:	90                   	nop
    c5e0:	66 42 c7 04 49 00 00 	movw   $0x0,(%rcx,%r9,2)
    c5e7:	49 ff c1             	inc    %r9
    c5ea:	49 39 c1             	cmp    %rax,%r9
    c5ed:	7c f1                	jl     c5e0 <_ZN7console7putcharEc+0x670>
    c5ef:	eb 1e                	jmp    c60f <_ZN7console7putcharEc+0x69f>
    c5f1:	48 03 7c 24 b0       	add    -0x50(%rsp),%rdi
    c5f6:	49 89 f8             	mov    %rdi,%r8
    c5f9:	49 8d 0c 72          	lea    (%r10,%rsi,2),%rcx
    c5fd:	0f 1f 00             	nopl   (%rax)
    c600:	66 42 c7 04 41 00 00 	movw   $0x0,(%rcx,%r8,2)
    c607:	49 ff c0             	inc    %r8
    c60a:	49 39 c0             	cmp    %rax,%r8
    c60d:	7c f1                	jl     c600 <_ZN7console7putcharEc+0x690>
    c60f:	5b                   	pop    %rbx
    c610:	41 5c                	pop    %r12
    c612:	41 5d                	pop    %r13
    c614:	41 5e                	pop    %r14
    c616:	41 5f                	pop    %r15
    c618:	5d                   	pop    %rbp
    c619:	c5 f8 77             	vzeroupper 
    c61c:	c3                   	ret    
    c61d:	0f 1f 00             	nopl   (%rax)

000000000000c620 <_ZN8rostringC1EPKc>:
    c620:	31 c0                	xor    %eax,%eax
    c622:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    c629:	1f 84 00 00 00 00 00 
    c630:	80 3c 06 00          	cmpb   $0x0,(%rsi,%rax,1)
    c634:	48 8d 40 01          	lea    0x1(%rax),%rax
    c638:	75 f6                	jne    c630 <_ZN8rostringC1EPKc+0x10>
    c63a:	ff c8                	dec    %eax
    c63c:	48 89 37             	mov    %rsi,(%rdi)
    c63f:	89 47 08             	mov    %eax,0x8(%rdi)
    c642:	c3                   	ret    
    c643:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    c64a:	00 00 00 
    c64d:	0f 1f 00             	nopl   (%rax)

000000000000c650 <_ZN13ostringstream7write_dEdiic>:
    c650:	55                   	push   %rbp
    c651:	41 57                	push   %r15
    c653:	41 56                	push   %r14
    c655:	41 55                	push   %r13
    c657:	41 54                	push   %r12
    c659:	53                   	push   %rbx
    c65a:	48 83 ec 58          	sub    $0x58,%rsp
    c65e:	41 89 ce             	mov    %ecx,%r14d
    c661:	48 89 fb             	mov    %rdi,%rbx
    c664:	c4 e1 f9 7e c0       	vmovq  %xmm0,%rax
    c669:	48 b9 00 00 00 00 00 	movabs $0x7ff0000000000000,%rcx
    c670:	00 f0 7f 
    c673:	c4 e2 f8 f2 c1       	andn   %rcx,%rax,%rax
    c678:	75 2f                	jne    c6a9 <_ZN13ostringstream7write_dEdiic+0x59>
    c67a:	8b 73 08             	mov    0x8(%rbx),%esi
    c67d:	48 89 df             	mov    %rbx,%rdi
    c680:	e8 db 36 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    c685:	c6 00 4e             	movb   $0x4e,(%rax)
    c688:	8b 73 08             	mov    0x8(%rbx),%esi
    c68b:	48 89 df             	mov    %rbx,%rdi
    c68e:	e8 cd 36 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    c693:	c6 00 61             	movb   $0x61,(%rax)
    c696:	8b 73 08             	mov    0x8(%rbx),%esi
    c699:	48 89 df             	mov    %rbx,%rdi
    c69c:	e8 bf 36 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    c6a1:	c6 00 4e             	movb   $0x4e,(%rax)
    c6a4:	e9 4f 09 00 00       	jmp    cff8 <_ZN13ostringstream7write_dEdiic+0x9a8>
    c6a9:	41 89 f7             	mov    %esi,%r15d
    c6ac:	89 54 24 2c          	mov    %edx,0x2c(%rsp)
    c6b0:	c5 f1 57 c9          	vxorpd %xmm1,%xmm1,%xmm1
    c6b4:	c5 f9 2e c1          	vucomisd %xmm1,%xmm0
    c6b8:	73 26                	jae    c6e0 <_ZN13ostringstream7write_dEdiic+0x90>
    c6ba:	c5 f9 57 05 be 40 00 	vxorpd 0x40be(%rip),%xmm0,%xmm0        # 10780 <end_ctors+0x4a0>
    c6c1:	00 
    c6c2:	c5 f9 29 44 24 40    	vmovapd %xmm0,0x40(%rsp)
    c6c8:	8b 73 08             	mov    0x8(%rbx),%esi
    c6cb:	48 89 df             	mov    %rbx,%rdi
    c6ce:	e8 8d 36 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    c6d3:	c5 f1 57 c9          	vxorpd %xmm1,%xmm1,%xmm1
    c6d7:	c5 f9 28 44 24 40    	vmovapd 0x40(%rsp),%xmm0
    c6dd:	c6 00 2d             	movb   $0x2d,(%rax)
    c6e0:	31 c0                	xor    %eax,%eax
    c6e2:	c5 f9 29 44 24 40    	vmovapd %xmm0,0x40(%rsp)
    c6e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    c6ef:	00 
    c6f0:	c5 fb 59 05 e8 3e 00 	vmulsd 0x3ee8(%rip),%xmm0,%xmm0        # 105e0 <end_ctors+0x300>
    c6f7:	00 
    c6f8:	ff c0                	inc    %eax
    c6fa:	c5 f9 2e c1          	vucomisd %xmm1,%xmm0
    c6fe:	77 f0                	ja     c6f0 <_ZN13ostringstream7write_dEdiic+0xa0>
    c700:	41 29 c7             	sub    %eax,%r15d
    c703:	7e 21                	jle    c726 <_ZN13ostringstream7write_dEdiic+0xd6>
    c705:	41 8d 6f 01          	lea    0x1(%r15),%ebp
    c709:	41 bf 01 00 00 00    	mov    $0x1,%r15d
    c70f:	90                   	nop
    c710:	8b 73 08             	mov    0x8(%rbx),%esi
    c713:	48 89 df             	mov    %rbx,%rdi
    c716:	e8 45 36 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    c71b:	44 88 30             	mov    %r14b,(%rax)
    c71e:	41 ff c7             	inc    %r15d
    c721:	44 39 fd             	cmp    %r15d,%ebp
    c724:	75 ea                	jne    c710 <_ZN13ostringstream7write_dEdiic+0xc0>
    c726:	48 89 5c 24 38       	mov    %rbx,0x38(%rsp)
    c72b:	48 bb 00 00 00 00 fe 	movabs $0xfffffffe00000000,%rbx
    c732:	ff ff ff 
    c735:	49 bd 00 00 00 00 fc 	movabs $0xfffffffc00000000,%r13
    c73c:	ff ff ff 
    c73f:	c5 f9 57 c0          	vxorpd %xmm0,%xmm0,%xmm0
    c743:	c5 f9 11 44 24 18    	vmovupd %xmm0,0x18(%rsp)
    c749:	4c 8d 74 24 18       	lea    0x18(%rsp),%r14
    c74e:	c5 f9 28 4c 24 40    	vmovapd 0x40(%rsp),%xmm1
    c754:	eb 5b                	jmp    c7b1 <_ZN13ostringstream7write_dEdiic+0x161>
    c756:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    c75d:	00 00 00 
    c760:	4c 89 f7             	mov    %r14,%rdi
    c763:	31 f6                	xor    %esi,%esi
    c765:	e8 f6 35 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    c76a:	49 89 c7             	mov    %rax,%r15
    c76d:	c5 fb 10 05 6b 3e 00 	vmovsd 0x3e6b(%rip),%xmm0        # 105e0 <end_ctors+0x300>
    c774:	00 
    c775:	c5 fb 10 4c 24 10    	vmovsd 0x10(%rsp),%xmm1
    c77b:	c5 fb 2c c1          	vcvttsd2si %xmm1,%eax
    c77f:	48 98                	cltq   
    c781:	48 69 c8 67 66 66 66 	imul   $0x66666667,%rax,%rcx
    c788:	48 89 ca             	mov    %rcx,%rdx
    c78b:	48 c1 ea 3f          	shr    $0x3f,%rdx
    c78f:	48 c1 f9 22          	sar    $0x22,%rcx
    c793:	01 d1                	add    %edx,%ecx
    c795:	01 c9                	add    %ecx,%ecx
    c797:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
    c79a:	29 c8                	sub    %ecx,%eax
    c79c:	04 30                	add    $0x30,%al
    c79e:	41 88 07             	mov    %al,(%r15)
    c7a1:	c5 f3 59 c8          	vmulsd %xmm0,%xmm1,%xmm1
    c7a5:	c5 fb 2c c1          	vcvttsd2si %xmm1,%eax
    c7a9:	85 c0                	test   %eax,%eax
    c7ab:	0f 8e 56 01 00 00    	jle    c907 <_ZN13ostringstream7write_dEdiic+0x2b7>
    c7b1:	c5 fb 11 4c 24 10    	vmovsd %xmm1,0x10(%rsp)
    c7b7:	83 7c 24 20 00       	cmpl   $0x0,0x20(%rsp)
    c7bc:	7e a2                	jle    c760 <_ZN13ostringstream7write_dEdiic+0x110>
    c7be:	4c 63 64 24 20       	movslq 0x20(%rsp),%r12
    c7c3:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    c7c8:	4d 8d 7c 24 ff       	lea    -0x1(%r12),%r15
    c7cd:	42 0f b6 6c 20 ff    	movzbl -0x1(%rax,%r12,1),%ebp
    c7d3:	4c 89 f7             	mov    %r14,%rdi
    c7d6:	44 89 e6             	mov    %r12d,%esi
    c7d9:	e8 82 35 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    c7de:	40 88 28             	mov    %bpl,(%rax)
    c7e1:	49 83 fc 02          	cmp    $0x2,%r12
    c7e5:	7c 59                	jl     c840 <_ZN13ostringstream7write_dEdiic+0x1f0>
    c7e7:	4c 89 f9             	mov    %r15,%rcx
    c7ea:	44 89 e0             	mov    %r12d,%eax
    c7ed:	c5 fb 10 05 eb 3d 00 	vmovsd 0x3deb(%rip),%xmm0        # 105e0 <end_ctors+0x300>
    c7f4:	00 
    c7f5:	48 83 e1 03          	and    $0x3,%rcx
    c7f9:	74 58                	je     c853 <_ZN13ostringstream7write_dEdiic+0x203>
    c7fb:	c5 fb 10 4c 24 10    	vmovsd 0x10(%rsp),%xmm1
    c801:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    c808:	0f 1f 84 00 00 00 00 
    c80f:	00 
    c810:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
    c815:	8d 70 fe             	lea    -0x2(%rax),%esi
    c818:	48 63 f6             	movslq %esi,%rsi
    c81b:	0f b6 34 32          	movzbl (%rdx,%rsi,1),%esi
    c81f:	42 88 34 3a          	mov    %sil,(%rdx,%r15,1)
    c823:	49 ff cf             	dec    %r15
    c826:	ff c8                	dec    %eax
    c828:	48 ff c9             	dec    %rcx
    c82b:	75 e3                	jne    c810 <_ZN13ostringstream7write_dEdiic+0x1c0>
    c82d:	49 83 c4 fe          	add    $0xfffffffffffffffe,%r12
    c831:	49 83 fc 03          	cmp    $0x3,%r12
    c835:	73 30                	jae    c867 <_ZN13ostringstream7write_dEdiic+0x217>
    c837:	e9 be 00 00 00       	jmp    c8fa <_ZN13ostringstream7write_dEdiic+0x2aa>
    c83c:	0f 1f 40 00          	nopl   0x0(%rax)
    c840:	c5 fb 10 05 98 3d 00 	vmovsd 0x3d98(%rip),%xmm0        # 105e0 <end_ctors+0x300>
    c847:	00 
    c848:	c5 fb 10 4c 24 10    	vmovsd 0x10(%rsp),%xmm1
    c84e:	e9 aa 00 00 00       	jmp    c8fd <_ZN13ostringstream7write_dEdiic+0x2ad>
    c853:	c5 fb 10 4c 24 10    	vmovsd 0x10(%rsp),%xmm1
    c859:	49 83 c4 fe          	add    $0xfffffffffffffffe,%r12
    c85d:	49 83 fc 03          	cmp    $0x3,%r12
    c861:	0f 82 93 00 00 00    	jb     c8fa <_ZN13ostringstream7write_dEdiic+0x2aa>
    c867:	49 8d 77 04          	lea    0x4(%r15),%rsi
    c86b:	49 c1 e7 20          	shl    $0x20,%r15
    c86f:	4b 8d 0c 2f          	lea    (%r15,%r13,1),%rcx
    c873:	48 ba 00 00 00 00 fd 	movabs $0xfffffffd00000000,%rdx
    c87a:	ff ff ff 
    c87d:	4c 01 fa             	add    %r15,%rdx
    c880:	49 01 df             	add    %rbx,%r15
    c883:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    c88a:	84 00 00 00 00 00 
    c890:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
    c895:	48 98                	cltq   
    c897:	0f b6 44 38 fe       	movzbl -0x2(%rax,%rdi,1),%eax
    c89c:	88 44 37 fc          	mov    %al,-0x4(%rdi,%rsi,1)
    c8a0:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    c8a5:	4c 89 ff             	mov    %r15,%rdi
    c8a8:	48 c1 ff 20          	sar    $0x20,%rdi
    c8ac:	0f b6 3c 38          	movzbl (%rax,%rdi,1),%edi
    c8b0:	40 88 7c 30 fb       	mov    %dil,-0x5(%rax,%rsi,1)
    c8b5:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    c8ba:	48 89 d7             	mov    %rdx,%rdi
    c8bd:	48 c1 ff 20          	sar    $0x20,%rdi
    c8c1:	0f b6 3c 38          	movzbl (%rax,%rdi,1),%edi
    c8c5:	40 88 7c 30 fa       	mov    %dil,-0x6(%rax,%rsi,1)
    c8ca:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    c8cf:	48 89 cf             	mov    %rcx,%rdi
    c8d2:	48 c1 ff 20          	sar    $0x20,%rdi
    c8d6:	0f b6 3c 38          	movzbl (%rax,%rdi,1),%edi
    c8da:	40 88 7c 30 f9       	mov    %dil,-0x7(%rax,%rsi,1)
    c8df:	89 f0                	mov    %esi,%eax
    c8e1:	48 8d 7e fc          	lea    -0x4(%rsi),%rdi
    c8e5:	4c 01 e9             	add    %r13,%rcx
    c8e8:	4c 01 ea             	add    %r13,%rdx
    c8eb:	4d 01 ef             	add    %r13,%r15
    c8ee:	83 c0 f9             	add    $0xfffffff9,%eax
    c8f1:	48 89 fe             	mov    %rdi,%rsi
    c8f4:	48 83 ff 04          	cmp    $0x4,%rdi
    c8f8:	7f 96                	jg     c890 <_ZN13ostringstream7write_dEdiic+0x240>
    c8fa:	45 31 ff             	xor    %r15d,%r15d
    c8fd:	4c 03 7c 24 18       	add    0x18(%rsp),%r15
    c902:	e9 74 fe ff ff       	jmp    c77b <_ZN13ostringstream7write_dEdiic+0x12b>
    c907:	8b 44 24 20          	mov    0x20(%rsp),%eax
    c90b:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
    c910:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
    c915:	89 44 24 08          	mov    %eax,0x8(%rsp)
    c919:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
    c91e:	8b 44 24 08          	mov    0x8(%rsp),%eax
    c922:	48 63 d0             	movslq %eax,%rdx
    c925:	48 8d 7a 1f          	lea    0x1f(%rdx),%rdi
    c929:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
    c92d:	be 10 00 00 00       	mov    $0x10,%esi
    c932:	48 0f 45 f7          	cmovne %rdi,%rsi
    c936:	48 8b 3c 25 00 00 00 	mov    0x1000000,%rdi
    c93d:	01 
    c93e:	41 b8 00 00 00 01    	mov    $0x1000000,%r8d
    c944:	48 39 f7             	cmp    %rsi,%rdi
    c947:	73 13                	jae    c95c <_ZN13ostringstream7write_dEdiic+0x30c>
    c949:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    c950:	4d 8b 40 08          	mov    0x8(%r8),%r8
    c954:	49 8b 38             	mov    (%r8),%rdi
    c957:	48 39 f7             	cmp    %rsi,%rdi
    c95a:	72 f4                	jb     c950 <_ZN13ostringstream7write_dEdiic+0x300>
    c95c:	4d 8b 50 08          	mov    0x8(%r8),%r10
    c960:	49 89 f9             	mov    %rdi,%r9
    c963:	49 29 f1             	sub    %rsi,%r9
    c966:	49 83 f9 0f          	cmp    $0xf,%r9
    c96a:	77 0c                	ja     c978 <_ZN13ostringstream7write_dEdiic+0x328>
    c96c:	c4 c1 79 10 02       	vmovupd (%r10),%xmm0
    c971:	c4 c1 79 11 00       	vmovupd %xmm0,(%r8)
    c976:	eb 0d                	jmp    c985 <_ZN13ostringstream7write_dEdiic+0x335>
    c978:	4d 89 08             	mov    %r9,(%r8)
    c97b:	49 c1 e1 04          	shl    $0x4,%r9
    c97f:	4d 01 ca             	add    %r9,%r10
    c982:	48 89 f7             	mov    %rsi,%rdi
    c985:	4d 8d 5a 10          	lea    0x10(%r10),%r11
    c989:	49 89 3a             	mov    %rdi,(%r10)
    c98c:	48 01 3c 25 28 00 11 	add    %rdi,0x110028
    c993:	00 
    c994:	85 c0                	test   %eax,%eax
    c996:	0f 8e 3b 01 00 00    	jle    cad7 <_ZN13ostringstream7write_dEdiic+0x487>
    c99c:	31 f6                	xor    %esi,%esi
    c99e:	83 f8 10             	cmp    $0x10,%eax
    c9a1:	0f 82 a6 00 00 00    	jb     ca4d <_ZN13ostringstream7write_dEdiic+0x3fd>
    c9a7:	4c 89 df             	mov    %r11,%rdi
    c9aa:	48 29 cf             	sub    %rcx,%rdi
    c9ad:	48 81 ff 80 00 00 00 	cmp    $0x80,%rdi
    c9b4:	0f 82 93 00 00 00    	jb     ca4d <_ZN13ostringstream7write_dEdiic+0x3fd>
    c9ba:	3d 80 00 00 00       	cmp    $0x80,%eax
    c9bf:	73 04                	jae    c9c5 <_ZN13ostringstream7write_dEdiic+0x375>
    c9c1:	31 f6                	xor    %esi,%esi
    c9c3:	eb 54                	jmp    ca19 <_ZN13ostringstream7write_dEdiic+0x3c9>
    c9c5:	48 89 d6             	mov    %rdx,%rsi
    c9c8:	48 83 e6 80          	and    $0xffffffffffffff80,%rsi
    c9cc:	31 ff                	xor    %edi,%edi
    c9ce:	66 90                	xchg   %ax,%ax
    c9d0:	c5 fd 10 04 39       	vmovupd (%rcx,%rdi,1),%ymm0
    c9d5:	c5 fd 10 4c 39 20    	vmovupd 0x20(%rcx,%rdi,1),%ymm1
    c9db:	c5 fc 10 54 39 40    	vmovups 0x40(%rcx,%rdi,1),%ymm2
    c9e1:	c5 fc 10 5c 39 60    	vmovups 0x60(%rcx,%rdi,1),%ymm3
    c9e7:	c4 c1 7d 11 04 3b    	vmovupd %ymm0,(%r11,%rdi,1)
    c9ed:	c4 c1 7d 11 4c 3b 20 	vmovupd %ymm1,0x20(%r11,%rdi,1)
    c9f4:	c4 c1 7c 11 54 3b 40 	vmovups %ymm2,0x40(%r11,%rdi,1)
    c9fb:	c4 c1 7c 11 5c 3b 60 	vmovups %ymm3,0x60(%r11,%rdi,1)
    ca02:	48 83 ef 80          	sub    $0xffffffffffffff80,%rdi
    ca06:	48 39 fe             	cmp    %rdi,%rsi
    ca09:	75 c5                	jne    c9d0 <_ZN13ostringstream7write_dEdiic+0x380>
    ca0b:	48 39 d6             	cmp    %rdx,%rsi
    ca0e:	0f 84 c3 00 00 00    	je     cad7 <_ZN13ostringstream7write_dEdiic+0x487>
    ca14:	f6 c2 70             	test   $0x70,%dl
    ca17:	74 34                	je     ca4d <_ZN13ostringstream7write_dEdiic+0x3fd>
    ca19:	48 89 f7             	mov    %rsi,%rdi
    ca1c:	48 89 d6             	mov    %rdx,%rsi
    ca1f:	48 83 e6 f0          	and    $0xfffffffffffffff0,%rsi
    ca23:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    ca2a:	84 00 00 00 00 00 
    ca30:	c5 f9 10 04 39       	vmovupd (%rcx,%rdi,1),%xmm0
    ca35:	c4 c1 79 11 04 3b    	vmovupd %xmm0,(%r11,%rdi,1)
    ca3b:	48 83 c7 10          	add    $0x10,%rdi
    ca3f:	48 39 fe             	cmp    %rdi,%rsi
    ca42:	75 ec                	jne    ca30 <_ZN13ostringstream7write_dEdiic+0x3e0>
    ca44:	48 39 d6             	cmp    %rdx,%rsi
    ca47:	0f 84 8a 00 00 00    	je     cad7 <_ZN13ostringstream7write_dEdiic+0x487>
    ca4d:	48 89 f7             	mov    %rsi,%rdi
    ca50:	48 f7 d7             	not    %rdi
    ca53:	48 01 d7             	add    %rdx,%rdi
    ca56:	49 89 d0             	mov    %rdx,%r8
    ca59:	49 83 e0 07          	and    $0x7,%r8
    ca5d:	74 12                	je     ca71 <_ZN13ostringstream7write_dEdiic+0x421>
    ca5f:	90                   	nop
    ca60:	44 0f b6 0c 31       	movzbl (%rcx,%rsi,1),%r9d
    ca65:	45 88 0c 33          	mov    %r9b,(%r11,%rsi,1)
    ca69:	48 ff c6             	inc    %rsi
    ca6c:	49 ff c8             	dec    %r8
    ca6f:	75 ef                	jne    ca60 <_ZN13ostringstream7write_dEdiic+0x410>
    ca71:	48 83 ff 07          	cmp    $0x7,%rdi
    ca75:	72 60                	jb     cad7 <_ZN13ostringstream7write_dEdiic+0x487>
    ca77:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    ca7e:	00 00 
    ca80:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
    ca84:	41 88 3c 33          	mov    %dil,(%r11,%rsi,1)
    ca88:	0f b6 7c 31 01       	movzbl 0x1(%rcx,%rsi,1),%edi
    ca8d:	41 88 7c 33 01       	mov    %dil,0x1(%r11,%rsi,1)
    ca92:	0f b6 7c 31 02       	movzbl 0x2(%rcx,%rsi,1),%edi
    ca97:	41 88 7c 33 02       	mov    %dil,0x2(%r11,%rsi,1)
    ca9c:	0f b6 7c 31 03       	movzbl 0x3(%rcx,%rsi,1),%edi
    caa1:	41 88 7c 33 03       	mov    %dil,0x3(%r11,%rsi,1)
    caa6:	0f b6 7c 31 04       	movzbl 0x4(%rcx,%rsi,1),%edi
    caab:	41 88 7c 33 04       	mov    %dil,0x4(%r11,%rsi,1)
    cab0:	0f b6 7c 31 05       	movzbl 0x5(%rcx,%rsi,1),%edi
    cab5:	41 88 7c 33 05       	mov    %dil,0x5(%r11,%rsi,1)
    caba:	0f b6 7c 31 06       	movzbl 0x6(%rcx,%rsi,1),%edi
    cabf:	41 88 7c 33 06       	mov    %dil,0x6(%r11,%rsi,1)
    cac4:	0f b6 7c 31 07       	movzbl 0x7(%rcx,%rsi,1),%edi
    cac9:	41 88 7c 33 07       	mov    %dil,0x7(%r11,%rsi,1)
    cace:	48 83 c6 08          	add    $0x8,%rsi
    cad2:	48 39 f2             	cmp    %rsi,%rdx
    cad5:	75 a9                	jne    ca80 <_ZN13ostringstream7write_dEdiic+0x430>
    cad7:	4c 89 54 24 50       	mov    %r10,0x50(%rsp)
    cadc:	4c 89 5c 24 10       	mov    %r11,0x10(%rsp)
    cae1:	4c 89 5c 24 30       	mov    %r11,0x30(%rsp)
    cae6:	89 44 24 08          	mov    %eax,0x8(%rsp)
    caea:	48 8b 6c 24 30       	mov    0x30(%rsp),%rbp
    caef:	44 8b 7c 24 08       	mov    0x8(%rsp),%r15d
    caf4:	45 85 ff             	test   %r15d,%r15d
    caf7:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
    cafc:	7e 32                	jle    cb30 <_ZN13ostringstream7write_dEdiic+0x4e0>
    cafe:	45 31 f6             	xor    %r14d,%r14d
    cb01:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    cb08:	0f 1f 84 00 00 00 00 
    cb0f:	00 
    cb10:	42 0f b6 5c 35 00    	movzbl 0x0(%rbp,%r14,1),%ebx
    cb16:	41 8b 74 24 08       	mov    0x8(%r12),%esi
    cb1b:	4c 89 e7             	mov    %r12,%rdi
    cb1e:	c5 f8 77             	vzeroupper 
    cb21:	e8 3a 32 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    cb26:	88 18                	mov    %bl,(%rax)
    cb28:	49 ff c6             	inc    %r14
    cb2b:	4d 39 f7             	cmp    %r14,%r15
    cb2e:	75 e0                	jne    cb10 <_ZN13ostringstream7write_dEdiic+0x4c0>
    cb30:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
    cb36:	74 2d                	je     cb65 <_ZN13ostringstream7write_dEdiic+0x515>
    cb38:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
    cb3d:	48 8b 01             	mov    (%rcx),%rax
    cb40:	c5 f9 10 04 25 00 00 	vmovupd 0x1000000,%xmm0
    cb47:	00 01 
    cb49:	c5 f9 11 01          	vmovupd %xmm0,(%rcx)
    cb4d:	48 89 04 25 00 00 00 	mov    %rax,0x1000000
    cb54:	01 
    cb55:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    cb5c:	01 
    cb5d:	48 29 04 25 28 00 11 	sub    %rax,0x110028
    cb64:	00 
    cb65:	8b 5c 24 2c          	mov    0x2c(%rsp),%ebx
    cb69:	85 db                	test   %ebx,%ebx
    cb6b:	0f 8e 4f 04 00 00    	jle    cfc0 <_ZN13ostringstream7write_dEdiic+0x970>
    cb71:	48 8b 7c 24 38       	mov    0x38(%rsp),%rdi
    cb76:	8b 77 08             	mov    0x8(%rdi),%esi
    cb79:	c5 f8 77             	vzeroupper 
    cb7c:	e8 df 31 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    cb81:	c6 00 2e             	movb   $0x2e,(%rax)
    cb84:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    cb89:	48 85 c0             	test   %rax,%rax
    cb8c:	74 2e                	je     cbbc <_ZN13ostringstream7write_dEdiic+0x56c>
    cb8e:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    cb92:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    cb96:	c5 f9 10 04 25 00 00 	vmovupd 0x1000000,%xmm0
    cb9d:	00 01 
    cb9f:	c5 f9 11 40 f0       	vmovupd %xmm0,-0x10(%rax)
    cba4:	48 89 14 25 00 00 00 	mov    %rdx,0x1000000
    cbab:	01 
    cbac:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    cbb3:	01 
    cbb4:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    cbbb:	00 
    cbbc:	c5 f9 57 c0          	vxorpd %xmm0,%xmm0,%xmm0
    cbc0:	c5 f9 11 44 24 18    	vmovupd %xmm0,0x18(%rsp)
    cbc6:	c5 f9 28 4c 24 40    	vmovapd 0x40(%rsp),%xmm1
    cbcc:	c4 e3 71 0b c1 0b    	vroundsd $0xb,%xmm1,%xmm1,%xmm0
    cbd2:	c5 f3 5c c0          	vsubsd %xmm0,%xmm1,%xmm0
    cbd6:	31 ed                	xor    %ebp,%ebp
    cbd8:	4c 8d 74 24 18       	lea    0x18(%rsp),%r14
    cbdd:	eb 44                	jmp    cc23 <_ZN13ostringstream7write_dEdiic+0x5d3>
    cbdf:	90                   	nop
    cbe0:	4c 89 f7             	mov    %r14,%rdi
    cbe3:	31 f6                	xor    %esi,%esi
    cbe5:	e8 76 31 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    cbea:	49 89 c7             	mov    %rax,%r15
    cbed:	c5 fb 10 44 24 10    	vmovsd 0x10(%rsp),%xmm0
    cbf3:	c5 fb 2c c0          	vcvttsd2si %xmm0,%eax
    cbf7:	48 98                	cltq   
    cbf9:	48 69 c8 67 66 66 66 	imul   $0x66666667,%rax,%rcx
    cc00:	48 89 ca             	mov    %rcx,%rdx
    cc03:	48 c1 ea 3f          	shr    $0x3f,%rdx
    cc07:	48 c1 f9 22          	sar    $0x22,%rcx
    cc0b:	01 d1                	add    %edx,%ecx
    cc0d:	01 c9                	add    %ecx,%ecx
    cc0f:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
    cc12:	29 c8                	sub    %ecx,%eax
    cc14:	04 30                	add    $0x30,%al
    cc16:	41 88 07             	mov    %al,(%r15)
    cc19:	ff c5                	inc    %ebp
    cc1b:	39 dd                	cmp    %ebx,%ebp
    cc1d:	0f 84 54 01 00 00    	je     cd77 <_ZN13ostringstream7write_dEdiic+0x727>
    cc23:	c5 fb 59 05 bd 39 00 	vmulsd 0x39bd(%rip),%xmm0,%xmm0        # 105e8 <end_ctors+0x308>
    cc2a:	00 
    cc2b:	c5 fb 11 44 24 10    	vmovsd %xmm0,0x10(%rsp)
    cc31:	83 7c 24 20 00       	cmpl   $0x0,0x20(%rsp)
    cc36:	7e a8                	jle    cbe0 <_ZN13ostringstream7write_dEdiic+0x590>
    cc38:	4c 63 64 24 20       	movslq 0x20(%rsp),%r12
    cc3d:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    cc42:	4d 8d 7c 24 ff       	lea    -0x1(%r12),%r15
    cc47:	42 0f b6 5c 20 ff    	movzbl -0x1(%rax,%r12,1),%ebx
    cc4d:	4c 89 f7             	mov    %r14,%rdi
    cc50:	44 89 e6             	mov    %r12d,%esi
    cc53:	e8 08 31 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    cc58:	88 18                	mov    %bl,(%rax)
    cc5a:	49 83 fc 02          	cmp    $0x2,%r12
    cc5e:	7c 50                	jl     ccb0 <_ZN13ostringstream7write_dEdiic+0x660>
    cc60:	4c 89 f9             	mov    %r15,%rcx
    cc63:	44 89 e0             	mov    %r12d,%eax
    cc66:	48 83 e1 03          	and    $0x3,%rcx
    cc6a:	74 53                	je     ccbf <_ZN13ostringstream7write_dEdiic+0x66f>
    cc6c:	8b 5c 24 2c          	mov    0x2c(%rsp),%ebx
    cc70:	c5 fb 10 44 24 10    	vmovsd 0x10(%rsp),%xmm0
    cc76:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    cc7d:	00 00 00 
    cc80:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
    cc85:	8d 70 fe             	lea    -0x2(%rax),%esi
    cc88:	48 63 f6             	movslq %esi,%rsi
    cc8b:	0f b6 34 32          	movzbl (%rdx,%rsi,1),%esi
    cc8f:	42 88 34 3a          	mov    %sil,(%rdx,%r15,1)
    cc93:	49 ff cf             	dec    %r15
    cc96:	ff c8                	dec    %eax
    cc98:	48 ff c9             	dec    %rcx
    cc9b:	75 e3                	jne    cc80 <_ZN13ostringstream7write_dEdiic+0x630>
    cc9d:	49 83 c4 fe          	add    $0xfffffffffffffffe,%r12
    cca1:	49 83 fc 03          	cmp    $0x3,%r12
    cca5:	73 30                	jae    ccd7 <_ZN13ostringstream7write_dEdiic+0x687>
    cca7:	e9 be 00 00 00       	jmp    cd6a <_ZN13ostringstream7write_dEdiic+0x71a>
    ccac:	0f 1f 40 00          	nopl   0x0(%rax)
    ccb0:	8b 5c 24 2c          	mov    0x2c(%rsp),%ebx
    ccb4:	c5 fb 10 44 24 10    	vmovsd 0x10(%rsp),%xmm0
    ccba:	e9 ae 00 00 00       	jmp    cd6d <_ZN13ostringstream7write_dEdiic+0x71d>
    ccbf:	8b 5c 24 2c          	mov    0x2c(%rsp),%ebx
    ccc3:	c5 fb 10 44 24 10    	vmovsd 0x10(%rsp),%xmm0
    ccc9:	49 83 c4 fe          	add    $0xfffffffffffffffe,%r12
    cccd:	49 83 fc 03          	cmp    $0x3,%r12
    ccd1:	0f 82 93 00 00 00    	jb     cd6a <_ZN13ostringstream7write_dEdiic+0x71a>
    ccd7:	49 8d 77 04          	lea    0x4(%r15),%rsi
    ccdb:	49 c1 e7 20          	shl    $0x20,%r15
    ccdf:	4b 8d 0c 2f          	lea    (%r15,%r13,1),%rcx
    cce3:	48 ba 00 00 00 00 fd 	movabs $0xfffffffd00000000,%rdx
    ccea:	ff ff ff 
    cced:	4c 01 fa             	add    %r15,%rdx
    ccf0:	48 bf 00 00 00 00 fe 	movabs $0xfffffffe00000000,%rdi
    ccf7:	ff ff ff 
    ccfa:	49 01 ff             	add    %rdi,%r15
    ccfd:	0f 1f 00             	nopl   (%rax)
    cd00:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
    cd05:	48 98                	cltq   
    cd07:	0f b6 44 38 fe       	movzbl -0x2(%rax,%rdi,1),%eax
    cd0c:	88 44 37 fc          	mov    %al,-0x4(%rdi,%rsi,1)
    cd10:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    cd15:	4c 89 ff             	mov    %r15,%rdi
    cd18:	48 c1 ff 20          	sar    $0x20,%rdi
    cd1c:	0f b6 3c 38          	movzbl (%rax,%rdi,1),%edi
    cd20:	40 88 7c 30 fb       	mov    %dil,-0x5(%rax,%rsi,1)
    cd25:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    cd2a:	48 89 d7             	mov    %rdx,%rdi
    cd2d:	48 c1 ff 20          	sar    $0x20,%rdi
    cd31:	0f b6 3c 38          	movzbl (%rax,%rdi,1),%edi
    cd35:	40 88 7c 30 fa       	mov    %dil,-0x6(%rax,%rsi,1)
    cd3a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    cd3f:	48 89 cf             	mov    %rcx,%rdi
    cd42:	48 c1 ff 20          	sar    $0x20,%rdi
    cd46:	0f b6 3c 38          	movzbl (%rax,%rdi,1),%edi
    cd4a:	40 88 7c 30 f9       	mov    %dil,-0x7(%rax,%rsi,1)
    cd4f:	89 f0                	mov    %esi,%eax
    cd51:	48 8d 7e fc          	lea    -0x4(%rsi),%rdi
    cd55:	4c 01 e9             	add    %r13,%rcx
    cd58:	4c 01 ea             	add    %r13,%rdx
    cd5b:	4d 01 ef             	add    %r13,%r15
    cd5e:	83 c0 f9             	add    $0xfffffff9,%eax
    cd61:	48 89 fe             	mov    %rdi,%rsi
    cd64:	48 83 ff 04          	cmp    $0x4,%rdi
    cd68:	7f 96                	jg     cd00 <_ZN13ostringstream7write_dEdiic+0x6b0>
    cd6a:	45 31 ff             	xor    %r15d,%r15d
    cd6d:	4c 03 7c 24 18       	add    0x18(%rsp),%r15
    cd72:	e9 7c fe ff ff       	jmp    cbf3 <_ZN13ostringstream7write_dEdiic+0x5a3>
    cd77:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    cd7c:	8b 4c 24 20          	mov    0x20(%rsp),%ecx
    cd80:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
    cd85:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
    cd89:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
    cd8e:	8b 44 24 08          	mov    0x8(%rsp),%eax
    cd92:	48 63 d0             	movslq %eax,%rdx
    cd95:	48 8d 7a 1f          	lea    0x1f(%rdx),%rdi
    cd99:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
    cd9d:	be 10 00 00 00       	mov    $0x10,%esi
    cda2:	48 0f 45 f7          	cmovne %rdi,%rsi
    cda6:	48 8b 3c 25 00 00 00 	mov    0x1000000,%rdi
    cdad:	01 
    cdae:	41 b8 00 00 00 01    	mov    $0x1000000,%r8d
    cdb4:	48 39 f7             	cmp    %rsi,%rdi
    cdb7:	73 13                	jae    cdcc <_ZN13ostringstream7write_dEdiic+0x77c>
    cdb9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    cdc0:	4d 8b 40 08          	mov    0x8(%r8),%r8
    cdc4:	49 8b 38             	mov    (%r8),%rdi
    cdc7:	48 39 f7             	cmp    %rsi,%rdi
    cdca:	72 f4                	jb     cdc0 <_ZN13ostringstream7write_dEdiic+0x770>
    cdcc:	4d 8b 50 08          	mov    0x8(%r8),%r10
    cdd0:	49 89 f9             	mov    %rdi,%r9
    cdd3:	49 29 f1             	sub    %rsi,%r9
    cdd6:	49 83 f9 0f          	cmp    $0xf,%r9
    cdda:	77 0c                	ja     cde8 <_ZN13ostringstream7write_dEdiic+0x798>
    cddc:	c4 c1 79 10 02       	vmovupd (%r10),%xmm0
    cde1:	c4 c1 79 11 00       	vmovupd %xmm0,(%r8)
    cde6:	eb 0d                	jmp    cdf5 <_ZN13ostringstream7write_dEdiic+0x7a5>
    cde8:	4d 89 08             	mov    %r9,(%r8)
    cdeb:	49 c1 e1 04          	shl    $0x4,%r9
    cdef:	4d 01 ca             	add    %r9,%r10
    cdf2:	48 89 f7             	mov    %rsi,%rdi
    cdf5:	4d 8d 7a 10          	lea    0x10(%r10),%r15
    cdf9:	49 89 3a             	mov    %rdi,(%r10)
    cdfc:	48 01 3c 25 28 00 11 	add    %rdi,0x110028
    ce03:	00 
    ce04:	85 c0                	test   %eax,%eax
    ce06:	0f 8e 3b 01 00 00    	jle    cf47 <_ZN13ostringstream7write_dEdiic+0x8f7>
    ce0c:	31 f6                	xor    %esi,%esi
    ce0e:	83 f8 10             	cmp    $0x10,%eax
    ce11:	0f 82 a6 00 00 00    	jb     cebd <_ZN13ostringstream7write_dEdiic+0x86d>
    ce17:	4c 89 ff             	mov    %r15,%rdi
    ce1a:	48 29 cf             	sub    %rcx,%rdi
    ce1d:	48 81 ff 80 00 00 00 	cmp    $0x80,%rdi
    ce24:	0f 82 93 00 00 00    	jb     cebd <_ZN13ostringstream7write_dEdiic+0x86d>
    ce2a:	3d 80 00 00 00       	cmp    $0x80,%eax
    ce2f:	73 04                	jae    ce35 <_ZN13ostringstream7write_dEdiic+0x7e5>
    ce31:	31 f6                	xor    %esi,%esi
    ce33:	eb 54                	jmp    ce89 <_ZN13ostringstream7write_dEdiic+0x839>
    ce35:	48 89 d6             	mov    %rdx,%rsi
    ce38:	48 83 e6 80          	and    $0xffffffffffffff80,%rsi
    ce3c:	31 ff                	xor    %edi,%edi
    ce3e:	66 90                	xchg   %ax,%ax
    ce40:	c5 fd 10 04 39       	vmovupd (%rcx,%rdi,1),%ymm0
    ce45:	c5 fd 10 4c 39 20    	vmovupd 0x20(%rcx,%rdi,1),%ymm1
    ce4b:	c5 fc 10 54 39 40    	vmovups 0x40(%rcx,%rdi,1),%ymm2
    ce51:	c5 fc 10 5c 39 60    	vmovups 0x60(%rcx,%rdi,1),%ymm3
    ce57:	c4 c1 7d 11 04 3f    	vmovupd %ymm0,(%r15,%rdi,1)
    ce5d:	c4 c1 7d 11 4c 3f 20 	vmovupd %ymm1,0x20(%r15,%rdi,1)
    ce64:	c4 c1 7c 11 54 3f 40 	vmovups %ymm2,0x40(%r15,%rdi,1)
    ce6b:	c4 c1 7c 11 5c 3f 60 	vmovups %ymm3,0x60(%r15,%rdi,1)
    ce72:	48 83 ef 80          	sub    $0xffffffffffffff80,%rdi
    ce76:	48 39 fe             	cmp    %rdi,%rsi
    ce79:	75 c5                	jne    ce40 <_ZN13ostringstream7write_dEdiic+0x7f0>
    ce7b:	48 39 d6             	cmp    %rdx,%rsi
    ce7e:	0f 84 c3 00 00 00    	je     cf47 <_ZN13ostringstream7write_dEdiic+0x8f7>
    ce84:	f6 c2 70             	test   $0x70,%dl
    ce87:	74 34                	je     cebd <_ZN13ostringstream7write_dEdiic+0x86d>
    ce89:	48 89 f7             	mov    %rsi,%rdi
    ce8c:	48 89 d6             	mov    %rdx,%rsi
    ce8f:	48 83 e6 f0          	and    $0xfffffffffffffff0,%rsi
    ce93:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    ce9a:	84 00 00 00 00 00 
    cea0:	c5 f9 10 04 39       	vmovupd (%rcx,%rdi,1),%xmm0
    cea5:	c4 c1 79 11 04 3f    	vmovupd %xmm0,(%r15,%rdi,1)
    ceab:	48 83 c7 10          	add    $0x10,%rdi
    ceaf:	48 39 fe             	cmp    %rdi,%rsi
    ceb2:	75 ec                	jne    cea0 <_ZN13ostringstream7write_dEdiic+0x850>
    ceb4:	48 39 d6             	cmp    %rdx,%rsi
    ceb7:	0f 84 8a 00 00 00    	je     cf47 <_ZN13ostringstream7write_dEdiic+0x8f7>
    cebd:	48 89 f7             	mov    %rsi,%rdi
    cec0:	48 f7 d7             	not    %rdi
    cec3:	48 01 d7             	add    %rdx,%rdi
    cec6:	49 89 d0             	mov    %rdx,%r8
    cec9:	49 83 e0 07          	and    $0x7,%r8
    cecd:	74 12                	je     cee1 <_ZN13ostringstream7write_dEdiic+0x891>
    cecf:	90                   	nop
    ced0:	44 0f b6 0c 31       	movzbl (%rcx,%rsi,1),%r9d
    ced5:	45 88 0c 37          	mov    %r9b,(%r15,%rsi,1)
    ced9:	48 ff c6             	inc    %rsi
    cedc:	49 ff c8             	dec    %r8
    cedf:	75 ef                	jne    ced0 <_ZN13ostringstream7write_dEdiic+0x880>
    cee1:	48 83 ff 07          	cmp    $0x7,%rdi
    cee5:	72 60                	jb     cf47 <_ZN13ostringstream7write_dEdiic+0x8f7>
    cee7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    ceee:	00 00 
    cef0:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
    cef4:	41 88 3c 37          	mov    %dil,(%r15,%rsi,1)
    cef8:	0f b6 7c 31 01       	movzbl 0x1(%rcx,%rsi,1),%edi
    cefd:	41 88 7c 37 01       	mov    %dil,0x1(%r15,%rsi,1)
    cf02:	0f b6 7c 31 02       	movzbl 0x2(%rcx,%rsi,1),%edi
    cf07:	41 88 7c 37 02       	mov    %dil,0x2(%r15,%rsi,1)
    cf0c:	0f b6 7c 31 03       	movzbl 0x3(%rcx,%rsi,1),%edi
    cf11:	41 88 7c 37 03       	mov    %dil,0x3(%r15,%rsi,1)
    cf16:	0f b6 7c 31 04       	movzbl 0x4(%rcx,%rsi,1),%edi
    cf1b:	41 88 7c 37 04       	mov    %dil,0x4(%r15,%rsi,1)
    cf20:	0f b6 7c 31 05       	movzbl 0x5(%rcx,%rsi,1),%edi
    cf25:	41 88 7c 37 05       	mov    %dil,0x5(%r15,%rsi,1)
    cf2a:	0f b6 7c 31 06       	movzbl 0x6(%rcx,%rsi,1),%edi
    cf2f:	41 88 7c 37 06       	mov    %dil,0x6(%r15,%rsi,1)
    cf34:	0f b6 7c 31 07       	movzbl 0x7(%rcx,%rsi,1),%edi
    cf39:	41 88 7c 37 07       	mov    %dil,0x7(%r15,%rsi,1)
    cf3e:	48 83 c6 08          	add    $0x8,%rsi
    cf42:	48 39 f2             	cmp    %rsi,%rdx
    cf45:	75 a9                	jne    cef0 <_ZN13ostringstream7write_dEdiic+0x8a0>
    cf47:	4c 89 54 24 10       	mov    %r10,0x10(%rsp)
    cf4c:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
    cf51:	89 44 24 08          	mov    %eax,0x8(%rsp)
    cf55:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
    cf5a:	44 8b 6c 24 08       	mov    0x8(%rsp),%r13d
    cf5f:	45 85 ed             	test   %r13d,%r13d
    cf62:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
    cf67:	7e 25                	jle    cf8e <_ZN13ostringstream7write_dEdiic+0x93e>
    cf69:	31 ed                	xor    %ebp,%ebp
    cf6b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    cf70:	41 0f b6 1c 2c       	movzbl (%r12,%rbp,1),%ebx
    cf75:	41 8b 76 08          	mov    0x8(%r14),%esi
    cf79:	4c 89 f7             	mov    %r14,%rdi
    cf7c:	c5 f8 77             	vzeroupper 
    cf7f:	e8 dc 2d 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    cf84:	88 18                	mov    %bl,(%rax)
    cf86:	48 ff c5             	inc    %rbp
    cf89:	49 39 ed             	cmp    %rbp,%r13
    cf8c:	75 e2                	jne    cf70 <_ZN13ostringstream7write_dEdiic+0x920>
    cf8e:	4d 85 ff             	test   %r15,%r15
    cf91:	74 2d                	je     cfc0 <_ZN13ostringstream7write_dEdiic+0x970>
    cf93:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
    cf98:	48 8b 01             	mov    (%rcx),%rax
    cf9b:	c5 f9 10 04 25 00 00 	vmovupd 0x1000000,%xmm0
    cfa2:	00 01 
    cfa4:	c5 f9 11 01          	vmovupd %xmm0,(%rcx)
    cfa8:	48 89 04 25 00 00 00 	mov    %rax,0x1000000
    cfaf:	01 
    cfb0:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    cfb7:	01 
    cfb8:	48 29 04 25 28 00 11 	sub    %rax,0x110028
    cfbf:	00 
    cfc0:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    cfc5:	48 85 c0             	test   %rax,%rax
    cfc8:	74 2e                	je     cff8 <_ZN13ostringstream7write_dEdiic+0x9a8>
    cfca:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    cfce:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    cfd2:	c5 f9 10 04 25 00 00 	vmovupd 0x1000000,%xmm0
    cfd9:	00 01 
    cfdb:	c5 f9 11 40 f0       	vmovupd %xmm0,-0x10(%rax)
    cfe0:	48 89 14 25 00 00 00 	mov    %rdx,0x1000000
    cfe7:	01 
    cfe8:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    cfef:	01 
    cff0:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    cff7:	00 
    cff8:	48 83 c4 58          	add    $0x58,%rsp
    cffc:	5b                   	pop    %rbx
    cffd:	41 5c                	pop    %r12
    cfff:	41 5d                	pop    %r13
    d001:	41 5e                	pop    %r14
    d003:	41 5f                	pop    %r15
    d005:	5d                   	pop    %rbp
    d006:	c5 f8 77             	vzeroupper 
    d009:	c3                   	ret    
    d00a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

000000000000d010 <_ZN13ostringstream7write_uEmiicPKc>:
    d010:	55                   	push   %rbp
    d011:	41 57                	push   %r15
    d013:	41 56                	push   %r14
    d015:	41 55                	push   %r13
    d017:	41 54                	push   %r12
    d019:	53                   	push   %rbx
    d01a:	48 83 ec 48          	sub    $0x48,%rsp
    d01e:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
    d023:	45 89 c4             	mov    %r8d,%r12d
    d026:	41 89 d7             	mov    %edx,%r15d
    d029:	48 89 fd             	mov    %rdi,%rbp
    d02c:	89 4c 24 1c          	mov    %ecx,0x1c(%rsp)
    d030:	4c 63 f1             	movslq %ecx,%r14
    d033:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    d038:	48 89 f1             	mov    %rsi,%rcx
    d03b:	eb 15                	jmp    d052 <_ZN13ostringstream7write_uEmiicPKc+0x42>
    d03d:	0f 1f 00             	nopl   (%rax)
    d040:	48 89 c8             	mov    %rcx,%rax
    d043:	31 d2                	xor    %edx,%edx
    d045:	49 f7 f6             	div    %r14
    d048:	ff c3                	inc    %ebx
    d04a:	4c 39 f1             	cmp    %r14,%rcx
    d04d:	48 89 c1             	mov    %rax,%rcx
    d050:	72 1e                	jb     d070 <_ZN13ostringstream7write_uEmiicPKc+0x60>
    d052:	48 89 c8             	mov    %rcx,%rax
    d055:	4c 09 f0             	or     %r14,%rax
    d058:	48 c1 e8 20          	shr    $0x20,%rax
    d05c:	75 e2                	jne    d040 <_ZN13ostringstream7write_uEmiicPKc+0x30>
    d05e:	89 c8                	mov    %ecx,%eax
    d060:	31 d2                	xor    %edx,%edx
    d062:	f7 74 24 1c          	divl   0x1c(%rsp)
    d066:	ff c3                	inc    %ebx
    d068:	4c 39 f1             	cmp    %r14,%rcx
    d06b:	48 89 c1             	mov    %rax,%rcx
    d06e:	73 e2                	jae    d052 <_ZN13ostringstream7write_uEmiicPKc+0x42>
    d070:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
    d075:	8d 43 01             	lea    0x1(%rbx),%eax
    d078:	89 44 24 10          	mov    %eax,0x10(%rsp)
    d07c:	44 39 f8             	cmp    %r15d,%eax
    d07f:	7d 25                	jge    d0a6 <_ZN13ostringstream7write_uEmiicPKc+0x96>
    d081:	41 29 df             	sub    %ebx,%r15d
    d084:	41 bd 01 00 00 00    	mov    $0x1,%r13d
    d08a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    d090:	8b 75 08             	mov    0x8(%rbp),%esi
    d093:	48 89 ef             	mov    %rbp,%rdi
    d096:	e8 c5 2c 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    d09b:	44 88 20             	mov    %r12b,(%rax)
    d09e:	41 ff c5             	inc    %r13d
    d0a1:	45 39 ef             	cmp    %r13d,%r15d
    d0a4:	75 ea                	jne    d090 <_ZN13ostringstream7write_uEmiicPKc+0x80>
    d0a6:	48 89 6c 24 38       	mov    %rbp,0x38(%rsp)
    d0ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
    d0b2:	00 
    d0b3:	81 e3 f0 ff ff 7f    	and    $0x7ffffff0,%ebx
    d0b9:	83 c3 20             	add    $0x20,%ebx
    d0bc:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    d0c3:	01 
    d0c4:	b9 00 00 00 01       	mov    $0x1000000,%ecx
    d0c9:	48 39 d8             	cmp    %rbx,%rax
    d0cc:	73 0e                	jae    d0dc <_ZN13ostringstream7write_uEmiicPKc+0xcc>
    d0ce:	66 90                	xchg   %ax,%ax
    d0d0:	48 8b 49 08          	mov    0x8(%rcx),%rcx
    d0d4:	48 8b 01             	mov    (%rcx),%rax
    d0d7:	48 39 d8             	cmp    %rbx,%rax
    d0da:	72 f4                	jb     d0d0 <_ZN13ostringstream7write_uEmiicPKc+0xc0>
    d0dc:	48 8b 51 08          	mov    0x8(%rcx),%rdx
    d0e0:	48 89 c6             	mov    %rax,%rsi
    d0e3:	48 29 de             	sub    %rbx,%rsi
    d0e6:	48 83 fe 0f          	cmp    $0xf,%rsi
    d0ea:	77 0a                	ja     d0f6 <_ZN13ostringstream7write_uEmiicPKc+0xe6>
    d0ec:	c5 f8 10 02          	vmovups (%rdx),%xmm0
    d0f0:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    d0f4:	eb 0d                	jmp    d103 <_ZN13ostringstream7write_uEmiicPKc+0xf3>
    d0f6:	48 89 31             	mov    %rsi,(%rcx)
    d0f9:	48 c1 e6 04          	shl    $0x4,%rsi
    d0fd:	48 01 f2             	add    %rsi,%rdx
    d100:	48 89 d8             	mov    %rbx,%rax
    d103:	4c 8b 7c 24 28       	mov    0x28(%rsp),%r15
    d108:	48 89 02             	mov    %rax,(%rdx)
    d10b:	48 01 04 25 28 00 11 	add    %rax,0x110028
    d112:	00 
    d113:	48 bb 00 00 00 00 fc 	movabs $0xfffffffc00000000,%rbx
    d11a:	ff ff ff 
    d11d:	48 83 c2 10          	add    $0x10,%rdx
    d121:	48 89 14 24          	mov    %rdx,(%rsp)
    d125:	8b 44 24 10          	mov    0x10(%rsp),%eax
    d129:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    d12d:	4c 89 74 24 30       	mov    %r14,0x30(%rsp)
    d132:	eb 29                	jmp    d15d <_ZN13ostringstream7write_uEmiicPKc+0x14d>
    d134:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    d13b:	00 00 00 00 00 
    d140:	48 89 e7             	mov    %rsp,%rdi
    d143:	31 f6                	xor    %esi,%esi
    d145:	e8 16 2c 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    d14a:	48 89 c5             	mov    %rax,%rbp
    d14d:	44 88 6d 00          	mov    %r13b,0x0(%rbp)
    d151:	4d 39 f7             	cmp    %r14,%r15
    d154:	4d 89 e7             	mov    %r12,%r15
    d157:	0f 82 8f 01 00 00    	jb     d2ec <_ZN13ostringstream7write_uEmiicPKc+0x2dc>
    d15d:	4c 89 f8             	mov    %r15,%rax
    d160:	4c 09 f0             	or     %r14,%rax
    d163:	48 c1 e8 20          	shr    $0x20,%rax
    d167:	74 27                	je     d190 <_ZN13ostringstream7write_uEmiicPKc+0x180>
    d169:	4c 89 f8             	mov    %r15,%rax
    d16c:	31 d2                	xor    %edx,%edx
    d16e:	49 f7 f6             	div    %r14
    d171:	49 89 c4             	mov    %rax,%r12
    d174:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
    d179:	44 0f b6 2c 10       	movzbl (%rax,%rdx,1),%r13d
    d17e:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    d183:	7f 28                	jg     d1ad <_ZN13ostringstream7write_uEmiicPKc+0x19d>
    d185:	eb b9                	jmp    d140 <_ZN13ostringstream7write_uEmiicPKc+0x130>
    d187:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    d18e:	00 00 
    d190:	44 89 f8             	mov    %r15d,%eax
    d193:	31 d2                	xor    %edx,%edx
    d195:	f7 74 24 1c          	divl   0x1c(%rsp)
    d199:	41 89 c4             	mov    %eax,%r12d
    d19c:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
    d1a1:	44 0f b6 2c 10       	movzbl (%rax,%rdx,1),%r13d
    d1a6:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    d1ab:	7e 93                	jle    d140 <_ZN13ostringstream7write_uEmiicPKc+0x130>
    d1ad:	45 89 ee             	mov    %r13d,%r14d
    d1b0:	4c 89 64 24 10       	mov    %r12,0x10(%rsp)
    d1b5:	4c 63 64 24 08       	movslq 0x8(%rsp),%r12
    d1ba:	48 8b 04 24          	mov    (%rsp),%rax
    d1be:	49 8d 6c 24 ff       	lea    -0x1(%r12),%rbp
    d1c3:	46 0f b6 6c 20 ff    	movzbl -0x1(%rax,%r12,1),%r13d
    d1c9:	48 89 e7             	mov    %rsp,%rdi
    d1cc:	44 89 e6             	mov    %r12d,%esi
    d1cf:	e8 8c 2b 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    d1d4:	44 88 28             	mov    %r13b,(%rax)
    d1d7:	49 83 fc 02          	cmp    $0x2,%r12
    d1db:	7c 53                	jl     d230 <_ZN13ostringstream7write_uEmiicPKc+0x220>
    d1dd:	48 89 e9             	mov    %rbp,%rcx
    d1e0:	44 89 e0             	mov    %r12d,%eax
    d1e3:	45 89 f5             	mov    %r14d,%r13d
    d1e6:	48 83 e1 03          	and    $0x3,%rcx
    d1ea:	74 20                	je     d20c <_ZN13ostringstream7write_uEmiicPKc+0x1fc>
    d1ec:	0f 1f 40 00          	nopl   0x0(%rax)
    d1f0:	48 8b 14 24          	mov    (%rsp),%rdx
    d1f4:	8d 70 fe             	lea    -0x2(%rax),%esi
    d1f7:	48 63 f6             	movslq %esi,%rsi
    d1fa:	0f b6 34 32          	movzbl (%rdx,%rsi,1),%esi
    d1fe:	40 88 34 2a          	mov    %sil,(%rdx,%rbp,1)
    d202:	48 ff cd             	dec    %rbp
    d205:	ff c8                	dec    %eax
    d207:	48 ff c9             	dec    %rcx
    d20a:	75 e4                	jne    d1f0 <_ZN13ostringstream7write_uEmiicPKc+0x1e0>
    d20c:	49 83 c4 fe          	add    $0xfffffffffffffffe,%r12
    d210:	49 83 fc 03          	cmp    $0x3,%r12
    d214:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
    d219:	73 27                	jae    d242 <_ZN13ostringstream7write_uEmiicPKc+0x232>
    d21b:	31 ed                	xor    %ebp,%ebp
    d21d:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
    d222:	e9 b1 00 00 00       	jmp    d2d8 <_ZN13ostringstream7write_uEmiicPKc+0x2c8>
    d227:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    d22e:	00 00 
    d230:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
    d235:	45 89 f5             	mov    %r14d,%r13d
    d238:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
    d23d:	e9 96 00 00 00       	jmp    d2d8 <_ZN13ostringstream7write_uEmiicPKc+0x2c8>
    d242:	48 8d 75 04          	lea    0x4(%rbp),%rsi
    d246:	48 c1 e5 20          	shl    $0x20,%rbp
    d24a:	48 8d 0c 2b          	lea    (%rbx,%rbp,1),%rcx
    d24e:	48 ba 00 00 00 00 fd 	movabs $0xfffffffd00000000,%rdx
    d255:	ff ff ff 
    d258:	48 01 ea             	add    %rbp,%rdx
    d25b:	48 bf 00 00 00 00 fe 	movabs $0xfffffffe00000000,%rdi
    d262:	ff ff ff 
    d265:	48 01 fd             	add    %rdi,%rbp
    d268:	4c 8b 64 24 10       	mov    0x10(%rsp),%r12
    d26d:	0f 1f 00             	nopl   (%rax)
    d270:	48 8b 3c 24          	mov    (%rsp),%rdi
    d274:	48 98                	cltq   
    d276:	0f b6 44 38 fe       	movzbl -0x2(%rax,%rdi,1),%eax
    d27b:	88 44 37 fc          	mov    %al,-0x4(%rdi,%rsi,1)
    d27f:	48 8b 04 24          	mov    (%rsp),%rax
    d283:	48 89 ef             	mov    %rbp,%rdi
    d286:	48 c1 ff 20          	sar    $0x20,%rdi
    d28a:	0f b6 3c 38          	movzbl (%rax,%rdi,1),%edi
    d28e:	40 88 7c 30 fb       	mov    %dil,-0x5(%rax,%rsi,1)
    d293:	48 8b 04 24          	mov    (%rsp),%rax
    d297:	48 89 d7             	mov    %rdx,%rdi
    d29a:	48 c1 ff 20          	sar    $0x20,%rdi
    d29e:	0f b6 3c 38          	movzbl (%rax,%rdi,1),%edi
    d2a2:	40 88 7c 30 fa       	mov    %dil,-0x6(%rax,%rsi,1)
    d2a7:	48 8b 04 24          	mov    (%rsp),%rax
    d2ab:	48 89 cf             	mov    %rcx,%rdi
    d2ae:	48 c1 ff 20          	sar    $0x20,%rdi
    d2b2:	0f b6 3c 38          	movzbl (%rax,%rdi,1),%edi
    d2b6:	40 88 7c 30 f9       	mov    %dil,-0x7(%rax,%rsi,1)
    d2bb:	89 f0                	mov    %esi,%eax
    d2bd:	48 8d 7e fc          	lea    -0x4(%rsi),%rdi
    d2c1:	48 01 d9             	add    %rbx,%rcx
    d2c4:	48 01 da             	add    %rbx,%rdx
    d2c7:	48 01 dd             	add    %rbx,%rbp
    d2ca:	83 c0 f9             	add    $0xfffffff9,%eax
    d2cd:	48 89 fe             	mov    %rdi,%rsi
    d2d0:	48 83 ff 04          	cmp    $0x4,%rdi
    d2d4:	7f 9a                	jg     d270 <_ZN13ostringstream7write_uEmiicPKc+0x260>
    d2d6:	31 ed                	xor    %ebp,%ebp
    d2d8:	48 03 2c 24          	add    (%rsp),%rbp
    d2dc:	44 88 6d 00          	mov    %r13b,0x0(%rbp)
    d2e0:	4d 39 f7             	cmp    %r14,%r15
    d2e3:	4d 89 e7             	mov    %r12,%r15
    d2e6:	0f 83 71 fe ff ff    	jae    d15d <_ZN13ostringstream7write_uEmiicPKc+0x14d>
    d2ec:	8b 44 24 08          	mov    0x8(%rsp),%eax
    d2f0:	48 8b 0c 24          	mov    (%rsp),%rcx
    d2f4:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
    d2f9:	89 44 24 18          	mov    %eax,0x18(%rsp)
    d2fd:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    d302:	8b 44 24 18          	mov    0x18(%rsp),%eax
    d306:	48 63 d0             	movslq %eax,%rdx
    d309:	48 8d 7a 1f          	lea    0x1f(%rdx),%rdi
    d30d:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
    d311:	be 10 00 00 00       	mov    $0x10,%esi
    d316:	48 0f 45 f7          	cmovne %rdi,%rsi
    d31a:	48 8b 3c 25 00 00 00 	mov    0x1000000,%rdi
    d321:	01 
    d322:	41 b8 00 00 00 01    	mov    $0x1000000,%r8d
    d328:	48 39 f7             	cmp    %rsi,%rdi
    d32b:	73 0f                	jae    d33c <_ZN13ostringstream7write_uEmiicPKc+0x32c>
    d32d:	0f 1f 00             	nopl   (%rax)
    d330:	4d 8b 40 08          	mov    0x8(%r8),%r8
    d334:	49 8b 38             	mov    (%r8),%rdi
    d337:	48 39 f7             	cmp    %rsi,%rdi
    d33a:	72 f4                	jb     d330 <_ZN13ostringstream7write_uEmiicPKc+0x320>
    d33c:	4d 8b 50 08          	mov    0x8(%r8),%r10
    d340:	49 89 f9             	mov    %rdi,%r9
    d343:	49 29 f1             	sub    %rsi,%r9
    d346:	49 83 f9 0f          	cmp    $0xf,%r9
    d34a:	77 0c                	ja     d358 <_ZN13ostringstream7write_uEmiicPKc+0x348>
    d34c:	c4 c1 78 10 02       	vmovups (%r10),%xmm0
    d351:	c4 c1 78 11 00       	vmovups %xmm0,(%r8)
    d356:	eb 0d                	jmp    d365 <_ZN13ostringstream7write_uEmiicPKc+0x355>
    d358:	4d 89 08             	mov    %r9,(%r8)
    d35b:	49 c1 e1 04          	shl    $0x4,%r9
    d35f:	4d 01 ca             	add    %r9,%r10
    d362:	48 89 f7             	mov    %rsi,%rdi
    d365:	49 8d 5a 10          	lea    0x10(%r10),%rbx
    d369:	49 89 3a             	mov    %rdi,(%r10)
    d36c:	48 01 3c 25 28 00 11 	add    %rdi,0x110028
    d373:	00 
    d374:	85 c0                	test   %eax,%eax
    d376:	0f 8e 2b 01 00 00    	jle    d4a7 <_ZN13ostringstream7write_uEmiicPKc+0x497>
    d37c:	31 f6                	xor    %esi,%esi
    d37e:	83 f8 10             	cmp    $0x10,%eax
    d381:	0f 82 95 00 00 00    	jb     d41c <_ZN13ostringstream7write_uEmiicPKc+0x40c>
    d387:	48 89 df             	mov    %rbx,%rdi
    d38a:	48 29 cf             	sub    %rcx,%rdi
    d38d:	48 81 ff 80 00 00 00 	cmp    $0x80,%rdi
    d394:	0f 82 82 00 00 00    	jb     d41c <_ZN13ostringstream7write_uEmiicPKc+0x40c>
    d39a:	3d 80 00 00 00       	cmp    $0x80,%eax
    d39f:	73 04                	jae    d3a5 <_ZN13ostringstream7write_uEmiicPKc+0x395>
    d3a1:	31 f6                	xor    %esi,%esi
    d3a3:	eb 50                	jmp    d3f5 <_ZN13ostringstream7write_uEmiicPKc+0x3e5>
    d3a5:	48 89 d6             	mov    %rdx,%rsi
    d3a8:	48 83 e6 80          	and    $0xffffffffffffff80,%rsi
    d3ac:	31 ff                	xor    %edi,%edi
    d3ae:	66 90                	xchg   %ax,%ax
    d3b0:	c5 fc 10 04 39       	vmovups (%rcx,%rdi,1),%ymm0
    d3b5:	c5 fc 10 4c 39 20    	vmovups 0x20(%rcx,%rdi,1),%ymm1
    d3bb:	c5 fc 10 54 39 40    	vmovups 0x40(%rcx,%rdi,1),%ymm2
    d3c1:	c5 fc 10 5c 39 60    	vmovups 0x60(%rcx,%rdi,1),%ymm3
    d3c7:	c5 fc 11 04 3b       	vmovups %ymm0,(%rbx,%rdi,1)
    d3cc:	c5 fc 11 4c 3b 20    	vmovups %ymm1,0x20(%rbx,%rdi,1)
    d3d2:	c5 fc 11 54 3b 40    	vmovups %ymm2,0x40(%rbx,%rdi,1)
    d3d8:	c5 fc 11 5c 3b 60    	vmovups %ymm3,0x60(%rbx,%rdi,1)
    d3de:	48 83 ef 80          	sub    $0xffffffffffffff80,%rdi
    d3e2:	48 39 fe             	cmp    %rdi,%rsi
    d3e5:	75 c9                	jne    d3b0 <_ZN13ostringstream7write_uEmiicPKc+0x3a0>
    d3e7:	48 39 d6             	cmp    %rdx,%rsi
    d3ea:	0f 84 b7 00 00 00    	je     d4a7 <_ZN13ostringstream7write_uEmiicPKc+0x497>
    d3f0:	f6 c2 70             	test   $0x70,%dl
    d3f3:	74 27                	je     d41c <_ZN13ostringstream7write_uEmiicPKc+0x40c>
    d3f5:	48 89 f7             	mov    %rsi,%rdi
    d3f8:	48 89 d6             	mov    %rdx,%rsi
    d3fb:	48 83 e6 f0          	and    $0xfffffffffffffff0,%rsi
    d3ff:	90                   	nop
    d400:	c5 f8 10 04 39       	vmovups (%rcx,%rdi,1),%xmm0
    d405:	c5 f8 11 04 3b       	vmovups %xmm0,(%rbx,%rdi,1)
    d40a:	48 83 c7 10          	add    $0x10,%rdi
    d40e:	48 39 fe             	cmp    %rdi,%rsi
    d411:	75 ed                	jne    d400 <_ZN13ostringstream7write_uEmiicPKc+0x3f0>
    d413:	48 39 d6             	cmp    %rdx,%rsi
    d416:	0f 84 8b 00 00 00    	je     d4a7 <_ZN13ostringstream7write_uEmiicPKc+0x497>
    d41c:	48 89 f7             	mov    %rsi,%rdi
    d41f:	48 f7 d7             	not    %rdi
    d422:	48 01 d7             	add    %rdx,%rdi
    d425:	49 89 d0             	mov    %rdx,%r8
    d428:	49 83 e0 07          	and    $0x7,%r8
    d42c:	74 13                	je     d441 <_ZN13ostringstream7write_uEmiicPKc+0x431>
    d42e:	66 90                	xchg   %ax,%ax
    d430:	44 0f b6 0c 31       	movzbl (%rcx,%rsi,1),%r9d
    d435:	44 88 0c 33          	mov    %r9b,(%rbx,%rsi,1)
    d439:	48 ff c6             	inc    %rsi
    d43c:	49 ff c8             	dec    %r8
    d43f:	75 ef                	jne    d430 <_ZN13ostringstream7write_uEmiicPKc+0x420>
    d441:	48 83 ff 07          	cmp    $0x7,%rdi
    d445:	72 60                	jb     d4a7 <_ZN13ostringstream7write_uEmiicPKc+0x497>
    d447:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    d44e:	00 00 
    d450:	0f b6 3c 31          	movzbl (%rcx,%rsi,1),%edi
    d454:	40 88 3c 33          	mov    %dil,(%rbx,%rsi,1)
    d458:	0f b6 7c 31 01       	movzbl 0x1(%rcx,%rsi,1),%edi
    d45d:	40 88 7c 33 01       	mov    %dil,0x1(%rbx,%rsi,1)
    d462:	0f b6 7c 31 02       	movzbl 0x2(%rcx,%rsi,1),%edi
    d467:	40 88 7c 33 02       	mov    %dil,0x2(%rbx,%rsi,1)
    d46c:	0f b6 7c 31 03       	movzbl 0x3(%rcx,%rsi,1),%edi
    d471:	40 88 7c 33 03       	mov    %dil,0x3(%rbx,%rsi,1)
    d476:	0f b6 7c 31 04       	movzbl 0x4(%rcx,%rsi,1),%edi
    d47b:	40 88 7c 33 04       	mov    %dil,0x4(%rbx,%rsi,1)
    d480:	0f b6 7c 31 05       	movzbl 0x5(%rcx,%rsi,1),%edi
    d485:	40 88 7c 33 05       	mov    %dil,0x5(%rbx,%rsi,1)
    d48a:	0f b6 7c 31 06       	movzbl 0x6(%rcx,%rsi,1),%edi
    d48f:	40 88 7c 33 06       	mov    %dil,0x6(%rbx,%rsi,1)
    d494:	0f b6 7c 31 07       	movzbl 0x7(%rcx,%rsi,1),%edi
    d499:	40 88 7c 33 07       	mov    %dil,0x7(%rbx,%rsi,1)
    d49e:	48 83 c6 08          	add    $0x8,%rsi
    d4a2:	48 39 f2             	cmp    %rsi,%rdx
    d4a5:	75 a9                	jne    d450 <_ZN13ostringstream7write_uEmiicPKc+0x440>
    d4a7:	4c 89 54 24 10       	mov    %r10,0x10(%rsp)
    d4ac:	48 89 5c 24 20       	mov    %rbx,0x20(%rsp)
    d4b1:	89 44 24 18          	mov    %eax,0x18(%rsp)
    d4b5:	4c 8b 7c 24 20       	mov    0x20(%rsp),%r15
    d4ba:	44 8b 64 24 18       	mov    0x18(%rsp),%r12d
    d4bf:	45 85 e4             	test   %r12d,%r12d
    d4c2:	4c 8b 74 24 38       	mov    0x38(%rsp),%r14
    d4c7:	7e 26                	jle    d4ef <_ZN13ostringstream7write_uEmiicPKc+0x4df>
    d4c9:	45 31 ed             	xor    %r13d,%r13d
    d4cc:	0f 1f 40 00          	nopl   0x0(%rax)
    d4d0:	43 0f b6 2c 2f       	movzbl (%r15,%r13,1),%ebp
    d4d5:	41 8b 76 08          	mov    0x8(%r14),%esi
    d4d9:	4c 89 f7             	mov    %r14,%rdi
    d4dc:	c5 f8 77             	vzeroupper 
    d4df:	e8 7c 28 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    d4e4:	40 88 28             	mov    %bpl,(%rax)
    d4e7:	49 ff c5             	inc    %r13
    d4ea:	4d 39 ec             	cmp    %r13,%r12
    d4ed:	75 e1                	jne    d4d0 <_ZN13ostringstream7write_uEmiicPKc+0x4c0>
    d4ef:	48 85 db             	test   %rbx,%rbx
    d4f2:	74 2d                	je     d521 <_ZN13ostringstream7write_uEmiicPKc+0x511>
    d4f4:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
    d4f9:	48 8b 01             	mov    (%rcx),%rax
    d4fc:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    d503:	00 01 
    d505:	c5 f8 11 01          	vmovups %xmm0,(%rcx)
    d509:	48 89 04 25 00 00 00 	mov    %rax,0x1000000
    d510:	01 
    d511:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    d518:	01 
    d519:	48 29 04 25 28 00 11 	sub    %rax,0x110028
    d520:	00 
    d521:	48 8b 04 24          	mov    (%rsp),%rax
    d525:	48 85 c0             	test   %rax,%rax
    d528:	74 2e                	je     d558 <_ZN13ostringstream7write_uEmiicPKc+0x548>
    d52a:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    d52e:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    d532:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    d539:	00 01 
    d53b:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    d540:	48 89 14 25 00 00 00 	mov    %rdx,0x1000000
    d547:	01 
    d548:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    d54f:	01 
    d550:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    d557:	00 
    d558:	48 83 c4 48          	add    $0x48,%rsp
    d55c:	5b                   	pop    %rbx
    d55d:	41 5c                	pop    %r12
    d55f:	41 5d                	pop    %r13
    d561:	41 5e                	pop    %r14
    d563:	41 5f                	pop    %r15
    d565:	5d                   	pop    %rbp
    d566:	c5 f8 77             	vzeroupper 
    d569:	c3                   	ret    
    d56a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

000000000000d570 <_ZN13istringstream4readIlEET_v>:
    d570:	8b 47 10             	mov    0x10(%rdi),%eax
    d573:	8d 50 01             	lea    0x1(%rax),%edx
    d576:	89 57 10             	mov    %edx,0x10(%rdi)
    d579:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    d57d:	74 78                	je     d5f7 <_ZN13istringstream4readIlEET_v+0x87>
    d57f:	48 63 c8             	movslq %eax,%rcx
    d582:	48 8b 37             	mov    (%rdi),%rsi
    d585:	80 3c 0e 2d          	cmpb   $0x2d,(%rsi,%rcx,1)
    d589:	0f 85 f3 00 00 00    	jne    d682 <_ZN13istringstream4readIlEET_v+0x112>
    d58f:	89 57 10             	mov    %edx,0x10(%rdi)
    d592:	b1 01                	mov    $0x1,%cl
    d594:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    d598:	0f 84 52 02 00 00    	je     d7f0 <_ZN13istringstream4readIlEET_v+0x280>
    d59e:	89 d0                	mov    %edx,%eax
    d5a0:	8d 70 01             	lea    0x1(%rax),%esi
    d5a3:	89 77 10             	mov    %esi,0x10(%rdi)
    d5a6:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    d5aa:	0f 85 e4 00 00 00    	jne    d694 <_ZN13istringstream4readIlEET_v+0x124>
    d5b0:	31 d2                	xor    %edx,%edx
    d5b2:	48 8b 34 25 00 00 00 	mov    0x1000000,%rsi
    d5b9:	01 
    d5ba:	41 b8 00 00 00 01    	mov    $0x1000000,%r8d
    d5c0:	48 83 fe 1f          	cmp    $0x1f,%rsi
    d5c4:	77 17                	ja     d5dd <_ZN13istringstream4readIlEET_v+0x6d>
    d5c6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    d5cd:	00 00 00 
    d5d0:	4d 8b 40 08          	mov    0x8(%r8),%r8
    d5d4:	49 8b 30             	mov    (%r8),%rsi
    d5d7:	48 83 fe 20          	cmp    $0x20,%rsi
    d5db:	72 f3                	jb     d5d0 <_ZN13istringstream4readIlEET_v+0x60>
    d5dd:	4d 8b 48 08          	mov    0x8(%r8),%r9
    d5e1:	4c 8d 56 e0          	lea    -0x20(%rsi),%r10
    d5e5:	49 83 fa 0f          	cmp    $0xf,%r10
    d5e9:	77 4a                	ja     d635 <_ZN13istringstream4readIlEET_v+0xc5>
    d5eb:	c4 c1 78 10 01       	vmovups (%r9),%xmm0
    d5f0:	c4 c1 78 11 00       	vmovups %xmm0,(%r8)
    d5f5:	eb 4d                	jmp    d644 <_ZN13istringstream4readIlEET_v+0xd4>
    d5f7:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    d5fe:	01 
    d5ff:	ba 00 00 00 01       	mov    $0x1000000,%edx
    d604:	48 83 f9 1f          	cmp    $0x1f,%rcx
    d608:	77 13                	ja     d61d <_ZN13istringstream4readIlEET_v+0xad>
    d60a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    d610:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    d614:	48 8b 0a             	mov    (%rdx),%rcx
    d617:	48 83 f9 20          	cmp    $0x20,%rcx
    d61b:	72 f3                	jb     d610 <_ZN13istringstream4readIlEET_v+0xa0>
    d61d:	48 8b 72 08          	mov    0x8(%rdx),%rsi
    d621:	4c 8d 41 e0          	lea    -0x20(%rcx),%r8
    d625:	49 83 f8 0f          	cmp    $0xf,%r8
    d629:	77 39                	ja     d664 <_ZN13istringstream4readIlEET_v+0xf4>
    d62b:	c5 f8 10 06          	vmovups (%rsi),%xmm0
    d62f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    d633:	eb 3e                	jmp    d673 <_ZN13istringstream4readIlEET_v+0x103>
    d635:	4d 89 10             	mov    %r10,(%r8)
    d638:	49 c1 e2 04          	shl    $0x4,%r10
    d63c:	4d 01 d1             	add    %r10,%r9
    d63f:	be 20 00 00 00       	mov    $0x20,%esi
    d644:	49 89 31             	mov    %rsi,(%r9)
    d647:	48 01 34 25 28 00 11 	add    %rsi,0x110028
    d64e:	00 
    d64f:	41 c6 41 10 00       	movb   $0x0,0x10(%r9)
    d654:	89 47 10             	mov    %eax,0x10(%rdi)
    d657:	48 89 d0             	mov    %rdx,%rax
    d65a:	48 f7 d8             	neg    %rax
    d65d:	84 c9                	test   %cl,%cl
    d65f:	48 0f 44 c2          	cmove  %rdx,%rax
    d663:	c3                   	ret    
    d664:	4c 89 02             	mov    %r8,(%rdx)
    d667:	49 c1 e0 04          	shl    $0x4,%r8
    d66b:	4c 01 c6             	add    %r8,%rsi
    d66e:	b9 20 00 00 00       	mov    $0x20,%ecx
    d673:	48 89 0e             	mov    %rcx,(%rsi)
    d676:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    d67d:	00 
    d67e:	c6 46 10 00          	movb   $0x0,0x10(%rsi)
    d682:	31 c9                	xor    %ecx,%ecx
    d684:	8d 70 01             	lea    0x1(%rax),%esi
    d687:	89 77 10             	mov    %esi,0x10(%rdi)
    d68a:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    d68e:	0f 84 1c ff ff ff    	je     d5b0 <_ZN13istringstream4readIlEET_v+0x40>
    d694:	31 d2                	xor    %edx,%edx
    d696:	eb 34                	jmp    d6cc <_ZN13istringstream4readIlEET_v+0x15c>
    d698:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    d69f:	00 
    d6a0:	4c 8b 07             	mov    (%rdi),%r8
    d6a3:	45 0f b6 04 00       	movzbl (%r8,%rax,1),%r8d
    d6a8:	89 f0                	mov    %esi,%eax
    d6aa:	48 01 d2             	add    %rdx,%rdx
    d6ad:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
    d6b1:	49 0f be f0          	movsbq %r8b,%rsi
    d6b5:	48 01 f2             	add    %rsi,%rdx
    d6b8:	48 83 c2 d0          	add    $0xffffffffffffffd0,%rdx
    d6bc:	8d 70 01             	lea    0x1(%rax),%esi
    d6bf:	89 77 10             	mov    %esi,0x10(%rdi)
    d6c2:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    d6c6:	0f 84 e6 fe ff ff    	je     d5b2 <_ZN13istringstream4readIlEET_v+0x42>
    d6cc:	4c 8b 07             	mov    (%rdi),%r8
    d6cf:	48 98                	cltq   
    d6d1:	45 0f b6 0c 00       	movzbl (%r8,%rax,1),%r9d
    d6d6:	89 47 10             	mov    %eax,0x10(%rdi)
    d6d9:	41 80 f9 30          	cmp    $0x30,%r9b
    d6dd:	0f 8c 74 ff ff ff    	jl     d657 <_ZN13istringstream4readIlEET_v+0xe7>
    d6e3:	89 77 10             	mov    %esi,0x10(%rdi)
    d6e6:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    d6ea:	74 24                	je     d710 <_ZN13istringstream4readIlEET_v+0x1a0>
    d6ec:	45 0f b6 04 00       	movzbl (%r8,%rax,1),%r8d
    d6f1:	89 47 10             	mov    %eax,0x10(%rdi)
    d6f4:	41 80 f8 39          	cmp    $0x39,%r8b
    d6f8:	0f 8f 59 ff ff ff    	jg     d657 <_ZN13istringstream4readIlEET_v+0xe7>
    d6fe:	89 77 10             	mov    %esi,0x10(%rdi)
    d701:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    d705:	75 99                	jne    d6a0 <_ZN13istringstream4readIlEET_v+0x130>
    d707:	eb 7b                	jmp    d784 <_ZN13istringstream4readIlEET_v+0x214>
    d709:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    d710:	4c 8b 04 25 00 00 00 	mov    0x1000000,%r8
    d717:	01 
    d718:	41 b9 00 00 00 01    	mov    $0x1000000,%r9d
    d71e:	49 83 f8 1f          	cmp    $0x1f,%r8
    d722:	77 19                	ja     d73d <_ZN13istringstream4readIlEET_v+0x1cd>
    d724:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    d72b:	00 00 00 00 00 
    d730:	4d 8b 49 08          	mov    0x8(%r9),%r9
    d734:	4d 8b 01             	mov    (%r9),%r8
    d737:	49 83 f8 20          	cmp    $0x20,%r8
    d73b:	72 f3                	jb     d730 <_ZN13istringstream4readIlEET_v+0x1c0>
    d73d:	4d 8b 51 08          	mov    0x8(%r9),%r10
    d741:	4d 8d 58 e0          	lea    -0x20(%r8),%r11
    d745:	49 83 fb 0f          	cmp    $0xf,%r11
    d749:	77 0c                	ja     d757 <_ZN13istringstream4readIlEET_v+0x1e7>
    d74b:	c4 c1 78 10 02       	vmovups (%r10),%xmm0
    d750:	c4 c1 78 11 01       	vmovups %xmm0,(%r9)
    d755:	eb 10                	jmp    d767 <_ZN13istringstream4readIlEET_v+0x1f7>
    d757:	4d 89 19             	mov    %r11,(%r9)
    d75a:	49 c1 e3 04          	shl    $0x4,%r11
    d75e:	4d 01 da             	add    %r11,%r10
    d761:	41 b8 20 00 00 00    	mov    $0x20,%r8d
    d767:	4d 89 02             	mov    %r8,(%r10)
    d76a:	4c 01 04 25 28 00 11 	add    %r8,0x110028
    d771:	00 
    d772:	41 c6 42 10 00       	movb   $0x0,0x10(%r10)
    d777:	89 77 10             	mov    %esi,0x10(%rdi)
    d77a:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    d77e:	0f 85 1c ff ff ff    	jne    d6a0 <_ZN13istringstream4readIlEET_v+0x130>
    d784:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    d78b:	01 
    d78c:	be 00 00 00 01       	mov    $0x1000000,%esi
    d791:	48 83 f8 1f          	cmp    $0x1f,%rax
    d795:	77 16                	ja     d7ad <_ZN13istringstream4readIlEET_v+0x23d>
    d797:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    d79e:	00 00 
    d7a0:	48 8b 76 08          	mov    0x8(%rsi),%rsi
    d7a4:	48 8b 06             	mov    (%rsi),%rax
    d7a7:	48 83 f8 20          	cmp    $0x20,%rax
    d7ab:	72 f3                	jb     d7a0 <_ZN13istringstream4readIlEET_v+0x230>
    d7ad:	4c 8b 46 08          	mov    0x8(%rsi),%r8
    d7b1:	4c 8d 48 e0          	lea    -0x20(%rax),%r9
    d7b5:	49 83 f9 0f          	cmp    $0xf,%r9
    d7b9:	77 0b                	ja     d7c6 <_ZN13istringstream4readIlEET_v+0x256>
    d7bb:	c4 c1 78 10 00       	vmovups (%r8),%xmm0
    d7c0:	c5 f8 11 06          	vmovups %xmm0,(%rsi)
    d7c4:	eb 0f                	jmp    d7d5 <_ZN13istringstream4readIlEET_v+0x265>
    d7c6:	4c 89 0e             	mov    %r9,(%rsi)
    d7c9:	49 c1 e1 04          	shl    $0x4,%r9
    d7cd:	4d 01 c8             	add    %r9,%r8
    d7d0:	b8 20 00 00 00       	mov    $0x20,%eax
    d7d5:	49 89 00             	mov    %rax,(%r8)
    d7d8:	48 01 04 25 28 00 11 	add    %rax,0x110028
    d7df:	00 
    d7e0:	41 c6 40 10 00       	movb   $0x0,0x10(%r8)
    d7e5:	8b 77 10             	mov    0x10(%rdi),%esi
    d7e8:	45 31 c0             	xor    %r8d,%r8d
    d7eb:	e9 b8 fe ff ff       	jmp    d6a8 <_ZN13istringstream4readIlEET_v+0x138>
    d7f0:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    d7f7:	01 
    d7f8:	ba 00 00 00 01       	mov    $0x1000000,%edx
    d7fd:	48 83 f8 1f          	cmp    $0x1f,%rax
    d801:	77 1a                	ja     d81d <_ZN13istringstream4readIlEET_v+0x2ad>
    d803:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    d80a:	84 00 00 00 00 00 
    d810:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    d814:	48 8b 02             	mov    (%rdx),%rax
    d817:	48 83 f8 20          	cmp    $0x20,%rax
    d81b:	72 f3                	jb     d810 <_ZN13istringstream4readIlEET_v+0x2a0>
    d81d:	48 8b 72 08          	mov    0x8(%rdx),%rsi
    d821:	4c 8d 40 e0          	lea    -0x20(%rax),%r8
    d825:	49 83 f8 0f          	cmp    $0xf,%r8
    d829:	77 0a                	ja     d835 <_ZN13istringstream4readIlEET_v+0x2c5>
    d82b:	c5 f8 10 06          	vmovups (%rsi),%xmm0
    d82f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    d833:	eb 0f                	jmp    d844 <_ZN13istringstream4readIlEET_v+0x2d4>
    d835:	4c 89 02             	mov    %r8,(%rdx)
    d838:	49 c1 e0 04          	shl    $0x4,%r8
    d83c:	4c 01 c6             	add    %r8,%rsi
    d83f:	b8 20 00 00 00       	mov    $0x20,%eax
    d844:	48 89 06             	mov    %rax,(%rsi)
    d847:	48 01 04 25 28 00 11 	add    %rax,0x110028
    d84e:	00 
    d84f:	c6 46 10 00          	movb   $0x0,0x10(%rsi)
    d853:	8b 47 10             	mov    0x10(%rdi),%eax
    d856:	8d 70 01             	lea    0x1(%rax),%esi
    d859:	89 77 10             	mov    %esi,0x10(%rdi)
    d85c:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    d860:	0f 85 2e fe ff ff    	jne    d694 <_ZN13istringstream4readIlEET_v+0x124>
    d866:	e9 45 fd ff ff       	jmp    d5b0 <_ZN13istringstream4readIlEET_v+0x40>
    d86b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

000000000000d870 <_ZN13istringstream18read_until_any_incE8rostring>:
    d870:	53                   	push   %rbx
    d871:	48 89 f8             	mov    %rdi,%rax
    d874:	8b 7e 10             	mov    0x10(%rsi),%edi
    d877:	48 63 cf             	movslq %edi,%rcx
    d87a:	83 7e 08 00          	cmpl   $0x0,0x8(%rsi)
    d87e:	74 20                	je     d8a0 <_ZN13istringstream18read_until_any_incE8rostring+0x30>
    d880:	48 63 ff             	movslq %edi,%rdi
    d883:	48 03 3e             	add    (%rsi),%rdi
    d886:	83 7a 08 00          	cmpl   $0x0,0x8(%rdx)
    d88a:	0f 8f 8e 00 00 00    	jg     d91e <_ZN13istringstream18read_until_any_incE8rostring+0xae>
    d890:	e9 50 01 00 00       	jmp    d9e5 <_ZN13istringstream18read_until_any_incE8rostring+0x175>
    d895:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    d89c:	00 00 00 00 
    d8a0:	4c 8b 04 25 00 00 00 	mov    0x1000000,%r8
    d8a7:	01 
    d8a8:	bf 00 00 00 01       	mov    $0x1000000,%edi
    d8ad:	49 83 f8 1f          	cmp    $0x1f,%r8
    d8b1:	77 1a                	ja     d8cd <_ZN13istringstream18read_until_any_incE8rostring+0x5d>
    d8b3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    d8ba:	84 00 00 00 00 00 
    d8c0:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
    d8c4:	4c 8b 07             	mov    (%rdi),%r8
    d8c7:	49 83 f8 20          	cmp    $0x20,%r8
    d8cb:	72 f3                	jb     d8c0 <_ZN13istringstream18read_until_any_incE8rostring+0x50>
    d8cd:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
    d8d1:	4d 8d 50 e0          	lea    -0x20(%r8),%r10
    d8d5:	49 83 fa 0f          	cmp    $0xf,%r10
    d8d9:	77 15                	ja     d8f0 <_ZN13istringstream18read_until_any_incE8rostring+0x80>
    d8db:	c4 c1 78 10 01       	vmovups (%r9),%xmm0
    d8e0:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    d8e4:	eb 1a                	jmp    d900 <_ZN13istringstream18read_until_any_incE8rostring+0x90>
    d8e6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    d8ed:	00 00 00 
    d8f0:	4c 89 17             	mov    %r10,(%rdi)
    d8f3:	49 c1 e2 04          	shl    $0x4,%r10
    d8f7:	4d 01 d1             	add    %r10,%r9
    d8fa:	41 b8 20 00 00 00    	mov    $0x20,%r8d
    d900:	49 8d 79 10          	lea    0x10(%r9),%rdi
    d904:	4d 89 01             	mov    %r8,(%r9)
    d907:	4c 01 04 25 28 00 11 	add    %r8,0x110028
    d90e:	00 
    d90f:	41 c6 41 10 00       	movb   $0x0,0x10(%r9)
    d914:	83 7a 08 00          	cmpl   $0x0,0x8(%rdx)
    d918:	0f 8e c7 00 00 00    	jle    d9e5 <_ZN13istringstream18read_until_any_incE8rostring+0x175>
    d91e:	45 31 c0             	xor    %r8d,%r8d
    d921:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    d928:	0f 1f 84 00 00 00 00 
    d92f:	00 
    d930:	83 7a 08 00          	cmpl   $0x0,0x8(%rdx)
    d934:	74 1a                	je     d950 <_ZN13istringstream18read_until_any_incE8rostring+0xe0>
    d936:	4c 8b 0a             	mov    (%rdx),%r9
    d939:	47 0f b6 0c 01       	movzbl (%r9,%r8,1),%r9d
    d93e:	44 3a 0f             	cmp    (%rdi),%r9b
    d941:	75 7c                	jne    d9bf <_ZN13istringstream18read_until_any_incE8rostring+0x14f>
    d943:	e9 98 00 00 00       	jmp    d9e0 <_ZN13istringstream18read_until_any_incE8rostring+0x170>
    d948:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    d94f:	00 
    d950:	4c 8b 0c 25 00 00 00 	mov    0x1000000,%r9
    d957:	01 
    d958:	41 ba 00 00 00 01    	mov    $0x1000000,%r10d
    d95e:	49 83 f9 1f          	cmp    $0x1f,%r9
    d962:	77 19                	ja     d97d <_ZN13istringstream18read_until_any_incE8rostring+0x10d>
    d964:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    d96b:	00 00 00 00 00 
    d970:	4d 8b 52 08          	mov    0x8(%r10),%r10
    d974:	4d 8b 0a             	mov    (%r10),%r9
    d977:	49 83 f9 20          	cmp    $0x20,%r9
    d97b:	72 f3                	jb     d970 <_ZN13istringstream18read_until_any_incE8rostring+0x100>
    d97d:	4d 8b 5a 08          	mov    0x8(%r10),%r11
    d981:	49 8d 59 e0          	lea    -0x20(%r9),%rbx
    d985:	48 83 fb 0f          	cmp    $0xf,%rbx
    d989:	77 0c                	ja     d997 <_ZN13istringstream18read_until_any_incE8rostring+0x127>
    d98b:	c4 c1 78 10 03       	vmovups (%r11),%xmm0
    d990:	c4 c1 78 11 02       	vmovups %xmm0,(%r10)
    d995:	eb 10                	jmp    d9a7 <_ZN13istringstream18read_until_any_incE8rostring+0x137>
    d997:	49 89 1a             	mov    %rbx,(%r10)
    d99a:	48 c1 e3 04          	shl    $0x4,%rbx
    d99e:	49 01 db             	add    %rbx,%r11
    d9a1:	41 b9 20 00 00 00    	mov    $0x20,%r9d
    d9a7:	4d 89 0b             	mov    %r9,(%r11)
    d9aa:	4c 01 0c 25 28 00 11 	add    %r9,0x110028
    d9b1:	00 
    d9b2:	41 c6 43 10 00       	movb   $0x0,0x10(%r11)
    d9b7:	45 31 c9             	xor    %r9d,%r9d
    d9ba:	44 3a 0f             	cmp    (%rdi),%r9b
    d9bd:	74 21                	je     d9e0 <_ZN13istringstream18read_until_any_incE8rostring+0x170>
    d9bf:	49 ff c0             	inc    %r8
    d9c2:	4c 63 4a 08          	movslq 0x8(%rdx),%r9
    d9c6:	4d 39 c8             	cmp    %r9,%r8
    d9c9:	0f 8c 61 ff ff ff    	jl     d930 <_ZN13istringstream18read_until_any_incE8rostring+0xc0>
    d9cf:	eb 14                	jmp    d9e5 <_ZN13istringstream18read_until_any_incE8rostring+0x175>
    d9d1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    d9d8:	0f 1f 84 00 00 00 00 
    d9df:	00 
    d9e0:	45 85 c0             	test   %r8d,%r8d
    d9e3:	79 1c                	jns    da01 <_ZN13istringstream18read_until_any_incE8rostring+0x191>
    d9e5:	8b 7e 10             	mov    0x10(%rsi),%edi
    d9e8:	3b 7e 08             	cmp    0x8(%rsi),%edi
    d9eb:	7d 17                	jge    da04 <_ZN13istringstream18read_until_any_incE8rostring+0x194>
    d9ed:	ff c7                	inc    %edi
    d9ef:	89 7e 10             	mov    %edi,0x10(%rsi)
    d9f2:	83 7e 08 00          	cmpl   $0x0,0x8(%rsi)
    d9f6:	0f 85 84 fe ff ff    	jne    d880 <_ZN13istringstream18read_until_any_incE8rostring+0x10>
    d9fc:	e9 9f fe ff ff       	jmp    d8a0 <_ZN13istringstream18read_until_any_incE8rostring+0x30>
    da01:	8b 7e 10             	mov    0x10(%rsi),%edi
    da04:	3b 7e 08             	cmp    0x8(%rsi),%edi
    da07:	7d 05                	jge    da0e <_ZN13istringstream18read_until_any_incE8rostring+0x19e>
    da09:	ff c7                	inc    %edi
    da0b:	89 7e 10             	mov    %edi,0x10(%rsi)
    da0e:	29 cf                	sub    %ecx,%edi
    da10:	48 03 0e             	add    (%rsi),%rcx
    da13:	48 89 08             	mov    %rcx,(%rax)
    da16:	89 78 08             	mov    %edi,0x8(%rax)
    da19:	5b                   	pop    %rbx
    da1a:	c3                   	ret    
    da1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

000000000000da20 <_ZN13istringstream14read_until_anyE8rostring>:
    da20:	53                   	push   %rbx
    da21:	48 89 f8             	mov    %rdi,%rax
    da24:	8b 7e 10             	mov    0x10(%rsi),%edi
    da27:	48 63 cf             	movslq %edi,%rcx
    da2a:	83 7e 08 00          	cmpl   $0x0,0x8(%rsi)
    da2e:	74 20                	je     da50 <_ZN13istringstream14read_until_anyE8rostring+0x30>
    da30:	48 63 ff             	movslq %edi,%rdi
    da33:	48 03 3e             	add    (%rsi),%rdi
    da36:	83 7a 08 00          	cmpl   $0x0,0x8(%rdx)
    da3a:	0f 8f 8e 00 00 00    	jg     dace <_ZN13istringstream14read_until_anyE8rostring+0xae>
    da40:	e9 50 01 00 00       	jmp    db95 <_ZN13istringstream14read_until_anyE8rostring+0x175>
    da45:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    da4c:	00 00 00 00 
    da50:	4c 8b 04 25 00 00 00 	mov    0x1000000,%r8
    da57:	01 
    da58:	bf 00 00 00 01       	mov    $0x1000000,%edi
    da5d:	49 83 f8 1f          	cmp    $0x1f,%r8
    da61:	77 1a                	ja     da7d <_ZN13istringstream14read_until_anyE8rostring+0x5d>
    da63:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    da6a:	84 00 00 00 00 00 
    da70:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
    da74:	4c 8b 07             	mov    (%rdi),%r8
    da77:	49 83 f8 20          	cmp    $0x20,%r8
    da7b:	72 f3                	jb     da70 <_ZN13istringstream14read_until_anyE8rostring+0x50>
    da7d:	4c 8b 4f 08          	mov    0x8(%rdi),%r9
    da81:	4d 8d 50 e0          	lea    -0x20(%r8),%r10
    da85:	49 83 fa 0f          	cmp    $0xf,%r10
    da89:	77 15                	ja     daa0 <_ZN13istringstream14read_until_anyE8rostring+0x80>
    da8b:	c4 c1 78 10 01       	vmovups (%r9),%xmm0
    da90:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    da94:	eb 1a                	jmp    dab0 <_ZN13istringstream14read_until_anyE8rostring+0x90>
    da96:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    da9d:	00 00 00 
    daa0:	4c 89 17             	mov    %r10,(%rdi)
    daa3:	49 c1 e2 04          	shl    $0x4,%r10
    daa7:	4d 01 d1             	add    %r10,%r9
    daaa:	41 b8 20 00 00 00    	mov    $0x20,%r8d
    dab0:	49 8d 79 10          	lea    0x10(%r9),%rdi
    dab4:	4d 89 01             	mov    %r8,(%r9)
    dab7:	4c 01 04 25 28 00 11 	add    %r8,0x110028
    dabe:	00 
    dabf:	41 c6 41 10 00       	movb   $0x0,0x10(%r9)
    dac4:	83 7a 08 00          	cmpl   $0x0,0x8(%rdx)
    dac8:	0f 8e c7 00 00 00    	jle    db95 <_ZN13istringstream14read_until_anyE8rostring+0x175>
    dace:	45 31 c0             	xor    %r8d,%r8d
    dad1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    dad8:	0f 1f 84 00 00 00 00 
    dadf:	00 
    dae0:	83 7a 08 00          	cmpl   $0x0,0x8(%rdx)
    dae4:	74 1a                	je     db00 <_ZN13istringstream14read_until_anyE8rostring+0xe0>
    dae6:	4c 8b 0a             	mov    (%rdx),%r9
    dae9:	47 0f b6 0c 01       	movzbl (%r9,%r8,1),%r9d
    daee:	44 3a 0f             	cmp    (%rdi),%r9b
    daf1:	75 7c                	jne    db6f <_ZN13istringstream14read_until_anyE8rostring+0x14f>
    daf3:	e9 98 00 00 00       	jmp    db90 <_ZN13istringstream14read_until_anyE8rostring+0x170>
    daf8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    daff:	00 
    db00:	4c 8b 0c 25 00 00 00 	mov    0x1000000,%r9
    db07:	01 
    db08:	41 ba 00 00 00 01    	mov    $0x1000000,%r10d
    db0e:	49 83 f9 1f          	cmp    $0x1f,%r9
    db12:	77 19                	ja     db2d <_ZN13istringstream14read_until_anyE8rostring+0x10d>
    db14:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    db1b:	00 00 00 00 00 
    db20:	4d 8b 52 08          	mov    0x8(%r10),%r10
    db24:	4d 8b 0a             	mov    (%r10),%r9
    db27:	49 83 f9 20          	cmp    $0x20,%r9
    db2b:	72 f3                	jb     db20 <_ZN13istringstream14read_until_anyE8rostring+0x100>
    db2d:	4d 8b 5a 08          	mov    0x8(%r10),%r11
    db31:	49 8d 59 e0          	lea    -0x20(%r9),%rbx
    db35:	48 83 fb 0f          	cmp    $0xf,%rbx
    db39:	77 0c                	ja     db47 <_ZN13istringstream14read_until_anyE8rostring+0x127>
    db3b:	c4 c1 78 10 03       	vmovups (%r11),%xmm0
    db40:	c4 c1 78 11 02       	vmovups %xmm0,(%r10)
    db45:	eb 10                	jmp    db57 <_ZN13istringstream14read_until_anyE8rostring+0x137>
    db47:	49 89 1a             	mov    %rbx,(%r10)
    db4a:	48 c1 e3 04          	shl    $0x4,%rbx
    db4e:	49 01 db             	add    %rbx,%r11
    db51:	41 b9 20 00 00 00    	mov    $0x20,%r9d
    db57:	4d 89 0b             	mov    %r9,(%r11)
    db5a:	4c 01 0c 25 28 00 11 	add    %r9,0x110028
    db61:	00 
    db62:	41 c6 43 10 00       	movb   $0x0,0x10(%r11)
    db67:	45 31 c9             	xor    %r9d,%r9d
    db6a:	44 3a 0f             	cmp    (%rdi),%r9b
    db6d:	74 21                	je     db90 <_ZN13istringstream14read_until_anyE8rostring+0x170>
    db6f:	49 ff c0             	inc    %r8
    db72:	4c 63 4a 08          	movslq 0x8(%rdx),%r9
    db76:	4d 39 c8             	cmp    %r9,%r8
    db79:	0f 8c 61 ff ff ff    	jl     dae0 <_ZN13istringstream14read_until_anyE8rostring+0xc0>
    db7f:	eb 14                	jmp    db95 <_ZN13istringstream14read_until_anyE8rostring+0x175>
    db81:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    db88:	0f 1f 84 00 00 00 00 
    db8f:	00 
    db90:	45 85 c0             	test   %r8d,%r8d
    db93:	79 1c                	jns    dbb1 <_ZN13istringstream14read_until_anyE8rostring+0x191>
    db95:	8b 7e 10             	mov    0x10(%rsi),%edi
    db98:	3b 7e 08             	cmp    0x8(%rsi),%edi
    db9b:	7d 17                	jge    dbb4 <_ZN13istringstream14read_until_anyE8rostring+0x194>
    db9d:	ff c7                	inc    %edi
    db9f:	89 7e 10             	mov    %edi,0x10(%rsi)
    dba2:	83 7e 08 00          	cmpl   $0x0,0x8(%rsi)
    dba6:	0f 85 84 fe ff ff    	jne    da30 <_ZN13istringstream14read_until_anyE8rostring+0x10>
    dbac:	e9 9f fe ff ff       	jmp    da50 <_ZN13istringstream14read_until_anyE8rostring+0x30>
    dbb1:	8b 7e 10             	mov    0x10(%rsi),%edi
    dbb4:	29 cf                	sub    %ecx,%edi
    dbb6:	48 03 0e             	add    (%rsi),%rcx
    dbb9:	48 89 08             	mov    %rcx,(%rax)
    dbbc:	89 78 08             	mov    %edi,0x8(%rax)
    dbbf:	5b                   	pop    %rbx
    dbc0:	c3                   	ret    
    dbc1:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    dbc8:	00 00 00 
    dbcb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

000000000000dbd0 <_ZNK4spanIcE11starts_withES0_>:
    dbd0:	8b 47 08             	mov    0x8(%rdi),%eax
    dbd3:	3b 46 08             	cmp    0x8(%rsi),%eax
    dbd6:	7d 03                	jge    dbdb <_ZNK4spanIcE11starts_withES0_+0xb>
    dbd8:	31 c0                	xor    %eax,%eax
    dbda:	c3                   	ret    
    dbdb:	83 7e 08 00          	cmpl   $0x0,0x8(%rsi)
    dbdf:	0f 8e 2b 01 00 00    	jle    dd10 <_ZNK4spanIcE11starts_withES0_+0x140>
    dbe5:	31 c9                	xor    %ecx,%ecx
    dbe7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    dbee:	00 00 
    dbf0:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    dbf4:	74 2a                	je     dc20 <_ZNK4spanIcE11starts_withES0_+0x50>
    dbf6:	48 8b 07             	mov    (%rdi),%rax
    dbf9:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax
    dbfd:	83 7e 08 00          	cmpl   $0x0,0x8(%rsi)
    dc01:	0f 84 8a 00 00 00    	je     dc91 <_ZNK4spanIcE11starts_withES0_+0xc1>
    dc07:	48 8b 16             	mov    (%rsi),%rdx
    dc0a:	0f b6 14 0a          	movzbl (%rdx,%rcx,1),%edx
    dc0e:	38 d0                	cmp    %dl,%al
    dc10:	0f 94 c0             	sete   %al
    dc13:	0f 84 e6 00 00 00    	je     dcff <_ZNK4spanIcE11starts_withES0_+0x12f>
    dc19:	e9 f1 00 00 00       	jmp    dd0f <_ZNK4spanIcE11starts_withES0_+0x13f>
    dc1e:	66 90                	xchg   %ax,%ax
    dc20:	48 8b 04 25 00 00 00 	mov    0x1000000,%rax
    dc27:	01 
    dc28:	ba 00 00 00 01       	mov    $0x1000000,%edx
    dc2d:	48 83 f8 1f          	cmp    $0x1f,%rax
    dc31:	77 1a                	ja     dc4d <_ZNK4spanIcE11starts_withES0_+0x7d>
    dc33:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    dc3a:	84 00 00 00 00 00 
    dc40:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    dc44:	48 8b 02             	mov    (%rdx),%rax
    dc47:	48 83 f8 20          	cmp    $0x20,%rax
    dc4b:	72 f3                	jb     dc40 <_ZNK4spanIcE11starts_withES0_+0x70>
    dc4d:	4c 8b 42 08          	mov    0x8(%rdx),%r8
    dc51:	4c 8d 48 e0          	lea    -0x20(%rax),%r9
    dc55:	49 83 f9 0f          	cmp    $0xf,%r9
    dc59:	77 0b                	ja     dc66 <_ZNK4spanIcE11starts_withES0_+0x96>
    dc5b:	c4 c1 78 10 00       	vmovups (%r8),%xmm0
    dc60:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    dc64:	eb 0f                	jmp    dc75 <_ZNK4spanIcE11starts_withES0_+0xa5>
    dc66:	4c 89 0a             	mov    %r9,(%rdx)
    dc69:	49 c1 e1 04          	shl    $0x4,%r9
    dc6d:	4d 01 c8             	add    %r9,%r8
    dc70:	b8 20 00 00 00       	mov    $0x20,%eax
    dc75:	49 89 00             	mov    %rax,(%r8)
    dc78:	48 01 04 25 28 00 11 	add    %rax,0x110028
    dc7f:	00 
    dc80:	41 c6 40 10 00       	movb   $0x0,0x10(%r8)
    dc85:	31 c0                	xor    %eax,%eax
    dc87:	83 7e 08 00          	cmpl   $0x0,0x8(%rsi)
    dc8b:	0f 85 76 ff ff ff    	jne    dc07 <_ZNK4spanIcE11starts_withES0_+0x37>
    dc91:	48 8b 14 25 00 00 00 	mov    0x1000000,%rdx
    dc98:	01 
    dc99:	41 b8 00 00 00 01    	mov    $0x1000000,%r8d
    dc9f:	48 83 fa 1f          	cmp    $0x1f,%rdx
    dca3:	77 18                	ja     dcbd <_ZNK4spanIcE11starts_withES0_+0xed>
    dca5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    dcac:	00 00 00 00 
    dcb0:	4d 8b 40 08          	mov    0x8(%r8),%r8
    dcb4:	49 8b 10             	mov    (%r8),%rdx
    dcb7:	48 83 fa 20          	cmp    $0x20,%rdx
    dcbb:	72 f3                	jb     dcb0 <_ZNK4spanIcE11starts_withES0_+0xe0>
    dcbd:	4d 8b 48 08          	mov    0x8(%r8),%r9
    dcc1:	4c 8d 52 e0          	lea    -0x20(%rdx),%r10
    dcc5:	49 83 fa 0f          	cmp    $0xf,%r10
    dcc9:	77 0c                	ja     dcd7 <_ZNK4spanIcE11starts_withES0_+0x107>
    dccb:	c4 c1 78 10 01       	vmovups (%r9),%xmm0
    dcd0:	c4 c1 78 11 00       	vmovups %xmm0,(%r8)
    dcd5:	eb 0f                	jmp    dce6 <_ZNK4spanIcE11starts_withES0_+0x116>
    dcd7:	4d 89 10             	mov    %r10,(%r8)
    dcda:	49 c1 e2 04          	shl    $0x4,%r10
    dcde:	4d 01 d1             	add    %r10,%r9
    dce1:	ba 20 00 00 00       	mov    $0x20,%edx
    dce6:	49 89 11             	mov    %rdx,(%r9)
    dce9:	48 01 14 25 28 00 11 	add    %rdx,0x110028
    dcf0:	00 
    dcf1:	41 c6 41 10 00       	movb   $0x0,0x10(%r9)
    dcf6:	31 d2                	xor    %edx,%edx
    dcf8:	38 d0                	cmp    %dl,%al
    dcfa:	0f 94 c0             	sete   %al
    dcfd:	75 10                	jne    dd0f <_ZNK4spanIcE11starts_withES0_+0x13f>
    dcff:	48 ff c1             	inc    %rcx
    dd02:	48 63 56 08          	movslq 0x8(%rsi),%rdx
    dd06:	48 39 d1             	cmp    %rdx,%rcx
    dd09:	0f 8c e1 fe ff ff    	jl     dbf0 <_ZNK4spanIcE11starts_withES0_+0x20>
    dd0f:	c3                   	ret    
    dd10:	b0 01                	mov    $0x1,%al
    dd12:	c3                   	ret    
    dd13:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    dd1a:	00 00 00 
    dd1d:	0f 1f 00             	nopl   (%rax)

000000000000dd20 <_Z16handle_exceptionimmP13register_file>:
    dd20:	41 57                	push   %r15
    dd22:	41 56                	push   %r14
    dd24:	53                   	push   %rbx
    dd25:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
    dd2c:	49 89 ce             	mov    %rcx,%r14
    dd2f:	48 89 d1             	mov    %rdx,%rcx
    dd32:	48 89 f2             	mov    %rsi,%rdx
    dd35:	89 fb                	mov    %edi,%ebx
    dd37:	48 c7 44 24 70 87 09 	movq   $0x10987,0x70(%rsp)
    dd3e:	01 00 
    dd40:	c7 44 24 78 1e 00 00 	movl   $0x1e,0x78(%rsp)
    dd47:	00 
    dd48:	41 b8 21 0c 01 00    	mov    $0x10c21,%r8d
    dd4e:	48 83 fe 1f          	cmp    $0x1f,%rsi
    dd52:	77 08                	ja     dd5c <_Z16handle_exceptionimmP13register_file+0x3c>
    dd54:	4c 8b 04 d5 a0 0f 01 	mov    0x10fa0(,%rdx,8),%r8
    dd5b:	00 
    dd5c:	48 89 e7             	mov    %rsp,%rdi
    dd5f:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
    dd64:	31 c0                	xor    %eax,%eax
    dd66:	e8 35 b0 ff ff       	call   8da0 <_Z6format8rostringz>
    dd6b:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    dd70:	74 17                	je     dd89 <_Z16handle_exceptionimmP13register_file+0x69>
    dd72:	48 63 44 24 08       	movslq 0x8(%rsp),%rax
    dd77:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    dd7c:	74 19                	je     dd97 <_Z16handle_exceptionimmP13register_file+0x77>
    dd7e:	48 8b 0c 24          	mov    (%rsp),%rcx
    dd82:	80 7c 08 ff 00       	cmpb   $0x0,-0x1(%rax,%rcx,1)
    dd87:	74 6d                	je     ddf6 <_Z16handle_exceptionimmP13register_file+0xd6>
    dd89:	8b 74 24 08          	mov    0x8(%rsp),%esi
    dd8d:	48 89 e7             	mov    %rsp,%rdi
    dd90:	e8 cb 1f 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    dd95:	eb 5c                	jmp    ddf3 <_Z16handle_exceptionimmP13register_file+0xd3>
    dd97:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    dd9e:	01 
    dd9f:	ba 00 00 00 01       	mov    $0x1000000,%edx
    dda4:	48 83 f9 1f          	cmp    $0x1f,%rcx
    dda8:	77 13                	ja     ddbd <_Z16handle_exceptionimmP13register_file+0x9d>
    ddaa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    ddb0:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    ddb4:	48 8b 0a             	mov    (%rdx),%rcx
    ddb7:	48 83 f9 20          	cmp    $0x20,%rcx
    ddbb:	72 f3                	jb     ddb0 <_Z16handle_exceptionimmP13register_file+0x90>
    ddbd:	48 8b 42 08          	mov    0x8(%rdx),%rax
    ddc1:	48 8d 71 e0          	lea    -0x20(%rcx),%rsi
    ddc5:	48 83 fe 0f          	cmp    $0xf,%rsi
    ddc9:	77 0a                	ja     ddd5 <_Z16handle_exceptionimmP13register_file+0xb5>
    ddcb:	c5 f8 10 00          	vmovups (%rax),%xmm0
    ddcf:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    ddd3:	eb 0f                	jmp    dde4 <_Z16handle_exceptionimmP13register_file+0xc4>
    ddd5:	48 89 32             	mov    %rsi,(%rdx)
    ddd8:	48 c1 e6 04          	shl    $0x4,%rsi
    dddc:	48 01 f0             	add    %rsi,%rax
    dddf:	b9 20 00 00 00       	mov    $0x20,%ecx
    dde4:	48 89 08             	mov    %rcx,(%rax)
    dde7:	48 83 c0 10          	add    $0x10,%rax
    ddeb:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    ddf2:	00 
    ddf3:	c6 00 00             	movb   $0x0,(%rax)
    ddf6:	4c 8b 3c 24          	mov    (%rsp),%r15
    ddfa:	41 0f b6 07          	movzbl (%r15),%eax
    ddfe:	84 c0                	test   %al,%al
    de00:	74 2f                	je     de31 <_Z16handle_exceptionimmP13register_file+0x111>
    de02:	49 ff c7             	inc    %r15
    de05:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    de0c:	00 00 00 00 
    de10:	0f be f0             	movsbl %al,%esi
    de13:	bf 00 00 11 00       	mov    $0x110000,%edi
    de18:	e8 53 e1 ff ff       	call   bf70 <_ZN7console7putcharEc>
    de1d:	41 0f b6 07          	movzbl (%r15),%eax
    de21:	49 ff c7             	inc    %r15
    de24:	84 c0                	test   %al,%al
    de26:	75 e8                	jne    de10 <_Z16handle_exceptionimmP13register_file+0xf0>
    de28:	4c 8b 3c 24          	mov    (%rsp),%r15
    de2c:	4d 85 ff             	test   %r15,%r15
    de2f:	74 2f                	je     de60 <_Z16handle_exceptionimmP13register_file+0x140>
    de31:	49 8d 47 f0          	lea    -0x10(%r15),%rax
    de35:	49 8b 4f f0          	mov    -0x10(%r15),%rcx
    de39:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    de40:	00 01 
    de42:	c4 c1 78 11 47 f0    	vmovups %xmm0,-0x10(%r15)
    de48:	48 89 0c 25 00 00 00 	mov    %rcx,0x1000000
    de4f:	01 
    de50:	48 89 04 25 08 00 00 	mov    %rax,0x1000008
    de57:	01 
    de58:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    de5f:	00 
    de60:	48 c7 44 24 60 94 0d 	movq   $0x10d94,0x60(%rsp)
    de67:	01 00 
    de69:	c7 44 24 68 10 00 00 	movl   $0x10,0x68(%rsp)
    de70:	00 
    de71:	49 8b 8e 80 00 00 00 	mov    0x80(%r14),%rcx
    de78:	49 8b 96 90 00 00 00 	mov    0x90(%r14),%rdx
    de7f:	48 89 e7             	mov    %rsp,%rdi
    de82:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
    de87:	31 c0                	xor    %eax,%eax
    de89:	e8 12 af ff ff       	call   8da0 <_Z6format8rostringz>
    de8e:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    de93:	74 17                	je     deac <_Z16handle_exceptionimmP13register_file+0x18c>
    de95:	48 63 44 24 08       	movslq 0x8(%rsp),%rax
    de9a:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    de9f:	74 19                	je     deba <_Z16handle_exceptionimmP13register_file+0x19a>
    dea1:	48 8b 0c 24          	mov    (%rsp),%rcx
    dea5:	80 7c 08 ff 00       	cmpb   $0x0,-0x1(%rax,%rcx,1)
    deaa:	74 6a                	je     df16 <_Z16handle_exceptionimmP13register_file+0x1f6>
    deac:	8b 74 24 08          	mov    0x8(%rsp),%esi
    deb0:	48 89 e7             	mov    %rsp,%rdi
    deb3:	e8 a8 1e 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    deb8:	eb 59                	jmp    df13 <_Z16handle_exceptionimmP13register_file+0x1f3>
    deba:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    dec1:	01 
    dec2:	ba 00 00 00 01       	mov    $0x1000000,%edx
    dec7:	48 83 f9 1f          	cmp    $0x1f,%rcx
    decb:	77 10                	ja     dedd <_Z16handle_exceptionimmP13register_file+0x1bd>
    decd:	0f 1f 00             	nopl   (%rax)
    ded0:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    ded4:	48 8b 0a             	mov    (%rdx),%rcx
    ded7:	48 83 f9 20          	cmp    $0x20,%rcx
    dedb:	72 f3                	jb     ded0 <_Z16handle_exceptionimmP13register_file+0x1b0>
    dedd:	48 8b 42 08          	mov    0x8(%rdx),%rax
    dee1:	48 8d 71 e0          	lea    -0x20(%rcx),%rsi
    dee5:	48 83 fe 0f          	cmp    $0xf,%rsi
    dee9:	77 0a                	ja     def5 <_Z16handle_exceptionimmP13register_file+0x1d5>
    deeb:	c5 f8 10 00          	vmovups (%rax),%xmm0
    deef:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    def3:	eb 0f                	jmp    df04 <_Z16handle_exceptionimmP13register_file+0x1e4>
    def5:	48 89 32             	mov    %rsi,(%rdx)
    def8:	48 c1 e6 04          	shl    $0x4,%rsi
    defc:	48 01 f0             	add    %rsi,%rax
    deff:	b9 20 00 00 00       	mov    $0x20,%ecx
    df04:	48 89 08             	mov    %rcx,(%rax)
    df07:	48 83 c0 10          	add    $0x10,%rax
    df0b:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    df12:	00 
    df13:	c6 00 00             	movb   $0x0,(%rax)
    df16:	4c 8b 3c 24          	mov    (%rsp),%r15
    df1a:	41 0f b6 07          	movzbl (%r15),%eax
    df1e:	84 c0                	test   %al,%al
    df20:	74 2f                	je     df51 <_Z16handle_exceptionimmP13register_file+0x231>
    df22:	49 ff c7             	inc    %r15
    df25:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    df2c:	00 00 00 00 
    df30:	0f be f0             	movsbl %al,%esi
    df33:	bf 00 00 11 00       	mov    $0x110000,%edi
    df38:	e8 33 e0 ff ff       	call   bf70 <_ZN7console7putcharEc>
    df3d:	41 0f b6 07          	movzbl (%r15),%eax
    df41:	49 ff c7             	inc    %r15
    df44:	84 c0                	test   %al,%al
    df46:	75 e8                	jne    df30 <_Z16handle_exceptionimmP13register_file+0x210>
    df48:	4c 8b 3c 24          	mov    (%rsp),%r15
    df4c:	4d 85 ff             	test   %r15,%r15
    df4f:	74 2f                	je     df80 <_Z16handle_exceptionimmP13register_file+0x260>
    df51:	49 8d 47 f0          	lea    -0x10(%r15),%rax
    df55:	49 8b 4f f0          	mov    -0x10(%r15),%rcx
    df59:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    df60:	00 01 
    df62:	c4 c1 78 11 47 f0    	vmovups %xmm0,-0x10(%r15)
    df68:	48 89 0c 25 00 00 00 	mov    %rcx,0x1000000
    df6f:	01 
    df70:	48 89 04 25 08 00 00 	mov    %rax,0x1000008
    df77:	01 
    df78:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    df7f:	00 
    df80:	bf 00 00 11 00       	mov    $0x110000,%edi
    df85:	be 52 00 00 00       	mov    $0x52,%esi
    df8a:	e8 e1 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    df8f:	bf 00 00 11 00       	mov    $0x110000,%edi
    df94:	be 65 00 00 00       	mov    $0x65,%esi
    df99:	e8 d2 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    df9e:	bf 00 00 11 00       	mov    $0x110000,%edi
    dfa3:	be 67 00 00 00       	mov    $0x67,%esi
    dfa8:	e8 c3 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    dfad:	bf 00 00 11 00       	mov    $0x110000,%edi
    dfb2:	be 69 00 00 00       	mov    $0x69,%esi
    dfb7:	e8 b4 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    dfbc:	bf 00 00 11 00       	mov    $0x110000,%edi
    dfc1:	be 73 00 00 00       	mov    $0x73,%esi
    dfc6:	e8 a5 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    dfcb:	bf 00 00 11 00       	mov    $0x110000,%edi
    dfd0:	be 74 00 00 00       	mov    $0x74,%esi
    dfd5:	e8 96 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    dfda:	bf 00 00 11 00       	mov    $0x110000,%edi
    dfdf:	be 65 00 00 00       	mov    $0x65,%esi
    dfe4:	e8 87 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    dfe9:	bf 00 00 11 00       	mov    $0x110000,%edi
    dfee:	be 72 00 00 00       	mov    $0x72,%esi
    dff3:	e8 78 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    dff8:	bf 00 00 11 00       	mov    $0x110000,%edi
    dffd:	be 20 00 00 00       	mov    $0x20,%esi
    e002:	e8 69 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    e007:	bf 00 00 11 00       	mov    $0x110000,%edi
    e00c:	be 64 00 00 00       	mov    $0x64,%esi
    e011:	e8 5a df ff ff       	call   bf70 <_ZN7console7putcharEc>
    e016:	bf 00 00 11 00       	mov    $0x110000,%edi
    e01b:	be 75 00 00 00       	mov    $0x75,%esi
    e020:	e8 4b df ff ff       	call   bf70 <_ZN7console7putcharEc>
    e025:	bf 00 00 11 00       	mov    $0x110000,%edi
    e02a:	be 6d 00 00 00       	mov    $0x6d,%esi
    e02f:	e8 3c df ff ff       	call   bf70 <_ZN7console7putcharEc>
    e034:	bf 00 00 11 00       	mov    $0x110000,%edi
    e039:	be 70 00 00 00       	mov    $0x70,%esi
    e03e:	e8 2d df ff ff       	call   bf70 <_ZN7console7putcharEc>
    e043:	bf 00 00 11 00       	mov    $0x110000,%edi
    e048:	be 3a 00 00 00       	mov    $0x3a,%esi
    e04d:	e8 1e df ff ff       	call   bf70 <_ZN7console7putcharEc>
    e052:	bf 00 00 11 00       	mov    $0x110000,%edi
    e057:	be 0d 00 00 00       	mov    $0xd,%esi
    e05c:	e8 0f df ff ff       	call   bf70 <_ZN7console7putcharEc>
    e061:	bf 00 00 11 00       	mov    $0x110000,%edi
    e066:	be 0a 00 00 00       	mov    $0xa,%esi
    e06b:	e8 00 df ff ff       	call   bf70 <_ZN7console7putcharEc>
    e070:	48 c7 44 24 50 0f 0d 	movq   $0x10d0f,0x50(%rsp)
    e077:	01 00 
    e079:	c7 44 24 58 19 00 00 	movl   $0x19,0x58(%rsp)
    e080:	00 
    e081:	49 8b 16             	mov    (%r14),%rdx
    e084:	49 8b 4e 08          	mov    0x8(%r14),%rcx
    e088:	4d 8b 46 10          	mov    0x10(%r14),%r8
    e08c:	4d 8b 4e 18          	mov    0x18(%r14),%r9
    e090:	48 89 e7             	mov    %rsp,%rdi
    e093:	48 8d 74 24 50       	lea    0x50(%rsp),%rsi
    e098:	31 c0                	xor    %eax,%eax
    e09a:	e8 01 ad ff ff       	call   8da0 <_Z6format8rostringz>
    e09f:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e0a4:	74 17                	je     e0bd <_Z16handle_exceptionimmP13register_file+0x39d>
    e0a6:	48 63 44 24 08       	movslq 0x8(%rsp),%rax
    e0ab:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e0b0:	74 19                	je     e0cb <_Z16handle_exceptionimmP13register_file+0x3ab>
    e0b2:	48 8b 0c 24          	mov    (%rsp),%rcx
    e0b6:	80 7c 08 ff 00       	cmpb   $0x0,-0x1(%rax,%rcx,1)
    e0bb:	74 69                	je     e126 <_Z16handle_exceptionimmP13register_file+0x406>
    e0bd:	8b 74 24 08          	mov    0x8(%rsp),%esi
    e0c1:	48 89 e7             	mov    %rsp,%rdi
    e0c4:	e8 97 1c 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    e0c9:	eb 58                	jmp    e123 <_Z16handle_exceptionimmP13register_file+0x403>
    e0cb:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    e0d2:	01 
    e0d3:	ba 00 00 00 01       	mov    $0x1000000,%edx
    e0d8:	48 83 f9 1f          	cmp    $0x1f,%rcx
    e0dc:	77 0f                	ja     e0ed <_Z16handle_exceptionimmP13register_file+0x3cd>
    e0de:	66 90                	xchg   %ax,%ax
    e0e0:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    e0e4:	48 8b 0a             	mov    (%rdx),%rcx
    e0e7:	48 83 f9 20          	cmp    $0x20,%rcx
    e0eb:	72 f3                	jb     e0e0 <_Z16handle_exceptionimmP13register_file+0x3c0>
    e0ed:	48 8b 42 08          	mov    0x8(%rdx),%rax
    e0f1:	48 8d 71 e0          	lea    -0x20(%rcx),%rsi
    e0f5:	48 83 fe 0f          	cmp    $0xf,%rsi
    e0f9:	77 0a                	ja     e105 <_Z16handle_exceptionimmP13register_file+0x3e5>
    e0fb:	c5 f8 10 00          	vmovups (%rax),%xmm0
    e0ff:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    e103:	eb 0f                	jmp    e114 <_Z16handle_exceptionimmP13register_file+0x3f4>
    e105:	48 89 32             	mov    %rsi,(%rdx)
    e108:	48 c1 e6 04          	shl    $0x4,%rsi
    e10c:	48 01 f0             	add    %rsi,%rax
    e10f:	b9 20 00 00 00       	mov    $0x20,%ecx
    e114:	48 89 08             	mov    %rcx,(%rax)
    e117:	48 83 c0 10          	add    $0x10,%rax
    e11b:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    e122:	00 
    e123:	c6 00 00             	movb   $0x0,(%rax)
    e126:	4c 8b 3c 24          	mov    (%rsp),%r15
    e12a:	41 0f b6 07          	movzbl (%r15),%eax
    e12e:	84 c0                	test   %al,%al
    e130:	74 2f                	je     e161 <_Z16handle_exceptionimmP13register_file+0x441>
    e132:	49 ff c7             	inc    %r15
    e135:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    e13c:	00 00 00 00 
    e140:	0f be f0             	movsbl %al,%esi
    e143:	bf 00 00 11 00       	mov    $0x110000,%edi
    e148:	e8 23 de ff ff       	call   bf70 <_ZN7console7putcharEc>
    e14d:	41 0f b6 07          	movzbl (%r15),%eax
    e151:	49 ff c7             	inc    %r15
    e154:	84 c0                	test   %al,%al
    e156:	75 e8                	jne    e140 <_Z16handle_exceptionimmP13register_file+0x420>
    e158:	4c 8b 3c 24          	mov    (%rsp),%r15
    e15c:	4d 85 ff             	test   %r15,%r15
    e15f:	74 2f                	je     e190 <_Z16handle_exceptionimmP13register_file+0x470>
    e161:	49 8d 47 f0          	lea    -0x10(%r15),%rax
    e165:	49 8b 4f f0          	mov    -0x10(%r15),%rcx
    e169:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    e170:	00 01 
    e172:	c4 c1 78 11 47 f0    	vmovups %xmm0,-0x10(%r15)
    e178:	48 89 0c 25 00 00 00 	mov    %rcx,0x1000000
    e17f:	01 
    e180:	48 89 04 25 08 00 00 	mov    %rax,0x1000008
    e187:	01 
    e188:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    e18f:	00 
    e190:	48 c7 44 24 40 0f 0d 	movq   $0x10d0f,0x40(%rsp)
    e197:	01 00 
    e199:	c7 44 24 48 19 00 00 	movl   $0x19,0x48(%rsp)
    e1a0:	00 
    e1a1:	49 8b 56 20          	mov    0x20(%r14),%rdx
    e1a5:	49 8b 4e 28          	mov    0x28(%r14),%rcx
    e1a9:	4d 8b 46 30          	mov    0x30(%r14),%r8
    e1ad:	4d 8b 4e 38          	mov    0x38(%r14),%r9
    e1b1:	48 89 e7             	mov    %rsp,%rdi
    e1b4:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
    e1b9:	31 c0                	xor    %eax,%eax
    e1bb:	e8 e0 ab ff ff       	call   8da0 <_Z6format8rostringz>
    e1c0:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e1c5:	74 17                	je     e1de <_Z16handle_exceptionimmP13register_file+0x4be>
    e1c7:	48 63 44 24 08       	movslq 0x8(%rsp),%rax
    e1cc:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e1d1:	74 19                	je     e1ec <_Z16handle_exceptionimmP13register_file+0x4cc>
    e1d3:	48 8b 0c 24          	mov    (%rsp),%rcx
    e1d7:	80 7c 08 ff 00       	cmpb   $0x0,-0x1(%rax,%rcx,1)
    e1dc:	74 68                	je     e246 <_Z16handle_exceptionimmP13register_file+0x526>
    e1de:	8b 74 24 08          	mov    0x8(%rsp),%esi
    e1e2:	48 89 e7             	mov    %rsp,%rdi
    e1e5:	e8 76 1b 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    e1ea:	eb 57                	jmp    e243 <_Z16handle_exceptionimmP13register_file+0x523>
    e1ec:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    e1f3:	01 
    e1f4:	ba 00 00 00 01       	mov    $0x1000000,%edx
    e1f9:	48 83 f9 1f          	cmp    $0x1f,%rcx
    e1fd:	77 0e                	ja     e20d <_Z16handle_exceptionimmP13register_file+0x4ed>
    e1ff:	90                   	nop
    e200:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    e204:	48 8b 0a             	mov    (%rdx),%rcx
    e207:	48 83 f9 20          	cmp    $0x20,%rcx
    e20b:	72 f3                	jb     e200 <_Z16handle_exceptionimmP13register_file+0x4e0>
    e20d:	48 8b 42 08          	mov    0x8(%rdx),%rax
    e211:	48 8d 71 e0          	lea    -0x20(%rcx),%rsi
    e215:	48 83 fe 0f          	cmp    $0xf,%rsi
    e219:	77 0a                	ja     e225 <_Z16handle_exceptionimmP13register_file+0x505>
    e21b:	c5 f8 10 00          	vmovups (%rax),%xmm0
    e21f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    e223:	eb 0f                	jmp    e234 <_Z16handle_exceptionimmP13register_file+0x514>
    e225:	48 89 32             	mov    %rsi,(%rdx)
    e228:	48 c1 e6 04          	shl    $0x4,%rsi
    e22c:	48 01 f0             	add    %rsi,%rax
    e22f:	b9 20 00 00 00       	mov    $0x20,%ecx
    e234:	48 89 08             	mov    %rcx,(%rax)
    e237:	48 83 c0 10          	add    $0x10,%rax
    e23b:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    e242:	00 
    e243:	c6 00 00             	movb   $0x0,(%rax)
    e246:	4c 8b 3c 24          	mov    (%rsp),%r15
    e24a:	41 0f b6 07          	movzbl (%r15),%eax
    e24e:	84 c0                	test   %al,%al
    e250:	74 2f                	je     e281 <_Z16handle_exceptionimmP13register_file+0x561>
    e252:	49 ff c7             	inc    %r15
    e255:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    e25c:	00 00 00 00 
    e260:	0f be f0             	movsbl %al,%esi
    e263:	bf 00 00 11 00       	mov    $0x110000,%edi
    e268:	e8 03 dd ff ff       	call   bf70 <_ZN7console7putcharEc>
    e26d:	41 0f b6 07          	movzbl (%r15),%eax
    e271:	49 ff c7             	inc    %r15
    e274:	84 c0                	test   %al,%al
    e276:	75 e8                	jne    e260 <_Z16handle_exceptionimmP13register_file+0x540>
    e278:	4c 8b 3c 24          	mov    (%rsp),%r15
    e27c:	4d 85 ff             	test   %r15,%r15
    e27f:	74 2f                	je     e2b0 <_Z16handle_exceptionimmP13register_file+0x590>
    e281:	49 8d 47 f0          	lea    -0x10(%r15),%rax
    e285:	49 8b 4f f0          	mov    -0x10(%r15),%rcx
    e289:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    e290:	00 01 
    e292:	c4 c1 78 11 47 f0    	vmovups %xmm0,-0x10(%r15)
    e298:	48 89 0c 25 00 00 00 	mov    %rcx,0x1000000
    e29f:	01 
    e2a0:	48 89 04 25 08 00 00 	mov    %rax,0x1000008
    e2a7:	01 
    e2a8:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    e2af:	00 
    e2b0:	48 c7 44 24 30 0f 0d 	movq   $0x10d0f,0x30(%rsp)
    e2b7:	01 00 
    e2b9:	c7 44 24 38 19 00 00 	movl   $0x19,0x38(%rsp)
    e2c0:	00 
    e2c1:	49 8b 56 40          	mov    0x40(%r14),%rdx
    e2c5:	49 8b 4e 48          	mov    0x48(%r14),%rcx
    e2c9:	4d 8b 46 50          	mov    0x50(%r14),%r8
    e2cd:	4d 8b 4e 58          	mov    0x58(%r14),%r9
    e2d1:	48 89 e7             	mov    %rsp,%rdi
    e2d4:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
    e2d9:	31 c0                	xor    %eax,%eax
    e2db:	e8 c0 aa ff ff       	call   8da0 <_Z6format8rostringz>
    e2e0:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e2e5:	74 17                	je     e2fe <_Z16handle_exceptionimmP13register_file+0x5de>
    e2e7:	48 63 44 24 08       	movslq 0x8(%rsp),%rax
    e2ec:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e2f1:	74 19                	je     e30c <_Z16handle_exceptionimmP13register_file+0x5ec>
    e2f3:	48 8b 0c 24          	mov    (%rsp),%rcx
    e2f7:	80 7c 08 ff 00       	cmpb   $0x0,-0x1(%rax,%rcx,1)
    e2fc:	74 68                	je     e366 <_Z16handle_exceptionimmP13register_file+0x646>
    e2fe:	8b 74 24 08          	mov    0x8(%rsp),%esi
    e302:	48 89 e7             	mov    %rsp,%rdi
    e305:	e8 56 1a 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    e30a:	eb 57                	jmp    e363 <_Z16handle_exceptionimmP13register_file+0x643>
    e30c:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    e313:	01 
    e314:	ba 00 00 00 01       	mov    $0x1000000,%edx
    e319:	48 83 f9 1f          	cmp    $0x1f,%rcx
    e31d:	77 0e                	ja     e32d <_Z16handle_exceptionimmP13register_file+0x60d>
    e31f:	90                   	nop
    e320:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    e324:	48 8b 0a             	mov    (%rdx),%rcx
    e327:	48 83 f9 20          	cmp    $0x20,%rcx
    e32b:	72 f3                	jb     e320 <_Z16handle_exceptionimmP13register_file+0x600>
    e32d:	48 8b 42 08          	mov    0x8(%rdx),%rax
    e331:	48 8d 71 e0          	lea    -0x20(%rcx),%rsi
    e335:	48 83 fe 0f          	cmp    $0xf,%rsi
    e339:	77 0a                	ja     e345 <_Z16handle_exceptionimmP13register_file+0x625>
    e33b:	c5 f8 10 00          	vmovups (%rax),%xmm0
    e33f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    e343:	eb 0f                	jmp    e354 <_Z16handle_exceptionimmP13register_file+0x634>
    e345:	48 89 32             	mov    %rsi,(%rdx)
    e348:	48 c1 e6 04          	shl    $0x4,%rsi
    e34c:	48 01 f0             	add    %rsi,%rax
    e34f:	b9 20 00 00 00       	mov    $0x20,%ecx
    e354:	48 89 08             	mov    %rcx,(%rax)
    e357:	48 83 c0 10          	add    $0x10,%rax
    e35b:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    e362:	00 
    e363:	c6 00 00             	movb   $0x0,(%rax)
    e366:	4c 8b 3c 24          	mov    (%rsp),%r15
    e36a:	41 0f b6 07          	movzbl (%r15),%eax
    e36e:	84 c0                	test   %al,%al
    e370:	74 2f                	je     e3a1 <_Z16handle_exceptionimmP13register_file+0x681>
    e372:	49 ff c7             	inc    %r15
    e375:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    e37c:	00 00 00 00 
    e380:	0f be f0             	movsbl %al,%esi
    e383:	bf 00 00 11 00       	mov    $0x110000,%edi
    e388:	e8 e3 db ff ff       	call   bf70 <_ZN7console7putcharEc>
    e38d:	41 0f b6 07          	movzbl (%r15),%eax
    e391:	49 ff c7             	inc    %r15
    e394:	84 c0                	test   %al,%al
    e396:	75 e8                	jne    e380 <_Z16handle_exceptionimmP13register_file+0x660>
    e398:	4c 8b 3c 24          	mov    (%rsp),%r15
    e39c:	4d 85 ff             	test   %r15,%r15
    e39f:	74 2f                	je     e3d0 <_Z16handle_exceptionimmP13register_file+0x6b0>
    e3a1:	49 8d 47 f0          	lea    -0x10(%r15),%rax
    e3a5:	49 8b 4f f0          	mov    -0x10(%r15),%rcx
    e3a9:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    e3b0:	00 01 
    e3b2:	c4 c1 78 11 47 f0    	vmovups %xmm0,-0x10(%r15)
    e3b8:	48 89 0c 25 00 00 00 	mov    %rcx,0x1000000
    e3bf:	01 
    e3c0:	48 89 04 25 08 00 00 	mov    %rax,0x1000008
    e3c7:	01 
    e3c8:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    e3cf:	00 
    e3d0:	48 c7 44 24 20 0f 0d 	movq   $0x10d0f,0x20(%rsp)
    e3d7:	01 00 
    e3d9:	c7 44 24 28 19 00 00 	movl   $0x19,0x28(%rsp)
    e3e0:	00 
    e3e1:	49 8b 56 60          	mov    0x60(%r14),%rdx
    e3e5:	49 8b 4e 68          	mov    0x68(%r14),%rcx
    e3e9:	4d 8b 46 70          	mov    0x70(%r14),%r8
    e3ed:	4d 8b 4e 78          	mov    0x78(%r14),%r9
    e3f1:	48 89 e7             	mov    %rsp,%rdi
    e3f4:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
    e3f9:	31 c0                	xor    %eax,%eax
    e3fb:	e8 a0 a9 ff ff       	call   8da0 <_Z6format8rostringz>
    e400:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e405:	74 17                	je     e41e <_Z16handle_exceptionimmP13register_file+0x6fe>
    e407:	48 63 44 24 08       	movslq 0x8(%rsp),%rax
    e40c:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e411:	74 19                	je     e42c <_Z16handle_exceptionimmP13register_file+0x70c>
    e413:	48 8b 0c 24          	mov    (%rsp),%rcx
    e417:	80 7c 08 ff 00       	cmpb   $0x0,-0x1(%rax,%rcx,1)
    e41c:	74 68                	je     e486 <_Z16handle_exceptionimmP13register_file+0x766>
    e41e:	8b 74 24 08          	mov    0x8(%rsp),%esi
    e422:	48 89 e7             	mov    %rsp,%rdi
    e425:	e8 36 19 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    e42a:	eb 57                	jmp    e483 <_Z16handle_exceptionimmP13register_file+0x763>
    e42c:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    e433:	01 
    e434:	ba 00 00 00 01       	mov    $0x1000000,%edx
    e439:	48 83 f9 1f          	cmp    $0x1f,%rcx
    e43d:	77 0e                	ja     e44d <_Z16handle_exceptionimmP13register_file+0x72d>
    e43f:	90                   	nop
    e440:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    e444:	48 8b 0a             	mov    (%rdx),%rcx
    e447:	48 83 f9 20          	cmp    $0x20,%rcx
    e44b:	72 f3                	jb     e440 <_Z16handle_exceptionimmP13register_file+0x720>
    e44d:	48 8b 42 08          	mov    0x8(%rdx),%rax
    e451:	48 8d 71 e0          	lea    -0x20(%rcx),%rsi
    e455:	48 83 fe 0f          	cmp    $0xf,%rsi
    e459:	77 0a                	ja     e465 <_Z16handle_exceptionimmP13register_file+0x745>
    e45b:	c5 f8 10 00          	vmovups (%rax),%xmm0
    e45f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    e463:	eb 0f                	jmp    e474 <_Z16handle_exceptionimmP13register_file+0x754>
    e465:	48 89 32             	mov    %rsi,(%rdx)
    e468:	48 c1 e6 04          	shl    $0x4,%rsi
    e46c:	48 01 f0             	add    %rsi,%rax
    e46f:	b9 20 00 00 00       	mov    $0x20,%ecx
    e474:	48 89 08             	mov    %rcx,(%rax)
    e477:	48 83 c0 10          	add    $0x10,%rax
    e47b:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    e482:	00 
    e483:	c6 00 00             	movb   $0x0,(%rax)
    e486:	4c 8b 34 24          	mov    (%rsp),%r14
    e48a:	41 0f b6 06          	movzbl (%r14),%eax
    e48e:	84 c0                	test   %al,%al
    e490:	74 2f                	je     e4c1 <_Z16handle_exceptionimmP13register_file+0x7a1>
    e492:	49 ff c6             	inc    %r14
    e495:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    e49c:	00 00 00 00 
    e4a0:	0f be f0             	movsbl %al,%esi
    e4a3:	bf 00 00 11 00       	mov    $0x110000,%edi
    e4a8:	e8 c3 da ff ff       	call   bf70 <_ZN7console7putcharEc>
    e4ad:	41 0f b6 06          	movzbl (%r14),%eax
    e4b1:	49 ff c6             	inc    %r14
    e4b4:	84 c0                	test   %al,%al
    e4b6:	75 e8                	jne    e4a0 <_Z16handle_exceptionimmP13register_file+0x780>
    e4b8:	4c 8b 34 24          	mov    (%rsp),%r14
    e4bc:	4d 85 f6             	test   %r14,%r14
    e4bf:	74 2f                	je     e4f0 <_Z16handle_exceptionimmP13register_file+0x7d0>
    e4c1:	49 8d 46 f0          	lea    -0x10(%r14),%rax
    e4c5:	49 8b 4e f0          	mov    -0x10(%r14),%rcx
    e4c9:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    e4d0:	00 01 
    e4d2:	c4 c1 78 11 46 f0    	vmovups %xmm0,-0x10(%r14)
    e4d8:	48 89 0c 25 00 00 00 	mov    %rcx,0x1000000
    e4df:	01 
    e4e0:	48 89 04 25 08 00 00 	mov    %rax,0x1000008
    e4e7:	01 
    e4e8:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    e4ef:	00 
    e4f0:	48 c7 44 24 10 0f 0d 	movq   $0x10d0f,0x10(%rsp)
    e4f7:	01 00 
    e4f9:	c7 44 24 18 19 00 00 	movl   $0x19,0x18(%rsp)
    e500:	00 
    e501:	0f 20 c2             	mov    %cr0,%rdx
    e504:	0f 20 d1             	mov    %cr2,%rcx
    e507:	41 0f 20 d8          	mov    %cr3,%r8
    e50b:	41 0f 20 e1          	mov    %cr4,%r9
    e50f:	48 89 e7             	mov    %rsp,%rdi
    e512:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
    e517:	31 c0                	xor    %eax,%eax
    e519:	e8 82 a8 ff ff       	call   8da0 <_Z6format8rostringz>
    e51e:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e523:	74 17                	je     e53c <_Z16handle_exceptionimmP13register_file+0x81c>
    e525:	48 63 44 24 08       	movslq 0x8(%rsp),%rax
    e52a:	83 7c 24 08 00       	cmpl   $0x0,0x8(%rsp)
    e52f:	74 19                	je     e54a <_Z16handle_exceptionimmP13register_file+0x82a>
    e531:	48 8b 0c 24          	mov    (%rsp),%rcx
    e535:	80 7c 08 ff 00       	cmpb   $0x0,-0x1(%rax,%rcx,1)
    e53a:	74 6a                	je     e5a6 <_Z16handle_exceptionimmP13register_file+0x886>
    e53c:	8b 74 24 08          	mov    0x8(%rsp),%esi
    e540:	48 89 e7             	mov    %rsp,%rdi
    e543:	e8 18 18 00 00       	call   fd60 <_ZN6vectorIcE2atEi>
    e548:	eb 59                	jmp    e5a3 <_Z16handle_exceptionimmP13register_file+0x883>
    e54a:	48 8b 0c 25 00 00 00 	mov    0x1000000,%rcx
    e551:	01 
    e552:	ba 00 00 00 01       	mov    $0x1000000,%edx
    e557:	48 83 f9 1f          	cmp    $0x1f,%rcx
    e55b:	77 10                	ja     e56d <_Z16handle_exceptionimmP13register_file+0x84d>
    e55d:	0f 1f 00             	nopl   (%rax)
    e560:	48 8b 52 08          	mov    0x8(%rdx),%rdx
    e564:	48 8b 0a             	mov    (%rdx),%rcx
    e567:	48 83 f9 20          	cmp    $0x20,%rcx
    e56b:	72 f3                	jb     e560 <_Z16handle_exceptionimmP13register_file+0x840>
    e56d:	48 8b 42 08          	mov    0x8(%rdx),%rax
    e571:	48 8d 71 e0          	lea    -0x20(%rcx),%rsi
    e575:	48 83 fe 0f          	cmp    $0xf,%rsi
    e579:	77 0a                	ja     e585 <_Z16handle_exceptionimmP13register_file+0x865>
    e57b:	c5 f8 10 00          	vmovups (%rax),%xmm0
    e57f:	c5 f8 11 02          	vmovups %xmm0,(%rdx)
    e583:	eb 0f                	jmp    e594 <_Z16handle_exceptionimmP13register_file+0x874>
    e585:	48 89 32             	mov    %rsi,(%rdx)
    e588:	48 c1 e6 04          	shl    $0x4,%rsi
    e58c:	48 01 f0             	add    %rsi,%rax
    e58f:	b9 20 00 00 00       	mov    $0x20,%ecx
    e594:	48 89 08             	mov    %rcx,(%rax)
    e597:	48 83 c0 10          	add    $0x10,%rax
    e59b:	48 01 0c 25 28 00 11 	add    %rcx,0x110028
    e5a2:	00 
    e5a3:	c6 00 00             	movb   $0x0,(%rax)
    e5a6:	4c 8b 34 24          	mov    (%rsp),%r14
    e5aa:	41 0f b6 06          	movzbl (%r14),%eax
    e5ae:	84 c0                	test   %al,%al
    e5b0:	74 2f                	je     e5e1 <_Z16handle_exceptionimmP13register_file+0x8c1>
    e5b2:	49 ff c6             	inc    %r14
    e5b5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
    e5bc:	00 00 00 00 
    e5c0:	0f be f0             	movsbl %al,%esi
    e5c3:	bf 00 00 11 00       	mov    $0x110000,%edi
    e5c8:	e8 a3 d9 ff ff       	call   bf70 <_ZN7console7putcharEc>
    e5cd:	41 0f b6 06          	movzbl (%r14),%eax
    e5d1:	49 ff c6             	inc    %r14
    e5d4:	84 c0                	test   %al,%al
    e5d6:	75 e8                	jne    e5c0 <_Z16handle_exceptionimmP13register_file+0x8a0>
    e5d8:	4c 8b 34 24          	mov    (%rsp),%r14
    e5dc:	4d 85 f6             	test   %r14,%r14
    e5df:	74 2f                	je     e610 <_Z16handle_exceptionimmP13register_file+0x8f0>
    e5e1:	49 8d 46 f0          	lea    -0x10(%r14),%rax
    e5e5:	49 8b 4e f0          	mov    -0x10(%r14),%rcx
    e5e9:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    e5f0:	00 01 
    e5f2:	c4 c1 78 11 46 f0    	vmovups %xmm0,-0x10(%r14)
    e5f8:	48 89 0c 25 00 00 00 	mov    %rcx,0x1000000
    e5ff:	01 
    e600:	48 89 04 25 08 00 00 	mov    %rax,0x1000008
    e607:	01 
    e608:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    e60f:	00 
    e610:	85 db                	test   %ebx,%ebx
    e612:	74 1e                	je     e632 <_Z16handle_exceptionimmP13register_file+0x912>
    e614:	bf 00 00 11 00       	mov    $0x110000,%edi
    e619:	be a3 0b 01 00       	mov    $0x10ba3,%esi
    e61e:	e8 3d a7 ff ff       	call   8d60 <_ZN7console6putstrEPKc>
    e623:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    e62a:	84 00 00 00 00 00 
    e630:	eb fe                	jmp    e630 <_Z16handle_exceptionimmP13register_file+0x910>
    e632:	48 81 c4 80 00 00 00 	add    $0x80,%rsp
    e639:	5b                   	pop    %rbx
    e63a:	41 5e                	pop    %r14
    e63c:	41 5f                	pop    %r15
    e63e:	c3                   	ret    
    e63f:	90                   	nop

000000000000e640 <isr_err>:
    e640:	55                   	push   %rbp
    e641:	48 89 e5             	mov    %rsp,%rbp
    e644:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    e648:	48 89 f1             	mov    %rsi,%rcx
    e64b:	48 89 fe             	mov    %rdi,%rsi
    e64e:	bf 01 00 00 00       	mov    $0x1,%edi
    e653:	e8 c8 f6 ff ff       	call   dd20 <_Z16handle_exceptionimmP13register_file>
    e658:	48 89 ec             	mov    %rbp,%rsp
    e65b:	5d                   	pop    %rbp
    e65c:	c3                   	ret    
    e65d:	0f 1f 00             	nopl   (%rax)

000000000000e660 <isr_no_err>:
    e660:	55                   	push   %rbp
    e661:	48 89 e5             	mov    %rsp,%rbp
    e664:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    e668:	48 89 f1             	mov    %rsi,%rcx
    e66b:	48 89 fe             	mov    %rdi,%rsi
    e66e:	31 ff                	xor    %edi,%edi
    e670:	31 d2                	xor    %edx,%edx
    e672:	e8 a9 f6 ff ff       	call   dd20 <_Z16handle_exceptionimmP13register_file>
    e677:	48 89 ec             	mov    %rbp,%rsp
    e67a:	5d                   	pop    %rbp
    e67b:	c3                   	ret    
    e67c:	0f 1f 40 00          	nopl   0x0(%rax)

000000000000e680 <irq_isr>:
    e680:	55                   	push   %rbp
    e681:	48 89 e5             	mov    %rsp,%rbp
    e684:	53                   	push   %rbx
    e685:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    e689:	48 83 ec 10          	sub    $0x10,%rsp
    e68d:	48 8d 5f e0          	lea    -0x20(%rdi),%rbx
    e691:	48 8b 04 fd 40 ff 10 	mov    0x10ff40(,%rdi,8),%rax
    e698:	00 
    e699:	48 85 c0             	test   %rax,%rax
    e69c:	74 16                	je     e6b4 <irq_isr+0x34>
    e69e:	ff d0                	call   *%rax
    e6a0:	f6 c3 f8             	test   $0xf8,%bl
    e6a3:	74 04                	je     e6a9 <irq_isr+0x29>
    e6a5:	b0 20                	mov    $0x20,%al
    e6a7:	e6 a0                	out    %al,$0xa0
    e6a9:	b0 20                	mov    $0x20,%al
    e6ab:	e6 20                	out    %al,$0x20
    e6ad:	48 8d 65 f8          	lea    -0x8(%rbp),%rsp
    e6b1:	5b                   	pop    %rbx
    e6b2:	5d                   	pop    %rbp
    e6b3:	c3                   	ret    
    e6b4:	48 89 f1             	mov    %rsi,%rcx
    e6b7:	48 89 fe             	mov    %rdi,%rsi
    e6ba:	31 ff                	xor    %edi,%edi
    e6bc:	31 d2                	xor    %edx,%edx
    e6be:	e8 5d f6 ff ff       	call   dd20 <_Z16handle_exceptionimmP13register_file>
    e6c3:	f6 c3 f8             	test   $0xf8,%bl
    e6c6:	75 dd                	jne    e6a5 <irq_isr+0x25>
    e6c8:	eb df                	jmp    e6a9 <irq_isr+0x29>
    e6ca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

000000000000e6d0 <_Z8idt_initv>:
    e6d0:	66 c7 04 25 00 90 05 	movw   $0xfff,0x59000
    e6d7:	00 ff 0f 
    e6da:	c7 04 25 02 90 05 00 	movl   $0x58000,0x59002
    e6e1:	00 80 05 00 
    e6e5:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    e6e9:	c5 fc 29 04 25 00 80 	vmovaps %ymm0,0x58000
    e6f0:	05 00 
    e6f2:	c5 fc 29 04 25 20 80 	vmovaps %ymm0,0x58020
    e6f9:	05 00 
    e6fb:	c5 fc 29 04 25 40 80 	vmovaps %ymm0,0x58040
    e702:	05 00 
    e704:	c5 fc 29 04 25 60 80 	vmovaps %ymm0,0x58060
    e70b:	05 00 
    e70d:	c5 fc 29 04 25 80 80 	vmovaps %ymm0,0x58080
    e714:	05 00 
    e716:	c5 fc 29 04 25 a0 80 	vmovaps %ymm0,0x580a0
    e71d:	05 00 
    e71f:	c5 fc 29 04 25 c0 80 	vmovaps %ymm0,0x580c0
    e726:	05 00 
    e728:	c5 fc 29 04 25 e0 80 	vmovaps %ymm0,0x580e0
    e72f:	05 00 
    e731:	c5 fc 29 04 25 00 81 	vmovaps %ymm0,0x58100
    e738:	05 00 
    e73a:	c5 fc 29 04 25 20 81 	vmovaps %ymm0,0x58120
    e741:	05 00 
    e743:	c5 fc 29 04 25 40 81 	vmovaps %ymm0,0x58140
    e74a:	05 00 
    e74c:	c5 fc 29 04 25 60 81 	vmovaps %ymm0,0x58160
    e753:	05 00 
    e755:	c5 fc 29 04 25 80 81 	vmovaps %ymm0,0x58180
    e75c:	05 00 
    e75e:	c5 fc 29 04 25 a0 81 	vmovaps %ymm0,0x581a0
    e765:	05 00 
    e767:	c5 fc 29 04 25 c0 81 	vmovaps %ymm0,0x581c0
    e76e:	05 00 
    e770:	c5 fc 29 04 25 e0 81 	vmovaps %ymm0,0x581e0
    e777:	05 00 
    e779:	c5 fc 29 04 25 00 82 	vmovaps %ymm0,0x58200
    e780:	05 00 
    e782:	c5 fc 29 04 25 20 82 	vmovaps %ymm0,0x58220
    e789:	05 00 
    e78b:	c5 fc 29 04 25 40 82 	vmovaps %ymm0,0x58240
    e792:	05 00 
    e794:	c5 fc 29 04 25 60 82 	vmovaps %ymm0,0x58260
    e79b:	05 00 
    e79d:	c5 fc 29 04 25 80 82 	vmovaps %ymm0,0x58280
    e7a4:	05 00 
    e7a6:	c5 fc 29 04 25 a0 82 	vmovaps %ymm0,0x582a0
    e7ad:	05 00 
    e7af:	c5 fc 29 04 25 c0 82 	vmovaps %ymm0,0x582c0
    e7b6:	05 00 
    e7b8:	c5 fc 29 04 25 e0 82 	vmovaps %ymm0,0x582e0
    e7bf:	05 00 
    e7c1:	c5 fc 29 04 25 00 83 	vmovaps %ymm0,0x58300
    e7c8:	05 00 
    e7ca:	c5 fc 29 04 25 20 83 	vmovaps %ymm0,0x58320
    e7d1:	05 00 
    e7d3:	c5 fc 29 04 25 40 83 	vmovaps %ymm0,0x58340
    e7da:	05 00 
    e7dc:	c5 fc 29 04 25 60 83 	vmovaps %ymm0,0x58360
    e7e3:	05 00 
    e7e5:	c5 fc 29 04 25 80 83 	vmovaps %ymm0,0x58380
    e7ec:	05 00 
    e7ee:	c5 fc 29 04 25 a0 83 	vmovaps %ymm0,0x583a0
    e7f5:	05 00 
    e7f7:	c5 fc 29 04 25 c0 83 	vmovaps %ymm0,0x583c0
    e7fe:	05 00 
    e800:	c5 fc 29 04 25 e0 83 	vmovaps %ymm0,0x583e0
    e807:	05 00 
    e809:	c5 fc 29 04 25 00 84 	vmovaps %ymm0,0x58400
    e810:	05 00 
    e812:	c5 fc 29 04 25 20 84 	vmovaps %ymm0,0x58420
    e819:	05 00 
    e81b:	c5 fc 29 04 25 40 84 	vmovaps %ymm0,0x58440
    e822:	05 00 
    e824:	c5 fc 29 04 25 60 84 	vmovaps %ymm0,0x58460
    e82b:	05 00 
    e82d:	c5 fc 29 04 25 80 84 	vmovaps %ymm0,0x58480
    e834:	05 00 
    e836:	c5 fc 29 04 25 a0 84 	vmovaps %ymm0,0x584a0
    e83d:	05 00 
    e83f:	c5 fc 29 04 25 c0 84 	vmovaps %ymm0,0x584c0
    e846:	05 00 
    e848:	c5 fc 29 04 25 e0 84 	vmovaps %ymm0,0x584e0
    e84f:	05 00 
    e851:	c5 fc 29 04 25 00 85 	vmovaps %ymm0,0x58500
    e858:	05 00 
    e85a:	c5 fc 29 04 25 20 85 	vmovaps %ymm0,0x58520
    e861:	05 00 
    e863:	c5 fc 29 04 25 40 85 	vmovaps %ymm0,0x58540
    e86a:	05 00 
    e86c:	c5 fc 29 04 25 60 85 	vmovaps %ymm0,0x58560
    e873:	05 00 
    e875:	c5 fc 29 04 25 80 85 	vmovaps %ymm0,0x58580
    e87c:	05 00 
    e87e:	c5 fc 29 04 25 a0 85 	vmovaps %ymm0,0x585a0
    e885:	05 00 
    e887:	c5 fc 29 04 25 c0 85 	vmovaps %ymm0,0x585c0
    e88e:	05 00 
    e890:	c5 fc 29 04 25 e0 85 	vmovaps %ymm0,0x585e0
    e897:	05 00 
    e899:	c5 fc 29 04 25 00 86 	vmovaps %ymm0,0x58600
    e8a0:	05 00 
    e8a2:	c5 fc 29 04 25 20 86 	vmovaps %ymm0,0x58620
    e8a9:	05 00 
    e8ab:	c5 fc 29 04 25 40 86 	vmovaps %ymm0,0x58640
    e8b2:	05 00 
    e8b4:	c5 fc 29 04 25 60 86 	vmovaps %ymm0,0x58660
    e8bb:	05 00 
    e8bd:	c5 fc 29 04 25 80 86 	vmovaps %ymm0,0x58680
    e8c4:	05 00 
    e8c6:	c5 fc 29 04 25 a0 86 	vmovaps %ymm0,0x586a0
    e8cd:	05 00 
    e8cf:	c5 fc 29 04 25 c0 86 	vmovaps %ymm0,0x586c0
    e8d6:	05 00 
    e8d8:	c5 fc 29 04 25 e0 86 	vmovaps %ymm0,0x586e0
    e8df:	05 00 
    e8e1:	c5 fc 29 04 25 00 87 	vmovaps %ymm0,0x58700
    e8e8:	05 00 
    e8ea:	c5 fc 29 04 25 20 87 	vmovaps %ymm0,0x58720
    e8f1:	05 00 
    e8f3:	c5 fc 29 04 25 40 87 	vmovaps %ymm0,0x58740
    e8fa:	05 00 
    e8fc:	c5 fc 29 04 25 60 87 	vmovaps %ymm0,0x58760
    e903:	05 00 
    e905:	c5 fc 29 04 25 80 87 	vmovaps %ymm0,0x58780
    e90c:	05 00 
    e90e:	c5 fc 29 04 25 a0 87 	vmovaps %ymm0,0x587a0
    e915:	05 00 
    e917:	c5 fc 29 04 25 c0 87 	vmovaps %ymm0,0x587c0
    e91e:	05 00 
    e920:	c5 fc 29 04 25 e0 87 	vmovaps %ymm0,0x587e0
    e927:	05 00 
    e929:	c5 fc 29 04 25 00 88 	vmovaps %ymm0,0x58800
    e930:	05 00 
    e932:	c5 fc 29 04 25 20 88 	vmovaps %ymm0,0x58820
    e939:	05 00 
    e93b:	c5 fc 29 04 25 40 88 	vmovaps %ymm0,0x58840
    e942:	05 00 
    e944:	c5 fc 29 04 25 60 88 	vmovaps %ymm0,0x58860
    e94b:	05 00 
    e94d:	c5 fc 29 04 25 80 88 	vmovaps %ymm0,0x58880
    e954:	05 00 
    e956:	c5 fc 29 04 25 a0 88 	vmovaps %ymm0,0x588a0
    e95d:	05 00 
    e95f:	c5 fc 29 04 25 c0 88 	vmovaps %ymm0,0x588c0
    e966:	05 00 
    e968:	c5 fc 29 04 25 e0 88 	vmovaps %ymm0,0x588e0
    e96f:	05 00 
    e971:	c5 fc 29 04 25 00 89 	vmovaps %ymm0,0x58900
    e978:	05 00 
    e97a:	c5 fc 29 04 25 20 89 	vmovaps %ymm0,0x58920
    e981:	05 00 
    e983:	c5 fc 29 04 25 40 89 	vmovaps %ymm0,0x58940
    e98a:	05 00 
    e98c:	c5 fc 29 04 25 60 89 	vmovaps %ymm0,0x58960
    e993:	05 00 
    e995:	c5 fc 29 04 25 80 89 	vmovaps %ymm0,0x58980
    e99c:	05 00 
    e99e:	c5 fc 29 04 25 a0 89 	vmovaps %ymm0,0x589a0
    e9a5:	05 00 
    e9a7:	c5 fc 29 04 25 c0 89 	vmovaps %ymm0,0x589c0
    e9ae:	05 00 
    e9b0:	c5 fc 29 04 25 e0 89 	vmovaps %ymm0,0x589e0
    e9b7:	05 00 
    e9b9:	c5 fc 29 04 25 00 8a 	vmovaps %ymm0,0x58a00
    e9c0:	05 00 
    e9c2:	c5 fc 29 04 25 20 8a 	vmovaps %ymm0,0x58a20
    e9c9:	05 00 
    e9cb:	c5 fc 29 04 25 40 8a 	vmovaps %ymm0,0x58a40
    e9d2:	05 00 
    e9d4:	c5 fc 29 04 25 60 8a 	vmovaps %ymm0,0x58a60
    e9db:	05 00 
    e9dd:	c5 fc 29 04 25 80 8a 	vmovaps %ymm0,0x58a80
    e9e4:	05 00 
    e9e6:	c5 fc 29 04 25 a0 8a 	vmovaps %ymm0,0x58aa0
    e9ed:	05 00 
    e9ef:	c5 fc 29 04 25 c0 8a 	vmovaps %ymm0,0x58ac0
    e9f6:	05 00 
    e9f8:	c5 fc 29 04 25 e0 8a 	vmovaps %ymm0,0x58ae0
    e9ff:	05 00 
    ea01:	c5 fc 29 04 25 00 8b 	vmovaps %ymm0,0x58b00
    ea08:	05 00 
    ea0a:	c5 fc 29 04 25 20 8b 	vmovaps %ymm0,0x58b20
    ea11:	05 00 
    ea13:	c5 fc 29 04 25 40 8b 	vmovaps %ymm0,0x58b40
    ea1a:	05 00 
    ea1c:	c5 fc 29 04 25 60 8b 	vmovaps %ymm0,0x58b60
    ea23:	05 00 
    ea25:	c5 fc 29 04 25 80 8b 	vmovaps %ymm0,0x58b80
    ea2c:	05 00 
    ea2e:	c5 fc 29 04 25 a0 8b 	vmovaps %ymm0,0x58ba0
    ea35:	05 00 
    ea37:	c5 fc 29 04 25 c0 8b 	vmovaps %ymm0,0x58bc0
    ea3e:	05 00 
    ea40:	c5 fc 29 04 25 e0 8b 	vmovaps %ymm0,0x58be0
    ea47:	05 00 
    ea49:	c5 fc 29 04 25 00 8c 	vmovaps %ymm0,0x58c00
    ea50:	05 00 
    ea52:	c5 fc 29 04 25 20 8c 	vmovaps %ymm0,0x58c20
    ea59:	05 00 
    ea5b:	c5 fc 29 04 25 40 8c 	vmovaps %ymm0,0x58c40
    ea62:	05 00 
    ea64:	c5 fc 29 04 25 60 8c 	vmovaps %ymm0,0x58c60
    ea6b:	05 00 
    ea6d:	c5 fc 29 04 25 80 8c 	vmovaps %ymm0,0x58c80
    ea74:	05 00 
    ea76:	c5 fc 29 04 25 a0 8c 	vmovaps %ymm0,0x58ca0
    ea7d:	05 00 
    ea7f:	c5 fc 29 04 25 c0 8c 	vmovaps %ymm0,0x58cc0
    ea86:	05 00 
    ea88:	c5 fc 29 04 25 e0 8c 	vmovaps %ymm0,0x58ce0
    ea8f:	05 00 
    ea91:	c5 fc 29 04 25 00 8d 	vmovaps %ymm0,0x58d00
    ea98:	05 00 
    ea9a:	c5 fc 29 04 25 20 8d 	vmovaps %ymm0,0x58d20
    eaa1:	05 00 
    eaa3:	c5 fc 29 04 25 40 8d 	vmovaps %ymm0,0x58d40
    eaaa:	05 00 
    eaac:	c5 fc 29 04 25 60 8d 	vmovaps %ymm0,0x58d60
    eab3:	05 00 
    eab5:	c5 fc 29 04 25 80 8d 	vmovaps %ymm0,0x58d80
    eabc:	05 00 
    eabe:	c5 fc 29 04 25 a0 8d 	vmovaps %ymm0,0x58da0
    eac5:	05 00 
    eac7:	c5 fc 29 04 25 c0 8d 	vmovaps %ymm0,0x58dc0
    eace:	05 00 
    ead0:	c5 fc 29 04 25 e0 8d 	vmovaps %ymm0,0x58de0
    ead7:	05 00 
    ead9:	c5 fc 29 04 25 00 8e 	vmovaps %ymm0,0x58e00
    eae0:	05 00 
    eae2:	c5 fc 29 04 25 20 8e 	vmovaps %ymm0,0x58e20
    eae9:	05 00 
    eaeb:	c5 fc 29 04 25 40 8e 	vmovaps %ymm0,0x58e40
    eaf2:	05 00 
    eaf4:	c5 fc 29 04 25 60 8e 	vmovaps %ymm0,0x58e60
    eafb:	05 00 
    eafd:	c5 fc 29 04 25 80 8e 	vmovaps %ymm0,0x58e80
    eb04:	05 00 
    eb06:	c5 fc 29 04 25 a0 8e 	vmovaps %ymm0,0x58ea0
    eb0d:	05 00 
    eb0f:	c5 fc 29 04 25 c0 8e 	vmovaps %ymm0,0x58ec0
    eb16:	05 00 
    eb18:	c5 fc 29 04 25 e0 8e 	vmovaps %ymm0,0x58ee0
    eb1f:	05 00 
    eb21:	c5 fc 29 04 25 00 8f 	vmovaps %ymm0,0x58f00
    eb28:	05 00 
    eb2a:	c5 fc 29 04 25 20 8f 	vmovaps %ymm0,0x58f20
    eb31:	05 00 
    eb33:	c5 fc 29 04 25 40 8f 	vmovaps %ymm0,0x58f40
    eb3a:	05 00 
    eb3c:	c5 fc 29 04 25 60 8f 	vmovaps %ymm0,0x58f60
    eb43:	05 00 
    eb45:	c5 fc 29 04 25 80 8f 	vmovaps %ymm0,0x58f80
    eb4c:	05 00 
    eb4e:	c5 fc 29 04 25 a0 8f 	vmovaps %ymm0,0x58fa0
    eb55:	05 00 
    eb57:	c5 fc 29 04 25 c0 8f 	vmovaps %ymm0,0x58fc0
    eb5e:	05 00 
    eb60:	b8 3c 80 05 00       	mov    $0x5803c,%eax
    eb65:	c5 fc 29 04 25 e0 8f 	vmovaps %ymm0,0x58fe0
    eb6c:	05 00 
    eb6e:	31 c9                	xor    %ecx,%ecx
    eb70:	8b 91 6b 88 00 00    	mov    0x886b(%rcx),%edx
    eb76:	66 89 54 88 c4       	mov    %dx,-0x3c(%rax,%rcx,4)
    eb7b:	c1 ea 10             	shr    $0x10,%edx
    eb7e:	c7 44 88 c6 18 00 00 	movl   $0x8e000018,-0x3a(%rax,%rcx,4)
    eb85:	8e 
    eb86:	66 89 54 88 ca       	mov    %dx,-0x36(%rax,%rcx,4)
    eb8b:	48 c7 44 88 cc 00 00 	movq   $0x0,-0x34(%rax,%rcx,4)
    eb92:	00 00 
    eb94:	8b 91 6f 88 00 00    	mov    0x886f(%rcx),%edx
    eb9a:	66 89 54 88 d4       	mov    %dx,-0x2c(%rax,%rcx,4)
    eb9f:	c1 ea 10             	shr    $0x10,%edx
    eba2:	c7 44 88 d6 18 00 00 	movl   $0x8e000018,-0x2a(%rax,%rcx,4)
    eba9:	8e 
    ebaa:	66 89 54 88 da       	mov    %dx,-0x26(%rax,%rcx,4)
    ebaf:	48 c7 44 88 dc 00 00 	movq   $0x0,-0x24(%rax,%rcx,4)
    ebb6:	00 00 
    ebb8:	8b 91 73 88 00 00    	mov    0x8873(%rcx),%edx
    ebbe:	66 89 54 88 e4       	mov    %dx,-0x1c(%rax,%rcx,4)
    ebc3:	c1 ea 10             	shr    $0x10,%edx
    ebc6:	c7 44 88 e6 18 00 00 	movl   $0x8e000018,-0x1a(%rax,%rcx,4)
    ebcd:	8e 
    ebce:	66 89 54 88 ea       	mov    %dx,-0x16(%rax,%rcx,4)
    ebd3:	48 c7 44 88 ec 00 00 	movq   $0x0,-0x14(%rax,%rcx,4)
    ebda:	00 00 
    ebdc:	8b 91 77 88 00 00    	mov    0x8877(%rcx),%edx
    ebe2:	66 89 54 88 f4       	mov    %dx,-0xc(%rax,%rcx,4)
    ebe7:	c1 ea 10             	shr    $0x10,%edx
    ebea:	c7 44 88 f6 18 00 00 	movl   $0x8e000018,-0xa(%rax,%rcx,4)
    ebf1:	8e 
    ebf2:	66 89 54 88 fa       	mov    %dx,-0x6(%rax,%rcx,4)
    ebf7:	48 c7 44 88 fc 00 00 	movq   $0x0,-0x4(%rax,%rcx,4)
    ebfe:	00 00 
    ec00:	48 83 c1 10          	add    $0x10,%rcx
    ec04:	48 81 f9 80 00 00 00 	cmp    $0x80,%rcx
    ec0b:	0f 85 5f ff ff ff    	jne    eb70 <_Z8idt_initv+0x4a0>
    ec11:	8b 0d d4 9c ff ff    	mov    -0x632c(%rip),%ecx        # 88eb <isr_stub_table+0x80>
    ec17:	66 89 0c 25 00 82 05 	mov    %cx,0x58200
    ec1e:	00 
    ec1f:	c1 e9 10             	shr    $0x10,%ecx
    ec22:	66 c7 04 25 02 82 05 	movw   $0x18,0x58202
    ec29:	00 18 00 
    ec2c:	c6 04 25 04 82 05 00 	movb   $0x0,0x58204
    ec33:	00 
    ec34:	c6 04 25 05 82 05 00 	movb   $0x8e,0x58205
    ec3b:	8e 
    ec3c:	66 89 0c 25 06 82 05 	mov    %cx,0x58206
    ec43:	00 
    ec44:	c7 04 25 08 82 05 00 	movl   $0x0,0x58208
    ec4b:	00 00 00 00 
    ec4f:	c7 04 25 0c 82 05 00 	movl   $0x0,0x5820c
    ec56:	00 00 00 00 
    ec5a:	8b 0d 8f 9c ff ff    	mov    -0x6371(%rip),%ecx        # 88ef <isr_stub_table+0x84>
    ec60:	66 89 0c 25 10 82 05 	mov    %cx,0x58210
    ec67:	00 
    ec68:	c1 e9 10             	shr    $0x10,%ecx
    ec6b:	66 c7 04 25 12 82 05 	movw   $0x18,0x58212
    ec72:	00 18 00 
    ec75:	c6 04 25 14 82 05 00 	movb   $0x0,0x58214
    ec7c:	00 
    ec7d:	c6 04 25 15 82 05 00 	movb   $0x8e,0x58215
    ec84:	8e 
    ec85:	66 89 0c 25 16 82 05 	mov    %cx,0x58216
    ec8c:	00 
    ec8d:	c7 04 25 18 82 05 00 	movl   $0x0,0x58218
    ec94:	00 00 00 00 
    ec98:	c7 04 25 1c 82 05 00 	movl   $0x0,0x5821c
    ec9f:	00 00 00 00 
    eca3:	8b 0d 4a 9c ff ff    	mov    -0x63b6(%rip),%ecx        # 88f3 <isr_stub_table+0x88>
    eca9:	66 89 0c 25 20 82 05 	mov    %cx,0x58220
    ecb0:	00 
    ecb1:	c1 e9 10             	shr    $0x10,%ecx
    ecb4:	66 c7 04 25 22 82 05 	movw   $0x18,0x58222
    ecbb:	00 18 00 
    ecbe:	c6 04 25 24 82 05 00 	movb   $0x0,0x58224
    ecc5:	00 
    ecc6:	c6 04 25 25 82 05 00 	movb   $0x8e,0x58225
    eccd:	8e 
    ecce:	66 89 0c 25 26 82 05 	mov    %cx,0x58226
    ecd5:	00 
    ecd6:	c7 04 25 28 82 05 00 	movl   $0x0,0x58228
    ecdd:	00 00 00 00 
    ece1:	c7 04 25 2c 82 05 00 	movl   $0x0,0x5822c
    ece8:	00 00 00 00 
    ecec:	8b 0d 05 9c ff ff    	mov    -0x63fb(%rip),%ecx        # 88f7 <isr_stub_table+0x8c>
    ecf2:	66 89 0c 25 30 82 05 	mov    %cx,0x58230
    ecf9:	00 
    ecfa:	c1 e9 10             	shr    $0x10,%ecx
    ecfd:	66 c7 04 25 32 82 05 	movw   $0x18,0x58232
    ed04:	00 18 00 
    ed07:	c6 04 25 34 82 05 00 	movb   $0x0,0x58234
    ed0e:	00 
    ed0f:	c6 04 25 35 82 05 00 	movb   $0x8e,0x58235
    ed16:	8e 
    ed17:	66 89 0c 25 36 82 05 	mov    %cx,0x58236
    ed1e:	00 
    ed1f:	c7 04 25 38 82 05 00 	movl   $0x0,0x58238
    ed26:	00 00 00 00 
    ed2a:	c7 04 25 3c 82 05 00 	movl   $0x0,0x5823c
    ed31:	00 00 00 00 
    ed35:	8b 0d c0 9b ff ff    	mov    -0x6440(%rip),%ecx        # 88fb <isr_stub_table+0x90>
    ed3b:	66 89 0c 25 40 82 05 	mov    %cx,0x58240
    ed42:	00 
    ed43:	c1 e9 10             	shr    $0x10,%ecx
    ed46:	66 c7 04 25 42 82 05 	movw   $0x18,0x58242
    ed4d:	00 18 00 
    ed50:	c6 04 25 44 82 05 00 	movb   $0x0,0x58244
    ed57:	00 
    ed58:	c6 04 25 45 82 05 00 	movb   $0x8e,0x58245
    ed5f:	8e 
    ed60:	66 89 0c 25 46 82 05 	mov    %cx,0x58246
    ed67:	00 
    ed68:	c7 04 25 48 82 05 00 	movl   $0x0,0x58248
    ed6f:	00 00 00 00 
    ed73:	c7 04 25 4c 82 05 00 	movl   $0x0,0x5824c
    ed7a:	00 00 00 00 
    ed7e:	8b 0d 7b 9b ff ff    	mov    -0x6485(%rip),%ecx        # 88ff <isr_stub_table+0x94>
    ed84:	66 89 0c 25 50 82 05 	mov    %cx,0x58250
    ed8b:	00 
    ed8c:	c1 e9 10             	shr    $0x10,%ecx
    ed8f:	66 c7 04 25 52 82 05 	movw   $0x18,0x58252
    ed96:	00 18 00 
    ed99:	c6 04 25 54 82 05 00 	movb   $0x0,0x58254
    eda0:	00 
    eda1:	c6 04 25 55 82 05 00 	movb   $0x8e,0x58255
    eda8:	8e 
    eda9:	66 89 0c 25 56 82 05 	mov    %cx,0x58256
    edb0:	00 
    edb1:	c7 04 25 58 82 05 00 	movl   $0x0,0x58258
    edb8:	00 00 00 00 
    edbc:	c7 04 25 5c 82 05 00 	movl   $0x0,0x5825c
    edc3:	00 00 00 00 
    edc7:	8b 0d 36 9b ff ff    	mov    -0x64ca(%rip),%ecx        # 8903 <isr_stub_table+0x98>
    edcd:	66 89 0c 25 60 82 05 	mov    %cx,0x58260
    edd4:	00 
    edd5:	c1 e9 10             	shr    $0x10,%ecx
    edd8:	66 c7 04 25 62 82 05 	movw   $0x18,0x58262
    eddf:	00 18 00 
    ede2:	c6 04 25 64 82 05 00 	movb   $0x0,0x58264
    ede9:	00 
    edea:	c6 04 25 65 82 05 00 	movb   $0x8e,0x58265
    edf1:	8e 
    edf2:	66 89 0c 25 66 82 05 	mov    %cx,0x58266
    edf9:	00 
    edfa:	c7 04 25 68 82 05 00 	movl   $0x0,0x58268
    ee01:	00 00 00 00 
    ee05:	c7 04 25 6c 82 05 00 	movl   $0x0,0x5826c
    ee0c:	00 00 00 00 
    ee10:	8b 0d f1 9a ff ff    	mov    -0x650f(%rip),%ecx        # 8907 <isr_stub_table+0x9c>
    ee16:	66 89 0c 25 70 82 05 	mov    %cx,0x58270
    ee1d:	00 
    ee1e:	c1 e9 10             	shr    $0x10,%ecx
    ee21:	66 c7 04 25 72 82 05 	movw   $0x18,0x58272
    ee28:	00 18 00 
    ee2b:	c6 04 25 74 82 05 00 	movb   $0x0,0x58274
    ee32:	00 
    ee33:	c6 04 25 75 82 05 00 	movb   $0x8e,0x58275
    ee3a:	8e 
    ee3b:	66 89 0c 25 76 82 05 	mov    %cx,0x58276
    ee42:	00 
    ee43:	c7 04 25 78 82 05 00 	movl   $0x0,0x58278
    ee4a:	00 00 00 00 
    ee4e:	c7 04 25 7c 82 05 00 	movl   $0x0,0x5827c
    ee55:	00 00 00 00 
    ee59:	8b 0d ac 9a ff ff    	mov    -0x6554(%rip),%ecx        # 890b <isr_stub_table+0xa0>
    ee5f:	66 89 0c 25 80 82 05 	mov    %cx,0x58280
    ee66:	00 
    ee67:	c1 e9 10             	shr    $0x10,%ecx
    ee6a:	66 c7 04 25 82 82 05 	movw   $0x18,0x58282
    ee71:	00 18 00 
    ee74:	c6 04 25 84 82 05 00 	movb   $0x0,0x58284
    ee7b:	00 
    ee7c:	c6 04 25 85 82 05 00 	movb   $0x8e,0x58285
    ee83:	8e 
    ee84:	66 89 0c 25 86 82 05 	mov    %cx,0x58286
    ee8b:	00 
    ee8c:	c7 04 25 88 82 05 00 	movl   $0x0,0x58288
    ee93:	00 00 00 00 
    ee97:	c7 04 25 8c 82 05 00 	movl   $0x0,0x5828c
    ee9e:	00 00 00 00 
    eea2:	8b 0d 67 9a ff ff    	mov    -0x6599(%rip),%ecx        # 890f <isr_stub_table+0xa4>
    eea8:	66 89 0c 25 90 82 05 	mov    %cx,0x58290
    eeaf:	00 
    eeb0:	c1 e9 10             	shr    $0x10,%ecx
    eeb3:	66 c7 04 25 92 82 05 	movw   $0x18,0x58292
    eeba:	00 18 00 
    eebd:	c6 04 25 94 82 05 00 	movb   $0x0,0x58294
    eec4:	00 
    eec5:	c6 04 25 95 82 05 00 	movb   $0x8e,0x58295
    eecc:	8e 
    eecd:	66 89 0c 25 96 82 05 	mov    %cx,0x58296
    eed4:	00 
    eed5:	c7 04 25 98 82 05 00 	movl   $0x0,0x58298
    eedc:	00 00 00 00 
    eee0:	c7 04 25 9c 82 05 00 	movl   $0x0,0x5829c
    eee7:	00 00 00 00 
    eeeb:	8b 0d 22 9a ff ff    	mov    -0x65de(%rip),%ecx        # 8913 <isr_stub_table+0xa8>
    eef1:	66 89 0c 25 a0 82 05 	mov    %cx,0x582a0
    eef8:	00 
    eef9:	c1 e9 10             	shr    $0x10,%ecx
    eefc:	66 c7 04 25 a2 82 05 	movw   $0x18,0x582a2
    ef03:	00 18 00 
    ef06:	c6 04 25 a4 82 05 00 	movb   $0x0,0x582a4
    ef0d:	00 
    ef0e:	c6 04 25 a5 82 05 00 	movb   $0x8e,0x582a5
    ef15:	8e 
    ef16:	66 89 0c 25 a6 82 05 	mov    %cx,0x582a6
    ef1d:	00 
    ef1e:	c7 04 25 a8 82 05 00 	movl   $0x0,0x582a8
    ef25:	00 00 00 00 
    ef29:	c7 04 25 ac 82 05 00 	movl   $0x0,0x582ac
    ef30:	00 00 00 00 
    ef34:	8b 0d dd 99 ff ff    	mov    -0x6623(%rip),%ecx        # 8917 <isr_stub_table+0xac>
    ef3a:	66 89 0c 25 b0 82 05 	mov    %cx,0x582b0
    ef41:	00 
    ef42:	c1 e9 10             	shr    $0x10,%ecx
    ef45:	66 c7 04 25 b2 82 05 	movw   $0x18,0x582b2
    ef4c:	00 18 00 
    ef4f:	c6 04 25 b4 82 05 00 	movb   $0x0,0x582b4
    ef56:	00 
    ef57:	c6 04 25 b5 82 05 00 	movb   $0x8e,0x582b5
    ef5e:	8e 
    ef5f:	66 89 0c 25 b6 82 05 	mov    %cx,0x582b6
    ef66:	00 
    ef67:	c7 04 25 b8 82 05 00 	movl   $0x0,0x582b8
    ef6e:	00 00 00 00 
    ef72:	c7 04 25 bc 82 05 00 	movl   $0x0,0x582bc
    ef79:	00 00 00 00 
    ef7d:	8b 0d 98 99 ff ff    	mov    -0x6668(%rip),%ecx        # 891b <isr_stub_table+0xb0>
    ef83:	66 89 0c 25 c0 82 05 	mov    %cx,0x582c0
    ef8a:	00 
    ef8b:	c1 e9 10             	shr    $0x10,%ecx
    ef8e:	66 c7 04 25 c2 82 05 	movw   $0x18,0x582c2
    ef95:	00 18 00 
    ef98:	c6 04 25 c4 82 05 00 	movb   $0x0,0x582c4
    ef9f:	00 
    efa0:	c6 04 25 c5 82 05 00 	movb   $0x8e,0x582c5
    efa7:	8e 
    efa8:	66 89 0c 25 c6 82 05 	mov    %cx,0x582c6
    efaf:	00 
    efb0:	c7 04 25 c8 82 05 00 	movl   $0x0,0x582c8
    efb7:	00 00 00 00 
    efbb:	c7 04 25 cc 82 05 00 	movl   $0x0,0x582cc
    efc2:	00 00 00 00 
    efc6:	8b 0d 53 99 ff ff    	mov    -0x66ad(%rip),%ecx        # 891f <isr_stub_table+0xb4>
    efcc:	66 89 0c 25 d0 82 05 	mov    %cx,0x582d0
    efd3:	00 
    efd4:	c1 e9 10             	shr    $0x10,%ecx
    efd7:	66 c7 04 25 d2 82 05 	movw   $0x18,0x582d2
    efde:	00 18 00 
    efe1:	c6 04 25 d4 82 05 00 	movb   $0x0,0x582d4
    efe8:	00 
    efe9:	c6 04 25 d5 82 05 00 	movb   $0x8e,0x582d5
    eff0:	8e 
    eff1:	66 89 0c 25 d6 82 05 	mov    %cx,0x582d6
    eff8:	00 
    eff9:	c7 04 25 d8 82 05 00 	movl   $0x0,0x582d8
    f000:	00 00 00 00 
    f004:	c7 04 25 dc 82 05 00 	movl   $0x0,0x582dc
    f00b:	00 00 00 00 
    f00f:	8b 0d 0e 99 ff ff    	mov    -0x66f2(%rip),%ecx        # 8923 <isr_stub_table+0xb8>
    f015:	66 89 0c 25 e0 82 05 	mov    %cx,0x582e0
    f01c:	00 
    f01d:	c1 e9 10             	shr    $0x10,%ecx
    f020:	66 c7 04 25 e2 82 05 	movw   $0x18,0x582e2
    f027:	00 18 00 
    f02a:	c6 04 25 e4 82 05 00 	movb   $0x0,0x582e4
    f031:	00 
    f032:	c6 04 25 e5 82 05 00 	movb   $0x8e,0x582e5
    f039:	8e 
    f03a:	66 89 0c 25 e6 82 05 	mov    %cx,0x582e6
    f041:	00 
    f042:	c7 04 25 e8 82 05 00 	movl   $0x0,0x582e8
    f049:	00 00 00 00 
    f04d:	c7 04 25 ec 82 05 00 	movl   $0x0,0x582ec
    f054:	00 00 00 00 
    f058:	8b 0d c9 98 ff ff    	mov    -0x6737(%rip),%ecx        # 8927 <isr_stub_table+0xbc>
    f05e:	66 89 0c 25 f0 82 05 	mov    %cx,0x582f0
    f065:	00 
    f066:	c1 e9 10             	shr    $0x10,%ecx
    f069:	66 c7 04 25 f2 82 05 	movw   $0x18,0x582f2
    f070:	00 18 00 
    f073:	c6 04 25 f4 82 05 00 	movb   $0x0,0x582f4
    f07a:	00 
    f07b:	c6 04 25 f5 82 05 00 	movb   $0x8e,0x582f5
    f082:	8e 
    f083:	66 89 0c 25 f6 82 05 	mov    %cx,0x582f6
    f08a:	00 
    f08b:	c7 04 25 f8 82 05 00 	movl   $0x0,0x582f8
    f092:	00 00 00 00 
    f096:	c7 04 25 fc 82 05 00 	movl   $0x0,0x582fc
    f09d:	00 00 00 00 
    f0a1:	31 c9                	xor    %ecx,%ecx
    f0a3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    f0aa:	84 00 00 00 00 00 
    f0b0:	8b 15 b5 97 ff ff    	mov    -0x684b(%rip),%edx        # 886b <isr_stub_table>
    f0b6:	66 89 94 08 c4 02 00 	mov    %dx,0x2c4(%rax,%rcx,1)
    f0bd:	00 
    f0be:	c1 ea 10             	shr    $0x10,%edx
    f0c1:	c7 84 08 c6 02 00 00 	movl   $0x8e000018,0x2c6(%rax,%rcx,1)
    f0c8:	18 00 00 8e 
    f0cc:	66 89 94 08 ca 02 00 	mov    %dx,0x2ca(%rax,%rcx,1)
    f0d3:	00 
    f0d4:	48 c7 84 08 cc 02 00 	movq   $0x0,0x2cc(%rax,%rcx,1)
    f0db:	00 00 00 00 00 
    f0e0:	8b 15 85 97 ff ff    	mov    -0x687b(%rip),%edx        # 886b <isr_stub_table>
    f0e6:	66 89 94 08 d4 02 00 	mov    %dx,0x2d4(%rax,%rcx,1)
    f0ed:	00 
    f0ee:	c1 ea 10             	shr    $0x10,%edx
    f0f1:	c7 84 08 d6 02 00 00 	movl   $0x8e000018,0x2d6(%rax,%rcx,1)
    f0f8:	18 00 00 8e 
    f0fc:	66 89 94 08 da 02 00 	mov    %dx,0x2da(%rax,%rcx,1)
    f103:	00 
    f104:	48 c7 84 08 dc 02 00 	movq   $0x0,0x2dc(%rax,%rcx,1)
    f10b:	00 00 00 00 00 
    f110:	8b 15 55 97 ff ff    	mov    -0x68ab(%rip),%edx        # 886b <isr_stub_table>
    f116:	66 89 94 08 e4 02 00 	mov    %dx,0x2e4(%rax,%rcx,1)
    f11d:	00 
    f11e:	c1 ea 10             	shr    $0x10,%edx
    f121:	c7 84 08 e6 02 00 00 	movl   $0x8e000018,0x2e6(%rax,%rcx,1)
    f128:	18 00 00 8e 
    f12c:	66 89 94 08 ea 02 00 	mov    %dx,0x2ea(%rax,%rcx,1)
    f133:	00 
    f134:	48 c7 84 08 ec 02 00 	movq   $0x0,0x2ec(%rax,%rcx,1)
    f13b:	00 00 00 00 00 
    f140:	8b 15 25 97 ff ff    	mov    -0x68db(%rip),%edx        # 886b <isr_stub_table>
    f146:	66 89 94 08 f4 02 00 	mov    %dx,0x2f4(%rax,%rcx,1)
    f14d:	00 
    f14e:	c1 ea 10             	shr    $0x10,%edx
    f151:	c7 84 08 f6 02 00 00 	movl   $0x8e000018,0x2f6(%rax,%rcx,1)
    f158:	18 00 00 8e 
    f15c:	66 89 94 08 fa 02 00 	mov    %dx,0x2fa(%rax,%rcx,1)
    f163:	00 
    f164:	48 c7 84 08 fc 02 00 	movq   $0x0,0x2fc(%rax,%rcx,1)
    f16b:	00 00 00 00 00 
    f170:	48 83 c1 40          	add    $0x40,%rcx
    f174:	48 81 f9 00 0d 00 00 	cmp    $0xd00,%rcx
    f17b:	0f 85 2f ff ff ff    	jne    f0b0 <_Z8idt_initv+0x9e0>
    f181:	48 c7 04 25 40 00 11 	movq   $0x0,0x110040
    f188:	00 00 00 00 00 
    f18d:	48 c7 04 25 48 00 11 	movq   $0x0,0x110048
    f194:	00 00 00 00 00 
    f199:	48 c7 04 25 50 00 11 	movq   $0x0,0x110050
    f1a0:	00 00 00 00 00 
    f1a5:	48 c7 04 25 58 00 11 	movq   $0x0,0x110058
    f1ac:	00 00 00 00 00 
    f1b1:	48 c7 04 25 60 00 11 	movq   $0x0,0x110060
    f1b8:	00 00 00 00 00 
    f1bd:	48 c7 04 25 68 00 11 	movq   $0x0,0x110068
    f1c4:	00 00 00 00 00 
    f1c9:	48 c7 04 25 70 00 11 	movq   $0x0,0x110070
    f1d0:	00 00 00 00 00 
    f1d5:	48 c7 04 25 78 00 11 	movq   $0x0,0x110078
    f1dc:	00 00 00 00 00 
    f1e1:	48 c7 04 25 80 00 11 	movq   $0x0,0x110080
    f1e8:	00 00 00 00 00 
    f1ed:	48 c7 04 25 88 00 11 	movq   $0x0,0x110088
    f1f4:	00 00 00 00 00 
    f1f9:	48 c7 04 25 90 00 11 	movq   $0x0,0x110090
    f200:	00 00 00 00 00 
    f205:	48 c7 04 25 98 00 11 	movq   $0x0,0x110098
    f20c:	00 00 00 00 00 
    f211:	48 c7 04 25 a0 00 11 	movq   $0x0,0x1100a0
    f218:	00 00 00 00 00 
    f21d:	48 c7 04 25 a8 00 11 	movq   $0x0,0x1100a8
    f224:	00 00 00 00 00 
    f229:	48 c7 04 25 b0 00 11 	movq   $0x0,0x1100b0
    f230:	00 00 00 00 00 
    f235:	48 c7 04 25 b8 00 11 	movq   $0x0,0x1100b8
    f23c:	00 00 00 00 00 
    f241:	48 c7 05 ec 1d 00 00 	movq   $0x59000,0x1dec(%rip)        # 11038 <idtptr>
    f248:	00 90 05 00 
    f24c:	bf 00 90 05 00       	mov    $0x59000,%edi
    f251:	c5 f8 77             	vzeroupper 
    f254:	e9 d2 96 ff ff       	jmp    892b <load_idt>
    f259:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

000000000000f260 <_Z11init_libcppv>:
    f260:	53                   	push   %rbx
    f261:	48 c7 04 25 20 00 11 	movq   $0x400000,0x110020
    f268:	00 00 00 40 00 
    f26d:	48 c7 04 25 30 00 11 	movq   $0xfffff0,0x110030
    f274:	00 f0 ff ff 00 
    f279:	48 c7 04 25 28 00 11 	movq   $0x10,0x110028
    f280:	00 10 00 00 00 
    f285:	48 c7 04 25 00 00 00 	movq   $0xfffff8,0x1000000
    f28c:	01 f8 ff ff 00 
    f291:	48 c7 04 25 08 00 00 	movq   $0x1000010,0x1000008
    f298:	01 10 00 00 01 
    f29d:	48 c7 04 25 10 00 00 	movq   $0x0,0x1000010
    f2a4:	01 00 00 00 00 
    f2a9:	c4 e2 7d 18 05 1a 12 	vbroadcastss 0x121a(%rip),%ymm0        # 104cc <end_ctors+0x1ec>
    f2b0:	00 00 
    f2b2:	c5 fc 29 04 25 00 80 	vmovaps %ymm0,0xb8000
    f2b9:	0b 00 
    f2bb:	c5 fc 29 04 25 20 80 	vmovaps %ymm0,0xb8020
    f2c2:	0b 00 
    f2c4:	c5 fc 29 04 25 40 80 	vmovaps %ymm0,0xb8040
    f2cb:	0b 00 
    f2cd:	c5 fc 29 04 25 60 80 	vmovaps %ymm0,0xb8060
    f2d4:	0b 00 
    f2d6:	c5 fc 29 04 25 80 80 	vmovaps %ymm0,0xb8080
    f2dd:	0b 00 
    f2df:	c5 fc 29 04 25 a0 80 	vmovaps %ymm0,0xb80a0
    f2e6:	0b 00 
    f2e8:	c5 fc 29 04 25 c0 80 	vmovaps %ymm0,0xb80c0
    f2ef:	0b 00 
    f2f1:	c5 fc 29 04 25 e0 80 	vmovaps %ymm0,0xb80e0
    f2f8:	0b 00 
    f2fa:	c5 fc 29 04 25 00 81 	vmovaps %ymm0,0xb8100
    f301:	0b 00 
    f303:	c5 fc 29 04 25 20 81 	vmovaps %ymm0,0xb8120
    f30a:	0b 00 
    f30c:	c5 fc 29 04 25 40 81 	vmovaps %ymm0,0xb8140
    f313:	0b 00 
    f315:	c5 fc 29 04 25 60 81 	vmovaps %ymm0,0xb8160
    f31c:	0b 00 
    f31e:	c5 fc 29 04 25 80 81 	vmovaps %ymm0,0xb8180
    f325:	0b 00 
    f327:	c5 fc 29 04 25 a0 81 	vmovaps %ymm0,0xb81a0
    f32e:	0b 00 
    f330:	c5 fc 29 04 25 c0 81 	vmovaps %ymm0,0xb81c0
    f337:	0b 00 
    f339:	c5 fc 29 04 25 e0 81 	vmovaps %ymm0,0xb81e0
    f340:	0b 00 
    f342:	c5 fc 29 04 25 00 82 	vmovaps %ymm0,0xb8200
    f349:	0b 00 
    f34b:	c5 fc 29 04 25 20 82 	vmovaps %ymm0,0xb8220
    f352:	0b 00 
    f354:	c5 fc 29 04 25 40 82 	vmovaps %ymm0,0xb8240
    f35b:	0b 00 
    f35d:	c5 fc 29 04 25 60 82 	vmovaps %ymm0,0xb8260
    f364:	0b 00 
    f366:	c5 fc 29 04 25 80 82 	vmovaps %ymm0,0xb8280
    f36d:	0b 00 
    f36f:	c5 fc 29 04 25 a0 82 	vmovaps %ymm0,0xb82a0
    f376:	0b 00 
    f378:	c5 fc 29 04 25 c0 82 	vmovaps %ymm0,0xb82c0
    f37f:	0b 00 
    f381:	c5 fc 29 04 25 e0 82 	vmovaps %ymm0,0xb82e0
    f388:	0b 00 
    f38a:	c5 fc 29 04 25 00 83 	vmovaps %ymm0,0xb8300
    f391:	0b 00 
    f393:	c5 fc 29 04 25 20 83 	vmovaps %ymm0,0xb8320
    f39a:	0b 00 
    f39c:	c5 fc 29 04 25 40 83 	vmovaps %ymm0,0xb8340
    f3a3:	0b 00 
    f3a5:	c5 fc 29 04 25 60 83 	vmovaps %ymm0,0xb8360
    f3ac:	0b 00 
    f3ae:	c5 fc 29 04 25 80 83 	vmovaps %ymm0,0xb8380
    f3b5:	0b 00 
    f3b7:	c5 fc 29 04 25 a0 83 	vmovaps %ymm0,0xb83a0
    f3be:	0b 00 
    f3c0:	c5 fc 29 04 25 c0 83 	vmovaps %ymm0,0xb83c0
    f3c7:	0b 00 
    f3c9:	c5 fc 29 04 25 e0 83 	vmovaps %ymm0,0xb83e0
    f3d0:	0b 00 
    f3d2:	c5 fc 29 04 25 00 84 	vmovaps %ymm0,0xb8400
    f3d9:	0b 00 
    f3db:	c5 fc 29 04 25 20 84 	vmovaps %ymm0,0xb8420
    f3e2:	0b 00 
    f3e4:	c5 fc 29 04 25 40 84 	vmovaps %ymm0,0xb8440
    f3eb:	0b 00 
    f3ed:	c5 fc 29 04 25 60 84 	vmovaps %ymm0,0xb8460
    f3f4:	0b 00 
    f3f6:	c5 fc 29 04 25 80 84 	vmovaps %ymm0,0xb8480
    f3fd:	0b 00 
    f3ff:	c5 fc 29 04 25 a0 84 	vmovaps %ymm0,0xb84a0
    f406:	0b 00 
    f408:	c5 fc 29 04 25 c0 84 	vmovaps %ymm0,0xb84c0
    f40f:	0b 00 
    f411:	c5 fc 29 04 25 e0 84 	vmovaps %ymm0,0xb84e0
    f418:	0b 00 
    f41a:	c5 fc 29 04 25 00 85 	vmovaps %ymm0,0xb8500
    f421:	0b 00 
    f423:	c5 fc 29 04 25 20 85 	vmovaps %ymm0,0xb8520
    f42a:	0b 00 
    f42c:	c5 fc 29 04 25 40 85 	vmovaps %ymm0,0xb8540
    f433:	0b 00 
    f435:	c5 fc 29 04 25 60 85 	vmovaps %ymm0,0xb8560
    f43c:	0b 00 
    f43e:	c5 fc 29 04 25 80 85 	vmovaps %ymm0,0xb8580
    f445:	0b 00 
    f447:	c5 fc 29 04 25 a0 85 	vmovaps %ymm0,0xb85a0
    f44e:	0b 00 
    f450:	c5 fc 29 04 25 c0 85 	vmovaps %ymm0,0xb85c0
    f457:	0b 00 
    f459:	c5 fc 29 04 25 e0 85 	vmovaps %ymm0,0xb85e0
    f460:	0b 00 
    f462:	c5 fc 29 04 25 00 86 	vmovaps %ymm0,0xb8600
    f469:	0b 00 
    f46b:	c5 fc 29 04 25 20 86 	vmovaps %ymm0,0xb8620
    f472:	0b 00 
    f474:	c5 fc 29 04 25 40 86 	vmovaps %ymm0,0xb8640
    f47b:	0b 00 
    f47d:	c5 fc 29 04 25 60 86 	vmovaps %ymm0,0xb8660
    f484:	0b 00 
    f486:	c5 fc 29 04 25 80 86 	vmovaps %ymm0,0xb8680
    f48d:	0b 00 
    f48f:	c5 fc 29 04 25 a0 86 	vmovaps %ymm0,0xb86a0
    f496:	0b 00 
    f498:	c5 fc 29 04 25 c0 86 	vmovaps %ymm0,0xb86c0
    f49f:	0b 00 
    f4a1:	c5 fc 29 04 25 e0 86 	vmovaps %ymm0,0xb86e0
    f4a8:	0b 00 
    f4aa:	c5 fc 29 04 25 00 87 	vmovaps %ymm0,0xb8700
    f4b1:	0b 00 
    f4b3:	c5 fc 29 04 25 20 87 	vmovaps %ymm0,0xb8720
    f4ba:	0b 00 
    f4bc:	c5 fc 29 04 25 40 87 	vmovaps %ymm0,0xb8740
    f4c3:	0b 00 
    f4c5:	c5 fc 29 04 25 60 87 	vmovaps %ymm0,0xb8760
    f4cc:	0b 00 
    f4ce:	c5 fc 29 04 25 80 87 	vmovaps %ymm0,0xb8780
    f4d5:	0b 00 
    f4d7:	c5 fc 29 04 25 a0 87 	vmovaps %ymm0,0xb87a0
    f4de:	0b 00 
    f4e0:	c5 fc 29 04 25 c0 87 	vmovaps %ymm0,0xb87c0
    f4e7:	0b 00 
    f4e9:	c5 fc 29 04 25 e0 87 	vmovaps %ymm0,0xb87e0
    f4f0:	0b 00 
    f4f2:	c5 fc 29 04 25 00 88 	vmovaps %ymm0,0xb8800
    f4f9:	0b 00 
    f4fb:	c5 fc 29 04 25 20 88 	vmovaps %ymm0,0xb8820
    f502:	0b 00 
    f504:	c5 fc 29 04 25 40 88 	vmovaps %ymm0,0xb8840
    f50b:	0b 00 
    f50d:	c5 fc 29 04 25 60 88 	vmovaps %ymm0,0xb8860
    f514:	0b 00 
    f516:	c5 fc 29 04 25 80 88 	vmovaps %ymm0,0xb8880
    f51d:	0b 00 
    f51f:	c5 fc 29 04 25 a0 88 	vmovaps %ymm0,0xb88a0
    f526:	0b 00 
    f528:	c5 fc 29 04 25 c0 88 	vmovaps %ymm0,0xb88c0
    f52f:	0b 00 
    f531:	c5 fc 29 04 25 e0 88 	vmovaps %ymm0,0xb88e0
    f538:	0b 00 
    f53a:	c5 fc 29 04 25 00 89 	vmovaps %ymm0,0xb8900
    f541:	0b 00 
    f543:	c5 fc 29 04 25 20 89 	vmovaps %ymm0,0xb8920
    f54a:	0b 00 
    f54c:	c5 fc 29 04 25 40 89 	vmovaps %ymm0,0xb8940
    f553:	0b 00 
    f555:	c5 fc 29 04 25 60 89 	vmovaps %ymm0,0xb8960
    f55c:	0b 00 
    f55e:	c5 fc 29 04 25 80 89 	vmovaps %ymm0,0xb8980
    f565:	0b 00 
    f567:	c5 fc 29 04 25 a0 89 	vmovaps %ymm0,0xb89a0
    f56e:	0b 00 
    f570:	c5 fc 29 04 25 c0 89 	vmovaps %ymm0,0xb89c0
    f577:	0b 00 
    f579:	c5 fc 29 04 25 e0 89 	vmovaps %ymm0,0xb89e0
    f580:	0b 00 
    f582:	c5 fc 29 04 25 00 8a 	vmovaps %ymm0,0xb8a00
    f589:	0b 00 
    f58b:	c5 fc 29 04 25 20 8a 	vmovaps %ymm0,0xb8a20
    f592:	0b 00 
    f594:	c5 fc 29 04 25 40 8a 	vmovaps %ymm0,0xb8a40
    f59b:	0b 00 
    f59d:	c5 fc 29 04 25 60 8a 	vmovaps %ymm0,0xb8a60
    f5a4:	0b 00 
    f5a6:	c5 fc 29 04 25 80 8a 	vmovaps %ymm0,0xb8a80
    f5ad:	0b 00 
    f5af:	c5 fc 29 04 25 a0 8a 	vmovaps %ymm0,0xb8aa0
    f5b6:	0b 00 
    f5b8:	c5 fc 29 04 25 c0 8a 	vmovaps %ymm0,0xb8ac0
    f5bf:	0b 00 
    f5c1:	c5 fc 29 04 25 e0 8a 	vmovaps %ymm0,0xb8ae0
    f5c8:	0b 00 
    f5ca:	c5 fc 29 04 25 00 8b 	vmovaps %ymm0,0xb8b00
    f5d1:	0b 00 
    f5d3:	c5 fc 29 04 25 20 8b 	vmovaps %ymm0,0xb8b20
    f5da:	0b 00 
    f5dc:	c5 fc 29 04 25 40 8b 	vmovaps %ymm0,0xb8b40
    f5e3:	0b 00 
    f5e5:	c5 fc 29 04 25 60 8b 	vmovaps %ymm0,0xb8b60
    f5ec:	0b 00 
    f5ee:	c5 fc 29 04 25 80 8b 	vmovaps %ymm0,0xb8b80
    f5f5:	0b 00 
    f5f7:	c5 fc 29 04 25 a0 8b 	vmovaps %ymm0,0xb8ba0
    f5fe:	0b 00 
    f600:	c5 fc 29 04 25 c0 8b 	vmovaps %ymm0,0xb8bc0
    f607:	0b 00 
    f609:	c5 fc 29 04 25 e0 8b 	vmovaps %ymm0,0xb8be0
    f610:	0b 00 
    f612:	c5 fc 29 04 25 00 8c 	vmovaps %ymm0,0xb8c00
    f619:	0b 00 
    f61b:	c5 fc 29 04 25 20 8c 	vmovaps %ymm0,0xb8c20
    f622:	0b 00 
    f624:	c5 fc 29 04 25 40 8c 	vmovaps %ymm0,0xb8c40
    f62b:	0b 00 
    f62d:	c5 fc 29 04 25 60 8c 	vmovaps %ymm0,0xb8c60
    f634:	0b 00 
    f636:	c5 fc 29 04 25 80 8c 	vmovaps %ymm0,0xb8c80
    f63d:	0b 00 
    f63f:	c5 fc 29 04 25 a0 8c 	vmovaps %ymm0,0xb8ca0
    f646:	0b 00 
    f648:	c5 fc 29 04 25 c0 8c 	vmovaps %ymm0,0xb8cc0
    f64f:	0b 00 
    f651:	c5 fc 29 04 25 e0 8c 	vmovaps %ymm0,0xb8ce0
    f658:	0b 00 
    f65a:	c5 fc 29 04 25 00 8d 	vmovaps %ymm0,0xb8d00
    f661:	0b 00 
    f663:	c5 fc 29 04 25 20 8d 	vmovaps %ymm0,0xb8d20
    f66a:	0b 00 
    f66c:	c5 fc 29 04 25 40 8d 	vmovaps %ymm0,0xb8d40
    f673:	0b 00 
    f675:	c5 fc 29 04 25 60 8d 	vmovaps %ymm0,0xb8d60
    f67c:	0b 00 
    f67e:	c5 fc 29 04 25 80 8d 	vmovaps %ymm0,0xb8d80
    f685:	0b 00 
    f687:	c5 fc 29 04 25 a0 8d 	vmovaps %ymm0,0xb8da0
    f68e:	0b 00 
    f690:	c5 fc 29 04 25 c0 8d 	vmovaps %ymm0,0xb8dc0
    f697:	0b 00 
    f699:	c5 fc 29 04 25 e0 8d 	vmovaps %ymm0,0xb8de0
    f6a0:	0b 00 
    f6a2:	c5 fc 29 04 25 00 8e 	vmovaps %ymm0,0xb8e00
    f6a9:	0b 00 
    f6ab:	c5 fc 29 04 25 20 8e 	vmovaps %ymm0,0xb8e20
    f6b2:	0b 00 
    f6b4:	c5 fc 29 04 25 40 8e 	vmovaps %ymm0,0xb8e40
    f6bb:	0b 00 
    f6bd:	c5 fc 29 04 25 60 8e 	vmovaps %ymm0,0xb8e60
    f6c4:	0b 00 
    f6c6:	c5 fc 29 04 25 80 8e 	vmovaps %ymm0,0xb8e80
    f6cd:	0b 00 
    f6cf:	c5 fc 29 04 25 a0 8e 	vmovaps %ymm0,0xb8ea0
    f6d6:	0b 00 
    f6d8:	c5 fc 29 04 25 c0 8e 	vmovaps %ymm0,0xb8ec0
    f6df:	0b 00 
    f6e1:	c5 fc 29 04 25 e0 8e 	vmovaps %ymm0,0xb8ee0
    f6e8:	0b 00 
    f6ea:	c5 fc 29 04 25 00 8f 	vmovaps %ymm0,0xb8f00
    f6f1:	0b 00 
    f6f3:	c5 fc 29 04 25 20 8f 	vmovaps %ymm0,0xb8f20
    f6fa:	0b 00 
    f6fc:	c5 fc 29 04 25 40 8f 	vmovaps %ymm0,0xb8f40
    f703:	0b 00 
    f705:	c5 fc 29 04 25 60 8f 	vmovaps %ymm0,0xb8f60
    f70c:	0b 00 
    f70e:	c4 e2 79 18 05 b5 0d 	vbroadcastss 0xdb5(%rip),%xmm0        # 104cc <end_ctors+0x1ec>
    f715:	00 00 
    f717:	c5 f8 29 04 25 80 8f 	vmovaps %xmm0,0xb8f80
    f71e:	0b 00 
    f720:	c5 f8 29 04 25 90 8f 	vmovaps %xmm0,0xb8f90
    f727:	0b 00 
    f729:	48 c7 04 25 00 00 11 	movq   $0xb8000,0x110000
    f730:	00 00 80 0b 00 
    f735:	c7 04 25 08 00 11 00 	movl   $0x0,0x110008
    f73c:	00 00 00 00 
    f740:	c7 04 25 0c 00 11 00 	movl   $0x0,0x11000c
    f747:	00 00 00 00 
    f74b:	c7 04 25 10 00 11 00 	movl   $0x0,0x110010
    f752:	00 00 00 00 
    f756:	c7 04 25 14 00 11 00 	movl   $0x0,0x110014
    f75d:	00 00 00 00 
    f761:	c7 04 25 18 00 11 00 	movl   $0x50,0x110018
    f768:	50 00 00 00 
    f76c:	c7 04 25 1c 00 11 00 	movl   $0x19,0x11001c
    f773:	19 00 00 00 
    f777:	48 8b 1d 62 0b 00 00 	mov    0xb62(%rip),%rbx        # 102e0 <end_ctors>
    f77e:	48 3b 1d 5b 0b 00 00 	cmp    0xb5b(%rip),%rbx        # 102e0 <end_ctors>
    f785:	74 17                	je     f79e <_Z11init_libcppv+0x53e>
    f787:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    f78e:	00 00 
    f790:	c5 f8 77             	vzeroupper 
    f793:	ff d3                	call   *%rbx
    f795:	48 3b 1d 44 0b 00 00 	cmp    0xb44(%rip),%rbx        # 102e0 <end_ctors>
    f79c:	75 f2                	jne    f790 <_Z11init_libcppv+0x530>
    f79e:	5b                   	pop    %rbx
    f79f:	c5 f8 77             	vzeroupper 
    f7a2:	c3                   	ret    
    f7a3:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    f7aa:	00 00 00 
    f7ad:	0f 1f 00             	nopl   (%rax)

000000000000f7b0 <_Z7inc_pitv>:
    f7b0:	48 83 ec 48          	sub    $0x48,%rsp
    f7b4:	48 ff 04 25 c0 00 11 	incq   0x1100c0
    f7bb:	00 
    f7bc:	8b 14 25 28 00 11 00 	mov    0x110028,%edx
    f7c3:	48 c7 44 24 38 ca 0b 	movq   $0x10bca,0x38(%rsp)
    f7ca:	01 00 
    f7cc:	c7 44 24 40 05 00 00 	movl   $0x5,0x40(%rsp)
    f7d3:	00 
    f7d4:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
    f7d9:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
    f7de:	31 c0                	xor    %eax,%eax
    f7e0:	e8 bb 95 ff ff       	call   8da0 <_Z6format8rostringz>
    f7e5:	8b 44 24 20          	mov    0x20(%rsp),%eax
    f7e9:	85 c0                	test   %eax,%eax
    f7eb:	0f 8e ab 00 00 00    	jle    f89c <_Z7inc_pitv+0xec>
    f7f1:	b9 4f 00 00 00       	mov    $0x4f,%ecx
    f7f6:	eb 35                	jmp    f82d <_Z7inc_pitv+0x7d>
    f7f8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    f7ff:	00 
    f800:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
    f805:	89 d7                	mov    %edx,%edi
    f807:	0f b6 34 3e          	movzbl (%rsi,%rdi,1),%esi
    f80b:	40 0f be f6          	movsbl %sil,%esi
    f80f:	81 ce 00 0f 00 00    	or     $0xf00,%esi
    f815:	48 8b 3c 25 00 00 11 	mov    0x110000,%rdi
    f81c:	00 
    f81d:	66 89 34 4f          	mov    %si,(%rdi,%rcx,2)
    f821:	48 ff c9             	dec    %rcx
    f824:	48 83 f8 01          	cmp    $0x1,%rax
    f828:	48 89 d0             	mov    %rdx,%rax
    f82b:	7e 6f                	jle    f89c <_Z7inc_pitv+0xec>
    f82d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
    f831:	83 7c 24 20 00       	cmpl   $0x0,0x20(%rsp)
    f836:	75 c8                	jne    f800 <_Z7inc_pitv+0x50>
    f838:	48 8b 34 25 00 00 00 	mov    0x1000000,%rsi
    f83f:	01 
    f840:	bf 00 00 00 01       	mov    $0x1000000,%edi
    f845:	48 83 fe 1f          	cmp    $0x1f,%rsi
    f849:	77 12                	ja     f85d <_Z7inc_pitv+0xad>
    f84b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
    f850:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
    f854:	48 8b 37             	mov    (%rdi),%rsi
    f857:	48 83 fe 20          	cmp    $0x20,%rsi
    f85b:	72 f3                	jb     f850 <_Z7inc_pitv+0xa0>
    f85d:	4c 8b 47 08          	mov    0x8(%rdi),%r8
    f861:	4c 8d 4e e0          	lea    -0x20(%rsi),%r9
    f865:	49 83 f9 0f          	cmp    $0xf,%r9
    f869:	77 0b                	ja     f876 <_Z7inc_pitv+0xc6>
    f86b:	c4 c1 78 10 00       	vmovups (%r8),%xmm0
    f870:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    f874:	eb 0f                	jmp    f885 <_Z7inc_pitv+0xd5>
    f876:	4c 89 0f             	mov    %r9,(%rdi)
    f879:	49 c1 e1 04          	shl    $0x4,%r9
    f87d:	4d 01 c8             	add    %r9,%r8
    f880:	be 20 00 00 00       	mov    $0x20,%esi
    f885:	49 89 30             	mov    %rsi,(%r8)
    f888:	48 01 34 25 28 00 11 	add    %rsi,0x110028
    f88f:	00 
    f890:	41 c6 40 10 00       	movb   $0x0,0x10(%r8)
    f895:	31 f6                	xor    %esi,%esi
    f897:	e9 6f ff ff ff       	jmp    f80b <_Z7inc_pitv+0x5b>
    f89c:	48 c7 44 24 28 ca 0b 	movq   $0x10bca,0x28(%rsp)
    f8a3:	01 00 
    f8a5:	c7 44 24 30 05 00 00 	movl   $0x5,0x30(%rsp)
    f8ac:	00 
    f8ad:	48 c7 c2 00 00 c0 ff 	mov    $0xffffffffffc00000,%rdx
    f8b4:	48 03 14 25 20 00 11 	add    0x110020,%rdx
    f8bb:	00 
    f8bc:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
    f8c1:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
    f8c6:	31 c0                	xor    %eax,%eax
    f8c8:	e8 d3 94 ff ff       	call   8da0 <_Z6format8rostringz>
    f8cd:	8b 44 24 10          	mov    0x10(%rsp),%eax
    f8d1:	85 c0                	test   %eax,%eax
    f8d3:	0f 8e b3 00 00 00    	jle    f98c <_Z7inc_pitv+0x1dc>
    f8d9:	b9 4f 00 00 00       	mov    $0x4f,%ecx
    f8de:	eb 3b                	jmp    f91b <_Z7inc_pitv+0x16b>
    f8e0:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
    f8e5:	89 d7                	mov    %edx,%edi
    f8e7:	0f b6 34 3e          	movzbl (%rsi,%rdi,1),%esi
    f8eb:	40 0f be f6          	movsbl %sil,%esi
    f8ef:	81 ce 00 0f 00 00    	or     $0xf00,%esi
    f8f5:	48 8b 3c 25 00 00 11 	mov    0x110000,%rdi
    f8fc:	00 
    f8fd:	4c 63 04 25 18 00 11 	movslq 0x110018,%r8
    f904:	00 
    f905:	4c 63 c9             	movslq %ecx,%r9
    f908:	ff c9                	dec    %ecx
    f90a:	4d 01 c1             	add    %r8,%r9
    f90d:	66 42 89 34 4f       	mov    %si,(%rdi,%r9,2)
    f912:	48 83 f8 01          	cmp    $0x1,%rax
    f916:	48 89 d0             	mov    %rdx,%rax
    f919:	7e 71                	jle    f98c <_Z7inc_pitv+0x1dc>
    f91b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
    f91f:	83 7c 24 10 00       	cmpl   $0x0,0x10(%rsp)
    f924:	75 ba                	jne    f8e0 <_Z7inc_pitv+0x130>
    f926:	48 8b 34 25 00 00 00 	mov    0x1000000,%rsi
    f92d:	01 
    f92e:	bf 00 00 00 01       	mov    $0x1000000,%edi
    f933:	48 83 fe 1f          	cmp    $0x1f,%rsi
    f937:	77 14                	ja     f94d <_Z7inc_pitv+0x19d>
    f939:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    f940:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
    f944:	48 8b 37             	mov    (%rdi),%rsi
    f947:	48 83 fe 20          	cmp    $0x20,%rsi
    f94b:	72 f3                	jb     f940 <_Z7inc_pitv+0x190>
    f94d:	4c 8b 47 08          	mov    0x8(%rdi),%r8
    f951:	4c 8d 4e e0          	lea    -0x20(%rsi),%r9
    f955:	49 83 f9 0f          	cmp    $0xf,%r9
    f959:	77 0b                	ja     f966 <_Z7inc_pitv+0x1b6>
    f95b:	c4 c1 78 10 00       	vmovups (%r8),%xmm0
    f960:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    f964:	eb 0f                	jmp    f975 <_Z7inc_pitv+0x1c5>
    f966:	4c 89 0f             	mov    %r9,(%rdi)
    f969:	49 c1 e1 04          	shl    $0x4,%r9
    f96d:	4d 01 c8             	add    %r9,%r8
    f970:	be 20 00 00 00       	mov    $0x20,%esi
    f975:	49 89 30             	mov    %rsi,(%r8)
    f978:	48 01 34 25 28 00 11 	add    %rsi,0x110028
    f97f:	00 
    f980:	41 c6 40 10 00       	movb   $0x0,0x10(%r8)
    f985:	31 f6                	xor    %esi,%esi
    f987:	e9 5f ff ff ff       	jmp    f8eb <_Z7inc_pitv+0x13b>
    f98c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    f991:	48 85 c0             	test   %rax,%rax
    f994:	74 2e                	je     f9c4 <_Z7inc_pitv+0x214>
    f996:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    f99a:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    f99e:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    f9a5:	00 01 
    f9a7:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    f9ac:	48 89 14 25 00 00 00 	mov    %rdx,0x1000000
    f9b3:	01 
    f9b4:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    f9bb:	01 
    f9bc:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    f9c3:	00 
    f9c4:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    f9c9:	48 85 c0             	test   %rax,%rax
    f9cc:	74 2e                	je     f9fc <_Z7inc_pitv+0x24c>
    f9ce:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    f9d2:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    f9d6:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    f9dd:	00 01 
    f9df:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    f9e4:	48 89 14 25 00 00 00 	mov    %rdx,0x1000000
    f9eb:	01 
    f9ec:	48 89 0c 25 08 00 00 	mov    %rcx,0x1000008
    f9f3:	01 
    f9f4:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    f9fb:	00 
    f9fc:	48 83 c4 48          	add    $0x48,%rsp
    fa00:	c3                   	ret    
    fa01:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    fa08:	00 00 00 
    fa0b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

000000000000fa10 <_Z9time_initv>:
    fa10:	48 83 ec 18          	sub    $0x18,%rsp
    fa14:	48 8d 7c 24 0c       	lea    0xc(%rsp),%rdi
    fa19:	31 f6                	xor    %esi,%esi
    fa1b:	e8 20 00 00 00       	call   fa40 <_ZN9timepointC1Em>
    fa20:	48 c7 04 25 c0 00 11 	movq   $0x0,0x1100c0
    fa27:	00 00 00 00 00 
    fa2c:	48 83 c4 18          	add    $0x18,%rsp
    fa30:	c3                   	ret    
    fa31:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    fa38:	00 00 00 
    fa3b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

000000000000fa40 <_ZN9timepointC1Em>:
    fa40:	48 89 f2             	mov    %rsi,%rdx
    fa43:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    fa4a:	84 00 00 00 00 00 
    fa50:	b0 0a                	mov    $0xa,%al
    fa52:	e6 70                	out    %al,$0x70
    fa54:	e4 71                	in     $0x71,%al
    fa56:	84 c0                	test   %al,%al
    fa58:	78 f6                	js     fa50 <_ZN9timepointC1Em+0x10>
    fa5a:	b0 09                	mov    $0x9,%al
    fa5c:	e6 70                	out    %al,$0x70
    fa5e:	e4 71                	in     $0x71,%al
    fa60:	88 07                	mov    %al,(%rdi)
    fa62:	b0 08                	mov    $0x8,%al
    fa64:	e6 70                	out    %al,$0x70
    fa66:	e4 71                	in     $0x71,%al
    fa68:	88 47 01             	mov    %al,0x1(%rdi)
    fa6b:	b0 07                	mov    $0x7,%al
    fa6d:	e6 70                	out    %al,$0x70
    fa6f:	e4 71                	in     $0x71,%al
    fa71:	88 47 02             	mov    %al,0x2(%rdi)
    fa74:	b0 04                	mov    $0x4,%al
    fa76:	e6 70                	out    %al,$0x70
    fa78:	e4 71                	in     $0x71,%al
    fa7a:	88 47 03             	mov    %al,0x3(%rdi)
    fa7d:	b0 02                	mov    $0x2,%al
    fa7f:	e6 70                	out    %al,$0x70
    fa81:	e4 71                	in     $0x71,%al
    fa83:	88 47 04             	mov    %al,0x4(%rdi)
    fa86:	31 c0                	xor    %eax,%eax
    fa88:	e6 70                	out    %al,$0x70
    fa8a:	e4 71                	in     $0x71,%al
    fa8c:	89 c1                	mov    %eax,%ecx
    fa8e:	80 e1 0f             	and    $0xf,%cl
    fa91:	c0 e8 04             	shr    $0x4,%al
    fa94:	0f b6 c0             	movzbl %al,%eax
    fa97:	01 c0                	add    %eax,%eax
    fa99:	8d 34 80             	lea    (%rax,%rax,4),%esi
    fa9c:	40 00 ce             	add    %cl,%sil
    fa9f:	0f b6 47 04          	movzbl 0x4(%rdi),%eax
    faa3:	89 c1                	mov    %eax,%ecx
    faa5:	83 e1 0f             	and    $0xf,%ecx
    faa8:	c1 e8 04             	shr    $0x4,%eax
    faab:	8d 04 80             	lea    (%rax,%rax,4),%eax
    faae:	8d 04 41             	lea    (%rcx,%rax,2),%eax
    fab1:	44 0f b6 47 03       	movzbl 0x3(%rdi),%r8d
    fab6:	44 89 c1             	mov    %r8d,%ecx
    fab9:	80 e1 0f             	and    $0xf,%cl
    fabc:	45 89 c1             	mov    %r8d,%r9d
    fabf:	41 c0 e9 04          	shr    $0x4,%r9b
    fac3:	41 80 e1 07          	and    $0x7,%r9b
    fac7:	45 0f b6 c9          	movzbl %r9b,%r9d
    facb:	45 01 c9             	add    %r9d,%r9d
    face:	47 8d 0c 89          	lea    (%r9,%r9,4),%r9d
    fad2:	41 00 c9             	add    %cl,%r9b
    fad5:	41 80 e0 80          	and    $0x80,%r8b
    fad9:	45 08 c8             	or     %r9b,%r8b
    fadc:	0f b6 4f 02          	movzbl 0x2(%rdi),%ecx
    fae0:	41 89 c9             	mov    %ecx,%r9d
    fae3:	41 80 e1 0f          	and    $0xf,%r9b
    fae7:	c0 e9 04             	shr    $0x4,%cl
    faea:	0f b6 c9             	movzbl %cl,%ecx
    faed:	01 c9                	add    %ecx,%ecx
    faef:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
    faf2:	44 00 c9             	add    %r9b,%cl
    faf5:	44 0f b6 0f          	movzbl (%rdi),%r9d
    faf9:	44 0f b6 57 01       	movzbl 0x1(%rdi),%r10d
    fafe:	45 89 d3             	mov    %r10d,%r11d
    fb01:	41 80 e3 0f          	and    $0xf,%r11b
    fb05:	41 c0 ea 04          	shr    $0x4,%r10b
    fb09:	45 0f b6 d2          	movzbl %r10b,%r10d
    fb0d:	45 01 d2             	add    %r10d,%r10d
    fb10:	47 8d 14 92          	lea    (%r10,%r10,4),%r10d
    fb14:	45 00 da             	add    %r11b,%r10b
    fb17:	44 88 57 01          	mov    %r10b,0x1(%rdi)
    fb1b:	45 89 ca             	mov    %r9d,%r10d
    fb1e:	41 80 e2 0f          	and    $0xf,%r10b
    fb22:	41 c0 e9 04          	shr    $0x4,%r9b
    fb26:	45 0f b6 c9          	movzbl %r9b,%r9d
    fb2a:	45 01 c9             	add    %r9d,%r9d
    fb2d:	47 8d 0c 89          	lea    (%r9,%r9,4),%r9d
    fb31:	45 00 d1             	add    %r10b,%r9b
    fb34:	44 88 0f             	mov    %r9b,(%rdi)
    fb37:	49 b9 db 34 b6 d7 82 	movabs $0x431bde82d7b634db,%r9
    fb3e:	de 1b 43 
    fb41:	c4 42 b3 f6 c9       	mulx   %r9,%r9,%r9
    fb46:	49 c1 e9 12          	shr    $0x12,%r9
    fb4a:	45 69 d1 40 42 0f 00 	imul   $0xf4240,%r9d,%r10d
    fb51:	44 29 d2             	sub    %r10d,%edx
    fb54:	89 57 08             	mov    %edx,0x8(%rdi)
    fb57:	40 0f b6 d6          	movzbl %sil,%edx
    fb5b:	4c 01 ca             	add    %r9,%rdx
    fb5e:	48 be 45 44 44 44 44 	movabs $0x444444444444445,%rsi
    fb65:	44 44 04 
    fb68:	c4 62 b3 f6 ce       	mulx   %rsi,%r9,%r9
    fb6d:	44 01 c8             	add    %r9d,%eax
    fb70:	41 0f b6 f0          	movzbl %r8b,%esi
    fb74:	41 b8 89 88 88 88    	mov    $0x88888889,%r8d
    fb7a:	4c 0f af c0          	imul   %rax,%r8
    fb7e:	49 c1 e8 25          	shr    $0x25,%r8
    fb82:	44 01 c6             	add    %r8d,%esi
    fb85:	45 6b c9 3c          	imul   $0x3c,%r9d,%r9d
    fb89:	44 29 ca             	sub    %r9d,%edx
    fb8c:	88 57 05             	mov    %dl,0x5(%rdi)
    fb8f:	41 6b d0 3c          	imul   $0x3c,%r8d,%edx
    fb93:	29 d0                	sub    %edx,%eax
    fb95:	88 47 04             	mov    %al,0x4(%rdi)
    fb98:	48 69 c6 ab aa aa 0a 	imul   $0xaaaaaab,%rsi,%rax
    fb9f:	48 c1 e8 20          	shr    $0x20,%rax
    fba3:	8d 14 c5 00 00 00 00 	lea    0x0(,%rax,8),%edx
    fbaa:	8d 14 52             	lea    (%rdx,%rdx,2),%edx
    fbad:	29 d6                	sub    %edx,%esi
    fbaf:	40 88 77 03          	mov    %sil,0x3(%rdi)
    fbb3:	00 c8                	add    %cl,%al
    fbb5:	88 47 02             	mov    %al,0x2(%rdi)
    fbb8:	c3                   	ret    
    fbb9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

000000000000fbc0 <_Z8pic_initv>:
    fbc0:	e4 21                	in     $0x21,%al
    fbc2:	89 c1                	mov    %eax,%ecx
    fbc4:	e4 a1                	in     $0xa1,%al
    fbc6:	89 c2                	mov    %eax,%edx
    fbc8:	b0 11                	mov    $0x11,%al
    fbca:	e6 20                	out    %al,$0x20
    fbcc:	31 c0                	xor    %eax,%eax
    fbce:	e6 80                	out    %al,$0x80
    fbd0:	b0 11                	mov    $0x11,%al
    fbd2:	e6 a0                	out    %al,$0xa0
    fbd4:	31 c0                	xor    %eax,%eax
    fbd6:	e6 80                	out    %al,$0x80
    fbd8:	b0 20                	mov    $0x20,%al
    fbda:	e6 21                	out    %al,$0x21
    fbdc:	31 c0                	xor    %eax,%eax
    fbde:	e6 80                	out    %al,$0x80
    fbe0:	b0 28                	mov    $0x28,%al
    fbe2:	e6 a1                	out    %al,$0xa1
    fbe4:	31 c0                	xor    %eax,%eax
    fbe6:	e6 80                	out    %al,$0x80
    fbe8:	b0 04                	mov    $0x4,%al
    fbea:	e6 21                	out    %al,$0x21
    fbec:	31 c0                	xor    %eax,%eax
    fbee:	e6 80                	out    %al,$0x80
    fbf0:	b0 02                	mov    $0x2,%al
    fbf2:	e6 a1                	out    %al,$0xa1
    fbf4:	31 c0                	xor    %eax,%eax
    fbf6:	e6 80                	out    %al,$0x80
    fbf8:	b0 01                	mov    $0x1,%al
    fbfa:	e6 21                	out    %al,$0x21
    fbfc:	31 c0                	xor    %eax,%eax
    fbfe:	e6 80                	out    %al,$0x80
    fc00:	b0 01                	mov    $0x1,%al
    fc02:	e6 a1                	out    %al,$0xa1
    fc04:	31 c0                	xor    %eax,%eax
    fc06:	e6 80                	out    %al,$0x80
    fc08:	89 c8                	mov    %ecx,%eax
    fc0a:	e6 21                	out    %al,$0x21
    fc0c:	89 d0                	mov    %edx,%eax
    fc0e:	e6 a1                	out    %al,$0xa1
    fc10:	c3                   	ret    
    fc11:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    fc18:	00 00 00 
    fc1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

000000000000fc20 <_ZN6vectorI13fat_disk_spanE2atEi>:
    fc20:	8b 4f 0c             	mov    0xc(%rdi),%ecx
    fc23:	39 f1                	cmp    %esi,%ecx
    fc25:	7e 08                	jle    fc2f <_ZN6vectorI13fat_disk_spanE2atEi+0xf>
    fc27:	48 8b 0f             	mov    (%rdi),%rcx
    fc2a:	e9 14 01 00 00       	jmp    fd43 <_ZN6vectorI13fat_disk_spanE2atEi+0x123>
    fc2f:	83 f9 02             	cmp    $0x2,%ecx
    fc32:	b8 01 00 00 00       	mov    $0x1,%eax
    fc37:	0f 4d c1             	cmovge %ecx,%eax
    fc3a:	39 f0                	cmp    %esi,%eax
    fc3c:	7f 12                	jg     fc50 <_ZN6vectorI13fat_disk_spanE2atEi+0x30>
    fc3e:	66 90                	xchg   %ax,%ax
    fc40:	c5 f2 2a c0          	vcvtsi2ss %eax,%xmm1,%xmm0
    fc44:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    fc48:	c5 fa 2c c0          	vcvttss2si %xmm0,%eax
    fc4c:	39 f0                	cmp    %esi,%eax
    fc4e:	7e f0                	jle    fc40 <_ZN6vectorI13fat_disk_spanE2atEi+0x20>
    fc50:	89 c1                	mov    %eax,%ecx
    fc52:	48 8d 14 cd 1f 00 00 	lea    0x1f(,%rcx,8),%rdx
    fc59:	00 
    fc5a:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
    fc5e:	85 c0                	test   %eax,%eax
    fc60:	b9 10 00 00 00       	mov    $0x10,%ecx
    fc65:	48 0f 48 d1          	cmovs  %rcx,%rdx
    fc69:	48 85 d2             	test   %rdx,%rdx
    fc6c:	48 0f 44 d1          	cmove  %rcx,%rdx
    fc70:	4c 8b 04 25 00 00 00 	mov    0x1000000,%r8
    fc77:	01 
    fc78:	41 b9 00 00 00 01    	mov    $0x1000000,%r9d
    fc7e:	49 39 d0             	cmp    %rdx,%r8
    fc81:	73 19                	jae    fc9c <_ZN6vectorI13fat_disk_spanE2atEi+0x7c>
    fc83:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    fc8a:	84 00 00 00 00 00 
    fc90:	4d 8b 49 08          	mov    0x8(%r9),%r9
    fc94:	4d 8b 01             	mov    (%r9),%r8
    fc97:	49 39 d0             	cmp    %rdx,%r8
    fc9a:	72 f4                	jb     fc90 <_ZN6vectorI13fat_disk_spanE2atEi+0x70>
    fc9c:	49 8b 49 08          	mov    0x8(%r9),%rcx
    fca0:	4d 89 c2             	mov    %r8,%r10
    fca3:	49 29 d2             	sub    %rdx,%r10
    fca6:	49 83 fa 0f          	cmp    $0xf,%r10
    fcaa:	77 0b                	ja     fcb7 <_ZN6vectorI13fat_disk_spanE2atEi+0x97>
    fcac:	c5 f8 10 01          	vmovups (%rcx),%xmm0
    fcb0:	c4 c1 78 11 01       	vmovups %xmm0,(%r9)
    fcb5:	eb 0d                	jmp    fcc4 <_ZN6vectorI13fat_disk_spanE2atEi+0xa4>
    fcb7:	4d 89 11             	mov    %r10,(%r9)
    fcba:	49 c1 e2 04          	shl    $0x4,%r10
    fcbe:	4c 01 d1             	add    %r10,%rcx
    fcc1:	49 89 d0             	mov    %rdx,%r8
    fcc4:	4c 89 01             	mov    %r8,(%rcx)
    fcc7:	4c 01 04 25 28 00 11 	add    %r8,0x110028
    fcce:	00 
    fccf:	48 83 c1 10          	add    $0x10,%rcx
    fcd3:	48 8b 17             	mov    (%rdi),%rdx
    fcd6:	48 85 d2             	test   %rdx,%rdx
    fcd9:	74 62                	je     fd3d <_ZN6vectorI13fat_disk_spanE2atEi+0x11d>
    fcdb:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    fcdf:	7e 2e                	jle    fd0f <_ZN6vectorI13fat_disk_spanE2atEi+0xef>
    fce1:	31 d2                	xor    %edx,%edx
    fce3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    fcea:	84 00 00 00 00 00 
    fcf0:	4c 8b 07             	mov    (%rdi),%r8
    fcf3:	4d 8b 04 d0          	mov    (%r8,%rdx,8),%r8
    fcf7:	4c 89 04 d1          	mov    %r8,(%rcx,%rdx,8)
    fcfb:	48 ff c2             	inc    %rdx
    fcfe:	4c 63 47 08          	movslq 0x8(%rdi),%r8
    fd02:	4c 39 c2             	cmp    %r8,%rdx
    fd05:	7c e9                	jl     fcf0 <_ZN6vectorI13fat_disk_spanE2atEi+0xd0>
    fd07:	48 8b 17             	mov    (%rdi),%rdx
    fd0a:	48 85 d2             	test   %rdx,%rdx
    fd0d:	74 2e                	je     fd3d <_ZN6vectorI13fat_disk_spanE2atEi+0x11d>
    fd0f:	4c 8d 42 f0          	lea    -0x10(%rdx),%r8
    fd13:	4c 8b 4a f0          	mov    -0x10(%rdx),%r9
    fd17:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    fd1e:	00 01 
    fd20:	c5 f8 11 42 f0       	vmovups %xmm0,-0x10(%rdx)
    fd25:	4c 89 0c 25 00 00 00 	mov    %r9,0x1000000
    fd2c:	01 
    fd2d:	4c 89 04 25 08 00 00 	mov    %r8,0x1000008
    fd34:	01 
    fd35:	4c 29 0c 25 28 00 11 	sub    %r9,0x110028
    fd3c:	00 
    fd3d:	48 89 0f             	mov    %rcx,(%rdi)
    fd40:	89 47 0c             	mov    %eax,0xc(%rdi)
    fd43:	8b 47 08             	mov    0x8(%rdi),%eax
    fd46:	8d 56 01             	lea    0x1(%rsi),%edx
    fd49:	39 d0                	cmp    %edx,%eax
    fd4b:	0f 4f d0             	cmovg  %eax,%edx
    fd4e:	89 57 08             	mov    %edx,0x8(%rdi)
    fd51:	48 63 c6             	movslq %esi,%rax
    fd54:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
    fd58:	c3                   	ret    
    fd59:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

000000000000fd60 <_ZN6vectorIcE2atEi>:
    fd60:	8b 4f 0c             	mov    0xc(%rdi),%ecx
    fd63:	39 f1                	cmp    %esi,%ecx
    fd65:	7e 08                	jle    fd6f <_ZN6vectorIcE2atEi+0xf>
    fd67:	48 8b 0f             	mov    (%rdi),%rcx
    fd6a:	e9 05 01 00 00       	jmp    fe74 <_ZN6vectorIcE2atEi+0x114>
    fd6f:	83 f9 02             	cmp    $0x2,%ecx
    fd72:	b8 01 00 00 00       	mov    $0x1,%eax
    fd77:	0f 4d c1             	cmovge %ecx,%eax
    fd7a:	39 f0                	cmp    %esi,%eax
    fd7c:	7f 12                	jg     fd90 <_ZN6vectorIcE2atEi+0x30>
    fd7e:	66 90                	xchg   %ax,%ax
    fd80:	c5 f2 2a c0          	vcvtsi2ss %eax,%xmm1,%xmm0
    fd84:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    fd88:	c5 fa 2c c0          	vcvttss2si %xmm0,%eax
    fd8c:	39 f0                	cmp    %esi,%eax
    fd8e:	7e f0                	jle    fd80 <_ZN6vectorIcE2atEi+0x20>
    fd90:	48 63 c8             	movslq %eax,%rcx
    fd93:	48 83 c1 1f          	add    $0x1f,%rcx
    fd97:	48 83 e1 f0          	and    $0xfffffffffffffff0,%rcx
    fd9b:	ba 10 00 00 00       	mov    $0x10,%edx
    fda0:	48 0f 45 d1          	cmovne %rcx,%rdx
    fda4:	4c 8b 04 25 00 00 00 	mov    0x1000000,%r8
    fdab:	01 
    fdac:	41 b9 00 00 00 01    	mov    $0x1000000,%r9d
    fdb2:	49 39 d0             	cmp    %rdx,%r8
    fdb5:	73 15                	jae    fdcc <_ZN6vectorIcE2atEi+0x6c>
    fdb7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    fdbe:	00 00 
    fdc0:	4d 8b 49 08          	mov    0x8(%r9),%r9
    fdc4:	4d 8b 01             	mov    (%r9),%r8
    fdc7:	49 39 d0             	cmp    %rdx,%r8
    fdca:	72 f4                	jb     fdc0 <_ZN6vectorIcE2atEi+0x60>
    fdcc:	49 8b 49 08          	mov    0x8(%r9),%rcx
    fdd0:	4d 89 c2             	mov    %r8,%r10
    fdd3:	49 29 d2             	sub    %rdx,%r10
    fdd6:	49 83 fa 0f          	cmp    $0xf,%r10
    fdda:	77 0b                	ja     fde7 <_ZN6vectorIcE2atEi+0x87>
    fddc:	c5 f8 10 01          	vmovups (%rcx),%xmm0
    fde0:	c4 c1 78 11 01       	vmovups %xmm0,(%r9)
    fde5:	eb 0d                	jmp    fdf4 <_ZN6vectorIcE2atEi+0x94>
    fde7:	4d 89 11             	mov    %r10,(%r9)
    fdea:	49 c1 e2 04          	shl    $0x4,%r10
    fdee:	4c 01 d1             	add    %r10,%rcx
    fdf1:	49 89 d0             	mov    %rdx,%r8
    fdf4:	4c 89 01             	mov    %r8,(%rcx)
    fdf7:	4c 01 04 25 28 00 11 	add    %r8,0x110028
    fdfe:	00 
    fdff:	48 83 c1 10          	add    $0x10,%rcx
    fe03:	48 8b 17             	mov    (%rdi),%rdx
    fe06:	48 85 d2             	test   %rdx,%rdx
    fe09:	74 63                	je     fe6e <_ZN6vectorIcE2atEi+0x10e>
    fe0b:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    fe0f:	7e 2f                	jle    fe40 <_ZN6vectorIcE2atEi+0xe0>
    fe11:	31 d2                	xor    %edx,%edx
    fe13:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    fe1a:	84 00 00 00 00 00 
    fe20:	4c 8b 07             	mov    (%rdi),%r8
    fe23:	45 0f b6 04 10       	movzbl (%r8,%rdx,1),%r8d
    fe28:	44 88 04 11          	mov    %r8b,(%rcx,%rdx,1)
    fe2c:	48 ff c2             	inc    %rdx
    fe2f:	4c 63 47 08          	movslq 0x8(%rdi),%r8
    fe33:	4c 39 c2             	cmp    %r8,%rdx
    fe36:	7c e8                	jl     fe20 <_ZN6vectorIcE2atEi+0xc0>
    fe38:	48 8b 17             	mov    (%rdi),%rdx
    fe3b:	48 85 d2             	test   %rdx,%rdx
    fe3e:	74 2e                	je     fe6e <_ZN6vectorIcE2atEi+0x10e>
    fe40:	4c 8d 42 f0          	lea    -0x10(%rdx),%r8
    fe44:	4c 8b 4a f0          	mov    -0x10(%rdx),%r9
    fe48:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
    fe4f:	00 01 
    fe51:	c5 f8 11 42 f0       	vmovups %xmm0,-0x10(%rdx)
    fe56:	4c 89 0c 25 00 00 00 	mov    %r9,0x1000000
    fe5d:	01 
    fe5e:	4c 89 04 25 08 00 00 	mov    %r8,0x1000008
    fe65:	01 
    fe66:	4c 29 0c 25 28 00 11 	sub    %r9,0x110028
    fe6d:	00 
    fe6e:	48 89 0f             	mov    %rcx,(%rdi)
    fe71:	89 47 0c             	mov    %eax,0xc(%rdi)
    fe74:	8b 47 08             	mov    0x8(%rdi),%eax
    fe77:	8d 56 01             	lea    0x1(%rsi),%edx
    fe7a:	39 d0                	cmp    %edx,%eax
    fe7c:	0f 4f d0             	cmovg  %eax,%edx
    fe7f:	89 57 08             	mov    %edx,0x8(%rdi)
    fe82:	48 63 c6             	movslq %esi,%rax
    fe85:	48 01 c8             	add    %rcx,%rax
    fe88:	c3                   	ret    
    fe89:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

000000000000fe90 <_ZN6vectorIPjE2atEi>:
    fe90:	8b 4f 0c             	mov    0xc(%rdi),%ecx
    fe93:	39 f1                	cmp    %esi,%ecx
    fe95:	7e 08                	jle    fe9f <_ZN6vectorIPjE2atEi+0xf>
    fe97:	48 8b 0f             	mov    (%rdi),%rcx
    fe9a:	e9 b0 01 00 00       	jmp    1004f <_ZN6vectorIPjE2atEi+0x1bf>
    fe9f:	83 f9 02             	cmp    $0x2,%ecx
    fea2:	b8 01 00 00 00       	mov    $0x1,%eax
    fea7:	0f 4d c1             	cmovge %ecx,%eax
    feaa:	39 f0                	cmp    %esi,%eax
    feac:	7f 12                	jg     fec0 <_ZN6vectorIPjE2atEi+0x30>
    feae:	66 90                	xchg   %ax,%ax
    feb0:	c5 f2 2a c0          	vcvtsi2ss %eax,%xmm1,%xmm0
    feb4:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    feb8:	c5 fa 2c c0          	vcvttss2si %xmm0,%eax
    febc:	39 f0                	cmp    %esi,%eax
    febe:	7e f0                	jle    feb0 <_ZN6vectorIPjE2atEi+0x20>
    fec0:	89 c1                	mov    %eax,%ecx
    fec2:	48 8d 14 cd 1f 00 00 	lea    0x1f(,%rcx,8),%rdx
    fec9:	00 
    feca:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
    fece:	85 c0                	test   %eax,%eax
    fed0:	b9 10 00 00 00       	mov    $0x10,%ecx
    fed5:	48 0f 48 d1          	cmovs  %rcx,%rdx
    fed9:	48 85 d2             	test   %rdx,%rdx
    fedc:	48 0f 44 d1          	cmove  %rcx,%rdx
    fee0:	4c 8b 04 25 00 00 00 	mov    0x1000000,%r8
    fee7:	01 
    fee8:	41 b9 00 00 00 01    	mov    $0x1000000,%r9d
    feee:	49 39 d0             	cmp    %rdx,%r8
    fef1:	73 19                	jae    ff0c <_ZN6vectorIPjE2atEi+0x7c>
    fef3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
    fefa:	84 00 00 00 00 00 
    ff00:	4d 8b 49 08          	mov    0x8(%r9),%r9
    ff04:	4d 8b 01             	mov    (%r9),%r8
    ff07:	49 39 d0             	cmp    %rdx,%r8
    ff0a:	72 f4                	jb     ff00 <_ZN6vectorIPjE2atEi+0x70>
    ff0c:	49 8b 49 08          	mov    0x8(%r9),%rcx
    ff10:	4d 89 c2             	mov    %r8,%r10
    ff13:	49 29 d2             	sub    %rdx,%r10
    ff16:	49 83 fa 0f          	cmp    $0xf,%r10
    ff1a:	77 0b                	ja     ff27 <_ZN6vectorIPjE2atEi+0x97>
    ff1c:	c5 f8 10 01          	vmovups (%rcx),%xmm0
    ff20:	c4 c1 78 11 01       	vmovups %xmm0,(%r9)
    ff25:	eb 0d                	jmp    ff34 <_ZN6vectorIPjE2atEi+0xa4>
    ff27:	4d 89 11             	mov    %r10,(%r9)
    ff2a:	49 c1 e2 04          	shl    $0x4,%r10
    ff2e:	4c 01 d1             	add    %r10,%rcx
    ff31:	49 89 d0             	mov    %rdx,%r8
    ff34:	4c 89 01             	mov    %r8,(%rcx)
    ff37:	4c 01 04 25 28 00 11 	add    %r8,0x110028
    ff3e:	00 
    ff3f:	48 83 c1 10          	add    $0x10,%rcx
    ff43:	48 8b 17             	mov    (%rdi),%rdx
    ff46:	48 85 d2             	test   %rdx,%rdx
    ff49:	0f 84 fa 00 00 00    	je     10049 <_ZN6vectorIPjE2atEi+0x1b9>
    ff4f:	44 8b 4f 08          	mov    0x8(%rdi),%r9d
    ff53:	45 85 c9             	test   %r9d,%r9d
    ff56:	0f 8e bf 00 00 00    	jle    1001b <_ZN6vectorIPjE2atEi+0x18b>
    ff5c:	44 89 ca             	mov    %r9d,%edx
    ff5f:	83 e2 07             	and    $0x7,%edx
    ff62:	41 83 f9 08          	cmp    $0x8,%r9d
    ff66:	73 08                	jae    ff70 <_ZN6vectorIPjE2atEi+0xe0>
    ff68:	45 31 c0             	xor    %r8d,%r8d
    ff6b:	e9 7f 00 00 00       	jmp    ffef <_ZN6vectorIPjE2atEi+0x15f>
    ff70:	41 83 e1 f8          	and    $0xfffffff8,%r9d
    ff74:	45 31 c0             	xor    %r8d,%r8d
    ff77:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
    ff7e:	00 00 
    ff80:	4c 8b 17             	mov    (%rdi),%r10
    ff83:	4f 8b 14 c2          	mov    (%r10,%r8,8),%r10
    ff87:	4e 89 14 c1          	mov    %r10,(%rcx,%r8,8)
    ff8b:	4c 8b 17             	mov    (%rdi),%r10
    ff8e:	4f 8b 54 c2 08       	mov    0x8(%r10,%r8,8),%r10
    ff93:	4e 89 54 c1 08       	mov    %r10,0x8(%rcx,%r8,8)
    ff98:	4c 8b 17             	mov    (%rdi),%r10
    ff9b:	4f 8b 54 c2 10       	mov    0x10(%r10,%r8,8),%r10
    ffa0:	4e 89 54 c1 10       	mov    %r10,0x10(%rcx,%r8,8)
    ffa5:	4c 8b 17             	mov    (%rdi),%r10
    ffa8:	4f 8b 54 c2 18       	mov    0x18(%r10,%r8,8),%r10
    ffad:	4e 89 54 c1 18       	mov    %r10,0x18(%rcx,%r8,8)
    ffb2:	4c 8b 17             	mov    (%rdi),%r10
    ffb5:	4f 8b 54 c2 20       	mov    0x20(%r10,%r8,8),%r10
    ffba:	4e 89 54 c1 20       	mov    %r10,0x20(%rcx,%r8,8)
    ffbf:	4c 8b 17             	mov    (%rdi),%r10
    ffc2:	4f 8b 54 c2 28       	mov    0x28(%r10,%r8,8),%r10
    ffc7:	4e 89 54 c1 28       	mov    %r10,0x28(%rcx,%r8,8)
    ffcc:	4c 8b 17             	mov    (%rdi),%r10
    ffcf:	4f 8b 54 c2 30       	mov    0x30(%r10,%r8,8),%r10
    ffd4:	4e 89 54 c1 30       	mov    %r10,0x30(%rcx,%r8,8)
    ffd9:	4c 8b 17             	mov    (%rdi),%r10
    ffdc:	4f 8b 54 c2 38       	mov    0x38(%r10,%r8,8),%r10
    ffe1:	4e 89 54 c1 38       	mov    %r10,0x38(%rcx,%r8,8)
    ffe6:	49 83 c0 08          	add    $0x8,%r8
    ffea:	4d 39 c1             	cmp    %r8,%r9
    ffed:	75 91                	jne    ff80 <_ZN6vectorIPjE2atEi+0xf0>
    ffef:	48 85 d2             	test   %rdx,%rdx
    fff2:	74 1f                	je     10013 <_ZN6vectorIPjE2atEi+0x183>
    fff4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
    fffb:	00 00 00 00 00 
   10000:	4c 8b 0f             	mov    (%rdi),%r9
   10003:	4f 8b 0c c1          	mov    (%r9,%r8,8),%r9
   10007:	4e 89 0c c1          	mov    %r9,(%rcx,%r8,8)
   1000b:	49 ff c0             	inc    %r8
   1000e:	48 ff ca             	dec    %rdx
   10011:	75 ed                	jne    10000 <_ZN6vectorIPjE2atEi+0x170>
   10013:	48 8b 17             	mov    (%rdi),%rdx
   10016:	48 85 d2             	test   %rdx,%rdx
   10019:	74 2e                	je     10049 <_ZN6vectorIPjE2atEi+0x1b9>
   1001b:	4c 8d 42 f0          	lea    -0x10(%rdx),%r8
   1001f:	4c 8b 4a f0          	mov    -0x10(%rdx),%r9
   10023:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
   1002a:	00 01 
   1002c:	c5 f8 11 42 f0       	vmovups %xmm0,-0x10(%rdx)
   10031:	4c 89 0c 25 00 00 00 	mov    %r9,0x1000000
   10038:	01 
   10039:	4c 89 04 25 08 00 00 	mov    %r8,0x1000008
   10040:	01 
   10041:	4c 29 0c 25 28 00 11 	sub    %r9,0x110028
   10048:	00 
   10049:	48 89 0f             	mov    %rcx,(%rdi)
   1004c:	89 47 0c             	mov    %eax,0xc(%rdi)
   1004f:	8b 47 08             	mov    0x8(%rdi),%eax
   10052:	8d 56 01             	lea    0x1(%rsi),%edx
   10055:	39 d0                	cmp    %edx,%eax
   10057:	0f 4f d0             	cmovg  %eax,%edx
   1005a:	89 57 08             	mov    %edx,0x8(%rdi)
   1005d:	48 63 c6             	movslq %esi,%rax
   10060:	48 8d 04 c1          	lea    (%rcx,%rax,8),%rax
   10064:	c3                   	ret    
   10065:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   1006c:	00 00 00 
   1006f:	90                   	nop

0000000000010070 <_ZN6vectorI8rostringE7reserveEi>:
   10070:	39 77 0c             	cmp    %esi,0xc(%rdi)
   10073:	0f 8d 66 02 00 00    	jge    102df <_ZN6vectorI8rostringE7reserveEi+0x26f>
   10079:	48 63 c6             	movslq %esi,%rax
   1007c:	48 89 c1             	mov    %rax,%rcx
   1007f:	48 c1 e1 04          	shl    $0x4,%rcx
   10083:	48 8d 51 1f          	lea    0x1f(%rcx),%rdx
   10087:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
   1008b:	85 c0                	test   %eax,%eax
   1008d:	b8 10 00 00 00       	mov    $0x10,%eax
   10092:	48 0f 48 d0          	cmovs  %rax,%rdx
   10096:	48 85 d2             	test   %rdx,%rdx
   10099:	48 0f 44 d0          	cmove  %rax,%rdx
   1009d:	4c 8b 04 25 00 00 00 	mov    0x1000000,%r8
   100a4:	01 
   100a5:	41 b9 00 00 00 01    	mov    $0x1000000,%r9d
   100ab:	49 39 d0             	cmp    %rdx,%r8
   100ae:	73 0c                	jae    100bc <_ZN6vectorI8rostringE7reserveEi+0x4c>
   100b0:	4d 8b 49 08          	mov    0x8(%r9),%r9
   100b4:	4d 8b 01             	mov    (%r9),%r8
   100b7:	49 39 d0             	cmp    %rdx,%r8
   100ba:	72 f4                	jb     100b0 <_ZN6vectorI8rostringE7reserveEi+0x40>
   100bc:	49 8b 41 08          	mov    0x8(%r9),%rax
   100c0:	4d 89 c2             	mov    %r8,%r10
   100c3:	49 29 d2             	sub    %rdx,%r10
   100c6:	49 83 fa 0f          	cmp    $0xf,%r10
   100ca:	77 0b                	ja     100d7 <_ZN6vectorI8rostringE7reserveEi+0x67>
   100cc:	c5 f8 10 00          	vmovups (%rax),%xmm0
   100d0:	c4 c1 78 11 01       	vmovups %xmm0,(%r9)
   100d5:	eb 0d                	jmp    100e4 <_ZN6vectorI8rostringE7reserveEi+0x74>
   100d7:	4d 89 11             	mov    %r10,(%r9)
   100da:	49 c1 e2 04          	shl    $0x4,%r10
   100de:	4c 01 d0             	add    %r10,%rax
   100e1:	49 89 d0             	mov    %rdx,%r8
   100e4:	4c 89 00             	mov    %r8,(%rax)
   100e7:	48 83 c0 10          	add    $0x10,%rax
   100eb:	4c 01 04 25 28 00 11 	add    %r8,0x110028
   100f2:	00 
   100f3:	85 f6                	test   %esi,%esi
   100f5:	0f 84 d5 00 00 00    	je     101d0 <_ZN6vectorI8rostringE7reserveEi+0x160>
   100fb:	4c 8d 41 f0          	lea    -0x10(%rcx),%r8
   100ff:	45 89 c1             	mov    %r8d,%r9d
   10102:	41 c1 e9 04          	shr    $0x4,%r9d
   10106:	41 ff c1             	inc    %r9d
   10109:	48 89 c2             	mov    %rax,%rdx
   1010c:	41 83 e1 07          	and    $0x7,%r9d
   10110:	74 25                	je     10137 <_ZN6vectorI8rostringE7reserveEi+0xc7>
   10112:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   10119:	1f 84 00 00 00 00 00 
   10120:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)
   10127:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
   1012e:	48 83 c2 10          	add    $0x10,%rdx
   10132:	49 ff c9             	dec    %r9
   10135:	75 e9                	jne    10120 <_ZN6vectorI8rostringE7reserveEi+0xb0>
   10137:	49 83 f8 70          	cmp    $0x70,%r8
   1013b:	0f 82 8f 00 00 00    	jb     101d0 <_ZN6vectorI8rostringE7reserveEi+0x160>
   10141:	48 01 c1             	add    %rax,%rcx
   10144:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   1014b:	00 00 00 00 00 
   10150:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)
   10157:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
   1015e:	48 c7 42 10 00 00 00 	movq   $0x0,0x10(%rdx)
   10165:	00 
   10166:	c7 42 18 00 00 00 00 	movl   $0x0,0x18(%rdx)
   1016d:	48 c7 42 20 00 00 00 	movq   $0x0,0x20(%rdx)
   10174:	00 
   10175:	c7 42 28 00 00 00 00 	movl   $0x0,0x28(%rdx)
   1017c:	48 c7 42 30 00 00 00 	movq   $0x0,0x30(%rdx)
   10183:	00 
   10184:	c7 42 38 00 00 00 00 	movl   $0x0,0x38(%rdx)
   1018b:	48 c7 42 40 00 00 00 	movq   $0x0,0x40(%rdx)
   10192:	00 
   10193:	c7 42 48 00 00 00 00 	movl   $0x0,0x48(%rdx)
   1019a:	48 c7 42 50 00 00 00 	movq   $0x0,0x50(%rdx)
   101a1:	00 
   101a2:	c7 42 58 00 00 00 00 	movl   $0x0,0x58(%rdx)
   101a9:	48 c7 42 60 00 00 00 	movq   $0x0,0x60(%rdx)
   101b0:	00 
   101b1:	c7 42 68 00 00 00 00 	movl   $0x0,0x68(%rdx)
   101b8:	48 c7 42 70 00 00 00 	movq   $0x0,0x70(%rdx)
   101bf:	00 
   101c0:	c7 42 78 00 00 00 00 	movl   $0x0,0x78(%rdx)
   101c7:	48 83 ea 80          	sub    $0xffffffffffffff80,%rdx
   101cb:	48 39 ca             	cmp    %rcx,%rdx
   101ce:	75 80                	jne    10150 <_ZN6vectorI8rostringE7reserveEi+0xe0>
   101d0:	48 8b 0f             	mov    (%rdi),%rcx
   101d3:	48 85 c9             	test   %rcx,%rcx
   101d6:	0f 84 fd 00 00 00    	je     102d9 <_ZN6vectorI8rostringE7reserveEi+0x269>
   101dc:	44 8b 47 08          	mov    0x8(%rdi),%r8d
   101e0:	45 85 c0             	test   %r8d,%r8d
   101e3:	0f 8e c2 00 00 00    	jle    102ab <_ZN6vectorI8rostringE7reserveEi+0x23b>
   101e9:	44 89 c2             	mov    %r8d,%edx
   101ec:	83 e2 03             	and    $0x3,%edx
   101ef:	41 83 f8 04          	cmp    $0x4,%r8d
   101f3:	73 05                	jae    101fa <_ZN6vectorI8rostringE7reserveEi+0x18a>
   101f5:	45 31 c9             	xor    %r9d,%r9d
   101f8:	eb 71                	jmp    1026b <_ZN6vectorI8rostringE7reserveEi+0x1fb>
   101fa:	41 83 e0 fc          	and    $0xfffffffc,%r8d
   101fe:	41 ba 38 00 00 00    	mov    $0x38,%r10d
   10204:	45 31 c9             	xor    %r9d,%r9d
   10207:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   1020e:	00 00 
   10210:	4e 8b 5c 11 c8       	mov    -0x38(%rcx,%r10,1),%r11
   10215:	4e 89 5c 10 c8       	mov    %r11,-0x38(%rax,%r10,1)
   1021a:	46 8b 5c 11 d0       	mov    -0x30(%rcx,%r10,1),%r11d
   1021f:	46 89 5c 10 d0       	mov    %r11d,-0x30(%rax,%r10,1)
   10224:	4e 8b 5c 11 d8       	mov    -0x28(%rcx,%r10,1),%r11
   10229:	4e 89 5c 10 d8       	mov    %r11,-0x28(%rax,%r10,1)
   1022e:	46 8b 5c 11 e0       	mov    -0x20(%rcx,%r10,1),%r11d
   10233:	46 89 5c 10 e0       	mov    %r11d,-0x20(%rax,%r10,1)
   10238:	4e 8b 5c 11 e8       	mov    -0x18(%rcx,%r10,1),%r11
   1023d:	4e 89 5c 10 e8       	mov    %r11,-0x18(%rax,%r10,1)
   10242:	46 8b 5c 11 f0       	mov    -0x10(%rcx,%r10,1),%r11d
   10247:	46 89 5c 10 f0       	mov    %r11d,-0x10(%rax,%r10,1)
   1024c:	4e 8b 5c 11 f8       	mov    -0x8(%rcx,%r10,1),%r11
   10251:	4e 89 5c 10 f8       	mov    %r11,-0x8(%rax,%r10,1)
   10256:	46 8b 1c 11          	mov    (%rcx,%r10,1),%r11d
   1025a:	46 89 1c 10          	mov    %r11d,(%rax,%r10,1)
   1025e:	49 83 c1 04          	add    $0x4,%r9
   10262:	49 83 c2 40          	add    $0x40,%r10
   10266:	4d 39 c8             	cmp    %r9,%r8
   10269:	75 a5                	jne    10210 <_ZN6vectorI8rostringE7reserveEi+0x1a0>
   1026b:	48 85 d2             	test   %rdx,%rdx
   1026e:	74 3b                	je     102ab <_ZN6vectorI8rostringE7reserveEi+0x23b>
   10270:	49 c1 e1 04          	shl    $0x4,%r9
   10274:	4e 8d 04 08          	lea    (%rax,%r9,1),%r8
   10278:	49 83 c0 08          	add    $0x8,%r8
   1027c:	49 01 c9             	add    %rcx,%r9
   1027f:	49 83 c1 08          	add    $0x8,%r9
   10283:	48 c1 e2 04          	shl    $0x4,%rdx
   10287:	45 31 d2             	xor    %r10d,%r10d
   1028a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
   10290:	4f 8b 5c 11 f8       	mov    -0x8(%r9,%r10,1),%r11
   10295:	4f 89 5c 10 f8       	mov    %r11,-0x8(%r8,%r10,1)
   1029a:	47 8b 1c 11          	mov    (%r9,%r10,1),%r11d
   1029e:	47 89 1c 10          	mov    %r11d,(%r8,%r10,1)
   102a2:	49 83 c2 10          	add    $0x10,%r10
   102a6:	4c 39 d2             	cmp    %r10,%rdx
   102a9:	75 e5                	jne    10290 <_ZN6vectorI8rostringE7reserveEi+0x220>
   102ab:	48 8d 51 f0          	lea    -0x10(%rcx),%rdx
   102af:	4c 8b 41 f0          	mov    -0x10(%rcx),%r8
   102b3:	c5 f8 10 04 25 00 00 	vmovups 0x1000000,%xmm0
   102ba:	00 01 
   102bc:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
   102c1:	4c 89 04 25 00 00 00 	mov    %r8,0x1000000
   102c8:	01 
   102c9:	48 89 14 25 08 00 00 	mov    %rdx,0x1000008
   102d0:	01 
   102d1:	4c 29 04 25 28 00 11 	sub    %r8,0x110028
   102d8:	00 
   102d9:	48 89 07             	mov    %rax,(%rdi)
   102dc:	89 77 0c             	mov    %esi,0xc(%rdi)
   102df:	c3                   	ret    

00000000000102e0 <end_ctors>:
   102e0:	4e 6f                	rex.WRX outsl %ds:(%rsi),(%dx)
   102e2:	20 41 48             	and    %al,0x48(%rcx)
   102e5:	43                   	rex.XB
   102e6:	49 20 63 6f          	rex.WB and %spl,0x6f(%r11)
   102ea:	6e                   	outsb  %ds:(%rsi),(%dx)
   102eb:	74 72                	je     1035f <end_ctors+0x7f>
   102ed:	6f                   	outsl  %ds:(%rsi),(%dx)
   102ee:	6c                   	insb   (%dx),%es:(%rdi)
   102ef:	6c                   	insb   (%dx),%es:(%rdi)
   102f0:	65 72 20             	gs jb  10313 <end_ctors+0x33>
   102f3:	64 65 74 65          	fs gs je 1035c <end_ctors+0x7c>
   102f7:	63 74 65 64          	movsxd 0x64(%rbp,%riz,2),%esi
   102fb:	21 0d 0a 00 2f 6b    	and    %ecx,0x6b2f000a(%rip)        # 6b30030b <kernel_main+0x6b0ec0eb>
   10301:	65 72 6e             	gs jb  10372 <end_ctors+0x92>
   10304:	65 6c                	gs insb (%dx),%es:(%rdi)
   10306:	2e 69 6d 67 00 4b 65 	cs imul $0x72654b00,0x67(%rbp),%ebp
   1030d:	72 
   1030e:	6e                   	outsb  %ds:(%rsi),(%dx)
   1030f:	65 6c                	gs insb (%dx),%es:(%rdi)
   10311:	20 69 6d             	and    %ch,0x6d(%rcx)
   10314:	61                   	(bad)  
   10315:	67 65 20 6e 6f       	and    %ch,%gs:0x6f(%esi)
   1031a:	74 20                	je     1033c <end_ctors+0x5c>
   1031c:	66 6f                	outsw  %ds:(%rsi),(%dx)
   1031e:	75 6e                	jne    1038e <end_ctors+0xae>
   10320:	64 21 0d 0a 00 0f 1f 	and    %ecx,%fs:0x1f0f000a(%rip)        # 1f100331 <kernel_main+0x1eeec111>
   10327:	00 21                	add    %ah,(%rcx)
   10329:	94                   	xchg   %eax,%esp
   1032a:	00 00                	add    %al,(%rax)
   1032c:	00 00                	add    %al,(%rax)
   1032e:	00 00                	add    %al,(%rax)
   10330:	e7 8f                	out    %eax,$0x8f
   10332:	00 00                	add    %al,(%rax)
   10334:	00 00                	add    %al,(%rax)
   10336:	00 00                	add    %al,(%rax)
   10338:	e7 8f                	out    %eax,$0x8f
   1033a:	00 00                	add    %al,(%rax)
   1033c:	00 00                	add    %al,(%rax)
   1033e:	00 00                	add    %al,(%rax)
   10340:	e7 8f                	out    %eax,$0x8f
   10342:	00 00                	add    %al,(%rax)
   10344:	00 00                	add    %al,(%rax)
   10346:	00 00                	add    %al,(%rax)
   10348:	a8 94                	test   $0x94,%al
   1034a:	00 00                	add    %al,(%rax)
   1034c:	00 00                	add    %al,(%rax)
   1034e:	00 00                	add    %al,(%rax)
   10350:	e7 8f                	out    %eax,$0x8f
   10352:	00 00                	add    %al,(%rax)
   10354:	00 00                	add    %al,(%rax)
   10356:	00 00                	add    %al,(%rax)
   10358:	e7 8f                	out    %eax,$0x8f
   1035a:	00 00                	add    %al,(%rax)
   1035c:	00 00                	add    %al,(%rax)
   1035e:	00 00                	add    %al,(%rax)
   10360:	e7 8f                	out    %eax,$0x8f
   10362:	00 00                	add    %al,(%rax)
   10364:	00 00                	add    %al,(%rax)
   10366:	00 00                	add    %al,(%rax)
   10368:	e7 8f                	out    %eax,$0x8f
   1036a:	00 00                	add    %al,(%rax)
   1036c:	00 00                	add    %al,(%rax)
   1036e:	00 00                	add    %al,(%rax)
   10370:	e7 8f                	out    %eax,$0x8f
   10372:	00 00                	add    %al,(%rax)
   10374:	00 00                	add    %al,(%rax)
   10376:	00 00                	add    %al,(%rax)
   10378:	c8 94 00 00          	enter  $0x94,$0x0
   1037c:	00 00                	add    %al,(%rax)
   1037e:	00 00                	add    %al,(%rax)
   10380:	e7 8f                	out    %eax,$0x8f
   10382:	00 00                	add    %al,(%rax)
   10384:	00 00                	add    %al,(%rax)
   10386:	00 00                	add    %al,(%rax)
   10388:	e7 8f                	out    %eax,$0x8f
   1038a:	00 00                	add    %al,(%rax)
   1038c:	00 00                	add    %al,(%rax)
   1038e:	00 00                	add    %al,(%rax)
   10390:	e7 8f                	out    %eax,$0x8f
   10392:	00 00                	add    %al,(%rax)
   10394:	00 00                	add    %al,(%rax)
   10396:	00 00                	add    %al,(%rax)
   10398:	e7 8f                	out    %eax,$0x8f
   1039a:	00 00                	add    %al,(%rax)
   1039c:	00 00                	add    %al,(%rax)
   1039e:	00 00                	add    %al,(%rax)
   103a0:	77 95                	ja     10337 <end_ctors+0x57>
   103a2:	00 00                	add    %al,(%rax)
   103a4:	00 00                	add    %al,(%rax)
   103a6:	00 00                	add    %al,(%rax)
   103a8:	e7 8f                	out    %eax,$0x8f
   103aa:	00 00                	add    %al,(%rax)
   103ac:	00 00                	add    %al,(%rax)
   103ae:	00 00                	add    %al,(%rax)
   103b0:	e7 8f                	out    %eax,$0x8f
   103b2:	00 00                	add    %al,(%rax)
   103b4:	00 00                	add    %al,(%rax)
   103b6:	00 00                	add    %al,(%rax)
   103b8:	e7 8f                	out    %eax,$0x8f
   103ba:	00 00                	add    %al,(%rax)
   103bc:	00 00                	add    %al,(%rax)
   103be:	00 00                	add    %al,(%rax)
   103c0:	e7 8f                	out    %eax,$0x8f
   103c2:	00 00                	add    %al,(%rax)
   103c4:	00 00                	add    %al,(%rax)
   103c6:	00 00                	add    %al,(%rax)
   103c8:	e7 8f                	out    %eax,$0x8f
   103ca:	00 00                	add    %al,(%rax)
   103cc:	00 00                	add    %al,(%rax)
   103ce:	00 00                	add    %al,(%rax)
   103d0:	e7 8f                	out    %eax,$0x8f
   103d2:	00 00                	add    %al,(%rax)
   103d4:	00 00                	add    %al,(%rax)
   103d6:	00 00                	add    %al,(%rax)
   103d8:	e7 8f                	out    %eax,$0x8f
   103da:	00 00                	add    %al,(%rax)
   103dc:	00 00                	add    %al,(%rax)
   103de:	00 00                	add    %al,(%rax)
   103e0:	e7 8f                	out    %eax,$0x8f
   103e2:	00 00                	add    %al,(%rax)
   103e4:	00 00                	add    %al,(%rax)
   103e6:	00 00                	add    %al,(%rax)
   103e8:	e7 8f                	out    %eax,$0x8f
   103ea:	00 00                	add    %al,(%rax)
   103ec:	00 00                	add    %al,(%rax)
   103ee:	00 00                	add    %al,(%rax)
   103f0:	e8 94 00 00 00       	call   10489 <end_ctors+0x1a9>
   103f5:	00 00                	add    %al,(%rax)
   103f7:	00 e7                	add    %ah,%bh
   103f9:	8f 00                	pop    (%rax)
   103fb:	00 00                	add    %al,(%rax)
   103fd:	00 00                	add    %al,(%rax)
   103ff:	00 e7                	add    %ah,%bh
   10401:	8f 00                	pop    (%rax)
   10403:	00 00                	add    %al,(%rax)
   10405:	00 00                	add    %al,(%rax)
   10407:	00 e7                	add    %ah,%bh
   10409:	8f 00                	pop    (%rax)
   1040b:	00 00                	add    %al,(%rax)
   1040d:	00 00                	add    %al,(%rax)
   1040f:	00 08                	add    %cl,(%rax)
   10411:	95                   	xchg   %eax,%ebp
   10412:	00 00                	add    %al,(%rax)
   10414:	00 00                	add    %al,(%rax)
   10416:	00 00                	add    %al,(%rax)
   10418:	e7 8f                	out    %eax,$0x8f
   1041a:	00 00                	add    %al,(%rax)
   1041c:	00 00                	add    %al,(%rax)
   1041e:	00 00                	add    %al,(%rax)
   10420:	e7 8f                	out    %eax,$0x8f
   10422:	00 00                	add    %al,(%rax)
   10424:	00 00                	add    %al,(%rax)
   10426:	00 00                	add    %al,(%rax)
   10428:	2d 95 00 00 00       	sub    $0x95,%eax
   1042d:	00 00                	add    %al,(%rax)
   1042f:	00 e7                	add    %ah,%bh
   10431:	8f 00                	pop    (%rax)
   10433:	00 00                	add    %al,(%rax)
   10435:	00 00                	add    %al,(%rax)
   10437:	00 e7                	add    %ah,%bh
   10439:	8f 00                	pop    (%rax)
   1043b:	00 00                	add    %al,(%rax)
   1043d:	00 00                	add    %al,(%rax)
   1043f:	00 e7                	add    %ah,%bh
   10441:	8f 00                	pop    (%rax)
   10443:	00 00                	add    %al,(%rax)
   10445:	00 00                	add    %al,(%rax)
   10447:	00 e7                	add    %ah,%bh
   10449:	8f 00                	pop    (%rax)
   1044b:	00 00                	add    %al,(%rax)
   1044d:	00 00                	add    %al,(%rax)
   1044f:	00 e7                	add    %ah,%bh
   10451:	8f 00                	pop    (%rax)
   10453:	00 00                	add    %al,(%rax)
   10455:	00 00                	add    %al,(%rax)
   10457:	00 e7                	add    %ah,%bh
   10459:	8f 00                	pop    (%rax)
   1045b:	00 00                	add    %al,(%rax)
   1045d:	00 00                	add    %al,(%rax)
   1045f:	00 59 95             	add    %bl,-0x6b(%rcx)
   10462:	00 00                	add    %al,(%rax)
   10464:	00 00                	add    %al,(%rax)
   10466:	00 00                	add    %al,(%rax)
   10468:	e7 8f                	out    %eax,$0x8f
   1046a:	00 00                	add    %al,(%rax)
   1046c:	00 00                	add    %al,(%rax)
   1046e:	00 00                	add    %al,(%rax)
   10470:	e7 8f                	out    %eax,$0x8f
   10472:	00 00                	add    %al,(%rax)
   10474:	00 00                	add    %al,(%rax)
   10476:	00 00                	add    %al,(%rax)
   10478:	90                   	nop
   10479:	95                   	xchg   %eax,%ebp
   1047a:	00 00                	add    %al,(%rax)
   1047c:	00 00                	add    %al,(%rax)
   1047e:	00 00                	add    %al,(%rax)
   10480:	e7 8f                	out    %eax,$0x8f
   10482:	00 00                	add    %al,(%rax)
   10484:	00 00                	add    %al,(%rax)
   10486:	00 00                	add    %al,(%rax)
   10488:	e7 8f                	out    %eax,$0x8f
   1048a:	00 00                	add    %al,(%rax)
   1048c:	00 00                	add    %al,(%rax)
   1048e:	00 00                	add    %al,(%rax)
   10490:	e7 8f                	out    %eax,$0x8f
   10492:	00 00                	add    %al,(%rax)
   10494:	00 00                	add    %al,(%rax)
   10496:	00 00                	add    %al,(%rax)
   10498:	e7 8f                	out    %eax,$0x8f
   1049a:	00 00                	add    %al,(%rax)
   1049c:	00 00                	add    %al,(%rax)
   1049e:	00 00                	add    %al,(%rax)
   104a0:	b0 95                	mov    $0x95,%al
	...
   104aa:	c0 c0 00             	rol    $0x0,%al
   104ad:	00 80 3f ab aa aa    	add    %al,-0x555554c1(%rax)
   104b3:	3e 00 00             	ds add %al,(%rax)
   104b6:	c0 40 00 00          	rolb   $0x0,0x0(%rax)
   104ba:	80 bf 00 00 00 3f ab 	cmpb   $0xab,0x3f000000(%rdi)
   104c1:	aa                   	stos   %al,%es:(%rdi)
   104c2:	aa                   	stos   %al,%es:(%rdi)
   104c3:	3f                   	(bad)  
   104c4:	00 00                	add    %al,(%rax)
   104c6:	00 40 ab             	add    %al,-0x55(%rax)
   104c9:	aa                   	stos   %al,%es:(%rdi)
   104ca:	2a 3f                	sub    (%rdi),%bh
   104cc:	00 0f                	add    %cl,(%rdi)
   104ce:	00 0f                	add    %cl,(%rdi)
   104d0:	00 00                	add    %al,(%rax)
   104d2:	00 80 00 00 40 c1    	add    %al,-0x3ec00000(%rax)
   104d8:	00 00                	add    %al,(%rax)
   104da:	80 40 0a d7          	addb   $0xd7,0xa(%rax)
   104de:	23 3c ab             	and    (%rbx,%rbp,4),%edi
   104e1:	aa                   	stos   %al,%es:(%rdi)
   104e2:	2a 3e                	sub    (%rsi),%bh
   104e4:	ab                   	stos   %eax,%es:(%rdi)
   104e5:	aa                   	stos   %al,%es:(%rdi)
   104e6:	aa                   	stos   %al,%es:(%rdi)
   104e7:	be aa aa 2a 3f       	mov    $0x3f2aaaaa,%esi
   104ec:	81 80 80 3b 00 00 7f 	addl   $0xb717437f,0x3b80(%rax)
   104f3:	43 17 b7 
   104f6:	d1 38                	sarl   (%rax)
   104f8:	ff                   	(bad)  
   104f9:	ff                   	(bad)  
   104fa:	ff                   	(bad)  
   104fb:	7f 0f                	jg     1050c <end_ctors+0x22c>
   104fd:	1f                   	(bad)  
   104fe:	40 00 00             	rex add %al,(%rax)
   10501:	00 00                	add    %al,(%rax)
   10503:	00 00                	add    %al,(%rax)
   10505:	00 00                	add    %al,(%rax)
   10507:	3f                   	(bad)  
   10508:	55                   	push   %rbp
   10509:	55                   	push   %rbp
   1050a:	fd                   	std    
   1050b:	ff                   	(bad)  
   1050c:	ff                   	(bad)  
   1050d:	ff                   	(bad)  
   1050e:	df be 00 00 00 00    	fistpll 0x0(%rsi)
   10514:	00 00                	add    %al,(%rax)
   10516:	f0 bf 00 00 00 00    	lock mov $0x0,%edi
   1051c:	00 00                	add    %al,(%rax)
   1051e:	f0 3e 18 2d 44 54 fb 	lock ds sbb %ch,0x21fb5444(%rip)        # 21fc596a <kernel_main+0x21db174a>
   10525:	21 
   10526:	f9                   	stc    
   10527:	bf 25 76 a9 bb       	mov    $0xbba97625,%edi
   1052c:	55                   	push   %rbp
   1052d:	fd                   	std    
   1052e:	9f                   	lahf   
   1052f:	bf 00 00 00 00       	mov    $0x0,%edi
   10534:	00 00                	add    %al,(%rax)
   10536:	80 3f 24             	cmpb   $0x24,(%rdi)
   10539:	fd                   	std    
   1053a:	4e 84 9e 6e e3 bf 18 	rex.WRX test %r11b,0x18bfe36e(%rsi)
   10541:	2d 44 54 fb 21       	sub    $0x21fb5444,%eax
   10546:	19 c0                	sbb    %eax,%eax
   10548:	4f bb 61 05 67 ac dd 	rex.WRXB movabs $0xbbbcbfddac670561,%r11
   1054f:	bf bc bb 
   10552:	55                   	push   %rbp
   10553:	55                   	push   %rbp
   10554:	fd                   	std    
   10555:	ff 5f bf             	lcall  *-0x41(%rdi)
   10558:	5c                   	pop    %rsp
   10559:	55                   	push   %rbp
   1055a:	55                   	push   %rbp
   1055b:	f5                   	cmc    
   1055c:	ff                   	(bad)  
   1055d:	ff 2f                	ljmp   *(%rdi)
   1055f:	bf c0 78 08 b5       	mov    $0xb50878c0,%edi
   10564:	9d                   	popf   
   10565:	6e                   	outsb  %ds:(%rsi),(%dx)
   10566:	e3 3f                	jrcxz  105a7 <end_ctors+0x2c7>
   10568:	00 00                	add    %al,(%rax)
   1056a:	00 00                	add    %al,(%rax)
   1056c:	00 00                	add    %al,(%rax)
   1056e:	50                   	push   %rax
   1056f:	3f                   	(bad)  
   10570:	8d                   	(bad)  
   10571:	ed                   	in     (%dx),%eax
   10572:	b5 a0                	mov    $0xa0,%ch
   10574:	f7 c6 b0 3e 00 00    	test   $0x3eb0,%esi
   1057a:	00 00                	add    %al,(%rax)
   1057c:	00 00                	add    %al,(%rax)
   1057e:	c0 3f bc             	sarb   $0xbc,(%rdi)
   10581:	55                   	push   %rbp
   10582:	55                   	push   %rbp
   10583:	d5                   	(bad)  
   10584:	ff                   	(bad)  
   10585:	ff                   	(bad)  
   10586:	3f                   	(bad)  
   10587:	bf 00 00 00 00       	mov    $0x0,%edi
   1058c:	00 00                	add    %al,(%rax)
   1058e:	d0 3e                	sarb   (%rsi)
   10590:	00 00                	add    %al,(%rax)
   10592:	00 00                	add    %al,(%rax)
   10594:	00 00                	add    %al,(%rax)
   10596:	c0 3e 18             	sarb   $0x18,(%rsi)
   10599:	2d 44 54 fb 21       	sub    $0x21fb5444,%eax
   1059e:	09 c0                	or     %eax,%eax
   105a0:	00 00                	add    %al,(%rax)
   105a2:	00 00                	add    %al,(%rax)
   105a4:	00 00                	add    %al,(%rax)
   105a6:	f0 3f                	lock (bad) 
   105a8:	97                   	xchg   %eax,%edi
   105a9:	ba bb 55 d5 ff       	mov    $0xffd555bb,%edx
   105ae:	7f bf                	jg     1056f <end_ctors+0x28f>
   105b0:	bc 5b 55 55 ff       	mov    $0xff55555b,%esp
   105b5:	ff 4f bf             	decl   -0x41(%rdi)
   105b8:	00 00                	add    %al,(%rax)
   105ba:	00 00                	add    %al,(%rax)
   105bc:	00 00                	add    %al,(%rax)
   105be:	10 3f                	adc    %bh,(%rdi)
   105c0:	00 00                	add    %al,(%rax)
   105c2:	00 00                	add    %al,(%rax)
   105c4:	00 00                	add    %al,(%rax)
   105c6:	e0 3e                	loopne 10606 <end_ctors+0x326>
	...
   105d4:	00 00                	add    %al,(%rax)
   105d6:	e0 bf                	loopne 10597 <end_ctors+0x2b7>
   105d8:	ea                   	(bad)  
   105d9:	fd                   	std    
   105da:	2c b7                	sub    $0xb7,%al
   105dc:	5b                   	pop    %rbx
   105dd:	f5                   	cmc    
   105de:	af                   	scas   %es:(%rdi),%eax
   105df:	bf 9a 99 99 99       	mov    $0x9999999a,%edi
   105e4:	99                   	cltd   
   105e5:	99                   	cltd   
   105e6:	b9 3f 00 00 00       	mov    $0x3f,%ecx
   105eb:	00 00                	add    %al,(%rax)
   105ed:	00 24 40             	add    %ah,(%rax,%rax,2)
   105f0:	00 00                	add    %al,(%rax)
   105f2:	00 00                	add    %al,(%rax)
   105f4:	00 00                	add    %al,(%rax)
   105f6:	e0 3f                	loopne 10637 <end_ctors+0x357>
   105f8:	6e                   	outsb  %ds:(%rsi),(%dx)
   105f9:	2f                   	(bad)  
   105fa:	ac                   	lods   %ds:(%rsi),%al
   105fb:	9a                   	(bad)  
   105fc:	ba d5 bf bf 24       	mov    $0x24bfbfd5,%edx
   10601:	fd                   	std    
   10602:	4e 84 9e 6e e3 3f 18 	rex.WRX test %r11b,0x183fe36e(%rsi)
   10609:	2d 44 54 fb 21       	sub    $0x21fb5444,%eax
   1060e:	e9 3f 00 00 00       	jmp    10652 <end_ctors+0x372>
   10613:	00 00                	add    %al,(%rax)
   10615:	00 d0                	add    %dl,%al
   10617:	3f                   	(bad)  
   10618:	00 00                	add    %al,(%rax)
   1061a:	00 00                	add    %al,(%rax)
   1061c:	00 00                	add    %al,(%rax)
   1061e:	90                   	nop
   1061f:	3f                   	(bad)  
   10620:	9b                   	fwait
   10621:	72 bb                	jb     105de <end_ctors+0x2fe>
   10623:	5b                   	pop    %rbx
   10624:	55                   	push   %rbp
   10625:	ff 8f bf c0 78 08    	decl   0x878c0bf(%rdi)
   1062b:	b5 9d                	mov    $0x9d,%ch
   1062d:	6e                   	outsb  %ds:(%rsi),(%dx)
   1062e:	e3 bf                	jrcxz  105ef <end_ctors+0x30f>
   10630:	18 2d 44 54 fb 21    	sbb    %ch,0x21fb5444(%rip)        # 21fc5a7a <kernel_main+0x21db185a>
   10636:	e9 bf 00 00 00       	jmp    106fa <end_ctors+0x41a>
   1063b:	00 00                	add    %al,(%rax)
   1063d:	00 30                	add    %dh,(%rax)
   1063f:	3f                   	(bad)  
   10640:	56                   	push   %rsi
   10641:	55                   	push   %rbp
   10642:	55                   	push   %rbp
   10643:	fd                   	std    
   10644:	ff                   	(bad)  
   10645:	ff 1f                	lcall  *(%rdi)
   10647:	bf 55 55 55 ff       	mov    $0xff555555,%edi
   1064c:	ff                   	(bad)  
   1064d:	ff 0f                	decl   (%rdi)
   1064f:	bf 18 2d 44 54       	mov    $0x54442d18,%edi
   10654:	fb                   	sti    
   10655:	21 19                	and    %ebx,(%rcx)
   10657:	40 00 00             	rex add %al,(%rax)
   1065a:	00 00                	add    %al,(%rax)
   1065c:	00 00                	add    %al,(%rax)
   1065e:	40 3f                	rex (bad) 
   10660:	55                   	push   %rbp
   10661:	55                   	push   %rbp
   10662:	ff                   	(bad)  
   10663:	ff                   	(bad)  
   10664:	ff                   	(bad)  
   10665:	ff cf                	dec    %edi
   10667:	be 00 00 00 00       	mov    $0x0,%esi
   1066c:	00 00                	add    %al,(%rax)
   1066e:	70 3f                	jo     106af <end_ctors+0x3cf>
   10670:	18 2d 44 54 fb 21    	sbb    %ch,0x21fb5444(%rip)        # 21fc5aba <kernel_main+0x21db189a>
   10676:	f9                   	stc    
   10677:	3f                   	(bad)  
   10678:	00 00                	add    %al,(%rax)
   1067a:	00 00                	add    %al,(%rax)
   1067c:	00 00                	add    %al,(%rax)
   1067e:	b0 3f                	mov    $0x3f,%al
   10680:	00 00                	add    %al,(%rax)
   10682:	00 00                	add    %al,(%rax)
   10684:	00 00                	add    %al,(%rax)
   10686:	60                   	(bad)  
   10687:	3f                   	(bad)  
   10688:	83 c8 c9             	or     $0xffffffc9,%eax
   1068b:	6d                   	insl   (%dx),%es:(%rdi)
   1068c:	30 5f c4             	xor    %bl,-0x3c(%rdi)
   1068f:	3f                   	(bad)  
   10690:	dd 80 2c f9 75 5b    	fldl   0x5b75f92c(%rax)
   10696:	cf                   	iret   
   10697:	bf 55 55 d5 ff       	mov    $0xffd55555,%edi
   1069c:	ff                   	(bad)  
   1069d:	ff                   	(bad)  
   1069e:	ff                   	(bad)  
   1069f:	be 00 00 00 00       	mov    $0x0,%esi
   106a4:	00 00                	add    %al,(%rax)
   106a6:	a0 3f 55 55 f5 ff ff 	movabs 0xeffffffff555553f,%al
   106ad:	ff ef 
   106af:	be 18 2d 44 54       	mov    $0x54442d18,%esi
   106b4:	fb                   	sti    
   106b5:	21 09                	and    %ecx,(%rcx)
   106b7:	40 b7 bb             	mov    $0xbb,%dil
   106ba:	5b                   	pop    %rbx
   106bb:	55                   	push   %rbp
   106bc:	f5                   	cmc    
   106bd:	ff 6f bf             	ljmp   *-0x41(%rdi)
   106c0:	00 00                	add    %al,(%rax)
   106c2:	00 00                	add    %al,(%rax)
   106c4:	00 00                	add    %al,(%rax)
   106c6:	20 3f                	and    %bh,(%rdi)
   106c8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   106cf:	00 
   106d0:	00 0f                	add    %cl,(%rdi)
   106d2:	00 0f                	add    %cl,(%rdi)
   106d4:	00 0f                	add    %cl,(%rdi)
   106d6:	00 0f                	add    %cl,(%rdi)
   106d8:	00 0f                	add    %cl,(%rdi)
   106da:	00 0f                	add    %cl,(%rdi)
   106dc:	00 0f                	add    %cl,(%rdi)
   106de:	00 0f                	add    %cl,(%rdi)
   106e0:	00 00                	add    %al,(%rax)
   106e2:	00 00                	add    %al,(%rax)
   106e4:	00 00                	add    %al,(%rax)
   106e6:	60                   	(bad)  
   106e7:	bf 00 00 00 00       	mov    $0x0,%edi
   106ec:	00 00                	add    %al,(%rax)
   106ee:	60                   	(bad)  
   106ef:	bf 01 00 03 02       	mov    $0x2030001,%edi
	...
   10700:	03 02                	add    (%rdx),%eax
   10702:	01 00                	add    %eax,(%rax)
   10704:	07                   	(bad)  
   10705:	06                   	(bad)  
   10706:	05 04 00 00 00       	add    $0x4,%eax
	...
   1071b:	00 00                	add    %al,(%rax)
   1071d:	00 80 3f 00 00 00    	add    %al,0x3f(%rax)
   10723:	00 00                	add    %al,(%rax)
   10725:	00 7f 43             	add    %bh,0x43(%rdi)
   10728:	00 00                	add    %al,(%rax)
   1072a:	7f 43                	jg     1076f <end_ctors+0x48f>
   1072c:	00 00                	add    %al,(%rax)
   1072e:	7f 43                	jg     10773 <end_ctors+0x493>
   10730:	00 00                	add    %al,(%rax)
   10732:	00 00                	add    %al,(%rax)
   10734:	00 00                	add    %al,(%rax)
   10736:	c0 3e 00             	sarb   $0x0,(%rsi)
   10739:	00 00                	add    %al,(%rax)
   1073b:	00 00                	add    %al,(%rax)
   1073d:	00 c0                	add    %al,%al
   1073f:	3e 00 00             	ds add %al,(%rax)
   10742:	00 00                	add    %al,(%rax)
   10744:	00 00                	add    %al,(%rax)
   10746:	f0 3f                	lock (bad) 
   10748:	00 00                	add    %al,(%rax)
   1074a:	00 00                	add    %al,(%rax)
   1074c:	00 00                	add    %al,(%rax)
   1074e:	f0 3f                	lock (bad) 
   10750:	03 02                	add    (%rdx),%eax
   10752:	01 00                	add    %eax,(%rax)
	...
   10764:	00 00                	add    %al,(%rax)
   10766:	60                   	(bad)  
   10767:	3f                   	(bad)  
   10768:	00 00                	add    %al,(%rax)
   1076a:	00 00                	add    %al,(%rax)
   1076c:	00 00                	add    %al,(%rax)
   1076e:	60                   	(bad)  
   1076f:	3f                   	(bad)  
	...
   10784:	00 00                	add    %al,(%rax)
   10786:	00 80 00 00 00 00    	add    %al,0x0(%rax)
   1078c:	00 00                	add    %al,(%rax)
   1078e:	00 80 00 00 00 00    	add    %al,0x0(%rax)
   10794:	00 00                	add    %al,(%rax)
   10796:	80 3f 00             	cmpb   $0x0,(%rdi)
	...
   107a5:	00 f0                	add    %dh,%al
   107a7:	bf 00 00 00 00       	mov    $0x0,%edi
   107ac:	00 00                	add    %al,(%rax)
   107ae:	f0 bf 00 00 00 00    	lock mov $0x0,%edi
   107b4:	00 00                	add    %al,(%rax)
   107b6:	c0 be 00 00 00 00 00 	sarb   $0x0,0x0(%rsi)
   107bd:	00 c0                	add    %al,%al
   107bf:	be 50 61 72 74       	mov    $0x74726150,%esi
   107c4:	69 74 69 6f 6e 20 6e 	imul   $0x6f6e206e,0x6f(%rcx,%rbp,2),%esi
   107cb:	6f 
   107cc:	74 20                	je     107ee <end_ctors+0x50e>
   107ce:	72 65                	jb     10835 <end_ctors+0x555>
   107d0:	63 6f 67             	movsxd 0x67(%rdi),%ebp
   107d3:	6e                   	outsb  %ds:(%rsi),(%dx)
   107d4:	69 7a 65 64 20 61 73 	imul   $0x73612064,0x65(%rdx),%edi
   107db:	20 46 41             	and    %al,0x41(%rsi)
   107de:	54                   	push   %rsp
   107df:	33 32                	xor    (%rdx),%esi
   107e1:	2e 0d 0a 00 4e 4d    	cs or  $0x4d4e000a,%eax
   107e7:	49 00 20             	rex.WB add %spl,(%r8)
   107ea:	20 52 43             	and    %dl,0x43(%rdx)
   107ed:	54                   	push   %rsp
   107ee:	52                   	push   %rdx
   107ef:	4c 20 25 30 38 78 0d 	rex.WR and %r12b,0xd783830(%rip)        # d794026 <kernel_main+0xd57fe06>
   107f6:	0a 00                	or     (%rax),%al
   107f8:	74 69                	je     10863 <end_ctors+0x583>
   107fa:	6d                   	insl   (%dx),%es:(%rdi)
   107fb:	65 73 3a             	gs jae 10838 <end_ctors+0x558>
   107fe:	20 25 69 20 25 69    	and    %ah,0x69252069(%rip)        # 6926286d <kernel_main+0x6904e64d>
   10804:	20 25 69 20 7c 20    	and    %ah,0x207c2069(%rip)        # 207d2873 <kernel_main+0x205be653>
   1080a:	25 69 0d 0a 00       	and    $0xa0d69,%eax
   1080f:	4e 6f                	rex.WRX outsl %ds:(%rsi),(%dx)
   10811:	20 46 41             	and    %al,0x41(%rsi)
   10814:	54                   	push   %rsp
   10815:	33 32                	xor    (%rdx),%esi
   10817:	20 70 61             	and    %dh,0x61(%rax)
   1081a:	72 74                	jb     10890 <end_ctors+0x5b0>
   1081c:	69 74 69 6f 6e 20 66 	imul   $0x6f66206e,0x6f(%rcx,%rbp,2),%esi
   10823:	6f 
   10824:	75 6e                	jne    10894 <end_ctors+0x5b4>
   10826:	64 2c 20             	fs sub $0x20,%al
   10829:	77 61                	ja     1088c <end_ctors+0x5ac>
   1082b:	73 20                	jae    1084d <end_ctors+0x56d>
   1082d:	74 68                	je     10897 <end_ctors+0x5b7>
   1082f:	65 20 4d 42          	and    %cl,%gs:0x42(%rbp)
   10833:	52                   	push   %rdx
   10834:	20 63 6f             	and    %ah,0x6f(%rbx)
   10837:	72 72                	jb     108ab <end_ctors+0x5cb>
   10839:	75 70                	jne    108ab <end_ctors+0x5cb>
   1083b:	74 65                	je     108a2 <end_ctors+0x5c2>
   1083d:	64 3f                	fs (bad) 
   1083f:	0d 0a 00 5b 41       	or     $0x415b000a,%eax
   10844:	52                   	push   %rdx
   10845:	50                   	push   %rax
   10846:	5d                   	pop    %rbp
   10847:	20 4e 6f             	and    %cl,0x6f(%rsi)
   1084a:	2c 20                	sub    $0x20,%al
   1084c:	25 49 20 62 65       	and    $0x65622049,%eax
   10851:	6c                   	insb   (%dx),%es:(%rdi)
   10852:	6f                   	outsl  %ds:(%rsi),(%dx)
   10853:	6e                   	outsb  %ds:(%rsi),(%dx)
   10854:	67 73 20             	addr32 jae 10877 <end_ctors+0x597>
   10857:	74 6f                	je     108c8 <end_ctors+0x5e8>
   10859:	20 25 4d 2e 0d 0a    	and    %ah,0xa0d2e4d(%rip)        # a0e36ac <kernel_main+0x9ecf48c>
   1085f:	00 5b 49             	add    %bl,0x49(%rbx)
   10862:	50                   	push   %rax
   10863:	76 34                	jbe    10899 <end_ctors+0x5b9>
   10865:	5d                   	pop    %rbp
   10866:	20 49 6e             	and    %cl,0x6e(%rcx)
   10869:	20 70 61             	and    %dh,0x61(%rax)
   1086c:	63 6b 65             	movsxd 0x65(%rbx),%ebp
   1086f:	74 20                	je     10891 <end_ctors+0x5b1>
   10871:	66 72 6f             	data16 jb 108e3 <end_ctors+0x603>
   10874:	6d                   	insl   (%dx),%es:(%rdi)
   10875:	20 25 49 3a 20 4d    	and    %ah,0x4d203a49(%rip)        # 4d2142c4 <kernel_main+0x4d0000a4>
   1087b:	69 73 6d 61 74 63 68 	imul   $0x68637461,0x6d(%rbx),%esi
   10882:	20 69 6e             	and    %ch,0x6e(%rcx)
   10885:	20 65 74             	and    %ah,0x74(%rbp)
   10888:	68 65 72 6e 65       	push   $0x656e7265
   1088d:	74 20                	je     108af <end_ctors+0x5cf>
   1088f:	61                   	(bad)  
   10890:	6e                   	outsb  %ds:(%rsi),(%dx)
   10891:	64 20 49 50          	and    %cl,%fs:0x50(%rcx)
   10895:	20 70 61             	and    %dh,0x61(%rax)
   10898:	63 6b 65             	movsxd 0x65(%rbx),%ebp
   1089b:	74 20                	je     108bd <end_ctors+0x5dd>
   1089d:	73 69                	jae    10908 <end_ctors+0x628>
   1089f:	7a 65                	jp     10906 <end_ctors+0x626>
   108a1:	73 21                	jae    108c4 <end_ctors+0x5e4>
   108a3:	20 25 69 20 76 73    	and    %ah,0x73762069(%rip)        # 73772912 <kernel_main+0x7355e6f2>
   108a9:	20 25 69 0d 0a 00    	and    %ah,0xa0d69(%rip)        # b1618 <sig3+0x8961c>
   108af:	4f 76 65             	rex.WRXB jbe 10917 <end_ctors+0x637>
   108b2:	72 66                	jb     1091a <end_ctors+0x63a>
   108b4:	6c                   	insb   (%dx),%es:(%rdi)
   108b5:	6f                   	outsl  %ds:(%rsi),(%dx)
   108b6:	77 00                	ja     108b8 <end_ctors+0x5d8>
   108b8:	20 20                	and    %ah,(%rax)
   108ba:	52                   	push   %rdx
   108bb:	58                   	pop    %rax
   108bc:	44                   	rex.R
   108bd:	48 20 25 69 20 52 58 	rex.W and %spl,0x58522069(%rip)        # 5853292d <kernel_main+0x5831e70d>
   108c4:	44 54                	rex.R push %rsp
   108c6:	20 25 69 0d 0a 00    	and    %ah,0xa0d69(%rip)        # b1635 <sig3+0x89639>
   108cc:	61                   	(bad)  
   108cd:	70 70                	jo     1093f <end_ctors+0x65f>
   108cf:	6c                   	insb   (%dx),%es:(%rdi)
   108d0:	69 63 61 74 69 6f 6e 	imul   $0x6e6f6974,0x61(%rbx),%esp
   108d7:	2f                   	(bad)  
   108d8:	77 61                	ja     1093b <end_ctors+0x65b>
   108da:	73 6d                	jae    10949 <end_ctors+0x669>
   108dc:	00 43 6f             	add    %al,0x6f(%rbx)
   108df:	70 72                	jo     10953 <end_ctors+0x673>
   108e1:	6f                   	outsl  %ds:(%rsi),(%dx)
   108e2:	63 65 73             	movsxd 0x73(%rbp),%esp
   108e5:	73 6f                	jae    10956 <end_ctors+0x676>
   108e7:	72 20                	jb     10909 <end_ctors+0x629>
   108e9:	73 65                	jae    10950 <end_ctors+0x670>
   108eb:	67 6d                	insl   (%dx),%es:(%edi)
   108ed:	65 6e                	outsb  %gs:(%rsi),(%dx)
   108ef:	74 20                	je     10911 <end_ctors+0x631>
   108f1:	6f                   	outsl  %ds:(%rsi),(%dx)
   108f2:	76 65                	jbe    10959 <end_ctors+0x679>
   108f4:	72 72                	jb     10968 <end_ctors+0x688>
   108f6:	75 6e                	jne    10966 <end_ctors+0x686>
   108f8:	00 53 65             	add    %dl,0x65(%rbx)
   108fb:	67 6d                	insl   (%dx),%es:(%edi)
   108fd:	65 6e                	outsb  %gs:(%rsi),(%dx)
   108ff:	74 20                	je     10921 <end_ctors+0x641>
   10901:	6e                   	outsb  %ds:(%rsi),(%dx)
   10902:	6f                   	outsl  %ds:(%rsi),(%dx)
   10903:	74 20                	je     10925 <end_ctors+0x645>
   10905:	70 72                	jo     10979 <end_ctors+0x699>
   10907:	65 73 65             	gs jae 1096f <end_ctors+0x68f>
   1090a:	6e                   	outsb  %ds:(%rsi),(%dx)
   1090b:	74 00                	je     1090d <end_ctors+0x62d>
   1090d:	46 6f                	rex.RX outsl %ds:(%rsi),(%dx)
   1090f:	75 6e                	jne    1097f <end_ctors+0x69f>
   10911:	64 20 4d 41          	and    %cl,%fs:0x41(%rbp)
   10915:	43 20 61 64          	rex.XB and %spl,0x64(%r9)
   10919:	64 72 65             	fs jb  10981 <end_ctors+0x6a1>
   1091c:	73 73                	jae    10991 <end_ctors+0x6b1>
   1091e:	3a 20                	cmp    (%rax),%ah
   10920:	25 30 32 78 3a       	and    $0x3a783230,%eax
   10925:	25 30 32 78 3a       	and    $0x3a783230,%eax
   1092a:	25 30 32 78 3a       	and    $0x3a783230,%eax
   1092f:	25 30 32 78 3a       	and    $0x3a783230,%eax
   10934:	25 30 32 78 3a       	and    $0x3a783230,%eax
   10939:	25 30 32 78 0d       	and    $0xd783230,%eax
   1093e:	0a 00                	or     (%rax),%al
   10940:	30 31                	xor    %dh,(%rcx)
   10942:	32 33                	xor    (%rbx),%dh
   10944:	34 35                	xor    $0x35,%al
   10946:	36 37                	ss (bad) 
   10948:	38 39                	cmp    %bh,(%rcx)
   1094a:	41                   	rex.B
   1094b:	42                   	rex.X
   1094c:	43                   	rex.XB
   1094d:	44                   	rex.R
   1094e:	45                   	rex.RB
   1094f:	46 00 74 65 78       	add    %r14b,0x78(%rbp,%r12,2)
   10954:	74 2f                	je     10985 <end_ctors+0x6a5>
   10956:	6a 61                	push   $0x61
   10958:	76 61                	jbe    109bb <end_ctors+0x6db>
   1095a:	73 63                	jae    109bf <end_ctors+0x6df>
   1095c:	72 69                	jb     109c7 <end_ctors+0x6e7>
   1095e:	70 74                	jo     109d4 <end_ctors+0x6f4>
   10960:	00 44 65 74          	add    %al,0x74(%rbp,%riz,2)
   10964:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
   10969:	20 45 74             	and    %al,0x74(%rbp)
   1096c:	68 65 72 6e 65       	push   $0x656e7265
   10971:	74 20                	je     10993 <end_ctors+0x6b3>
   10973:	64 65 76 69          	fs gs jbe 109e0 <end_ctors+0x700>
   10977:	63 65 3a             	movsxd 0x3a(%rbp),%esp
   1097a:	20 25 30 34 78 3a    	and    %ah,0x3a783430(%rip)        # 3a793db0 <kernel_main+0x3a57fb90>
   10980:	25 30 34 78 0d       	and    $0xd783430,%eax
   10985:	0a 00                	or     (%rax),%al
   10987:	0d 0a 45 78 63       	or     $0x6378450a,%eax
   1098c:	65 70 74             	gs jo  10a03 <end_ctors+0x723>
   1098f:	69 6f 6e 20 76 3d 25 	imul   $0x253d7620,0x6e(%rdi),%ebp
   10996:	30 32                	xor    %dh,(%rdx)
   10998:	78 20                	js     109ba <end_ctors+0x6da>
   1099a:	65 3d 25 30 34 78    	gs cmp $0x78343025,%eax
   109a0:	20 25 73 0d 0a 00    	and    %ah,0xa0d73(%rip)        # b1719 <sig3+0x8971d>
   109a6:	41 53                	push   %r11
   109a8:	44                   	rex.R
   109a9:	46                   	rex.RX
   109aa:	47                   	rex.RXB
   109ab:	48                   	rex.W
   109ac:	4a                   	rex.WX
   109ad:	4b                   	rex.WXB
   109ae:	4c 3a 22             	rex.WR cmp (%rdx),%r12b
   109b1:	7e 00                	jle    109b3 <end_ctors+0x6d3>
   109b3:	72 65                	jb     10a1a <end_ctors+0x73a>
   109b5:	70 6c                	jo     10a23 <end_ctors+0x743>
   109b7:	79 00                	jns    109b9 <end_ctors+0x6d9>
   109b9:	5b                   	pop    %rbx
   109ba:	54                   	push   %rsp
   109bb:	43 50                	rex.XB push %r8
   109bd:	5d                   	pop    %rbp
   109be:	20 49 6e             	and    %cl,0x6e(%rcx)
   109c1:	76 61                	jbe    10a24 <end_ctors+0x744>
   109c3:	6c                   	insb   (%dx),%es:(%rdi)
   109c4:	69 64 20 70 61 63 6b 	imul   $0x656b6361,0x70(%rax,%riz,1),%esp
   109cb:	65 
   109cc:	74 3a                	je     10a08 <end_ctors+0x728>
   109ce:	20 53 52             	and    %dl,0x52(%rbx)
   109d1:	43 20 25 69 2c 20 46 	rex.XB and %spl,0x46202c69(%rip)        # 46213641 <kernel_main+0x45fff421>
   109d8:	6c                   	insb   (%dx),%es:(%rdi)
   109d9:	61                   	(bad)  
   109da:	67 73 3d             	addr32 jae 10a1a <end_ctors+0x73a>
   109dd:	25 30 32 78 2c       	and    $0x2c783230,%eax
   109e2:	20 53 59             	and    %dl,0x59(%rbx)
   109e5:	4e 3d 25 69 2c 20    	rex.WRX cmp $0x202c6925,%rax
   109eb:	41                   	rex.B
   109ec:	43                   	rex.XB
   109ed:	4b 3d 25 69 0d 0a    	rex.WXB cmp $0xa0d6925,%rax
   109f3:	00 49 6e             	add    %cl,0x6e(%rcx)
   109f6:	76 61                	jbe    10a59 <end_ctors+0x779>
   109f8:	6c                   	insb   (%dx),%es:(%rdi)
   109f9:	69 64 20 6f 70 63 6f 	imul   $0x646f6370,0x6f(%rax,%riz,1),%esp
   10a00:	64 
   10a01:	65 00 66 20          	add    %ah,%gs:0x20(%rsi)
   10a05:	00 53 74             	add    %dl,0x74(%rbx)
   10a08:	61                   	(bad)  
   10a09:	63 6b 20             	movsxd 0x20(%rbx),%ebp
   10a0c:	66 61                	data16 (bad) 
   10a0e:	75 6c                	jne    10a7c <end_ctors+0x79c>
   10a10:	74 00                	je     10a12 <end_ctors+0x732>
   10a12:	55                   	push   %rbp
   10a13:	6e                   	outsb  %ds:(%rsi),(%dx)
   10a14:	72 65                	jb     10a7b <end_ctors+0x79b>
   10a16:	63 6f 67             	movsxd 0x67(%rdi),%ebp
   10a19:	6e                   	outsb  %ds:(%rsi),(%dx)
   10a1a:	69 7a 65 64 20 69 6e 	imul   $0x6e692064,0x65(%rdx),%edi
   10a21:	74 65                	je     10a88 <end_ctors+0x7a8>
   10a23:	72 72                	jb     10a97 <end_ctors+0x7b7>
   10a25:	75 70                	jne    10a97 <end_ctors+0x7b7>
   10a27:	74 00                	je     10a29 <end_ctors+0x749>
   10a29:	69 6e 64 65 78 2e 68 	imul   $0x682e7865,0x64(%rsi),%ebp
   10a30:	74 6d                	je     10a9f <end_ctors+0x7bf>
   10a32:	6c                   	insb   (%dx),%es:(%rdi)
   10a33:	00 42 72             	add    %al,0x72(%rdx)
   10a36:	65 61                	gs (bad) 
   10a38:	6b 70 6f 69          	imul   $0x69,0x6f(%rax),%esi
   10a3c:	6e                   	outsb  %ds:(%rsi),(%dx)
   10a3d:	74 00                	je     10a3f <end_ctors+0x75f>
   10a3f:	5c                   	pop    %rsp
   10a40:	2f                   	(bad)  
   10a41:	00 5b 54             	add    %bl,0x54(%rbx)
   10a44:	43 50                	rex.XB push %r8
   10a46:	5d                   	pop    %rbp
   10a47:	20 53 70             	and    %dl,0x70(%rbx)
   10a4a:	75 72                	jne    10abe <end_ctors+0x7de>
   10a4c:	69 6f 75 73 20 70 61 	imul   $0x61702073,0x75(%rdi),%ebp
   10a53:	63 6b 65             	movsxd 0x65(%rbx),%ebp
   10a56:	74 20                	je     10a78 <end_ctors+0x798>
   10a58:	72 65                	jb     10abf <end_ctors+0x7df>
   10a5a:	63 69 65             	movsxd 0x65(%rcx),%ebp
   10a5d:	76 65                	jbe    10ac4 <end_ctors+0x7e4>
   10a5f:	64 20 64 75 72       	and    %ah,%fs:0x72(%rbp,%rsi,2)
   10a64:	69 6e 67 20 68 61 6e 	imul   $0x6e616820,0x67(%rsi),%ebp
   10a6b:	64 73 68             	fs jae 10ad6 <end_ctors+0x7f6>
   10a6e:	61                   	(bad)  
   10a6f:	6b 65 2c 20          	imul   $0x20,0x2c(%rbp),%esp
   10a73:	65 78 70             	gs js  10ae6 <end_ctors+0x806>
   10a76:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
   10a7b:	20 41 43             	and    %al,0x43(%rcx)
   10a7e:	4b 0d 0a 00 4e 6f    	rex.WXB or $0x6f4e000a,%rax
   10a84:	20 63 6f             	and    %ah,0x6f(%rbx)
   10a87:	70 72                	jo     10afb <end_ctors+0x81b>
   10a89:	6f                   	outsl  %ds:(%rsi),(%dx)
   10a8a:	63 65 73             	movsxd 0x73(%rbp),%esp
   10a8d:	73 6f                	jae    10afe <end_ctors+0x81e>
   10a8f:	72 00                	jb     10a91 <end_ctors+0x7b1>
   10a91:	47                   	rex.RXB
   10a92:	65 6e                	outsb  %gs:(%rsi),(%dx)
   10a94:	65 72 61             	gs jb  10af8 <end_ctors+0x818>
   10a97:	6c                   	insb   (%dx),%es:(%rdi)
   10a98:	20 70 72             	and    %dh,0x72(%rax)
   10a9b:	6f                   	outsl  %ds:(%rsi),(%dx)
   10a9c:	74 65                	je     10b03 <end_ctors+0x823>
   10a9e:	63 74 69 6f          	movsxd 0x6f(%rcx,%rbp,2),%esi
   10aa2:	6e                   	outsb  %ds:(%rsi),(%dx)
   10aa3:	20 66 61             	and    %ah,0x61(%rsi)
   10aa6:	75 6c                	jne    10b14 <end_ctors+0x834>
   10aa8:	74 00                	je     10aaa <end_ctors+0x7ca>
   10aaa:	74 65                	je     10b11 <end_ctors+0x831>
   10aac:	78 74                	js     10b22 <end_ctors+0x842>
   10aae:	2f                   	(bad)  
   10aaf:	63 73 73             	movsxd 0x73(%rbx),%esi
   10ab2:	00 72 65             	add    %dh,0x65(%rdx)
   10ab5:	71 75                	jno    10b2c <end_ctors+0x84c>
   10ab7:	65 73 74             	gs jae 10b2e <end_ctors+0x84e>
   10aba:	00 4c 41 52          	add    %cl,0x52(%rcx,%rax,2)
   10abe:	47                   	rex.RXB
   10abf:	45 20 50 41          	and    %r10b,0x41(%r8)
   10ac3:	43                   	rex.XB
   10ac4:	4b                   	rex.WXB
   10ac5:	45 54                	rex.RB push %r12
   10ac7:	3a 20                	cmp    (%rax),%ah
   10ac9:	25 69 20 62 79       	and    $0x79622069,%eax
   10ace:	74 65                	je     10b35 <end_ctors+0x855>
   10ad0:	73 0d                	jae    10adf <end_ctors+0x7ff>
   10ad2:	0a 00                	or     (%rax),%al
   10ad4:	76 20                	jbe    10af6 <end_ctors+0x816>
   10ad6:	00 20                	add    %ah,(%rax)
   10ad8:	20 52 58             	and    %dl,0x58(%rdx)
   10adb:	30 20                	xor    %ah,(%rax)
   10add:	41                   	rex.B
   10ade:	44                   	rex.R
   10adf:	44 52                	rex.R push %rdx
   10ae1:	20 25 30 38 78 20    	and    %ah,0x20783830(%rip)        # 20794317 <kernel_main+0x205800f7>
   10ae7:	53                   	push   %rbx
   10ae8:	54                   	push   %rsp
   10ae9:	41 54                	push   %r12
   10aeb:	55                   	push   %rbp
   10aec:	53                   	push   %rbx
   10aed:	20 25 30 32 78 0d    	and    %ah,0xd783230(%rip)        # d793d23 <kernel_main+0xd57fb03>
   10af3:	0a 00                	or     (%rax),%al
   10af5:	56                   	push   %rsi
   10af6:	4d 77 61             	rex.WRB ja 10b5a <end_ctors+0x87a>
   10af9:	72 65                	jb     10b60 <end_ctors+0x880>
   10afb:	20 53 56             	and    %dl,0x56(%rbx)
   10afe:	47                   	rex.RXB
   10aff:	41 20 64 65 76       	and    %spl,0x76(%r13,%riz,2)
   10b04:	69 63 65 20 74 6f 6f 	imul   $0x6f6f7420,0x65(%rbx),%esp
   10b0b:	20 6f 6c             	and    %ch,0x6c(%rdi)
   10b0e:	64 21 0d 0a 00 34 30 	and    %ecx,%fs:0x3034000a(%rip)        # 30350b1f <kernel_main+0x3013c8ff>
   10b15:	34 20                	xor    $0x20,%al
   10b17:	4e 6f                	rex.WRX outsl %ds:(%rsi),(%dx)
   10b19:	74 20                	je     10b3b <end_ctors+0x85b>
   10b1b:	46 6f                	rex.RX outsl %ds:(%rsi),(%dx)
   10b1d:	75 6e                	jne    10b8d <end_ctors+0x8ad>
   10b1f:	64 00 46 61          	add    %al,%fs:0x61(%rsi)
   10b23:	69 6c 65 64 20 74 6f 	imul   $0x206f7420,0x64(%rbp,%riz,2),%ebp
   10b2a:	20 
   10b2b:	6c                   	insb   (%dx),%es:(%rdi)
   10b2c:	6f                   	outsl  %ds:(%rsi),(%dx)
   10b2d:	63 61 74             	movsxd 0x74(%rcx),%esp
   10b30:	65 20 45 74          	and    %al,%gs:0x74(%rbp)
   10b34:	68 65 72 6e 65       	push   $0x656e7265
   10b39:	74 20                	je     10b5b <end_ctors+0x87b>
   10b3b:	63 6f 6e             	movsxd 0x6e(%rdi),%ebp
   10b3e:	74 72                	je     10bb2 <end_ctors+0x8d2>
   10b40:	6f                   	outsl  %ds:(%rsi),(%dx)
   10b41:	6c                   	insb   (%dx),%es:(%rdi)
   10b42:	6c                   	insb   (%dx),%es:(%rdi)
   10b43:	65 72 21             	gs jb  10b67 <end_ctors+0x887>
   10b46:	0d 0a 00 4f 4f       	or     $0x4f4f000a,%eax
   10b4b:	42 00 2e             	rex.X add %bpl,(%rsi)
   10b4e:	70 6e                	jo     10bbe <end_ctors+0x8de>
   10b50:	67 00 51 57          	add    %dl,0x57(%ecx)
   10b54:	45 52                	rex.RB push %r10
   10b56:	54                   	push   %rsp
   10b57:	59                   	pop    %rcx
   10b58:	55                   	push   %rbp
   10b59:	49                   	rex.WB
   10b5a:	4f 50                	rex.WRXB push %r8
   10b5c:	7b 7d                	jnp    10bdb <end_ctors+0x8fb>
   10b5e:	00 5b 54             	add    %bl,0x54(%rbx)
   10b61:	43 50                	rex.XB push %r8
   10b63:	5d                   	pop    %rbp
   10b64:	20 53 70             	and    %dl,0x70(%rbx)
   10b67:	75 72                	jne    10bdb <end_ctors+0x8fb>
   10b69:	69 6f 75 73 20 70 61 	imul   $0x61702073,0x75(%rdi),%ebp
   10b70:	63 6b 65             	movsxd 0x65(%rbx),%ebp
   10b73:	74 20                	je     10b95 <end_ctors+0x8b5>
   10b75:	72 65                	jb     10bdc <end_ctors+0x8fc>
   10b77:	63 69 65             	movsxd 0x65(%rcx),%ebp
   10b7a:	76 65                	jbe    10be1 <end_ctors+0x901>
   10b7c:	64 20 64 75 72       	and    %ah,%fs:0x72(%rbp,%rsi,2)
   10b81:	69 6e 67 20 68 61 6e 	imul   $0x6e616820,0x67(%rsi),%ebp
   10b88:	64 73 68             	fs jae 10bf3 <end_ctors+0x913>
   10b8b:	61                   	(bad)  
   10b8c:	6b 65 2c 20          	imul   $0x20,0x2c(%rbp),%esp
   10b90:	65 78 70             	gs js  10c03 <end_ctors+0x923>
   10b93:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
   10b98:	20 53 59             	and    %dl,0x59(%rbx)
   10b9b:	4e 2f                	rex.WRX (bad) 
   10b9d:	41                   	rex.B
   10b9e:	43                   	rex.XB
   10b9f:	4b 0d 0a 00 55 6e    	rex.WXB or $0x6e55000a,%rax
   10ba5:	72 65                	jb     10c0c <end_ctors+0x92c>
   10ba7:	63 6f 76             	movsxd 0x76(%rdi),%ebp
   10baa:	65 72 61             	gs jb  10c0e <end_ctors+0x92e>
   10bad:	62                   	(bad)  
   10bae:	6c                   	insb   (%dx),%es:(%rdi)
   10baf:	65 20 65 78          	and    %ah,%gs:0x78(%rbp)
   10bb3:	63 65 70             	movsxd 0x70(%rbp),%esp
   10bb6:	74 69                	je     10c21 <end_ctors+0x941>
   10bb8:	6f                   	outsl  %ds:(%rsi),(%dx)
   10bb9:	6e                   	outsb  %ds:(%rsi),(%dx)
   10bba:	20 2d 20 68 61 6c    	and    %ch,0x6c616820(%rip)        # 6c6273e0 <kernel_main+0x6c4131c0>
   10bc0:	74 69                	je     10c2b <end_ctors+0x94b>
   10bc2:	6e                   	outsb  %ds:(%rsi),(%dx)
   10bc3:	67 2e 2e 2e 0d 0a 00 	addr32 cs cs cs or $0x2020000a,%eax
   10bca:	20 20 
   10bcc:	20 25 69 00 2e 2e    	and    %ah,0x2e2e0069(%rip)        # 2e2f0c3b <kernel_main+0x2e0dca1b>
   10bd2:	00 48 54             	add    %cl,0x54(%rax)
   10bd5:	54                   	push   %rsp
   10bd6:	50                   	push   %rax
   10bd7:	2f                   	(bad)  
   10bd8:	31 2e                	xor    %ebp,(%rsi)
   10bda:	31 20                	xor    %esp,(%rax)
   10bdc:	25 53 0d 0a 43       	and    $0x430a0d53,%eax
   10be1:	6f                   	outsl  %ds:(%rsi),(%dx)
   10be2:	6e                   	outsb  %ds:(%rsi),(%dx)
   10be3:	74 65                	je     10c4a <end_ctors+0x96a>
   10be5:	6e                   	outsb  %ds:(%rsi),(%dx)
   10be6:	74 2d                	je     10c15 <end_ctors+0x935>
   10be8:	4c                   	rex.WR
   10be9:	65 6e                	outsb  %gs:(%rsi),(%dx)
   10beb:	67 74 68             	addr32 je 10c56 <end_ctors+0x976>
   10bee:	3a 20                	cmp    (%rax),%ah
   10bf0:	30 0d 0a 43 6f 6e    	xor    %cl,0x6e6f430a(%rip)        # 6e704f00 <kernel_main+0x6e4f0ce0>
   10bf6:	6e                   	outsb  %ds:(%rsi),(%dx)
   10bf7:	65 63 74 69 6f       	movsxd %gs:0x6f(%rcx,%rbp,2),%esi
   10bfc:	6e                   	outsb  %ds:(%rsi),(%dx)
   10bfd:	3a 20                	cmp    (%rax),%ah
   10bff:	63 6c 6f 73          	movsxd 0x73(%rdi,%rbp,2),%ebp
   10c03:	65 0d 0a 00 49 6e    	gs or  $0x6e49000a,%eax
   10c09:	69 74 20 73 74 61 6c 	imul   $0x6c6c6174,0x73(%rax,%riz,1),%esi
   10c10:	6c 
   10c11:	65 64 2e 20 43 4d    	gs fs and %al,%fs:0x4d(%rbx)
   10c17:	44 3a 20             	cmp    (%rax),%r12b
   10c1a:	25 30 38 78 0d       	and    $0xd783830,%eax
   10c1f:	0a 00                	or     (%rax),%al
   10c21:	49 52                	rex.WB push %r10
   10c23:	51                   	push   %rcx
   10c24:	00 25 53 0d 0a 00    	add    %ah,0xa0d53(%rip)        # b197d <sig3+0x89981>
   10c2a:	2e 63 73 73          	cs movsxd 0x73(%rbx),%esi
   10c2e:	00 42 61             	add    %al,0x61(%rdx)
   10c31:	64 20 54 53 53       	and    %dl,%fs:0x53(%rbx,%rdx,2)
   10c36:	00 50 61             	add    %dl,0x61(%rax)
   10c39:	67 65 20 66 61       	and    %ah,%gs:0x61(%esi)
   10c3e:	75 6c                	jne    10cac <end_ctors+0x9cc>
   10c40:	74 00                	je     10c42 <end_ctors+0x962>
   10c42:	43 6f                	rex.XB outsl %ds:(%rsi),(%dx)
   10c44:	70 72                	jo     10cb8 <end_ctors+0x9d8>
   10c46:	6f                   	outsl  %ds:(%rsi),(%dx)
   10c47:	63 65 73             	movsxd 0x73(%rbp),%esp
   10c4a:	73 6f                	jae    10cbb <end_ctors+0x9db>
   10c4c:	72 20                	jb     10c6e <end_ctors+0x98e>
   10c4e:	66 61                	data16 (bad) 
   10c50:	75 6c                	jne    10cbe <end_ctors+0x9de>
   10c52:	74 00                	je     10c54 <end_ctors+0x974>
   10c54:	44 69 76 69 64 65 20 	imul   $0x62206564,0x69(%rsi),%r14d
   10c5b:	62 
   10c5c:	79 20                	jns    10c7e <end_ctors+0x99e>
   10c5e:	7a 65                	jp     10cc5 <end_ctors+0x9e5>
   10c60:	72 6f                	jb     10cd1 <end_ctors+0x9f1>
   10c62:	00 5b 41             	add    %bl,0x41(%rbx)
   10c65:	52                   	push   %rdx
   10c66:	50                   	push   %rax
   10c67:	5d                   	pop    %rbp
   10c68:	20 25 49 20 77 61    	and    %ah,0x61772049(%rip)        # 61782cb7 <kernel_main+0x6156ea97>
   10c6e:	6e                   	outsb  %ds:(%rsi),(%dx)
   10c6f:	74 73                	je     10ce4 <end_ctors+0xa04>
   10c71:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
   10c75:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
   10c79:	3a 20                	cmp    (%rax),%ah
   10c7b:	57                   	push   %rdi
   10c7c:	68 6f 20 69 73       	push   $0x7369206f
   10c81:	20 25 49 3f 0d 0a    	and    %ah,0xa0d3f49(%rip)        # a0e4bd0 <kernel_main+0x9ed09b0>
   10c87:	00 69 6d             	add    %ch,0x6d(%rcx)
   10c8a:	61                   	(bad)  
   10c8b:	67 65 2f             	addr32 gs (bad) 
   10c8e:	70 6e                	jo     10cfe <end_ctors+0xa1e>
   10c90:	67 00 2e             	add    %ch,(%esi)
   10c93:	77 61                	ja     10cf6 <end_ctors+0xa16>
   10c95:	73 6d                	jae    10d04 <end_ctors+0xa24>
   10c97:	00 5b 54             	add    %bl,0x54(%rbx)
   10c9a:	43 50                	rex.XB push %r8
   10c9c:	5d                   	pop    %rbp
   10c9d:	20 25 49 3a 25 69    	and    %ah,0x69253a49(%rip)        # 692646ec <kernel_main+0x690504cc>
   10ca3:	2d 3e 25 69 3a       	sub    $0x3a69253e,%eax
   10ca8:	20 52 53             	and    %dl,0x53(%rdx)
   10cab:	54                   	push   %rsp
   10cac:	20 72 65             	and    %dh,0x65(%rdx)
   10caf:	63 69 65             	movsxd 0x65(%rcx),%ebp
   10cb2:	76 65                	jbe    10d19 <end_ctors+0xa39>
   10cb4:	64 2e 0d 0a 00 69 78 	fs cs or $0x7869000a,%eax
   10cbb:	58                   	pop    %rax
   10cbc:	70 62                	jo     10d20 <end_ctors+0xa40>
   10cbe:	66 73 53             	data16 jae 10d14 <end_ctors+0xa34>
   10cc1:	49                   	rex.WB
   10cc2:	4d 00 5b 41          	rex.WRB add %r11b,0x41(%r11)
   10cc6:	52                   	push   %rdx
   10cc7:	50                   	push   %rax
   10cc8:	5d                   	pop    %rbp
   10cc9:	20 4e 6f             	and    %cl,0x6f(%rsi)
   10ccc:	74 20                	je     10cee <end_ctors+0xa0e>
   10cce:	73 75                	jae    10d45 <end_ctors+0xa65>
   10cd0:	72 65                	jb     10d37 <end_ctors+0xa57>
   10cd2:	20 77 68             	and    %dh,0x68(%rdi)
   10cd5:	61                   	(bad)  
   10cd6:	74 20                	je     10cf8 <end_ctors+0xa18>
   10cd8:	74 6f                	je     10d49 <end_ctors+0xa69>
   10cda:	20 64 6f 20          	and    %ah,0x20(%rdi,%rbp,2)
   10cde:	77 69                	ja     10d49 <end_ctors+0xa69>
   10ce0:	74 68                	je     10d4a <end_ctors+0xa6a>
   10ce2:	20 25 73 2e 20 28    	and    %ah,0x28202e73(%rip)        # 28213b5b <kernel_main+0x27fff93b>
   10ce8:	25 4d 20 25 49       	and    $0x4925204d,%eax
   10ced:	29 20                	sub    %esp,(%rax)
   10cef:	28 25 4d 20 25 49    	sub    %ah,0x4925204d(%rip)        # 49262d42 <kernel_main+0x4904eb22>
   10cf5:	29 0d 0a 00 2e 77    	sub    %ecx,0x772e000a(%rip)        # 772f0d05 <kernel_main+0x770dcae5>
   10cfb:	65 62                	gs (bad) 
   10cfd:	70 00                	jo     10cff <end_ctors+0xa1f>
   10cff:	34 30                	xor    $0x30,%al
   10d01:	30 20                	xor    %ah,(%rax)
   10d03:	42 61                	rex.X (bad) 
   10d05:	64 20 52 65          	and    %dl,%fs:0x65(%rdx)
   10d09:	71 75                	jno    10d80 <end_ctors+0xaa0>
   10d0b:	65 73 74             	gs jae 10d82 <end_ctors+0xaa2>
   10d0e:	00 25 30 31 36 78    	add    %ah,0x78363130(%rip)        # 78373e44 <kernel_main+0x7815fc24>
   10d14:	20 25 30 31 36 78    	and    %ah,0x78363130(%rip)        # 78373e4a <kernel_main+0x7815fc2a>
   10d1a:	20 25 30 31 36 78    	and    %ah,0x78363130(%rip)        # 78373e50 <kernel_main+0x7815fc30>
   10d20:	20 25 30 31 36 78    	and    %ah,0x78363130(%rip)        # 78373e56 <kernel_main+0x7815fc36>
   10d26:	0d 0a 00 41 6c       	or     $0x6c41000a,%eax
   10d2b:	69 67 6e 6d 65 6e 74 	imul   $0x746e656d,0x6e(%rdi),%esp
   10d32:	20 63 68             	and    %ah,0x68(%rbx)
   10d35:	65 63 6b 00          	movsxd %gs:0x0(%rbx),%ebp
   10d39:	4d 61                	rex.WRB (bad) 
   10d3b:	63 68 69             	movsxd 0x69(%rax),%ebp
   10d3e:	6e                   	outsb  %ds:(%rsi),(%dx)
   10d3f:	65 20 63 68          	and    %ah,%gs:0x68(%rbx)
   10d43:	65 63 6b 00          	movsxd %gs:0x0(%rbx),%ebp
   10d47:	2e 6a 73             	cs push $0x73
   10d4a:	00 7c 5a 58          	add    %bh,0x58(%rdx,%rbx,2)
   10d4e:	43 56                	rex.XB push %r14
   10d50:	42                   	rex.X
   10d51:	4e                   	rex.WRX
   10d52:	4d 3c 3e             	rex.WRB cmp $0x3e,%al
   10d55:	3f                   	(bad)  
   10d56:	00 31                	add    %dh,(%rcx)
   10d58:	32 33                	xor    (%rbx),%dh
   10d5a:	34 35                	xor    $0x35,%al
   10d5c:	36 37                	ss (bad) 
   10d5e:	38 39                	cmp    %bh,(%rcx)
   10d60:	30 2d 3d 00 5c 7a    	xor    %ch,0x7a5c003d(%rip)        # 7a5d0da3 <kernel_main+0x7a3bcb83>
   10d66:	78 63                	js     10dcb <end_ctors+0xaeb>
   10d68:	76 62                	jbe    10dcc <end_ctors+0xaec>
   10d6a:	6e                   	outsb  %ds:(%rsi),(%dx)
   10d6b:	6d                   	insl   (%dx),%es:(%rdi)
   10d6c:	2c 2e                	sub    $0x2e,%al
   10d6e:	2f                   	(bad)  
   10d6f:	00 5b 41             	add    %bl,0x41(%rbx)
   10d72:	52                   	push   %rdx
   10d73:	50                   	push   %rax
   10d74:	5d                   	pop    %rbp
   10d75:	20 52 65             	and    %dl,0x65(%rdx)
   10d78:	73 70                	jae    10dea <end_ctors+0xb0a>
   10d7a:	6f                   	outsl  %ds:(%rsi),(%dx)
   10d7b:	6e                   	outsb  %ds:(%rsi),(%dx)
   10d7c:	64 69 6e 67 20 74 6f 	imul   $0x206f7420,%fs:0x67(%rsi),%ebp
   10d83:	20 
   10d84:	25 49 3a 20 25       	and    $0x25203a49,%eax
   10d89:	49 20 69 73          	rex.WB and %bpl,0x73(%r9)
   10d8d:	20 25 4d 2e 0d 0a    	and    %ah,0xa0d2e4d(%rip)        # a0e3be0 <kernel_main+0x9ecf9c0>
   10d93:	00 49 50             	add    %cl,0x50(%rcx)
   10d96:	3a 20                	cmp    (%rax),%ah
   10d98:	25 30 32 78 3a       	and    $0x3a783230,%eax
   10d9d:	25 30 31 36 78       	and    $0x78363130,%eax
   10da2:	0d 0a 00 45 45       	or     $0x4545000a,%eax
   10da7:	50                   	push   %rax
   10da8:	52                   	push   %rdx
   10da9:	4f                   	rex.WRXB
   10daa:	4d 20 52 65          	rex.WRB and %r10b,0x65(%r10)
   10dae:	61                   	(bad)  
   10daf:	64 20 45 72          	and    %al,%fs:0x72(%rbp)
   10db3:	72 6f                	jb     10e24 <end_ctors+0xb44>
   10db5:	72 3a                	jb     10df1 <end_ctors+0xb11>
   10db7:	20 25 30 38 78 20    	and    %ah,0x20783830(%rip)        # 207945ed <kernel_main+0x205803cd>
   10dbd:	25 30 38 78 0d       	and    $0xd783830,%eax
   10dc2:	0a 00                	or     (%rax),%al
   10dc4:	61                   	(bad)  
   10dc5:	73 64                	jae    10e2b <end_ctors+0xb4b>
   10dc7:	66 67 68 6a 6b       	addr32 pushw $0x6b6a
   10dcc:	6c                   	insb   (%dx),%es:(%rdi)
   10dcd:	3b 27                	cmp    (%rdi),%esp
   10dcf:	60                   	(bad)  
   10dd0:	00 44 6f 75          	add    %al,0x75(%rdi,%rbp,2)
   10dd4:	62                   	(bad)  
   10dd5:	6c                   	insb   (%dx),%es:(%rdi)
   10dd6:	65 20 66 61          	and    %ah,%gs:0x61(%rsi)
   10dda:	75 6c                	jne    10e48 <end_ctors+0xb68>
   10ddc:	74 00                	je     10dde <end_ctors+0xafe>
   10dde:	6c                   	insb   (%dx),%es:(%rdi)
   10ddf:	6f                   	outsl  %ds:(%rsi),(%dx)
   10de0:	61                   	(bad)  
   10de1:	64 65 64 20 6d 6f    	fs gs and %ch,%fs:0x6f(%rbp)
   10de7:	64 65 6c             	fs gs insb (%dx),%es:(%rdi)
   10dea:	20 77 69             	and    %dh,0x69(%rdi)
   10ded:	74 68                	je     10e57 <end_ctors+0xb77>
   10def:	20 25 69 20 76 65    	and    %ah,0x65762069(%rip)        # 65772e5e <kernel_main+0x6555ec3e>
   10df5:	72 74                	jb     10e6b <end_ctors+0xb8b>
   10df7:	73 2c                	jae    10e25 <end_ctors+0xb45>
   10df9:	20 25 69 20 74 72    	and    %ah,0x72742069(%rip)        # 72752e68 <kernel_main+0x7253ec48>
   10dff:	69 73 0d 0a 00 30 31 	imul   $0x3130000a,0xd(%rbx),%esi
   10e06:	32 33                	xor    (%rbx),%dh
   10e08:	34 35                	xor    $0x35,%al
   10e0a:	36 37                	ss (bad) 
   10e0c:	38 39                	cmp    %bh,(%rcx)
   10e0e:	61                   	(bad)  
   10e0f:	62 63 64 65 66       	(bad)
   10e14:	00 5b 41             	add    %bl,0x41(%rbx)
   10e17:	52                   	push   %rdx
   10e18:	50                   	push   %rax
   10e19:	5d                   	pop    %rbp
   10e1a:	20 41 6e             	and    %al,0x6e(%rcx)
   10e1d:	6e                   	outsb  %ds:(%rsi),(%dx)
   10e1e:	6f                   	outsl  %ds:(%rsi),(%dx)
   10e1f:	75 6e                	jne    10e8f <end_ctors+0xbaf>
   10e21:	63 65 6d             	movsxd 0x6d(%rbp),%esp
   10e24:	65 6e                	outsb  %gs:(%rsi),(%dx)
   10e26:	74 3a                	je     10e62 <end_ctors+0xb82>
   10e28:	20 25 49 20 62 65    	and    %ah,0x65622049(%rip)        # 65632e77 <kernel_main+0x6541ec57>
   10e2e:	6c                   	insb   (%dx),%es:(%rdi)
   10e2f:	6f                   	outsl  %ds:(%rsi),(%dx)
   10e30:	6e                   	outsb  %ds:(%rsi),(%dx)
   10e31:	67 73 20             	addr32 jae 10e54 <end_ctors+0xb74>
   10e34:	74 6f                	je     10ea5 <end_ctors+0xbc5>
   10e36:	20 25 4d 2e 0d 0a    	and    %ah,0xa0d2e4d(%rip)        # a0e3c89 <kernel_main+0x9ecfa69>
   10e3c:	00 4e 6f             	add    %cl,0x6f(%rsi)
   10e3f:	20 56 47             	and    %dl,0x47(%rsi)
   10e42:	41 20 64 69 73       	and    %spl,0x73(%r9,%rbp,2)
   10e47:	70 6c                	jo     10eb5 <end_ctors+0xbd5>
   10e49:	61                   	(bad)  
   10e4a:	79 20                	jns    10e6c <end_ctors+0xb8c>
   10e4c:	64 65 76 69          	fs gs jbe 10eb9 <end_ctors+0xbd9>
   10e50:	63 65 20             	movsxd 0x20(%rbp),%esp
   10e53:	64 65 74 65          	fs gs je 10ebc <end_ctors+0xbdc>
   10e57:	63 74 65 64          	movsxd 0x64(%rbp,%riz,2),%esi
   10e5b:	21 0d 0a 00 5b 41    	and    %ecx,0x415b000a(%rip)        # 415c0e6b <kernel_main+0x413acc4b>
   10e61:	52                   	push   %rdx
   10e62:	50                   	push   %rax
   10e63:	5d                   	pop    %rbp
   10e64:	20 25 4d 20 77 61    	and    %ah,0x6177204d(%rip)        # 61782eb7 <kernel_main+0x6156ec97>
   10e6a:	6e                   	outsb  %ds:(%rsi),(%dx)
   10e6b:	74 73                	je     10ee0 <end_ctors+0xc00>
   10e6d:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
   10e71:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
   10e75:	3a 20                	cmp    (%rax),%ah
   10e77:	49 73 20             	rex.WB jae 10e9a <end_ctors+0xbba>
   10e7a:	25 49 20 61 76       	and    $0x76612049,%eax
   10e7f:	61                   	(bad)  
   10e80:	69 6c 61 62 6c 65 3f 	imul   $0xd3f656c,0x62(%rcx,%riz,2),%ebp
   10e87:	0d 
   10e88:	0a 00                	or     (%rax),%al
   10e8a:	47                   	rex.RXB
   10e8b:	45 54                	rex.RB push %r12
   10e8d:	00 48 54             	add    %cl,0x54(%rax)
   10e90:	54                   	push   %rsp
   10e91:	50                   	push   %rax
   10e92:	2f                   	(bad)  
   10e93:	31 2e                	xor    %ebp,(%rsi)
   10e95:	31 20                	xor    %esp,(%rax)
   10e97:	32 30                	xor    (%rax),%dh
   10e99:	30 20                	xor    %ah,(%rax)
   10e9b:	4f                   	rex.WRXB
   10e9c:	4b 0d 0a 43 6f 6e    	rex.WXB or $0x6e6f430a,%rax
   10ea2:	74 65                	je     10f09 <end_ctors+0xc29>
   10ea4:	6e                   	outsb  %ds:(%rsi),(%dx)
   10ea5:	74 2d                	je     10ed4 <end_ctors+0xbf4>
   10ea7:	54                   	push   %rsp
   10ea8:	79 70                	jns    10f1a <end_ctors+0xc3a>
   10eaa:	65 3a 20             	cmp    %gs:(%rax),%ah
   10ead:	25 53 0d 0a 43       	and    $0x430a0d53,%eax
   10eb2:	6f                   	outsl  %ds:(%rsi),(%dx)
   10eb3:	6e                   	outsb  %ds:(%rsi),(%dx)
   10eb4:	74 65                	je     10f1b <end_ctors+0xc3b>
   10eb6:	6e                   	outsb  %ds:(%rsi),(%dx)
   10eb7:	74 2d                	je     10ee6 <end_ctors+0xc06>
   10eb9:	4c                   	rex.WR
   10eba:	65 6e                	outsb  %gs:(%rsi),(%dx)
   10ebc:	67 74 68             	addr32 je 10f27 <end_ctors+0xc47>
   10ebf:	3a 20                	cmp    (%rax),%ah
   10ec1:	25 69 0d 0a 41       	and    $0x410a0d69,%eax
   10ec6:	63 63 65             	movsxd 0x65(%rbx),%esp
   10ec9:	70 74                	jo     10f3f <end_ctors+0xc5f>
   10ecb:	2d 52 61 6e 67       	sub    $0x676e6152,%eax
   10ed0:	65 73 3a             	gs jae 10f0d <end_ctors+0xc2d>
   10ed3:	20 62 79             	and    %ah,0x79(%rdx)
   10ed6:	74 65                	je     10f3d <end_ctors+0xc5d>
   10ed8:	73 0d                	jae    10ee7 <end_ctors+0xc07>
   10eda:	0a 43 6f             	or     0x6f(%rbx),%al
   10edd:	6e                   	outsb  %ds:(%rsi),(%dx)
   10ede:	6e                   	outsb  %ds:(%rsi),(%dx)
   10edf:	65 63 74 69 6f       	movsxd %gs:0x6f(%rcx,%rbp,2),%esi
   10ee4:	6e                   	outsb  %ds:(%rsi),(%dx)
   10ee5:	3a 20                	cmp    (%rax),%ah
   10ee7:	6b 65 65 70          	imul   $0x70,0x65(%rbp),%esp
   10eeb:	2d 61 6c 69 76       	sub    $0x76696c61,%eax
   10ef0:	65 0d 0a 0d 0a 25    	gs or  $0x250a0d0a,%eax
   10ef6:	53                   	push   %rbx
   10ef7:	00 44 65 62          	add    %al,0x62(%rbp,%riz,2)
   10efb:	75 67                	jne    10f64 <end_ctors+0xc84>
   10efd:	00 28                	add    %ch,(%rax)
   10eff:	25 69 3a 25 69       	and    $0x69253a69,%eax
   10f04:	3a 25 69 29 20 64    	cmp    0x64202969(%rip),%ah        # 64213873 <kernel_main+0x63fff653>
   10f0a:	65 76 3a             	gs jbe 10f47 <end_ctors+0xc67>
   10f0d:	25 30 34 78 20       	and    $0x20783430,%eax
   10f12:	76 65                	jbe    10f79 <end_ctors+0xc99>
   10f14:	6e                   	outsb  %ds:(%rsi),(%dx)
   10f15:	64 6f                	outsl  %fs:(%rsi),(%dx)
   10f17:	72 3a                	jb     10f53 <end_ctors+0xc73>
   10f19:	25 30 34 78 20       	and    $0x20783430,%eax
   10f1e:	63 6c 61 73          	movsxd 0x73(%rcx,%riz,2),%ebp
   10f22:	73 20                	jae    10f44 <end_ctors+0xc64>
   10f24:	25 30 32 78 3a       	and    $0x3a783230,%eax
   10f29:	25 30 32 78 3a       	and    $0x3a783230,%eax
   10f2e:	25 30 32 78 3a       	and    $0x3a783230,%eax
   10f33:	25 30 32 78 0d       	and    $0xd783230,%eax
   10f38:	0a 00                	or     (%rax),%al
   10f3a:	69 6d 61 67 65 2f 77 	imul   $0x772f6567,0x61(%rbp),%ebp
   10f41:	65 62                	gs (bad) 
   10f43:	70 00                	jo     10f45 <end_ctors+0xc65>
   10f45:	74 65                	je     10fac <_ZL10exceptions+0xc>
   10f47:	78 74                	js     10fbd <_ZL10exceptions+0x1d>
   10f49:	2f                   	(bad)  
   10f4a:	68 74 6d 6c 00       	push   $0x6c6d74
   10f4f:	5b                   	pop    %rbx
   10f50:	54                   	push   %rsp
   10f51:	43 50                	rex.XB push %r8
   10f53:	5d                   	pop    %rbp
   10f54:	20 50 53             	and    %dl,0x53(%rax)
   10f57:	48 20 72 65          	rex.W and %sil,0x65(%rdx)
   10f5b:	63 69 65             	movsxd 0x65(%rcx),%ebp
   10f5e:	76 65                	jbe    10fc5 <_ZL10exceptions+0x25>
   10f60:	64 20 64 75 72       	and    %ah,%fs:0x72(%rbp,%rsi,2)
   10f65:	69 6e 67 20 69 6e 76 	imul   $0x766e6920,0x67(%rsi),%ebp
   10f6c:	61                   	(bad)  
   10f6d:	6c                   	insb   (%dx),%es:(%rdi)
   10f6e:	69 64 20 73 74 61 74 	imul   $0x65746174,0x73(%rax,%riz,1),%esp
   10f75:	65 
   10f76:	20 25 69 2e 0d 0a    	and    %ah,0xa0d2e69(%rip)        # a0e3de5 <kernel_main+0x9ecfbc5>
   10f7c:	00 2f                	add    %ch,(%rdi)
   10f7e:	63 6f 77             	movsxd 0x77(%rdi),%ebp
   10f81:	2e 6f                	outsl  %ds:(%rsi),(%dx)
   10f83:	62                   	(bad)  
   10f84:	6a 00                	push   $0x0
   10f86:	21 40 23             	and    %eax,0x23(%rax)
   10f89:	24 25                	and    $0x25,%al
   10f8b:	5e                   	pop    %rsi
   10f8c:	26 2a 28             	es sub (%rax),%ch
   10f8f:	29 5f 2b             	sub    %ebx,0x2b(%rdi)
   10f92:	00 71 77             	add    %dh,0x77(%rcx)
   10f95:	65 72 74             	gs jb  1100c <_ZL10exceptions+0x6c>
   10f98:	79 75                	jns    1100f <_ZL10exceptions+0x6f>
   10f9a:	69                   	.byte 0x69
   10f9b:	6f                   	outsl  %ds:(%rsi),(%dx)
   10f9c:	70 5b                	jo     10ff9 <_ZL10exceptions+0x59>
   10f9e:	5d                   	pop    %rbp
	...

0000000000010fa0 <_ZL10exceptions>:
   10fa0:	54 0c 01 00 00 00 00 00 f8 0e 01 00 00 00 00 00     T...............
   10fb0:	e5 07 01 00 00 00 00 00 34 0a 01 00 00 00 00 00     ........4.......
   10fc0:	af 08 01 00 00 00 00 00 49 0b 01 00 00 00 00 00     ........I.......
   10fd0:	f4 09 01 00 00 00 00 00 82 0a 01 00 00 00 00 00     ................
   10fe0:	d1 0d 01 00 00 00 00 00 dd 08 01 00 00 00 00 00     ................
   10ff0:	2f 0c 01 00 00 00 00 00 f9 08 01 00 00 00 00 00     /...............
   11000:	06 0a 01 00 00 00 00 00 91 0a 01 00 00 00 00 00     ................
   11010:	37 0c 01 00 00 00 00 00 12 0a 01 00 00 00 00 00     7...............
   11020:	42 0c 01 00 00 00 00 00 29 0d 01 00 00 00 00 00     B.......).......
   11030:	39 0d 01 00 00 00 00 00                             9.......

0000000000011038 <idtptr>:
	...
