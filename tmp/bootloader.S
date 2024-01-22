
tmp/bootloader.img.elf:     file format elf64-x86-64


Disassembly of section .bootloader:

0000000000007c00 <stage0_main>:
    7c00:	31 c0                	xor    %eax,%eax
    7c02:	8e d8                	mov    %eax,%ds
    7c04:	8e c0                	mov    %eax,%es
    7c06:	8e d0                	mov    %eax,%ss
    7c08:	bc 00 7c 88 16       	mov    $0x16887c00,%esp
    7c0d:	d7                   	xlat   %ds:(%rbx)
    7c0e:	7c b4                	jl     7bc4 <stage0_main-0x3c>
    7c10:	42 8a 16             	rex.X mov (%rsi),%dl
    7c13:	d7                   	xlat   %ds:(%rbx)
    7c14:	7c be                	jl     7bd4 <stage0_main-0x2c>
    7c16:	dc 7c 83 3e          	fdivrl 0x3e(%rbx,%rax,4)
    7c1a:	da 7c 00 74          	fidivrl 0x74(%rax,%rax,1)
    7c1e:	12                   	.byte 0x12

0000000000007c1f <load_block>:
    7c1f:	b4 0e                	mov    $0xe,%ah
    7c21:	be                   	.byte 0xbe
    7c22:	9e                   	sahf   
    7c23:	7c                   	.byte 0x7c

0000000000007c24 <print_loop>:
    7c24:	8a 04 46             	mov    (%rsi,%rax,2),%al
    7c27:	08 c0                	or     %al,%al
    7c29:	74 04                	je     7c2f <print_end>
    7c2b:	cd 10                	int    $0x10
    7c2d:	eb f5                	jmp    7c24 <print_loop>

0000000000007c2f <print_end>:
    7c2f:	eb fe                	jmp    7c2f <print_end>

0000000000007c31 <load_sectors>:
    7c31:	8b 0e                	mov    (%rsi),%ecx
    7c33:	d8 7c 89 0e          	fdivrs 0xe(%rcx,%rcx,4)
    7c37:	de 7c cd 13          	fidivrs 0x13(%rbp,%rcx,8)
    7c3b:	b8 00 70 8e c0       	mov    $0xc08e7000,%eax
    7c40:	bf 00 00 57 66       	mov    $0x66570000,%edi
    7c45:	b9 00 10 00 00       	mov    $0x1000,%ecx
    7c4a:	66 31 c0             	xor    %ax,%ax
    7c4d:	f3 66 ab             	rep stos %ax,%es:(%rdi)
    7c50:	5f                   	pop    %rdi
    7c51:	66 b8 03 10          	mov    $0x1003,%ax
    7c55:	07                   	(bad)  
    7c56:	00 26                	add    %ah,(%rsi)
    7c58:	66 89 05 66 b9 04 00 	mov    %ax,0x4b966(%rip)        # 535c5 <sig3+0x435c9>
    7c5f:	00 00                	add    %al,(%rax)
    7c61:	66 b8 03 20          	mov    $0x2003,%ax
    7c65:	07                   	(bad)  
    7c66:	00                   	.byte 0x0
    7c67:	bf                   	.byte 0xbf
    7c68:	00 10                	add    %dl,(%rax)

0000000000007c6a <load_sectors.PDPLoop>:
    7c6a:	26 66 89 05 66 05 00 	es mov %ax,0x10000566(%rip)        # 100081d8 <kernel_main+0xf000c79>
    7c71:	10 
    7c72:	00 00                	add    %al,(%rax)
    7c74:	83 c7 08             	add    $0x8,%edi
    7c77:	66 49 75 ef          	data16 rex.WB jne 7c6a <load_sectors.PDPLoop>
    7c7b:	66 b9 00 08          	mov    $0x800,%cx
    7c7f:	00 00                	add    %al,(%rax)
    7c81:	66 b8 83 00          	mov    $0x83,%ax
    7c85:	00 00                	add    %al,(%rax)
    7c87:	bf                   	.byte 0xbf
    7c88:	00 20                	add    %ah,(%rax)

0000000000007c8a <load_sectors.PDLoop>:
    7c8a:	26 66 89 05 66 05 00 	es mov %ax,0x566(%rip)        # 81f8 <isr_stub_13+0x26>
    7c91:	00 
    7c92:	20 00                	and    %al,(%rax)
    7c94:	83 c7 08             	add    $0x8,%edi
    7c97:	66 49 75 ef          	data16 rex.WB jne 7c8a <load_sectors.PDLoop>
    7c9b:	e9                   	.byte 0xe9
    7c9c:	62                   	.byte 0x62
    7c9d:	01                   	.byte 0x1

0000000000007c9e <block_err_msg>:
    7c9e:	4c 6f                	rex.WR outsl %ds:(%rsi),(%dx)
    7ca0:	61                   	(bad)  
    7ca1:	64 69 6e 67 20 6d 6f 	imul   $0x726f6d20,%fs:0x67(%rsi),%ebp
    7ca8:	72 
    7ca9:	65 20 74 68 61       	and    %dh,%gs:0x61(%rax,%rbp,2)
    7cae:	6e                   	outsb  %ds:(%rsi),(%dx)
    7caf:	20 36                	and    %dh,(%rsi)
    7cb1:	34 20                	xor    $0x20,%al
    7cb3:	73 65                	jae    7d1a <drive_lba+0x36>
    7cb5:	63 74 6f 72          	movsxd 0x72(%rdi,%rbp,2),%esi
    7cb9:	73 20                	jae    7cdb <required_block_count+0x1>
    7cbb:	69 6e 20 62 6f 6f 74 	imul   $0x746f6f62,0x20(%rsi),%ebp
    7cc2:	73 74                	jae    7d38 <drive_lba+0x54>
    7cc4:	72 61                	jb     7d27 <drive_lba+0x43>
    7cc6:	70 20                	jo     7ce8 <drive_lba+0x4>
    7cc8:	6e                   	outsb  %ds:(%rsi),(%dx)
    7cc9:	6f                   	outsl  %ds:(%rsi),(%dx)
    7cca:	74 20                	je     7cec <drive_lba+0x8>
    7ccc:	73 75                	jae    7d43 <drive_lba+0x5f>
    7cce:	70 70                	jo     7d40 <drive_lba+0x5c>
    7cd0:	6f                   	outsl  %ds:(%rsi),(%dx)
    7cd1:	72 74                	jb     7d47 <drive_lba+0x63>
    7cd3:	65                   	gs
    7cd4:	64                   	fs
    7cd5:	2e                   	cs
	...

0000000000007cd7 <drive_num>:
	...

0000000000007cd8 <required_sector_count>:
    7cd8:	3f                   	(bad)  
	...

0000000000007cda <required_block_count>:
	...

0000000000007cdc <drive_packet>:
    7cdc:	10 00                	adc    %al,(%rax)

0000000000007cde <drive_num_sectors>:
    7cde:	40                   	rex
	...

0000000000007ce0 <drive_address>:
	...

0000000000007ce2 <drive_sector>:
    7ce2:	e0 07                	loopne 7ceb <drive_lba+0x7>

0000000000007ce4 <drive_lba>:
    7ce4:	01 00                	add    %eax,(%rax)
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
    7dc6:	40 00 00             	rex add %al,(%rax)
	...

0000000000007dca <lba_size>:
    7dca:	00 10                	add    %dl,(%rax)
	...

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
    7ec1:	e8 0a 00 00 00       	call   7ed0 <enable_sse41>
    7ec6:	e8 1e 00 00 00       	call   7ee9 <enable_avx>
    7ecb:	e9 5c 13 00 00       	jmp    922c <stage2_main>

0000000000007ed0 <enable_sse41>:
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

0000000000007f30 <save_regs>:
    7f30:	52                   	push   %rdx
    7f31:	ba 00 00 01 00       	mov    $0x10000,%edx
    7f36:	48 89 02             	mov    %rax,(%rdx)
    7f39:	48 89 5a 08          	mov    %rbx,0x8(%rdx)
    7f3d:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
    7f41:	48 89 d0             	mov    %rdx,%rax
    7f44:	5a                   	pop    %rdx
    7f45:	48 89 50 18          	mov    %rdx,0x18(%rax)
    7f49:	48 89 70 20          	mov    %rsi,0x20(%rax)
    7f4d:	48 89 78 28          	mov    %rdi,0x28(%rax)
    7f51:	48 89 68 30          	mov    %rbp,0x30(%rax)
    7f55:	4c 89 40 40          	mov    %r8,0x40(%rax)
    7f59:	4c 89 48 48          	mov    %r9,0x48(%rax)
    7f5d:	4c 89 50 50          	mov    %r10,0x50(%rax)
    7f61:	4c 89 58 58          	mov    %r11,0x58(%rax)
    7f65:	4c 89 60 60          	mov    %r12,0x60(%rax)
    7f69:	4c 89 68 68          	mov    %r13,0x68(%rax)
    7f6d:	4c 89 70 70          	mov    %r14,0x70(%rax)
    7f71:	4c 89 78 78          	mov    %r15,0x78(%rax)
    7f75:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
    7f7a:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
    7f81:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
    7f86:	48 89 90 90 00 00 00 	mov    %rdx,0x90(%rax)
    7f8d:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
    7f92:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
    7f99:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
    7f9e:	48 89 50 38          	mov    %rdx,0x38(%rax)
    7fa2:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
    7fa7:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
    7fae:	c3                   	ret    

0000000000007faf <stor_regs>:
    7faf:	b8 00 00 01 00       	mov    $0x10000,%eax
    7fb4:	4c 8b 78 78          	mov    0x78(%rax),%r15
    7fb8:	4c 8b 70 70          	mov    0x70(%rax),%r14
    7fbc:	4c 8b 68 68          	mov    0x68(%rax),%r13
    7fc0:	4c 8b 60 60          	mov    0x60(%rax),%r12
    7fc4:	4c 8b 58 58          	mov    0x58(%rax),%r11
    7fc8:	4c 8b 50 50          	mov    0x50(%rax),%r10
    7fcc:	4c 8b 48 48          	mov    0x48(%rax),%r9
    7fd0:	4c 8b 40 40          	mov    0x40(%rax),%r8
    7fd4:	48 8b 68 30          	mov    0x30(%rax),%rbp
    7fd8:	48 8b 78 28          	mov    0x28(%rax),%rdi
    7fdc:	48 8b 70 20          	mov    0x20(%rax),%rsi
    7fe0:	48 8b 50 18          	mov    0x18(%rax),%rdx
    7fe4:	48 8b 48 10          	mov    0x10(%rax),%rcx
    7fe8:	48 8b 58 08          	mov    0x8(%rax),%rbx
    7fec:	ff 30                	push   (%rax)
    7fee:	58                   	pop    %rax
    7fef:	c3                   	ret    

0000000000007ff0 <isr_stub_0>:
    7ff0:	e8 3b ff ff ff       	call   7f30 <save_regs>
    7ff5:	bf 00 00 00 00       	mov    $0x0,%edi
    7ffa:	48 89 de             	mov    %rbx,%rsi
    7ffd:	55                   	push   %rbp
    7ffe:	48 89 e5             	mov    %rsp,%rbp
    8001:	e8 dd 35 00 00       	call   b5e3 <isr_no_err>
    8006:	5d                   	pop    %rbp
    8007:	e8 a3 ff ff ff       	call   7faf <stor_regs>
    800c:	48 cf                	iretq  

000000000000800e <isr_stub_1>:
    800e:	e8 1d ff ff ff       	call   7f30 <save_regs>
    8013:	bf 01 00 00 00       	mov    $0x1,%edi
    8018:	48 89 de             	mov    %rbx,%rsi
    801b:	55                   	push   %rbp
    801c:	48 89 e5             	mov    %rsp,%rbp
    801f:	e8 bf 35 00 00       	call   b5e3 <isr_no_err>
    8024:	5d                   	pop    %rbp
    8025:	e8 85 ff ff ff       	call   7faf <stor_regs>
    802a:	48 cf                	iretq  

000000000000802c <isr_stub_2>:
    802c:	e8 ff fe ff ff       	call   7f30 <save_regs>
    8031:	bf 02 00 00 00       	mov    $0x2,%edi
    8036:	48 89 de             	mov    %rbx,%rsi
    8039:	55                   	push   %rbp
    803a:	48 89 e5             	mov    %rsp,%rbp
    803d:	e8 a1 35 00 00       	call   b5e3 <isr_no_err>
    8042:	5d                   	pop    %rbp
    8043:	e8 67 ff ff ff       	call   7faf <stor_regs>
    8048:	48 cf                	iretq  

000000000000804a <isr_stub_3>:
    804a:	e8 e1 fe ff ff       	call   7f30 <save_regs>
    804f:	bf 03 00 00 00       	mov    $0x3,%edi
    8054:	48 89 de             	mov    %rbx,%rsi
    8057:	55                   	push   %rbp
    8058:	48 89 e5             	mov    %rsp,%rbp
    805b:	e8 83 35 00 00       	call   b5e3 <isr_no_err>
    8060:	5d                   	pop    %rbp
    8061:	e8 49 ff ff ff       	call   7faf <stor_regs>
    8066:	48 cf                	iretq  

0000000000008068 <isr_stub_4>:
    8068:	e8 c3 fe ff ff       	call   7f30 <save_regs>
    806d:	bf 04 00 00 00       	mov    $0x4,%edi
    8072:	48 89 de             	mov    %rbx,%rsi
    8075:	55                   	push   %rbp
    8076:	48 89 e5             	mov    %rsp,%rbp
    8079:	e8 65 35 00 00       	call   b5e3 <isr_no_err>
    807e:	5d                   	pop    %rbp
    807f:	e8 2b ff ff ff       	call   7faf <stor_regs>
    8084:	48 cf                	iretq  

0000000000008086 <isr_stub_5>:
    8086:	e8 a5 fe ff ff       	call   7f30 <save_regs>
    808b:	bf 05 00 00 00       	mov    $0x5,%edi
    8090:	48 89 de             	mov    %rbx,%rsi
    8093:	55                   	push   %rbp
    8094:	48 89 e5             	mov    %rsp,%rbp
    8097:	e8 47 35 00 00       	call   b5e3 <isr_no_err>
    809c:	5d                   	pop    %rbp
    809d:	e8 0d ff ff ff       	call   7faf <stor_regs>
    80a2:	48 cf                	iretq  

00000000000080a4 <isr_stub_6>:
    80a4:	e8 87 fe ff ff       	call   7f30 <save_regs>
    80a9:	bf 06 00 00 00       	mov    $0x6,%edi
    80ae:	48 89 de             	mov    %rbx,%rsi
    80b1:	55                   	push   %rbp
    80b2:	48 89 e5             	mov    %rsp,%rbp
    80b5:	e8 29 35 00 00       	call   b5e3 <isr_no_err>
    80ba:	5d                   	pop    %rbp
    80bb:	e8 ef fe ff ff       	call   7faf <stor_regs>
    80c0:	48 cf                	iretq  

00000000000080c2 <isr_stub_7>:
    80c2:	e8 69 fe ff ff       	call   7f30 <save_regs>
    80c7:	bf 07 00 00 00       	mov    $0x7,%edi
    80cc:	48 89 de             	mov    %rbx,%rsi
    80cf:	55                   	push   %rbp
    80d0:	48 89 e5             	mov    %rsp,%rbp
    80d3:	e8 0b 35 00 00       	call   b5e3 <isr_no_err>
    80d8:	5d                   	pop    %rbp
    80d9:	e8 d1 fe ff ff       	call   7faf <stor_regs>
    80de:	48 cf                	iretq  

00000000000080e0 <isr_stub_8>:
    80e0:	50                   	push   %rax
    80e1:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    80e6:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    80eb:	58                   	pop    %rax
    80ec:	48 83 c4 08          	add    $0x8,%rsp
    80f0:	e8 3b fe ff ff       	call   7f30 <save_regs>
    80f5:	bf 08 00 00 00       	mov    $0x8,%edi
    80fa:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    80ff:	be 00 00 01 00       	mov    $0x10000,%esi
    8104:	55                   	push   %rbp
    8105:	48 89 e5             	mov    %rsp,%rbp
    8108:	e8 b9 34 00 00       	call   b5c6 <isr_err>
    810d:	5d                   	pop    %rbp
    810e:	e8 9c fe ff ff       	call   7faf <stor_regs>
    8113:	48 cf                	iretq  

0000000000008115 <isr_stub_9>:
    8115:	e8 16 fe ff ff       	call   7f30 <save_regs>
    811a:	bf 09 00 00 00       	mov    $0x9,%edi
    811f:	48 89 de             	mov    %rbx,%rsi
    8122:	55                   	push   %rbp
    8123:	48 89 e5             	mov    %rsp,%rbp
    8126:	e8 b8 34 00 00       	call   b5e3 <isr_no_err>
    812b:	5d                   	pop    %rbp
    812c:	e8 7e fe ff ff       	call   7faf <stor_regs>
    8131:	48 cf                	iretq  

0000000000008133 <isr_stub_10>:
    8133:	50                   	push   %rax
    8134:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    8139:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    813e:	58                   	pop    %rax
    813f:	48 83 c4 08          	add    $0x8,%rsp
    8143:	e8 e8 fd ff ff       	call   7f30 <save_regs>
    8148:	bf 0a 00 00 00       	mov    $0xa,%edi
    814d:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8152:	be 00 00 01 00       	mov    $0x10000,%esi
    8157:	55                   	push   %rbp
    8158:	48 89 e5             	mov    %rsp,%rbp
    815b:	e8 66 34 00 00       	call   b5c6 <isr_err>
    8160:	5d                   	pop    %rbp
    8161:	e8 49 fe ff ff       	call   7faf <stor_regs>
    8166:	48 cf                	iretq  

0000000000008168 <isr_stub_11>:
    8168:	50                   	push   %rax
    8169:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    816e:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    8173:	58                   	pop    %rax
    8174:	48 83 c4 08          	add    $0x8,%rsp
    8178:	e8 b3 fd ff ff       	call   7f30 <save_regs>
    817d:	bf 0b 00 00 00       	mov    $0xb,%edi
    8182:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8187:	be 00 00 01 00       	mov    $0x10000,%esi
    818c:	55                   	push   %rbp
    818d:	48 89 e5             	mov    %rsp,%rbp
    8190:	e8 31 34 00 00       	call   b5c6 <isr_err>
    8195:	5d                   	pop    %rbp
    8196:	e8 14 fe ff ff       	call   7faf <stor_regs>
    819b:	48 cf                	iretq  

000000000000819d <isr_stub_12>:
    819d:	50                   	push   %rax
    819e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    81a3:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    81a8:	58                   	pop    %rax
    81a9:	48 83 c4 08          	add    $0x8,%rsp
    81ad:	e8 7e fd ff ff       	call   7f30 <save_regs>
    81b2:	bf 0c 00 00 00       	mov    $0xc,%edi
    81b7:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    81bc:	be 00 00 01 00       	mov    $0x10000,%esi
    81c1:	55                   	push   %rbp
    81c2:	48 89 e5             	mov    %rsp,%rbp
    81c5:	e8 fc 33 00 00       	call   b5c6 <isr_err>
    81ca:	5d                   	pop    %rbp
    81cb:	e8 df fd ff ff       	call   7faf <stor_regs>
    81d0:	48 cf                	iretq  

00000000000081d2 <isr_stub_13>:
    81d2:	50                   	push   %rax
    81d3:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    81d8:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    81dd:	58                   	pop    %rax
    81de:	48 83 c4 08          	add    $0x8,%rsp
    81e2:	e8 49 fd ff ff       	call   7f30 <save_regs>
    81e7:	bf 0d 00 00 00       	mov    $0xd,%edi
    81ec:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    81f1:	be 00 00 01 00       	mov    $0x10000,%esi
    81f6:	55                   	push   %rbp
    81f7:	48 89 e5             	mov    %rsp,%rbp
    81fa:	e8 c7 33 00 00       	call   b5c6 <isr_err>
    81ff:	5d                   	pop    %rbp
    8200:	e8 aa fd ff ff       	call   7faf <stor_regs>
    8205:	48 cf                	iretq  

0000000000008207 <isr_stub_14>:
    8207:	50                   	push   %rax
    8208:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    820d:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    8212:	58                   	pop    %rax
    8213:	48 83 c4 08          	add    $0x8,%rsp
    8217:	e8 14 fd ff ff       	call   7f30 <save_regs>
    821c:	bf 0e 00 00 00       	mov    $0xe,%edi
    8221:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8226:	be 00 00 01 00       	mov    $0x10000,%esi
    822b:	55                   	push   %rbp
    822c:	48 89 e5             	mov    %rsp,%rbp
    822f:	e8 92 33 00 00       	call   b5c6 <isr_err>
    8234:	5d                   	pop    %rbp
    8235:	e8 75 fd ff ff       	call   7faf <stor_regs>
    823a:	48 cf                	iretq  

000000000000823c <isr_stub_15>:
    823c:	e8 ef fc ff ff       	call   7f30 <save_regs>
    8241:	bf 0f 00 00 00       	mov    $0xf,%edi
    8246:	48 89 de             	mov    %rbx,%rsi
    8249:	55                   	push   %rbp
    824a:	48 89 e5             	mov    %rsp,%rbp
    824d:	e8 91 33 00 00       	call   b5e3 <isr_no_err>
    8252:	5d                   	pop    %rbp
    8253:	e8 57 fd ff ff       	call   7faf <stor_regs>
    8258:	48 cf                	iretq  

000000000000825a <isr_stub_16>:
    825a:	e8 d1 fc ff ff       	call   7f30 <save_regs>
    825f:	bf 10 00 00 00       	mov    $0x10,%edi
    8264:	48 89 de             	mov    %rbx,%rsi
    8267:	55                   	push   %rbp
    8268:	48 89 e5             	mov    %rsp,%rbp
    826b:	e8 73 33 00 00       	call   b5e3 <isr_no_err>
    8270:	5d                   	pop    %rbp
    8271:	e8 39 fd ff ff       	call   7faf <stor_regs>
    8276:	48 cf                	iretq  

0000000000008278 <isr_stub_17>:
    8278:	50                   	push   %rax
    8279:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    827e:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    8283:	58                   	pop    %rax
    8284:	48 83 c4 08          	add    $0x8,%rsp
    8288:	e8 a3 fc ff ff       	call   7f30 <save_regs>
    828d:	bf 11 00 00 00       	mov    $0x11,%edi
    8292:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8297:	be 00 00 01 00       	mov    $0x10000,%esi
    829c:	55                   	push   %rbp
    829d:	48 89 e5             	mov    %rsp,%rbp
    82a0:	e8 21 33 00 00       	call   b5c6 <isr_err>
    82a5:	5d                   	pop    %rbp
    82a6:	e8 04 fd ff ff       	call   7faf <stor_regs>
    82ab:	48 cf                	iretq  

00000000000082ad <isr_stub_18>:
    82ad:	e8 7e fc ff ff       	call   7f30 <save_regs>
    82b2:	bf 12 00 00 00       	mov    $0x12,%edi
    82b7:	48 89 de             	mov    %rbx,%rsi
    82ba:	55                   	push   %rbp
    82bb:	48 89 e5             	mov    %rsp,%rbp
    82be:	e8 20 33 00 00       	call   b5e3 <isr_no_err>
    82c3:	5d                   	pop    %rbp
    82c4:	e8 e6 fc ff ff       	call   7faf <stor_regs>
    82c9:	48 cf                	iretq  

00000000000082cb <isr_stub_19>:
    82cb:	e8 60 fc ff ff       	call   7f30 <save_regs>
    82d0:	bf 13 00 00 00       	mov    $0x13,%edi
    82d5:	48 89 de             	mov    %rbx,%rsi
    82d8:	55                   	push   %rbp
    82d9:	48 89 e5             	mov    %rsp,%rbp
    82dc:	e8 02 33 00 00       	call   b5e3 <isr_no_err>
    82e1:	5d                   	pop    %rbp
    82e2:	e8 c8 fc ff ff       	call   7faf <stor_regs>
    82e7:	48 cf                	iretq  

00000000000082e9 <isr_stub_20>:
    82e9:	e8 42 fc ff ff       	call   7f30 <save_regs>
    82ee:	bf 14 00 00 00       	mov    $0x14,%edi
    82f3:	48 89 de             	mov    %rbx,%rsi
    82f6:	55                   	push   %rbp
    82f7:	48 89 e5             	mov    %rsp,%rbp
    82fa:	e8 e4 32 00 00       	call   b5e3 <isr_no_err>
    82ff:	5d                   	pop    %rbp
    8300:	e8 aa fc ff ff       	call   7faf <stor_regs>
    8305:	48 cf                	iretq  

0000000000008307 <isr_stub_21>:
    8307:	e8 24 fc ff ff       	call   7f30 <save_regs>
    830c:	bf 15 00 00 00       	mov    $0x15,%edi
    8311:	48 89 de             	mov    %rbx,%rsi
    8314:	55                   	push   %rbp
    8315:	48 89 e5             	mov    %rsp,%rbp
    8318:	e8 c6 32 00 00       	call   b5e3 <isr_no_err>
    831d:	5d                   	pop    %rbp
    831e:	e8 8c fc ff ff       	call   7faf <stor_regs>
    8323:	48 cf                	iretq  

0000000000008325 <isr_stub_22>:
    8325:	e8 06 fc ff ff       	call   7f30 <save_regs>
    832a:	bf 16 00 00 00       	mov    $0x16,%edi
    832f:	48 89 de             	mov    %rbx,%rsi
    8332:	55                   	push   %rbp
    8333:	48 89 e5             	mov    %rsp,%rbp
    8336:	e8 a8 32 00 00       	call   b5e3 <isr_no_err>
    833b:	5d                   	pop    %rbp
    833c:	e8 6e fc ff ff       	call   7faf <stor_regs>
    8341:	48 cf                	iretq  

0000000000008343 <isr_stub_23>:
    8343:	e8 e8 fb ff ff       	call   7f30 <save_regs>
    8348:	bf 17 00 00 00       	mov    $0x17,%edi
    834d:	48 89 de             	mov    %rbx,%rsi
    8350:	55                   	push   %rbp
    8351:	48 89 e5             	mov    %rsp,%rbp
    8354:	e8 8a 32 00 00       	call   b5e3 <isr_no_err>
    8359:	5d                   	pop    %rbp
    835a:	e8 50 fc ff ff       	call   7faf <stor_regs>
    835f:	48 cf                	iretq  

0000000000008361 <isr_stub_24>:
    8361:	e8 ca fb ff ff       	call   7f30 <save_regs>
    8366:	bf 18 00 00 00       	mov    $0x18,%edi
    836b:	48 89 de             	mov    %rbx,%rsi
    836e:	55                   	push   %rbp
    836f:	48 89 e5             	mov    %rsp,%rbp
    8372:	e8 6c 32 00 00       	call   b5e3 <isr_no_err>
    8377:	5d                   	pop    %rbp
    8378:	e8 32 fc ff ff       	call   7faf <stor_regs>
    837d:	48 cf                	iretq  

000000000000837f <isr_stub_25>:
    837f:	e8 ac fb ff ff       	call   7f30 <save_regs>
    8384:	bf 19 00 00 00       	mov    $0x19,%edi
    8389:	48 89 de             	mov    %rbx,%rsi
    838c:	55                   	push   %rbp
    838d:	48 89 e5             	mov    %rsp,%rbp
    8390:	e8 4e 32 00 00       	call   b5e3 <isr_no_err>
    8395:	5d                   	pop    %rbp
    8396:	e8 14 fc ff ff       	call   7faf <stor_regs>
    839b:	48 cf                	iretq  

000000000000839d <isr_stub_26>:
    839d:	e8 8e fb ff ff       	call   7f30 <save_regs>
    83a2:	bf 1a 00 00 00       	mov    $0x1a,%edi
    83a7:	48 89 de             	mov    %rbx,%rsi
    83aa:	55                   	push   %rbp
    83ab:	48 89 e5             	mov    %rsp,%rbp
    83ae:	e8 30 32 00 00       	call   b5e3 <isr_no_err>
    83b3:	5d                   	pop    %rbp
    83b4:	e8 f6 fb ff ff       	call   7faf <stor_regs>
    83b9:	48 cf                	iretq  

00000000000083bb <isr_stub_27>:
    83bb:	e8 70 fb ff ff       	call   7f30 <save_regs>
    83c0:	bf 1b 00 00 00       	mov    $0x1b,%edi
    83c5:	48 89 de             	mov    %rbx,%rsi
    83c8:	55                   	push   %rbp
    83c9:	48 89 e5             	mov    %rsp,%rbp
    83cc:	e8 12 32 00 00       	call   b5e3 <isr_no_err>
    83d1:	5d                   	pop    %rbp
    83d2:	e8 d8 fb ff ff       	call   7faf <stor_regs>
    83d7:	48 cf                	iretq  

00000000000083d9 <isr_stub_28>:
    83d9:	e8 52 fb ff ff       	call   7f30 <save_regs>
    83de:	bf 1c 00 00 00       	mov    $0x1c,%edi
    83e3:	48 89 de             	mov    %rbx,%rsi
    83e6:	55                   	push   %rbp
    83e7:	48 89 e5             	mov    %rsp,%rbp
    83ea:	e8 f4 31 00 00       	call   b5e3 <isr_no_err>
    83ef:	5d                   	pop    %rbp
    83f0:	e8 ba fb ff ff       	call   7faf <stor_regs>
    83f5:	48 cf                	iretq  

00000000000083f7 <isr_stub_29>:
    83f7:	e8 34 fb ff ff       	call   7f30 <save_regs>
    83fc:	bf 1d 00 00 00       	mov    $0x1d,%edi
    8401:	48 89 de             	mov    %rbx,%rsi
    8404:	55                   	push   %rbp
    8405:	48 89 e5             	mov    %rsp,%rbp
    8408:	e8 d6 31 00 00       	call   b5e3 <isr_no_err>
    840d:	5d                   	pop    %rbp
    840e:	e8 9c fb ff ff       	call   7faf <stor_regs>
    8413:	48 cf                	iretq  

0000000000008415 <isr_stub_30>:
    8415:	50                   	push   %rax
    8416:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    841b:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
    8420:	58                   	pop    %rax
    8421:	48 83 c4 08          	add    $0x8,%rsp
    8425:	e8 06 fb ff ff       	call   7f30 <save_regs>
    842a:	bf 1e 00 00 00       	mov    $0x1e,%edi
    842f:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
    8434:	be 00 00 01 00       	mov    $0x10000,%esi
    8439:	55                   	push   %rbp
    843a:	48 89 e5             	mov    %rsp,%rbp
    843d:	e8 84 31 00 00       	call   b5c6 <isr_err>
    8442:	5d                   	pop    %rbp
    8443:	e8 67 fb ff ff       	call   7faf <stor_regs>
    8448:	48 cf                	iretq  

000000000000844a <isr_stub_31>:
    844a:	e8 e1 fa ff ff       	call   7f30 <save_regs>
    844f:	bf 1f 00 00 00       	mov    $0x1f,%edi
    8454:	48 89 de             	mov    %rbx,%rsi
    8457:	55                   	push   %rbp
    8458:	48 89 e5             	mov    %rsp,%rbp
    845b:	e8 83 31 00 00       	call   b5e3 <isr_no_err>
    8460:	5d                   	pop    %rbp
    8461:	e8 49 fb ff ff       	call   7faf <stor_regs>
    8466:	48 cf                	iretq  

0000000000008468 <isr_stub_32>:
    8468:	e8 c3 fa ff ff       	call   7f30 <save_regs>
    846d:	bf 20 00 00 00       	mov    $0x20,%edi
    8472:	48 89 de             	mov    %rbx,%rsi
    8475:	55                   	push   %rbp
    8476:	48 89 e5             	mov    %rsp,%rbp
    8479:	e8 81 31 00 00       	call   b5ff <irq_isr>
    847e:	5d                   	pop    %rbp
    847f:	e8 2b fb ff ff       	call   7faf <stor_regs>
    8484:	48 cf                	iretq  

0000000000008486 <isr_stub_33>:
    8486:	e8 a5 fa ff ff       	call   7f30 <save_regs>
    848b:	bf 21 00 00 00       	mov    $0x21,%edi
    8490:	48 89 de             	mov    %rbx,%rsi
    8493:	55                   	push   %rbp
    8494:	48 89 e5             	mov    %rsp,%rbp
    8497:	e8 63 31 00 00       	call   b5ff <irq_isr>
    849c:	5d                   	pop    %rbp
    849d:	e8 0d fb ff ff       	call   7faf <stor_regs>
    84a2:	48 cf                	iretq  

00000000000084a4 <isr_stub_34>:
    84a4:	e8 87 fa ff ff       	call   7f30 <save_regs>
    84a9:	bf 22 00 00 00       	mov    $0x22,%edi
    84ae:	48 89 de             	mov    %rbx,%rsi
    84b1:	55                   	push   %rbp
    84b2:	48 89 e5             	mov    %rsp,%rbp
    84b5:	e8 45 31 00 00       	call   b5ff <irq_isr>
    84ba:	5d                   	pop    %rbp
    84bb:	e8 ef fa ff ff       	call   7faf <stor_regs>
    84c0:	48 cf                	iretq  

00000000000084c2 <isr_stub_35>:
    84c2:	e8 69 fa ff ff       	call   7f30 <save_regs>
    84c7:	bf 23 00 00 00       	mov    $0x23,%edi
    84cc:	48 89 de             	mov    %rbx,%rsi
    84cf:	55                   	push   %rbp
    84d0:	48 89 e5             	mov    %rsp,%rbp
    84d3:	e8 27 31 00 00       	call   b5ff <irq_isr>
    84d8:	5d                   	pop    %rbp
    84d9:	e8 d1 fa ff ff       	call   7faf <stor_regs>
    84de:	48 cf                	iretq  

00000000000084e0 <isr_stub_36>:
    84e0:	e8 4b fa ff ff       	call   7f30 <save_regs>
    84e5:	bf 24 00 00 00       	mov    $0x24,%edi
    84ea:	48 89 de             	mov    %rbx,%rsi
    84ed:	55                   	push   %rbp
    84ee:	48 89 e5             	mov    %rsp,%rbp
    84f1:	e8 09 31 00 00       	call   b5ff <irq_isr>
    84f6:	5d                   	pop    %rbp
    84f7:	e8 b3 fa ff ff       	call   7faf <stor_regs>
    84fc:	48 cf                	iretq  

00000000000084fe <isr_stub_37>:
    84fe:	e8 2d fa ff ff       	call   7f30 <save_regs>
    8503:	bf 25 00 00 00       	mov    $0x25,%edi
    8508:	48 89 de             	mov    %rbx,%rsi
    850b:	55                   	push   %rbp
    850c:	48 89 e5             	mov    %rsp,%rbp
    850f:	e8 eb 30 00 00       	call   b5ff <irq_isr>
    8514:	5d                   	pop    %rbp
    8515:	e8 95 fa ff ff       	call   7faf <stor_regs>
    851a:	48 cf                	iretq  

000000000000851c <isr_stub_38>:
    851c:	e8 0f fa ff ff       	call   7f30 <save_regs>
    8521:	bf 26 00 00 00       	mov    $0x26,%edi
    8526:	48 89 de             	mov    %rbx,%rsi
    8529:	55                   	push   %rbp
    852a:	48 89 e5             	mov    %rsp,%rbp
    852d:	e8 cd 30 00 00       	call   b5ff <irq_isr>
    8532:	5d                   	pop    %rbp
    8533:	e8 77 fa ff ff       	call   7faf <stor_regs>
    8538:	48 cf                	iretq  

000000000000853a <isr_stub_39>:
    853a:	e8 f1 f9 ff ff       	call   7f30 <save_regs>
    853f:	bf 27 00 00 00       	mov    $0x27,%edi
    8544:	48 89 de             	mov    %rbx,%rsi
    8547:	55                   	push   %rbp
    8548:	48 89 e5             	mov    %rsp,%rbp
    854b:	e8 af 30 00 00       	call   b5ff <irq_isr>
    8550:	5d                   	pop    %rbp
    8551:	e8 59 fa ff ff       	call   7faf <stor_regs>
    8556:	48 cf                	iretq  

0000000000008558 <isr_stub_40>:
    8558:	e8 d3 f9 ff ff       	call   7f30 <save_regs>
    855d:	bf 28 00 00 00       	mov    $0x28,%edi
    8562:	48 89 de             	mov    %rbx,%rsi
    8565:	55                   	push   %rbp
    8566:	48 89 e5             	mov    %rsp,%rbp
    8569:	e8 91 30 00 00       	call   b5ff <irq_isr>
    856e:	5d                   	pop    %rbp
    856f:	e8 3b fa ff ff       	call   7faf <stor_regs>
    8574:	48 cf                	iretq  

0000000000008576 <isr_stub_41>:
    8576:	e8 b5 f9 ff ff       	call   7f30 <save_regs>
    857b:	bf 29 00 00 00       	mov    $0x29,%edi
    8580:	48 89 de             	mov    %rbx,%rsi
    8583:	55                   	push   %rbp
    8584:	48 89 e5             	mov    %rsp,%rbp
    8587:	e8 73 30 00 00       	call   b5ff <irq_isr>
    858c:	5d                   	pop    %rbp
    858d:	e8 1d fa ff ff       	call   7faf <stor_regs>
    8592:	48 cf                	iretq  

0000000000008594 <isr_stub_42>:
    8594:	e8 97 f9 ff ff       	call   7f30 <save_regs>
    8599:	bf 2a 00 00 00       	mov    $0x2a,%edi
    859e:	48 89 de             	mov    %rbx,%rsi
    85a1:	55                   	push   %rbp
    85a2:	48 89 e5             	mov    %rsp,%rbp
    85a5:	e8 55 30 00 00       	call   b5ff <irq_isr>
    85aa:	5d                   	pop    %rbp
    85ab:	e8 ff f9 ff ff       	call   7faf <stor_regs>
    85b0:	48 cf                	iretq  

00000000000085b2 <isr_stub_43>:
    85b2:	e8 79 f9 ff ff       	call   7f30 <save_regs>
    85b7:	bf 2b 00 00 00       	mov    $0x2b,%edi
    85bc:	48 89 de             	mov    %rbx,%rsi
    85bf:	55                   	push   %rbp
    85c0:	48 89 e5             	mov    %rsp,%rbp
    85c3:	e8 37 30 00 00       	call   b5ff <irq_isr>
    85c8:	5d                   	pop    %rbp
    85c9:	e8 e1 f9 ff ff       	call   7faf <stor_regs>
    85ce:	48 cf                	iretq  

00000000000085d0 <isr_stub_44>:
    85d0:	e8 5b f9 ff ff       	call   7f30 <save_regs>
    85d5:	bf 2c 00 00 00       	mov    $0x2c,%edi
    85da:	48 89 de             	mov    %rbx,%rsi
    85dd:	55                   	push   %rbp
    85de:	48 89 e5             	mov    %rsp,%rbp
    85e1:	e8 19 30 00 00       	call   b5ff <irq_isr>
    85e6:	5d                   	pop    %rbp
    85e7:	e8 c3 f9 ff ff       	call   7faf <stor_regs>
    85ec:	48 cf                	iretq  

00000000000085ee <isr_stub_45>:
    85ee:	e8 3d f9 ff ff       	call   7f30 <save_regs>
    85f3:	bf 2d 00 00 00       	mov    $0x2d,%edi
    85f8:	48 89 de             	mov    %rbx,%rsi
    85fb:	55                   	push   %rbp
    85fc:	48 89 e5             	mov    %rsp,%rbp
    85ff:	e8 fb 2f 00 00       	call   b5ff <irq_isr>
    8604:	5d                   	pop    %rbp
    8605:	e8 a5 f9 ff ff       	call   7faf <stor_regs>
    860a:	48 cf                	iretq  

000000000000860c <isr_stub_46>:
    860c:	e8 1f f9 ff ff       	call   7f30 <save_regs>
    8611:	bf 2e 00 00 00       	mov    $0x2e,%edi
    8616:	48 89 de             	mov    %rbx,%rsi
    8619:	55                   	push   %rbp
    861a:	48 89 e5             	mov    %rsp,%rbp
    861d:	e8 dd 2f 00 00       	call   b5ff <irq_isr>
    8622:	5d                   	pop    %rbp
    8623:	e8 87 f9 ff ff       	call   7faf <stor_regs>
    8628:	48 cf                	iretq  

000000000000862a <isr_stub_47>:
    862a:	e8 01 f9 ff ff       	call   7f30 <save_regs>
    862f:	bf 2f 00 00 00       	mov    $0x2f,%edi
    8634:	48 89 de             	mov    %rbx,%rsi
    8637:	55                   	push   %rbp
    8638:	48 89 e5             	mov    %rsp,%rbp
    863b:	e8 bf 2f 00 00       	call   b5ff <irq_isr>
    8640:	5d                   	pop    %rbp
    8641:	e8 69 f9 ff ff       	call   7faf <stor_regs>
    8646:	48 cf                	iretq  

0000000000008648 <isr_stub_table>:
    8648:	f0 7f 00             	lock jg 864b <isr_stub_table+0x3>
    864b:	00 0e                	add    %cl,(%rsi)
    864d:	80 00 00             	addb   $0x0,(%rax)
    8650:	2c 80                	sub    $0x80,%al
    8652:	00 00                	add    %al,(%rax)
    8654:	4a 80 00 00          	rex.WX addb $0x0,(%rax)
    8658:	68 80 00 00 86       	push   $0xffffffff86000080
    865d:	80 00 00             	addb   $0x0,(%rax)
    8660:	a4                   	movsb  %ds:(%rsi),%es:(%rdi)
    8661:	80 00 00             	addb   $0x0,(%rax)
    8664:	c2 80 00             	ret    $0x80
    8667:	00 e0                	add    %ah,%al
    8669:	80 00 00             	addb   $0x0,(%rax)
    866c:	15 81 00 00 33       	adc    $0x33000081,%eax
    8671:	81 00 00 68 81 00    	addl   $0x816800,(%rax)
    8677:	00 9d 81 00 00 d2    	add    %bl,-0x2dffff7f(%rbp)
    867d:	81 00 00 07 82 00    	addl   $0x820700,(%rax)
    8683:	00 3c 82             	add    %bh,(%rdx,%rax,4)
    8686:	00 00                	add    %al,(%rax)
    8688:	5a                   	pop    %rdx
    8689:	82                   	(bad)  
    868a:	00 00                	add    %al,(%rax)
    868c:	78 82                	js     8610 <isr_stub_46+0x4>
    868e:	00 00                	add    %al,(%rax)
    8690:	ad                   	lods   %ds:(%rsi),%eax
    8691:	82                   	(bad)  
    8692:	00 00                	add    %al,(%rax)
    8694:	cb                   	lret   
    8695:	82                   	(bad)  
    8696:	00 00                	add    %al,(%rax)
    8698:	e9 82 00 00 07       	jmp    700871f <kernel_main+0x60011c0>
    869d:	83 00 00             	addl   $0x0,(%rax)
    86a0:	25 83 00 00 43       	and    $0x43000083,%eax
    86a5:	83 00 00             	addl   $0x0,(%rax)
    86a8:	61                   	(bad)  
    86a9:	83 00 00             	addl   $0x0,(%rax)
    86ac:	7f 83                	jg     8631 <isr_stub_47+0x7>
    86ae:	00 00                	add    %al,(%rax)
    86b0:	9d                   	popf   
    86b1:	83 00 00             	addl   $0x0,(%rax)
    86b4:	bb 83 00 00 d9       	mov    $0xd9000083,%ebx
    86b9:	83 00 00             	addl   $0x0,(%rax)
    86bc:	f7 83 00 00 15 84 00 	testl  $0x844a0000,-0x7beb0000(%rbx)
    86c3:	00 4a 84 
    86c6:	00 00                	add    %al,(%rax)
    86c8:	68 84 00 00 86       	push   $0xffffffff86000084
    86cd:	84 00                	test   %al,(%rax)
    86cf:	00 a4 84 00 00 c2 84 	add    %ah,-0x7b3e0000(%rsp,%rax,4)
    86d6:	00 00                	add    %al,(%rax)
    86d8:	e0 84                	loopne 865e <isr_stub_table+0x16>
    86da:	00 00                	add    %al,(%rax)
    86dc:	fe 84 00 00 1c 85 00 	incb   0x851c00(%rax,%rax,1)
    86e3:	00 3a                	add    %bh,(%rdx)
    86e5:	85 00                	test   %eax,(%rax)
    86e7:	00 58 85             	add    %bl,-0x7b(%rax)
    86ea:	00 00                	add    %al,(%rax)
    86ec:	76 85                	jbe    8673 <isr_stub_table+0x2b>
    86ee:	00 00                	add    %al,(%rax)
    86f0:	94                   	xchg   %eax,%esp
    86f1:	85 00                	test   %eax,(%rax)
    86f3:	00 b2 85 00 00 d0    	add    %dh,-0x2fffff7b(%rdx)
    86f9:	85 00                	test   %eax,(%rax)
    86fb:	00 ee                	add    %ch,%dh
    86fd:	85 00                	test   %eax,(%rax)
    86ff:	00 0c 86             	add    %cl,(%rsi,%rax,4)
    8702:	00 00                	add    %al,(%rax)
    8704:	2a                   	.byte 0x2a
    8705:	86 00                	xchg   %al,(%rax)
	...

0000000000008708 <load_idt>:
    8708:	fa                   	cli    
    8709:	0f 01 1f             	lidt   (%rdi)
    870c:	b0 ff                	mov    $0xff,%al
    870e:	e6 21                	out    %al,$0x21
    8710:	e6 a1                	out    %al,$0xa1
    8712:	fb                   	sti    
    8713:	c3                   	ret    
    8714:	00 0f                	add    %cl,(%rdi)
    8716:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
    871d:	00 00 00 
    8720:	00 00                	add    %al,(%rax)
    8722:	30 43 00             	xor    %al,0x0(%rbx)
    8725:	00 30                	add    %dh,(%rax)
    8727:	45 00 00             	add    %r8b,(%r8)
	...
    8736:	30 43 00             	xor    %al,0x0(%rbx)
    8739:	00 00                	add    %al,(%rax)
    873b:	00 00                	add    %al,(%rax)
    873d:	00 30                	add    %dh,(%rax)
    873f:	45 00 00             	add    %r8b,(%r8)
    8742:	00 00                	add    %al,(%rax)
    8744:	80 84 2e 41 4e 6f 20 	addb   $0x41,0x206f4e41(%rsi,%rbp,1)
    874b:	41 
    874c:	48                   	rex.W
    874d:	43                   	rex.XB
    874e:	49 20 63 6f          	rex.WB and %spl,0x6f(%r11)
    8752:	6e                   	outsb  %ds:(%rsi),(%dx)
    8753:	74 72                	je     87c7 <load_idt+0xbf>
    8755:	6f                   	outsl  %ds:(%rsi),(%dx)
    8756:	6c                   	insb   (%dx),%es:(%rdi)
    8757:	6c                   	insb   (%dx),%es:(%rdi)
    8758:	65 72 20             	gs jb  877b <load_idt+0x73>
    875b:	64 65 74 65          	fs gs je 87c4 <load_idt+0xbc>
    875f:	63 74 65 64          	movsxd 0x64(%rbp,%riz,2),%esi
    8763:	21 0d 0a 00 44 65    	and    %ecx,0x6544000a(%rip)        # 65448773 <kernel_main+0x64441214>
    8769:	74 65                	je     87d0 <load_idt+0xc8>
    876b:	63 74 65 64          	movsxd 0x64(%rbp,%riz,2),%esi
    876f:	20 41 48             	and    %al,0x48(%rcx)
    8772:	43                   	rex.XB
    8773:	49 20 64 65 76       	rex.WB and %spl,0x76(%r13,%riz,2)
    8778:	69 63 65 3a 20 25 30 	imul   $0x3025203a,0x65(%rbx),%esp
    877f:	34 78                	xor    $0x78,%al
    8781:	3a 25 30 34 78 0d    	cmp    0xd783430(%rip),%ah        # d78bbb7 <kernel_main+0xc784658>
    8787:	0a 00                	or     (%rax),%al
    8789:	50                   	push   %rax
    878a:	61                   	(bad)  
    878b:	72 73                	jb     8800 <load_idt+0xf8>
    878d:	69 6e 67 20 70 61 72 	imul   $0x72617020,0x67(%rsi),%ebp
    8794:	74 69                	je     87ff <load_idt+0xf7>
    8796:	74 69                	je     8801 <load_idt+0xf9>
    8798:	6f                   	outsl  %ds:(%rsi),(%dx)
    8799:	6e                   	outsb  %ds:(%rsi),(%dx)
    879a:	20 74 61 62          	and    %dh,0x62(%rcx,%riz,2)
    879e:	6c                   	insb   (%dx),%es:(%rdi)
    879f:	65 2e 2e 2e 0d 0a 00 	gs cs cs cs or $0x6f4e000a,%eax
    87a6:	4e 6f 
    87a8:	20 46 41             	and    %al,0x41(%rsi)
    87ab:	54                   	push   %rsp
    87ac:	33 32                	xor    (%rdx),%esi
    87ae:	20 70 61             	and    %dh,0x61(%rax)
    87b1:	72 74                	jb     8827 <load_idt+0x11f>
    87b3:	69 74 69 6f 6e 73 20 	imul   $0x6420736e,0x6f(%rcx,%rbp,2),%esi
    87ba:	64 
    87bb:	65 74 65             	gs je  8823 <load_idt+0x11b>
    87be:	63 74 65 64          	movsxd 0x64(%rbp,%riz,2),%esi
    87c2:	2e 0d 0a 00 4c 6f    	cs or  $0x6f4c000a,%eax
    87c8:	61                   	(bad)  
    87c9:	64 69 6e 67 20 46 41 	imul   $0x54414620,%fs:0x67(%rsi),%ebp
    87d0:	54 
    87d1:	33 32                	xor    (%rdx),%esi
    87d3:	20 66 69             	and    %ah,0x69(%rsi)
    87d6:	6c                   	insb   (%dx),%es:(%rdi)
    87d7:	65 73 79             	gs jae 8853 <load_idt+0x14b>
    87da:	73 74                	jae    8850 <load_idt+0x148>
    87dc:	65 6d                	gs insl (%dx),%es:(%rdi)
    87de:	2e 2e 2e 0d 0a 00 49 	cs cs cs or $0x6e49000a,%eax
    87e5:	6e 
    87e6:	76 61                	jbe    8849 <load_idt+0x141>
    87e8:	6c                   	insb   (%dx),%es:(%rdi)
    87e9:	69 64 20 46 41 54 33 	imul   $0x32335441,0x46(%rax,%riz,1),%esp
    87f0:	32 
    87f1:	20 70 61             	and    %dh,0x61(%rax)
    87f4:	72 74                	jb     886a <load_idt+0x162>
    87f6:	69 74 69 6f 6e 2e 0d 	imul   $0xa0d2e6e,0x6f(%rcx,%rbp,2),%esi
    87fd:	0a 
    87fe:	00 50 61             	add    %dl,0x61(%rax)
    8801:	72 74                	jb     8877 <load_idt+0x16f>
    8803:	69 74 69 6f 6e 20 74 	imul   $0x6174206e,0x6f(%rcx,%rbp,2),%esi
    880a:	61 
    880b:	62                   	(bad)  
    880c:	6c                   	insb   (%dx),%es:(%rdi)
    880d:	65 3a 0d 0a 00 46 41 	cmp    %gs:0x4146000a(%rip),%cl        # 4146881e <kernel_main+0x404612bf>
    8814:	54                   	push   %rsp
    8815:	20 42 50             	and    %al,0x50(%rdx)
    8818:	42 3a 0d 0a 00 4c 6f 	rex.X cmp 0x6f4c000a(%rip),%cl        # 6f4c8829 <kernel_main+0x6e4c12ca>
    881f:	61                   	(bad)  
    8820:	64 69 6e 67 20 46 41 	imul   $0x54414620,%fs:0x67(%rsi),%ebp
    8827:	54 
    8828:	20 74 61 62          	and    %dh,0x62(%rcx,%riz,2)
    882c:	6c                   	insb   (%dx),%es:(%rdi)
    882d:	65 73 2e             	gs jae 885e <load_idt+0x156>
    8830:	2e 2e 0d 0a 00 4c 6f 	cs cs or $0x6f4c000a,%eax
    8837:	61                   	(bad)  
    8838:	64 69 6e 67 20 72 6f 	imul   $0x6f6f7220,%fs:0x67(%rsi),%ebp
    883f:	6f 
    8840:	74 20                	je     8862 <load_idt+0x15a>
    8842:	64 69 72 65 63 74 6f 	imul   $0x726f7463,%fs:0x65(%rdx),%esi
    8849:	72 
    884a:	79 2e                	jns    887a <load_idt+0x172>
    884c:	2e 2e 0d 0a 00 53 63 	cs cs or $0x6353000a,%eax
    8853:	61                   	(bad)  
    8854:	6e                   	outsb  %ds:(%rsi),(%dx)
    8855:	6e                   	outsb  %ds:(%rsi),(%dx)
    8856:	69 6e 67 20 66 6f 72 	imul   $0x726f6620,0x67(%rsi),%ebp
    885d:	20 6b 65             	and    %ch,0x65(%rbx)
    8860:	72 6e                	jb     88d0 <load_idt+0x1c8>
    8862:	65 6c                	gs insb (%dx),%es:(%rdi)
    8864:	20 65 78             	and    %ah,0x78(%rbp)
    8867:	65 63 75 74          	movsxd %gs:0x74(%rbp),%esi
    886b:	61                   	(bad)  
    886c:	62                   	(bad)  
    886d:	6c                   	insb   (%dx),%es:(%rdi)
    886e:	65 73 2e             	gs jae 889f <load_idt+0x197>
    8871:	2e 2e 0d 0a 00 6b 65 	cs cs or $0x656b000a,%eax
    8878:	72 6e                	jb     88e8 <load_idt+0x1e0>
    887a:	65 6c                	gs insb (%dx),%es:(%rdi)
    887c:	2e 69 6d 67 00 25 69 	cs imul $0x4d692500,0x67(%rbp),%ebp
    8883:	4d 
    8884:	48 7a 20             	rex.W jp 88a7 <load_idt+0x19f>
    8887:	28 25 6c 69 20 63    	sub    %ah,0x6320696c(%rip)        # 6320f1f9 <kernel_main+0x62207c9a>
    888d:	79 63                	jns    88f2 <load_idt+0x1ea>
    888f:	6c                   	insb   (%dx),%es:(%rdi)
    8890:	65 73 20             	gs jae 88b3 <load_idt+0x1ab>
    8893:	69 6e 20 25 69 75 73 	imul   $0x73756925,0x20(%rsi),%ebp
    889a:	29 0d 0a 00 66 90    	sub    %ecx,-0x6f99fff6(%rip)        # ffffffff906688aa <kernel_main+0xffffffff8f66134b>
    88a0:	4e 55                	rex.WRX push %rbp
    88a2:	4c                   	rex.WR
    88a3:	4c 00 00             	rex.WR add %r8b,(%rax)
	...
    88e2:	00 00                	add    %al,(%rax)
    88e4:	de 34 32             	fidivs (%rdx,%rsi,1)
    88e7:	41 20 00             	and    %al,(%r8)
	...
    88f6:	24 40                	and    $0x40,%al
    88f8:	9a                   	(bad)  
    88f9:	99                   	cltd   
    88fa:	99                   	cltd   
    88fb:	99                   	cltd   
    88fc:	99                   	cltd   
    88fd:	99                   	cltd   
    88fe:	b9 3f 00 00 00       	mov    $0x3f,%ecx
    8903:	00 00                	add    %al,(%rax)
    8905:	00 00                	add    %al,(%rax)
    8907:	80 0f 1f             	orb    $0x1f,(%rdi)
    890a:	84 00                	test   %al,(%rax)
    890c:	00 00                	add    %al,(%rax)
    890e:	00 00                	add    %al,(%rax)
    8910:	01 00                	add    %eax,(%rax)
    8912:	03 02                	add    (%rdx),%eax
	...
    8920:	03 02                	add    (%rdx),%eax
    8922:	01 00                	add    %eax,(%rax)
    8924:	07                   	(bad)  
    8925:	06                   	(bad)  
    8926:	05 04 00 00 00       	add    $0x4,%eax
    892b:	00 00                	add    %al,(%rax)
    892d:	00 00                	add    %al,(%rax)
    892f:	00 03                	add    %al,(%rbx)
    8931:	02 01                	add    (%rcx),%al
	...
    894f:	00 4e 4d             	add    %cl,0x4d(%rsi)
    8952:	49 00 20             	rex.WB add %spl,(%r8)
    8955:	20 52 43             	and    %dl,0x43(%rdx)
    8958:	54                   	push   %rsp
    8959:	52                   	push   %rdx
    895a:	4c 20 25 30 38 78 0d 	rex.WR and %r12b,0xd783830(%rip)        # d78c191 <kernel_main+0xc784c32>
    8961:	0a 00                	or     (%rax),%al
    8963:	5b                   	pop    %rbx
    8964:	41 52                	push   %r10
    8966:	50                   	push   %rax
    8967:	5d                   	pop    %rbp
    8968:	20 4e 6f             	and    %cl,0x6f(%rsi)
    896b:	2c 20                	sub    $0x20,%al
    896d:	25 49 20 62 65       	and    $0x65622049,%eax
    8972:	6c                   	insb   (%dx),%es:(%rdi)
    8973:	6f                   	outsl  %ds:(%rsi),(%dx)
    8974:	6e                   	outsb  %ds:(%rsi),(%dx)
    8975:	67 73 20             	addr32 jae 8998 <load_idt+0x290>
    8978:	74 6f                	je     89e9 <load_idt+0x2e1>
    897a:	20 25 4d 2e 0d 0a    	and    %ah,0xa0d2e4d(%rip)        # a0db7cd <kernel_main+0x90d426e>
    8980:	00 5b 49             	add    %bl,0x49(%rbx)
    8983:	50                   	push   %rax
    8984:	76 34                	jbe    89ba <load_idt+0x2b2>
    8986:	5d                   	pop    %rbp
    8987:	20 49 6e             	and    %cl,0x6e(%rcx)
    898a:	20 70 61             	and    %dh,0x61(%rax)
    898d:	63 6b 65             	movsxd 0x65(%rbx),%ebp
    8990:	74 20                	je     89b2 <load_idt+0x2aa>
    8992:	66 72 6f             	data16 jb 8a04 <load_idt+0x2fc>
    8995:	6d                   	insl   (%dx),%es:(%rdi)
    8996:	20 25 49 3a 20 4d    	and    %ah,0x4d203a49(%rip)        # 4d20c3e5 <kernel_main+0x4c204e86>
    899c:	69 73 6d 61 74 63 68 	imul   $0x68637461,0x6d(%rbx),%esi
    89a3:	20 69 6e             	and    %ch,0x6e(%rcx)
    89a6:	20 65 74             	and    %ah,0x74(%rbp)
    89a9:	68 65 72 6e 65       	push   $0x656e7265
    89ae:	74 20                	je     89d0 <load_idt+0x2c8>
    89b0:	61                   	(bad)  
    89b1:	6e                   	outsb  %ds:(%rsi),(%dx)
    89b2:	64 20 49 50          	and    %cl,%fs:0x50(%rcx)
    89b6:	20 70 61             	and    %dh,0x61(%rax)
    89b9:	63 6b 65             	movsxd 0x65(%rbx),%ebp
    89bc:	74 20                	je     89de <load_idt+0x2d6>
    89be:	73 69                	jae    8a29 <load_idt+0x321>
    89c0:	7a 65                	jp     8a27 <load_idt+0x31f>
    89c2:	73 21                	jae    89e5 <load_idt+0x2dd>
    89c4:	20 25 69 20 76 73    	and    %ah,0x73762069(%rip)        # 7376aa33 <kernel_main+0x727634d4>
    89ca:	20 25 69 0d 0a 00    	and    %ah,0xa0d69(%rip)        # a9739 <sig3+0x9973d>
    89d0:	4f 76 65             	rex.WRXB jbe 8a38 <load_idt+0x330>
    89d3:	72 66                	jb     8a3b <load_idt+0x333>
    89d5:	6c                   	insb   (%dx),%es:(%rdi)
    89d6:	6f                   	outsl  %ds:(%rsi),(%dx)
    89d7:	77 00                	ja     89d9 <load_idt+0x2d1>
    89d9:	20 20                	and    %ah,(%rax)
    89db:	52                   	push   %rdx
    89dc:	58                   	pop    %rax
    89dd:	44                   	rex.R
    89de:	48 20 25 69 20 52 58 	rex.W and %spl,0x58522069(%rip)        # 5852aa4e <kernel_main+0x575234ef>
    89e5:	44 54                	rex.R push %rsp
    89e7:	20 25 69 0d 0a 00    	and    %ah,0xa0d69(%rip)        # a9756 <sig3+0x9975a>
    89ed:	43 6f                	rex.XB outsl %ds:(%rsi),(%dx)
    89ef:	70 72                	jo     8a63 <load_idt+0x35b>
    89f1:	6f                   	outsl  %ds:(%rsi),(%dx)
    89f2:	63 65 73             	movsxd 0x73(%rbp),%esp
    89f5:	73 6f                	jae    8a66 <load_idt+0x35e>
    89f7:	72 20                	jb     8a19 <load_idt+0x311>
    89f9:	73 65                	jae    8a60 <load_idt+0x358>
    89fb:	67 6d                	insl   (%dx),%es:(%edi)
    89fd:	65 6e                	outsb  %gs:(%rsi),(%dx)
    89ff:	74 20                	je     8a21 <load_idt+0x319>
    8a01:	6f                   	outsl  %ds:(%rsi),(%dx)
    8a02:	76 65                	jbe    8a69 <load_idt+0x361>
    8a04:	72 72                	jb     8a78 <load_idt+0x370>
    8a06:	75 6e                	jne    8a76 <load_idt+0x36e>
    8a08:	00 53 65             	add    %dl,0x65(%rbx)
    8a0b:	67 6d                	insl   (%dx),%es:(%edi)
    8a0d:	65 6e                	outsb  %gs:(%rsi),(%dx)
    8a0f:	74 20                	je     8a31 <load_idt+0x329>
    8a11:	6e                   	outsb  %ds:(%rsi),(%dx)
    8a12:	6f                   	outsl  %ds:(%rsi),(%dx)
    8a13:	74 20                	je     8a35 <load_idt+0x32d>
    8a15:	70 72                	jo     8a89 <load_idt+0x381>
    8a17:	65 73 65             	gs jae 8a7f <load_idt+0x377>
    8a1a:	6e                   	outsb  %ds:(%rsi),(%dx)
    8a1b:	74 00                	je     8a1d <load_idt+0x315>
    8a1d:	46 6f                	rex.RX outsl %ds:(%rsi),(%dx)
    8a1f:	75 6e                	jne    8a8f <load_idt+0x387>
    8a21:	64 20 4d 41          	and    %cl,%fs:0x41(%rbp)
    8a25:	43 20 61 64          	rex.XB and %spl,0x64(%r9)
    8a29:	64 72 65             	fs jb  8a91 <load_idt+0x389>
    8a2c:	73 73                	jae    8aa1 <load_idt+0x399>
    8a2e:	3a 20                	cmp    (%rax),%ah
    8a30:	25 30 32 78 3a       	and    $0x3a783230,%eax
    8a35:	25 30 32 78 3a       	and    $0x3a783230,%eax
    8a3a:	25 30 32 78 3a       	and    $0x3a783230,%eax
    8a3f:	25 30 32 78 3a       	and    $0x3a783230,%eax
    8a44:	25 30 32 78 3a       	and    $0x3a783230,%eax
    8a49:	25 30 32 78 0d       	and    $0xd783230,%eax
    8a4e:	0a 00                	or     (%rax),%al
    8a50:	30 31                	xor    %dh,(%rcx)
    8a52:	32 33                	xor    (%rbx),%dh
    8a54:	34 35                	xor    $0x35,%al
    8a56:	36 37                	ss (bad) 
    8a58:	38 39                	cmp    %bh,(%rcx)
    8a5a:	41                   	rex.B
    8a5b:	42                   	rex.X
    8a5c:	43                   	rex.XB
    8a5d:	44                   	rex.R
    8a5e:	45                   	rex.RB
    8a5f:	46 00 44 65 74       	add    %r8b,0x74(%rbp,%r12,2)
    8a64:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
    8a69:	20 45 74             	and    %al,0x74(%rbp)
    8a6c:	68 65 72 6e 65       	push   $0x656e7265
    8a71:	74 20                	je     8a93 <load_idt+0x38b>
    8a73:	64 65 76 69          	fs gs jbe 8ae0 <load_idt+0x3d8>
    8a77:	63 65 3a             	movsxd 0x3a(%rbp),%esp
    8a7a:	20 25 30 34 78 3a    	and    %ah,0x3a783430(%rip)        # 3a78beb0 <kernel_main+0x39784951>
    8a80:	25 30 34 78 0d       	and    $0xd783430,%eax
    8a85:	0a 00                	or     (%rax),%al
    8a87:	0d 0a 45 78 63       	or     $0x6378450a,%eax
    8a8c:	65 70 74             	gs jo  8b03 <load_idt+0x3fb>
    8a8f:	69 6f 6e 20 76 3d 25 	imul   $0x253d7620,0x6e(%rdi),%ebp
    8a96:	30 32                	xor    %dh,(%rdx)
    8a98:	78 20                	js     8aba <load_idt+0x3b2>
    8a9a:	65 3d 25 30 34 78    	gs cmp $0x78343025,%eax
    8aa0:	20 25 73 0d 0a 00    	and    %ah,0xa0d73(%rip)        # a9819 <sig3+0x9981d>
    8aa6:	72 65                	jb     8b0d <load_idt+0x405>
    8aa8:	70 6c                	jo     8b16 <load_idt+0x40e>
    8aaa:	79 00                	jns    8aac <load_idt+0x3a4>
    8aac:	49 6e                	rex.WB outsb %ds:(%rsi),(%dx)
    8aae:	76 61                	jbe    8b11 <load_idt+0x409>
    8ab0:	6c                   	insb   (%dx),%es:(%rdi)
    8ab1:	69 64 20 6f 70 63 6f 	imul   $0x646f6370,0x6f(%rax,%riz,1),%esp
    8ab8:	64 
    8ab9:	65 00 47 45          	add    %al,%gs:0x45(%rdi)
    8abd:	54                   	push   %rsp
    8abe:	20 2f                	and    %ch,(%rdi)
    8ac0:	20 48 54             	and    %cl,0x54(%rax)
    8ac3:	54                   	push   %rsp
    8ac4:	50                   	push   %rax
    8ac5:	2f                   	(bad)  
    8ac6:	31 2e                	xor    %ebp,(%rsi)
    8ac8:	31 00                	xor    %eax,(%rax)
    8aca:	53                   	push   %rbx
    8acb:	74 61                	je     8b2e <load_idt+0x426>
    8acd:	63 6b 20             	movsxd 0x20(%rbx),%ebp
    8ad0:	66 61                	data16 (bad) 
    8ad2:	75 6c                	jne    8b40 <load_idt+0x438>
    8ad4:	74 00                	je     8ad6 <load_idt+0x3ce>
    8ad6:	55                   	push   %rbp
    8ad7:	6e                   	outsb  %ds:(%rsi),(%dx)
    8ad8:	72 65                	jb     8b3f <load_idt+0x437>
    8ada:	63 6f 67             	movsxd 0x67(%rdi),%ebp
    8add:	6e                   	outsb  %ds:(%rsi),(%dx)
    8ade:	69 7a 65 64 20 69 6e 	imul   $0x6e692064,0x65(%rdx),%edi
    8ae5:	74 65                	je     8b4c <load_idt+0x444>
    8ae7:	72 72                	jb     8b5b <load_idt+0x453>
    8ae9:	75 70                	jne    8b5b <load_idt+0x453>
    8aeb:	74 00                	je     8aed <load_idt+0x3e5>
    8aed:	42 72 65             	rex.X jb 8b55 <load_idt+0x44d>
    8af0:	61                   	(bad)  
    8af1:	6b 70 6f 69          	imul   $0x69,0x6f(%rax),%esi
    8af5:	6e                   	outsb  %ds:(%rsi),(%dx)
    8af6:	74 00                	je     8af8 <load_idt+0x3f0>
    8af8:	5b                   	pop    %rbx
    8af9:	54                   	push   %rsp
    8afa:	43 50                	rex.XB push %r8
    8afc:	5d                   	pop    %rbp
    8afd:	20 53 70             	and    %dl,0x70(%rbx)
    8b00:	75 72                	jne    8b74 <load_idt+0x46c>
    8b02:	69 6f 75 73 20 70 61 	imul   $0x61702073,0x75(%rdi),%ebp
    8b09:	63 6b 65             	movsxd 0x65(%rbx),%ebp
    8b0c:	74 20                	je     8b2e <load_idt+0x426>
    8b0e:	72 65                	jb     8b75 <load_idt+0x46d>
    8b10:	63 69 65             	movsxd 0x65(%rcx),%ebp
    8b13:	76 65                	jbe    8b7a <load_idt+0x472>
    8b15:	64 20 64 75 72       	and    %ah,%fs:0x72(%rbp,%rsi,2)
    8b1a:	69 6e 67 20 68 61 6e 	imul   $0x6e616820,0x67(%rsi),%ebp
    8b21:	64 73 68             	fs jae 8b8c <load_idt+0x484>
    8b24:	61                   	(bad)  
    8b25:	6b 65 2c 20          	imul   $0x20,0x2c(%rbp),%esp
    8b29:	65 78 70             	gs js  8b9c <load_idt+0x494>
    8b2c:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
    8b31:	20 41 43             	and    %al,0x43(%rcx)
    8b34:	4b 0d 0a 00 5b 54    	rex.WXB or $0x545b000a,%rax
    8b3a:	43 50                	rex.XB push %r8
    8b3c:	5d                   	pop    %rbp
    8b3d:	20 49 6e             	and    %cl,0x6e(%rcx)
    8b40:	76 61                	jbe    8ba3 <load_idt+0x49b>
    8b42:	6c                   	insb   (%dx),%es:(%rdi)
    8b43:	69 64 20 70 61 63 6b 	imul   $0x656b6361,0x70(%rax,%riz,1),%esp
    8b4a:	65 
    8b4b:	74 3a                	je     8b87 <load_idt+0x47f>
    8b4d:	20 46 6c             	and    %al,0x6c(%rsi)
    8b50:	61                   	(bad)  
    8b51:	67 73 3d             	addr32 jae 8b91 <load_idt+0x489>
    8b54:	25 30 32 78 0d       	and    $0xd783230,%eax
    8b59:	0a 00                	or     (%rax),%al
    8b5b:	4e 6f                	rex.WRX outsl %ds:(%rsi),(%dx)
    8b5d:	20 63 6f             	and    %ah,0x6f(%rbx)
    8b60:	70 72                	jo     8bd4 <load_idt+0x4cc>
    8b62:	6f                   	outsl  %ds:(%rsi),(%dx)
    8b63:	63 65 73             	movsxd 0x73(%rbp),%esp
    8b66:	73 6f                	jae    8bd7 <load_idt+0x4cf>
    8b68:	72 00                	jb     8b6a <load_idt+0x462>
    8b6a:	47                   	rex.RXB
    8b6b:	65 6e                	outsb  %gs:(%rsi),(%dx)
    8b6d:	65 72 61             	gs jb  8bd1 <load_idt+0x4c9>
    8b70:	6c                   	insb   (%dx),%es:(%rdi)
    8b71:	20 70 72             	and    %dh,0x72(%rax)
    8b74:	6f                   	outsl  %ds:(%rsi),(%dx)
    8b75:	74 65                	je     8bdc <load_idt+0x4d4>
    8b77:	63 74 69 6f          	movsxd 0x6f(%rcx,%rbp,2),%esi
    8b7b:	6e                   	outsb  %ds:(%rsi),(%dx)
    8b7c:	20 66 61             	and    %ah,0x61(%rsi)
    8b7f:	75 6c                	jne    8bed <load_idt+0x4e5>
    8b81:	74 00                	je     8b83 <load_idt+0x47b>
    8b83:	20 20                	and    %ah,(%rax)
    8b85:	52                   	push   %rdx
    8b86:	44                   	rex.R
    8b87:	46                   	rex.RX
    8b88:	48 20 25 78 20 52 44 	rex.W and %spl,0x44522078(%rip)        # 4452ac07 <kernel_main+0x435236a8>
    8b8f:	46 54                	rex.RX push %rsp
    8b91:	20 25 78 0d 0a 00    	and    %ah,0xa0d78(%rip)        # a990f <sig3+0x99913>
    8b97:	72 65                	jb     8bfe <load_idt+0x4f6>
    8b99:	71 75                	jno    8c10 <load_idt+0x508>
    8b9b:	65 73 74             	gs jae 8c12 <load_idt+0x50a>
    8b9e:	00 34 30             	add    %dh,(%rax,%rsi,1)
    8ba1:	34 20                	xor    $0x20,%al
    8ba3:	4e 6f                	rex.WRX outsl %ds:(%rsi),(%dx)
    8ba5:	74 20                	je     8bc7 <load_idt+0x4bf>
    8ba7:	46 6f                	rex.RX outsl %ds:(%rsi),(%dx)
    8ba9:	75 6e                	jne    8c19 <load_idt+0x511>
    8bab:	64 0d 0a 43 6f 6e    	fs or  $0x6e6f430a,%eax
    8bb1:	74 65                	je     8c18 <load_idt+0x510>
    8bb3:	6e                   	outsb  %ds:(%rsi),(%dx)
    8bb4:	74 2d                	je     8be3 <load_idt+0x4db>
    8bb6:	54                   	push   %rsp
    8bb7:	79 70                	jns    8c29 <load_idt+0x521>
    8bb9:	65 3a 20             	cmp    %gs:(%rax),%ah
    8bbc:	74 65                	je     8c23 <load_idt+0x51b>
    8bbe:	78 74                	js     8c34 <load_idt+0x52c>
    8bc0:	2f                   	(bad)  
    8bc1:	70 6c                	jo     8c2f <load_idt+0x527>
    8bc3:	61                   	(bad)  
    8bc4:	69 6e 0d 0a 43 6f 6e 	imul   $0x6e6f430a,0xd(%rsi),%ebp
    8bcb:	74 65                	je     8c32 <load_idt+0x52a>
    8bcd:	6e                   	outsb  %ds:(%rsi),(%dx)
    8bce:	74 2d                	je     8bfd <load_idt+0x4f5>
    8bd0:	4c                   	rex.WR
    8bd1:	65 6e                	outsb  %gs:(%rsi),(%dx)
    8bd3:	67 74 68             	addr32 je 8c3e <load_idt+0x536>
    8bd6:	3a 20                	cmp    (%rax),%ah
    8bd8:	30 0d 0a 43 6f 6e    	xor    %cl,0x6e6f430a(%rip)        # 6e6fcee8 <kernel_main+0x6d6f5989>
    8bde:	6e                   	outsb  %ds:(%rsi),(%dx)
    8bdf:	65 63 74 69 6f       	movsxd %gs:0x6f(%rcx,%rbp,2),%esi
    8be4:	6e                   	outsb  %ds:(%rsi),(%dx)
    8be5:	3a 20                	cmp    (%rax),%ah
    8be7:	63 6c 6f 73          	movsxd 0x73(%rdi,%rbp,2),%ebp
    8beb:	65 0d 0a 00 20 20    	gs or  $0x2020000a,%eax
    8bf1:	52                   	push   %rdx
    8bf2:	58                   	pop    %rax
    8bf3:	30 20                	xor    %ah,(%rax)
    8bf5:	41                   	rex.B
    8bf6:	44                   	rex.R
    8bf7:	44 52                	rex.R push %rdx
    8bf9:	20 25 30 38 78 20    	and    %ah,0x20783830(%rip)        # 2078c42f <kernel_main+0x1f784ed0>
    8bff:	53                   	push   %rbx
    8c00:	54                   	push   %rsp
    8c01:	41 54                	push   %r12
    8c03:	55                   	push   %rbp
    8c04:	53                   	push   %rbx
    8c05:	20 25 30 32 78 0d    	and    %ah,0xd783230(%rip)        # d78be3b <kernel_main+0xc7848dc>
    8c0b:	0a 00                	or     (%rax),%al
    8c0d:	46 61                	rex.RX (bad) 
    8c0f:	69 6c 65 64 20 74 6f 	imul   $0x206f7420,0x64(%rbp,%riz,2),%ebp
    8c16:	20 
    8c17:	6c                   	insb   (%dx),%es:(%rdi)
    8c18:	6f                   	outsl  %ds:(%rsi),(%dx)
    8c19:	63 61 74             	movsxd 0x74(%rcx),%esp
    8c1c:	65 20 45 74          	and    %al,%gs:0x74(%rbp)
    8c20:	68 65 72 6e 65       	push   $0x656e7265
    8c25:	74 20                	je     8c47 <load_idt+0x53f>
    8c27:	63 6f 6e             	movsxd 0x6e(%rdi),%ebp
    8c2a:	74 72                	je     8c9e <load_idt+0x596>
    8c2c:	6f                   	outsl  %ds:(%rsi),(%dx)
    8c2d:	6c                   	insb   (%dx),%es:(%rdi)
    8c2e:	6c                   	insb   (%dx),%es:(%rdi)
    8c2f:	65 72 21             	gs jb  8c53 <load_idt+0x54b>
    8c32:	0d 0a 00 52 65       	or     $0x6552000a,%eax
    8c37:	67 69 73 74 65 72 20 	imul   $0x64207265,0x74(%ebx),%esi
    8c3e:	64 
    8c3f:	75 6d                	jne    8cae <load_idt+0x5a6>
    8c41:	70 3a                	jo     8c7d <load_idt+0x575>
    8c43:	0d 0a 00 4f 4f       	or     $0x4f4f000a,%eax
    8c48:	42 00 5b 54          	rex.X add %bl,0x54(%rbx)
    8c4c:	43 50                	rex.XB push %r8
    8c4e:	5d                   	pop    %rbp
    8c4f:	20 4f 70             	and    %cl,0x70(%rdi)
    8c52:	65 6e                	outsb  %gs:(%rsi),(%dx)
    8c54:	69 6e 67 20 63 6f 6e 	imul   $0x6e6f6320,0x67(%rsi),%ebp
    8c5b:	6e                   	outsb  %ds:(%rsi),(%dx)
    8c5c:	65 63 74 69 6f       	movsxd %gs:0x6f(%rcx,%rbp,2),%esi
    8c61:	6e                   	outsb  %ds:(%rsi),(%dx)
    8c62:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
    8c66:	70 6f                	jo     8cd7 <load_idt+0x5cf>
    8c68:	72 74                	jb     8cde <load_idt+0x5d6>
    8c6a:	20 25 69 20 77 69    	and    %ah,0x69772069(%rip)        # 6977acd9 <kernel_main+0x6877377a>
    8c70:	74 68                	je     8cda <load_idt+0x5d2>
    8c72:	20 25 49 3a 25 69    	and    %ah,0x69253a49(%rip)        # 6925c6c1 <kernel_main+0x68255162>
    8c78:	2e 0d 0a 00 48 54    	cs or  $0x5448000a,%eax
    8c7e:	54                   	push   %rsp
    8c7f:	50                   	push   %rax
    8c80:	2f                   	(bad)  
    8c81:	31 2e                	xor    %ebp,(%rsi)
    8c83:	31 20                	xor    %esp,(%rax)
    8c85:	32 30                	xor    (%rax),%dh
    8c87:	30 20                	xor    %ah,(%rax)
    8c89:	4f                   	rex.WRXB
    8c8a:	4b 0d 0a 43 6f 6e    	rex.WXB or $0x6e6f430a,%rax
    8c90:	74 65                	je     8cf7 <load_idt+0x5ef>
    8c92:	6e                   	outsb  %ds:(%rsi),(%dx)
    8c93:	74 2d                	je     8cc2 <load_idt+0x5ba>
    8c95:	54                   	push   %rsp
    8c96:	79 70                	jns    8d08 <load_idt+0x600>
    8c98:	65 3a 20             	cmp    %gs:(%rax),%ah
    8c9b:	74 65                	je     8d02 <load_idt+0x5fa>
    8c9d:	78 74                	js     8d13 <load_idt+0x60b>
    8c9f:	2f                   	(bad)  
    8ca0:	68 74 6d 6c 0d       	push   $0xd6c6d74
    8ca5:	0a 43 6f             	or     0x6f(%rbx),%al
    8ca8:	6e                   	outsb  %ds:(%rsi),(%dx)
    8ca9:	74 65                	je     8d10 <load_idt+0x608>
    8cab:	6e                   	outsb  %ds:(%rsi),(%dx)
    8cac:	74 2d                	je     8cdb <load_idt+0x5d3>
    8cae:	4c                   	rex.WR
    8caf:	65 6e                	outsb  %gs:(%rsi),(%dx)
    8cb1:	67 74 68             	addr32 je 8d1c <load_idt+0x614>
    8cb4:	3a 20                	cmp    (%rax),%ah
    8cb6:	25 69 0d 0a 41       	and    $0x410a0d69,%eax
    8cbb:	63 63 65             	movsxd 0x65(%rbx),%esp
    8cbe:	70 74                	jo     8d34 <load_idt+0x62c>
    8cc0:	2d 52 61 6e 67       	sub    $0x676e6152,%eax
    8cc5:	65 73 3a             	gs jae 8d02 <load_idt+0x5fa>
    8cc8:	20 62 79             	and    %ah,0x79(%rdx)
    8ccb:	74 65                	je     8d32 <load_idt+0x62a>
    8ccd:	73 0d                	jae    8cdc <load_idt+0x5d4>
    8ccf:	0a 43 6f             	or     0x6f(%rbx),%al
    8cd2:	6e                   	outsb  %ds:(%rsi),(%dx)
    8cd3:	6e                   	outsb  %ds:(%rsi),(%dx)
    8cd4:	65 63 74 69 6f       	movsxd %gs:0x6f(%rcx,%rbp,2),%esi
    8cd9:	6e                   	outsb  %ds:(%rsi),(%dx)
    8cda:	3a 20                	cmp    (%rax),%ah
    8cdc:	63 6c 6f 73          	movsxd 0x73(%rdi,%rbp,2),%ebp
    8ce0:	65 0d 0a 0d 0a 25    	gs or  $0x250a0d0a,%eax
    8ce6:	73 00                	jae    8ce8 <load_idt+0x5e0>
    8ce8:	5b                   	pop    %rbx
    8ce9:	54                   	push   %rsp
    8cea:	43 50                	rex.XB push %r8
    8cec:	5d                   	pop    %rbp
    8ced:	20 53 70             	and    %dl,0x70(%rbx)
    8cf0:	75 72                	jne    8d64 <load_idt+0x65c>
    8cf2:	69 6f 75 73 20 70 61 	imul   $0x61702073,0x75(%rdi),%ebp
    8cf9:	63 6b 65             	movsxd 0x65(%rbx),%ebp
    8cfc:	74 20                	je     8d1e <load_idt+0x616>
    8cfe:	72 65                	jb     8d65 <load_idt+0x65d>
    8d00:	63 69 65             	movsxd 0x65(%rcx),%ebp
    8d03:	76 65                	jbe    8d6a <load_idt+0x662>
    8d05:	64 20 64 75 72       	and    %ah,%fs:0x72(%rbp,%rsi,2)
    8d0a:	69 6e 67 20 68 61 6e 	imul   $0x6e616820,0x67(%rsi),%ebp
    8d11:	64 73 68             	fs jae 8d7c <load_idt+0x674>
    8d14:	61                   	(bad)  
    8d15:	6b 65 2c 20          	imul   $0x20,0x2c(%rbp),%esp
    8d19:	65 78 70             	gs js  8d8c <load_idt+0x684>
    8d1c:	65 63 74 65 64       	movsxd %gs:0x64(%rbp,%riz,2),%esi
    8d21:	20 53 59             	and    %dl,0x59(%rbx)
    8d24:	4e 2f                	rex.WRX (bad) 
    8d26:	41                   	rex.B
    8d27:	43                   	rex.XB
    8d28:	4b 0d 0a 00 55 6e    	rex.WXB or $0x6e55000a,%rax
    8d2e:	72 65                	jb     8d95 <load_idt+0x68d>
    8d30:	63 6f 76             	movsxd 0x76(%rdi),%ebp
    8d33:	65 72 61             	gs jb  8d97 <load_idt+0x68f>
    8d36:	62                   	(bad)  
    8d37:	6c                   	insb   (%dx),%es:(%rdi)
    8d38:	65 20 65 78          	and    %ah,%gs:0x78(%rbp)
    8d3c:	63 65 70             	movsxd 0x70(%rbp),%esp
    8d3f:	74 69                	je     8daa <load_idt+0x6a2>
    8d41:	6f                   	outsl  %ds:(%rsi),(%dx)
    8d42:	6e                   	outsb  %ds:(%rsi),(%dx)
    8d43:	20 2d 20 68 61 6c    	and    %ch,0x6c616820(%rip)        # 6c61f569 <kernel_main+0x6b61800a>
    8d49:	74 69                	je     8db4 <load_idt+0x6ac>
    8d4b:	6e                   	outsb  %ds:(%rsi),(%dx)
    8d4c:	67 2e 2e 2e 0d 0a 00 	addr32 cs cs cs or $0x2020000a,%eax
    8d53:	20 20 
    8d55:	20 25 69 00 4e 6f    	and    %ah,0x6f4e0069(%rip)        # 6f4e8dc4 <kernel_main+0x6e4e1865>
    8d5b:	20 61 76             	and    %ah,0x76(%rcx)
    8d5e:	61                   	(bad)  
    8d5f:	69 6c 61 62 6c 65 20 	imul   $0x6320656c,0x62(%rcx,%riz,2),%ebp
    8d66:	63 
    8d67:	6f                   	outsl  %ds:(%rsi),(%dx)
    8d68:	6d                   	insl   (%dx),%es:(%rdi)
    8d69:	6d                   	insl   (%dx),%es:(%rdi)
    8d6a:	61                   	(bad)  
    8d6b:	6e                   	outsb  %ds:(%rsi),(%dx)
    8d6c:	64 20 73 6c          	and    %dh,%fs:0x6c(%rbx)
    8d70:	6f                   	outsl  %ds:(%rsi),(%dx)
    8d71:	74 73                	je     8de6 <load_idt+0x6de>
    8d73:	21 0d 0a 00 2e 2e    	and    %ecx,0x2e2e000a(%rip)        # 2e2e8d83 <kernel_main+0x2d2e1824>
    8d79:	00 30                	add    %dh,(%rax)
    8d7b:	78 00                	js     8d7d <load_idt+0x675>
    8d7d:	49 6e                	rex.WB outsb %ds:(%rsi),(%dx)
    8d7f:	69 74 20 73 74 61 6c 	imul   $0x6c6c6174,0x73(%rax,%riz,1),%esi
    8d86:	6c 
    8d87:	65 64 2e 20 43 4d    	gs fs and %al,%fs:0x4d(%rbx)
    8d8d:	44 3a 20             	cmp    (%rax),%r12b
    8d90:	25 30 38 78 0d       	and    $0xd783830,%eax
    8d95:	0a 00                	or     (%rax),%al
    8d97:	5b                   	pop    %rbx
    8d98:	54                   	push   %rsp
    8d99:	43 50                	rex.XB push %r8
    8d9b:	5d                   	pop    %rbp
    8d9c:	20 52 53             	and    %dl,0x53(%rdx)
    8d9f:	54                   	push   %rsp
    8da0:	20 73 75             	and    %dh,0x75(%rbx)
    8da3:	70 70                	jo     8e15 <load_idt+0x70d>
    8da5:	6f                   	outsl  %ds:(%rsi),(%dx)
    8da6:	72 74                	jb     8e1c <load_idt+0x714>
    8da8:	20 75 6e             	and    %dh,0x6e(%rbp)
    8dab:	69 6d 70 6c 65 6d 65 	imul   $0x656d656c,0x70(%rbp),%ebp
    8db2:	6e                   	outsb  %ds:(%rsi),(%dx)
    8db3:	74 65                	je     8e1a <load_idt+0x712>
    8db5:	64 2e 0d 0a 00 49 52 	fs cs or $0x5249000a,%eax
    8dbc:	51                   	push   %rcx
    8dbd:	00 4f 4f             	add    %cl,0x4f(%rdi)
    8dc0:	42 20 61 63          	rex.X and %spl,0x63(%rcx)
    8dc4:	63 65 73             	movsxd 0x73(%rbp),%esp
    8dc7:	73 20                	jae    8de9 <load_idt+0x6e1>
    8dc9:	74 6f                	je     8e3a <load_idt+0x732>
    8dcb:	20 73 70             	and    %dh,0x70(%rbx)
    8dce:	61                   	(bad)  
    8dcf:	6e                   	outsb  %ds:(%rsi),(%dx)
    8dd0:	2e 0d 0a 00 25 53    	cs or  $0x5325000a,%eax
    8dd6:	0d 0a 00 42 61       	or     $0x6142000a,%eax
    8ddb:	64 20 54 53 53       	and    %dl,%fs:0x53(%rbx,%rdx,2)
    8de0:	00 50 61             	add    %dl,0x61(%rax)
    8de3:	67 65 20 66 61       	and    %ah,%gs:0x61(%esi)
    8de8:	75 6c                	jne    8e56 <load_idt+0x74e>
    8dea:	74 00                	je     8dec <load_idt+0x6e4>
    8dec:	43 6f                	rex.XB outsl %ds:(%rsi),(%dx)
    8dee:	70 72                	jo     8e62 <load_idt+0x75a>
    8df0:	6f                   	outsl  %ds:(%rsi),(%dx)
    8df1:	63 65 73             	movsxd 0x73(%rbp),%esp
    8df4:	73 6f                	jae    8e65 <load_idt+0x75d>
    8df6:	72 20                	jb     8e18 <load_idt+0x710>
    8df8:	66 61                	data16 (bad) 
    8dfa:	75 6c                	jne    8e68 <load_idt+0x760>
    8dfc:	74 00                	je     8dfe <load_idt+0x6f6>
    8dfe:	4e 61                	rex.WRX (bad) 
    8e00:	4e 00 44 69 76       	rex.WRX add %r8b,0x76(%rcx,%r13,2)
    8e05:	69 64 65 20 62 79 20 	imul   $0x7a207962,0x20(%rbp,%riz,2),%esp
    8e0c:	7a 
    8e0d:	65 72 6f             	gs jb  8e7f <load_idt+0x777>
    8e10:	00 5b 41             	add    %bl,0x41(%rbx)
    8e13:	52                   	push   %rdx
    8e14:	50                   	push   %rax
    8e15:	5d                   	pop    %rbp
    8e16:	20 25 49 20 77 61    	and    %ah,0x61772049(%rip)        # 6177ae65 <kernel_main+0x60773906>
    8e1c:	6e                   	outsb  %ds:(%rsi),(%dx)
    8e1d:	74 73                	je     8e92 <load_idt+0x78a>
    8e1f:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
    8e23:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
    8e27:	3a 20                	cmp    (%rax),%ah
    8e29:	57                   	push   %rdi
    8e2a:	68 6f 20 69 73       	push   $0x7369206f
    8e2f:	20 25 49 3f 0d 0a    	and    %ah,0xa0d3f49(%rip)        # a0dcd7e <kernel_main+0x90d581f>
    8e35:	00 69 78             	add    %ch,0x78(%rcx)
    8e38:	58                   	pop    %rax
    8e39:	70 62                	jo     8e9d <load_idt+0x795>
    8e3b:	66 73 53             	data16 jae 8e91 <load_idt+0x789>
    8e3e:	49                   	rex.WB
    8e3f:	4d 00 5b 41          	rex.WRB add %r11b,0x41(%r11)
    8e43:	52                   	push   %rdx
    8e44:	50                   	push   %rax
    8e45:	5d                   	pop    %rbp
    8e46:	20 4e 6f             	and    %cl,0x6f(%rsi)
    8e49:	74 20                	je     8e6b <load_idt+0x763>
    8e4b:	73 75                	jae    8ec2 <load_idt+0x7ba>
    8e4d:	72 65                	jb     8eb4 <load_idt+0x7ac>
    8e4f:	20 77 68             	and    %dh,0x68(%rdi)
    8e52:	61                   	(bad)  
    8e53:	74 20                	je     8e75 <load_idt+0x76d>
    8e55:	74 6f                	je     8ec6 <load_idt+0x7be>
    8e57:	20 64 6f 20          	and    %ah,0x20(%rdi,%rbp,2)
    8e5b:	77 69                	ja     8ec6 <load_idt+0x7be>
    8e5d:	74 68                	je     8ec7 <load_idt+0x7bf>
    8e5f:	20 25 73 2e 20 28    	and    %ah,0x28202e73(%rip)        # 2820bcd8 <kernel_main+0x27204779>
    8e65:	25 4d 20 25 49       	and    $0x4925204d,%eax
    8e6a:	29 20                	sub    %esp,(%rax)
    8e6c:	28 25 4d 20 25 49    	sub    %ah,0x4925204d(%rip)        # 4925aebf <kernel_main+0x48253960>
    8e72:	29 0d 0a 00 25 30    	sub    %ecx,0x3025000a(%rip)        # 30258e82 <kernel_main+0x2f251923>
    8e78:	31 36                	xor    %esi,(%rsi)
    8e7a:	78 20                	js     8e9c <load_idt+0x794>
    8e7c:	25 30 31 36 78       	and    $0x78363130,%eax
    8e81:	20 25 30 31 36 78    	and    %ah,0x78363130(%rip)        # 7836bfb7 <kernel_main+0x77364a58>
    8e87:	20 25 30 31 36 78    	and    %ah,0x78363130(%rip)        # 7836bfbd <kernel_main+0x77364a5e>
    8e8d:	0d 0a 00 41 6c       	or     $0x6c41000a,%eax
    8e92:	69 67 6e 6d 65 6e 74 	imul   $0x746e656d,0x6e(%rdi),%esp
    8e99:	20 63 68             	and    %ah,0x68(%rbx)
    8e9c:	65 63 6b 00          	movsxd %gs:0x0(%rbx),%ebp
    8ea0:	4d 61                	rex.WRB (bad) 
    8ea2:	63 68 69             	movsxd 0x69(%rax),%ebp
    8ea5:	6e                   	outsb  %ds:(%rsi),(%dx)
    8ea6:	65 20 63 68          	and    %ah,%gs:0x68(%rbx)
    8eaa:	65 63 6b 00          	movsxd %gs:0x0(%rbx),%ebp
    8eae:	65 31 30             	xor    %esi,%gs:(%rax)
    8eb1:	30 30                	xor    %dh,(%rax)
    8eb3:	65 20 6e 65          	and    %ch,%gs:0x65(%rsi)
    8eb7:	74 77                	je     8f30 <load_idt+0x828>
    8eb9:	6f                   	outsl  %ds:(%rsi),(%dx)
    8eba:	72 6b                	jb     8f27 <load_idt+0x81f>
    8ebc:	20 63 61             	and    %ah,0x61(%rbx)
    8ebf:	72 64                	jb     8f25 <load_idt+0x81d>
    8ec1:	20 69 6e             	and    %ch,0x6e(%rcx)
    8ec4:	69 74 69 61 6c 69 7a 	imul   $0x657a696c,0x61(%rcx,%rbp,2),%esi
    8ecb:	65 
    8ecc:	64 2e 0d 0a 0a 00 52 	fs cs or $0x52000a0a,%eax
    8ed3:	58                   	pop    %rax
    8ed4:	4f 0d 0a 00 47 45    	rex.WRXB or $0x4547000a,%rax
    8eda:	54                   	push   %rsp
    8edb:	20 2f                	and    %ch,(%rdi)
    8edd:	69 6e 64 65 78 2e 68 	imul   $0x682e7865,0x64(%rsi),%ebp
    8ee4:	74 6d                	je     8f53 <load_idt+0x84b>
    8ee6:	6c                   	insb   (%dx),%es:(%rdi)
    8ee7:	20 48 54             	and    %cl,0x54(%rax)
    8eea:	54                   	push   %rsp
    8eeb:	50                   	push   %rax
    8eec:	2f                   	(bad)  
    8eed:	31 2e                	xor    %ebp,(%rsi)
    8eef:	31 00                	xor    %eax,(%rax)
    8ef1:	5b                   	pop    %rbx
    8ef2:	41 52                	push   %r10
    8ef4:	50                   	push   %rax
    8ef5:	5d                   	pop    %rbp
    8ef6:	20 52 65             	and    %dl,0x65(%rdx)
    8ef9:	73 70                	jae    8f6b <load_idt+0x863>
    8efb:	6f                   	outsl  %ds:(%rsi),(%dx)
    8efc:	6e                   	outsb  %ds:(%rsi),(%dx)
    8efd:	64 69 6e 67 20 74 6f 	imul   $0x206f7420,%fs:0x67(%rsi),%ebp
    8f04:	20 
    8f05:	25 49 3a 20 25       	and    $0x25203a49,%eax
    8f0a:	49 20 69 73          	rex.WB and %bpl,0x73(%r9)
    8f0e:	20 25 4d 2e 0d 0a    	and    %ah,0xa0d2e4d(%rip)        # a0dbd61 <kernel_main+0x90d4802>
    8f14:	00 49 50             	add    %cl,0x50(%rcx)
    8f17:	3a 20                	cmp    (%rax),%ah
    8f19:	25 30 32 78 3a       	and    $0x3a783230,%eax
    8f1e:	25 30 31 36 78       	and    $0x78363130,%eax
    8f23:	0d 0a 00 45 45       	or     $0x4545000a,%eax
    8f28:	50                   	push   %rax
    8f29:	52                   	push   %rdx
    8f2a:	4f                   	rex.WRXB
    8f2b:	4d 20 52 65          	rex.WRB and %r10b,0x65(%r10)
    8f2f:	61                   	(bad)  
    8f30:	64 20 45 72          	and    %al,%fs:0x72(%rbp)
    8f34:	72 6f                	jb     8fa5 <load_idt+0x89d>
    8f36:	72 3a                	jb     8f72 <load_idt+0x86a>
    8f38:	20 25 30 38 78 20    	and    %ah,0x20783830(%rip)        # 2078c76e <kernel_main+0x1f78520f>
    8f3e:	25 30 38 78 0d       	and    $0xd783830,%eax
    8f43:	0a 00                	or     (%rax),%al
    8f45:	44 6f                	rex.R outsl %ds:(%rsi),(%dx)
    8f47:	75 62                	jne    8fab <load_idt+0x8a3>
    8f49:	6c                   	insb   (%dx),%es:(%rdi)
    8f4a:	65 20 66 61          	and    %ah,%gs:0x61(%rsi)
    8f4e:	75 6c                	jne    8fbc <load_idt+0x8b4>
    8f50:	74 00                	je     8f52 <load_idt+0x84a>
    8f52:	44 69 73 6b 20 72 65 	imul   $0x61657220,0x6b(%rbx),%r14d
    8f59:	61 
    8f5a:	64 20 65 72          	and    %ah,%fs:0x72(%rbp)
    8f5e:	72 6f                	jb     8fcf <load_idt+0x8c7>
    8f60:	72 21                	jb     8f83 <load_idt+0x87b>
    8f62:	0d 0a 00 30 31       	or     $0x3130000a,%eax
    8f67:	32 33                	xor    (%rbx),%dh
    8f69:	34 35                	xor    $0x35,%al
    8f6b:	36 37                	ss (bad) 
    8f6d:	38 39                	cmp    %bh,(%rcx)
    8f6f:	61                   	(bad)  
    8f70:	62 63 64 65 66       	(bad)
    8f75:	00 5b 41             	add    %bl,0x41(%rbx)
    8f78:	52                   	push   %rdx
    8f79:	50                   	push   %rax
    8f7a:	5d                   	pop    %rbp
    8f7b:	20 41 6e             	and    %al,0x6e(%rcx)
    8f7e:	6e                   	outsb  %ds:(%rsi),(%dx)
    8f7f:	6f                   	outsl  %ds:(%rsi),(%dx)
    8f80:	75 6e                	jne    8ff0 <load_idt+0x8e8>
    8f82:	63 65 6d             	movsxd 0x6d(%rbp),%esp
    8f85:	65 6e                	outsb  %gs:(%rsi),(%dx)
    8f87:	74 3a                	je     8fc3 <load_idt+0x8bb>
    8f89:	20 25 49 20 62 65    	and    %ah,0x65622049(%rip)        # 6562afd8 <kernel_main+0x64623a79>
    8f8f:	6c                   	insb   (%dx),%es:(%rdi)
    8f90:	6f                   	outsl  %ds:(%rsi),(%dx)
    8f91:	6e                   	outsb  %ds:(%rsi),(%dx)
    8f92:	67 73 20             	addr32 jae 8fb5 <load_idt+0x8ad>
    8f95:	74 6f                	je     9006 <load_idt+0x8fe>
    8f97:	20 25 4d 2e 0d 0a    	and    %ah,0xa0d2e4d(%rip)        # a0dbdea <kernel_main+0x90d488b>
    8f9d:	00 5b 41             	add    %bl,0x41(%rbx)
    8fa0:	52                   	push   %rdx
    8fa1:	50                   	push   %rax
    8fa2:	5d                   	pop    %rbp
    8fa3:	20 25 4d 20 77 61    	and    %ah,0x6177204d(%rip)        # 6177aff6 <kernel_main+0x60773a97>
    8fa9:	6e                   	outsb  %ds:(%rsi),(%dx)
    8faa:	74 73                	je     901f <load_idt+0x917>
    8fac:	20 74 6f 20          	and    %dh,0x20(%rdi,%rbp,2)
    8fb0:	6b 6e 6f 77          	imul   $0x77,0x6f(%rsi),%ebp
    8fb4:	3a 20                	cmp    (%rax),%ah
    8fb6:	49 73 20             	rex.WB jae 8fd9 <load_idt+0x8d1>
    8fb9:	25 49 20 61 76       	and    $0x76612049,%eax
    8fbe:	61                   	(bad)  
    8fbf:	69 6c 61 62 6c 65 3f 	imul   $0xd3f656c,0x62(%rcx,%riz,2),%ebp
    8fc6:	0d 
    8fc7:	0a 00                	or     (%rax),%al
    8fc9:	5b                   	pop    %rbx
    8fca:	54                   	push   %rsp
    8fcb:	43 50                	rex.XB push %r8
    8fcd:	5d                   	pop    %rbp
    8fce:	20 43 6c             	and    %al,0x6c(%rbx)
    8fd1:	6f                   	outsl  %ds:(%rsi),(%dx)
    8fd2:	73 69                	jae    903d <load_idt+0x935>
    8fd4:	6e                   	outsb  %ds:(%rsi),(%dx)
    8fd5:	67 20 63 6f          	and    %ah,0x6f(%ebx)
    8fd9:	6e                   	outsb  %ds:(%rsi),(%dx)
    8fda:	6e                   	outsb  %ds:(%rsi),(%dx)
    8fdb:	65 63 74 69 6f       	movsxd %gs:0x6f(%rcx,%rbp,2),%esi
    8fe0:	6e                   	outsb  %ds:(%rsi),(%dx)
    8fe1:	20 77 69             	and    %dh,0x69(%rdi)
    8fe4:	74 68                	je     904e <load_idt+0x946>
    8fe6:	20 25 49 3a 25 69    	and    %ah,0x69253a49(%rip)        # 6925ca35 <kernel_main+0x682554d6>
    8fec:	2e 0d 0a 00 3c 21    	cs or  $0x213c000a,%eax
    8ff2:	44                   	rex.R
    8ff3:	4f                   	rex.WRXB
    8ff4:	43 54                	rex.XB push %r12
    8ff6:	59                   	pop    %rcx
    8ff7:	50                   	push   %rax
    8ff8:	45 20 68 74          	and    %r13b,0x74(%r8)
    8ffc:	6d                   	insl   (%dx),%es:(%rdi)
    8ffd:	6c                   	insb   (%dx),%es:(%rdi)
    8ffe:	3e 3c 68             	ds cmp $0x68,%al
    9001:	65 61                	gs (bad) 
    9003:	64 3e 3c 74          	fs ds cmp $0x74,%al
    9007:	69 74 6c 65 3e 53 75 	imul   $0x7075533e,0x65(%rsp,%rbp,2),%esi
    900e:	70 
    900f:	65 72 20             	gs jb  9032 <load_idt+0x92a>
    9012:	43 6f                	rex.XB outsl %ds:(%rsi),(%dx)
    9014:	6f                   	outsl  %ds:(%rsi),(%dx)
    9015:	6c                   	insb   (%dx),%es:(%rdi)
    9016:	20 57 65             	and    %dl,0x65(%rdi)
    9019:	62 73                	(bad)  
    901b:	69 74 65 3c 2f 74 69 	imul   $0x7469742f,0x3c(%rbp,%riz,2),%esi
    9022:	74 
    9023:	6c                   	insb   (%dx),%es:(%rdi)
    9024:	65 3e 3c 2f          	gs ds cmp $0x2f,%al
    9028:	68 65 61 64 3e       	push   $0x3e646165
    902d:	3c 62                	cmp    $0x62,%al
    902f:	6f                   	outsl  %ds:(%rsi),(%dx)
    9030:	64 79 3e             	fs jns 9071 <load_idt+0x969>
    9033:	3c 68                	cmp    $0x68,%al
    9035:	31 3e                	xor    %edi,(%rsi)
    9037:	42 69 67 20 74 65 78 	rex.X imul $0x74786574,0x20(%rdi),%esp
    903e:	74 
    903f:	21 3c 2f             	and    %edi,(%rdi,%rbp,1)
    9042:	68 31 3e 3c 70       	push   $0x703c3e31
    9047:	3e 3c 69             	ds cmp $0x69,%al
    904a:	3e 69 74 61 6c 69 63 	ds imul $0x21736369,0x6c(%rcx,%riz,2),%esi
    9051:	73 21 
    9053:	3c 2f                	cmp    $0x2f,%al
    9055:	69 3e 3c 2f 70 3e    	imul   $0x3e702f3c,(%rsi),%edi
    905b:	3c 70                	cmp    $0x70,%al
    905d:	3e 3c 61             	ds cmp $0x61,%al
    9060:	20 68 72             	and    %ch,0x72(%rax)
    9063:	65 66 3d 22 68       	gs cmp $0x6822,%ax
    9068:	74 74                	je     90de <load_idt+0x9d6>
    906a:	70 73                	jo     90df <load_idt+0x9d7>
    906c:	3a 2f                	cmp    (%rdi),%ch
    906e:	2f                   	(bad)  
    906f:	70 75                	jo     90e6 <load_idt+0x9de>
    9071:	64 79 32             	fs jns 90a6 <load_idt+0x99e>
    9074:	34 38                	xor    $0x38,%al
    9076:	2e 67 69 74 68 75 62 	cs imul $0x6f692e62,0x75(%eax,%ebp,2),%esi
    907d:	2e 69 6f 
    9080:	2f                   	(bad)  
    9081:	6e                   	outsb  %ds:(%rsi),(%dx)
    9082:	6f                   	outsl  %ds:(%rsi),(%dx)
    9083:	69 74 61 57 61 6e 64 	imul   $0x41646e61,0x57(%rcx,%riz,2),%esi
    908a:	41 
    908b:	74 6c                	je     90f9 <load_idt+0x9f1>
    908d:	61                   	(bad)  
    908e:	73 22                	jae    90b2 <load_idt+0x9aa>
    9090:	3e 6c                	ds insb (%dx),%es:(%rdi)
    9092:	69 6e 6b 73 21 3c 2f 	imul   $0x2f3c2173,0x6b(%rsi),%ebp
    9099:	61                   	(bad)  
    909a:	3e 3c 2f             	ds cmp $0x2f,%al
    909d:	70 3e                	jo     90dd <load_idt+0x9d5>
    909f:	3c 70                	cmp    $0x70,%al
    90a1:	3e 4d 6f             	rex.WRB outsl %ds:(%rsi),(%dx)
    90a4:	72 65                	jb     910b <load_idt+0xa03>
    90a6:	20 70 65             	and    %dh,0x65(%rax)
    90a9:	6e                   	outsb  %ds:(%rsi),(%dx)
    90aa:	64 69 6e 67 3f 3c 2f 	imul   $0x702f3c3f,%fs:0x67(%rsi),%ebp
    90b1:	70 
    90b2:	3e 3c 2f             	ds cmp $0x2f,%al
    90b5:	62                   	(bad)  
    90b6:	6f                   	outsl  %ds:(%rsi),(%dx)
    90b7:	64 79 3e             	fs jns 90f8 <load_idt+0x9f0>
    90ba:	00 47 45             	add    %al,0x45(%rdi)
    90bd:	54                   	push   %rsp
    90be:	00 44 65 62          	add    %al,0x62(%rbp,%riz,2)
    90c2:	75 67                	jne    912b <load_idt+0xa23>
    90c4:	00 28                	add    %ch,(%rax)
    90c6:	25 69 3a 25 69       	and    $0x69253a69,%eax
    90cb:	3a 25 69 29 20 64    	cmp    0x64202969(%rip),%ah        # 6420ba3a <kernel_main+0x632044db>
    90d1:	65 76 3a             	gs jbe 910e <load_idt+0xa06>
    90d4:	25 30 34 78 20       	and    $0x20783430,%eax
    90d9:	76 65                	jbe    9140 <load_idt+0xa38>
    90db:	6e                   	outsb  %ds:(%rsi),(%dx)
    90dc:	64 6f                	outsl  %fs:(%rsi),(%dx)
    90de:	72 3a                	jb     911a <load_idt+0xa12>
    90e0:	25 30 34 78 20       	and    $0x20783430,%eax
    90e5:	63 6c 61 73          	movsxd 0x73(%rcx,%riz,2),%ebp
    90e9:	73 20                	jae    910b <load_idt+0xa03>
    90eb:	25 30 32 78 3a       	and    $0x3a783230,%eax
    90f0:	25 30 32 78 3a       	and    $0x3a783230,%eax
    90f5:	25 30 32 78 3a       	and    $0x3a783230,%eax
    90fa:	25 30 32 78 0d       	and    $0xd783230,%eax
    90ff:	0a 00                	or     (%rax),%al
    9101:	5b                   	pop    %rbx
    9102:	54                   	push   %rsp
    9103:	43 50                	rex.XB push %r8
    9105:	5d                   	pop    %rbp
    9106:	20 50 53             	and    %dl,0x53(%rax)
    9109:	48 20 72 65          	rex.W and %sil,0x65(%rdx)
    910d:	63 69 65             	movsxd 0x65(%rcx),%ebp
    9110:	76 65                	jbe    9177 <_ZL10exceptions+0x17>
    9112:	64 20 64 75 72       	and    %ah,%fs:0x72(%rbp,%rsi,2)
    9117:	69 6e 67 20 69 6e 76 	imul   $0x766e6920,0x67(%rsi),%ebp
    911e:	61                   	(bad)  
    911f:	6c                   	insb   (%dx),%es:(%rdi)
    9120:	69 64 20 73 74 61 74 	imul   $0x65746174,0x73(%rax,%riz,1),%esp
    9127:	65 
    9128:	20 25 69 2e 0d 0a    	and    %ah,0xa0d2e69(%rip)        # a0dbf97 <kernel_main+0x90d4a38>
    912e:	00 5b 54             	add    %bl,0x54(%rbx)
    9131:	43 50                	rex.XB push %r8
    9133:	5d                   	pop    %rbp
    9134:	20 52 65             	and    %dl,0x65(%rdx)
    9137:	63 69 65             	movsxd 0x65(%rcx),%ebp
    913a:	76 65                	jbe    91a1 <_ZL10exceptions+0x41>
    913c:	64 20 25 69 20 28 25 	and    %ah,%fs:0x25282069(%rip)        # 2528b1ac <kernel_main+0x24283c4d>
    9143:	69 29 20 62 79 74    	imul   $0x74796220,(%rcx),%ebp
    9149:	65 73 20             	gs jae 916c <_ZL10exceptions+0xc>
    914c:	6f                   	outsl  %ds:(%rsi),(%dx)
    914d:	66 20 64 61 74       	data16 and %ah,0x74(%rcx,%riz,2)
    9152:	61                   	(bad)  
    9153:	20 28                	and    %ch,(%rax)
    9155:	25 49 3a 25 69       	and    $0x69253a49,%eax
    915a:	29 2e                	sub    %ebp,(%rsi)
    915c:	0d                   	.byte 0xd
    915d:	0a 00                	or     (%rax),%al
    915f:	90                   	nop

0000000000009160 <_ZL10exceptions>:
    9160:	02 8e 00 00 00 00 00 00 bf 90 00 00 00 00 00 00     ................
    9170:	50 89 00 00 00 00 00 00 ed 8a 00 00 00 00 00 00     P...............
    9180:	d0 89 00 00 00 00 00 00 46 8c 00 00 00 00 00 00     ........F.......
    9190:	ac 8a 00 00 00 00 00 00 5b 8b 00 00 00 00 00 00     ........[.......
    91a0:	45 8f 00 00 00 00 00 00 ed 89 00 00 00 00 00 00     E...............
    91b0:	d9 8d 00 00 00 00 00 00 09 8a 00 00 00 00 00 00     ................
    91c0:	ca 8a 00 00 00 00 00 00 6a 8b 00 00 00 00 00 00     ........j.......
    91d0:	e1 8d 00 00 00 00 00 00 d6 8a 00 00 00 00 00 00     ................
    91e0:	ec 8d 00 00 00 00 00 00 90 8e 00 00 00 00 00 00     ................
    91f0:	a0 8e 00 00 00 00 00 00                             ........

00000000000091f8 <pci_dev>:
	...

0000000000009200 <_ZL17sectorsPerCluster>:
    9200:	00 00 66 90                                         ..f.

0000000000009204 <_ZL15firstClusterLBA>:
    9204:	00 00 00 00                                         ....

0000000000009208 <_ZL15bytesPerCluster>:
    9208:	00 00 66 90                                         ..f.

000000000000920c <_ZL16firstClusterAddr>:
    920c:	00 00 00 00                                         ....

0000000000009210 <_ZL8fatTable>:
	...

0000000000009218 <idtptr>:
	...

0000000000009220 <_ZL19reference_timepoint>:
	...

Disassembly of section .text.stage2_main:

000000000000922c <stage2_main>:
    922c:	55                   	push   %rbp
    922d:	41 57                	push   %r15
    922f:	41 56                	push   %r14
    9231:	41 54                	push   %r12
    9233:	53                   	push   %rbx
    9234:	48 81 ec 00 0b 00 00 	sub    $0xb00,%rsp
    923b:	e8 c8 15 00 00       	call   a808 <_Z8mem_initv>
    9240:	48 8d 9c 24 00 01 00 	lea    0x100(%rsp),%rbx
    9247:	00 
    9248:	48 89 df             	mov    %rbx,%rdi
    924b:	e8 68 14 00 00       	call   a6b8 <_ZN7consoleC1Ev>
    9250:	c5 fd 10 03          	vmovupd (%rbx),%ymm0
    9254:	c5 fd 11 04 25 00 00 	vmovupd %ymm0,0x110000
    925b:	11 00 
    925d:	c5 f8 77             	vzeroupper 
    9260:	e8 df 23 00 00       	call   b644 <_Z8idt_initv>
    9265:	e8 de 28 00 00       	call   bb48 <_Z8pic_initv>
    926a:	be 54 b7 00 00       	mov    $0xb754,%esi
    926f:	31 ff                	xor    %edi,%edi
    9271:	e8 00 0e 00 00       	call   a076 <_Z7irq_sethPFvvE>
    9276:	e8 4c 26 00 00       	call   b8c7 <_Z9time_initv>
    927b:	bd 0a 00 00 00       	mov    $0xa,%ebp
    9280:	4c 8d b4 24 f0 00 00 	lea    0xf0(%rsp),%r14
    9287:	00 
    9288:	48 89 df             	mov    %rbx,%rdi
    928b:	e8 d8 27 00 00       	call   ba68 <_ZN9timepointC1Ev>
    9290:	48 89 df             	mov    %rbx,%rdi
    9293:	e8 44 28 00 00       	call   badc <_ZN9timepoint12unix_secondsEv>
    9298:	c5 fb 11 44 24 50    	vmovsd %xmm0,0x50(%rsp)
    929e:	0f 31                	rdtsc  
    92a0:	41 89 d7             	mov    %edx,%r15d
    92a3:	41 f7 df             	neg    %r15d
    92a6:	49 c1 e7 20          	shl    $0x20,%r15
    92aa:	41 89 c4             	mov    %eax,%r12d
    92ad:	bf 00 00 00 01       	mov    $0x1000000,%edi
    92b2:	e8 6e 28 00 00       	call   bb25 <_Z9tsc_delaym>
    92b7:	48 89 df             	mov    %rbx,%rdi
    92ba:	e8 a9 27 00 00       	call   ba68 <_ZN9timepointC1Ev>
    92bf:	48 89 df             	mov    %rbx,%rdi
    92c2:	e8 15 28 00 00       	call   badc <_ZN9timepoint12unix_secondsEv>
    92c7:	0f 31                	rdtsc  
    92c9:	48 c1 e2 20          	shl    $0x20,%rdx
    92cd:	89 c0                	mov    %eax,%eax
    92cf:	48 01 d0             	add    %rdx,%rax
    92d2:	4d 29 e7             	sub    %r12,%r15
    92d5:	49 01 c7             	add    %rax,%r15
    92d8:	c4 c1 f9 6e cf       	vmovq  %r15,%xmm1
    92dd:	c5 f1 62 0d 3b f4 ff 	vpunpckldq -0xbc5(%rip),%xmm1,%xmm1        # 8720 <load_idt+0x18>
    92e4:	ff 
    92e5:	c5 f1 5c 0d 43 f4 ff 	vsubpd -0xbbd(%rip),%xmm1,%xmm1        # 8730 <load_idt+0x28>
    92ec:	ff 
    92ed:	c5 f1 7c c9          	vhaddpd %xmm1,%xmm1,%xmm1
    92f1:	c5 fb 5c 44 24 50    	vsubsd 0x50(%rsp),%xmm0,%xmm0
    92f7:	c5 fb 11 44 24 50    	vmovsd %xmm0,0x50(%rsp)
    92fd:	c5 f3 5e c0          	vdivsd %xmm0,%xmm1,%xmm0
    9301:	c5 fb 10 0d 37 f4 ff 	vmovsd -0xbc9(%rip),%xmm1        # 8740 <load_idt+0x38>
    9308:	ff 
    9309:	c5 fb 5e c1          	vdivsd %xmm1,%xmm0,%xmm0
    930d:	c5 fb 11 44 24 58    	vmovsd %xmm0,0x58(%rsp)
    9313:	be 81 88 00 00       	mov    $0x8881,%esi
    9318:	4c 89 f7             	mov    %r14,%rdi
    931b:	ba 1c 00 00 00       	mov    $0x1c,%edx
    9320:	31 c9                	xor    %ecx,%ecx
    9322:	e8 c1 15 00 00       	call   a8e8 <_ZN8rostringC1EPKcii>
    9327:	c4 e1 fb 2c 54 24 58 	vcvttsd2si 0x58(%rsp),%rdx
    932e:	c5 fb 10 05 0a f4 ff 	vmovsd -0xbf6(%rip),%xmm0        # 8740 <load_idt+0x38>
    9335:	ff 
    9336:	c5 fb 59 44 24 50    	vmulsd 0x50(%rsp),%xmm0,%xmm0
    933c:	c4 61 fb 2c c0       	vcvttsd2si %xmm0,%r8
    9341:	48 89 df             	mov    %rbx,%rdi
    9344:	4c 89 f6             	mov    %r14,%rsi
    9347:	4c 89 f9             	mov    %r15,%rcx
    934a:	31 c0                	xor    %eax,%eax
    934c:	e8 2e 05 00 00       	call   987f <_Z6format8rostringz>
    9351:	48 89 df             	mov    %rbx,%rdi
    9354:	e8 dd 0b 00 00       	call   9f36 <_ZN6string10c_str_thisEv>
    9359:	bf 00 00 11 00       	mov    $0x110000,%edi
    935e:	48 89 c6             	mov    %rax,%rsi
    9361:	e8 ea 04 00 00       	call   9850 <_ZN7console6putstrEPKc>
    9366:	48 8b bc 24 00 01 00 	mov    0x100(%rsp),%rdi
    936d:	00 
    936e:	48 85 ff             	test   %rdi,%rdi
    9371:	74 05                	je     9378 <stage2_main+0x14c>
    9373:	e8 3c 15 00 00       	call   a8b4 <_ZdaPv>
    9378:	ff cd                	dec    %ebp
    937a:	0f 85 08 ff ff ff    	jne    9288 <stage2_main+0x5c>
    9380:	e8 e5 0d 00 00       	call   a16a <_Z8pci_initv>
    9385:	bf 01 00 00 00       	mov    $0x1,%edi
    938a:	be 06 00 00 00       	mov    $0x6,%esi
    938f:	ba ff 00 00 00       	mov    $0xff,%edx
    9394:	e8 41 0f 00 00       	call   a2da <_Z9pci_matchhhh>
    9399:	48 85 c0             	test   %rax,%rax
    939c:	0f 84 d9 00 00 00    	je     947b <stage2_main+0x24f>
    93a2:	48 89 c3             	mov    %rax,%rbx
    93a5:	4c 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%r14
    93ac:	00 
    93ad:	be 67 87 00 00       	mov    $0x8767,%esi
    93b2:	4c 89 f7             	mov    %r14,%rdi
    93b5:	ba 21 00 00 00       	mov    $0x21,%edx
    93ba:	31 c9                	xor    %ecx,%ecx
    93bc:	e8 27 15 00 00       	call   a8e8 <_ZN8rostringC1EPKcii>
    93c1:	0f b7 53 04          	movzwl 0x4(%rbx),%edx
    93c5:	0f b7 4b 06          	movzwl 0x6(%rbx),%ecx
    93c9:	4c 8d bc 24 00 01 00 	lea    0x100(%rsp),%r15
    93d0:	00 
    93d1:	4c 89 ff             	mov    %r15,%rdi
    93d4:	4c 89 f6             	mov    %r14,%rsi
    93d7:	31 c0                	xor    %eax,%eax
    93d9:	e8 a1 04 00 00       	call   987f <_Z6format8rostringz>
    93de:	4c 89 ff             	mov    %r15,%rdi
    93e1:	e8 50 0b 00 00       	call   9f36 <_ZN6string10c_str_thisEv>
    93e6:	bf 00 00 11 00       	mov    $0x110000,%edi
    93eb:	48 89 c6             	mov    %rax,%rsi
    93ee:	e8 5d 04 00 00       	call   9850 <_ZN7console6putstrEPKc>
    93f3:	49 8b 3f             	mov    (%r15),%rdi
    93f6:	48 85 ff             	test   %rdi,%rdi
    93f9:	74 05                	je     9400 <stage2_main+0x1d4>
    93fb:	e8 b4 14 00 00       	call   a8b4 <_ZdaPv>
    9400:	41 be be 7d 00 00    	mov    $0x7dbe,%r14d
    9406:	c5 fc 10 03          	vmovups (%rbx),%ymm0
    940a:	c5 fc 10 4b 10       	vmovups 0x10(%rbx),%ymm1
    940f:	c5 fc 11 84 24 b0 00 	vmovups %ymm0,0xb0(%rsp)
    9416:	00 00 
    9418:	c5 fc 11 8c 24 c0 00 	vmovups %ymm1,0xc0(%rsp)
    941f:	00 00 
    9421:	c5 fc 10 84 24 b0 00 	vmovups 0xb0(%rsp),%ymm0
    9428:	00 00 
    942a:	c5 fc 10 8c 24 c0 00 	vmovups 0xc0(%rsp),%ymm1
    9431:	00 00 
    9433:	c5 fc 11 4c 24 10    	vmovups %ymm1,0x10(%rsp)
    9439:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    943e:	c5 f8 77             	vzeroupper 
    9441:	e8 74 02 00 00       	call   96ba <_Z9ahci_init10pci_device>
    9446:	bf 00 00 11 00       	mov    $0x110000,%edi
    944b:	be 89 87 00 00       	mov    $0x8789,%esi
    9450:	e8 fb 03 00 00       	call   9850 <_ZN7console6putstrEPKc>
    9455:	45 31 ff             	xor    %r15d,%r15d
    9458:	43 80 7c 3e 04 0c    	cmpb   $0xc,0x4(%r14,%r15,1)
    945e:	74 2c                	je     948c <stage2_main+0x260>
    9460:	49 83 c7 10          	add    $0x10,%r15
    9464:	49 83 ff 40          	cmp    $0x40,%r15
    9468:	75 ee                	jne    9458 <stage2_main+0x22c>
    946a:	bf 00 00 11 00       	mov    $0x110000,%edi
    946f:	be a6 87 00 00       	mov    $0x87a6,%esi
    9474:	e8 d7 03 00 00       	call   9850 <_ZN7console6putstrEPKc>
    9479:	eb fe                	jmp    9479 <stage2_main+0x24d>
    947b:	bf 00 00 11 00       	mov    $0x110000,%edi
    9480:	be 48 87 00 00       	mov    $0x8748,%esi
    9485:	e8 c6 03 00 00       	call   9850 <_ZN7console6putstrEPKc>
    948a:	eb fe                	jmp    948a <stage2_main+0x25e>
    948c:	bf 00 00 11 00       	mov    $0x110000,%edi
    9491:	be c6 87 00 00       	mov    $0x87c6,%esi
    9496:	e8 b5 03 00 00       	call   9850 <_ZN7console6putstrEPKc>
    949b:	43 8b 74 3e 08       	mov    0x8(%r14,%r15,1),%esi
    94a0:	bf 00 00 00 01       	mov    $0x1000000,%edi
    94a5:	ba 01 00 00 00       	mov    $0x1,%edx
    94aa:	e8 92 0b 00 00       	call   a041 <_Z9read_diskPvjt>
    94af:	80 3c 25 42 00 00 01 	cmpb   $0x29,0x1000042
    94b6:	29 
    94b7:	0f 85 33 01 00 00    	jne    95f0 <stage2_main+0x3c4>
    94bd:	4b 8d 1c 3e          	lea    (%r14,%r15,1),%rbx
    94c1:	bf 00 00 11 00       	mov    $0x110000,%edi
    94c6:	be 1d 88 00 00       	mov    $0x881d,%esi
    94cb:	e8 80 03 00 00       	call   9850 <_ZN7console6putstrEPKc>
    94d0:	43 8b 74 3e 08       	mov    0x8(%r14,%r15,1),%esi
    94d5:	ff c6                	inc    %esi
    94d7:	0f b7 04 25 0e 00 00 	movzwl 0x100000e,%eax
    94de:	01 
    94df:	0f b6 0c 25 10 00 00 	movzbl 0x1000010,%ecx
    94e6:	01 
    94e7:	0f af 0c 25 24 00 00 	imul   0x1000024,%ecx
    94ee:	01 
    94ef:	01 c8                	add    %ecx,%eax
    94f1:	ff c8                	dec    %eax
    94f3:	0f b7 d0             	movzwl %ax,%edx
    94f6:	bf 00 02 00 01       	mov    $0x1000200,%edi
    94fb:	e8 41 0b 00 00       	call   a041 <_Z9read_diskPvjt>
    9500:	be 00 00 00 01       	mov    $0x1000000,%esi
    9505:	48 89 df             	mov    %rbx,%rdi
    9508:	e8 24 0e 00 00       	call   a331 <_Z8fat_initP15partition_entryP9fat32_bpb>
    950d:	bf 00 00 11 00       	mov    $0x110000,%edi
    9512:	be 35 88 00 00       	mov    $0x8835,%esi
    9517:	e8 34 03 00 00       	call   9850 <_ZN7console6putstrEPKc>
    951c:	8b 3c 25 2c 00 00 01 	mov    0x100002c,%edi
    9523:	e8 53 0e 00 00       	call   a37b <_Z16get_cluster_addrj>
    9528:	48 89 c3             	mov    %rax,%rbx
    952b:	8b 34 25 2c 00 00 01 	mov    0x100002c,%esi
    9532:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
    9537:	48 89 c7             	mov    %rax,%rdi
    953a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
    953f:	e8 4b 0e 00 00       	call   a38f <_Z18read_cluster_chainPvjj>
    9544:	bf 00 00 11 00       	mov    $0x110000,%edi
    9549:	be 51 88 00 00       	mov    $0x8851,%esi
    954e:	e8 fd 02 00 00       	call   9850 <_ZN7console6putstrEPKc>
    9553:	c5 fc 10 05 45 f3 ff 	vmovups -0xcbb(%rip),%ymm0        # 88a0 <load_idt+0x198>
    955a:	ff 
    955b:	c5 fc 11 44 24 60    	vmovups %ymm0,0x60(%rsp)
    9561:	c5 fc 10 05 57 f3 ff 	vmovups -0xca9(%rip),%ymm0        # 88c0 <load_idt+0x1b8>
    9568:	ff 
    9569:	c5 fc 11 84 24 80 00 	vmovups %ymm0,0x80(%rsp)
    9570:	00 00 
    9572:	48 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%rsp)
    9579:	00 00 00 00 00 
    957e:	48 89 9c 24 a8 00 00 	mov    %rbx,0xa8(%rsp)
    9585:	00 
    9586:	c5 fc 10 44 24 60    	vmovups 0x60(%rsp),%ymm0
    958c:	c5 fc 10 8c 24 80 00 	vmovups 0x80(%rsp),%ymm1
    9593:	00 00 
    9595:	c5 fc 10 94 24 90 00 	vmovups 0x90(%rsp),%ymm2
    959c:	00 00 
    959e:	c5 fc 11 54 24 30    	vmovups %ymm2,0x30(%rsp)
    95a4:	c5 fc 11 4c 24 20    	vmovups %ymm1,0x20(%rsp)
    95aa:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    95af:	48 8d 9c 24 00 01 00 	lea    0x100(%rsp),%rbx
    95b6:	00 
    95b7:	48 89 df             	mov    %rbx,%rdi
    95ba:	c5 f8 77             	vzeroupper 
    95bd:	e8 4e 10 00 00       	call   a610 <_Z8enum_dir8fat_filePS_>
    95c2:	85 c0                	test   %eax,%eax
    95c4:	7e 59                	jle    961f <stage2_main+0x3f3>
    95c6:	41 89 c6             	mov    %eax,%r14d
    95c9:	45 31 ff             	xor    %r15d,%r15d
    95cc:	be 76 88 00 00       	mov    $0x8876,%esi
    95d1:	48 89 df             	mov    %rbx,%rdi
    95d4:	e8 bd 10 00 00       	call   a696 <_Z6streqlPKcS0_>
    95d9:	84 c0                	test   %al,%al
    95db:	41 0f 45 ef          	cmovne %r15d,%ebp
    95df:	49 ff c7             	inc    %r15
    95e2:	48 83 c3 50          	add    $0x50,%rbx
    95e6:	4d 39 fe             	cmp    %r15,%r14
    95e9:	75 e1                	jne    95cc <stage2_main+0x3a0>
    95eb:	48 63 c5             	movslq %ebp,%rax
    95ee:	eb 36                	jmp    9626 <stage2_main+0x3fa>
    95f0:	bf 00 00 11 00       	mov    $0x110000,%edi
    95f5:	be e4 87 00 00       	mov    $0x87e4,%esi
    95fa:	e8 51 02 00 00       	call   9850 <_ZN7console6putstrEPKc>
    95ff:	bf 00 00 11 00       	mov    $0x110000,%edi
    9604:	be ff 87 00 00       	mov    $0x87ff,%esi
    9609:	e8 42 02 00 00       	call   9850 <_ZN7console6putstrEPKc>
    960e:	bf 00 00 11 00       	mov    $0x110000,%edi
    9613:	be 12 88 00 00       	mov    $0x8812,%esi
    9618:	e8 33 02 00 00       	call   9850 <_ZN7console6putstrEPKc>
    961d:	eb fe                	jmp    961d <stage2_main+0x3f1>
    961f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
    9626:	48 8d 1c 80          	lea    (%rax,%rax,4),%rbx
    962a:	48 c1 e3 04          	shl    $0x4,%rbx
    962e:	c5 fc 10 84 1c 00 01 	vmovups 0x100(%rsp,%rbx,1),%ymm0
    9635:	00 00 
    9637:	c5 fc 10 8c 1c 20 01 	vmovups 0x120(%rsp,%rbx,1),%ymm1
    963e:	00 00 
    9640:	c5 fc 10 94 1c 30 01 	vmovups 0x130(%rsp,%rbx,1),%ymm2
    9647:	00 00 
    9649:	c5 fc 11 54 24 30    	vmovups %ymm2,0x30(%rsp)
    964f:	c5 fc 11 4c 24 20    	vmovups %ymm1,0x20(%rsp)
    9655:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    965a:	bf 00 00 04 00       	mov    $0x40000,%edi
    965f:	be 00 02 00 00       	mov    $0x200,%esi
    9664:	c5 f8 77             	vzeroupper 
    9667:	e8 07 0e 00 00       	call   a473 <_Z9read_file8fat_filePvm>
    966c:	48 8b 3c 25 00 00 04 	mov    0x40000,%rdi
    9673:	00 
    9674:	48 8b 84 1c 40 01 00 	mov    0x140(%rsp,%rbx,1),%rax
    967b:	00 
    967c:	8b 70 1c             	mov    0x1c(%rax),%esi
    967f:	c5 fc 10 84 1c 00 01 	vmovups 0x100(%rsp,%rbx,1),%ymm0
    9686:	00 00 
    9688:	c5 fc 10 8c 1c 20 01 	vmovups 0x120(%rsp,%rbx,1),%ymm1
    968f:	00 00 
    9691:	c5 fc 10 94 1c 30 01 	vmovups 0x130(%rsp,%rbx,1),%ymm2
    9698:	00 00 
    969a:	c5 fc 11 54 24 30    	vmovups %ymm2,0x30(%rsp)
    96a0:	c5 fc 11 4c 24 20    	vmovups %ymm1,0x20(%rsp)
    96a6:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    96ab:	c5 f8 77             	vzeroupper 
    96ae:	e8 c0 0d 00 00       	call   a473 <_Z9read_file8fat_filePvm>
    96b3:	e8 a7 de ff 00       	call   100755f <kernel_main>
    96b8:	eb fe                	jmp    96b8 <stage2_main+0x48c>

Disassembly of section .text._Z9ahci_init10pci_device:

00000000000096ba <_Z9ahci_init10pci_device>:
    96ba:	53                   	push   %rbx
    96bb:	48 83 ec 20          	sub    $0x20,%rsp
    96bf:	48 8d 44 24 30       	lea    0x30(%rsp),%rax
    96c4:	b9 0c 20 01 00       	mov    $0x1200c,%ecx
    96c9:	48 8b 14 25 20 00 11 	mov    0x110020,%rdx
    96d0:	00 
    96d1:	48 83 c2 0f          	add    $0xf,%rdx
    96d5:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
    96d9:	48 8d 72 28          	lea    0x28(%rdx),%rsi
    96dd:	48 89 34 25 20 00 11 	mov    %rsi,0x110020
    96e4:	00 
    96e5:	48 89 14 25 c8 00 11 	mov    %rdx,0x1100c8
    96ec:	00 
    96ed:	31 d2                	xor    %edx,%edx
    96ef:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    96f3:	c5 fc 29 84 11 f4 0f 	vmovaps %ymm0,0xff4(%rcx,%rdx,1)
    96fa:	00 00 
    96fc:	48 83 c2 20          	add    $0x20,%rdx
    9700:	48 81 fa 00 20 00 00 	cmp    $0x2000,%rdx
    9707:	75 ea                	jne    96f3 <_Z9ahci_init10pci_device+0x39>
    9709:	8b 50 24             	mov    0x24(%rax),%edx
    970c:	89 d0                	mov    %edx,%eax
    970e:	83 e0 f0             	and    $0xfffffff0,%eax
    9711:	89 d6                	mov    %edx,%esi
    9713:	c1 ee 15             	shr    $0x15,%esi
    9716:	48 83 8c f1 f4 ff 05 	orq    $0x8,0x5fff4(%rcx,%rsi,8)
    971d:	00 08 
    971f:	81 c2 00 01 00 00    	add    $0x100,%edx
    9725:	48 8d 7a 28          	lea    0x28(%rdx),%rdi
    9729:	be ff ff ff ff       	mov    $0xffffffff,%esi
    972e:	45 31 c0             	xor    %r8d,%r8d
    9731:	44 8b 48 0c          	mov    0xc(%rax),%r9d
    9735:	45 0f a3 c1          	bt     %r8d,%r9d
    9739:	73 07                	jae    9742 <_Z9ahci_init10pci_device+0x88>
    973b:	83 3f 00             	cmpl   $0x0,(%rdi)
    973e:	41 0f 45 f0          	cmovne %r8d,%esi
    9742:	49 ff c0             	inc    %r8
    9745:	48 83 ef 80          	sub    $0xffffffffffffff80,%rdi
    9749:	49 83 f8 20          	cmp    $0x20,%r8
    974d:	75 e2                	jne    9731 <_Z9ahci_init10pci_device+0x77>
    974f:	4c 63 ce             	movslq %esi,%r9
    9752:	49 c1 e1 07          	shl    $0x7,%r9
    9756:	4a 8d 3c 0a          	lea    (%rdx,%r9,1),%rdi
    975a:	48 83 c7 18          	add    $0x18,%rdi
    975e:	83 27 ee             	andl   $0xffffffee,(%rdi)
    9761:	f7 07 00 c0 00 00    	testl  $0xc000,(%rdi)
    9767:	75 f8                	jne    9761 <_Z9ahci_init10pci_device+0xa7>
    9769:	4a 8d 34 0a          	lea    (%rdx,%r9,1),%rsi
    976d:	42 c7 04 0a 00 20 01 	movl   $0x12000,(%rdx,%r9,1)
    9774:	00 
    9775:	45 31 c0             	xor    %r8d,%r8d
    9778:	46 89 44 0a 04       	mov    %r8d,0x4(%rdx,%r9,1)
    977d:	42 c7 44 0a 08 00 28 	movl   $0x12800,0x8(%rdx,%r9,1)
    9784:	01 00 
    9786:	46 89 44 0a 0c       	mov    %r8d,0xc(%rdx,%r9,1)
    978b:	ba 00 30 01 00       	mov    $0x13000,%edx
    9790:	42 89 54 01 fc       	mov    %edx,-0x4(%rcx,%r8,1)
    9795:	42 c7 04 01 00 00 00 	movl   $0x0,(%rcx,%r8,1)
    979c:	00 
    979d:	66 42 c7 44 01 f6 08 	movw   $0x8,-0xa(%rcx,%r8,1)
    97a4:	00 
    97a5:	81 c2 00 01 00 00    	add    $0x100,%edx
    97ab:	49 83 c0 20          	add    $0x20,%r8
    97af:	49 81 f8 00 04 00 00 	cmp    $0x400,%r8
    97b6:	75 d8                	jne    9790 <_Z9ahci_init10pci_device+0xd6>
    97b8:	83 0f 11             	orl    $0x11,(%rdi)
    97bb:	8b 0f                	mov    (%rdi),%ecx
    97bd:	f7 d1                	not    %ecx
    97bf:	f7 c1 00 c0 00 00    	test   $0xc000,%ecx
    97c5:	74 15                	je     97dc <_Z9ahci_init10pci_device+0x122>
    97c7:	b9 02 00 00 02       	mov    $0x2000002,%ecx
    97cc:	ff c9                	dec    %ecx
    97ce:	74 3c                	je     980c <_Z9ahci_init10pci_device+0x152>
    97d0:	8b 17                	mov    (%rdi),%edx
    97d2:	f7 d2                	not    %edx
    97d4:	f7 c2 00 c0 00 00    	test   $0xc000,%edx
    97da:	75 f0                	jne    97cc <_Z9ahci_init10pci_device+0x112>
    97dc:	48 8b 0c 25 c8 00 11 	mov    0x1100c8,%rcx
    97e3:	00 
    97e4:	48 89 01             	mov    %rax,(%rcx)
    97e7:	48 89 71 08          	mov    %rsi,0x8(%rcx)
    97eb:	48 c7 41 10 00 20 01 	movq   $0x12000,0x10(%rcx)
    97f2:	00 
    97f3:	48 c7 41 18 00 28 01 	movq   $0x12800,0x18(%rcx)
    97fa:	00 
    97fb:	48 c7 41 20 00 30 01 	movq   $0x13000,0x20(%rcx)
    9802:	00 
    9803:	48 83 c4 20          	add    $0x20,%rsp
    9807:	5b                   	pop    %rbx
    9808:	c5 f8 77             	vzeroupper 
    980b:	c3                   	ret    
    980c:	48 89 e6             	mov    %rsp,%rsi
    980f:	48 c7 06 7d 8d 00 00 	movq   $0x8d7d,(%rsi)
    9816:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
    981d:	8b 17                	mov    (%rdi),%edx
    981f:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
    9824:	48 89 df             	mov    %rbx,%rdi
    9827:	31 c0                	xor    %eax,%eax
    9829:	c5 f8 77             	vzeroupper 
    982c:	e8 4e 00 00 00       	call   987f <_Z6format8rostringz>
    9831:	48 89 df             	mov    %rbx,%rdi
    9834:	e8 fd 06 00 00       	call   9f36 <_ZN6string10c_str_thisEv>
    9839:	bf 00 00 11 00       	mov    $0x110000,%edi
    983e:	48 89 c6             	mov    %rax,%rsi
    9841:	e8 0a 00 00 00       	call   9850 <_ZN7console6putstrEPKc>
    9846:	48 89 df             	mov    %rbx,%rdi
    9849:	e8 de 18 00 00       	call   b12c <_ZN6vectorIcED2Ev>
    984e:	eb fe                	jmp    984e <_Z9ahci_init10pci_device+0x194>

Disassembly of section .text._ZN7console6putstrEPKc:

0000000000009850 <_ZN7console6putstrEPKc>:
    9850:	8a 06                	mov    (%rsi),%al
    9852:	84 c0                	test   %al,%al
    9854:	74 28                	je     987e <_ZN7console6putstrEPKc+0x2e>
    9856:	41 56                	push   %r14
    9858:	53                   	push   %rbx
    9859:	50                   	push   %rax
    985a:	48 89 f3             	mov    %rsi,%rbx
    985d:	49 89 fe             	mov    %rdi,%r14
    9860:	48 ff c3             	inc    %rbx
    9863:	0f be f0             	movsbl %al,%esi
    9866:	4c 89 f7             	mov    %r14,%rdi
    9869:	e8 44 0f 00 00       	call   a7b2 <_ZN7console7putcharEc>
    986e:	8a 03                	mov    (%rbx),%al
    9870:	48 ff c3             	inc    %rbx
    9873:	84 c0                	test   %al,%al
    9875:	75 ec                	jne    9863 <_ZN7console6putstrEPKc+0x13>
    9877:	48 83 c4 08          	add    $0x8,%rsp
    987b:	5b                   	pop    %rbx
    987c:	41 5e                	pop    %r14
    987e:	c3                   	ret    

Disassembly of section .text._Z6format8rostringz:

000000000000987f <_Z6format8rostringz>:
    987f:	55                   	push   %rbp
    9880:	41 57                	push   %r15
    9882:	41 56                	push   %r14
    9884:	41 55                	push   %r13
    9886:	41 54                	push   %r12
    9888:	53                   	push   %rbx
    9889:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
    9890:	48 89 7c 24 78       	mov    %rdi,0x78(%rsp)
    9895:	48 8d bc 24 b0 00 00 	lea    0xb0(%rsp),%rdi
    989c:	00 
    989d:	48 89 57 10          	mov    %rdx,0x10(%rdi)
    98a1:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
    98a5:	4c 89 47 20          	mov    %r8,0x20(%rdi)
    98a9:	4c 89 4f 28          	mov    %r9,0x28(%rdi)
    98ad:	84 c0                	test   %al,%al
    98af:	74 48                	je     98f9 <_Z6format8rostringz+0x7a>
    98b1:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
    98b8:	00 00 
    98ba:	c5 f8 29 8c 24 f0 00 	vmovaps %xmm1,0xf0(%rsp)
    98c1:	00 00 
    98c3:	c5 f8 29 94 24 00 01 	vmovaps %xmm2,0x100(%rsp)
    98ca:	00 00 
    98cc:	c5 f8 29 9c 24 10 01 	vmovaps %xmm3,0x110(%rsp)
    98d3:	00 00 
    98d5:	c5 f8 29 a4 24 20 01 	vmovaps %xmm4,0x120(%rsp)
    98dc:	00 00 
    98de:	c5 f8 29 ac 24 30 01 	vmovaps %xmm5,0x130(%rsp)
    98e5:	00 00 
    98e7:	c5 f8 29 b4 24 40 01 	vmovaps %xmm6,0x140(%rsp)
    98ee:	00 00 
    98f0:	c5 f8 29 bc 24 50 01 	vmovaps %xmm7,0x150(%rsp)
    98f7:	00 00 
    98f9:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
    98fe:	48 8d 84 24 a0 01 00 	lea    0x1a0(%rsp),%rax
    9905:	00 
    9906:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
    990b:	48 b8 10 00 00 00 30 	movabs $0x3000000010,%rax
    9912:	00 00 00 
    9915:	48 89 04 24          	mov    %rax,(%rsp)
    9919:	8b 46 08             	mov    0x8(%rsi),%eax
    991c:	48 8b 0e             	mov    (%rsi),%rcx
    991f:	89 44 24 60          	mov    %eax,0x60(%rsp)
    9923:	8b 44 24 60          	mov    0x60(%rsp),%eax
    9927:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
    992c:	89 44 24 40          	mov    %eax,0x40(%rsp)
    9930:	c7 44 24 48 00 00 00 	movl   $0x0,0x48(%rsp)
    9937:	00 
    9938:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    993c:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
    9941:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    9945:	8b 76 08             	mov    0x8(%rsi),%esi
    9948:	e8 51 15 00 00       	call   ae9e <_ZN6vectorIcE7reserveEi>
    994d:	48 c7 44 24 68 36 8e 	movq   $0x8e36,0x68(%rsp)
    9954:	00 00 
    9956:	c7 44 24 70 0a 00 00 	movl   $0xa,0x70(%rsp)
    995d:	00 
    995e:	83 7c 24 40 00       	cmpl   $0x0,0x40(%rsp)
    9963:	0f 8e 55 05 00 00    	jle    9ebe <_Z6format8rostringz+0x63f>
    9969:	31 f6                	xor    %esi,%esi
    996b:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
    9970:	4c 8d 6c 24 20       	lea    0x20(%rsp),%r13
    9975:	4c 8d 7c 24 50       	lea    0x50(%rsp),%r15
    997a:	8d 46 01             	lea    0x1(%rsi),%eax
    997d:	89 44 24 48          	mov    %eax,0x48(%rsp)
    9981:	4c 89 f7             	mov    %r14,%rdi
    9984:	e8 2b 16 00 00       	call   afb4 <_ZN4spanIcE2atEi>
    9989:	8a 18                	mov    (%rax),%bl
    998b:	80 fb 25             	cmp    $0x25,%bl
    998e:	0f 85 13 01 00 00    	jne    9aa7 <_Z6format8rostringz+0x228>
    9994:	8b 44 24 70          	mov    0x70(%rsp),%eax
    9998:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
    999d:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
    99a4:	00 
    99a5:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
    99ac:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
    99b3:	00 
    99b4:	4c 89 f6             	mov    %r14,%rsi
    99b7:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
    99be:	00 
    99bf:	e8 fa 16 00 00       	call   b0be <_ZN13istringstream14read_until_incE8rostring>
    99c4:	8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%eax
    99cb:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
    99d2:	00 
    99d3:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
    99d8:	89 44 24 28          	mov    %eax,0x28(%rsp)
    99dc:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%rsp)
    99e3:	00 
    99e4:	83 7c 24 28 00       	cmpl   $0x0,0x28(%rsp)
    99e9:	0f 8e cb 00 00 00    	jle    9aba <_Z6format8rostringz+0x23b>
    99ef:	41 be 03 00 00 00    	mov    $0x3,%r14d
    99f5:	b3 20                	mov    $0x20,%bl
    99f7:	31 ed                	xor    %ebp,%ebp
    99f9:	45 31 e4             	xor    %r12d,%r12d
    99fc:	8d 45 01             	lea    0x1(%rbp),%eax
    99ff:	89 44 24 30          	mov    %eax,0x30(%rsp)
    9a03:	4c 89 ef             	mov    %r13,%rdi
    9a06:	89 ee                	mov    %ebp,%esi
    9a08:	e8 a7 15 00 00       	call   afb4 <_ZN4spanIcE2atEi>
    9a0d:	8a 00                	mov    (%rax),%al
    9a0f:	89 6c 24 30          	mov    %ebp,0x30(%rsp)
    9a13:	88 44 24 18          	mov    %al,0x18(%rsp)
    9a17:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
    9a1c:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
    9a21:	e8 74 21 00 00       	call   bb9a <_ZNK4spanIcE4findERKc>
    9a26:	85 c0                	test   %eax,%eax
    9a28:	0f 89 97 00 00 00    	jns    9ac5 <_Z6format8rostringz+0x246>
    9a2e:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
    9a33:	83 f8 2e             	cmp    $0x2e,%eax
    9a36:	74 1f                	je     9a57 <_Z6format8rostringz+0x1d8>
    9a38:	83 f8 7a             	cmp    $0x7a,%eax
    9a3b:	74 05                	je     9a42 <_Z6format8rostringz+0x1c3>
    9a3d:	83 f8 6c             	cmp    $0x6c,%eax
    9a40:	75 35                	jne    9a77 <_Z6format8rostringz+0x1f8>
    9a42:	8b 74 24 30          	mov    0x30(%rsp),%esi
    9a46:	8d 46 01             	lea    0x1(%rsi),%eax
    9a49:	89 44 24 30          	mov    %eax,0x30(%rsp)
    9a4d:	4c 89 ef             	mov    %r13,%rdi
    9a50:	e8 5f 15 00 00       	call   afb4 <_ZN4spanIcE2atEi>
    9a55:	eb 40                	jmp    9a97 <_Z6format8rostringz+0x218>
    9a57:	8b 74 24 30          	mov    0x30(%rsp),%esi
    9a5b:	8d 46 01             	lea    0x1(%rsi),%eax
    9a5e:	89 44 24 30          	mov    %eax,0x30(%rsp)
    9a62:	4c 89 ef             	mov    %r13,%rdi
    9a65:	e8 4a 15 00 00       	call   afb4 <_ZN4spanIcE2atEi>
    9a6a:	4c 89 ef             	mov    %r13,%rdi
    9a6d:	e8 80 15 00 00       	call   aff2 <_ZN13istringstream4readIlEET_v>
    9a72:	49 89 c6             	mov    %rax,%r14
    9a75:	eb 20                	jmp    9a97 <_Z6format8rostringz+0x218>
    9a77:	8b 74 24 30          	mov    0x30(%rsp),%esi
    9a7b:	8d 46 01             	lea    0x1(%rsi),%eax
    9a7e:	89 44 24 30          	mov    %eax,0x30(%rsp)
    9a82:	4c 89 ef             	mov    %r13,%rdi
    9a85:	e8 2a 15 00 00       	call   afb4 <_ZN4spanIcE2atEi>
    9a8a:	8a 18                	mov    (%rax),%bl
    9a8c:	4c 89 ef             	mov    %r13,%rdi
    9a8f:	e8 5e 15 00 00       	call   aff2 <_ZN13istringstream4readIlEET_v>
    9a94:	49 89 c4             	mov    %rax,%r12
    9a97:	8b 6c 24 30          	mov    0x30(%rsp),%ebp
    9a9b:	3b 6c 24 28          	cmp    0x28(%rsp),%ebp
    9a9f:	0f 8c 57 ff ff ff    	jl     99fc <_Z6format8rostringz+0x17d>
    9aa5:	eb 1e                	jmp    9ac5 <_Z6format8rostringz+0x246>
    9aa7:	8b 74 24 58          	mov    0x58(%rsp),%esi
    9aab:	4c 89 ff             	mov    %r15,%rdi
    9aae:	e8 b7 21 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    9ab3:	88 18                	mov    %bl,(%rax)
    9ab5:	e9 f6 03 00 00       	jmp    9eb0 <_Z6format8rostringz+0x631>
    9aba:	45 31 e4             	xor    %r12d,%r12d
    9abd:	b3 20                	mov    $0x20,%bl
    9abf:	41 be 03 00 00 00    	mov    $0x3,%r14d
    9ac5:	8b 74 24 28          	mov    0x28(%rsp),%esi
    9ac9:	ff ce                	dec    %esi
    9acb:	4c 89 ef             	mov    %r13,%rdi
    9ace:	e8 e1 14 00 00       	call   afb4 <_ZN4spanIcE2atEi>
    9ad3:	0f b6 00             	movzbl (%rax),%eax
    9ad6:	83 f8 65             	cmp    $0x65,%eax
    9ad9:	7f 49                	jg     9b24 <_Z6format8rostringz+0x2a5>
    9adb:	83 f8 52             	cmp    $0x52,%eax
    9ade:	0f 8e 85 00 00 00    	jle    9b69 <_Z6format8rostringz+0x2ea>
    9ae4:	83 f8 53             	cmp    $0x53,%eax
    9ae7:	0f 84 ea 00 00 00    	je     9bd7 <_Z6format8rostringz+0x358>
    9aed:	83 f8 58             	cmp    $0x58,%eax
    9af0:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
    9af5:	0f 84 01 01 00 00    	je     9bfc <_Z6format8rostringz+0x37d>
    9afb:	83 f8 62             	cmp    $0x62,%eax
    9afe:	0f 85 ac 03 00 00    	jne    9eb0 <_Z6format8rostringz+0x631>
    9b04:	8b 0c 24             	mov    (%rsp),%ecx
    9b07:	48 83 f9 28          	cmp    $0x28,%rcx
    9b0b:	0f 87 a9 01 00 00    	ja     9cba <_Z6format8rostringz+0x43b>
    9b11:	48 89 c8             	mov    %rcx,%rax
    9b14:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9b19:	83 c1 08             	add    $0x8,%ecx
    9b1c:	89 0c 24             	mov    %ecx,(%rsp)
    9b1f:	e9 a4 01 00 00       	jmp    9cc8 <_Z6format8rostringz+0x449>
    9b24:	83 f8 6f             	cmp    $0x6f,%eax
    9b27:	7e 77                	jle    9ba0 <_Z6format8rostringz+0x321>
    9b29:	83 f8 70             	cmp    $0x70,%eax
    9b2c:	0f 84 e3 00 00 00    	je     9c15 <_Z6format8rostringz+0x396>
    9b32:	83 f8 73             	cmp    $0x73,%eax
    9b35:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
    9b3a:	0f 84 10 01 00 00    	je     9c50 <_Z6format8rostringz+0x3d1>
    9b40:	83 f8 78             	cmp    $0x78,%eax
    9b43:	0f 85 67 03 00 00    	jne    9eb0 <_Z6format8rostringz+0x631>
    9b49:	8b 0c 24             	mov    (%rsp),%ecx
    9b4c:	48 83 f9 28          	cmp    $0x28,%rcx
    9b50:	0f 87 8c 01 00 00    	ja     9ce2 <_Z6format8rostringz+0x463>
    9b56:	48 89 c8             	mov    %rcx,%rax
    9b59:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9b5e:	83 c1 08             	add    $0x8,%ecx
    9b61:	89 0c 24             	mov    %ecx,(%rsp)
    9b64:	e9 87 01 00 00       	jmp    9cf0 <_Z6format8rostringz+0x471>
    9b69:	83 f8 49             	cmp    $0x49,%eax
    9b6c:	0f 84 fe 00 00 00    	je     9c70 <_Z6format8rostringz+0x3f1>
    9b72:	83 f8 4d             	cmp    $0x4d,%eax
    9b75:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
    9b7a:	0f 85 30 03 00 00    	jne    9eb0 <_Z6format8rostringz+0x631>
    9b80:	8b 0c 24             	mov    (%rsp),%ecx
    9b83:	48 83 f9 28          	cmp    $0x28,%rcx
    9b87:	0f 87 85 01 00 00    	ja     9d12 <_Z6format8rostringz+0x493>
    9b8d:	48 89 c8             	mov    %rcx,%rax
    9b90:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9b95:	83 c1 08             	add    $0x8,%ecx
    9b98:	89 0c 24             	mov    %ecx,(%rsp)
    9b9b:	e9 80 01 00 00       	jmp    9d20 <_Z6format8rostringz+0x4a1>
    9ba0:	83 f8 66             	cmp    $0x66,%eax
    9ba3:	0f 84 ec 00 00 00    	je     9c95 <_Z6format8rostringz+0x416>
    9ba9:	83 f8 69             	cmp    $0x69,%eax
    9bac:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
    9bb1:	0f 85 f9 02 00 00    	jne    9eb0 <_Z6format8rostringz+0x631>
    9bb7:	8b 0c 24             	mov    (%rsp),%ecx
    9bba:	48 83 f9 28          	cmp    $0x28,%rcx
    9bbe:	0f 87 ca 01 00 00    	ja     9d8e <_Z6format8rostringz+0x50f>
    9bc4:	48 89 c8             	mov    %rcx,%rax
    9bc7:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9bcc:	83 c1 08             	add    $0x8,%ecx
    9bcf:	89 0c 24             	mov    %ecx,(%rsp)
    9bd2:	e9 c5 01 00 00       	jmp    9d9c <_Z6format8rostringz+0x51d>
    9bd7:	8b 0c 24             	mov    (%rsp),%ecx
    9bda:	48 83 f9 28          	cmp    $0x28,%rcx
    9bde:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
    9be3:	0f 87 d5 01 00 00    	ja     9dbe <_Z6format8rostringz+0x53f>
    9be9:	48 89 c8             	mov    %rcx,%rax
    9bec:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9bf1:	83 c1 08             	add    $0x8,%ecx
    9bf4:	89 0c 24             	mov    %ecx,(%rsp)
    9bf7:	e9 d0 01 00 00       	jmp    9dcc <_Z6format8rostringz+0x54d>
    9bfc:	8b 0c 24             	mov    (%rsp),%ecx
    9bff:	48 83 f9 28          	cmp    $0x28,%rcx
    9c03:	77 2b                	ja     9c30 <_Z6format8rostringz+0x3b1>
    9c05:	48 89 c8             	mov    %rcx,%rax
    9c08:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9c0d:	83 c1 08             	add    $0x8,%ecx
    9c10:	89 0c 24             	mov    %ecx,(%rsp)
    9c13:	eb 29                	jmp    9c3e <_Z6format8rostringz+0x3bf>
    9c15:	be 7a 8d 00 00       	mov    $0x8d7a,%esi
    9c1a:	4c 89 ff             	mov    %r15,%rdi
    9c1d:	e8 d4 0c 00 00       	call   a8f6 <_ZN13ostringstream5writeIPKcEEvT_>
    9c22:	8b 0c 24             	mov    (%rsp),%ecx
    9c25:	48 83 f9 28          	cmp    $0x28,%rcx
    9c29:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
    9c2e:	76 d5                	jbe    9c05 <_Z6format8rostringz+0x386>
    9c30:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9c35:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9c39:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9c3e:	48 8b 30             	mov    (%rax),%rsi
    9c41:	44 0f be c3          	movsbl %bl,%r8d
    9c45:	41 b9 50 8a 00 00    	mov    $0x8a50,%r9d
    9c4b:	e9 ad 00 00 00       	jmp    9cfd <_Z6format8rostringz+0x47e>
    9c50:	8b 0c 24             	mov    (%rsp),%ecx
    9c53:	48 83 f9 28          	cmp    $0x28,%rcx
    9c57:	0f 87 9c 01 00 00    	ja     9df9 <_Z6format8rostringz+0x57a>
    9c5d:	48 89 c8             	mov    %rcx,%rax
    9c60:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9c65:	83 c1 08             	add    $0x8,%ecx
    9c68:	89 0c 24             	mov    %ecx,(%rsp)
    9c6b:	e9 97 01 00 00       	jmp    9e07 <_Z6format8rostringz+0x588>
    9c70:	8b 0c 24             	mov    (%rsp),%ecx
    9c73:	48 83 f9 28          	cmp    $0x28,%rcx
    9c77:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
    9c7c:	0f 87 95 01 00 00    	ja     9e17 <_Z6format8rostringz+0x598>
    9c82:	48 89 c8             	mov    %rcx,%rax
    9c85:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9c8a:	83 c1 08             	add    $0x8,%ecx
    9c8d:	89 0c 24             	mov    %ecx,(%rsp)
    9c90:	e9 90 01 00 00       	jmp    9e25 <_Z6format8rostringz+0x5a6>
    9c95:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
    9c99:	48 81 f9 a0 00 00 00 	cmp    $0xa0,%rcx
    9ca0:	0f 87 e2 01 00 00    	ja     9e88 <_Z6format8rostringz+0x609>
    9ca6:	48 89 c8             	mov    %rcx,%rax
    9ca9:	48 03 44 24 10       	add    0x10(%rsp),%rax
    9cae:	83 c1 10             	add    $0x10,%ecx
    9cb1:	89 4c 24 04          	mov    %ecx,0x4(%rsp)
    9cb5:	e9 dc 01 00 00       	jmp    9e96 <_Z6format8rostringz+0x617>
    9cba:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9cbf:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9cc3:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9cc8:	48 8b 30             	mov    (%rax),%rsi
    9ccb:	44 0f be c3          	movsbl %bl,%r8d
    9ccf:	41 b9 50 8a 00 00    	mov    $0x8a50,%r9d
    9cd5:	4c 89 ff             	mov    %r15,%rdi
    9cd8:	44 89 e2             	mov    %r12d,%edx
    9cdb:	b9 02 00 00 00       	mov    $0x2,%ecx
    9ce0:	eb 26                	jmp    9d08 <_Z6format8rostringz+0x489>
    9ce2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9ce7:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9ceb:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9cf0:	48 8b 30             	mov    (%rax),%rsi
    9cf3:	44 0f be c3          	movsbl %bl,%r8d
    9cf7:	41 b9 65 8f 00 00    	mov    $0x8f65,%r9d
    9cfd:	4c 89 ff             	mov    %r15,%rdi
    9d00:	44 89 e2             	mov    %r12d,%edx
    9d03:	b9 10 00 00 00       	mov    $0x10,%ecx
    9d08:	e8 0f 10 00 00       	call   ad1c <_ZN13ostringstream7write_uEmiicPKc>
    9d0d:	e9 9e 01 00 00       	jmp    9eb0 <_Z6format8rostringz+0x631>
    9d12:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9d17:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9d1b:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9d20:	48 8b 00             	mov    (%rax),%rax
    9d23:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
    9d28:	0f b6 f0             	movzbl %al,%esi
    9d2b:	41 b9 65 8f 00 00    	mov    $0x8f65,%r9d
    9d31:	4c 89 ff             	mov    %r15,%rdi
    9d34:	ba 02 00 00 00       	mov    $0x2,%edx
    9d39:	b9 10 00 00 00       	mov    $0x10,%ecx
    9d3e:	41 b8 30 00 00 00    	mov    $0x30,%r8d
    9d44:	e8 3b 0c 00 00       	call   a984 <_ZN13ostringstream7write_iEliicPKc>
    9d49:	bb 01 00 00 00       	mov    $0x1,%ebx
    9d4e:	8b 74 24 58          	mov    0x58(%rsp),%esi
    9d52:	4c 89 ff             	mov    %r15,%rdi
    9d55:	e8 10 1f 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    9d5a:	c6 00 3a             	movb   $0x3a,(%rax)
    9d5d:	0f b6 74 1c 18       	movzbl 0x18(%rsp,%rbx,1),%esi
    9d62:	41 b9 65 8f 00 00    	mov    $0x8f65,%r9d
    9d68:	4c 89 ff             	mov    %r15,%rdi
    9d6b:	ba 02 00 00 00       	mov    $0x2,%edx
    9d70:	b9 10 00 00 00       	mov    $0x10,%ecx
    9d75:	41 b8 30 00 00 00    	mov    $0x30,%r8d
    9d7b:	e8 04 0c 00 00       	call   a984 <_ZN13ostringstream7write_iEliicPKc>
    9d80:	48 ff c3             	inc    %rbx
    9d83:	48 83 fb 06          	cmp    $0x6,%rbx
    9d87:	75 c5                	jne    9d4e <_Z6format8rostringz+0x4cf>
    9d89:	e9 22 01 00 00       	jmp    9eb0 <_Z6format8rostringz+0x631>
    9d8e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9d93:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9d97:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9d9c:	48 8b 30             	mov    (%rax),%rsi
    9d9f:	44 0f be c3          	movsbl %bl,%r8d
    9da3:	41 b9 50 8a 00 00    	mov    $0x8a50,%r9d
    9da9:	4c 89 ff             	mov    %r15,%rdi
    9dac:	44 89 e2             	mov    %r12d,%edx
    9daf:	b9 0a 00 00 00       	mov    $0xa,%ecx
    9db4:	e8 cb 0b 00 00       	call   a984 <_ZN13ostringstream7write_iEliicPKc>
    9db9:	e9 f2 00 00 00       	jmp    9eb0 <_Z6format8rostringz+0x631>
    9dbe:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9dc3:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9dc7:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9dcc:	48 8b 00             	mov    (%rax),%rax
    9dcf:	8b 48 08             	mov    0x8(%rax),%ecx
    9dd2:	48 8b 00             	mov    (%rax),%rax
    9dd5:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
    9ddc:	00 
    9ddd:	89 8c 24 88 00 00 00 	mov    %ecx,0x88(%rsp)
    9de4:	4c 89 ff             	mov    %r15,%rdi
    9de7:	48 8d b4 24 80 00 00 	lea    0x80(%rsp),%rsi
    9dee:	00 
    9def:	e8 52 0b 00 00       	call   a946 <_ZN13ostringstream5writeI8rostringEEvT_>
    9df4:	e9 b7 00 00 00       	jmp    9eb0 <_Z6format8rostringz+0x631>
    9df9:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9dfe:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9e02:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9e07:	48 8b 30             	mov    (%rax),%rsi
    9e0a:	4c 89 ff             	mov    %r15,%rdi
    9e0d:	e8 e4 0a 00 00       	call   a8f6 <_ZN13ostringstream5writeIPKcEEvT_>
    9e12:	e9 99 00 00 00       	jmp    9eb0 <_Z6format8rostringz+0x631>
    9e17:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9e1c:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9e20:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9e25:	8b 00                	mov    (%rax),%eax
    9e27:	89 44 24 18          	mov    %eax,0x18(%rsp)
    9e2b:	0f b6 f0             	movzbl %al,%esi
    9e2e:	41 b9 50 8a 00 00    	mov    $0x8a50,%r9d
    9e34:	4c 89 ff             	mov    %r15,%rdi
    9e37:	31 d2                	xor    %edx,%edx
    9e39:	b9 0a 00 00 00       	mov    $0xa,%ecx
    9e3e:	41 b8 20 00 00 00    	mov    $0x20,%r8d
    9e44:	e8 3b 0b 00 00       	call   a984 <_ZN13ostringstream7write_iEliicPKc>
    9e49:	bb 01 00 00 00       	mov    $0x1,%ebx
    9e4e:	8b 74 24 58          	mov    0x58(%rsp),%esi
    9e52:	4c 89 ff             	mov    %r15,%rdi
    9e55:	e8 10 1e 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    9e5a:	c6 00 2e             	movb   $0x2e,(%rax)
    9e5d:	0f b6 74 1c 18       	movzbl 0x18(%rsp,%rbx,1),%esi
    9e62:	41 b9 50 8a 00 00    	mov    $0x8a50,%r9d
    9e68:	4c 89 ff             	mov    %r15,%rdi
    9e6b:	31 d2                	xor    %edx,%edx
    9e6d:	b9 0a 00 00 00       	mov    $0xa,%ecx
    9e72:	41 b8 20 00 00 00    	mov    $0x20,%r8d
    9e78:	e8 07 0b 00 00       	call   a984 <_ZN13ostringstream7write_iEliicPKc>
    9e7d:	48 ff c3             	inc    %rbx
    9e80:	48 83 fb 04          	cmp    $0x4,%rbx
    9e84:	75 c8                	jne    9e4e <_Z6format8rostringz+0x5cf>
    9e86:	eb 28                	jmp    9eb0 <_Z6format8rostringz+0x631>
    9e88:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
    9e8d:	48 8d 48 08          	lea    0x8(%rax),%rcx
    9e91:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
    9e96:	c5 fb 10 00          	vmovsd (%rax),%xmm0
    9e9a:	0f be cb             	movsbl %bl,%ecx
    9e9d:	4c 89 ff             	mov    %r15,%rdi
    9ea0:	44 89 e6             	mov    %r12d,%esi
    9ea3:	44 89 f2             	mov    %r14d,%edx
    9ea6:	e8 31 0b 00 00       	call   a9dc <_ZN13ostringstream7write_dEdiic>
    9eab:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
    9eb0:	8b 74 24 48          	mov    0x48(%rsp),%esi
    9eb4:	3b 74 24 40          	cmp    0x40(%rsp),%esi
    9eb8:	0f 8c bc fa ff ff    	jl     997a <_Z6format8rostringz+0xfb>
    9ebe:	8b 44 24 58          	mov    0x58(%rsp),%eax
    9ec2:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
    9ec7:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
    9ecc:	89 44 24 18          	mov    %eax,0x18(%rsp)
    9ed0:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
    9ed5:	8b 54 24 18          	mov    0x18(%rsp),%edx
    9ed9:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
    9ede:	48 89 df             	mov    %rbx,%rdi
    9ee1:	31 c9                	xor    %ecx,%ecx
    9ee3:	e8 34 1d 00 00       	call   bc1c <_ZN6vectorIcEC2EPKcii>
    9ee8:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
    9eed:	48 85 c0             	test   %rax,%rax
    9ef0:	74 2e                	je     9f20 <_Z6format8rostringz+0x6a1>
    9ef2:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    9ef6:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    9efa:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    9f01:	00 04 
    9f03:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    9f08:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    9f0f:	04 
    9f10:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    9f17:	04 
    9f18:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    9f1f:	00 
    9f20:	48 89 d8             	mov    %rbx,%rax
    9f23:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
    9f2a:	5b                   	pop    %rbx
    9f2b:	41 5c                	pop    %r12
    9f2d:	41 5d                	pop    %r13
    9f2f:	41 5e                	pop    %r14
    9f31:	41 5f                	pop    %r15
    9f33:	5d                   	pop    %rbp
    9f34:	c3                   	ret    

Disassembly of section .text._ZN6string10c_str_thisEv:

0000000000009f36 <_ZN6string10c_str_thisEv>:
    9f36:	53                   	push   %rbx
    9f37:	48 89 fb             	mov    %rdi,%rbx
    9f3a:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    9f3e:	74 12                	je     9f52 <_ZN6string10c_str_thisEv+0x1c>
    9f40:	8b 73 08             	mov    0x8(%rbx),%esi
    9f43:	ff ce                	dec    %esi
    9f45:	48 89 df             	mov    %rbx,%rdi
    9f48:	e8 67 10 00 00       	call   afb4 <_ZN4spanIcE2atEi>
    9f4d:	80 38 00             	cmpb   $0x0,(%rax)
    9f50:	74 0e                	je     9f60 <_ZN6string10c_str_thisEv+0x2a>
    9f52:	8b 73 08             	mov    0x8(%rbx),%esi
    9f55:	48 89 df             	mov    %rbx,%rdi
    9f58:	e8 0d 1d 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    9f5d:	c6 00 00             	movb   $0x0,(%rax)
    9f60:	48 8b 03             	mov    (%rbx),%rax
    9f63:	5b                   	pop    %rbx
    9f64:	c3                   	ret    

Disassembly of section .text._Z9ahci_read11ahci_devicemtPv:

0000000000009f65 <_Z9ahci_read11ahci_devicemtPv>:
    9f65:	53                   	push   %rbx
    9f66:	89 f0                	mov    %esi,%eax
    9f68:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    9f6d:	8b 31                	mov    (%rcx),%esi
    9f6f:	83 e6 a0             	and    $0xffffffa0,%esi
    9f72:	83 ce 05             	or     $0x5,%esi
    9f75:	66 89 31             	mov    %si,(%rcx)
    9f78:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
    9f7d:	89 91 80 00 00 00    	mov    %edx,0x80(%rcx)
    9f83:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%rcx)
    9f8a:	00 00 00 
    9f8d:	89 c2                	mov    %eax,%edx
    9f8f:	c1 e2 09             	shl    $0x9,%edx
    9f92:	ff ca                	dec    %edx
    9f94:	81 e2 ff ff 3f 00    	and    $0x3fffff,%edx
    9f9a:	be 00 00 c0 7f       	mov    $0x7fc00000,%esi
    9f9f:	23 b1 8c 00 00 00    	and    0x8c(%rcx),%esi
    9fa5:	01 f2                	add    %esi,%edx
    9fa7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
    9fad:	89 91 8c 00 00 00    	mov    %edx,0x8c(%rcx)
    9fb3:	c6 01 27             	movb   $0x27,(%rcx)
    9fb6:	80 49 01 80          	orb    $0x80,0x1(%rcx)
    9fba:	48 89 fa             	mov    %rdi,%rdx
    9fbd:	c6 41 02 25          	movb   $0x25,0x2(%rcx)
    9fc1:	88 51 04             	mov    %dl,0x4(%rcx)
    9fc4:	88 71 05             	mov    %dh,0x5(%rcx)
    9fc7:	89 d6                	mov    %edx,%esi
    9fc9:	c1 ee 10             	shr    $0x10,%esi
    9fcc:	40 88 71 06          	mov    %sil,0x6(%rcx)
    9fd0:	c6 41 07 40          	movb   $0x40,0x7(%rcx)
    9fd4:	89 d6                	mov    %edx,%esi
    9fd6:	c1 ee 18             	shr    $0x18,%esi
    9fd9:	40 88 71 08          	mov    %sil,0x8(%rcx)
    9fdd:	48 89 fe             	mov    %rdi,%rsi
    9fe0:	48 c1 ee 20          	shr    $0x20,%rsi
    9fe4:	40 88 71 09          	mov    %sil,0x9(%rcx)
    9fe8:	48 c1 ea 28          	shr    $0x28,%rdx
    9fec:	88 51 0a             	mov    %dl,0xa(%rcx)
    9fef:	88 41 0c             	mov    %al,0xc(%rcx)
    9ff2:	88 61 0d             	mov    %ah,0xd(%rcx)
    9ff5:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    9ffa:	f7 40 20 84 00 00 00 	testl  $0x84,0x20(%rax)
    a001:	75 f7                	jne    9ffa <_Z9ahci_read11ahci_devicemtPv+0x95>
    a003:	83 48 38 01          	orl    $0x1,0x38(%rax)
    a007:	f7 40 38 01 00 00 00 	testl  $0x1,0x38(%rax)
    a00e:	74 07                	je     a017 <_Z9ahci_read11ahci_devicemtPv+0xb2>
    a010:	0f ba 60 10 1e       	btl    $0x1e,0x10(%rax)
    a015:	73 f0                	jae    a007 <_Z9ahci_read11ahci_devicemtPv+0xa2>
    a017:	0f ba 60 10 1e       	btl    $0x1e,0x10(%rax)
    a01c:	73 21                	jae    a03f <_Z9ahci_read11ahci_devicemtPv+0xda>
    a01e:	b0 44                	mov    $0x44,%al
    a020:	48 c7 c3 ee ff ff ff 	mov    $0xffffffffffffffee,%rbx
    a027:	0f be f0             	movsbl %al,%esi
    a02a:	bf 00 00 11 00       	mov    $0x110000,%edi
    a02f:	e8 7e 07 00 00       	call   a7b2 <_ZN7console7putcharEc>
    a034:	8a 83 65 8f 00 00    	mov    0x8f65(%rbx),%al
    a03a:	48 ff c3             	inc    %rbx
    a03d:	75 e8                	jne    a027 <_Z9ahci_read11ahci_devicemtPv+0xc2>
    a03f:	5b                   	pop    %rbx
    a040:	c3                   	ret    

Disassembly of section .text._Z9read_diskPvjt:

000000000000a041 <_Z9read_diskPvjt>:
    a041:	48 83 ec 28          	sub    $0x28,%rsp
    a045:	48 89 f8             	mov    %rdi,%rax
    a048:	48 8b 0c 25 c8 00 11 	mov    0x1100c8,%rcx
    a04f:	00 
    a050:	89 f7                	mov    %esi,%edi
    a052:	48 8b 71 20          	mov    0x20(%rcx),%rsi
    a056:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
    a05b:	c5 fc 10 01          	vmovups (%rcx),%ymm0
    a05f:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    a064:	89 d6                	mov    %edx,%esi
    a066:	48 89 c2             	mov    %rax,%rdx
    a069:	c5 f8 77             	vzeroupper 
    a06c:	e8 f4 fe ff ff       	call   9f65 <_Z9ahci_read11ahci_devicemtPv>
    a071:	48 83 c4 28          	add    $0x28,%rsp
    a075:	c3                   	ret    

Disassembly of section .text._Z7irq_sethPFvvE:

000000000000a076 <_Z7irq_sethPFvvE>:
    a076:	89 f8                	mov    %edi,%eax
    a078:	48 89 34 c5 40 00 11 	mov    %rsi,0x110040(,%rax,8)
    a07f:	00 
    a080:	40 80 ff 07          	cmp    $0x7,%dil
    a084:	77 13                	ja     a099 <_Z7irq_sethPFvvE+0x23>
    a086:	e4 21                	in     $0x21,%al
    a088:	b9 01 00 00 00       	mov    $0x1,%ecx
    a08d:	c4 e2 41 f7 c9       	shlx   %edi,%ecx,%ecx
    a092:	f6 d1                	not    %cl
    a094:	20 c8                	and    %cl,%al
    a096:	e6 21                	out    %al,$0x21
    a098:	c3                   	ret    
    a099:	e4 a1                	in     $0xa1,%al
    a09b:	40 80 c7 f8          	add    $0xf8,%dil
    a09f:	b9 01 00 00 00       	mov    $0x1,%ecx
    a0a4:	c4 e2 41 f7 c9       	shlx   %edi,%ecx,%ecx
    a0a9:	f6 d1                	not    %cl
    a0ab:	20 c8                	and    %cl,%al
    a0ad:	e6 a1                	out    %al,$0xa1
    a0af:	c3                   	ret    

Disassembly of section .text._Z10pci_create8pci_addr:

000000000000a0b0 <_Z10pci_create8pci_addr>:
    a0b0:	89 f1                	mov    %esi,%ecx
    a0b2:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
    a0b8:	66 89 37             	mov    %si,(%rdi)
    a0bb:	89 f0                	mov    %esi,%eax
    a0bd:	c1 e8 10             	shr    $0x10,%eax
    a0c0:	88 47 02             	mov    %al,0x2(%rdi)
    a0c3:	89 f0                	mov    %esi,%eax
    a0c5:	c1 e0 10             	shl    $0x10,%eax
    a0c8:	c1 e6 03             	shl    $0x3,%esi
    a0cb:	81 e6 00 f8 07 00    	and    $0x7f800,%esi
    a0d1:	09 c6                	or     %eax,%esi
    a0d3:	c1 e9 08             	shr    $0x8,%ecx
    a0d6:	09 f1                	or     %esi,%ecx
    a0d8:	81 e1 00 ff ff 00    	and    $0xffff00,%ecx
    a0de:	8d 81 00 00 00 80    	lea    -0x80000000(%rcx),%eax
    a0e4:	66 ba f8 0c          	mov    $0xcf8,%dx
    a0e8:	ef                   	out    %eax,(%dx)
    a0e9:	66 ba fc 0c          	mov    $0xcfc,%dx
    a0ed:	ed                   	in     (%dx),%eax
    a0ee:	89 47 04             	mov    %eax,0x4(%rdi)
    a0f1:	8d 81 08 00 00 80    	lea    -0x7ffffff8(%rcx),%eax
    a0f7:	66 ba f8 0c          	mov    $0xcf8,%dx
    a0fb:	ef                   	out    %eax,(%dx)
    a0fc:	66 ba fc 0c          	mov    $0xcfc,%dx
    a100:	ed                   	in     (%dx),%eax
    a101:	89 47 08             	mov    %eax,0x8(%rdi)
    a104:	8d 81 0c 00 00 80    	lea    -0x7ffffff4(%rcx),%eax
    a10a:	66 ba f8 0c          	mov    $0xcf8,%dx
    a10e:	ef                   	out    %eax,(%dx)
    a10f:	66 ba fc 0c          	mov    $0xcfc,%dx
    a113:	ed                   	in     (%dx),%eax
    a114:	89 47 0c             	mov    %eax,0xc(%rdi)
    a117:	be 10 00 00 00       	mov    $0x10,%esi
    a11c:	89 f0                	mov    %esi,%eax
    a11e:	09 c8                	or     %ecx,%eax
    a120:	0d 00 00 00 80       	or     $0x80000000,%eax
    a125:	66 ba f8 0c          	mov    $0xcf8,%dx
    a129:	ef                   	out    %eax,(%dx)
    a12a:	66 ba fc 0c          	mov    $0xcfc,%dx
    a12e:	ed                   	in     (%dx),%eax
    a12f:	89 04 37             	mov    %eax,(%rdi,%rsi,1)
    a132:	48 83 c6 04          	add    $0x4,%rsi
    a136:	48 83 fe 28          	cmp    $0x28,%rsi
    a13a:	75 e0                	jne    a11c <_Z10pci_create8pci_addr+0x6c>
    a13c:	89 c8                	mov    %ecx,%eax
    a13e:	0d 2c 00 00 80       	or     $0x8000002c,%eax
    a143:	66 ba f8 0c          	mov    $0xcf8,%dx
    a147:	ef                   	out    %eax,(%dx)
    a148:	66 ba fc 0c          	mov    $0xcfc,%dx
    a14c:	ed                   	in     (%dx),%eax
    a14d:	89 47 28             	mov    %eax,0x28(%rdi)
    a150:	81 c9 3c 00 00 80    	or     $0x8000003c,%ecx
    a156:	89 c8                	mov    %ecx,%eax
    a158:	66 ba f8 0c          	mov    $0xcf8,%dx
    a15c:	ef                   	out    %eax,(%dx)
    a15d:	66 ba fc 0c          	mov    $0xcfc,%dx
    a161:	ed                   	in     (%dx),%eax
    a162:	66 89 47 2c          	mov    %ax,0x2c(%rdi)
    a166:	48 89 f8             	mov    %rdi,%rax
    a169:	c3                   	ret    

Disassembly of section .text._Z8pci_initv:

000000000000a16a <_Z8pci_initv>:
    a16a:	55                   	push   %rbp
    a16b:	41 57                	push   %r15
    a16d:	41 56                	push   %r14
    a16f:	41 55                	push   %r13
    a171:	41 54                	push   %r12
    a173:	53                   	push   %rbx
    a174:	48 83 ec 38          	sub    $0x38,%rsp
    a178:	48 8b 04 25 20 00 11 	mov    0x110020,%rax
    a17f:	00 
    a180:	48 83 c0 0f          	add    $0xf,%rax
    a184:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
    a188:	48 8d 88 04 18 00 00 	lea    0x1804(%rax),%rcx
    a18f:	48 89 0c 25 20 00 11 	mov    %rcx,0x110020
    a196:	00 
    a197:	48 89 05 5a f0 ff ff 	mov    %rax,-0xfa6(%rip)        # 91f8 <pci_dev>
    a19e:	31 ed                	xor    %ebp,%ebp
    a1a0:	31 c9                	xor    %ecx,%ecx
    a1a2:	44 0f b7 f9          	movzwl %cx,%r15d
    a1a6:	c1 e1 10             	shl    $0x10,%ecx
    a1a9:	45 31 e4             	xor    %r12d,%r12d
    a1ac:	89 4c 24 04          	mov    %ecx,0x4(%rsp)
    a1b0:	45 0f b6 f4          	movzbl %r12b,%r14d
    a1b4:	45 89 f5             	mov    %r14d,%r13d
    a1b7:	41 c1 e5 0b          	shl    $0xb,%r13d
    a1bb:	41 09 cd             	or     %ecx,%r13d
    a1be:	44 89 e8             	mov    %r13d,%eax
    a1c1:	25 ff ff ff 00       	and    $0xffffff,%eax
    a1c6:	0d 00 00 00 80       	or     $0x80000000,%eax
    a1cb:	66 ba f8 0c          	mov    $0xcf8,%dx
    a1cf:	ef                   	out    %eax,(%dx)
    a1d0:	66 ba fc 0c          	mov    $0xcfc,%dx
    a1d4:	ed                   	in     (%dx),%eax
    a1d5:	83 f8 ff             	cmp    $0xffffffff,%eax
    a1d8:	0f 84 b7 00 00 00    	je     a295 <_Z8pci_initv+0x12b>
    a1de:	41 c1 e6 08          	shl    $0x8,%r14d
    a1e2:	44 89 f6             	mov    %r14d,%esi
    a1e5:	44 09 fe             	or     %r15d,%esi
    a1e8:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
    a1ed:	c5 f8 77             	vzeroupper 
    a1f0:	e8 bb fe ff ff       	call   a0b0 <_Z10pci_create8pci_addr>
    a1f5:	48 8b 05 fc ef ff ff 	mov    -0x1004(%rip),%rax        # 91f8 <pci_dev>
    a1fc:	48 63 cd             	movslq %ebp,%rcx
    a1ff:	ff c5                	inc    %ebp
    a201:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
    a205:	48 c1 e1 04          	shl    $0x4,%rcx
    a209:	c5 fc 10 44 24 08    	vmovups 0x8(%rsp),%ymm0
    a20f:	c5 fc 10 4c 24 18    	vmovups 0x18(%rsp),%ymm1
    a215:	c5 fc 11 4c 08 10    	vmovups %ymm1,0x10(%rax,%rcx,1)
    a21b:	c5 fc 11 04 08       	vmovups %ymm0,(%rax,%rcx,1)
    a220:	80 7c 08 0e 00       	cmpb   $0x0,0xe(%rax,%rcx,1)
    a225:	79 6e                	jns    a295 <_Z8pci_initv+0x12b>
    a227:	b3 01                	mov    $0x1,%bl
    a229:	0f b6 f3             	movzbl %bl,%esi
    a22c:	89 f0                	mov    %esi,%eax
    a22e:	c1 e0 08             	shl    $0x8,%eax
    a231:	44 09 e8             	or     %r13d,%eax
    a234:	25 ff ff ff 00       	and    $0xffffff,%eax
    a239:	0d 00 00 00 80       	or     $0x80000000,%eax
    a23e:	66 ba f8 0c          	mov    $0xcf8,%dx
    a242:	ef                   	out    %eax,(%dx)
    a243:	66 ba fc 0c          	mov    $0xcfc,%dx
    a247:	ed                   	in     (%dx),%eax
    a248:	83 f8 ff             	cmp    $0xffffffff,%eax
    a24b:	74 41                	je     a28e <_Z8pci_initv+0x124>
    a24d:	c1 e6 10             	shl    $0x10,%esi
    a250:	44 09 f6             	or     %r14d,%esi
    a253:	44 09 fe             	or     %r15d,%esi
    a256:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
    a25b:	c5 f8 77             	vzeroupper 
    a25e:	e8 4d fe ff ff       	call   a0b0 <_Z10pci_create8pci_addr>
    a263:	48 8b 05 8e ef ff ff 	mov    -0x1072(%rip),%rax        # 91f8 <pci_dev>
    a26a:	48 63 cd             	movslq %ebp,%rcx
    a26d:	ff c5                	inc    %ebp
    a26f:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
    a273:	48 c1 e1 04          	shl    $0x4,%rcx
    a277:	c5 fc 10 44 24 08    	vmovups 0x8(%rsp),%ymm0
    a27d:	c5 fc 10 4c 24 18    	vmovups 0x18(%rsp),%ymm1
    a283:	c5 fc 11 4c 08 10    	vmovups %ymm1,0x10(%rax,%rcx,1)
    a289:	c5 fc 11 04 08       	vmovups %ymm0,(%rax,%rcx,1)
    a28e:	fe c3                	inc    %bl
    a290:	80 fb 07             	cmp    $0x7,%bl
    a293:	75 94                	jne    a229 <_Z8pci_initv+0xbf>
    a295:	41 fe c4             	inc    %r12b
    a298:	41 80 fc 20          	cmp    $0x20,%r12b
    a29c:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
    a2a0:	0f 85 0a ff ff ff    	jne    a1b0 <_Z8pci_initv+0x46>
    a2a6:	41 ff c7             	inc    %r15d
    a2a9:	41 0f b7 c7          	movzwl %r15w,%eax
    a2ad:	44 89 f9             	mov    %r15d,%ecx
    a2b0:	3d 00 01 00 00       	cmp    $0x100,%eax
    a2b5:	0f 85 e7 fe ff ff    	jne    a1a2 <_Z8pci_initv+0x38>
    a2bb:	48 8b 05 36 ef ff ff 	mov    -0x10ca(%rip),%rax        # 91f8 <pci_dev>
    a2c2:	89 a8 00 18 00 00    	mov    %ebp,0x1800(%rax)
    a2c8:	48 83 c4 38          	add    $0x38,%rsp
    a2cc:	5b                   	pop    %rbx
    a2cd:	41 5c                	pop    %r12
    a2cf:	41 5d                	pop    %r13
    a2d1:	41 5e                	pop    %r14
    a2d3:	41 5f                	pop    %r15
    a2d5:	5d                   	pop    %rbp
    a2d6:	c5 f8 77             	vzeroupper 
    a2d9:	c3                   	ret    

Disassembly of section .text._Z9pci_matchhhh:

000000000000a2da <_Z9pci_matchhhh>:
    a2da:	48 8b 05 17 ef ff ff 	mov    -0x10e9(%rip),%rax        # 91f8 <pci_dev>
    a2e1:	8b 88 00 18 00 00    	mov    0x1800(%rax),%ecx
    a2e7:	85 c9                	test   %ecx,%ecx
    a2e9:	7e 43                	jle    a32e <_Z9pci_matchhhh+0x54>
    a2eb:	44 8a 48 0b          	mov    0xb(%rax),%r9b
    a2ef:	41 38 f9             	cmp    %dil,%r9b
    a2f2:	41 0f 94 c0          	sete   %r8b
    a2f6:	40 80 fe ff          	cmp    $0xff,%sil
    a2fa:	74 11                	je     a30d <_Z9pci_matchhhh+0x33>
    a2fc:	41 30 f9             	xor    %dil,%r9b
    a2ff:	44 8a 40 0a          	mov    0xa(%rax),%r8b
    a303:	41 30 f0             	xor    %sil,%r8b
    a306:	45 08 c8             	or     %r9b,%r8b
    a309:	41 0f 94 c0          	sete   %r8b
    a30d:	80 fa ff             	cmp    $0xff,%dl
    a310:	74 0e                	je     a320 <_Z9pci_matchhhh+0x46>
    a312:	38 50 09             	cmp    %dl,0x9(%rax)
    a315:	41 0f 94 c1          	sete   %r9b
    a319:	45 84 c8             	test   %r9b,%r8b
    a31c:	74 07                	je     a325 <_Z9pci_matchhhh+0x4b>
    a31e:	eb 10                	jmp    a330 <_Z9pci_matchhhh+0x56>
    a320:	45 84 c0             	test   %r8b,%r8b
    a323:	75 0b                	jne    a330 <_Z9pci_matchhhh+0x56>
    a325:	48 83 c0 30          	add    $0x30,%rax
    a329:	48 ff c9             	dec    %rcx
    a32c:	75 bd                	jne    a2eb <_Z9pci_matchhhh+0x11>
    a32e:	31 c0                	xor    %eax,%eax
    a330:	c3                   	ret    

Disassembly of section .text._Z8fat_initP15partition_entryP9fat32_bpb:

000000000000a331 <_Z8fat_initP15partition_entryP9fat32_bpb>:
    a331:	0f b6 46 0d          	movzbl 0xd(%rsi),%eax
    a335:	66 89 05 c4 ee ff ff 	mov    %ax,-0x113c(%rip)        # 9200 <_ZL17sectorsPerCluster>
    a33c:	0f b7 4e 0e          	movzwl 0xe(%rsi),%ecx
    a340:	0f b6 56 10          	movzbl 0x10(%rsi),%edx
    a344:	0f af 56 24          	imul   0x24(%rsi),%edx
    a348:	01 ca                	add    %ecx,%edx
    a34a:	8b 7f 08             	mov    0x8(%rdi),%edi
    a34d:	01 d7                	add    %edx,%edi
    a34f:	89 3d af ee ff ff    	mov    %edi,-0x1151(%rip)        # 9204 <_ZL15firstClusterLBA>
    a355:	0f b7 7e 0b          	movzwl 0xb(%rsi),%edi
    a359:	0f af c7             	imul   %edi,%eax
    a35c:	66 89 05 a5 ee ff ff 	mov    %ax,-0x115b(%rip)        # 9208 <_ZL15bytesPerCluster>
    a363:	0f af d7             	imul   %edi,%edx
    a366:	01 f2                	add    %esi,%edx
    a368:	89 15 9e ee ff ff    	mov    %edx,-0x1162(%rip)        # 920c <_ZL16firstClusterAddr>
    a36e:	0f af f9             	imul   %ecx,%edi
    a371:	01 f7                	add    %esi,%edi
    a373:	48 89 3d 96 ee ff ff 	mov    %rdi,-0x116a(%rip)        # 9210 <_ZL8fatTable>
    a37a:	c3                   	ret    

Disassembly of section .text._Z16get_cluster_addrj:

000000000000a37b <_Z16get_cluster_addrj>:
    a37b:	8d 4f fe             	lea    -0x2(%rdi),%ecx
    a37e:	0f b7 05 83 ee ff ff 	movzwl -0x117d(%rip),%eax        # 9208 <_ZL15bytesPerCluster>
    a385:	0f af c1             	imul   %ecx,%eax
    a388:	03 05 7e ee ff ff    	add    -0x1182(%rip),%eax        # 920c <_ZL16firstClusterAddr>
    a38e:	c3                   	ret    

Disassembly of section .text._Z18read_cluster_chainPvjj:

000000000000a38f <_Z18read_cluster_chainPvjj>:
    a38f:	85 d2                	test   %edx,%edx
    a391:	0f 84 db 00 00 00    	je     a472 <_Z18read_cluster_chainPvjj+0xe3>
    a397:	41 57                	push   %r15
    a399:	41 56                	push   %r14
    a39b:	41 54                	push   %r12
    a39d:	53                   	push   %rbx
    a39e:	48 83 ec 28          	sub    $0x28,%rsp
    a3a2:	41 89 f7             	mov    %esi,%r15d
    a3a5:	85 f6                	test   %esi,%esi
    a3a7:	0f 84 ba 00 00 00    	je     a467 <_Z18read_cluster_chainPvjj+0xd8>
    a3ad:	44 89 f8             	mov    %r15d,%eax
    a3b0:	25 ff ff ff 0f       	and    $0xfffffff,%eax
    a3b5:	3d f6 ff ff 0f       	cmp    $0xffffff6,%eax
    a3ba:	0f 87 a7 00 00 00    	ja     a467 <_Z18read_cluster_chainPvjj+0xd8>
    a3c0:	89 d3                	mov    %edx,%ebx
    a3c2:	49 89 fe             	mov    %rdi,%r14
    a3c5:	48 8b 05 44 ee ff ff 	mov    -0x11bc(%rip),%rax        # 9210 <_ZL8fatTable>
    a3cc:	45 31 e4             	xor    %r12d,%r12d
    a3cf:	44 89 f9             	mov    %r15d,%ecx
    a3d2:	89 ca                	mov    %ecx,%edx
    a3d4:	8b 14 90             	mov    (%rax,%rdx,4),%edx
    a3d7:	ff c1                	inc    %ecx
    a3d9:	41 ff c4             	inc    %r12d
    a3dc:	39 ca                	cmp    %ecx,%edx
    a3de:	89 d1                	mov    %edx,%ecx
    a3e0:	74 f0                	je     a3d2 <_Z18read_cluster_chainPvjj+0x43>
    a3e2:	44 39 e3             	cmp    %r12d,%ebx
    a3e5:	44 0f 42 e3          	cmovb  %ebx,%r12d
    a3e9:	41 8d 7f fe          	lea    -0x2(%r15),%edi
    a3ed:	0f b7 05 0c ee ff ff 	movzwl -0x11f4(%rip),%eax        # 9200 <_ZL17sectorsPerCluster>
    a3f4:	0f af f8             	imul   %eax,%edi
    a3f7:	03 3d 07 ee ff ff    	add    -0x11f9(%rip),%edi        # 9204 <_ZL15firstClusterLBA>
    a3fd:	41 0f af c4          	imul   %r12d,%eax
    a401:	48 8b 0c 25 c8 00 11 	mov    0x1100c8,%rcx
    a408:	00 
    a409:	48 8b 51 20          	mov    0x20(%rcx),%rdx
    a40d:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
    a412:	c5 fc 10 01          	vmovups (%rcx),%ymm0
    a416:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
    a41b:	0f b7 f0             	movzwl %ax,%esi
    a41e:	4c 89 f2             	mov    %r14,%rdx
    a421:	c5 f8 77             	vzeroupper 
    a424:	e8 3c fb ff ff       	call   9f65 <_Z9ahci_read11ahci_devicemtPv>
    a429:	44 29 e3             	sub    %r12d,%ebx
    a42c:	74 39                	je     a467 <_Z18read_cluster_chainPvjj+0xd8>
    a42e:	48 8b 05 db ed ff ff 	mov    -0x1225(%rip),%rax        # 9210 <_ZL8fatTable>
    a435:	43 8d 0c 27          	lea    (%r15,%r12,1),%ecx
    a439:	ff c9                	dec    %ecx
    a43b:	44 8b 3c 88          	mov    (%rax,%rcx,4),%r15d
    a43f:	45 85 ff             	test   %r15d,%r15d
    a442:	74 23                	je     a467 <_Z18read_cluster_chainPvjj+0xd8>
    a444:	0f b7 0d bd ed ff ff 	movzwl -0x1243(%rip),%ecx        # 9208 <_ZL15bytesPerCluster>
    a44b:	44 0f af e1          	imul   %ecx,%r12d
    a44f:	4d 01 e6             	add    %r12,%r14
    a452:	44 89 f9             	mov    %r15d,%ecx
    a455:	81 e1 ff ff ff 0f    	and    $0xfffffff,%ecx
    a45b:	81 f9 f7 ff ff 0f    	cmp    $0xffffff7,%ecx
    a461:	0f 82 65 ff ff ff    	jb     a3cc <_Z18read_cluster_chainPvjj+0x3d>
    a467:	48 83 c4 28          	add    $0x28,%rsp
    a46b:	5b                   	pop    %rbx
    a46c:	41 5c                	pop    %r12
    a46e:	41 5e                	pop    %r14
    a470:	41 5f                	pop    %r15
    a472:	c3                   	ret    

Disassembly of section .text._Z9read_file8fat_filePvm:

000000000000a473 <_Z9read_file8fat_filePvm>:
    a473:	0f b7 0d 8e ed ff ff 	movzwl -0x1272(%rip),%ecx        # 9208 <_ZL15bytesPerCluster>
    a47a:	48 8d 04 0e          	lea    (%rsi,%rcx,1),%rax
    a47e:	48 ff c8             	dec    %rax
    a481:	31 d2                	xor    %edx,%edx
    a483:	48 f7 f1             	div    %rcx
    a486:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
    a48b:	0f b7 51 14          	movzwl 0x14(%rcx),%edx
    a48f:	c1 e2 10             	shl    $0x10,%edx
    a492:	0f b7 71 1a          	movzwl 0x1a(%rcx),%esi
    a496:	09 d6                	or     %edx,%esi
    a498:	89 c2                	mov    %eax,%edx
    a49a:	e9 f0 fe ff ff       	jmp    a38f <_Z18read_cluster_chainPvjj>

Disassembly of section .text._Z16get_fat_metadataP14fat_disk_entry:

000000000000a49f <_Z16get_fat_metadataP14fat_disk_entry>:
    a49f:	55                   	push   %rbp
    a4a0:	41 57                	push   %r15
    a4a2:	41 56                	push   %r14
    a4a4:	53                   	push   %rbx
    a4a5:	48 81 ec 88 01 00 00 	sub    $0x188,%rsp
    a4ac:	48 89 f8             	mov    %rdi,%rax
    a4af:	48 89 77 40          	mov    %rsi,0x40(%rdi)
    a4b3:	80 7e eb 0f          	cmpb   $0xf,-0x15(%rsi)
    a4b7:	0f 85 e8 00 00 00    	jne    a5a5 <_Z16get_fat_metadataP14fat_disk_entry+0x106>
    a4bd:	48 8d 56 e0          	lea    -0x20(%rsi),%rdx
    a4c1:	48 8d 7c 24 80       	lea    -0x80(%rsp),%rdi
    a4c6:	31 c9                	xor    %ecx,%ecx
    a4c8:	48 ff c1             	inc    %rcx
    a4cb:	c5 fc 10 02          	vmovups (%rdx),%ymm0
    a4cf:	c5 fc 11 07          	vmovups %ymm0,(%rdi)
    a4d3:	48 83 c7 20          	add    $0x20,%rdi
    a4d7:	80 7a eb 0f          	cmpb   $0xf,-0x15(%rdx)
    a4db:	48 8d 52 e0          	lea    -0x20(%rdx),%rdx
    a4df:	74 e7                	je     a4c8 <_Z16get_fat_metadataP14fat_disk_entry+0x29>
    a4e1:	85 c9                	test   %ecx,%ecx
    a4e3:	0f 84 bc 00 00 00    	je     a5a5 <_Z16get_fat_metadataP14fat_disk_entry+0x106>
    a4e9:	89 c9                	mov    %ecx,%ecx
    a4eb:	48 8d 54 24 81       	lea    -0x7f(%rsp),%rdx
    a4f0:	48 8d 70 f3          	lea    -0xd(%rax),%rsi
    a4f4:	48 8d 78 f8          	lea    -0x8(%rax),%rdi
    a4f8:	4c 8d 44 24 8e       	lea    -0x72(%rsp),%r8
    a4fd:	45 31 c9             	xor    %r9d,%r9d
    a500:	4d 89 ca             	mov    %r9,%r10
    a503:	49 c1 e2 05          	shl    $0x5,%r10
    a507:	46 0f b6 5c 14 80    	movzbl -0x80(%rsp,%r10,1),%r11d
    a50d:	41 83 e3 1f          	and    $0x1f,%r11d
    a511:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
    a515:	4d 8d 1c 9b          	lea    (%r11,%rbx,4),%r11
    a519:	4a 8d 1c 1e          	lea    (%rsi,%r11,1),%rbx
    a51d:	45 31 f6             	xor    %r14d,%r14d
    a520:	42 0f b7 2c 72       	movzwl (%rdx,%r14,2),%ebp
    a525:	42 88 2c 33          	mov    %bpl,(%rbx,%r14,1)
    a529:	49 83 fe 03          	cmp    $0x3,%r14
    a52d:	77 08                	ja     a537 <_Z16get_fat_metadataP14fat_disk_entry+0x98>
    a52f:	49 ff c6             	inc    %r14
    a532:	66 85 ed             	test   %bp,%bp
    a535:	75 e9                	jne    a520 <_Z16get_fat_metadataP14fat_disk_entry+0x81>
    a537:	66 85 ed             	test   %bp,%bp
    a53a:	74 53                	je     a58f <_Z16get_fat_metadataP14fat_disk_entry+0xf0>
    a53c:	4a 8d 1c 1f          	lea    (%rdi,%r11,1),%rbx
    a540:	45 31 f6             	xor    %r14d,%r14d
    a543:	43 0f b7 2c 70       	movzwl (%r8,%r14,2),%ebp
    a548:	42 88 2c 33          	mov    %bpl,(%rbx,%r14,1)
    a54c:	49 83 fe 04          	cmp    $0x4,%r14
    a550:	77 08                	ja     a55a <_Z16get_fat_metadataP14fat_disk_entry+0xbb>
    a552:	49 ff c6             	inc    %r14
    a555:	66 85 ed             	test   %bp,%bp
    a558:	75 e9                	jne    a543 <_Z16get_fat_metadataP14fat_disk_entry+0xa4>
    a55a:	66 85 ed             	test   %bp,%bp
    a55d:	74 30                	je     a58f <_Z16get_fat_metadataP14fat_disk_entry+0xf0>
    a55f:	b3 01                	mov    $0x1,%bl
    a561:	45 31 f6             	xor    %r14d,%r14d
    a564:	4e 8d 3c 14          	lea    (%rsp,%r10,1),%r15
    a568:	49 83 c7 80          	add    $0xffffffffffffff80,%r15
    a56c:	43 0f b7 6c 77 1c    	movzwl 0x1c(%r15,%r14,2),%ebp
    a572:	49 83 ce fe          	or     $0xfffffffffffffffe,%r14
    a576:	4d 01 de             	add    %r11,%r14
    a579:	42 88 2c 30          	mov    %bpl,(%rax,%r14,1)
    a57d:	f6 c3 01             	test   $0x1,%bl
    a580:	74 0d                	je     a58f <_Z16get_fat_metadataP14fat_disk_entry+0xf0>
    a582:	41 be 01 00 00 00    	mov    $0x1,%r14d
    a588:	31 db                	xor    %ebx,%ebx
    a58a:	66 85 ed             	test   %bp,%bp
    a58d:	75 d5                	jne    a564 <_Z16get_fat_metadataP14fat_disk_entry+0xc5>
    a58f:	49 ff c1             	inc    %r9
    a592:	48 83 c2 20          	add    $0x20,%rdx
    a596:	49 83 c0 20          	add    $0x20,%r8
    a59a:	49 39 c9             	cmp    %rcx,%r9
    a59d:	0f 85 5d ff ff ff    	jne    a500 <_Z16get_fat_metadataP14fat_disk_entry+0x61>
    a5a3:	eb 5a                	jmp    a5ff <_Z16get_fat_metadataP14fat_disk_entry+0x160>
    a5a5:	31 c9                	xor    %ecx,%ecx
    a5a7:	8a 14 0e             	mov    (%rsi,%rcx,1),%dl
    a5aa:	80 fa 20             	cmp    $0x20,%dl
    a5ad:	74 11                	je     a5c0 <_Z16get_fat_metadataP14fat_disk_entry+0x121>
    a5af:	88 14 08             	mov    %dl,(%rax,%rcx,1)
    a5b2:	48 ff c1             	inc    %rcx
    a5b5:	48 83 f9 08          	cmp    $0x8,%rcx
    a5b9:	75 ec                	jne    a5a7 <_Z16get_fat_metadataP14fat_disk_entry+0x108>
    a5bb:	b9 08 00 00 00       	mov    $0x8,%ecx
    a5c0:	80 7e 08 20          	cmpb   $0x20,0x8(%rsi)
    a5c4:	74 32                	je     a5f8 <_Z16get_fat_metadataP14fat_disk_entry+0x159>
    a5c6:	89 ca                	mov    %ecx,%edx
    a5c8:	4c 8d 04 10          	lea    (%rax,%rdx,1),%r8
    a5cc:	49 ff c0             	inc    %r8
    a5cf:	41 c6 40 ff 2e       	movb   $0x2e,-0x1(%r8)
    a5d4:	83 c1 04             	add    $0x4,%ecx
    a5d7:	31 ff                	xor    %edi,%edi
    a5d9:	44 8a 4c 3e 08       	mov    0x8(%rsi,%rdi,1),%r9b
    a5de:	41 80 f9 20          	cmp    $0x20,%r9b
    a5e2:	74 0f                	je     a5f3 <_Z16get_fat_metadataP14fat_disk_entry+0x154>
    a5e4:	45 88 0c 38          	mov    %r9b,(%r8,%rdi,1)
    a5e8:	48 ff c7             	inc    %rdi
    a5eb:	48 83 ff 03          	cmp    $0x3,%rdi
    a5ef:	75 e8                	jne    a5d9 <_Z16get_fat_metadataP14fat_disk_entry+0x13a>
    a5f1:	eb 05                	jmp    a5f8 <_Z16get_fat_metadataP14fat_disk_entry+0x159>
    a5f3:	8d 0c 3a             	lea    (%rdx,%rdi,1),%ecx
    a5f6:	ff c1                	inc    %ecx
    a5f8:	48 63 c9             	movslq %ecx,%rcx
    a5fb:	c6 04 08 00          	movb   $0x0,(%rax,%rcx,1)
    a5ff:	48 81 c4 88 01 00 00 	add    $0x188,%rsp
    a606:	5b                   	pop    %rbx
    a607:	41 5e                	pop    %r14
    a609:	41 5f                	pop    %r15
    a60b:	5d                   	pop    %rbp
    a60c:	c5 f8 77             	vzeroupper 
    a60f:	c3                   	ret    

Disassembly of section .text._Z8enum_dir8fat_filePS_:

000000000000a610 <_Z8enum_dir8fat_filePS_>:
    a610:	55                   	push   %rbp
    a611:	41 57                	push   %r15
    a613:	41 56                	push   %r14
    a615:	53                   	push   %rbx
    a616:	48 83 ec 58          	sub    $0x58,%rsp
    a61a:	4c 8b b4 24 c8 00 00 	mov    0xc8(%rsp),%r14
    a621:	00 
    a622:	41 80 3e 00          	cmpb   $0x0,(%r14)
    a626:	74 5c                	je     a684 <_Z8enum_dir8fat_filePS_+0x74>
    a628:	48 89 fb             	mov    %rdi,%rbx
    a62b:	31 ed                	xor    %ebp,%ebp
    a62d:	4c 8d 7c 24 08       	lea    0x8(%rsp),%r15
    a632:	41 80 7e 0b 0f       	cmpb   $0xf,0xb(%r14)
    a637:	74 3e                	je     a677 <_Z8enum_dir8fat_filePS_+0x67>
    a639:	4c 89 ff             	mov    %r15,%rdi
    a63c:	4c 89 f6             	mov    %r14,%rsi
    a63f:	c5 f8 77             	vzeroupper 
    a642:	e8 58 fe ff ff       	call   a49f <_Z16get_fat_metadataP14fat_disk_entry>
    a647:	48 63 c5             	movslq %ebp,%rax
    a64a:	ff c5                	inc    %ebp
    a64c:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
    a650:	48 c1 e0 04          	shl    $0x4,%rax
    a654:	c5 fc 10 44 24 08    	vmovups 0x8(%rsp),%ymm0
    a65a:	c5 fc 10 4c 24 28    	vmovups 0x28(%rsp),%ymm1
    a660:	c5 fc 10 54 24 38    	vmovups 0x38(%rsp),%ymm2
    a666:	c5 fc 11 54 03 30    	vmovups %ymm2,0x30(%rbx,%rax,1)
    a66c:	c5 fc 11 4c 03 20    	vmovups %ymm1,0x20(%rbx,%rax,1)
    a672:	c5 fc 11 04 03       	vmovups %ymm0,(%rbx,%rax,1)
    a677:	41 80 7e 20 00       	cmpb   $0x0,0x20(%r14)
    a67c:	4d 8d 76 20          	lea    0x20(%r14),%r14
    a680:	75 b0                	jne    a632 <_Z8enum_dir8fat_filePS_+0x22>
    a682:	eb 02                	jmp    a686 <_Z8enum_dir8fat_filePS_+0x76>
    a684:	31 ed                	xor    %ebp,%ebp
    a686:	89 e8                	mov    %ebp,%eax
    a688:	48 83 c4 58          	add    $0x58,%rsp
    a68c:	5b                   	pop    %rbx
    a68d:	41 5e                	pop    %r14
    a68f:	41 5f                	pop    %r15
    a691:	5d                   	pop    %rbp
    a692:	c5 f8 77             	vzeroupper 
    a695:	c3                   	ret    

Disassembly of section .text._Z6streqlPKcS0_:

000000000000a696 <_Z6streqlPKcS0_>:
    a696:	8a 0f                	mov    (%rdi),%cl
    a698:	31 c0                	xor    %eax,%eax
    a69a:	84 c9                	test   %cl,%cl
    a69c:	74 0e                	je     a6ac <_Z6streqlPKcS0_+0x16>
    a69e:	38 0c 06             	cmp    %cl,(%rsi,%rax,1)
    a6a1:	75 11                	jne    a6b4 <_Z6streqlPKcS0_+0x1e>
    a6a3:	8a 4c 07 01          	mov    0x1(%rdi,%rax,1),%cl
    a6a7:	48 ff c0             	inc    %rax
    a6aa:	eb ee                	jmp    a69a <_Z6streqlPKcS0_+0x4>
    a6ac:	80 3c 06 00          	cmpb   $0x0,(%rsi,%rax,1)
    a6b0:	0f 94 c0             	sete   %al
    a6b3:	c3                   	ret    
    a6b4:	31 c0                	xor    %eax,%eax
    a6b6:	c3                   	ret    

Disassembly of section .text._ZN7consoleC2Ev:

000000000000a6b8 <_ZN7consoleC1Ev>:
    a6b8:	48 c7 07 00 80 0b 00 	movq   $0xb8000,(%rdi)
    a6bf:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    a6c3:	c5 f8 11 47 08       	vmovups %xmm0,0x8(%rdi)
    a6c8:	48 b8 50 00 00 00 19 	movabs $0x1900000050,%rax
    a6cf:	00 00 00 
    a6d2:	48 89 47 18          	mov    %rax,0x18(%rdi)
    a6d6:	31 c0                	xor    %eax,%eax
    a6d8:	c4 e2 7d 79 05 33 e0 	vpbroadcastw -0x1fcd(%rip),%ymm0        # 8714 <load_idt+0xc>
    a6df:	ff ff 
    a6e1:	c5 fd 7f 84 00 00 80 	vmovdqa %ymm0,0xb8000(%rax,%rax,1)
    a6e8:	0b 00 
    a6ea:	48 83 c0 10          	add    $0x10,%rax
    a6ee:	48 3d d0 07 00 00    	cmp    $0x7d0,%rax
    a6f4:	75 eb                	jne    a6e1 <_ZN7consoleC1Ev+0x29>
    a6f6:	c5 f8 77             	vzeroupper 
    a6f9:	c3                   	ret    

Disassembly of section .text._ZN7console7newlineEv:

000000000000a6fa <_ZN7console7newlineEv>:
    a6fa:	55                   	push   %rbp
    a6fb:	41 56                	push   %r14
    a6fd:	53                   	push   %rbx
    a6fe:	8b 47 0c             	mov    0xc(%rdi),%eax
    a701:	8b 77 1c             	mov    0x1c(%rdi),%esi
    a704:	8d 50 01             	lea    0x1(%rax),%edx
    a707:	89 57 0c             	mov    %edx,0xc(%rdi)
    a70a:	48 63 4f 14          	movslq 0x14(%rdi),%rcx
    a70e:	41 89 f0             	mov    %esi,%r8d
    a711:	41 29 c8             	sub    %ecx,%r8d
    a714:	44 39 c2             	cmp    %r8d,%edx
    a717:	75 67                	jne    a780 <_ZN7console7newlineEv+0x86>
    a719:	44 8d 0c 0e          	lea    (%rsi,%rcx,1),%r9d
    a71d:	41 ff c9             	dec    %r9d
    a720:	44 39 c9             	cmp    %r9d,%ecx
    a723:	7d 56                	jge    a77b <_ZN7console7newlineEv+0x81>
    a725:	48 63 57 10          	movslq 0x10(%rdi),%rdx
    a729:	48 63 77 18          	movslq 0x18(%rdi),%rsi
    a72d:	4c 8d 04 16          	lea    (%rsi,%rdx,1),%r8
    a731:	48 8b 1f             	mov    (%rdi),%rbx
    a734:	4d 63 c9             	movslq %r9d,%r9
    a737:	49 89 ca             	mov    %rcx,%r10
    a73a:	4c 0f af d6          	imul   %rsi,%r10
    a73e:	4e 8d 14 53          	lea    (%rbx,%r10,2),%r10
    a742:	4c 8d 71 01          	lea    0x1(%rcx),%r14
    a746:	4c 0f af f6          	imul   %rsi,%r14
    a74a:	49 89 f3             	mov    %rsi,%r11
    a74d:	49 01 f3             	add    %rsi,%r11
    a750:	4a 8d 1c 73          	lea    (%rbx,%r14,2),%rbx
    a754:	49 89 d6             	mov    %rdx,%r14
    a757:	85 f6                	test   %esi,%esi
    a759:	7e 12                	jle    a76d <_ZN7console7newlineEv+0x73>
    a75b:	42 0f b7 2c 73       	movzwl (%rbx,%r14,2),%ebp
    a760:	66 43 89 2c 72       	mov    %bp,(%r10,%r14,2)
    a765:	49 ff c6             	inc    %r14
    a768:	4d 39 c6             	cmp    %r8,%r14
    a76b:	7c ee                	jl     a75b <_ZN7console7newlineEv+0x61>
    a76d:	48 ff c1             	inc    %rcx
    a770:	4d 01 da             	add    %r11,%r10
    a773:	4c 01 db             	add    %r11,%rbx
    a776:	4c 39 c9             	cmp    %r9,%rcx
    a779:	75 d9                	jne    a754 <_ZN7console7newlineEv+0x5a>
    a77b:	89 47 0c             	mov    %eax,0xc(%rdi)
    a77e:	89 c2                	mov    %eax,%edx
    a780:	48 63 47 18          	movslq 0x18(%rdi),%rax
    a784:	48 85 c0             	test   %rax,%rax
    a787:	7e 23                	jle    a7ac <_ZN7console7newlineEv+0xb2>
    a789:	89 c6                	mov    %eax,%esi
    a78b:	48 63 4f 10          	movslq 0x10(%rdi),%rcx
    a78f:	48 01 c8             	add    %rcx,%rax
    a792:	0f af d6             	imul   %esi,%edx
    a795:	48 63 d2             	movslq %edx,%rdx
    a798:	48 01 d2             	add    %rdx,%rdx
    a79b:	48 03 17             	add    (%rdi),%rdx
    a79e:	66 c7 04 4a 00 00    	movw   $0x0,(%rdx,%rcx,2)
    a7a4:	48 ff c1             	inc    %rcx
    a7a7:	48 39 c1             	cmp    %rax,%rcx
    a7aa:	7c f2                	jl     a79e <_ZN7console7newlineEv+0xa4>
    a7ac:	5b                   	pop    %rbx
    a7ad:	41 5e                	pop    %r14
    a7af:	5d                   	pop    %rbp
    a7b0:	c3                   	ret    

Disassembly of section .text._ZN7console7putcharEc:

000000000000a7b2 <_ZN7console7putcharEc>:
    a7b2:	85 f6                	test   %esi,%esi
    a7b4:	74 51                	je     a807 <_ZN7console7putcharEc+0x55>
    a7b6:	83 fe 0a             	cmp    $0xa,%esi
    a7b9:	0f 84 3b ff ff ff    	je     a6fa <_ZN7console7newlineEv>
    a7bf:	83 fe 0d             	cmp    $0xd,%esi
    a7c2:	75 08                	jne    a7cc <_ZN7console7putcharEc+0x1a>
    a7c4:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%rdi)
    a7cb:	c3                   	ret    
    a7cc:	8b 4f 08             	mov    0x8(%rdi),%ecx
    a7cf:	40 0f be c6          	movsbl %sil,%eax
    a7d3:	0d 00 0f 00 00       	or     $0xf00,%eax
    a7d8:	48 8b 17             	mov    (%rdi),%rdx
    a7db:	8b 77 18             	mov    0x18(%rdi),%esi
    a7de:	44 8b 47 0c          	mov    0xc(%rdi),%r8d
    a7e2:	44 0f af c6          	imul   %esi,%r8d
    a7e6:	41 01 c8             	add    %ecx,%r8d
    a7e9:	4d 63 c0             	movslq %r8d,%r8
    a7ec:	66 42 89 04 42       	mov    %ax,(%rdx,%r8,2)
    a7f1:	ff c1                	inc    %ecx
    a7f3:	89 4f 08             	mov    %ecx,0x8(%rdi)
    a7f6:	8b 47 10             	mov    0x10(%rdi),%eax
    a7f9:	01 c6                	add    %eax,%esi
    a7fb:	39 f1                	cmp    %esi,%ecx
    a7fd:	75 08                	jne    a807 <_ZN7console7putcharEc+0x55>
    a7ff:	89 47 08             	mov    %eax,0x8(%rdi)
    a802:	e9 f3 fe ff ff       	jmp    a6fa <_ZN7console7newlineEv>
    a807:	c3                   	ret    

Disassembly of section .text._Z8mem_initv:

000000000000a808 <_Z8mem_initv>:
    a808:	48 c7 04 25 20 00 11 	movq   $0x200000,0x110020
    a80f:	00 00 00 20 00 
    a814:	48 c7 04 25 30 00 11 	movq   $0x3fffff0,0x110030
    a81b:	00 f0 ff ff 03 
    a820:	48 c7 04 25 28 00 11 	movq   $0x10,0x110028
    a827:	00 10 00 00 00 
    a82c:	48 c7 04 25 00 00 00 	movq   $0x3fffff8,0x4000000
    a833:	04 f8 ff ff 03 
    a838:	48 c7 04 25 08 00 00 	movq   $0x4000010,0x4000008
    a83f:	04 10 00 00 04 
    a844:	48 c7 04 25 10 00 00 	movq   $0x0,0x4000010
    a84b:	04 00 00 00 00 
    a850:	c3                   	ret    

Disassembly of section .text._Z16__malloc_trackedmPKci:

000000000000a851 <_Z16__malloc_trackedmPKci>:
    a851:	48 83 c7 1f          	add    $0x1f,%rdi
    a855:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
    a859:	b9 10 00 00 00       	mov    $0x10,%ecx
    a85e:	48 0f 45 cf          	cmovne %rdi,%rcx
    a862:	48 8b 14 25 00 00 00 	mov    0x4000000,%rdx
    a869:	04 
    a86a:	be 00 00 00 04       	mov    $0x4000000,%esi
    a86f:	48 39 ca             	cmp    %rcx,%rdx
    a872:	73 09                	jae    a87d <_Z16__malloc_trackedmPKci+0x2c>
    a874:	48 8b 76 08          	mov    0x8(%rsi),%rsi
    a878:	48 8b 16             	mov    (%rsi),%rdx
    a87b:	eb f2                	jmp    a86f <_Z16__malloc_trackedmPKci+0x1e>
    a87d:	48 8b 46 08          	mov    0x8(%rsi),%rax
    a881:	48 89 d7             	mov    %rdx,%rdi
    a884:	48 29 cf             	sub    %rcx,%rdi
    a887:	48 83 ff 0f          	cmp    $0xf,%rdi
    a88b:	77 0a                	ja     a897 <_Z16__malloc_trackedmPKci+0x46>
    a88d:	c5 f8 10 00          	vmovups (%rax),%xmm0
    a891:	c5 f8 11 06          	vmovups %xmm0,(%rsi)
    a895:	eb 0d                	jmp    a8a4 <_Z16__malloc_trackedmPKci+0x53>
    a897:	48 89 3e             	mov    %rdi,(%rsi)
    a89a:	48 c1 e7 04          	shl    $0x4,%rdi
    a89e:	48 01 f8             	add    %rdi,%rax
    a8a1:	48 89 ca             	mov    %rcx,%rdx
    a8a4:	48 89 10             	mov    %rdx,(%rax)
    a8a7:	48 83 c0 10          	add    $0x10,%rax
    a8ab:	48 01 14 25 28 00 11 	add    %rdx,0x110028
    a8b2:	00 
    a8b3:	c3                   	ret    

Disassembly of section .text._ZdaPv:

000000000000a8b4 <_ZdaPv>:
    a8b4:	48 85 ff             	test   %rdi,%rdi
    a8b7:	74 2e                	je     a8e7 <_ZdaPv+0x33>
    a8b9:	48 8d 47 f0          	lea    -0x10(%rdi),%rax
    a8bd:	48 8b 4f f0          	mov    -0x10(%rdi),%rcx
    a8c1:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    a8c8:	00 04 
    a8ca:	c5 f8 11 47 f0       	vmovups %xmm0,-0x10(%rdi)
    a8cf:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
    a8d6:	04 
    a8d7:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
    a8de:	04 
    a8df:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    a8e6:	00 
    a8e7:	c3                   	ret    

Disassembly of section .text._ZN8rostringC2EPKcii:

000000000000a8e8 <_ZN8rostringC1EPKcii>:
    a8e8:	48 63 c1             	movslq %ecx,%rax
    a8eb:	48 01 f0             	add    %rsi,%rax
    a8ee:	48 89 07             	mov    %rax,(%rdi)
    a8f1:	89 57 08             	mov    %edx,0x8(%rdi)
    a8f4:	c3                   	ret    

Disassembly of section .text._ZN13ostringstream5writeIPKcEEvT_:

000000000000a8f6 <_ZN13ostringstream5writeIPKcEEvT_>:
    a8f6:	55                   	push   %rbp
    a8f7:	41 57                	push   %r15
    a8f9:	41 56                	push   %r14
    a8fb:	41 54                	push   %r12
    a8fd:	53                   	push   %rbx
    a8fe:	48 89 f3             	mov    %rsi,%rbx
    a901:	49 89 fe             	mov    %rdi,%r14
    a904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    a909:	48 89 f1             	mov    %rsi,%rcx
    a90c:	ff c0                	inc    %eax
    a90e:	80 39 00             	cmpb   $0x0,(%rcx)
    a911:	48 8d 49 01          	lea    0x1(%rcx),%rcx
    a915:	75 f5                	jne    a90c <_ZN13ostringstream5writeIPKcEEvT_+0x16>
    a917:	85 c0                	test   %eax,%eax
    a919:	7e 21                	jle    a93c <_ZN13ostringstream5writeIPKcEEvT_+0x46>
    a91b:	41 89 c7             	mov    %eax,%r15d
    a91e:	45 31 e4             	xor    %r12d,%r12d
    a921:	42 8a 2c 23          	mov    (%rbx,%r12,1),%bpl
    a925:	41 8b 76 08          	mov    0x8(%r14),%esi
    a929:	4c 89 f7             	mov    %r14,%rdi
    a92c:	e8 39 13 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    a931:	40 88 28             	mov    %bpl,(%rax)
    a934:	49 ff c4             	inc    %r12
    a937:	4d 39 e7             	cmp    %r12,%r15
    a93a:	75 e5                	jne    a921 <_ZN13ostringstream5writeIPKcEEvT_+0x2b>
    a93c:	5b                   	pop    %rbx
    a93d:	41 5c                	pop    %r12
    a93f:	41 5e                	pop    %r14
    a941:	41 5f                	pop    %r15
    a943:	5d                   	pop    %rbp
    a944:	c3                   	ret    

Disassembly of section .text._ZN13ostringstream5writeI8rostringEEvT_:

000000000000a946 <_ZN13ostringstream5writeI8rostringEEvT_>:
    a946:	55                   	push   %rbp
    a947:	41 57                	push   %r15
    a949:	41 56                	push   %r14
    a94b:	41 54                	push   %r12
    a94d:	53                   	push   %rbx
    a94e:	4c 8b 36             	mov    (%rsi),%r14
    a951:	44 8b 7e 08          	mov    0x8(%rsi),%r15d
    a955:	45 85 ff             	test   %r15d,%r15d
    a958:	7e 20                	jle    a97a <_ZN13ostringstream5writeI8rostringEEvT_+0x34>
    a95a:	48 89 fb             	mov    %rdi,%rbx
    a95d:	45 31 e4             	xor    %r12d,%r12d
    a960:	43 8a 2c 26          	mov    (%r14,%r12,1),%bpl
    a964:	8b 73 08             	mov    0x8(%rbx),%esi
    a967:	48 89 df             	mov    %rbx,%rdi
    a96a:	e8 fb 12 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    a96f:	40 88 28             	mov    %bpl,(%rax)
    a972:	49 ff c4             	inc    %r12
    a975:	4d 39 e7             	cmp    %r12,%r15
    a978:	75 e6                	jne    a960 <_ZN13ostringstream5writeI8rostringEEvT_+0x1a>
    a97a:	5b                   	pop    %rbx
    a97b:	41 5c                	pop    %r12
    a97d:	41 5e                	pop    %r14
    a97f:	41 5f                	pop    %r15
    a981:	5d                   	pop    %rbp
    a982:	c3                   	ret    

Disassembly of section .text._ZN13ostringstream7write_iEliicPKc:

000000000000a984 <_ZN13ostringstream7write_iEliicPKc>:
    a984:	55                   	push   %rbp
    a985:	41 57                	push   %r15
    a987:	41 56                	push   %r14
    a989:	41 55                	push   %r13
    a98b:	41 54                	push   %r12
    a98d:	53                   	push   %rbx
    a98e:	50                   	push   %rax
    a98f:	4c 89 cb             	mov    %r9,%rbx
    a992:	45 89 c7             	mov    %r8d,%r15d
    a995:	89 cd                	mov    %ecx,%ebp
    a997:	41 89 d6             	mov    %edx,%r14d
    a99a:	49 89 f4             	mov    %rsi,%r12
    a99d:	49 89 fd             	mov    %rdi,%r13
    a9a0:	48 85 f6             	test   %rsi,%rsi
    a9a3:	79 12                	jns    a9b7 <_ZN13ostringstream7write_iEliicPKc+0x33>
    a9a5:	49 f7 dc             	neg    %r12
    a9a8:	41 8b 75 08          	mov    0x8(%r13),%esi
    a9ac:	4c 89 ef             	mov    %r13,%rdi
    a9af:	e8 b6 12 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    a9b4:	c6 00 2d             	movb   $0x2d,(%rax)
    a9b7:	45 0f be c7          	movsbl %r15b,%r8d
    a9bb:	4c 89 ef             	mov    %r13,%rdi
    a9be:	4c 89 e6             	mov    %r12,%rsi
    a9c1:	44 89 f2             	mov    %r14d,%edx
    a9c4:	89 e9                	mov    %ebp,%ecx
    a9c6:	49 89 d9             	mov    %rbx,%r9
    a9c9:	48 83 c4 08          	add    $0x8,%rsp
    a9cd:	5b                   	pop    %rbx
    a9ce:	41 5c                	pop    %r12
    a9d0:	41 5d                	pop    %r13
    a9d2:	41 5e                	pop    %r14
    a9d4:	41 5f                	pop    %r15
    a9d6:	5d                   	pop    %rbp
    a9d7:	e9 40 03 00 00       	jmp    ad1c <_ZN13ostringstream7write_uEmiicPKc>

Disassembly of section .text._ZN13ostringstream7write_dEdiic:

000000000000a9dc <_ZN13ostringstream7write_dEdiic>:
    a9dc:	55                   	push   %rbp
    a9dd:	41 57                	push   %r15
    a9df:	41 56                	push   %r14
    a9e1:	41 54                	push   %r12
    a9e3:	53                   	push   %rbx
    a9e4:	48 83 ec 50          	sub    $0x50,%rsp
    a9e8:	41 89 ce             	mov    %ecx,%r14d
    a9eb:	48 89 fb             	mov    %rdi,%rbx
    a9ee:	c4 e1 f9 7e c0       	vmovq  %xmm0,%rax
    a9f3:	48 b9 00 00 00 00 00 	movabs $0x7ff0000000000000,%rcx
    a9fa:	00 f0 7f 
    a9fd:	c4 e2 f8 f2 c1       	andn   %rcx,%rax,%rax
    aa02:	75 19                	jne    aa1d <_ZN13ostringstream7write_dEdiic+0x41>
    aa04:	be fe 8d 00 00       	mov    $0x8dfe,%esi
    aa09:	48 89 df             	mov    %rbx,%rdi
    aa0c:	48 83 c4 50          	add    $0x50,%rsp
    aa10:	5b                   	pop    %rbx
    aa11:	41 5c                	pop    %r12
    aa13:	41 5e                	pop    %r14
    aa15:	41 5f                	pop    %r15
    aa17:	5d                   	pop    %rbp
    aa18:	e9 d9 fe ff ff       	jmp    a8f6 <_ZN13ostringstream5writeIPKcEEvT_>
    aa1d:	89 d5                	mov    %edx,%ebp
    aa1f:	41 89 f7             	mov    %esi,%r15d
    aa22:	c5 f1 57 c9          	vxorpd %xmm1,%xmm1,%xmm1
    aa26:	c5 f9 2e c8          	vucomisd %xmm0,%xmm1
    aa2a:	76 2a                	jbe    aa56 <_ZN13ostringstream7write_dEdiic+0x7a>
    aa2c:	c5 fb 12 0d cc de ff 	vmovddup -0x2134(%rip),%xmm1        # 8900 <load_idt+0x1f8>
    aa33:	ff 
    aa34:	c5 f9 57 c1          	vxorpd %xmm1,%xmm0,%xmm0
    aa38:	c5 f9 29 44 24 40    	vmovapd %xmm0,0x40(%rsp)
    aa3e:	8b 73 08             	mov    0x8(%rbx),%esi
    aa41:	48 89 df             	mov    %rbx,%rdi
    aa44:	e8 21 12 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    aa49:	c5 f1 57 c9          	vxorpd %xmm1,%xmm1,%xmm1
    aa4d:	c5 f9 28 44 24 40    	vmovapd 0x40(%rsp),%xmm0
    aa53:	c6 00 2d             	movb   $0x2d,(%rax)
    aa56:	31 c0                	xor    %eax,%eax
    aa58:	c5 f9 29 44 24 40    	vmovapd %xmm0,0x40(%rsp)
    aa5e:	c5 fb 5e 05 8a de ff 	vdivsd -0x2176(%rip),%xmm0,%xmm0        # 88f0 <load_idt+0x1e8>
    aa65:	ff 
    aa66:	ff c0                	inc    %eax
    aa68:	c5 f9 2e c1          	vucomisd %xmm1,%xmm0
    aa6c:	77 f0                	ja     aa5e <_ZN13ostringstream7write_dEdiic+0x82>
    aa6e:	41 29 c7             	sub    %eax,%r15d
    aa71:	7e 1f                	jle    aa92 <_ZN13ostringstream7write_dEdiic+0xb6>
    aa73:	41 ff c7             	inc    %r15d
    aa76:	41 bc 01 00 00 00    	mov    $0x1,%r12d
    aa7c:	8b 73 08             	mov    0x8(%rbx),%esi
    aa7f:	48 89 df             	mov    %rbx,%rdi
    aa82:	e8 e3 11 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    aa87:	44 88 30             	mov    %r14b,(%rax)
    aa8a:	41 ff c4             	inc    %r12d
    aa8d:	45 39 e7             	cmp    %r12d,%r15d
    aa90:	75 ea                	jne    aa7c <_ZN13ostringstream7write_dEdiic+0xa0>
    aa92:	c5 f9 57 c0          	vxorpd %xmm0,%xmm0,%xmm0
    aa96:	4c 8d 74 24 20       	lea    0x20(%rsp),%r14
    aa9b:	c4 c1 79 11 06       	vmovupd %xmm0,(%r14)
    aaa0:	c5 f9 28 4c 24 40    	vmovapd 0x40(%rsp),%xmm1
    aaa6:	c5 fb 11 4c 24 18    	vmovsd %xmm1,0x18(%rsp)
    aaac:	c5 fb 2c c1          	vcvttsd2si %xmm1,%eax
    aab0:	48 98                	cltq   
    aab2:	48 69 c8 67 66 66 66 	imul   $0x66666667,%rax,%rcx
    aab9:	48 89 ca             	mov    %rcx,%rdx
    aabc:	48 c1 ea 3f          	shr    $0x3f,%rdx
    aac0:	48 c1 f9 22          	sar    $0x22,%rcx
    aac4:	01 d1                	add    %edx,%ecx
    aac6:	01 c9                	add    %ecx,%ecx
    aac8:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
    aacb:	29 c8                	sub    %ecx,%eax
    aacd:	04 30                	add    $0x30,%al
    aacf:	0f be f0             	movsbl %al,%esi
    aad2:	4c 89 f7             	mov    %r14,%rdi
    aad5:	31 d2                	xor    %edx,%edx
    aad7:	e8 38 04 00 00       	call   af14 <_ZN6vectorIcE6insertEci>
    aadc:	c5 fb 10 4c 24 18    	vmovsd 0x18(%rsp),%xmm1
    aae2:	c5 f3 5e 0d 06 de ff 	vdivsd -0x21fa(%rip),%xmm1,%xmm1        # 88f0 <load_idt+0x1e8>
    aae9:	ff 
    aaea:	c5 fb 2c c1          	vcvttsd2si %xmm1,%eax
    aaee:	85 c0                	test   %eax,%eax
    aaf0:	7f b4                	jg     aaa6 <_ZN13ostringstream7write_dEdiic+0xca>
    aaf2:	8b 44 24 28          	mov    0x28(%rsp),%eax
    aaf6:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
    aafb:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
    ab00:	89 04 24             	mov    %eax,(%rsp)
    ab03:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
    ab08:	4c 63 3c 24          	movslq (%rsp),%r15
    ab0c:	44 89 7c 24 10       	mov    %r15d,0x10(%rsp)
    ab11:	4c 89 ff             	mov    %r15,%rdi
    ab14:	e8 38 fd ff ff       	call   a851 <_Z16__malloc_trackedmPKci>
    ab19:	49 89 c6             	mov    %rax,%r14
    ab1c:	4d 85 ff             	test   %r15,%r15
    ab1f:	7e 12                	jle    ab33 <_ZN13ostringstream7write_dEdiic+0x157>
    ab21:	31 c0                	xor    %eax,%eax
    ab23:	41 8a 0c 04          	mov    (%r12,%rax,1),%cl
    ab27:	41 88 0c 06          	mov    %cl,(%r14,%rax,1)
    ab2b:	48 ff c0             	inc    %rax
    ab2e:	49 39 c7             	cmp    %rax,%r15
    ab31:	75 f0                	jne    ab23 <_ZN13ostringstream7write_dEdiic+0x147>
    ab33:	8b 44 24 10          	mov    0x10(%rsp),%eax
    ab37:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
    ab3c:	4c 89 36             	mov    %r14,(%rsi)
    ab3f:	89 46 08             	mov    %eax,0x8(%rsi)
    ab42:	48 89 df             	mov    %rbx,%rdi
    ab45:	e8 fc fd ff ff       	call   a946 <_ZN13ostringstream5writeI8rostringEEvT_>
    ab4a:	4d 85 f6             	test   %r14,%r14
    ab4d:	74 32                	je     ab81 <_ZN13ostringstream7write_dEdiic+0x1a5>
    ab4f:	4c 89 f0             	mov    %r14,%rax
    ab52:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
    ab56:	49 8b 4e f0          	mov    -0x10(%r14),%rcx
    ab5a:	c5 f9 10 04 25 00 00 	vmovupd 0x4000000,%xmm0
    ab61:	00 04 
    ab63:	c4 c1 79 11 46 f0    	vmovupd %xmm0,-0x10(%r14)
    ab69:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
    ab70:	04 
    ab71:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
    ab78:	04 
    ab79:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    ab80:	00 
    ab81:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
    ab88:	00 
    ab89:	85 ed                	test   %ebp,%ebp
    ab8b:	0f 8e 45 01 00 00    	jle    acd6 <_ZN13ostringstream7write_dEdiic+0x2fa>
    ab91:	8b 73 08             	mov    0x8(%rbx),%esi
    ab94:	48 89 df             	mov    %rbx,%rdi
    ab97:	e8 ce 10 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    ab9c:	c6 00 2e             	movb   $0x2e,(%rax)
    ab9f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    aba4:	48 85 c0             	test   %rax,%rax
    aba7:	74 2e                	je     abd7 <_ZN13ostringstream7write_dEdiic+0x1fb>
    aba9:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    abad:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    abb1:	c5 f9 10 04 25 00 00 	vmovupd 0x4000000,%xmm0
    abb8:	00 04 
    abba:	c5 f9 11 40 f0       	vmovupd %xmm0,-0x10(%rax)
    abbf:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    abc6:	04 
    abc7:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    abce:	04 
    abcf:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    abd6:	00 
    abd7:	c5 f9 57 c0          	vxorpd %xmm0,%xmm0,%xmm0
    abdb:	4c 8d 74 24 20       	lea    0x20(%rsp),%r14
    abe0:	c4 c1 79 11 06       	vmovupd %xmm0,(%r14)
    abe5:	c5 f9 28 4c 24 40    	vmovapd 0x40(%rsp),%xmm1
    abeb:	c5 f9 e6 c1          	vcvttpd2dq %xmm1,%xmm0
    abef:	c5 fa e6 c0          	vcvtdq2pd %xmm0,%xmm0
    abf3:	c5 f3 5c c8          	vsubsd %xmm0,%xmm1,%xmm1
    abf7:	c5 f3 59 0d f1 dc ff 	vmulsd -0x230f(%rip),%xmm1,%xmm1        # 88f0 <load_idt+0x1e8>
    abfe:	ff 
    abff:	c5 fb 11 4c 24 18    	vmovsd %xmm1,0x18(%rsp)
    ac05:	c5 fb 2c c1          	vcvttsd2si %xmm1,%eax
    ac09:	48 98                	cltq   
    ac0b:	48 69 c8 67 66 66 66 	imul   $0x66666667,%rax,%rcx
    ac12:	48 89 ca             	mov    %rcx,%rdx
    ac15:	48 c1 ea 3f          	shr    $0x3f,%rdx
    ac19:	48 c1 f9 22          	sar    $0x22,%rcx
    ac1d:	01 d1                	add    %edx,%ecx
    ac1f:	01 c9                	add    %ecx,%ecx
    ac21:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
    ac24:	29 c8                	sub    %ecx,%eax
    ac26:	04 30                	add    $0x30,%al
    ac28:	0f be f0             	movsbl %al,%esi
    ac2b:	4c 89 f7             	mov    %r14,%rdi
    ac2e:	31 d2                	xor    %edx,%edx
    ac30:	e8 df 02 00 00       	call   af14 <_ZN6vectorIcE6insertEci>
    ac35:	c5 fb 10 4c 24 18    	vmovsd 0x18(%rsp),%xmm1
    ac3b:	ff cd                	dec    %ebp
    ac3d:	75 b8                	jne    abf7 <_ZN13ostringstream7write_dEdiic+0x21b>
    ac3f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    ac44:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
    ac48:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
    ac4d:	89 0c 24             	mov    %ecx,(%rsp)
    ac50:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
    ac55:	4c 63 3c 24          	movslq (%rsp),%r15
    ac59:	44 89 7c 24 08       	mov    %r15d,0x8(%rsp)
    ac5e:	4c 89 ff             	mov    %r15,%rdi
    ac61:	e8 eb fb ff ff       	call   a851 <_Z16__malloc_trackedmPKci>
    ac66:	49 89 c6             	mov    %rax,%r14
    ac69:	4d 85 ff             	test   %r15,%r15
    ac6c:	7e 12                	jle    ac80 <_ZN13ostringstream7write_dEdiic+0x2a4>
    ac6e:	31 c0                	xor    %eax,%eax
    ac70:	41 8a 0c 04          	mov    (%r12,%rax,1),%cl
    ac74:	41 88 0c 06          	mov    %cl,(%r14,%rax,1)
    ac78:	48 ff c0             	inc    %rax
    ac7b:	49 39 c7             	cmp    %rax,%r15
    ac7e:	75 f0                	jne    ac70 <_ZN13ostringstream7write_dEdiic+0x294>
    ac80:	8b 44 24 08          	mov    0x8(%rsp),%eax
    ac84:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
    ac89:	4c 89 36             	mov    %r14,(%rsi)
    ac8c:	89 46 08             	mov    %eax,0x8(%rsi)
    ac8f:	48 89 df             	mov    %rbx,%rdi
    ac92:	e8 af fc ff ff       	call   a946 <_ZN13ostringstream5writeI8rostringEEvT_>
    ac97:	4d 85 f6             	test   %r14,%r14
    ac9a:	74 32                	je     acce <_ZN13ostringstream7write_dEdiic+0x2f2>
    ac9c:	4c 89 f0             	mov    %r14,%rax
    ac9f:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
    aca3:	49 8b 4e f0          	mov    -0x10(%r14),%rcx
    aca7:	c5 f9 10 04 25 00 00 	vmovupd 0x4000000,%xmm0
    acae:	00 04 
    acb0:	c4 c1 79 11 46 f0    	vmovupd %xmm0,-0x10(%r14)
    acb6:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
    acbd:	04 
    acbe:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
    acc5:	04 
    acc6:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    accd:	00 
    acce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
    acd5:	00 
    acd6:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
    acdb:	48 85 c0             	test   %rax,%rax
    acde:	74 2e                	je     ad0e <_ZN13ostringstream7write_dEdiic+0x332>
    ace0:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    ace4:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    ace8:	c5 f9 10 04 25 00 00 	vmovupd 0x4000000,%xmm0
    acef:	00 04 
    acf1:	c5 f9 11 40 f0       	vmovupd %xmm0,-0x10(%rax)
    acf6:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    acfd:	04 
    acfe:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    ad05:	04 
    ad06:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    ad0d:	00 
    ad0e:	48 83 c4 50          	add    $0x50,%rsp
    ad12:	5b                   	pop    %rbx
    ad13:	41 5c                	pop    %r12
    ad15:	41 5e                	pop    %r14
    ad17:	41 5f                	pop    %r15
    ad19:	5d                   	pop    %rbp
    ad1a:	c3                   	ret    

Disassembly of section .text._ZN13ostringstream7write_uEmiicPKc:

000000000000ad1c <_ZN13ostringstream7write_uEmiicPKc>:
    ad1c:	55                   	push   %rbp
    ad1d:	41 57                	push   %r15
    ad1f:	41 56                	push   %r14
    ad21:	41 55                	push   %r13
    ad23:	41 54                	push   %r12
    ad25:	53                   	push   %rbx
    ad26:	48 83 ec 38          	sub    $0x38,%rsp
    ad2a:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
    ad2f:	45 89 c5             	mov    %r8d,%r13d
    ad32:	41 89 d1             	mov    %edx,%r9d
    ad35:	49 89 f7             	mov    %rsi,%r15
    ad38:	49 89 fe             	mov    %rdi,%r14
    ad3b:	48 63 e9             	movslq %ecx,%rbp
    ad3e:	45 31 e4             	xor    %r12d,%r12d
    ad41:	48 89 f0             	mov    %rsi,%rax
    ad44:	31 d2                	xor    %edx,%edx
    ad46:	48 f7 f5             	div    %rbp
    ad49:	41 ff c4             	inc    %r12d
    ad4c:	48 39 ee             	cmp    %rbp,%rsi
    ad4f:	48 89 c6             	mov    %rax,%rsi
    ad52:	73 ed                	jae    ad41 <_ZN13ostringstream7write_uEmiicPKc+0x25>
    ad54:	45 29 e1             	sub    %r12d,%r9d
    ad57:	7e 24                	jle    ad7d <_ZN13ostringstream7write_uEmiicPKc+0x61>
    ad59:	41 8d 41 01          	lea    0x1(%r9),%eax
    ad5d:	89 44 24 0c          	mov    %eax,0xc(%rsp)
    ad61:	bb 01 00 00 00       	mov    $0x1,%ebx
    ad66:	41 8b 76 08          	mov    0x8(%r14),%esi
    ad6a:	4c 89 f7             	mov    %r14,%rdi
    ad6d:	e8 f8 0e 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    ad72:	44 88 28             	mov    %r13b,(%rax)
    ad75:	ff c3                	inc    %ebx
    ad77:	39 5c 24 0c          	cmp    %ebx,0xc(%rsp)
    ad7b:	75 e9                	jne    ad66 <_ZN13ostringstream7write_uEmiicPKc+0x4a>
    ad7d:	4c 89 f3             	mov    %r14,%rbx
    ad80:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    ad84:	4c 8d 6c 24 18       	lea    0x18(%rsp),%r13
    ad89:	c4 c1 78 11 45 00    	vmovups %xmm0,0x0(%r13)
    ad8f:	4c 89 ef             	mov    %r13,%rdi
    ad92:	44 89 e6             	mov    %r12d,%esi
    ad95:	e8 04 01 00 00       	call   ae9e <_ZN6vectorIcE7reserveEi>
    ad9a:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
    ad9f:	4c 89 f8             	mov    %r15,%rax
    ada2:	31 d2                	xor    %edx,%edx
    ada4:	48 f7 f5             	div    %rbp
    ada7:	49 89 c4             	mov    %rax,%r12
    adaa:	41 0f be 34 16       	movsbl (%r14,%rdx,1),%esi
    adaf:	4c 89 ef             	mov    %r13,%rdi
    adb2:	31 d2                	xor    %edx,%edx
    adb4:	e8 5b 01 00 00       	call   af14 <_ZN6vectorIcE6insertEci>
    adb9:	49 39 ef             	cmp    %rbp,%r15
    adbc:	4d 89 e7             	mov    %r12,%r15
    adbf:	73 de                	jae    ad9f <_ZN13ostringstream7write_uEmiicPKc+0x83>
    adc1:	8b 44 24 20          	mov    0x20(%rsp),%eax
    adc5:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
    adca:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
    adcf:	89 44 24 08          	mov    %eax,0x8(%rsp)
    add3:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
    add8:	4c 63 7c 24 08       	movslq 0x8(%rsp),%r15
    addd:	44 89 3c 24          	mov    %r15d,(%rsp)
    ade1:	4c 89 ff             	mov    %r15,%rdi
    ade4:	e8 68 fa ff ff       	call   a851 <_Z16__malloc_trackedmPKci>
    ade9:	49 89 c6             	mov    %rax,%r14
    adec:	4d 85 ff             	test   %r15,%r15
    adef:	7e 12                	jle    ae03 <_ZN13ostringstream7write_uEmiicPKc+0xe7>
    adf1:	31 c0                	xor    %eax,%eax
    adf3:	41 8a 0c 04          	mov    (%r12,%rax,1),%cl
    adf7:	41 88 0c 06          	mov    %cl,(%r14,%rax,1)
    adfb:	48 ff c0             	inc    %rax
    adfe:	49 39 c7             	cmp    %rax,%r15
    ae01:	75 f0                	jne    adf3 <_ZN13ostringstream7write_uEmiicPKc+0xd7>
    ae03:	8b 04 24             	mov    (%rsp),%eax
    ae06:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
    ae0b:	4c 89 36             	mov    %r14,(%rsi)
    ae0e:	89 46 08             	mov    %eax,0x8(%rsi)
    ae11:	48 89 df             	mov    %rbx,%rdi
    ae14:	e8 2d fb ff ff       	call   a946 <_ZN13ostringstream5writeI8rostringEEvT_>
    ae19:	4d 85 f6             	test   %r14,%r14
    ae1c:	74 32                	je     ae50 <_ZN13ostringstream7write_uEmiicPKc+0x134>
    ae1e:	4c 89 f0             	mov    %r14,%rax
    ae21:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
    ae25:	49 8b 4e f0          	mov    -0x10(%r14),%rcx
    ae29:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    ae30:	00 04 
    ae32:	c4 c1 78 11 46 f0    	vmovups %xmm0,-0x10(%r14)
    ae38:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
    ae3f:	04 
    ae40:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
    ae47:	04 
    ae48:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
    ae4f:	00 
    ae50:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
    ae57:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
    ae5c:	48 85 c0             	test   %rax,%rax
    ae5f:	74 2e                	je     ae8f <_ZN13ostringstream7write_uEmiicPKc+0x173>
    ae61:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    ae65:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    ae69:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    ae70:	00 04 
    ae72:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    ae77:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    ae7e:	04 
    ae7f:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    ae86:	04 
    ae87:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    ae8e:	00 
    ae8f:	48 83 c4 38          	add    $0x38,%rsp
    ae93:	5b                   	pop    %rbx
    ae94:	41 5c                	pop    %r12
    ae96:	41 5d                	pop    %r13
    ae98:	41 5e                	pop    %r14
    ae9a:	41 5f                	pop    %r15
    ae9c:	5d                   	pop    %rbp
    ae9d:	c3                   	ret    

Disassembly of section .text._ZN6vectorIcE7reserveEi:

000000000000ae9e <_ZN6vectorIcE7reserveEi>:
    ae9e:	39 77 0c             	cmp    %esi,0xc(%rdi)
    aea1:	7d 6f                	jge    af12 <_ZN6vectorIcE7reserveEi+0x74>
    aea3:	41 56                	push   %r14
    aea5:	53                   	push   %rbx
    aea6:	50                   	push   %rax
    aea7:	89 f3                	mov    %esi,%ebx
    aea9:	49 89 fe             	mov    %rdi,%r14
    aeac:	48 63 fe             	movslq %esi,%rdi
    aeaf:	e8 9d f9 ff ff       	call   a851 <_Z16__malloc_trackedmPKci>
    aeb4:	49 8b 0e             	mov    (%r14),%rcx
    aeb7:	48 85 c9             	test   %rcx,%rcx
    aeba:	74 48                	je     af04 <_ZN6vectorIcE7reserveEi+0x66>
    aebc:	41 8b 56 08          	mov    0x8(%r14),%edx
    aec0:	85 d2                	test   %edx,%edx
    aec2:	7e 12                	jle    aed6 <_ZN6vectorIcE7reserveEi+0x38>
    aec4:	31 f6                	xor    %esi,%esi
    aec6:	40 8a 3c 31          	mov    (%rcx,%rsi,1),%dil
    aeca:	40 88 3c 30          	mov    %dil,(%rax,%rsi,1)
    aece:	48 ff c6             	inc    %rsi
    aed1:	48 39 f2             	cmp    %rsi,%rdx
    aed4:	75 f0                	jne    aec6 <_ZN6vectorIcE7reserveEi+0x28>
    aed6:	48 8d 51 f0          	lea    -0x10(%rcx),%rdx
    aeda:	48 8b 71 f0          	mov    -0x10(%rcx),%rsi
    aede:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    aee5:	00 04 
    aee7:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
    aeec:	48 89 34 25 00 00 00 	mov    %rsi,0x4000000
    aef3:	04 
    aef4:	48 89 14 25 08 00 00 	mov    %rdx,0x4000008
    aefb:	04 
    aefc:	48 29 34 25 28 00 11 	sub    %rsi,0x110028
    af03:	00 
    af04:	49 89 06             	mov    %rax,(%r14)
    af07:	41 89 5e 0c          	mov    %ebx,0xc(%r14)
    af0b:	48 83 c4 08          	add    $0x8,%rsp
    af0f:	5b                   	pop    %rbx
    af10:	41 5e                	pop    %r14
    af12:	c3                   	ret    

Disassembly of section .text._ZN6vectorIcE6insertEci:

000000000000af14 <_ZN6vectorIcE6insertEci>:
    af14:	55                   	push   %rbp
    af15:	41 57                	push   %r15
    af17:	41 56                	push   %r14
    af19:	41 55                	push   %r13
    af1b:	41 54                	push   %r12
    af1d:	53                   	push   %rbx
    af1e:	50                   	push   %rax
    af1f:	89 d5                	mov    %edx,%ebp
    af21:	89 f3                	mov    %esi,%ebx
    af23:	49 89 fe             	mov    %rdi,%r14
    af26:	8b 47 08             	mov    0x8(%rdi),%eax
    af29:	39 d0                	cmp    %edx,%eax
    af2b:	7e 67                	jle    af94 <_ZN6vectorIcE6insertEci+0x80>
    af2d:	41 8b 46 08          	mov    0x8(%r14),%eax
    af31:	4c 63 e0             	movslq %eax,%r12
    af34:	49 8b 06             	mov    (%r14),%rax
    af37:	4d 8d 7c 24 ff       	lea    -0x1(%r12),%r15
    af3c:	46 8a 6c 20 ff       	mov    -0x1(%rax,%r12,1),%r13b
    af41:	4c 89 f7             	mov    %r14,%rdi
    af44:	44 89 e6             	mov    %r12d,%esi
    af47:	e8 1e 0d 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    af4c:	44 88 28             	mov    %r13b,(%rax)
    af4f:	41 39 ef             	cmp    %ebp,%r15d
    af52:	7e 3b                	jle    af8f <_ZN6vectorIcE6insertEci+0x7b>
    af54:	48 b8 00 00 00 00 ff 	movabs $0xffffffff00000000,%rax
    af5b:	ff ff ff 
    af5e:	48 63 cd             	movslq %ebp,%rcx
    af61:	41 8d 54 24 fe       	lea    -0x2(%r12),%edx
    af66:	49 c1 e4 20          	shl    $0x20,%r12
    af6a:	49 01 c4             	add    %rax,%r12
    af6d:	49 8b 36             	mov    (%r14),%rsi
    af70:	48 63 d2             	movslq %edx,%rdx
    af73:	40 8a 3c 16          	mov    (%rsi,%rdx,1),%dil
    af77:	42 88 3c 3e          	mov    %dil,(%rsi,%r15,1)
    af7b:	49 ff cf             	dec    %r15
    af7e:	ff ca                	dec    %edx
    af80:	49 01 c4             	add    %rax,%r12
    af83:	49 39 cf             	cmp    %rcx,%r15
    af86:	7f e5                	jg     af6d <_ZN6vectorIcE6insertEci+0x59>
    af88:	49 c1 fc 20          	sar    $0x20,%r12
    af8c:	4d 89 e7             	mov    %r12,%r15
    af8f:	4d 03 3e             	add    (%r14),%r15
    af92:	eb 0d                	jmp    afa1 <_ZN6vectorIcE6insertEci+0x8d>
    af94:	4c 89 f7             	mov    %r14,%rdi
    af97:	89 ee                	mov    %ebp,%esi
    af99:	e8 cc 0c 00 00       	call   bc6a <_ZN6vectorIcE2atEi>
    af9e:	49 89 c7             	mov    %rax,%r15
    afa1:	41 88 1f             	mov    %bl,(%r15)
    afa4:	48 83 c4 08          	add    $0x8,%rsp
    afa8:	5b                   	pop    %rbx
    afa9:	41 5c                	pop    %r12
    afab:	41 5d                	pop    %r13
    afad:	41 5e                	pop    %r14
    afaf:	41 5f                	pop    %r15
    afb1:	5d                   	pop    %rbp
    afb2:	c3                   	ret    

Disassembly of section .text._ZN4spanIcE2atEi:

000000000000afb4 <_ZN4spanIcE2atEi>:
    afb4:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    afb8:	74 07                	je     afc1 <_ZN4spanIcE2atEi+0xd>
    afba:	48 63 c6             	movslq %esi,%rax
    afbd:	48 03 07             	add    (%rdi),%rax
    afc0:	c3                   	ret    
    afc1:	53                   	push   %rbx
    afc2:	b0 4f                	mov    $0x4f,%al
    afc4:	48 c7 c3 eb ff ff ff 	mov    $0xffffffffffffffeb,%rbx
    afcb:	0f be f0             	movsbl %al,%esi
    afce:	bf 00 00 11 00       	mov    $0x110000,%edi
    afd3:	e8 da f7 ff ff       	call   a7b2 <_ZN7console7putcharEc>
    afd8:	8a 83 d4 8d 00 00    	mov    0x8dd4(%rbx),%al
    afde:	48 ff c3             	inc    %rbx
    afe1:	75 e8                	jne    afcb <_ZN4spanIcE2atEi+0x17>
    afe3:	bf 01 00 00 00       	mov    $0x1,%edi
    afe8:	e8 64 f8 ff ff       	call   a851 <_Z16__malloc_trackedmPKci>
    afed:	c6 00 00             	movb   $0x0,(%rax)
    aff0:	5b                   	pop    %rbx
    aff1:	c3                   	ret    

Disassembly of section .text._ZN13istringstream4readIlEET_v:

000000000000aff2 <_ZN13istringstream4readIlEET_v>:
    aff2:	55                   	push   %rbp
    aff3:	41 57                	push   %r15
    aff5:	41 56                	push   %r14
    aff7:	41 54                	push   %r12
    aff9:	53                   	push   %rbx
    affa:	48 89 fb             	mov    %rdi,%rbx
    affd:	44 8b 77 10          	mov    0x10(%rdi),%r14d
    b001:	45 8d 7e 01          	lea    0x1(%r14),%r15d
    b005:	44 89 7f 10          	mov    %r15d,0x10(%rdi)
    b009:	44 89 f6             	mov    %r14d,%esi
    b00c:	e8 a3 ff ff ff       	call   afb4 <_ZN4spanIcE2atEi>
    b011:	40 8a 28             	mov    (%rax),%bpl
    b014:	40 80 fd 2d          	cmp    $0x2d,%bpl
    b018:	75 17                	jne    b031 <_ZN13istringstream4readIlEET_v+0x3f>
    b01a:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
    b01e:	48 89 df             	mov    %rbx,%rdi
    b021:	44 89 f6             	mov    %r14d,%esi
    b024:	e8 8b ff ff ff       	call   afb4 <_ZN4spanIcE2atEi>
    b029:	44 8b 73 10          	mov    0x10(%rbx),%r14d
    b02d:	45 8d 7e 01          	lea    0x1(%r14),%r15d
    b031:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
    b035:	48 89 df             	mov    %rbx,%rdi
    b038:	44 89 f6             	mov    %r14d,%esi
    b03b:	e8 74 ff ff ff       	call   afb4 <_ZN4spanIcE2atEi>
    b040:	8a 00                	mov    (%rax),%al
    b042:	44 89 73 10          	mov    %r14d,0x10(%rbx)
    b046:	45 31 e4             	xor    %r12d,%r12d
    b049:	3c 30                	cmp    $0x30,%al
    b04b:	7c 59                	jl     b0a6 <_ZN13istringstream4readIlEET_v+0xb4>
    b04d:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
    b051:	48 89 df             	mov    %rbx,%rdi
    b054:	44 89 f6             	mov    %r14d,%esi
    b057:	e8 58 ff ff ff       	call   afb4 <_ZN4spanIcE2atEi>
    b05c:	8a 00                	mov    (%rax),%al
    b05e:	44 89 73 10          	mov    %r14d,0x10(%rbx)
    b062:	3c 39                	cmp    $0x39,%al
    b064:	7f 40                	jg     b0a6 <_ZN13istringstream4readIlEET_v+0xb4>
    b066:	4f 8d 24 a4          	lea    (%r12,%r12,4),%r12
    b06a:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
    b06e:	48 89 df             	mov    %rbx,%rdi
    b071:	44 89 f6             	mov    %r14d,%esi
    b074:	e8 3b ff ff ff       	call   afb4 <_ZN4spanIcE2atEi>
    b079:	48 0f be 00          	movsbq (%rax),%rax
    b07d:	4e 8d 24 60          	lea    (%rax,%r12,2),%r12
    b081:	49 83 c4 d0          	add    $0xffffffffffffffd0,%r12
    b085:	44 8b 73 10          	mov    0x10(%rbx),%r14d
    b089:	45 8d 7e 01          	lea    0x1(%r14),%r15d
    b08d:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
    b091:	48 89 df             	mov    %rbx,%rdi
    b094:	44 89 f6             	mov    %r14d,%esi
    b097:	e8 18 ff ff ff       	call   afb4 <_ZN4spanIcE2atEi>
    b09c:	8a 00                	mov    (%rax),%al
    b09e:	44 89 73 10          	mov    %r14d,0x10(%rbx)
    b0a2:	3c 2f                	cmp    $0x2f,%al
    b0a4:	7f a7                	jg     b04d <_ZN13istringstream4readIlEET_v+0x5b>
    b0a6:	4c 89 e0             	mov    %r12,%rax
    b0a9:	48 f7 d8             	neg    %rax
    b0ac:	40 80 fd 2d          	cmp    $0x2d,%bpl
    b0b0:	49 0f 45 c4          	cmovne %r12,%rax
    b0b4:	5b                   	pop    %rbx
    b0b5:	41 5c                	pop    %r12
    b0b7:	41 5e                	pop    %r14
    b0b9:	41 5f                	pop    %r15
    b0bb:	5d                   	pop    %rbp
    b0bc:	c3                   	ret    

Disassembly of section .text._ZN13istringstream14read_until_incE8rostring:

000000000000b0be <_ZN13istringstream14read_until_incE8rostring>:
    b0be:	55                   	push   %rbp
    b0bf:	41 57                	push   %r15
    b0c1:	41 56                	push   %r14
    b0c3:	53                   	push   %rbx
    b0c4:	50                   	push   %rax
    b0c5:	49 89 d7             	mov    %rdx,%r15
    b0c8:	49 89 f6             	mov    %rsi,%r14
    b0cb:	48 89 fb             	mov    %rdi,%rbx
    b0ce:	8b 6e 10             	mov    0x10(%rsi),%ebp
    b0d1:	48 89 f7             	mov    %rsi,%rdi
    b0d4:	89 ee                	mov    %ebp,%esi
    b0d6:	e8 d9 fe ff ff       	call   afb4 <_ZN4spanIcE2atEi>
    b0db:	4c 89 ff             	mov    %r15,%rdi
    b0de:	48 89 c6             	mov    %rax,%rsi
    b0e1:	e8 b4 0a 00 00       	call   bb9a <_ZNK4spanIcE4findERKc>
    b0e6:	85 c0                	test   %eax,%eax
    b0e8:	79 15                	jns    b0ff <_ZN13istringstream14read_until_incE8rostring+0x41>
    b0ea:	41 8b 76 10          	mov    0x10(%r14),%esi
    b0ee:	41 3b 76 08          	cmp    0x8(%r14),%esi
    b0f2:	7d 0b                	jge    b0ff <_ZN13istringstream14read_until_incE8rostring+0x41>
    b0f4:	ff c6                	inc    %esi
    b0f6:	41 89 76 10          	mov    %esi,0x10(%r14)
    b0fa:	4c 89 f7             	mov    %r14,%rdi
    b0fd:	eb d7                	jmp    b0d6 <_ZN13istringstream14read_until_incE8rostring+0x18>
    b0ff:	48 63 c5             	movslq %ebp,%rax
    b102:	41 8b 4e 10          	mov    0x10(%r14),%ecx
    b106:	41 3b 4e 08          	cmp    0x8(%r14),%ecx
    b10a:	7d 06                	jge    b112 <_ZN13istringstream14read_until_incE8rostring+0x54>
    b10c:	ff c1                	inc    %ecx
    b10e:	41 89 4e 10          	mov    %ecx,0x10(%r14)
    b112:	29 e9                	sub    %ebp,%ecx
    b114:	49 03 06             	add    (%r14),%rax
    b117:	48 89 03             	mov    %rax,(%rbx)
    b11a:	89 4b 08             	mov    %ecx,0x8(%rbx)
    b11d:	48 89 d8             	mov    %rbx,%rax
    b120:	48 83 c4 08          	add    $0x8,%rsp
    b124:	5b                   	pop    %rbx
    b125:	41 5e                	pop    %r14
    b127:	41 5f                	pop    %r15
    b129:	5d                   	pop    %rbp
    b12a:	c3                   	ret    

Disassembly of section .text._ZN6vectorIcED2Ev:

000000000000b12c <_ZN6vectorIcED2Ev>:
    b12c:	48 8b 07             	mov    (%rdi),%rax
    b12f:	48 85 c0             	test   %rax,%rax
    b132:	74 2e                	je     b162 <_ZN6vectorIcED2Ev+0x36>
    b134:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b138:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b13c:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b143:	00 04 
    b145:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b14a:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b151:	04 
    b152:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b159:	04 
    b15a:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b161:	00 
    b162:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    b166:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
    b16a:	c3                   	ret    

Disassembly of section .text._Z16handle_exceptionimmP13register_file:

000000000000b16b <_Z16handle_exceptionimmP13register_file>:
    b16b:	41 57                	push   %r15
    b16d:	41 56                	push   %r14
    b16f:	53                   	push   %rbx
    b170:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
    b177:	49 89 ce             	mov    %rcx,%r14
    b17a:	48 89 d1             	mov    %rdx,%rcx
    b17d:	48 89 f2             	mov    %rsi,%rdx
    b180:	89 fb                	mov    %edi,%ebx
    b182:	48 c7 44 24 10 87 8a 	movq   $0x8a87,0x10(%rsp)
    b189:	00 00 
    b18b:	c7 44 24 18 1e 00 00 	movl   $0x1e,0x18(%rsp)
    b192:	00 
    b193:	41 b8 ba 8d 00 00    	mov    $0x8dba,%r8d
    b199:	48 83 fe 1f          	cmp    $0x1f,%rsi
    b19d:	77 08                	ja     b1a7 <_Z16handle_exceptionimmP13register_file+0x3c>
    b19f:	4c 8b 04 d5 60 91 00 	mov    0x9160(,%rdx,8),%r8
    b1a6:	00 
    b1a7:	49 89 e7             	mov    %rsp,%r15
    b1aa:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
    b1af:	4c 89 ff             	mov    %r15,%rdi
    b1b2:	31 c0                	xor    %eax,%eax
    b1b4:	e8 c6 e6 ff ff       	call   987f <_Z6format8rostringz>
    b1b9:	4c 89 ff             	mov    %r15,%rdi
    b1bc:	e8 75 ed ff ff       	call   9f36 <_ZN6string10c_str_thisEv>
    b1c1:	49 89 c7             	mov    %rax,%r15
    b1c4:	8a 00                	mov    (%rax),%al
    b1c6:	84 c0                	test   %al,%al
    b1c8:	74 1a                	je     b1e4 <_Z16handle_exceptionimmP13register_file+0x79>
    b1ca:	49 ff c7             	inc    %r15
    b1cd:	0f be f0             	movsbl %al,%esi
    b1d0:	bf 00 00 11 00       	mov    $0x110000,%edi
    b1d5:	e8 d8 f5 ff ff       	call   a7b2 <_ZN7console7putcharEc>
    b1da:	41 8a 07             	mov    (%r15),%al
    b1dd:	49 ff c7             	inc    %r15
    b1e0:	84 c0                	test   %al,%al
    b1e2:	75 e9                	jne    b1cd <_Z16handle_exceptionimmP13register_file+0x62>
    b1e4:	48 8b 04 24          	mov    (%rsp),%rax
    b1e8:	48 85 c0             	test   %rax,%rax
    b1eb:	74 2e                	je     b21b <_Z16handle_exceptionimmP13register_file+0xb0>
    b1ed:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b1f1:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b1f5:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b1fc:	00 04 
    b1fe:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b203:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b20a:	04 
    b20b:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b212:	04 
    b213:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b21a:	00 
    b21b:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
    b220:	48 c7 06 15 8f 00 00 	movq   $0x8f15,(%rsi)
    b227:	c7 46 08 10 00 00 00 	movl   $0x10,0x8(%rsi)
    b22e:	49 8b 8e 80 00 00 00 	mov    0x80(%r14),%rcx
    b235:	49 8b 96 90 00 00 00 	mov    0x90(%r14),%rdx
    b23c:	49 89 e7             	mov    %rsp,%r15
    b23f:	4c 89 ff             	mov    %r15,%rdi
    b242:	31 c0                	xor    %eax,%eax
    b244:	e8 36 e6 ff ff       	call   987f <_Z6format8rostringz>
    b249:	4c 89 ff             	mov    %r15,%rdi
    b24c:	e8 e5 ec ff ff       	call   9f36 <_ZN6string10c_str_thisEv>
    b251:	49 89 c7             	mov    %rax,%r15
    b254:	8a 00                	mov    (%rax),%al
    b256:	84 c0                	test   %al,%al
    b258:	74 1a                	je     b274 <_Z16handle_exceptionimmP13register_file+0x109>
    b25a:	49 ff c7             	inc    %r15
    b25d:	0f be f0             	movsbl %al,%esi
    b260:	bf 00 00 11 00       	mov    $0x110000,%edi
    b265:	e8 48 f5 ff ff       	call   a7b2 <_ZN7console7putcharEc>
    b26a:	41 8a 07             	mov    (%r15),%al
    b26d:	49 ff c7             	inc    %r15
    b270:	84 c0                	test   %al,%al
    b272:	75 e9                	jne    b25d <_Z16handle_exceptionimmP13register_file+0xf2>
    b274:	48 8b 04 24          	mov    (%rsp),%rax
    b278:	48 85 c0             	test   %rax,%rax
    b27b:	74 2e                	je     b2ab <_Z16handle_exceptionimmP13register_file+0x140>
    b27d:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b281:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b285:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b28c:	00 04 
    b28e:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b293:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b29a:	04 
    b29b:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b2a2:	04 
    b2a3:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b2aa:	00 
    b2ab:	b0 52                	mov    $0x52,%al
    b2ad:	49 c7 c7 f0 ff ff ff 	mov    $0xfffffffffffffff0,%r15
    b2b4:	0f be f0             	movsbl %al,%esi
    b2b7:	bf 00 00 11 00       	mov    $0x110000,%edi
    b2bc:	e8 f1 f4 ff ff       	call   a7b2 <_ZN7console7putcharEc>
    b2c1:	41 8a 87 46 8c 00 00 	mov    0x8c46(%r15),%al
    b2c8:	49 ff c7             	inc    %r15
    b2cb:	75 e7                	jne    b2b4 <_Z16handle_exceptionimmP13register_file+0x149>
    b2cd:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
    b2d2:	48 c7 06 76 8e 00 00 	movq   $0x8e76,(%rsi)
    b2d9:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
    b2e0:	49 8b 16             	mov    (%r14),%rdx
    b2e3:	49 8b 4e 08          	mov    0x8(%r14),%rcx
    b2e7:	4d 8b 46 10          	mov    0x10(%r14),%r8
    b2eb:	4d 8b 4e 18          	mov    0x18(%r14),%r9
    b2ef:	49 89 e7             	mov    %rsp,%r15
    b2f2:	4c 89 ff             	mov    %r15,%rdi
    b2f5:	31 c0                	xor    %eax,%eax
    b2f7:	e8 83 e5 ff ff       	call   987f <_Z6format8rostringz>
    b2fc:	4c 89 ff             	mov    %r15,%rdi
    b2ff:	e8 32 ec ff ff       	call   9f36 <_ZN6string10c_str_thisEv>
    b304:	49 89 c7             	mov    %rax,%r15
    b307:	8a 00                	mov    (%rax),%al
    b309:	84 c0                	test   %al,%al
    b30b:	74 1a                	je     b327 <_Z16handle_exceptionimmP13register_file+0x1bc>
    b30d:	49 ff c7             	inc    %r15
    b310:	0f be f0             	movsbl %al,%esi
    b313:	bf 00 00 11 00       	mov    $0x110000,%edi
    b318:	e8 95 f4 ff ff       	call   a7b2 <_ZN7console7putcharEc>
    b31d:	41 8a 07             	mov    (%r15),%al
    b320:	49 ff c7             	inc    %r15
    b323:	84 c0                	test   %al,%al
    b325:	75 e9                	jne    b310 <_Z16handle_exceptionimmP13register_file+0x1a5>
    b327:	48 8b 04 24          	mov    (%rsp),%rax
    b32b:	48 85 c0             	test   %rax,%rax
    b32e:	74 2e                	je     b35e <_Z16handle_exceptionimmP13register_file+0x1f3>
    b330:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b334:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b338:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b33f:	00 04 
    b341:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b346:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b34d:	04 
    b34e:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b355:	04 
    b356:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b35d:	00 
    b35e:	48 8d 74 24 50       	lea    0x50(%rsp),%rsi
    b363:	48 c7 06 76 8e 00 00 	movq   $0x8e76,(%rsi)
    b36a:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
    b371:	49 8b 56 20          	mov    0x20(%r14),%rdx
    b375:	49 8b 4e 28          	mov    0x28(%r14),%rcx
    b379:	4d 8b 46 30          	mov    0x30(%r14),%r8
    b37d:	4d 8b 4e 38          	mov    0x38(%r14),%r9
    b381:	49 89 e7             	mov    %rsp,%r15
    b384:	4c 89 ff             	mov    %r15,%rdi
    b387:	31 c0                	xor    %eax,%eax
    b389:	e8 f1 e4 ff ff       	call   987f <_Z6format8rostringz>
    b38e:	4c 89 ff             	mov    %r15,%rdi
    b391:	e8 a0 eb ff ff       	call   9f36 <_ZN6string10c_str_thisEv>
    b396:	49 89 c7             	mov    %rax,%r15
    b399:	8a 00                	mov    (%rax),%al
    b39b:	84 c0                	test   %al,%al
    b39d:	74 1a                	je     b3b9 <_Z16handle_exceptionimmP13register_file+0x24e>
    b39f:	49 ff c7             	inc    %r15
    b3a2:	0f be f0             	movsbl %al,%esi
    b3a5:	bf 00 00 11 00       	mov    $0x110000,%edi
    b3aa:	e8 03 f4 ff ff       	call   a7b2 <_ZN7console7putcharEc>
    b3af:	41 8a 07             	mov    (%r15),%al
    b3b2:	49 ff c7             	inc    %r15
    b3b5:	84 c0                	test   %al,%al
    b3b7:	75 e9                	jne    b3a2 <_Z16handle_exceptionimmP13register_file+0x237>
    b3b9:	48 8b 04 24          	mov    (%rsp),%rax
    b3bd:	48 85 c0             	test   %rax,%rax
    b3c0:	74 2e                	je     b3f0 <_Z16handle_exceptionimmP13register_file+0x285>
    b3c2:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b3c6:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b3ca:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b3d1:	00 04 
    b3d3:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b3d8:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b3df:	04 
    b3e0:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b3e7:	04 
    b3e8:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b3ef:	00 
    b3f0:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
    b3f5:	48 c7 06 76 8e 00 00 	movq   $0x8e76,(%rsi)
    b3fc:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
    b403:	49 8b 56 40          	mov    0x40(%r14),%rdx
    b407:	49 8b 4e 48          	mov    0x48(%r14),%rcx
    b40b:	4d 8b 46 50          	mov    0x50(%r14),%r8
    b40f:	4d 8b 4e 58          	mov    0x58(%r14),%r9
    b413:	49 89 e7             	mov    %rsp,%r15
    b416:	4c 89 ff             	mov    %r15,%rdi
    b419:	31 c0                	xor    %eax,%eax
    b41b:	e8 5f e4 ff ff       	call   987f <_Z6format8rostringz>
    b420:	4c 89 ff             	mov    %r15,%rdi
    b423:	e8 0e eb ff ff       	call   9f36 <_ZN6string10c_str_thisEv>
    b428:	49 89 c7             	mov    %rax,%r15
    b42b:	8a 00                	mov    (%rax),%al
    b42d:	84 c0                	test   %al,%al
    b42f:	74 1a                	je     b44b <_Z16handle_exceptionimmP13register_file+0x2e0>
    b431:	49 ff c7             	inc    %r15
    b434:	0f be f0             	movsbl %al,%esi
    b437:	bf 00 00 11 00       	mov    $0x110000,%edi
    b43c:	e8 71 f3 ff ff       	call   a7b2 <_ZN7console7putcharEc>
    b441:	41 8a 07             	mov    (%r15),%al
    b444:	49 ff c7             	inc    %r15
    b447:	84 c0                	test   %al,%al
    b449:	75 e9                	jne    b434 <_Z16handle_exceptionimmP13register_file+0x2c9>
    b44b:	48 8b 04 24          	mov    (%rsp),%rax
    b44f:	48 85 c0             	test   %rax,%rax
    b452:	74 2e                	je     b482 <_Z16handle_exceptionimmP13register_file+0x317>
    b454:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b458:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b45c:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b463:	00 04 
    b465:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b46a:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b471:	04 
    b472:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b479:	04 
    b47a:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b481:	00 
    b482:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
    b487:	48 c7 06 76 8e 00 00 	movq   $0x8e76,(%rsi)
    b48e:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
    b495:	49 8b 56 60          	mov    0x60(%r14),%rdx
    b499:	49 8b 4e 68          	mov    0x68(%r14),%rcx
    b49d:	4d 8b 46 70          	mov    0x70(%r14),%r8
    b4a1:	4d 8b 4e 78          	mov    0x78(%r14),%r9
    b4a5:	49 89 e6             	mov    %rsp,%r14
    b4a8:	4c 89 f7             	mov    %r14,%rdi
    b4ab:	31 c0                	xor    %eax,%eax
    b4ad:	e8 cd e3 ff ff       	call   987f <_Z6format8rostringz>
    b4b2:	4c 89 f7             	mov    %r14,%rdi
    b4b5:	e8 7c ea ff ff       	call   9f36 <_ZN6string10c_str_thisEv>
    b4ba:	49 89 c6             	mov    %rax,%r14
    b4bd:	8a 00                	mov    (%rax),%al
    b4bf:	84 c0                	test   %al,%al
    b4c1:	74 1a                	je     b4dd <_Z16handle_exceptionimmP13register_file+0x372>
    b4c3:	49 ff c6             	inc    %r14
    b4c6:	0f be f0             	movsbl %al,%esi
    b4c9:	bf 00 00 11 00       	mov    $0x110000,%edi
    b4ce:	e8 df f2 ff ff       	call   a7b2 <_ZN7console7putcharEc>
    b4d3:	41 8a 06             	mov    (%r14),%al
    b4d6:	49 ff c6             	inc    %r14
    b4d9:	84 c0                	test   %al,%al
    b4db:	75 e9                	jne    b4c6 <_Z16handle_exceptionimmP13register_file+0x35b>
    b4dd:	48 8b 04 24          	mov    (%rsp),%rax
    b4e1:	48 85 c0             	test   %rax,%rax
    b4e4:	74 2e                	je     b514 <_Z16handle_exceptionimmP13register_file+0x3a9>
    b4e6:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b4ea:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b4ee:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b4f5:	00 04 
    b4f7:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b4fc:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b503:	04 
    b504:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b50b:	04 
    b50c:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b513:	00 
    b514:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
    b519:	48 c7 06 76 8e 00 00 	movq   $0x8e76,(%rsi)
    b520:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
    b527:	0f 20 c2             	mov    %cr0,%rdx
    b52a:	0f 20 d1             	mov    %cr2,%rcx
    b52d:	41 0f 20 d8          	mov    %cr3,%r8
    b531:	41 0f 20 e1          	mov    %cr4,%r9
    b535:	49 89 e6             	mov    %rsp,%r14
    b538:	4c 89 f7             	mov    %r14,%rdi
    b53b:	31 c0                	xor    %eax,%eax
    b53d:	e8 3d e3 ff ff       	call   987f <_Z6format8rostringz>
    b542:	4c 89 f7             	mov    %r14,%rdi
    b545:	e8 ec e9 ff ff       	call   9f36 <_ZN6string10c_str_thisEv>
    b54a:	49 89 c6             	mov    %rax,%r14
    b54d:	8a 00                	mov    (%rax),%al
    b54f:	84 c0                	test   %al,%al
    b551:	74 1a                	je     b56d <_Z16handle_exceptionimmP13register_file+0x402>
    b553:	49 ff c6             	inc    %r14
    b556:	0f be f0             	movsbl %al,%esi
    b559:	bf 00 00 11 00       	mov    $0x110000,%edi
    b55e:	e8 4f f2 ff ff       	call   a7b2 <_ZN7console7putcharEc>
    b563:	41 8a 06             	mov    (%r14),%al
    b566:	49 ff c6             	inc    %r14
    b569:	84 c0                	test   %al,%al
    b56b:	75 e9                	jne    b556 <_Z16handle_exceptionimmP13register_file+0x3eb>
    b56d:	48 8b 04 24          	mov    (%rsp),%rax
    b571:	48 85 c0             	test   %rax,%rax
    b574:	74 2e                	je     b5a4 <_Z16handle_exceptionimmP13register_file+0x439>
    b576:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b57a:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b57e:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b585:	00 04 
    b587:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b58c:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b593:	04 
    b594:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b59b:	04 
    b59c:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b5a3:	00 
    b5a4:	85 db                	test   %ebx,%ebx
    b5a6:	74 11                	je     b5b9 <_Z16handle_exceptionimmP13register_file+0x44e>
    b5a8:	bf 00 00 11 00       	mov    $0x110000,%edi
    b5ad:	be 2c 8d 00 00       	mov    $0x8d2c,%esi
    b5b2:	e8 99 e2 ff ff       	call   9850 <_ZN7console6putstrEPKc>
    b5b7:	eb fe                	jmp    b5b7 <_Z16handle_exceptionimmP13register_file+0x44c>
    b5b9:	48 81 c4 80 00 00 00 	add    $0x80,%rsp
    b5c0:	5b                   	pop    %rbx
    b5c1:	41 5e                	pop    %r14
    b5c3:	41 5f                	pop    %r15
    b5c5:	c3                   	ret    

Disassembly of section .text.isr_err:

000000000000b5c6 <isr_err>:
    b5c6:	55                   	push   %rbp
    b5c7:	48 89 e5             	mov    %rsp,%rbp
    b5ca:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    b5ce:	48 89 f1             	mov    %rsi,%rcx
    b5d1:	48 89 fe             	mov    %rdi,%rsi
    b5d4:	bf 01 00 00 00       	mov    $0x1,%edi
    b5d9:	e8 8d fb ff ff       	call   b16b <_Z16handle_exceptionimmP13register_file>
    b5de:	48 89 ec             	mov    %rbp,%rsp
    b5e1:	5d                   	pop    %rbp
    b5e2:	c3                   	ret    

Disassembly of section .text.isr_no_err:

000000000000b5e3 <isr_no_err>:
    b5e3:	55                   	push   %rbp
    b5e4:	48 89 e5             	mov    %rsp,%rbp
    b5e7:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    b5eb:	48 89 f1             	mov    %rsi,%rcx
    b5ee:	48 89 fe             	mov    %rdi,%rsi
    b5f1:	31 ff                	xor    %edi,%edi
    b5f3:	31 d2                	xor    %edx,%edx
    b5f5:	e8 71 fb ff ff       	call   b16b <_Z16handle_exceptionimmP13register_file>
    b5fa:	48 89 ec             	mov    %rbp,%rsp
    b5fd:	5d                   	pop    %rbp
    b5fe:	c3                   	ret    

Disassembly of section .text.irq_isr:

000000000000b5ff <irq_isr>:
    b5ff:	55                   	push   %rbp
    b600:	48 89 e5             	mov    %rsp,%rbp
    b603:	53                   	push   %rbx
    b604:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    b608:	48 83 ec 10          	sub    $0x10,%rsp
    b60c:	48 8d 5f e0          	lea    -0x20(%rdi),%rbx
    b610:	48 8b 04 fd 40 ff 10 	mov    0x10ff40(,%rdi,8),%rax
    b617:	00 
    b618:	48 85 c0             	test   %rax,%rax
    b61b:	74 04                	je     b621 <irq_isr+0x22>
    b61d:	ff d0                	call   *%rax
    b61f:	eb 0f                	jmp    b630 <irq_isr+0x31>
    b621:	48 89 f1             	mov    %rsi,%rcx
    b624:	48 89 fe             	mov    %rdi,%rsi
    b627:	31 ff                	xor    %edi,%edi
    b629:	31 d2                	xor    %edx,%edx
    b62b:	e8 3b fb ff ff       	call   b16b <_Z16handle_exceptionimmP13register_file>
    b630:	f6 c3 f8             	test   $0xf8,%bl
    b633:	74 04                	je     b639 <irq_isr+0x3a>
    b635:	b0 20                	mov    $0x20,%al
    b637:	e6 a0                	out    %al,$0xa0
    b639:	b0 20                	mov    $0x20,%al
    b63b:	e6 20                	out    %al,$0x20
    b63d:	48 8d 65 f8          	lea    -0x8(%rbp),%rsp
    b641:	5b                   	pop    %rbx
    b642:	5d                   	pop    %rbp
    b643:	c3                   	ret    

Disassembly of section .text._Z8idt_initv:

000000000000b644 <_Z8idt_initv>:
    b644:	b8 00 80 01 00       	mov    $0x18000,%eax
    b649:	66 c7 04 25 00 90 01 	movw   $0xfff,0x19000
    b650:	00 ff 0f 
    b653:	c7 04 25 02 90 01 00 	movl   $0x18000,0x19002
    b65a:	00 80 01 00 
    b65e:	31 c9                	xor    %ecx,%ecx
    b660:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    b664:	c5 fc 29 04 08       	vmovaps %ymm0,(%rax,%rcx,1)
    b669:	48 83 c1 20          	add    $0x20,%rcx
    b66d:	48 81 f9 00 10 00 00 	cmp    $0x1000,%rcx
    b674:	75 ee                	jne    b664 <_Z8idt_initv+0x20>
    b676:	31 c9                	xor    %ecx,%ecx
    b678:	8b 91 48 86 00 00    	mov    0x8648(%rcx),%edx
    b67e:	66 89 14 88          	mov    %dx,(%rax,%rcx,4)
    b682:	c1 ea 10             	shr    $0x10,%edx
    b685:	c7 44 88 02 18 00 00 	movl   $0x8e000018,0x2(%rax,%rcx,4)
    b68c:	8e 
    b68d:	66 89 54 88 06       	mov    %dx,0x6(%rax,%rcx,4)
    b692:	48 c7 44 88 08 00 00 	movq   $0x0,0x8(%rax,%rcx,4)
    b699:	00 00 
    b69b:	48 83 c1 04          	add    $0x4,%rcx
    b69f:	48 81 f9 80 00 00 00 	cmp    $0x80,%rcx
    b6a6:	75 d0                	jne    b678 <_Z8idt_initv+0x34>
    b6a8:	31 c9                	xor    %ecx,%ecx
    b6aa:	8b 91 c8 86 00 00    	mov    0x86c8(%rcx),%edx
    b6b0:	66 89 94 88 00 02 00 	mov    %dx,0x200(%rax,%rcx,4)
    b6b7:	00 
    b6b8:	c1 ea 10             	shr    $0x10,%edx
    b6bb:	c7 84 88 02 02 00 00 	movl   $0x8e000018,0x202(%rax,%rcx,4)
    b6c2:	18 00 00 8e 
    b6c6:	66 89 94 88 06 02 00 	mov    %dx,0x206(%rax,%rcx,4)
    b6cd:	00 
    b6ce:	48 c7 84 88 08 02 00 	movq   $0x0,0x208(%rax,%rcx,4)
    b6d5:	00 00 00 00 00 
    b6da:	48 83 c1 04          	add    $0x4,%rcx
    b6de:	48 83 f9 40          	cmp    $0x40,%rcx
    b6e2:	75 c6                	jne    b6aa <_Z8idt_initv+0x66>
    b6e4:	31 c9                	xor    %ecx,%ecx
    b6e6:	8b 15 5c cf ff ff    	mov    -0x30a4(%rip),%edx        # 8648 <isr_stub_table>
    b6ec:	66 89 94 08 00 03 00 	mov    %dx,0x300(%rax,%rcx,1)
    b6f3:	00 
    b6f4:	c1 ea 10             	shr    $0x10,%edx
    b6f7:	c7 84 08 02 03 00 00 	movl   $0x8e000018,0x302(%rax,%rcx,1)
    b6fe:	18 00 00 8e 
    b702:	66 89 94 08 06 03 00 	mov    %dx,0x306(%rax,%rcx,1)
    b709:	00 
    b70a:	48 c7 84 08 08 03 00 	movq   $0x0,0x308(%rax,%rcx,1)
    b711:	00 00 00 00 00 
    b716:	48 83 c1 10          	add    $0x10,%rcx
    b71a:	48 81 f9 00 0d 00 00 	cmp    $0xd00,%rcx
    b721:	75 c3                	jne    b6e6 <_Z8idt_initv+0xa2>
    b723:	31 c9                	xor    %ecx,%ecx
    b725:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    b729:	c5 fc 29 84 c8 40 80 	vmovaps %ymm0,0xf8040(%rax,%rcx,8)
    b730:	0f 00 
    b732:	48 83 c1 04          	add    $0x4,%rcx
    b736:	48 83 f9 10          	cmp    $0x10,%rcx
    b73a:	75 ed                	jne    b729 <_Z8idt_initv+0xe5>
    b73c:	48 c7 05 d1 da ff ff 	movq   $0x19000,-0x252f(%rip)        # 9218 <idtptr>
    b743:	00 90 01 00 
    b747:	bf 00 90 01 00       	mov    $0x19000,%edi
    b74c:	c5 f8 77             	vzeroupper 
    b74f:	e9 b4 cf ff ff       	jmp    8708 <load_idt>

Disassembly of section .text._Z7inc_pitv:

000000000000b754 <_Z7inc_pitv>:
    b754:	41 57                	push   %r15
    b756:	41 56                	push   %r14
    b758:	53                   	push   %rbx
    b759:	48 83 ec 40          	sub    $0x40,%rsp
    b75d:	48 ff 04 25 c0 00 11 	incq   0x1100c0
    b764:	00 
    b765:	8b 14 25 28 00 11 00 	mov    0x110028,%edx
    b76c:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
    b771:	48 c7 06 53 8d 00 00 	movq   $0x8d53,(%rsi)
    b778:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%rsi)
    b77f:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
    b784:	48 89 df             	mov    %rbx,%rdi
    b787:	31 c0                	xor    %eax,%eax
    b789:	e8 f1 e0 ff ff       	call   987f <_Z6format8rostringz>
    b78e:	44 8b 73 08          	mov    0x8(%rbx),%r14d
    b792:	45 85 f6             	test   %r14d,%r14d
    b795:	7e 3c                	jle    b7d3 <_Z7inc_pitv+0x7f>
    b797:	41 ff c6             	inc    %r14d
    b79a:	41 bf 9e 00 00 00    	mov    $0x9e,%r15d
    b7a0:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
    b7a5:	41 8d 76 fe          	lea    -0x2(%r14),%esi
    b7a9:	48 89 df             	mov    %rbx,%rdi
    b7ac:	e8 03 f8 ff ff       	call   afb4 <_ZN4spanIcE2atEi>
    b7b1:	0f be 00             	movsbl (%rax),%eax
    b7b4:	0d 00 0f 00 00       	or     $0xf00,%eax
    b7b9:	48 8b 0c 25 00 00 11 	mov    0x110000,%rcx
    b7c0:	00 
    b7c1:	66 42 89 04 39       	mov    %ax,(%rcx,%r15,1)
    b7c6:	49 83 c7 fe          	add    $0xfffffffffffffffe,%r15
    b7ca:	41 ff ce             	dec    %r14d
    b7cd:	41 83 fe 01          	cmp    $0x1,%r14d
    b7d1:	77 d2                	ja     b7a5 <_Z7inc_pitv+0x51>
    b7d3:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
    b7d8:	48 c7 06 53 8d 00 00 	movq   $0x8d53,(%rsi)
    b7df:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%rsi)
    b7e6:	48 c7 c2 00 00 e0 ff 	mov    $0xffffffffffe00000,%rdx
    b7ed:	48 03 14 25 20 00 11 	add    0x110020,%rdx
    b7f4:	00 
    b7f5:	48 89 e3             	mov    %rsp,%rbx
    b7f8:	48 89 df             	mov    %rbx,%rdi
    b7fb:	31 c0                	xor    %eax,%eax
    b7fd:	e8 7d e0 ff ff       	call   987f <_Z6format8rostringz>
    b802:	44 8b 73 08          	mov    0x8(%rbx),%r14d
    b806:	45 85 f6             	test   %r14d,%r14d
    b809:	7e 43                	jle    b84e <_Z7inc_pitv+0xfa>
    b80b:	41 ff c6             	inc    %r14d
    b80e:	41 bf 4f 00 00 00    	mov    $0x4f,%r15d
    b814:	48 89 e3             	mov    %rsp,%rbx
    b817:	41 8d 76 fe          	lea    -0x2(%r14),%esi
    b81b:	48 89 df             	mov    %rbx,%rdi
    b81e:	e8 91 f7 ff ff       	call   afb4 <_ZN4spanIcE2atEi>
    b823:	0f be 00             	movsbl (%rax),%eax
    b826:	0d 00 0f 00 00       	or     $0xf00,%eax
    b82b:	48 8b 0c 25 00 00 11 	mov    0x110000,%rcx
    b832:	00 
    b833:	48 63 14 25 18 00 11 	movslq 0x110018,%rdx
    b83a:	00 
    b83b:	4c 01 fa             	add    %r15,%rdx
    b83e:	66 89 04 51          	mov    %ax,(%rcx,%rdx,2)
    b842:	41 ff ce             	dec    %r14d
    b845:	49 ff cf             	dec    %r15
    b848:	41 83 fe 01          	cmp    $0x1,%r14d
    b84c:	77 c9                	ja     b817 <_Z7inc_pitv+0xc3>
    b84e:	48 8b 04 24          	mov    (%rsp),%rax
    b852:	48 85 c0             	test   %rax,%rax
    b855:	74 2e                	je     b885 <_Z7inc_pitv+0x131>
    b857:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b85b:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b85f:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b866:	00 04 
    b868:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b86d:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b874:	04 
    b875:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b87c:	04 
    b87d:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b884:	00 
    b885:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
    b88a:	48 85 c0             	test   %rax,%rax
    b88d:	74 2e                	je     b8bd <_Z7inc_pitv+0x169>
    b88f:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
    b893:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
    b897:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
    b89e:	00 04 
    b8a0:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
    b8a5:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
    b8ac:	04 
    b8ad:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
    b8b4:	04 
    b8b5:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
    b8bc:	00 
    b8bd:	48 83 c4 40          	add    $0x40,%rsp
    b8c1:	5b                   	pop    %rbx
    b8c2:	41 5e                	pop    %r14
    b8c4:	41 5f                	pop    %r15
    b8c6:	c3                   	ret    

Disassembly of section .text._Z9time_initv:

000000000000b8c7 <_Z9time_initv>:
    b8c7:	53                   	push   %rbx
    b8c8:	48 83 ec 10          	sub    $0x10,%rsp
    b8cc:	48 8d 5c 24 04       	lea    0x4(%rsp),%rbx
    b8d1:	48 89 df             	mov    %rbx,%rdi
    b8d4:	31 f6                	xor    %esi,%esi
    b8d6:	e8 25 00 00 00       	call   b900 <_ZN9timepointC1Em>
    b8db:	8b 43 08             	mov    0x8(%rbx),%eax
    b8de:	89 05 44 d9 ff ff    	mov    %eax,-0x26bc(%rip)        # 9228 <_ZL19reference_timepoint+0x8>
    b8e4:	48 8b 03             	mov    (%rbx),%rax
    b8e7:	48 89 05 32 d9 ff ff 	mov    %rax,-0x26ce(%rip)        # 9220 <_ZL19reference_timepoint>
    b8ee:	48 c7 04 25 c0 00 11 	movq   $0x0,0x1100c0
    b8f5:	00 00 00 00 00 
    b8fa:	48 83 c4 10          	add    $0x10,%rsp
    b8fe:	5b                   	pop    %rbx
    b8ff:	c3                   	ret    

Disassembly of section .text._ZN9timepointC2Em:

000000000000b900 <_ZN9timepointC1Em>:
    b900:	48 89 f2             	mov    %rsi,%rdx
    b903:	b0 0a                	mov    $0xa,%al
    b905:	e6 70                	out    %al,$0x70
    b907:	e4 71                	in     $0x71,%al
    b909:	84 c0                	test   %al,%al
    b90b:	78 f6                	js     b903 <_ZN9timepointC1Em+0x3>
    b90d:	b0 09                	mov    $0x9,%al
    b90f:	e6 70                	out    %al,$0x70
    b911:	e4 71                	in     $0x71,%al
    b913:	88 07                	mov    %al,(%rdi)
    b915:	b0 08                	mov    $0x8,%al
    b917:	e6 70                	out    %al,$0x70
    b919:	e4 71                	in     $0x71,%al
    b91b:	88 47 01             	mov    %al,0x1(%rdi)
    b91e:	b0 07                	mov    $0x7,%al
    b920:	e6 70                	out    %al,$0x70
    b922:	e4 71                	in     $0x71,%al
    b924:	88 47 02             	mov    %al,0x2(%rdi)
    b927:	b0 04                	mov    $0x4,%al
    b929:	e6 70                	out    %al,$0x70
    b92b:	e4 71                	in     $0x71,%al
    b92d:	88 47 03             	mov    %al,0x3(%rdi)
    b930:	b0 02                	mov    $0x2,%al
    b932:	e6 70                	out    %al,$0x70
    b934:	e4 71                	in     $0x71,%al
    b936:	88 47 04             	mov    %al,0x4(%rdi)
    b939:	31 c0                	xor    %eax,%eax
    b93b:	e6 70                	out    %al,$0x70
    b93d:	e4 71                	in     $0x71,%al
    b93f:	89 c1                	mov    %eax,%ecx
    b941:	80 e1 0f             	and    $0xf,%cl
    b944:	c0 e8 04             	shr    $0x4,%al
    b947:	0f b6 c0             	movzbl %al,%eax
    b94a:	01 c0                	add    %eax,%eax
    b94c:	8d 34 80             	lea    (%rax,%rax,4),%esi
    b94f:	40 00 ce             	add    %cl,%sil
    b952:	0f b6 47 04          	movzbl 0x4(%rdi),%eax
    b956:	89 c1                	mov    %eax,%ecx
    b958:	83 e1 0f             	and    $0xf,%ecx
    b95b:	c1 e8 04             	shr    $0x4,%eax
    b95e:	8d 04 80             	lea    (%rax,%rax,4),%eax
    b961:	8d 04 41             	lea    (%rcx,%rax,2),%eax
    b964:	44 8a 47 03          	mov    0x3(%rdi),%r8b
    b968:	44 89 c1             	mov    %r8d,%ecx
    b96b:	80 e1 0f             	and    $0xf,%cl
    b96e:	45 89 c1             	mov    %r8d,%r9d
    b971:	41 c0 e9 04          	shr    $0x4,%r9b
    b975:	41 80 e1 07          	and    $0x7,%r9b
    b979:	45 0f b6 c9          	movzbl %r9b,%r9d
    b97d:	45 01 c9             	add    %r9d,%r9d
    b980:	47 8d 0c 89          	lea    (%r9,%r9,4),%r9d
    b984:	41 00 c9             	add    %cl,%r9b
    b987:	41 80 e0 80          	and    $0x80,%r8b
    b98b:	45 08 c8             	or     %r9b,%r8b
    b98e:	8a 4f 02             	mov    0x2(%rdi),%cl
    b991:	41 89 c9             	mov    %ecx,%r9d
    b994:	41 80 e1 0f          	and    $0xf,%r9b
    b998:	c0 e9 04             	shr    $0x4,%cl
    b99b:	0f b6 c9             	movzbl %cl,%ecx
    b99e:	01 c9                	add    %ecx,%ecx
    b9a0:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
    b9a3:	44 00 c9             	add    %r9b,%cl
    b9a6:	44 8a 0f             	mov    (%rdi),%r9b
    b9a9:	44 8a 57 01          	mov    0x1(%rdi),%r10b
    b9ad:	45 89 d3             	mov    %r10d,%r11d
    b9b0:	41 80 e3 0f          	and    $0xf,%r11b
    b9b4:	41 c0 ea 04          	shr    $0x4,%r10b
    b9b8:	45 0f b6 d2          	movzbl %r10b,%r10d
    b9bc:	45 01 d2             	add    %r10d,%r10d
    b9bf:	47 8d 14 92          	lea    (%r10,%r10,4),%r10d
    b9c3:	45 00 da             	add    %r11b,%r10b
    b9c6:	44 88 57 01          	mov    %r10b,0x1(%rdi)
    b9ca:	45 89 ca             	mov    %r9d,%r10d
    b9cd:	41 80 e2 0f          	and    $0xf,%r10b
    b9d1:	41 c0 e9 04          	shr    $0x4,%r9b
    b9d5:	45 0f b6 c9          	movzbl %r9b,%r9d
    b9d9:	45 01 c9             	add    %r9d,%r9d
    b9dc:	47 8d 0c 89          	lea    (%r9,%r9,4),%r9d
    b9e0:	45 00 d1             	add    %r10b,%r9b
    b9e3:	44 88 0f             	mov    %r9b,(%rdi)
    b9e6:	49 b9 db 34 b6 d7 82 	movabs $0x431bde82d7b634db,%r9
    b9ed:	de 1b 43 
    b9f0:	c4 42 b3 f6 c9       	mulx   %r9,%r9,%r9
    b9f5:	49 c1 e9 12          	shr    $0x12,%r9
    b9f9:	45 69 d1 40 42 0f 00 	imul   $0xf4240,%r9d,%r10d
    ba00:	44 29 d2             	sub    %r10d,%edx
    ba03:	89 57 08             	mov    %edx,0x8(%rdi)
    ba06:	40 0f b6 d6          	movzbl %sil,%edx
    ba0a:	4c 01 ca             	add    %r9,%rdx
    ba0d:	48 be 45 44 44 44 44 	movabs $0x444444444444445,%rsi
    ba14:	44 44 04 
    ba17:	c4 62 b3 f6 ce       	mulx   %rsi,%r9,%r9
    ba1c:	44 01 c8             	add    %r9d,%eax
    ba1f:	41 0f b6 f0          	movzbl %r8b,%esi
    ba23:	41 b8 89 88 88 88    	mov    $0x88888889,%r8d
    ba29:	4c 0f af c0          	imul   %rax,%r8
    ba2d:	49 c1 e8 25          	shr    $0x25,%r8
    ba31:	44 01 c6             	add    %r8d,%esi
    ba34:	45 6b c9 3c          	imul   $0x3c,%r9d,%r9d
    ba38:	44 29 ca             	sub    %r9d,%edx
    ba3b:	88 57 05             	mov    %dl,0x5(%rdi)
    ba3e:	41 6b d0 3c          	imul   $0x3c,%r8d,%edx
    ba42:	29 d0                	sub    %edx,%eax
    ba44:	88 47 04             	mov    %al,0x4(%rdi)
    ba47:	48 69 c6 ab aa aa 0a 	imul   $0xaaaaaab,%rsi,%rax
    ba4e:	48 c1 e8 20          	shr    $0x20,%rax
    ba52:	8d 14 c5 00 00 00 00 	lea    0x0(,%rax,8),%edx
    ba59:	8d 14 52             	lea    (%rdx,%rdx,2),%edx
    ba5c:	29 d6                	sub    %edx,%esi
    ba5e:	40 88 77 03          	mov    %sil,0x3(%rdi)
    ba62:	00 c8                	add    %cl,%al
    ba64:	88 47 02             	mov    %al,0x2(%rdi)
    ba67:	c3                   	ret    

Disassembly of section .text._ZN9timepointC2Ev:

000000000000ba68 <_ZN9timepointC1Ev>:
    ba68:	41 56                	push   %r14
    ba6a:	53                   	push   %rbx
    ba6b:	48 83 ec 18          	sub    $0x18,%rsp
    ba6f:	48 89 fb             	mov    %rdi,%rbx
    ba72:	e4 40                	in     $0x40,%al
    ba74:	0f b6 c8             	movzbl %al,%ecx
    ba77:	e4 40                	in     $0x40,%al
    ba79:	0f b6 c0             	movzbl %al,%eax
    ba7c:	48 c1 e0 08          	shl    $0x8,%rax
    ba80:	48 09 c8             	or     %rcx,%rax
    ba83:	48 8b 0c 25 c0 00 11 	mov    0x1100c0,%rcx
    ba8a:	00 
    ba8b:	48 c1 e1 10          	shl    $0x10,%rcx
    ba8f:	48 29 c1             	sub    %rax,%rcx
    ba92:	48 69 c1 40 42 0f 00 	imul   $0xf4240,%rcx,%rax
    ba99:	48 ba 00 00 40 42 0f 	movabs $0xf42400000,%rdx
    baa0:	00 00 00 
    baa3:	48 01 c2             	add    %rax,%rdx
    baa6:	48 b8 45 db 4c d5 1a 	movabs $0xe0f9751ad54cdb45,%rax
    baad:	75 f9 e0 
    bab0:	c4 e2 cb f6 f0       	mulx   %rax,%rsi,%rsi
    bab5:	48 c1 ee 14          	shr    $0x14,%rsi
    bab9:	4c 8d 74 24 0c       	lea    0xc(%rsp),%r14
    babe:	4c 89 f7             	mov    %r14,%rdi
    bac1:	e8 3a fe ff ff       	call   b900 <_ZN9timepointC1Em>
    bac6:	41 8b 46 08          	mov    0x8(%r14),%eax
    baca:	89 43 08             	mov    %eax,0x8(%rbx)
    bacd:	49 8b 06             	mov    (%r14),%rax
    bad0:	48 89 03             	mov    %rax,(%rbx)
    bad3:	48 83 c4 18          	add    $0x18,%rsp
    bad7:	5b                   	pop    %rbx
    bad8:	41 5e                	pop    %r14
    bada:	c3                   	ret    

Disassembly of section .text._ZN9timepoint12unix_secondsEv:

000000000000badc <_ZN9timepoint12unix_secondsEv>:
    badc:	e4 40                	in     $0x40,%al
    bade:	0f b6 c8             	movzbl %al,%ecx
    bae1:	e4 40                	in     $0x40,%al
    bae3:	0f b6 c0             	movzbl %al,%eax
    bae6:	48 c1 e0 08          	shl    $0x8,%rax
    baea:	48 09 c8             	or     %rcx,%rax
    baed:	48 8b 0c 25 c0 00 11 	mov    0x1100c0,%rcx
    baf4:	00 
    baf5:	48 c1 e1 10          	shl    $0x10,%rcx
    baf9:	48 29 c1             	sub    %rax,%rcx
    bafc:	48 81 c1 00 00 01 00 	add    $0x10000,%rcx
    bb03:	c4 e1 f9 6e c1       	vmovq  %rcx,%xmm0
    bb08:	c5 f9 62 05 10 cc ff 	vpunpckldq -0x33f0(%rip),%xmm0,%xmm0        # 8720 <load_idt+0x18>
    bb0f:	ff 
    bb10:	c5 f9 5c 05 18 cc ff 	vsubpd -0x33e8(%rip),%xmm0,%xmm0        # 8730 <load_idt+0x28>
    bb17:	ff 
    bb18:	c5 f9 7c c0          	vhaddpd %xmm0,%xmm0,%xmm0
    bb1c:	c5 fb 5e 05 bc cd ff 	vdivsd -0x3244(%rip),%xmm0,%xmm0        # 88e0 <load_idt+0x1d8>
    bb23:	ff 
    bb24:	c3                   	ret    

Disassembly of section .text._Z9tsc_delaym:

000000000000bb25 <_Z9tsc_delaym>:
    bb25:	0f 31                	rdtsc  
    bb27:	89 d1                	mov    %edx,%ecx
    bb29:	f7 d9                	neg    %ecx
    bb2b:	48 c1 e1 20          	shl    $0x20,%rcx
    bb2f:	89 c0                	mov    %eax,%eax
    bb31:	48 29 c1             	sub    %rax,%rcx
    bb34:	0f 31                	rdtsc  
    bb36:	48 c1 e2 20          	shl    $0x20,%rdx
    bb3a:	89 c0                	mov    %eax,%eax
    bb3c:	48 01 c8             	add    %rcx,%rax
    bb3f:	48 01 d0             	add    %rdx,%rax
    bb42:	48 39 f8             	cmp    %rdi,%rax
    bb45:	72 ed                	jb     bb34 <_Z9tsc_delaym+0xf>
    bb47:	c3                   	ret    

Disassembly of section .text._Z8pic_initv:

000000000000bb48 <_Z8pic_initv>:
    bb48:	e4 21                	in     $0x21,%al
    bb4a:	89 c1                	mov    %eax,%ecx
    bb4c:	e4 a1                	in     $0xa1,%al
    bb4e:	89 c2                	mov    %eax,%edx
    bb50:	b0 11                	mov    $0x11,%al
    bb52:	e6 20                	out    %al,$0x20
    bb54:	31 c0                	xor    %eax,%eax
    bb56:	e6 80                	out    %al,$0x80
    bb58:	b0 11                	mov    $0x11,%al
    bb5a:	e6 a0                	out    %al,$0xa0
    bb5c:	31 c0                	xor    %eax,%eax
    bb5e:	e6 80                	out    %al,$0x80
    bb60:	b0 20                	mov    $0x20,%al
    bb62:	e6 21                	out    %al,$0x21
    bb64:	31 c0                	xor    %eax,%eax
    bb66:	e6 80                	out    %al,$0x80
    bb68:	b0 28                	mov    $0x28,%al
    bb6a:	e6 a1                	out    %al,$0xa1
    bb6c:	31 c0                	xor    %eax,%eax
    bb6e:	e6 80                	out    %al,$0x80
    bb70:	b0 04                	mov    $0x4,%al
    bb72:	e6 21                	out    %al,$0x21
    bb74:	31 c0                	xor    %eax,%eax
    bb76:	e6 80                	out    %al,$0x80
    bb78:	b0 02                	mov    $0x2,%al
    bb7a:	e6 a1                	out    %al,$0xa1
    bb7c:	31 c0                	xor    %eax,%eax
    bb7e:	e6 80                	out    %al,$0x80
    bb80:	b0 01                	mov    $0x1,%al
    bb82:	e6 21                	out    %al,$0x21
    bb84:	31 c0                	xor    %eax,%eax
    bb86:	e6 80                	out    %al,$0x80
    bb88:	b0 01                	mov    $0x1,%al
    bb8a:	e6 a1                	out    %al,$0xa1
    bb8c:	31 c0                	xor    %eax,%eax
    bb8e:	e6 80                	out    %al,$0x80
    bb90:	89 c8                	mov    %ecx,%eax
    bb92:	e6 21                	out    %al,$0x21
    bb94:	89 d0                	mov    %edx,%eax
    bb96:	e6 a1                	out    %al,$0xa1
    bb98:	c3                   	ret    

Disassembly of section .text._ZNK4spanIcE4findERKc:

000000000000bb9a <_ZNK4spanIcE4findERKc>:
    bb9a:	55                   	push   %rbp
    bb9b:	41 57                	push   %r15
    bb9d:	41 56                	push   %r14
    bb9f:	53                   	push   %rbx
    bba0:	50                   	push   %rax
    bba1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    bba6:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    bbaa:	7e 25                	jle    bbd1 <_ZNK4spanIcE4findERKc+0x37>
    bbac:	49 89 f6             	mov    %rsi,%r14
    bbaf:	49 89 ff             	mov    %rdi,%r15
    bbb2:	31 ed                	xor    %ebp,%ebp
    bbb4:	4c 89 ff             	mov    %r15,%rdi
    bbb7:	89 ee                	mov    %ebp,%esi
    bbb9:	e8 20 00 00 00       	call   bbde <_ZNK4spanIcE2atEi>
    bbbe:	8a 00                	mov    (%rax),%al
    bbc0:	41 3a 06             	cmp    (%r14),%al
    bbc3:	74 0a                	je     bbcf <_ZNK4spanIcE4findERKc+0x35>
    bbc5:	ff c5                	inc    %ebp
    bbc7:	41 3b 6f 08          	cmp    0x8(%r15),%ebp
    bbcb:	7c e7                	jl     bbb4 <_ZNK4spanIcE4findERKc+0x1a>
    bbcd:	eb 02                	jmp    bbd1 <_ZNK4spanIcE4findERKc+0x37>
    bbcf:	89 eb                	mov    %ebp,%ebx
    bbd1:	89 d8                	mov    %ebx,%eax
    bbd3:	48 83 c4 08          	add    $0x8,%rsp
    bbd7:	5b                   	pop    %rbx
    bbd8:	41 5e                	pop    %r14
    bbda:	41 5f                	pop    %r15
    bbdc:	5d                   	pop    %rbp
    bbdd:	c3                   	ret    

Disassembly of section .text._ZNK4spanIcE2atEi:

000000000000bbde <_ZNK4spanIcE2atEi>:
    bbde:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
    bbe2:	74 07                	je     bbeb <_ZNK4spanIcE2atEi+0xd>
    bbe4:	48 63 c6             	movslq %esi,%rax
    bbe7:	48 03 07             	add    (%rdi),%rax
    bbea:	c3                   	ret    
    bbeb:	53                   	push   %rbx
    bbec:	b0 4f                	mov    $0x4f,%al
    bbee:	48 c7 c3 eb ff ff ff 	mov    $0xffffffffffffffeb,%rbx
    bbf5:	0f be f0             	movsbl %al,%esi
    bbf8:	bf 00 00 11 00       	mov    $0x110000,%edi
    bbfd:	e8 b0 eb ff ff       	call   a7b2 <_ZN7console7putcharEc>
    bc02:	8a 83 d4 8d 00 00    	mov    0x8dd4(%rbx),%al
    bc08:	48 ff c3             	inc    %rbx
    bc0b:	75 e8                	jne    bbf5 <_ZNK4spanIcE2atEi+0x17>
    bc0d:	bf 01 00 00 00       	mov    $0x1,%edi
    bc12:	e8 3a ec ff ff       	call   a851 <_Z16__malloc_trackedmPKci>
    bc17:	c6 00 00             	movb   $0x0,(%rax)
    bc1a:	5b                   	pop    %rbx
    bc1b:	c3                   	ret    

Disassembly of section .text._ZN6vectorIcEC2EPKcii:

000000000000bc1c <_ZN6vectorIcEC2EPKcii>:
    bc1c:	55                   	push   %rbp
    bc1d:	41 56                	push   %r14
    bc1f:	53                   	push   %rbx
    bc20:	89 cd                	mov    %ecx,%ebp
    bc22:	48 89 f3             	mov    %rsi,%rbx
    bc25:	49 89 fe             	mov    %rdi,%r14
    bc28:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    bc2f:	89 57 0c             	mov    %edx,0xc(%rdi)
    bc32:	89 57 08             	mov    %edx,0x8(%rdi)
    bc35:	48 63 fa             	movslq %edx,%rdi
    bc38:	e8 14 ec ff ff       	call   a851 <_Z16__malloc_trackedmPKci>
    bc3d:	49 89 06             	mov    %rax,(%r14)
    bc40:	41 83 7e 08 00       	cmpl   $0x0,0x8(%r14)
    bc45:	7e 1d                	jle    bc64 <_ZN6vectorIcEC2EPKcii+0x48>
    bc47:	48 63 c5             	movslq %ebp,%rax
    bc4a:	48 01 c3             	add    %rax,%rbx
    bc4d:	31 c0                	xor    %eax,%eax
    bc4f:	8a 0c 03             	mov    (%rbx,%rax,1),%cl
    bc52:	49 8b 16             	mov    (%r14),%rdx
    bc55:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
    bc58:	48 ff c0             	inc    %rax
    bc5b:	49 63 4e 08          	movslq 0x8(%r14),%rcx
    bc5f:	48 39 c8             	cmp    %rcx,%rax
    bc62:	7c eb                	jl     bc4f <_ZN6vectorIcEC2EPKcii+0x33>
    bc64:	5b                   	pop    %rbx
    bc65:	41 5e                	pop    %r14
    bc67:	5d                   	pop    %rbp
    bc68:	c3                   	ret    

Disassembly of section .text._ZN6vectorIcE2atEi:

000000000000bc6a <_ZN6vectorIcE2atEi>:
    bc6a:	41 56                	push   %r14
    bc6c:	53                   	push   %rbx
    bc6d:	50                   	push   %rax
    bc6e:	41 89 f6             	mov    %esi,%r14d
    bc71:	48 89 fb             	mov    %rdi,%rbx
    bc74:	8b 47 0c             	mov    0xc(%rdi),%eax
    bc77:	39 f0                	cmp    %esi,%eax
    bc79:	7f 26                	jg     bca1 <_ZN6vectorIcE2atEi+0x37>
    bc7b:	83 f8 02             	cmp    $0x2,%eax
    bc7e:	be 01 00 00 00       	mov    $0x1,%esi
    bc83:	0f 4d f0             	cmovge %eax,%esi
    bc86:	44 39 f6             	cmp    %r14d,%esi
    bc89:	7f 0e                	jg     bc99 <_ZN6vectorIcE2atEi+0x2f>
    bc8b:	c5 f2 2a c6          	vcvtsi2ss %esi,%xmm1,%xmm0
    bc8f:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
    bc93:	c5 fa 2c f0          	vcvttss2si %xmm0,%esi
    bc97:	eb ed                	jmp    bc86 <_ZN6vectorIcE2atEi+0x1c>
    bc99:	48 89 df             	mov    %rbx,%rdi
    bc9c:	e8 fd f1 ff ff       	call   ae9e <_ZN6vectorIcE7reserveEi>
    bca1:	8b 43 08             	mov    0x8(%rbx),%eax
    bca4:	41 8d 4e 01          	lea    0x1(%r14),%ecx
    bca8:	39 c8                	cmp    %ecx,%eax
    bcaa:	0f 4f c8             	cmovg  %eax,%ecx
    bcad:	89 4b 08             	mov    %ecx,0x8(%rbx)
    bcb0:	49 63 c6             	movslq %r14d,%rax
    bcb3:	48 03 03             	add    (%rbx),%rax
    bcb6:	48 83 c4 08          	add    $0x8,%rsp
    bcba:	5b                   	pop    %rbx
    bcbb:	41 5e                	pop    %r14
    bcbd:	c3                   	ret    
