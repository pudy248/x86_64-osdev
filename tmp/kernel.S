
tmp/kernel.img.elf:     file format elf64-x86-64


Disassembly of section .text:

0000000001000000 <save_regs-0x10>:
 1000000:	00 00                	add    %al,(%rax)
 1000002:	00 01                	add    %al,(%rcx)
 1000004:	00 00                	add    %al,(%rax)
 1000006:	00 00                	add    %al,(%rax)
 1000008:	cc                   	int3   
 1000009:	cc                   	int3   
 100000a:	cc                   	int3   
 100000b:	cc                   	int3   
 100000c:	cc                   	int3   
 100000d:	cc                   	int3   
 100000e:	cc                   	int3   
 100000f:	cc                   	int3   

0000000001000010 <save_regs>:
 1000010:	52                   	push   %rdx
 1000011:	ba 00 00 01 00       	mov    $0x10000,%edx
 1000016:	48 89 02             	mov    %rax,(%rdx)
 1000019:	48 89 5a 08          	mov    %rbx,0x8(%rdx)
 100001d:	48 89 4a 10          	mov    %rcx,0x10(%rdx)
 1000021:	48 89 d0             	mov    %rdx,%rax
 1000024:	5a                   	pop    %rdx
 1000025:	48 89 50 18          	mov    %rdx,0x18(%rax)
 1000029:	48 89 70 20          	mov    %rsi,0x20(%rax)
 100002d:	48 89 78 28          	mov    %rdi,0x28(%rax)
 1000031:	48 89 68 30          	mov    %rbp,0x30(%rax)
 1000035:	4c 89 40 40          	mov    %r8,0x40(%rax)
 1000039:	4c 89 48 48          	mov    %r9,0x48(%rax)
 100003d:	4c 89 50 50          	mov    %r10,0x50(%rax)
 1000041:	4c 89 58 58          	mov    %r11,0x58(%rax)
 1000045:	4c 89 60 60          	mov    %r12,0x60(%rax)
 1000049:	4c 89 68 68          	mov    %r13,0x68(%rax)
 100004d:	4c 89 70 70          	mov    %r14,0x70(%rax)
 1000051:	4c 89 78 78          	mov    %r15,0x78(%rax)
 1000055:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
 100005a:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
 1000061:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
 1000066:	48 89 90 90 00 00 00 	mov    %rdx,0x90(%rax)
 100006d:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 1000072:	48 89 90 88 00 00 00 	mov    %rdx,0x88(%rax)
 1000079:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
 100007e:	48 89 50 38          	mov    %rdx,0x38(%rax)
 1000082:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
 1000087:	48 89 90 98 00 00 00 	mov    %rdx,0x98(%rax)
 100008e:	c3                   	ret    

000000000100008f <stor_regs>:
 100008f:	b8 00 00 01 00       	mov    $0x10000,%eax
 1000094:	4c 8b 78 78          	mov    0x78(%rax),%r15
 1000098:	4c 8b 70 70          	mov    0x70(%rax),%r14
 100009c:	4c 8b 68 68          	mov    0x68(%rax),%r13
 10000a0:	4c 8b 60 60          	mov    0x60(%rax),%r12
 10000a4:	4c 8b 58 58          	mov    0x58(%rax),%r11
 10000a8:	4c 8b 50 50          	mov    0x50(%rax),%r10
 10000ac:	4c 8b 48 48          	mov    0x48(%rax),%r9
 10000b0:	4c 8b 40 40          	mov    0x40(%rax),%r8
 10000b4:	48 8b 68 30          	mov    0x30(%rax),%rbp
 10000b8:	48 8b 78 28          	mov    0x28(%rax),%rdi
 10000bc:	48 8b 70 20          	mov    0x20(%rax),%rsi
 10000c0:	48 8b 50 18          	mov    0x18(%rax),%rdx
 10000c4:	48 8b 48 10          	mov    0x10(%rax),%rcx
 10000c8:	48 8b 58 08          	mov    0x8(%rax),%rbx
 10000cc:	ff 30                	push   (%rax)
 10000ce:	58                   	pop    %rax
 10000cf:	c3                   	ret    

00000000010000d0 <isr_stub_0>:
 10000d0:	e8 3b ff ff ff       	call   1000010 <save_regs>
 10000d5:	bf 00 00 00 00       	mov    $0x0,%edi
 10000da:	48 89 de             	mov    %rbx,%rsi
 10000dd:	55                   	push   %rbp
 10000de:	48 89 e5             	mov    %rsp,%rbp
 10000e1:	e8 76 6e 00 00       	call   1006f5c <isr_no_err>
 10000e6:	5d                   	pop    %rbp
 10000e7:	e8 a3 ff ff ff       	call   100008f <stor_regs>
 10000ec:	48 cf                	iretq  

00000000010000ee <isr_stub_1>:
 10000ee:	e8 1d ff ff ff       	call   1000010 <save_regs>
 10000f3:	bf 01 00 00 00       	mov    $0x1,%edi
 10000f8:	48 89 de             	mov    %rbx,%rsi
 10000fb:	55                   	push   %rbp
 10000fc:	48 89 e5             	mov    %rsp,%rbp
 10000ff:	e8 58 6e 00 00       	call   1006f5c <isr_no_err>
 1000104:	5d                   	pop    %rbp
 1000105:	e8 85 ff ff ff       	call   100008f <stor_regs>
 100010a:	48 cf                	iretq  

000000000100010c <isr_stub_2>:
 100010c:	e8 ff fe ff ff       	call   1000010 <save_regs>
 1000111:	bf 02 00 00 00       	mov    $0x2,%edi
 1000116:	48 89 de             	mov    %rbx,%rsi
 1000119:	55                   	push   %rbp
 100011a:	48 89 e5             	mov    %rsp,%rbp
 100011d:	e8 3a 6e 00 00       	call   1006f5c <isr_no_err>
 1000122:	5d                   	pop    %rbp
 1000123:	e8 67 ff ff ff       	call   100008f <stor_regs>
 1000128:	48 cf                	iretq  

000000000100012a <isr_stub_3>:
 100012a:	e8 e1 fe ff ff       	call   1000010 <save_regs>
 100012f:	bf 03 00 00 00       	mov    $0x3,%edi
 1000134:	48 89 de             	mov    %rbx,%rsi
 1000137:	55                   	push   %rbp
 1000138:	48 89 e5             	mov    %rsp,%rbp
 100013b:	e8 1c 6e 00 00       	call   1006f5c <isr_no_err>
 1000140:	5d                   	pop    %rbp
 1000141:	e8 49 ff ff ff       	call   100008f <stor_regs>
 1000146:	48 cf                	iretq  

0000000001000148 <isr_stub_4>:
 1000148:	e8 c3 fe ff ff       	call   1000010 <save_regs>
 100014d:	bf 04 00 00 00       	mov    $0x4,%edi
 1000152:	48 89 de             	mov    %rbx,%rsi
 1000155:	55                   	push   %rbp
 1000156:	48 89 e5             	mov    %rsp,%rbp
 1000159:	e8 fe 6d 00 00       	call   1006f5c <isr_no_err>
 100015e:	5d                   	pop    %rbp
 100015f:	e8 2b ff ff ff       	call   100008f <stor_regs>
 1000164:	48 cf                	iretq  

0000000001000166 <isr_stub_5>:
 1000166:	e8 a5 fe ff ff       	call   1000010 <save_regs>
 100016b:	bf 05 00 00 00       	mov    $0x5,%edi
 1000170:	48 89 de             	mov    %rbx,%rsi
 1000173:	55                   	push   %rbp
 1000174:	48 89 e5             	mov    %rsp,%rbp
 1000177:	e8 e0 6d 00 00       	call   1006f5c <isr_no_err>
 100017c:	5d                   	pop    %rbp
 100017d:	e8 0d ff ff ff       	call   100008f <stor_regs>
 1000182:	48 cf                	iretq  

0000000001000184 <isr_stub_6>:
 1000184:	e8 87 fe ff ff       	call   1000010 <save_regs>
 1000189:	bf 06 00 00 00       	mov    $0x6,%edi
 100018e:	48 89 de             	mov    %rbx,%rsi
 1000191:	55                   	push   %rbp
 1000192:	48 89 e5             	mov    %rsp,%rbp
 1000195:	e8 c2 6d 00 00       	call   1006f5c <isr_no_err>
 100019a:	5d                   	pop    %rbp
 100019b:	e8 ef fe ff ff       	call   100008f <stor_regs>
 10001a0:	48 cf                	iretq  

00000000010001a2 <isr_stub_7>:
 10001a2:	e8 69 fe ff ff       	call   1000010 <save_regs>
 10001a7:	bf 07 00 00 00       	mov    $0x7,%edi
 10001ac:	48 89 de             	mov    %rbx,%rsi
 10001af:	55                   	push   %rbp
 10001b0:	48 89 e5             	mov    %rsp,%rbp
 10001b3:	e8 a4 6d 00 00       	call   1006f5c <isr_no_err>
 10001b8:	5d                   	pop    %rbp
 10001b9:	e8 d1 fe ff ff       	call   100008f <stor_regs>
 10001be:	48 cf                	iretq  

00000000010001c0 <isr_stub_8>:
 10001c0:	50                   	push   %rax
 10001c1:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10001c6:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 10001cb:	58                   	pop    %rax
 10001cc:	48 83 c4 08          	add    $0x8,%rsp
 10001d0:	e8 3b fe ff ff       	call   1000010 <save_regs>
 10001d5:	bf 08 00 00 00       	mov    $0x8,%edi
 10001da:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
 10001df:	be 00 00 01 00       	mov    $0x10000,%esi
 10001e4:	55                   	push   %rbp
 10001e5:	48 89 e5             	mov    %rsp,%rbp
 10001e8:	e8 52 6d 00 00       	call   1006f3f <isr_err>
 10001ed:	5d                   	pop    %rbp
 10001ee:	e8 9c fe ff ff       	call   100008f <stor_regs>
 10001f3:	48 cf                	iretq  

00000000010001f5 <isr_stub_9>:
 10001f5:	e8 16 fe ff ff       	call   1000010 <save_regs>
 10001fa:	bf 09 00 00 00       	mov    $0x9,%edi
 10001ff:	48 89 de             	mov    %rbx,%rsi
 1000202:	55                   	push   %rbp
 1000203:	48 89 e5             	mov    %rsp,%rbp
 1000206:	e8 51 6d 00 00       	call   1006f5c <isr_no_err>
 100020b:	5d                   	pop    %rbp
 100020c:	e8 7e fe ff ff       	call   100008f <stor_regs>
 1000211:	48 cf                	iretq  

0000000001000213 <isr_stub_10>:
 1000213:	50                   	push   %rax
 1000214:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1000219:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 100021e:	58                   	pop    %rax
 100021f:	48 83 c4 08          	add    $0x8,%rsp
 1000223:	e8 e8 fd ff ff       	call   1000010 <save_regs>
 1000228:	bf 0a 00 00 00       	mov    $0xa,%edi
 100022d:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
 1000232:	be 00 00 01 00       	mov    $0x10000,%esi
 1000237:	55                   	push   %rbp
 1000238:	48 89 e5             	mov    %rsp,%rbp
 100023b:	e8 ff 6c 00 00       	call   1006f3f <isr_err>
 1000240:	5d                   	pop    %rbp
 1000241:	e8 49 fe ff ff       	call   100008f <stor_regs>
 1000246:	48 cf                	iretq  

0000000001000248 <isr_stub_11>:
 1000248:	50                   	push   %rax
 1000249:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 100024e:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 1000253:	58                   	pop    %rax
 1000254:	48 83 c4 08          	add    $0x8,%rsp
 1000258:	e8 b3 fd ff ff       	call   1000010 <save_regs>
 100025d:	bf 0b 00 00 00       	mov    $0xb,%edi
 1000262:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
 1000267:	be 00 00 01 00       	mov    $0x10000,%esi
 100026c:	55                   	push   %rbp
 100026d:	48 89 e5             	mov    %rsp,%rbp
 1000270:	e8 ca 6c 00 00       	call   1006f3f <isr_err>
 1000275:	5d                   	pop    %rbp
 1000276:	e8 14 fe ff ff       	call   100008f <stor_regs>
 100027b:	48 cf                	iretq  

000000000100027d <isr_stub_12>:
 100027d:	50                   	push   %rax
 100027e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1000283:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 1000288:	58                   	pop    %rax
 1000289:	48 83 c4 08          	add    $0x8,%rsp
 100028d:	e8 7e fd ff ff       	call   1000010 <save_regs>
 1000292:	bf 0c 00 00 00       	mov    $0xc,%edi
 1000297:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
 100029c:	be 00 00 01 00       	mov    $0x10000,%esi
 10002a1:	55                   	push   %rbp
 10002a2:	48 89 e5             	mov    %rsp,%rbp
 10002a5:	e8 95 6c 00 00       	call   1006f3f <isr_err>
 10002aa:	5d                   	pop    %rbp
 10002ab:	e8 df fd ff ff       	call   100008f <stor_regs>
 10002b0:	48 cf                	iretq  

00000000010002b2 <isr_stub_13>:
 10002b2:	50                   	push   %rax
 10002b3:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10002b8:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 10002bd:	58                   	pop    %rax
 10002be:	48 83 c4 08          	add    $0x8,%rsp
 10002c2:	e8 49 fd ff ff       	call   1000010 <save_regs>
 10002c7:	bf 0d 00 00 00       	mov    $0xd,%edi
 10002cc:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
 10002d1:	be 00 00 01 00       	mov    $0x10000,%esi
 10002d6:	55                   	push   %rbp
 10002d7:	48 89 e5             	mov    %rsp,%rbp
 10002da:	e8 60 6c 00 00       	call   1006f3f <isr_err>
 10002df:	5d                   	pop    %rbp
 10002e0:	e8 aa fd ff ff       	call   100008f <stor_regs>
 10002e5:	48 cf                	iretq  

00000000010002e7 <isr_stub_14>:
 10002e7:	50                   	push   %rax
 10002e8:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10002ed:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 10002f2:	58                   	pop    %rax
 10002f3:	48 83 c4 08          	add    $0x8,%rsp
 10002f7:	e8 14 fd ff ff       	call   1000010 <save_regs>
 10002fc:	bf 0e 00 00 00       	mov    $0xe,%edi
 1000301:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
 1000306:	be 00 00 01 00       	mov    $0x10000,%esi
 100030b:	55                   	push   %rbp
 100030c:	48 89 e5             	mov    %rsp,%rbp
 100030f:	e8 2b 6c 00 00       	call   1006f3f <isr_err>
 1000314:	5d                   	pop    %rbp
 1000315:	e8 75 fd ff ff       	call   100008f <stor_regs>
 100031a:	48 cf                	iretq  

000000000100031c <isr_stub_15>:
 100031c:	e8 ef fc ff ff       	call   1000010 <save_regs>
 1000321:	bf 0f 00 00 00       	mov    $0xf,%edi
 1000326:	48 89 de             	mov    %rbx,%rsi
 1000329:	55                   	push   %rbp
 100032a:	48 89 e5             	mov    %rsp,%rbp
 100032d:	e8 2a 6c 00 00       	call   1006f5c <isr_no_err>
 1000332:	5d                   	pop    %rbp
 1000333:	e8 57 fd ff ff       	call   100008f <stor_regs>
 1000338:	48 cf                	iretq  

000000000100033a <isr_stub_16>:
 100033a:	e8 d1 fc ff ff       	call   1000010 <save_regs>
 100033f:	bf 10 00 00 00       	mov    $0x10,%edi
 1000344:	48 89 de             	mov    %rbx,%rsi
 1000347:	55                   	push   %rbp
 1000348:	48 89 e5             	mov    %rsp,%rbp
 100034b:	e8 0c 6c 00 00       	call   1006f5c <isr_no_err>
 1000350:	5d                   	pop    %rbp
 1000351:	e8 39 fd ff ff       	call   100008f <stor_regs>
 1000356:	48 cf                	iretq  

0000000001000358 <isr_stub_17>:
 1000358:	50                   	push   %rax
 1000359:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 100035e:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 1000363:	58                   	pop    %rax
 1000364:	48 83 c4 08          	add    $0x8,%rsp
 1000368:	e8 a3 fc ff ff       	call   1000010 <save_regs>
 100036d:	bf 11 00 00 00       	mov    $0x11,%edi
 1000372:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
 1000377:	be 00 00 01 00       	mov    $0x10000,%esi
 100037c:	55                   	push   %rbp
 100037d:	48 89 e5             	mov    %rsp,%rbp
 1000380:	e8 ba 6b 00 00       	call   1006f3f <isr_err>
 1000385:	5d                   	pop    %rbp
 1000386:	e8 04 fd ff ff       	call   100008f <stor_regs>
 100038b:	48 cf                	iretq  

000000000100038d <isr_stub_18>:
 100038d:	e8 7e fc ff ff       	call   1000010 <save_regs>
 1000392:	bf 12 00 00 00       	mov    $0x12,%edi
 1000397:	48 89 de             	mov    %rbx,%rsi
 100039a:	55                   	push   %rbp
 100039b:	48 89 e5             	mov    %rsp,%rbp
 100039e:	e8 b9 6b 00 00       	call   1006f5c <isr_no_err>
 10003a3:	5d                   	pop    %rbp
 10003a4:	e8 e6 fc ff ff       	call   100008f <stor_regs>
 10003a9:	48 cf                	iretq  

00000000010003ab <isr_stub_19>:
 10003ab:	e8 60 fc ff ff       	call   1000010 <save_regs>
 10003b0:	bf 13 00 00 00       	mov    $0x13,%edi
 10003b5:	48 89 de             	mov    %rbx,%rsi
 10003b8:	55                   	push   %rbp
 10003b9:	48 89 e5             	mov    %rsp,%rbp
 10003bc:	e8 9b 6b 00 00       	call   1006f5c <isr_no_err>
 10003c1:	5d                   	pop    %rbp
 10003c2:	e8 c8 fc ff ff       	call   100008f <stor_regs>
 10003c7:	48 cf                	iretq  

00000000010003c9 <isr_stub_20>:
 10003c9:	e8 42 fc ff ff       	call   1000010 <save_regs>
 10003ce:	bf 14 00 00 00       	mov    $0x14,%edi
 10003d3:	48 89 de             	mov    %rbx,%rsi
 10003d6:	55                   	push   %rbp
 10003d7:	48 89 e5             	mov    %rsp,%rbp
 10003da:	e8 7d 6b 00 00       	call   1006f5c <isr_no_err>
 10003df:	5d                   	pop    %rbp
 10003e0:	e8 aa fc ff ff       	call   100008f <stor_regs>
 10003e5:	48 cf                	iretq  

00000000010003e7 <isr_stub_21>:
 10003e7:	e8 24 fc ff ff       	call   1000010 <save_regs>
 10003ec:	bf 15 00 00 00       	mov    $0x15,%edi
 10003f1:	48 89 de             	mov    %rbx,%rsi
 10003f4:	55                   	push   %rbp
 10003f5:	48 89 e5             	mov    %rsp,%rbp
 10003f8:	e8 5f 6b 00 00       	call   1006f5c <isr_no_err>
 10003fd:	5d                   	pop    %rbp
 10003fe:	e8 8c fc ff ff       	call   100008f <stor_regs>
 1000403:	48 cf                	iretq  

0000000001000405 <isr_stub_22>:
 1000405:	e8 06 fc ff ff       	call   1000010 <save_regs>
 100040a:	bf 16 00 00 00       	mov    $0x16,%edi
 100040f:	48 89 de             	mov    %rbx,%rsi
 1000412:	55                   	push   %rbp
 1000413:	48 89 e5             	mov    %rsp,%rbp
 1000416:	e8 41 6b 00 00       	call   1006f5c <isr_no_err>
 100041b:	5d                   	pop    %rbp
 100041c:	e8 6e fc ff ff       	call   100008f <stor_regs>
 1000421:	48 cf                	iretq  

0000000001000423 <isr_stub_23>:
 1000423:	e8 e8 fb ff ff       	call   1000010 <save_regs>
 1000428:	bf 17 00 00 00       	mov    $0x17,%edi
 100042d:	48 89 de             	mov    %rbx,%rsi
 1000430:	55                   	push   %rbp
 1000431:	48 89 e5             	mov    %rsp,%rbp
 1000434:	e8 23 6b 00 00       	call   1006f5c <isr_no_err>
 1000439:	5d                   	pop    %rbp
 100043a:	e8 50 fc ff ff       	call   100008f <stor_regs>
 100043f:	48 cf                	iretq  

0000000001000441 <isr_stub_24>:
 1000441:	e8 ca fb ff ff       	call   1000010 <save_regs>
 1000446:	bf 18 00 00 00       	mov    $0x18,%edi
 100044b:	48 89 de             	mov    %rbx,%rsi
 100044e:	55                   	push   %rbp
 100044f:	48 89 e5             	mov    %rsp,%rbp
 1000452:	e8 05 6b 00 00       	call   1006f5c <isr_no_err>
 1000457:	5d                   	pop    %rbp
 1000458:	e8 32 fc ff ff       	call   100008f <stor_regs>
 100045d:	48 cf                	iretq  

000000000100045f <isr_stub_25>:
 100045f:	e8 ac fb ff ff       	call   1000010 <save_regs>
 1000464:	bf 19 00 00 00       	mov    $0x19,%edi
 1000469:	48 89 de             	mov    %rbx,%rsi
 100046c:	55                   	push   %rbp
 100046d:	48 89 e5             	mov    %rsp,%rbp
 1000470:	e8 e7 6a 00 00       	call   1006f5c <isr_no_err>
 1000475:	5d                   	pop    %rbp
 1000476:	e8 14 fc ff ff       	call   100008f <stor_regs>
 100047b:	48 cf                	iretq  

000000000100047d <isr_stub_26>:
 100047d:	e8 8e fb ff ff       	call   1000010 <save_regs>
 1000482:	bf 1a 00 00 00       	mov    $0x1a,%edi
 1000487:	48 89 de             	mov    %rbx,%rsi
 100048a:	55                   	push   %rbp
 100048b:	48 89 e5             	mov    %rsp,%rbp
 100048e:	e8 c9 6a 00 00       	call   1006f5c <isr_no_err>
 1000493:	5d                   	pop    %rbp
 1000494:	e8 f6 fb ff ff       	call   100008f <stor_regs>
 1000499:	48 cf                	iretq  

000000000100049b <isr_stub_27>:
 100049b:	e8 70 fb ff ff       	call   1000010 <save_regs>
 10004a0:	bf 1b 00 00 00       	mov    $0x1b,%edi
 10004a5:	48 89 de             	mov    %rbx,%rsi
 10004a8:	55                   	push   %rbp
 10004a9:	48 89 e5             	mov    %rsp,%rbp
 10004ac:	e8 ab 6a 00 00       	call   1006f5c <isr_no_err>
 10004b1:	5d                   	pop    %rbp
 10004b2:	e8 d8 fb ff ff       	call   100008f <stor_regs>
 10004b7:	48 cf                	iretq  

00000000010004b9 <isr_stub_28>:
 10004b9:	e8 52 fb ff ff       	call   1000010 <save_regs>
 10004be:	bf 1c 00 00 00       	mov    $0x1c,%edi
 10004c3:	48 89 de             	mov    %rbx,%rsi
 10004c6:	55                   	push   %rbp
 10004c7:	48 89 e5             	mov    %rsp,%rbp
 10004ca:	e8 8d 6a 00 00       	call   1006f5c <isr_no_err>
 10004cf:	5d                   	pop    %rbp
 10004d0:	e8 ba fb ff ff       	call   100008f <stor_regs>
 10004d5:	48 cf                	iretq  

00000000010004d7 <isr_stub_29>:
 10004d7:	e8 34 fb ff ff       	call   1000010 <save_regs>
 10004dc:	bf 1d 00 00 00       	mov    $0x1d,%edi
 10004e1:	48 89 de             	mov    %rbx,%rsi
 10004e4:	55                   	push   %rbp
 10004e5:	48 89 e5             	mov    %rsp,%rbp
 10004e8:	e8 6f 6a 00 00       	call   1006f5c <isr_no_err>
 10004ed:	5d                   	pop    %rbp
 10004ee:	e8 9c fb ff ff       	call   100008f <stor_regs>
 10004f3:	48 cf                	iretq  

00000000010004f5 <isr_stub_30>:
 10004f5:	50                   	push   %rax
 10004f6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10004fb:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 1000500:	58                   	pop    %rax
 1000501:	48 83 c4 08          	add    $0x8,%rsp
 1000505:	e8 06 fb ff ff       	call   1000010 <save_regs>
 100050a:	bf 1e 00 00 00       	mov    $0x1e,%edi
 100050f:	48 8b 54 24 e8       	mov    -0x18(%rsp),%rdx
 1000514:	be 00 00 01 00       	mov    $0x10000,%esi
 1000519:	55                   	push   %rbp
 100051a:	48 89 e5             	mov    %rsp,%rbp
 100051d:	e8 1d 6a 00 00       	call   1006f3f <isr_err>
 1000522:	5d                   	pop    %rbp
 1000523:	e8 67 fb ff ff       	call   100008f <stor_regs>
 1000528:	48 cf                	iretq  

000000000100052a <isr_stub_31>:
 100052a:	e8 e1 fa ff ff       	call   1000010 <save_regs>
 100052f:	bf 1f 00 00 00       	mov    $0x1f,%edi
 1000534:	48 89 de             	mov    %rbx,%rsi
 1000537:	55                   	push   %rbp
 1000538:	48 89 e5             	mov    %rsp,%rbp
 100053b:	e8 1c 6a 00 00       	call   1006f5c <isr_no_err>
 1000540:	5d                   	pop    %rbp
 1000541:	e8 49 fb ff ff       	call   100008f <stor_regs>
 1000546:	48 cf                	iretq  

0000000001000548 <isr_stub_32>:
 1000548:	e8 c3 fa ff ff       	call   1000010 <save_regs>
 100054d:	bf 20 00 00 00       	mov    $0x20,%edi
 1000552:	48 89 de             	mov    %rbx,%rsi
 1000555:	55                   	push   %rbp
 1000556:	48 89 e5             	mov    %rsp,%rbp
 1000559:	e8 1a 6a 00 00       	call   1006f78 <irq_isr>
 100055e:	5d                   	pop    %rbp
 100055f:	e8 2b fb ff ff       	call   100008f <stor_regs>
 1000564:	48 cf                	iretq  

0000000001000566 <isr_stub_33>:
 1000566:	e8 a5 fa ff ff       	call   1000010 <save_regs>
 100056b:	bf 21 00 00 00       	mov    $0x21,%edi
 1000570:	48 89 de             	mov    %rbx,%rsi
 1000573:	55                   	push   %rbp
 1000574:	48 89 e5             	mov    %rsp,%rbp
 1000577:	e8 fc 69 00 00       	call   1006f78 <irq_isr>
 100057c:	5d                   	pop    %rbp
 100057d:	e8 0d fb ff ff       	call   100008f <stor_regs>
 1000582:	48 cf                	iretq  

0000000001000584 <isr_stub_34>:
 1000584:	e8 87 fa ff ff       	call   1000010 <save_regs>
 1000589:	bf 22 00 00 00       	mov    $0x22,%edi
 100058e:	48 89 de             	mov    %rbx,%rsi
 1000591:	55                   	push   %rbp
 1000592:	48 89 e5             	mov    %rsp,%rbp
 1000595:	e8 de 69 00 00       	call   1006f78 <irq_isr>
 100059a:	5d                   	pop    %rbp
 100059b:	e8 ef fa ff ff       	call   100008f <stor_regs>
 10005a0:	48 cf                	iretq  

00000000010005a2 <isr_stub_35>:
 10005a2:	e8 69 fa ff ff       	call   1000010 <save_regs>
 10005a7:	bf 23 00 00 00       	mov    $0x23,%edi
 10005ac:	48 89 de             	mov    %rbx,%rsi
 10005af:	55                   	push   %rbp
 10005b0:	48 89 e5             	mov    %rsp,%rbp
 10005b3:	e8 c0 69 00 00       	call   1006f78 <irq_isr>
 10005b8:	5d                   	pop    %rbp
 10005b9:	e8 d1 fa ff ff       	call   100008f <stor_regs>
 10005be:	48 cf                	iretq  

00000000010005c0 <isr_stub_36>:
 10005c0:	e8 4b fa ff ff       	call   1000010 <save_regs>
 10005c5:	bf 24 00 00 00       	mov    $0x24,%edi
 10005ca:	48 89 de             	mov    %rbx,%rsi
 10005cd:	55                   	push   %rbp
 10005ce:	48 89 e5             	mov    %rsp,%rbp
 10005d1:	e8 a2 69 00 00       	call   1006f78 <irq_isr>
 10005d6:	5d                   	pop    %rbp
 10005d7:	e8 b3 fa ff ff       	call   100008f <stor_regs>
 10005dc:	48 cf                	iretq  

00000000010005de <isr_stub_37>:
 10005de:	e8 2d fa ff ff       	call   1000010 <save_regs>
 10005e3:	bf 25 00 00 00       	mov    $0x25,%edi
 10005e8:	48 89 de             	mov    %rbx,%rsi
 10005eb:	55                   	push   %rbp
 10005ec:	48 89 e5             	mov    %rsp,%rbp
 10005ef:	e8 84 69 00 00       	call   1006f78 <irq_isr>
 10005f4:	5d                   	pop    %rbp
 10005f5:	e8 95 fa ff ff       	call   100008f <stor_regs>
 10005fa:	48 cf                	iretq  

00000000010005fc <isr_stub_38>:
 10005fc:	e8 0f fa ff ff       	call   1000010 <save_regs>
 1000601:	bf 26 00 00 00       	mov    $0x26,%edi
 1000606:	48 89 de             	mov    %rbx,%rsi
 1000609:	55                   	push   %rbp
 100060a:	48 89 e5             	mov    %rsp,%rbp
 100060d:	e8 66 69 00 00       	call   1006f78 <irq_isr>
 1000612:	5d                   	pop    %rbp
 1000613:	e8 77 fa ff ff       	call   100008f <stor_regs>
 1000618:	48 cf                	iretq  

000000000100061a <isr_stub_39>:
 100061a:	e8 f1 f9 ff ff       	call   1000010 <save_regs>
 100061f:	bf 27 00 00 00       	mov    $0x27,%edi
 1000624:	48 89 de             	mov    %rbx,%rsi
 1000627:	55                   	push   %rbp
 1000628:	48 89 e5             	mov    %rsp,%rbp
 100062b:	e8 48 69 00 00       	call   1006f78 <irq_isr>
 1000630:	5d                   	pop    %rbp
 1000631:	e8 59 fa ff ff       	call   100008f <stor_regs>
 1000636:	48 cf                	iretq  

0000000001000638 <isr_stub_40>:
 1000638:	e8 d3 f9 ff ff       	call   1000010 <save_regs>
 100063d:	bf 28 00 00 00       	mov    $0x28,%edi
 1000642:	48 89 de             	mov    %rbx,%rsi
 1000645:	55                   	push   %rbp
 1000646:	48 89 e5             	mov    %rsp,%rbp
 1000649:	e8 2a 69 00 00       	call   1006f78 <irq_isr>
 100064e:	5d                   	pop    %rbp
 100064f:	e8 3b fa ff ff       	call   100008f <stor_regs>
 1000654:	48 cf                	iretq  

0000000001000656 <isr_stub_41>:
 1000656:	e8 b5 f9 ff ff       	call   1000010 <save_regs>
 100065b:	bf 29 00 00 00       	mov    $0x29,%edi
 1000660:	48 89 de             	mov    %rbx,%rsi
 1000663:	55                   	push   %rbp
 1000664:	48 89 e5             	mov    %rsp,%rbp
 1000667:	e8 0c 69 00 00       	call   1006f78 <irq_isr>
 100066c:	5d                   	pop    %rbp
 100066d:	e8 1d fa ff ff       	call   100008f <stor_regs>
 1000672:	48 cf                	iretq  

0000000001000674 <isr_stub_42>:
 1000674:	e8 97 f9 ff ff       	call   1000010 <save_regs>
 1000679:	bf 2a 00 00 00       	mov    $0x2a,%edi
 100067e:	48 89 de             	mov    %rbx,%rsi
 1000681:	55                   	push   %rbp
 1000682:	48 89 e5             	mov    %rsp,%rbp
 1000685:	e8 ee 68 00 00       	call   1006f78 <irq_isr>
 100068a:	5d                   	pop    %rbp
 100068b:	e8 ff f9 ff ff       	call   100008f <stor_regs>
 1000690:	48 cf                	iretq  

0000000001000692 <isr_stub_43>:
 1000692:	e8 79 f9 ff ff       	call   1000010 <save_regs>
 1000697:	bf 2b 00 00 00       	mov    $0x2b,%edi
 100069c:	48 89 de             	mov    %rbx,%rsi
 100069f:	55                   	push   %rbp
 10006a0:	48 89 e5             	mov    %rsp,%rbp
 10006a3:	e8 d0 68 00 00       	call   1006f78 <irq_isr>
 10006a8:	5d                   	pop    %rbp
 10006a9:	e8 e1 f9 ff ff       	call   100008f <stor_regs>
 10006ae:	48 cf                	iretq  

00000000010006b0 <isr_stub_44>:
 10006b0:	e8 5b f9 ff ff       	call   1000010 <save_regs>
 10006b5:	bf 2c 00 00 00       	mov    $0x2c,%edi
 10006ba:	48 89 de             	mov    %rbx,%rsi
 10006bd:	55                   	push   %rbp
 10006be:	48 89 e5             	mov    %rsp,%rbp
 10006c1:	e8 b2 68 00 00       	call   1006f78 <irq_isr>
 10006c6:	5d                   	pop    %rbp
 10006c7:	e8 c3 f9 ff ff       	call   100008f <stor_regs>
 10006cc:	48 cf                	iretq  

00000000010006ce <isr_stub_45>:
 10006ce:	e8 3d f9 ff ff       	call   1000010 <save_regs>
 10006d3:	bf 2d 00 00 00       	mov    $0x2d,%edi
 10006d8:	48 89 de             	mov    %rbx,%rsi
 10006db:	55                   	push   %rbp
 10006dc:	48 89 e5             	mov    %rsp,%rbp
 10006df:	e8 94 68 00 00       	call   1006f78 <irq_isr>
 10006e4:	5d                   	pop    %rbp
 10006e5:	e8 a5 f9 ff ff       	call   100008f <stor_regs>
 10006ea:	48 cf                	iretq  

00000000010006ec <isr_stub_46>:
 10006ec:	e8 1f f9 ff ff       	call   1000010 <save_regs>
 10006f1:	bf 2e 00 00 00       	mov    $0x2e,%edi
 10006f6:	48 89 de             	mov    %rbx,%rsi
 10006f9:	55                   	push   %rbp
 10006fa:	48 89 e5             	mov    %rsp,%rbp
 10006fd:	e8 76 68 00 00       	call   1006f78 <irq_isr>
 1000702:	5d                   	pop    %rbp
 1000703:	e8 87 f9 ff ff       	call   100008f <stor_regs>
 1000708:	48 cf                	iretq  

000000000100070a <isr_stub_47>:
 100070a:	e8 01 f9 ff ff       	call   1000010 <save_regs>
 100070f:	bf 2f 00 00 00       	mov    $0x2f,%edi
 1000714:	48 89 de             	mov    %rbx,%rsi
 1000717:	55                   	push   %rbp
 1000718:	48 89 e5             	mov    %rsp,%rbp
 100071b:	e8 58 68 00 00       	call   1006f78 <irq_isr>
 1000720:	5d                   	pop    %rbp
 1000721:	e8 69 f9 ff ff       	call   100008f <stor_regs>
 1000726:	48 cf                	iretq  

0000000001000728 <isr_stub_table>:
 1000728:	d0 00                	rolb   (%rax)
 100072a:	00 01                	add    %al,(%rcx)
 100072c:	ee                   	out    %al,(%dx)
 100072d:	00 00                	add    %al,(%rax)
 100072f:	01 0c 01             	add    %ecx,(%rcx,%rax,1)
 1000732:	00 01                	add    %al,(%rcx)
 1000734:	2a 01                	sub    (%rcx),%al
 1000736:	00 01                	add    %al,(%rcx)
 1000738:	48 01 00             	add    %rax,(%rax)
 100073b:	01 66 01             	add    %esp,0x1(%rsi)
 100073e:	00 01                	add    %al,(%rcx)
 1000740:	84 01                	test   %al,(%rcx)
 1000742:	00 01                	add    %al,(%rcx)
 1000744:	a2 01 00 01 c0 01 00 	movabs %al,0xf5010001c0010001
 100074b:	01 f5 
 100074d:	01 00                	add    %eax,(%rax)
 100074f:	01 13                	add    %edx,(%rbx)
 1000751:	02 00                	add    (%rax),%al
 1000753:	01 48 02             	add    %ecx,0x2(%rax)
 1000756:	00 01                	add    %al,(%rcx)
 1000758:	7d 02                	jge    100075c <isr_stub_table+0x34>
 100075a:	00 01                	add    %al,(%rcx)
 100075c:	b2 02                	mov    $0x2,%dl
 100075e:	00 01                	add    %al,(%rcx)
 1000760:	e7 02                	out    %eax,$0x2
 1000762:	00 01                	add    %al,(%rcx)
 1000764:	1c 03                	sbb    $0x3,%al
 1000766:	00 01                	add    %al,(%rcx)
 1000768:	3a 03                	cmp    (%rbx),%al
 100076a:	00 01                	add    %al,(%rcx)
 100076c:	58                   	pop    %rax
 100076d:	03 00                	add    (%rax),%eax
 100076f:	01 8d 03 00 01 ab    	add    %ecx,-0x54fefffd(%rbp)
 1000775:	03 00                	add    (%rax),%eax
 1000777:	01 c9                	add    %ecx,%ecx
 1000779:	03 00                	add    (%rax),%eax
 100077b:	01 e7                	add    %esp,%edi
 100077d:	03 00                	add    (%rax),%eax
 100077f:	01 05 04 00 01 23    	add    %eax,0x23010004(%rip)        # 24010789 <_ZL19reference_timepoint+0x23007a11>
 1000785:	04 00                	add    $0x0,%al
 1000787:	01 41 04             	add    %eax,0x4(%rcx)
 100078a:	00 01                	add    %al,(%rcx)
 100078c:	5f                   	pop    %rdi
 100078d:	04 00                	add    $0x0,%al
 100078f:	01 7d 04             	add    %edi,0x4(%rbp)
 1000792:	00 01                	add    %al,(%rcx)
 1000794:	9b                   	fwait
 1000795:	04 00                	add    $0x0,%al
 1000797:	01 b9 04 00 01 d7    	add    %edi,-0x28fefffc(%rcx)
 100079d:	04 00                	add    $0x0,%al
 100079f:	01 f5                	add    %esi,%ebp
 10007a1:	04 00                	add    $0x0,%al
 10007a3:	01 2a                	add    %ebp,(%rdx)
 10007a5:	05 00 01 48 05       	add    $0x5480100,%eax
 10007aa:	00 01                	add    %al,(%rcx)
 10007ac:	66 05 00 01          	add    $0x100,%ax
 10007b0:	84 05 00 01 a2 05    	test   %al,0x5a20100(%rip)        # 6a208b6 <_ZL19reference_timepoint+0x5a17b3e>
 10007b6:	00 01                	add    %al,(%rcx)
 10007b8:	c0 05 00 01 de 05 00 	rolb   $0x0,0x5de0100(%rip)        # 6de08bf <_ZL19reference_timepoint+0x5dd7b47>
 10007bf:	01 fc                	add    %edi,%esp
 10007c1:	05 00 01 1a 06       	add    $0x61a0100,%eax
 10007c6:	00 01                	add    %al,(%rcx)
 10007c8:	38 06                	cmp    %al,(%rsi)
 10007ca:	00 01                	add    %al,(%rcx)
 10007cc:	56                   	push   %rsi
 10007cd:	06                   	(bad)  
 10007ce:	00 01                	add    %al,(%rcx)
 10007d0:	74 06                	je     10007d8 <isr_stub_table+0xb0>
 10007d2:	00 01                	add    %al,(%rcx)
 10007d4:	92                   	xchg   %eax,%edx
 10007d5:	06                   	(bad)  
 10007d6:	00 01                	add    %al,(%rcx)
 10007d8:	b0 06                	mov    $0x6,%al
 10007da:	00 01                	add    %al,(%rcx)
 10007dc:	ce                   	(bad)  
 10007dd:	06                   	(bad)  
 10007de:	00 01                	add    %al,(%rcx)
 10007e0:	ec                   	in     (%dx),%al
 10007e1:	06                   	(bad)  
 10007e2:	00 01                	add    %al,(%rcx)
 10007e4:	0a 07                	or     (%rdi),%al
 10007e6:	00 01                	add    %al,(%rcx)

00000000010007e8 <load_idt>:
 10007e8:	fa                   	cli    
 10007e9:	0f 01 1f             	lidt   (%rdi)
 10007ec:	b0 ff                	mov    $0xff,%al
 10007ee:	e6 21                	out    %al,$0x21
 10007f0:	e6 a1                	out    %al,$0xa1
 10007f2:	fb                   	sti    
 10007f3:	c3                   	ret    

00000000010007f4 <_Z9ahci_init10pci_device>:
 10007f4:	53                   	push   %rbx
 10007f5:	48 83 ec 20          	sub    $0x20,%rsp
 10007f9:	48 8d 44 24 30       	lea    0x30(%rsp),%rax
 10007fe:	b9 0c 20 01 00       	mov    $0x1200c,%ecx
 1000803:	48 8b 14 25 20 00 11 	mov    0x110020,%rdx
 100080a:	00 
 100080b:	48 83 c2 0f          	add    $0xf,%rdx
 100080f:	48 83 e2 f0          	and    $0xfffffffffffffff0,%rdx
 1000813:	48 8d 72 28          	lea    0x28(%rdx),%rsi
 1000817:	48 89 34 25 20 00 11 	mov    %rsi,0x110020
 100081e:	00 
 100081f:	48 89 14 25 c8 00 11 	mov    %rdx,0x1100c8
 1000826:	00 
 1000827:	31 d2                	xor    %edx,%edx
 1000829:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 100082d:	c5 fc 29 84 11 f4 0f 	vmovaps %ymm0,0xff4(%rcx,%rdx,1)
 1000834:	00 00 
 1000836:	48 83 c2 20          	add    $0x20,%rdx
 100083a:	48 81 fa 00 20 00 00 	cmp    $0x2000,%rdx
 1000841:	75 ea                	jne    100082d <_Z9ahci_init10pci_device+0x39>
 1000843:	8b 50 24             	mov    0x24(%rax),%edx
 1000846:	89 d0                	mov    %edx,%eax
 1000848:	83 e0 f0             	and    $0xfffffff0,%eax
 100084b:	89 d6                	mov    %edx,%esi
 100084d:	c1 ee 15             	shr    $0x15,%esi
 1000850:	48 83 8c f1 f4 ff 05 	orq    $0x8,0x5fff4(%rcx,%rsi,8)
 1000857:	00 08 
 1000859:	81 c2 00 01 00 00    	add    $0x100,%edx
 100085f:	48 8d 7a 28          	lea    0x28(%rdx),%rdi
 1000863:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1000868:	45 31 c0             	xor    %r8d,%r8d
 100086b:	44 8b 48 0c          	mov    0xc(%rax),%r9d
 100086f:	45 0f a3 c1          	bt     %r8d,%r9d
 1000873:	73 07                	jae    100087c <_Z9ahci_init10pci_device+0x88>
 1000875:	83 3f 00             	cmpl   $0x0,(%rdi)
 1000878:	41 0f 45 f0          	cmovne %r8d,%esi
 100087c:	49 ff c0             	inc    %r8
 100087f:	48 83 ef 80          	sub    $0xffffffffffffff80,%rdi
 1000883:	49 83 f8 20          	cmp    $0x20,%r8
 1000887:	75 e2                	jne    100086b <_Z9ahci_init10pci_device+0x77>
 1000889:	4c 63 ce             	movslq %esi,%r9
 100088c:	49 c1 e1 07          	shl    $0x7,%r9
 1000890:	4a 8d 3c 0a          	lea    (%rdx,%r9,1),%rdi
 1000894:	48 83 c7 18          	add    $0x18,%rdi
 1000898:	83 27 ee             	andl   $0xffffffee,(%rdi)
 100089b:	f7 07 00 c0 00 00    	testl  $0xc000,(%rdi)
 10008a1:	75 f8                	jne    100089b <_Z9ahci_init10pci_device+0xa7>
 10008a3:	4a 8d 34 0a          	lea    (%rdx,%r9,1),%rsi
 10008a7:	42 c7 04 0a 00 20 01 	movl   $0x12000,(%rdx,%r9,1)
 10008ae:	00 
 10008af:	45 31 c0             	xor    %r8d,%r8d
 10008b2:	46 89 44 0a 04       	mov    %r8d,0x4(%rdx,%r9,1)
 10008b7:	42 c7 44 0a 08 00 28 	movl   $0x12800,0x8(%rdx,%r9,1)
 10008be:	01 00 
 10008c0:	46 89 44 0a 0c       	mov    %r8d,0xc(%rdx,%r9,1)
 10008c5:	ba 00 30 01 00       	mov    $0x13000,%edx
 10008ca:	42 89 54 01 fc       	mov    %edx,-0x4(%rcx,%r8,1)
 10008cf:	42 c7 04 01 00 00 00 	movl   $0x0,(%rcx,%r8,1)
 10008d6:	00 
 10008d7:	66 42 c7 44 01 f6 08 	movw   $0x8,-0xa(%rcx,%r8,1)
 10008de:	00 
 10008df:	81 c2 00 01 00 00    	add    $0x100,%edx
 10008e5:	49 83 c0 20          	add    $0x20,%r8
 10008e9:	49 81 f8 00 04 00 00 	cmp    $0x400,%r8
 10008f0:	75 d8                	jne    10008ca <_Z9ahci_init10pci_device+0xd6>
 10008f2:	83 0f 11             	orl    $0x11,(%rdi)
 10008f5:	8b 0f                	mov    (%rdi),%ecx
 10008f7:	f7 d1                	not    %ecx
 10008f9:	f7 c1 00 c0 00 00    	test   $0xc000,%ecx
 10008ff:	74 15                	je     1000916 <_Z9ahci_init10pci_device+0x122>
 1000901:	b9 02 00 00 02       	mov    $0x2000002,%ecx
 1000906:	ff c9                	dec    %ecx
 1000908:	74 3c                	je     1000946 <_Z9ahci_init10pci_device+0x152>
 100090a:	8b 17                	mov    (%rdi),%edx
 100090c:	f7 d2                	not    %edx
 100090e:	f7 c2 00 c0 00 00    	test   $0xc000,%edx
 1000914:	75 f0                	jne    1000906 <_Z9ahci_init10pci_device+0x112>
 1000916:	48 8b 0c 25 c8 00 11 	mov    0x1100c8,%rcx
 100091d:	00 
 100091e:	48 89 01             	mov    %rax,(%rcx)
 1000921:	48 89 71 08          	mov    %rsi,0x8(%rcx)
 1000925:	48 c7 41 10 00 20 01 	movq   $0x12000,0x10(%rcx)
 100092c:	00 
 100092d:	48 c7 41 18 00 28 01 	movq   $0x12800,0x18(%rcx)
 1000934:	00 
 1000935:	48 c7 41 20 00 30 01 	movq   $0x13000,0x20(%rcx)
 100093c:	00 
 100093d:	48 83 c4 20          	add    $0x20,%rsp
 1000941:	5b                   	pop    %rbx
 1000942:	c5 f8 77             	vzeroupper 
 1000945:	c3                   	ret    
 1000946:	48 89 e6             	mov    %rsp,%rsi
 1000949:	48 c7 06 6f 87 00 01 	movq   $0x100876f,(%rsi)
 1000950:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
 1000957:	8b 17                	mov    (%rdi),%edx
 1000959:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
 100095e:	48 89 df             	mov    %rbx,%rdi
 1000961:	31 c0                	xor    %eax,%eax
 1000963:	c5 f8 77             	vzeroupper 
 1000966:	e8 5e 08 00 00       	call   10011c9 <_Z6format8rostringz>
 100096b:	48 89 df             	mov    %rbx,%rdi
 100096e:	e8 0d 0f 00 00       	call   1001880 <_ZN6string10c_str_thisEv>
 1000973:	bf 00 00 11 00       	mov    $0x110000,%edi
 1000978:	48 89 c6             	mov    %rax,%rsi
 100097b:	e8 1a 08 00 00       	call   100119a <_ZN7console6putstrEPKc>
 1000980:	48 89 df             	mov    %rbx,%rdi
 1000983:	e8 0a 5d 00 00       	call   1006692 <_ZN6vectorIcED2Ev>
 1000988:	eb fe                	jmp    1000988 <_Z9ahci_init10pci_device+0x194>

000000000100098a <_Z6memsetPvcm>:
 100098a:	48 85 d2             	test   %rdx,%rdx
 100098d:	0f 84 f3 07 00 00    	je     1001186 <_Z6memsetPvcm+0x7fc>
 1000993:	48 8d 42 1f          	lea    0x1f(%rdx),%rax
 1000997:	48 83 e0 e0          	and    $0xffffffffffffffe0,%rax
 100099b:	48 ff ca             	dec    %rdx
 100099e:	c4 e1 f9 6e c2       	vmovq  %rdx,%xmm0
 10009a3:	c4 e2 7d 59 c0       	vpbroadcastq %xmm0,%ymm0
 10009a8:	c5 fd 6f 0d 50 78 00 	vmovdqa 0x7850(%rip),%ymm1        # 1008200 <_ZL4lfsr+0xc0>
 10009af:	00 
 10009b0:	c5 fd 6f 15 e8 77 00 	vmovdqa 0x77e8(%rip),%ymm2        # 10081a0 <_ZL4lfsr+0x60>
 10009b7:	00 
 10009b8:	c5 fd 6f 1d c0 77 00 	vmovdqa 0x77c0(%rip),%ymm3        # 1008180 <_ZL4lfsr+0x40>
 10009bf:	00 
 10009c0:	c5 fd 6f 25 98 77 00 	vmovdqa 0x7798(%rip),%ymm4        # 1008160 <_ZL4lfsr+0x20>
 10009c7:	00 
 10009c8:	c5 fd 6f 2d f0 77 00 	vmovdqa 0x77f0(%rip),%ymm5        # 10081c0 <_ZL4lfsr+0x80>
 10009cf:	00 
 10009d0:	c5 fd 6f 35 68 78 00 	vmovdqa 0x7868(%rip),%ymm6        # 1008240 <_ZL4lfsr+0x100>
 10009d7:	00 
 10009d8:	c5 fd 6f 3d 80 78 00 	vmovdqa 0x7880(%rip),%ymm7        # 1008260 <_ZL4lfsr+0x120>
 10009df:	00 
 10009e0:	c5 7d 6f 05 f8 77 00 	vmovdqa 0x77f8(%rip),%ymm8        # 10081e0 <_ZL4lfsr+0xa0>
 10009e7:	00 
 10009e8:	31 c9                	xor    %ecx,%ecx
 10009ea:	c4 62 79 59 0d ad 78 	vpbroadcastq 0x78ad(%rip),%xmm9        # 10082a0 <_ZL4lfsr+0x160>
 10009f1:	00 00 
 10009f3:	c4 41 29 76 d2       	vpcmpeqd %xmm10,%xmm10,%xmm10
 10009f8:	c4 62 7d 59 1d 9f 78 	vpbroadcastq 0x789f(%rip),%ymm11        # 10082a0 <_ZL4lfsr+0x160>
 10009ff:	00 00 
 1000a01:	c4 62 79 58 35 9e 78 	vpbroadcastd 0x789e(%rip),%xmm14        # 10082a8 <_ZL4lfsr+0x168>
 1000a08:	00 00 
 1000a0a:	c4 62 7d 59 25 75 78 	vpbroadcastq 0x7875(%rip),%ymm12        # 1008288 <_ZL4lfsr+0x148>
 1000a11:	00 00 
 1000a13:	c5 7e 7f 64 24 b8    	vmovdqu %ymm12,-0x48(%rsp)
 1000a19:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000a1d:	c4 41 39 ef e9       	vpxor  %xmm9,%xmm8,%xmm13
 1000a22:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000a27:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000a2c:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000a31:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000a36:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000a3b:	c5 79 7e e2          	vmovd  %xmm12,%edx
 1000a3f:	f6 c2 01             	test   $0x1,%dl
 1000a42:	74 04                	je     1000a48 <_Z6memsetPvcm+0xbe>
 1000a44:	40 88 34 0f          	mov    %sil,(%rdi,%rcx,1)
 1000a48:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000a4c:	c4 41 39 ef e9       	vpxor  %xmm9,%xmm8,%xmm13
 1000a51:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000a56:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000a5b:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000a60:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000a65:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000a6a:	c4 63 79 14 e2 01    	vpextrb $0x1,%xmm12,%edx
 1000a70:	f6 c2 01             	test   $0x1,%dl
 1000a73:	74 05                	je     1000a7a <_Z6memsetPvcm+0xf0>
 1000a75:	40 88 74 0f 01       	mov    %sil,0x1(%rdi,%rcx,1)
 1000a7a:	c5 25 ef f8          	vpxor  %ymm0,%ymm11,%ymm15
 1000a7e:	c4 41 3d ef e3       	vpxor  %ymm11,%ymm8,%ymm12
 1000a83:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 1000a88:	c4 41 7f 70 e4 e8    	vpshuflw $0xe8,%ymm12,%ymm12
 1000a8e:	c5 1d ef 25 8a 77 00 	vpxor  0x778a(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 1000a95:	00 
 1000a96:	c4 42 0d 36 e4       	vpermd %ymm12,%ymm14,%ymm12
 1000a9b:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000aa0:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000aa5:	c4 63 79 14 e2 02    	vpextrb $0x2,%xmm12,%edx
 1000aab:	f6 c2 01             	test   $0x1,%dl
 1000aae:	74 05                	je     1000ab5 <_Z6memsetPvcm+0x12b>
 1000ab0:	40 88 74 0f 02       	mov    %sil,0x2(%rdi,%rcx,1)
 1000ab5:	c4 c3 7d 39 c4 01    	vextracti128 $0x1,%ymm0,%xmm12
 1000abb:	c4 41 19 ef e1       	vpxor  %xmm9,%xmm12,%xmm12
 1000ac0:	c4 43 7d 39 c5 01    	vextracti128 $0x1,%ymm8,%xmm13
 1000ac6:	c4 41 11 ef e9       	vpxor  %xmm9,%xmm13,%xmm13
 1000acb:	c5 79 7f 64 24 a8    	vmovdqa %xmm12,-0x58(%rsp)
 1000ad1:	c4 42 11 37 ec       	vpcmpgtq %xmm12,%xmm13,%xmm13
 1000ad6:	c4 41 11 6b ed       	vpackssdw %xmm13,%xmm13,%xmm13
 1000adb:	c4 41 11 ef ea       	vpxor  %xmm10,%xmm13,%xmm13
 1000ae0:	c4 41 11 6b ed       	vpackssdw %xmm13,%xmm13,%xmm13
 1000ae5:	c4 41 11 63 ed       	vpacksswb %xmm13,%xmm13,%xmm13
 1000aea:	c4 63 79 14 ea 03    	vpextrb $0x3,%xmm13,%edx
 1000af0:	f6 c2 01             	test   $0x1,%dl
 1000af3:	74 05                	je     1000afa <_Z6memsetPvcm+0x170>
 1000af5:	40 88 74 0f 03       	mov    %sil,0x3(%rdi,%rcx,1)
 1000afa:	c5 31 ef e8          	vpxor  %xmm0,%xmm9,%xmm13
 1000afe:	c5 31 ef e7          	vpxor  %xmm7,%xmm9,%xmm12
 1000b02:	c4 42 19 37 e5       	vpcmpgtq %xmm13,%xmm12,%xmm12
 1000b07:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000b0c:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000b11:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000b17:	c5 1d 6b e0          	vpackssdw %ymm0,%ymm12,%ymm12
 1000b1b:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000b21:	c4 42 79 79 e4       	vpbroadcastw %xmm12,%xmm12
 1000b26:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000b2b:	c4 63 79 14 e2 04    	vpextrb $0x4,%xmm12,%edx
 1000b31:	f6 c2 01             	test   $0x1,%dl
 1000b34:	74 05                	je     1000b3b <_Z6memsetPvcm+0x1b1>
 1000b36:	40 88 74 0f 04       	mov    %sil,0x4(%rdi,%rcx,1)
 1000b3b:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000b3f:	c5 31 ef ef          	vpxor  %xmm7,%xmm9,%xmm13
 1000b43:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000b48:	c4 41 7a 70 e4 84    	vpshufhw $0x84,%xmm12,%xmm12
 1000b4e:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000b53:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000b59:	c5 1d 6b e0          	vpackssdw %ymm0,%ymm12,%ymm12
 1000b5d:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000b63:	c4 42 79 58 e4       	vpbroadcastd %xmm12,%xmm12
 1000b68:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000b6d:	c4 63 79 14 e2 05    	vpextrb $0x5,%xmm12,%edx
 1000b73:	f6 c2 01             	test   $0x1,%dl
 1000b76:	74 05                	je     1000b7d <_Z6memsetPvcm+0x1f3>
 1000b78:	40 88 74 0f 05       	mov    %sil,0x5(%rdi,%rcx,1)
 1000b7d:	c5 25 ef e7          	vpxor  %ymm7,%ymm11,%ymm12
 1000b81:	c4 42 1d 37 ef       	vpcmpgtq %ymm15,%ymm12,%ymm13
 1000b86:	c4 41 7d 6b e5       	vpackssdw %ymm13,%ymm0,%ymm12
 1000b8b:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000b91:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000b96:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000b9b:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000ba0:	c4 63 79 14 e2 06    	vpextrb $0x6,%xmm12,%edx
 1000ba6:	f6 c2 01             	test   $0x1,%dl
 1000ba9:	74 05                	je     1000bb0 <_Z6memsetPvcm+0x226>
 1000bab:	40 88 74 0f 06       	mov    %sil,0x6(%rdi,%rcx,1)
 1000bb0:	c4 41 7e 70 e5 84    	vpshufhw $0x84,%ymm13,%ymm12
 1000bb6:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000bbc:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000bc1:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000bc6:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000bcb:	c4 63 79 14 e2 07    	vpextrb $0x7,%xmm12,%edx
 1000bd1:	f6 c2 01             	test   $0x1,%dl
 1000bd4:	74 05                	je     1000bdb <_Z6memsetPvcm+0x251>
 1000bd6:	40 88 74 0f 07       	mov    %sil,0x7(%rdi,%rcx,1)
 1000bdb:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000bdf:	c5 31 ef ee          	vpxor  %xmm6,%xmm9,%xmm13
 1000be3:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000be8:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000bed:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000bf2:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000bf7:	c4 42 7d 33 e4       	vpmovzxwd %xmm12,%ymm12
 1000bfc:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1000c00:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000c06:	c5 79 7e e2          	vmovd  %xmm12,%edx
 1000c0a:	f6 c2 01             	test   $0x1,%dl
 1000c0d:	74 05                	je     1000c14 <_Z6memsetPvcm+0x28a>
 1000c0f:	40 88 74 0f 08       	mov    %sil,0x8(%rdi,%rcx,1)
 1000c14:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000c18:	c5 31 ef ee          	vpxor  %xmm6,%xmm9,%xmm13
 1000c1c:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000c21:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000c26:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000c2b:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000c30:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000c36:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1000c3a:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000c40:	c4 63 79 14 e2 01    	vpextrb $0x1,%xmm12,%edx
 1000c46:	f6 c2 01             	test   $0x1,%dl
 1000c49:	74 05                	je     1000c50 <_Z6memsetPvcm+0x2c6>
 1000c4b:	40 88 74 0f 09       	mov    %sil,0x9(%rdi,%rcx,1)
 1000c50:	c5 25 ef e6          	vpxor  %ymm6,%ymm11,%ymm12
 1000c54:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 1000c59:	c4 41 7f 70 e4 e8    	vpshuflw $0xe8,%ymm12,%ymm12
 1000c5f:	c5 1d ef 25 b9 75 00 	vpxor  0x75b9(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 1000c66:	00 
 1000c67:	c4 42 0d 36 e4       	vpermd %ymm12,%ymm14,%ymm12
 1000c6c:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000c71:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000c77:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1000c7b:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000c81:	c4 63 79 14 e2 02    	vpextrb $0x2,%xmm12,%edx
 1000c87:	f6 c2 01             	test   $0x1,%dl
 1000c8a:	74 05                	je     1000c91 <_Z6memsetPvcm+0x307>
 1000c8c:	40 88 74 0f 0a       	mov    %sil,0xa(%rdi,%rcx,1)
 1000c91:	c5 fe 7f 5c 24 d8    	vmovdqu %ymm3,-0x28(%rsp)
 1000c97:	c4 c3 7d 39 f4 01    	vextracti128 $0x1,%ymm6,%xmm12
 1000c9d:	c4 41 19 ef e1       	vpxor  %xmm9,%xmm12,%xmm12
 1000ca2:	c4 62 19 37 64 24 a8 	vpcmpgtq -0x58(%rsp),%xmm12,%xmm12
 1000ca9:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000cae:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000cb3:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000cb8:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000cbe:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1000cc2:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000cc8:	c4 63 79 14 e2 03    	vpextrb $0x3,%xmm12,%edx
 1000cce:	f6 c2 01             	test   $0x1,%dl
 1000cd1:	74 05                	je     1000cd8 <_Z6memsetPvcm+0x34e>
 1000cd3:	40 88 74 0f 0b       	mov    %sil,0xb(%rdi,%rcx,1)
 1000cd8:	c5 fd 6f d9          	vmovdqa %ymm1,%ymm3
 1000cdc:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000ce0:	c5 31 ef ed          	vpxor  %xmm5,%xmm9,%xmm13
 1000ce4:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000ce9:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000cee:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000cf3:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000cf9:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1000cfe:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1000d02:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000d08:	c4 63 79 14 e2 04    	vpextrb $0x4,%xmm12,%edx
 1000d0e:	f6 c2 01             	test   $0x1,%dl
 1000d11:	74 05                	je     1000d18 <_Z6memsetPvcm+0x38e>
 1000d13:	40 88 74 0f 0c       	mov    %sil,0xc(%rdi,%rcx,1)
 1000d18:	c5 7d 7f f1          	vmovdqa %ymm14,%ymm1
 1000d1c:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000d20:	c5 31 ef ed          	vpxor  %xmm5,%xmm9,%xmm13
 1000d24:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000d29:	c4 41 7a 70 e4 84    	vpshufhw $0x84,%xmm12,%xmm12
 1000d2f:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000d34:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000d3a:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1000d3f:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1000d43:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000d49:	c4 63 79 14 e2 05    	vpextrb $0x5,%xmm12,%edx
 1000d4f:	f6 c2 01             	test   $0x1,%dl
 1000d52:	74 05                	je     1000d59 <_Z6memsetPvcm+0x3cf>
 1000d54:	40 88 74 0f 0d       	mov    %sil,0xd(%rdi,%rcx,1)
 1000d59:	c5 25 ef e5          	vpxor  %ymm5,%ymm11,%ymm12
 1000d5d:	c4 42 1d 37 ef       	vpcmpgtq %ymm15,%ymm12,%ymm13
 1000d62:	c4 41 7d 6b e5       	vpackssdw %ymm13,%ymm0,%ymm12
 1000d67:	c4 41 0d 76 f6       	vpcmpeqd %ymm14,%ymm14,%ymm14
 1000d6c:	c4 41 1d ef e6       	vpxor  %ymm14,%ymm12,%ymm12
 1000d71:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1000d76:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1000d7a:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000d80:	c4 63 79 14 e2 06    	vpextrb $0x6,%xmm12,%edx
 1000d86:	f6 c2 01             	test   $0x1,%dl
 1000d89:	74 05                	je     1000d90 <_Z6memsetPvcm+0x406>
 1000d8b:	40 88 74 0f 0e       	mov    %sil,0xe(%rdi,%rcx,1)
 1000d90:	c4 41 7e 70 e5 84    	vpshufhw $0x84,%ymm13,%ymm12
 1000d96:	c4 41 1d ef e6       	vpxor  %ymm14,%ymm12,%ymm12
 1000d9b:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1000da0:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1000da4:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000daa:	c4 63 79 14 e2 07    	vpextrb $0x7,%xmm12,%edx
 1000db0:	f6 c2 01             	test   $0x1,%dl
 1000db3:	74 05                	je     1000dba <_Z6memsetPvcm+0x430>
 1000db5:	40 88 74 0f 0f       	mov    %sil,0xf(%rdi,%rcx,1)
 1000dba:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000dbe:	c5 31 ef ec          	vpxor  %xmm4,%xmm9,%xmm13
 1000dc2:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000dc7:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000dcc:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000dd1:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000dd6:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000ddb:	c4 63 79 14 e2 08    	vpextrb $0x8,%xmm12,%edx
 1000de1:	f6 c2 01             	test   $0x1,%dl
 1000de4:	c5 7d 6f f1          	vmovdqa %ymm1,%ymm14
 1000de8:	74 05                	je     1000def <_Z6memsetPvcm+0x465>
 1000dea:	40 88 74 0f 10       	mov    %sil,0x10(%rdi,%rcx,1)
 1000def:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000df3:	c5 31 ef ec          	vpxor  %xmm4,%xmm9,%xmm13
 1000df7:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000dfc:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000e01:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000e06:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000e0b:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000e10:	c4 63 79 14 e2 09    	vpextrb $0x9,%xmm12,%edx
 1000e16:	f6 c2 01             	test   $0x1,%dl
 1000e19:	c5 fd 6f cb          	vmovdqa %ymm3,%ymm1
 1000e1d:	74 05                	je     1000e24 <_Z6memsetPvcm+0x49a>
 1000e1f:	40 88 74 0f 11       	mov    %sil,0x11(%rdi,%rcx,1)
 1000e24:	c5 25 ef e4          	vpxor  %ymm4,%ymm11,%ymm12
 1000e28:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 1000e2d:	c4 41 7f 70 e4 e8    	vpshuflw $0xe8,%ymm12,%ymm12
 1000e33:	c5 1d ef 25 e5 73 00 	vpxor  0x73e5(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 1000e3a:	00 
 1000e3b:	c4 42 0d 36 e4       	vpermd %ymm12,%ymm14,%ymm12
 1000e40:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000e45:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000e4a:	c4 63 79 14 e2 0a    	vpextrb $0xa,%xmm12,%edx
 1000e50:	f6 c2 01             	test   $0x1,%dl
 1000e53:	c5 fe 6f 5c 24 d8    	vmovdqu -0x28(%rsp),%ymm3
 1000e59:	74 05                	je     1000e60 <_Z6memsetPvcm+0x4d6>
 1000e5b:	40 88 74 0f 12       	mov    %sil,0x12(%rdi,%rcx,1)
 1000e60:	c4 c3 7d 39 e4 01    	vextracti128 $0x1,%ymm4,%xmm12
 1000e66:	c4 41 19 ef e1       	vpxor  %xmm9,%xmm12,%xmm12
 1000e6b:	c4 62 19 37 64 24 a8 	vpcmpgtq -0x58(%rsp),%xmm12,%xmm12
 1000e72:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000e77:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000e7c:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000e81:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000e86:	c4 63 79 14 e2 0b    	vpextrb $0xb,%xmm12,%edx
 1000e8c:	f6 c2 01             	test   $0x1,%dl
 1000e8f:	74 05                	je     1000e96 <_Z6memsetPvcm+0x50c>
 1000e91:	40 88 74 0f 13       	mov    %sil,0x13(%rdi,%rcx,1)
 1000e96:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000e9a:	c5 31 ef eb          	vpxor  %xmm3,%xmm9,%xmm13
 1000e9e:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000ea3:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000ea8:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000ead:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000eb3:	c5 1d 6b e0          	vpackssdw %ymm0,%ymm12,%ymm12
 1000eb7:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000ebd:	c4 42 79 79 e4       	vpbroadcastw %xmm12,%xmm12
 1000ec2:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000ec7:	c4 63 79 14 e2 0c    	vpextrb $0xc,%xmm12,%edx
 1000ecd:	f6 c2 01             	test   $0x1,%dl
 1000ed0:	74 05                	je     1000ed7 <_Z6memsetPvcm+0x54d>
 1000ed2:	40 88 74 0f 14       	mov    %sil,0x14(%rdi,%rcx,1)
 1000ed7:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000edb:	c5 31 ef eb          	vpxor  %xmm3,%xmm9,%xmm13
 1000edf:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000ee4:	c4 41 7a 70 e4 84    	vpshufhw $0x84,%xmm12,%xmm12
 1000eea:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000eef:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000ef5:	c5 1d 6b e0          	vpackssdw %ymm0,%ymm12,%ymm12
 1000ef9:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000eff:	c4 42 79 58 e4       	vpbroadcastd %xmm12,%xmm12
 1000f04:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000f09:	c4 63 79 14 e2 0d    	vpextrb $0xd,%xmm12,%edx
 1000f0f:	f6 c2 01             	test   $0x1,%dl
 1000f12:	74 05                	je     1000f19 <_Z6memsetPvcm+0x58f>
 1000f14:	40 88 74 0f 15       	mov    %sil,0x15(%rdi,%rcx,1)
 1000f19:	c5 25 ef e3          	vpxor  %ymm3,%ymm11,%ymm12
 1000f1d:	c4 42 1d 37 ef       	vpcmpgtq %ymm15,%ymm12,%ymm13
 1000f22:	c4 41 7d 6b e5       	vpackssdw %ymm13,%ymm0,%ymm12
 1000f27:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000f2d:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000f32:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000f37:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000f3c:	c4 63 79 14 e2 0e    	vpextrb $0xe,%xmm12,%edx
 1000f42:	f6 c2 01             	test   $0x1,%dl
 1000f45:	74 05                	je     1000f4c <_Z6memsetPvcm+0x5c2>
 1000f47:	40 88 74 0f 16       	mov    %sil,0x16(%rdi,%rcx,1)
 1000f4c:	c4 41 7e 70 e5 84    	vpshufhw $0x84,%ymm13,%ymm12
 1000f52:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000f58:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000f5d:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000f62:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1000f67:	c4 63 79 14 e2 0f    	vpextrb $0xf,%xmm12,%edx
 1000f6d:	f6 c2 01             	test   $0x1,%dl
 1000f70:	74 05                	je     1000f77 <_Z6memsetPvcm+0x5ed>
 1000f72:	40 88 74 0f 17       	mov    %sil,0x17(%rdi,%rcx,1)
 1000f77:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000f7b:	c5 31 ef ea          	vpxor  %xmm2,%xmm9,%xmm13
 1000f7f:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000f84:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000f89:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000f8e:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000f93:	c4 42 7d 33 e4       	vpmovzxwd %xmm12,%ymm12
 1000f98:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 1000f9d:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000fa3:	c4 63 79 14 e2 08    	vpextrb $0x8,%xmm12,%edx
 1000fa9:	f6 c2 01             	test   $0x1,%dl
 1000fac:	74 05                	je     1000fb3 <_Z6memsetPvcm+0x629>
 1000fae:	40 88 74 0f 18       	mov    %sil,0x18(%rdi,%rcx,1)
 1000fb3:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1000fb7:	c5 31 ef ea          	vpxor  %xmm2,%xmm9,%xmm13
 1000fbb:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1000fc0:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000fc5:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1000fca:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1000fcf:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1000fd5:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 1000fda:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1000fe0:	c4 63 79 14 e2 09    	vpextrb $0x9,%xmm12,%edx
 1000fe6:	f6 c2 01             	test   $0x1,%dl
 1000fe9:	74 05                	je     1000ff0 <_Z6memsetPvcm+0x666>
 1000feb:	40 88 74 0f 19       	mov    %sil,0x19(%rdi,%rcx,1)
 1000ff0:	c5 25 ef e2          	vpxor  %ymm2,%ymm11,%ymm12
 1000ff4:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 1000ff9:	c4 41 7f 70 e4 e8    	vpshuflw $0xe8,%ymm12,%ymm12
 1000fff:	c5 1d ef 25 19 72 00 	vpxor  0x7219(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 1001006:	00 
 1001007:	c4 42 0d 36 e4       	vpermd %ymm12,%ymm14,%ymm12
 100100c:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1001011:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1001017:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 100101c:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1001022:	c4 63 79 14 e2 0a    	vpextrb $0xa,%xmm12,%edx
 1001028:	f6 c2 01             	test   $0x1,%dl
 100102b:	74 05                	je     1001032 <_Z6memsetPvcm+0x6a8>
 100102d:	40 88 74 0f 1a       	mov    %sil,0x1a(%rdi,%rcx,1)
 1001032:	c4 c3 7d 39 d4 01    	vextracti128 $0x1,%ymm2,%xmm12
 1001038:	c4 41 19 ef e1       	vpxor  %xmm9,%xmm12,%xmm12
 100103d:	c4 62 19 37 64 24 a8 	vpcmpgtq -0x58(%rsp),%xmm12,%xmm12
 1001044:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1001049:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 100104e:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1001053:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1001059:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 100105e:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1001064:	c4 63 79 14 e2 0b    	vpextrb $0xb,%xmm12,%edx
 100106a:	f6 c2 01             	test   $0x1,%dl
 100106d:	74 05                	je     1001074 <_Z6memsetPvcm+0x6ea>
 100106f:	40 88 74 0f 1b       	mov    %sil,0x1b(%rdi,%rcx,1)
 1001074:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1001078:	c5 31 ef e9          	vpxor  %xmm1,%xmm9,%xmm13
 100107c:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1001081:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1001086:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 100108b:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1001091:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1001096:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 100109b:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 10010a1:	c4 63 79 14 e2 0c    	vpextrb $0xc,%xmm12,%edx
 10010a7:	f6 c2 01             	test   $0x1,%dl
 10010aa:	74 05                	je     10010b1 <_Z6memsetPvcm+0x727>
 10010ac:	40 88 74 0f 1c       	mov    %sil,0x1c(%rdi,%rcx,1)
 10010b1:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 10010b5:	c5 31 ef e9          	vpxor  %xmm1,%xmm9,%xmm13
 10010b9:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 10010be:	c4 41 7a 70 e4 84    	vpshufhw $0x84,%xmm12,%xmm12
 10010c4:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 10010c9:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 10010cf:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 10010d4:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 10010d9:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 10010df:	c4 63 79 14 e2 0d    	vpextrb $0xd,%xmm12,%edx
 10010e5:	f6 c2 01             	test   $0x1,%dl
 10010e8:	74 05                	je     10010ef <_Z6memsetPvcm+0x765>
 10010ea:	40 88 74 0f 1d       	mov    %sil,0x1d(%rdi,%rcx,1)
 10010ef:	c5 25 ef e1          	vpxor  %ymm1,%ymm11,%ymm12
 10010f3:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 10010f8:	c4 41 7d 6b ec       	vpackssdw %ymm12,%ymm0,%ymm13
 10010fd:	c4 41 05 76 ff       	vpcmpeqd %ymm15,%ymm15,%ymm15
 1001102:	c4 41 15 ef ef       	vpxor  %ymm15,%ymm13,%ymm13
 1001107:	c4 41 7d 6b ed       	vpackssdw %ymm13,%ymm0,%ymm13
 100110c:	c4 41 7d 63 ed       	vpacksswb %ymm13,%ymm0,%ymm13
 1001111:	c4 43 7d 39 ed 01    	vextracti128 $0x1,%ymm13,%xmm13
 1001117:	c4 63 79 14 ea 0e    	vpextrb $0xe,%xmm13,%edx
 100111d:	f6 c2 01             	test   $0x1,%dl
 1001120:	74 05                	je     1001127 <_Z6memsetPvcm+0x79d>
 1001122:	40 88 74 0f 1e       	mov    %sil,0x1e(%rdi,%rcx,1)
 1001127:	c4 41 7e 70 e4 84    	vpshufhw $0x84,%ymm12,%ymm12
 100112d:	c4 41 1d ef e7       	vpxor  %ymm15,%ymm12,%ymm12
 1001132:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1001137:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 100113c:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1001142:	c4 63 79 14 e2 0f    	vpextrb $0xf,%xmm12,%edx
 1001148:	f6 c2 01             	test   $0x1,%dl
 100114b:	74 05                	je     1001152 <_Z6memsetPvcm+0x7c8>
 100114d:	40 88 74 0f 1f       	mov    %sil,0x1f(%rdi,%rcx,1)
 1001152:	48 83 c1 20          	add    $0x20,%rcx
 1001156:	c5 7e 6f 64 24 b8    	vmovdqu -0x48(%rsp),%ymm12
 100115c:	c4 41 3d d4 c4       	vpaddq %ymm12,%ymm8,%ymm8
 1001161:	c5 9d d4 ff          	vpaddq %ymm7,%ymm12,%ymm7
 1001165:	c5 9d d4 f6          	vpaddq %ymm6,%ymm12,%ymm6
 1001169:	c5 9d d4 ed          	vpaddq %ymm5,%ymm12,%ymm5
 100116d:	c5 9d d4 e4          	vpaddq %ymm4,%ymm12,%ymm4
 1001171:	c5 9d d4 db          	vpaddq %ymm3,%ymm12,%ymm3
 1001175:	c5 9d d4 d2          	vpaddq %ymm2,%ymm12,%ymm2
 1001179:	c5 9d d4 c9          	vpaddq %ymm1,%ymm12,%ymm1
 100117d:	48 39 c8             	cmp    %rcx,%rax
 1001180:	0f 85 93 f8 ff ff    	jne    1000a19 <_Z6memsetPvcm+0x8f>
 1001186:	c5 f8 77             	vzeroupper 
 1001189:	c3                   	ret    

000000000100118a <_Z14set_page_flagsPvh>:
 100118a:	89 f0                	mov    %esi,%eax
 100118c:	48 c1 ef 15          	shr    $0x15,%rdi
 1001190:	48 09 04 fd 00 20 07 	or     %rax,0x72000(,%rdi,8)
 1001197:	00 
 1001198:	c3                   	ret    
 1001199:	cc                   	int3   

000000000100119a <_ZN7console6putstrEPKc>:
 100119a:	8a 06                	mov    (%rsi),%al
 100119c:	84 c0                	test   %al,%al
 100119e:	74 28                	je     10011c8 <_ZN7console6putstrEPKc+0x2e>
 10011a0:	41 56                	push   %r14
 10011a2:	53                   	push   %rbx
 10011a3:	50                   	push   %rax
 10011a4:	48 89 f3             	mov    %rsi,%rbx
 10011a7:	49 89 fe             	mov    %rdi,%r14
 10011aa:	48 ff c3             	inc    %rbx
 10011ad:	0f be f0             	movsbl %al,%esi
 10011b0:	4c 89 f7             	mov    %r14,%rdi
 10011b3:	e8 9a 29 00 00       	call   1003b52 <_ZN7console7putcharEc>
 10011b8:	8a 03                	mov    (%rbx),%al
 10011ba:	48 ff c3             	inc    %rbx
 10011bd:	84 c0                	test   %al,%al
 10011bf:	75 ec                	jne    10011ad <_ZN7console6putstrEPKc+0x13>
 10011c1:	48 83 c4 08          	add    $0x8,%rsp
 10011c5:	5b                   	pop    %rbx
 10011c6:	41 5e                	pop    %r14
 10011c8:	c3                   	ret    

00000000010011c9 <_Z6format8rostringz>:
 10011c9:	55                   	push   %rbp
 10011ca:	41 57                	push   %r15
 10011cc:	41 56                	push   %r14
 10011ce:	41 55                	push   %r13
 10011d0:	41 54                	push   %r12
 10011d2:	53                   	push   %rbx
 10011d3:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
 10011da:	48 89 7c 24 78       	mov    %rdi,0x78(%rsp)
 10011df:	48 8d bc 24 b0 00 00 	lea    0xb0(%rsp),%rdi
 10011e6:	00 
 10011e7:	48 89 57 10          	mov    %rdx,0x10(%rdi)
 10011eb:	48 89 4f 18          	mov    %rcx,0x18(%rdi)
 10011ef:	4c 89 47 20          	mov    %r8,0x20(%rdi)
 10011f3:	4c 89 4f 28          	mov    %r9,0x28(%rdi)
 10011f7:	84 c0                	test   %al,%al
 10011f9:	74 48                	je     1001243 <_Z6format8rostringz+0x7a>
 10011fb:	c5 f8 29 84 24 e0 00 	vmovaps %xmm0,0xe0(%rsp)
 1001202:	00 00 
 1001204:	c5 f8 29 8c 24 f0 00 	vmovaps %xmm1,0xf0(%rsp)
 100120b:	00 00 
 100120d:	c5 f8 29 94 24 00 01 	vmovaps %xmm2,0x100(%rsp)
 1001214:	00 00 
 1001216:	c5 f8 29 9c 24 10 01 	vmovaps %xmm3,0x110(%rsp)
 100121d:	00 00 
 100121f:	c5 f8 29 a4 24 20 01 	vmovaps %xmm4,0x120(%rsp)
 1001226:	00 00 
 1001228:	c5 f8 29 ac 24 30 01 	vmovaps %xmm5,0x130(%rsp)
 100122f:	00 00 
 1001231:	c5 f8 29 b4 24 40 01 	vmovaps %xmm6,0x140(%rsp)
 1001238:	00 00 
 100123a:	c5 f8 29 bc 24 50 01 	vmovaps %xmm7,0x150(%rsp)
 1001241:	00 00 
 1001243:	48 89 7c 24 10       	mov    %rdi,0x10(%rsp)
 1001248:	48 8d 84 24 a0 01 00 	lea    0x1a0(%rsp),%rax
 100124f:	00 
 1001250:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
 1001255:	48 b8 10 00 00 00 30 	movabs $0x3000000010,%rax
 100125c:	00 00 00 
 100125f:	48 89 04 24          	mov    %rax,(%rsp)
 1001263:	8b 46 08             	mov    0x8(%rsi),%eax
 1001266:	48 8b 0e             	mov    (%rsi),%rcx
 1001269:	89 44 24 60          	mov    %eax,0x60(%rsp)
 100126d:	8b 44 24 60          	mov    0x60(%rsp),%eax
 1001271:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
 1001276:	89 44 24 40          	mov    %eax,0x40(%rsp)
 100127a:	c7 44 24 48 00 00 00 	movl   $0x0,0x48(%rsp)
 1001281:	00 
 1001282:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 1001286:	48 8d 7c 24 50       	lea    0x50(%rsp),%rdi
 100128b:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
 100128f:	8b 76 08             	mov    0x8(%rsi),%esi
 1001292:	e8 f7 32 00 00       	call   100458e <_ZN6vectorIcE7reserveEi>
 1001297:	48 c7 44 24 68 2a 88 	movq   $0x100882a,0x68(%rsp)
 100129e:	00 01 
 10012a0:	c7 44 24 70 0a 00 00 	movl   $0xa,0x70(%rsp)
 10012a7:	00 
 10012a8:	83 7c 24 40 00       	cmpl   $0x0,0x40(%rsp)
 10012ad:	0f 8e 55 05 00 00    	jle    1001808 <_Z6format8rostringz+0x63f>
 10012b3:	31 f6                	xor    %esi,%esi
 10012b5:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
 10012ba:	4c 8d 6c 24 20       	lea    0x20(%rsp),%r13
 10012bf:	4c 8d 7c 24 50       	lea    0x50(%rsp),%r15
 10012c4:	8d 46 01             	lea    0x1(%rsi),%eax
 10012c7:	89 44 24 48          	mov    %eax,0x48(%rsp)
 10012cb:	4c 89 f7             	mov    %r14,%rdi
 10012ce:	e8 63 34 00 00       	call   1004736 <_ZN4spanIcE2atEi>
 10012d3:	8a 18                	mov    (%rax),%bl
 10012d5:	80 fb 25             	cmp    $0x25,%bl
 10012d8:	0f 85 13 01 00 00    	jne    10013f1 <_Z6format8rostringz+0x228>
 10012de:	8b 44 24 70          	mov    0x70(%rsp),%eax
 10012e2:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
 10012e7:	48 89 8c 24 90 00 00 	mov    %rcx,0x90(%rsp)
 10012ee:	00 
 10012ef:	89 84 24 98 00 00 00 	mov    %eax,0x98(%rsp)
 10012f6:	48 8d bc 24 a0 00 00 	lea    0xa0(%rsp),%rdi
 10012fd:	00 
 10012fe:	4c 89 f6             	mov    %r14,%rsi
 1001301:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
 1001308:	00 
 1001309:	e8 2e 37 00 00       	call   1004a3c <_ZN13istringstream14read_until_incE8rostring>
 100130e:	8b 84 24 a8 00 00 00 	mov    0xa8(%rsp),%eax
 1001315:	48 8b 8c 24 a0 00 00 	mov    0xa0(%rsp),%rcx
 100131c:	00 
 100131d:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 1001322:	89 44 24 28          	mov    %eax,0x28(%rsp)
 1001326:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%rsp)
 100132d:	00 
 100132e:	83 7c 24 28 00       	cmpl   $0x0,0x28(%rsp)
 1001333:	0f 8e cb 00 00 00    	jle    1001404 <_Z6format8rostringz+0x23b>
 1001339:	41 be 03 00 00 00    	mov    $0x3,%r14d
 100133f:	b3 20                	mov    $0x20,%bl
 1001341:	31 ed                	xor    %ebp,%ebp
 1001343:	45 31 e4             	xor    %r12d,%r12d
 1001346:	8d 45 01             	lea    0x1(%rbp),%eax
 1001349:	89 44 24 30          	mov    %eax,0x30(%rsp)
 100134d:	4c 89 ef             	mov    %r13,%rdi
 1001350:	89 ee                	mov    %ebp,%esi
 1001352:	e8 df 33 00 00       	call   1004736 <_ZN4spanIcE2atEi>
 1001357:	8a 00                	mov    (%rax),%al
 1001359:	89 6c 24 30          	mov    %ebp,0x30(%rsp)
 100135d:	88 44 24 18          	mov    %al,0x18(%rsp)
 1001361:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
 1001366:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
 100136b:	e8 7e 67 00 00       	call   1007aee <_ZNK4spanIcE4findERKc>
 1001370:	85 c0                	test   %eax,%eax
 1001372:	0f 89 97 00 00 00    	jns    100140f <_Z6format8rostringz+0x246>
 1001378:	0f b6 44 24 18       	movzbl 0x18(%rsp),%eax
 100137d:	83 f8 2e             	cmp    $0x2e,%eax
 1001380:	74 1f                	je     10013a1 <_Z6format8rostringz+0x1d8>
 1001382:	83 f8 7a             	cmp    $0x7a,%eax
 1001385:	74 05                	je     100138c <_Z6format8rostringz+0x1c3>
 1001387:	83 f8 6c             	cmp    $0x6c,%eax
 100138a:	75 35                	jne    10013c1 <_Z6format8rostringz+0x1f8>
 100138c:	8b 74 24 30          	mov    0x30(%rsp),%esi
 1001390:	8d 46 01             	lea    0x1(%rsi),%eax
 1001393:	89 44 24 30          	mov    %eax,0x30(%rsp)
 1001397:	4c 89 ef             	mov    %r13,%rdi
 100139a:	e8 97 33 00 00       	call   1004736 <_ZN4spanIcE2atEi>
 100139f:	eb 40                	jmp    10013e1 <_Z6format8rostringz+0x218>
 10013a1:	8b 74 24 30          	mov    0x30(%rsp),%esi
 10013a5:	8d 46 01             	lea    0x1(%rsi),%eax
 10013a8:	89 44 24 30          	mov    %eax,0x30(%rsp)
 10013ac:	4c 89 ef             	mov    %r13,%rdi
 10013af:	e8 82 33 00 00       	call   1004736 <_ZN4spanIcE2atEi>
 10013b4:	4c 89 ef             	mov    %r13,%rdi
 10013b7:	e8 b4 35 00 00       	call   1004970 <_ZN13istringstream4readIlEET_v>
 10013bc:	49 89 c6             	mov    %rax,%r14
 10013bf:	eb 20                	jmp    10013e1 <_Z6format8rostringz+0x218>
 10013c1:	8b 74 24 30          	mov    0x30(%rsp),%esi
 10013c5:	8d 46 01             	lea    0x1(%rsi),%eax
 10013c8:	89 44 24 30          	mov    %eax,0x30(%rsp)
 10013cc:	4c 89 ef             	mov    %r13,%rdi
 10013cf:	e8 62 33 00 00       	call   1004736 <_ZN4spanIcE2atEi>
 10013d4:	8a 18                	mov    (%rax),%bl
 10013d6:	4c 89 ef             	mov    %r13,%rdi
 10013d9:	e8 92 35 00 00       	call   1004970 <_ZN13istringstream4readIlEET_v>
 10013de:	49 89 c4             	mov    %rax,%r12
 10013e1:	8b 6c 24 30          	mov    0x30(%rsp),%ebp
 10013e5:	3b 6c 24 28          	cmp    0x28(%rsp),%ebp
 10013e9:	0f 8c 57 ff ff ff    	jl     1001346 <_Z6format8rostringz+0x17d>
 10013ef:	eb 1e                	jmp    100140f <_Z6format8rostringz+0x246>
 10013f1:	8b 74 24 58          	mov    0x58(%rsp),%esi
 10013f5:	4c 89 ff             	mov    %r15,%rdi
 10013f8:	e8 a3 69 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 10013fd:	88 18                	mov    %bl,(%rax)
 10013ff:	e9 f6 03 00 00       	jmp    10017fa <_Z6format8rostringz+0x631>
 1001404:	45 31 e4             	xor    %r12d,%r12d
 1001407:	b3 20                	mov    $0x20,%bl
 1001409:	41 be 03 00 00 00    	mov    $0x3,%r14d
 100140f:	8b 74 24 28          	mov    0x28(%rsp),%esi
 1001413:	ff ce                	dec    %esi
 1001415:	4c 89 ef             	mov    %r13,%rdi
 1001418:	e8 19 33 00 00       	call   1004736 <_ZN4spanIcE2atEi>
 100141d:	0f b6 00             	movzbl (%rax),%eax
 1001420:	83 f8 65             	cmp    $0x65,%eax
 1001423:	7f 49                	jg     100146e <_Z6format8rostringz+0x2a5>
 1001425:	83 f8 52             	cmp    $0x52,%eax
 1001428:	0f 8e 85 00 00 00    	jle    10014b3 <_Z6format8rostringz+0x2ea>
 100142e:	83 f8 53             	cmp    $0x53,%eax
 1001431:	0f 84 ea 00 00 00    	je     1001521 <_Z6format8rostringz+0x358>
 1001437:	83 f8 58             	cmp    $0x58,%eax
 100143a:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
 100143f:	0f 84 01 01 00 00    	je     1001546 <_Z6format8rostringz+0x37d>
 1001445:	83 f8 62             	cmp    $0x62,%eax
 1001448:	0f 85 ac 03 00 00    	jne    10017fa <_Z6format8rostringz+0x631>
 100144e:	8b 0c 24             	mov    (%rsp),%ecx
 1001451:	48 83 f9 28          	cmp    $0x28,%rcx
 1001455:	0f 87 a9 01 00 00    	ja     1001604 <_Z6format8rostringz+0x43b>
 100145b:	48 89 c8             	mov    %rcx,%rax
 100145e:	48 03 44 24 10       	add    0x10(%rsp),%rax
 1001463:	83 c1 08             	add    $0x8,%ecx
 1001466:	89 0c 24             	mov    %ecx,(%rsp)
 1001469:	e9 a4 01 00 00       	jmp    1001612 <_Z6format8rostringz+0x449>
 100146e:	83 f8 6f             	cmp    $0x6f,%eax
 1001471:	7e 77                	jle    10014ea <_Z6format8rostringz+0x321>
 1001473:	83 f8 70             	cmp    $0x70,%eax
 1001476:	0f 84 e3 00 00 00    	je     100155f <_Z6format8rostringz+0x396>
 100147c:	83 f8 73             	cmp    $0x73,%eax
 100147f:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
 1001484:	0f 84 10 01 00 00    	je     100159a <_Z6format8rostringz+0x3d1>
 100148a:	83 f8 78             	cmp    $0x78,%eax
 100148d:	0f 85 67 03 00 00    	jne    10017fa <_Z6format8rostringz+0x631>
 1001493:	8b 0c 24             	mov    (%rsp),%ecx
 1001496:	48 83 f9 28          	cmp    $0x28,%rcx
 100149a:	0f 87 8c 01 00 00    	ja     100162c <_Z6format8rostringz+0x463>
 10014a0:	48 89 c8             	mov    %rcx,%rax
 10014a3:	48 03 44 24 10       	add    0x10(%rsp),%rax
 10014a8:	83 c1 08             	add    $0x8,%ecx
 10014ab:	89 0c 24             	mov    %ecx,(%rsp)
 10014ae:	e9 87 01 00 00       	jmp    100163a <_Z6format8rostringz+0x471>
 10014b3:	83 f8 49             	cmp    $0x49,%eax
 10014b6:	0f 84 fe 00 00 00    	je     10015ba <_Z6format8rostringz+0x3f1>
 10014bc:	83 f8 4d             	cmp    $0x4d,%eax
 10014bf:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
 10014c4:	0f 85 30 03 00 00    	jne    10017fa <_Z6format8rostringz+0x631>
 10014ca:	8b 0c 24             	mov    (%rsp),%ecx
 10014cd:	48 83 f9 28          	cmp    $0x28,%rcx
 10014d1:	0f 87 85 01 00 00    	ja     100165c <_Z6format8rostringz+0x493>
 10014d7:	48 89 c8             	mov    %rcx,%rax
 10014da:	48 03 44 24 10       	add    0x10(%rsp),%rax
 10014df:	83 c1 08             	add    $0x8,%ecx
 10014e2:	89 0c 24             	mov    %ecx,(%rsp)
 10014e5:	e9 80 01 00 00       	jmp    100166a <_Z6format8rostringz+0x4a1>
 10014ea:	83 f8 66             	cmp    $0x66,%eax
 10014ed:	0f 84 ec 00 00 00    	je     10015df <_Z6format8rostringz+0x416>
 10014f3:	83 f8 69             	cmp    $0x69,%eax
 10014f6:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
 10014fb:	0f 85 f9 02 00 00    	jne    10017fa <_Z6format8rostringz+0x631>
 1001501:	8b 0c 24             	mov    (%rsp),%ecx
 1001504:	48 83 f9 28          	cmp    $0x28,%rcx
 1001508:	0f 87 ca 01 00 00    	ja     10016d8 <_Z6format8rostringz+0x50f>
 100150e:	48 89 c8             	mov    %rcx,%rax
 1001511:	48 03 44 24 10       	add    0x10(%rsp),%rax
 1001516:	83 c1 08             	add    $0x8,%ecx
 1001519:	89 0c 24             	mov    %ecx,(%rsp)
 100151c:	e9 c5 01 00 00       	jmp    10016e6 <_Z6format8rostringz+0x51d>
 1001521:	8b 0c 24             	mov    (%rsp),%ecx
 1001524:	48 83 f9 28          	cmp    $0x28,%rcx
 1001528:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
 100152d:	0f 87 d5 01 00 00    	ja     1001708 <_Z6format8rostringz+0x53f>
 1001533:	48 89 c8             	mov    %rcx,%rax
 1001536:	48 03 44 24 10       	add    0x10(%rsp),%rax
 100153b:	83 c1 08             	add    $0x8,%ecx
 100153e:	89 0c 24             	mov    %ecx,(%rsp)
 1001541:	e9 d0 01 00 00       	jmp    1001716 <_Z6format8rostringz+0x54d>
 1001546:	8b 0c 24             	mov    (%rsp),%ecx
 1001549:	48 83 f9 28          	cmp    $0x28,%rcx
 100154d:	77 2b                	ja     100157a <_Z6format8rostringz+0x3b1>
 100154f:	48 89 c8             	mov    %rcx,%rax
 1001552:	48 03 44 24 10       	add    0x10(%rsp),%rax
 1001557:	83 c1 08             	add    $0x8,%ecx
 100155a:	89 0c 24             	mov    %ecx,(%rsp)
 100155d:	eb 29                	jmp    1001588 <_Z6format8rostringz+0x3bf>
 100155f:	be 6c 87 00 01       	mov    $0x100876c,%esi
 1001564:	4c 89 ff             	mov    %r15,%rdi
 1001567:	e8 30 2a 00 00       	call   1003f9c <_ZN13ostringstream5writeIPKcEEvT_>
 100156c:	8b 0c 24             	mov    (%rsp),%ecx
 100156f:	48 83 f9 28          	cmp    $0x28,%rcx
 1001573:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
 1001578:	76 d5                	jbe    100154f <_Z6format8rostringz+0x386>
 100157a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 100157f:	48 8d 48 08          	lea    0x8(%rax),%rcx
 1001583:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 1001588:	48 8b 30             	mov    (%rax),%rsi
 100158b:	44 0f be c3          	movsbl %bl,%r8d
 100158f:	41 b9 40 84 00 01    	mov    $0x1008440,%r9d
 1001595:	e9 ad 00 00 00       	jmp    1001647 <_Z6format8rostringz+0x47e>
 100159a:	8b 0c 24             	mov    (%rsp),%ecx
 100159d:	48 83 f9 28          	cmp    $0x28,%rcx
 10015a1:	0f 87 9c 01 00 00    	ja     1001743 <_Z6format8rostringz+0x57a>
 10015a7:	48 89 c8             	mov    %rcx,%rax
 10015aa:	48 03 44 24 10       	add    0x10(%rsp),%rax
 10015af:	83 c1 08             	add    $0x8,%ecx
 10015b2:	89 0c 24             	mov    %ecx,(%rsp)
 10015b5:	e9 97 01 00 00       	jmp    1001751 <_Z6format8rostringz+0x588>
 10015ba:	8b 0c 24             	mov    (%rsp),%ecx
 10015bd:	48 83 f9 28          	cmp    $0x28,%rcx
 10015c1:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
 10015c6:	0f 87 95 01 00 00    	ja     1001761 <_Z6format8rostringz+0x598>
 10015cc:	48 89 c8             	mov    %rcx,%rax
 10015cf:	48 03 44 24 10       	add    0x10(%rsp),%rax
 10015d4:	83 c1 08             	add    $0x8,%ecx
 10015d7:	89 0c 24             	mov    %ecx,(%rsp)
 10015da:	e9 90 01 00 00       	jmp    100176f <_Z6format8rostringz+0x5a6>
 10015df:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
 10015e3:	48 81 f9 a0 00 00 00 	cmp    $0xa0,%rcx
 10015ea:	0f 87 e2 01 00 00    	ja     10017d2 <_Z6format8rostringz+0x609>
 10015f0:	48 89 c8             	mov    %rcx,%rax
 10015f3:	48 03 44 24 10       	add    0x10(%rsp),%rax
 10015f8:	83 c1 10             	add    $0x10,%ecx
 10015fb:	89 4c 24 04          	mov    %ecx,0x4(%rsp)
 10015ff:	e9 dc 01 00 00       	jmp    10017e0 <_Z6format8rostringz+0x617>
 1001604:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1001609:	48 8d 48 08          	lea    0x8(%rax),%rcx
 100160d:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 1001612:	48 8b 30             	mov    (%rax),%rsi
 1001615:	44 0f be c3          	movsbl %bl,%r8d
 1001619:	41 b9 40 84 00 01    	mov    $0x1008440,%r9d
 100161f:	4c 89 ff             	mov    %r15,%rdi
 1001622:	44 89 e2             	mov    %r12d,%edx
 1001625:	b9 02 00 00 00       	mov    $0x2,%ecx
 100162a:	eb 26                	jmp    1001652 <_Z6format8rostringz+0x489>
 100162c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1001631:	48 8d 48 08          	lea    0x8(%rax),%rcx
 1001635:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 100163a:	48 8b 30             	mov    (%rax),%rsi
 100163d:	44 0f be c3          	movsbl %bl,%r8d
 1001641:	41 b9 59 89 00 01    	mov    $0x1008959,%r9d
 1001647:	4c 89 ff             	mov    %r15,%rdi
 100164a:	44 89 e2             	mov    %r12d,%edx
 100164d:	b9 10 00 00 00       	mov    $0x10,%ecx
 1001652:	e8 b5 2d 00 00       	call   100440c <_ZN13ostringstream7write_uEmiicPKc>
 1001657:	e9 9e 01 00 00       	jmp    10017fa <_Z6format8rostringz+0x631>
 100165c:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1001661:	48 8d 48 08          	lea    0x8(%rax),%rcx
 1001665:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 100166a:	48 8b 00             	mov    (%rax),%rax
 100166d:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
 1001672:	0f b6 f0             	movzbl %al,%esi
 1001675:	41 b9 59 89 00 01    	mov    $0x1008959,%r9d
 100167b:	4c 89 ff             	mov    %r15,%rdi
 100167e:	ba 02 00 00 00       	mov    $0x2,%edx
 1001683:	b9 10 00 00 00       	mov    $0x10,%ecx
 1001688:	41 b8 30 00 00 00    	mov    $0x30,%r8d
 100168e:	e8 cf 29 00 00       	call   1004062 <_ZN13ostringstream7write_iEliicPKc>
 1001693:	bb 01 00 00 00       	mov    $0x1,%ebx
 1001698:	8b 74 24 58          	mov    0x58(%rsp),%esi
 100169c:	4c 89 ff             	mov    %r15,%rdi
 100169f:	e8 fc 66 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 10016a4:	c6 00 3a             	movb   $0x3a,(%rax)
 10016a7:	0f b6 74 1c 18       	movzbl 0x18(%rsp,%rbx,1),%esi
 10016ac:	41 b9 59 89 00 01    	mov    $0x1008959,%r9d
 10016b2:	4c 89 ff             	mov    %r15,%rdi
 10016b5:	ba 02 00 00 00       	mov    $0x2,%edx
 10016ba:	b9 10 00 00 00       	mov    $0x10,%ecx
 10016bf:	41 b8 30 00 00 00    	mov    $0x30,%r8d
 10016c5:	e8 98 29 00 00       	call   1004062 <_ZN13ostringstream7write_iEliicPKc>
 10016ca:	48 ff c3             	inc    %rbx
 10016cd:	48 83 fb 06          	cmp    $0x6,%rbx
 10016d1:	75 c5                	jne    1001698 <_Z6format8rostringz+0x4cf>
 10016d3:	e9 22 01 00 00       	jmp    10017fa <_Z6format8rostringz+0x631>
 10016d8:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10016dd:	48 8d 48 08          	lea    0x8(%rax),%rcx
 10016e1:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 10016e6:	48 8b 30             	mov    (%rax),%rsi
 10016e9:	44 0f be c3          	movsbl %bl,%r8d
 10016ed:	41 b9 40 84 00 01    	mov    $0x1008440,%r9d
 10016f3:	4c 89 ff             	mov    %r15,%rdi
 10016f6:	44 89 e2             	mov    %r12d,%edx
 10016f9:	b9 0a 00 00 00       	mov    $0xa,%ecx
 10016fe:	e8 5f 29 00 00       	call   1004062 <_ZN13ostringstream7write_iEliicPKc>
 1001703:	e9 f2 00 00 00       	jmp    10017fa <_Z6format8rostringz+0x631>
 1001708:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 100170d:	48 8d 48 08          	lea    0x8(%rax),%rcx
 1001711:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 1001716:	48 8b 00             	mov    (%rax),%rax
 1001719:	8b 48 08             	mov    0x8(%rax),%ecx
 100171c:	48 8b 00             	mov    (%rax),%rax
 100171f:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
 1001726:	00 
 1001727:	89 8c 24 88 00 00 00 	mov    %ecx,0x88(%rsp)
 100172e:	4c 89 ff             	mov    %r15,%rdi
 1001731:	48 8d b4 24 80 00 00 	lea    0x80(%rsp),%rsi
 1001738:	00 
 1001739:	e8 ae 28 00 00       	call   1003fec <_ZN13ostringstream5writeI8rostringEEvT_>
 100173e:	e9 b7 00 00 00       	jmp    10017fa <_Z6format8rostringz+0x631>
 1001743:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1001748:	48 8d 48 08          	lea    0x8(%rax),%rcx
 100174c:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 1001751:	48 8b 30             	mov    (%rax),%rsi
 1001754:	4c 89 ff             	mov    %r15,%rdi
 1001757:	e8 40 28 00 00       	call   1003f9c <_ZN13ostringstream5writeIPKcEEvT_>
 100175c:	e9 99 00 00 00       	jmp    10017fa <_Z6format8rostringz+0x631>
 1001761:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1001766:	48 8d 48 08          	lea    0x8(%rax),%rcx
 100176a:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 100176f:	8b 00                	mov    (%rax),%eax
 1001771:	89 44 24 18          	mov    %eax,0x18(%rsp)
 1001775:	0f b6 f0             	movzbl %al,%esi
 1001778:	41 b9 40 84 00 01    	mov    $0x1008440,%r9d
 100177e:	4c 89 ff             	mov    %r15,%rdi
 1001781:	31 d2                	xor    %edx,%edx
 1001783:	b9 0a 00 00 00       	mov    $0xa,%ecx
 1001788:	41 b8 20 00 00 00    	mov    $0x20,%r8d
 100178e:	e8 cf 28 00 00       	call   1004062 <_ZN13ostringstream7write_iEliicPKc>
 1001793:	bb 01 00 00 00       	mov    $0x1,%ebx
 1001798:	8b 74 24 58          	mov    0x58(%rsp),%esi
 100179c:	4c 89 ff             	mov    %r15,%rdi
 100179f:	e8 fc 65 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 10017a4:	c6 00 2e             	movb   $0x2e,(%rax)
 10017a7:	0f b6 74 1c 18       	movzbl 0x18(%rsp,%rbx,1),%esi
 10017ac:	41 b9 40 84 00 01    	mov    $0x1008440,%r9d
 10017b2:	4c 89 ff             	mov    %r15,%rdi
 10017b5:	31 d2                	xor    %edx,%edx
 10017b7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 10017bc:	41 b8 20 00 00 00    	mov    $0x20,%r8d
 10017c2:	e8 9b 28 00 00       	call   1004062 <_ZN13ostringstream7write_iEliicPKc>
 10017c7:	48 ff c3             	inc    %rbx
 10017ca:	48 83 fb 04          	cmp    $0x4,%rbx
 10017ce:	75 c8                	jne    1001798 <_Z6format8rostringz+0x5cf>
 10017d0:	eb 28                	jmp    10017fa <_Z6format8rostringz+0x631>
 10017d2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10017d7:	48 8d 48 08          	lea    0x8(%rax),%rcx
 10017db:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
 10017e0:	c5 fb 10 00          	vmovsd (%rax),%xmm0
 10017e4:	0f be cb             	movsbl %bl,%ecx
 10017e7:	4c 89 ff             	mov    %r15,%rdi
 10017ea:	44 89 e6             	mov    %r12d,%esi
 10017ed:	44 89 f2             	mov    %r14d,%edx
 10017f0:	e8 d7 28 00 00       	call   10040cc <_ZN13ostringstream7write_dEdiic>
 10017f5:	4c 8d 74 24 38       	lea    0x38(%rsp),%r14
 10017fa:	8b 74 24 48          	mov    0x48(%rsp),%esi
 10017fe:	3b 74 24 40          	cmp    0x40(%rsp),%esi
 1001802:	0f 8c bc fa ff ff    	jl     10012c4 <_Z6format8rostringz+0xfb>
 1001808:	8b 44 24 58          	mov    0x58(%rsp),%eax
 100180c:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
 1001811:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 1001816:	89 44 24 18          	mov    %eax,0x18(%rsp)
 100181a:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 100181f:	8b 54 24 18          	mov    0x18(%rsp),%edx
 1001823:	48 8b 5c 24 78       	mov    0x78(%rsp),%rbx
 1001828:	48 89 df             	mov    %rbx,%rdi
 100182b:	31 c9                	xor    %ecx,%ecx
 100182d:	e8 20 65 00 00       	call   1007d52 <_ZN6vectorIcEC2EPKcii>
 1001832:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
 1001837:	48 85 c0             	test   %rax,%rax
 100183a:	74 2e                	je     100186a <_Z6format8rostringz+0x6a1>
 100183c:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1001840:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1001844:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 100184b:	00 04 
 100184d:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1001852:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1001859:	04 
 100185a:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1001861:	04 
 1001862:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1001869:	00 
 100186a:	48 89 d8             	mov    %rbx,%rax
 100186d:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
 1001874:	5b                   	pop    %rbx
 1001875:	41 5c                	pop    %r12
 1001877:	41 5d                	pop    %r13
 1001879:	41 5e                	pop    %r14
 100187b:	41 5f                	pop    %r15
 100187d:	5d                   	pop    %rbp
 100187e:	c3                   	ret    
 100187f:	cc                   	int3   

0000000001001880 <_ZN6string10c_str_thisEv>:
 1001880:	53                   	push   %rbx
 1001881:	48 89 fb             	mov    %rdi,%rbx
 1001884:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
 1001888:	74 12                	je     100189c <_ZN6string10c_str_thisEv+0x1c>
 100188a:	8b 73 08             	mov    0x8(%rbx),%esi
 100188d:	ff ce                	dec    %esi
 100188f:	48 89 df             	mov    %rbx,%rdi
 1001892:	e8 9f 2e 00 00       	call   1004736 <_ZN4spanIcE2atEi>
 1001897:	80 38 00             	cmpb   $0x0,(%rax)
 100189a:	74 0e                	je     10018aa <_ZN6string10c_str_thisEv+0x2a>
 100189c:	8b 73 08             	mov    0x8(%rbx),%esi
 100189f:	48 89 df             	mov    %rbx,%rdi
 10018a2:	e8 f9 64 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 10018a7:	c6 00 00             	movb   $0x0,(%rax)
 10018aa:	48 8b 03             	mov    (%rbx),%rax
 10018ad:	5b                   	pop    %rbx
 10018ae:	c3                   	ret    

00000000010018af <_Z9ahci_read11ahci_devicemtPv>:
 10018af:	53                   	push   %rbx
 10018b0:	89 f0                	mov    %esi,%eax
 10018b2:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 10018b7:	8b 31                	mov    (%rcx),%esi
 10018b9:	83 e6 a0             	and    $0xffffffa0,%esi
 10018bc:	83 ce 05             	or     $0x5,%esi
 10018bf:	66 89 31             	mov    %si,(%rcx)
 10018c2:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 10018c7:	89 91 80 00 00 00    	mov    %edx,0x80(%rcx)
 10018cd:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%rcx)
 10018d4:	00 00 00 
 10018d7:	89 c2                	mov    %eax,%edx
 10018d9:	c1 e2 09             	shl    $0x9,%edx
 10018dc:	ff ca                	dec    %edx
 10018de:	81 e2 ff ff 3f 00    	and    $0x3fffff,%edx
 10018e4:	be 00 00 c0 7f       	mov    $0x7fc00000,%esi
 10018e9:	23 b1 8c 00 00 00    	and    0x8c(%rcx),%esi
 10018ef:	01 f2                	add    %esi,%edx
 10018f1:	81 c2 00 00 00 80    	add    $0x80000000,%edx
 10018f7:	89 91 8c 00 00 00    	mov    %edx,0x8c(%rcx)
 10018fd:	c6 01 27             	movb   $0x27,(%rcx)
 1001900:	80 49 01 80          	orb    $0x80,0x1(%rcx)
 1001904:	48 89 fa             	mov    %rdi,%rdx
 1001907:	c6 41 02 25          	movb   $0x25,0x2(%rcx)
 100190b:	88 51 04             	mov    %dl,0x4(%rcx)
 100190e:	88 71 05             	mov    %dh,0x5(%rcx)
 1001911:	89 d6                	mov    %edx,%esi
 1001913:	c1 ee 10             	shr    $0x10,%esi
 1001916:	40 88 71 06          	mov    %sil,0x6(%rcx)
 100191a:	c6 41 07 40          	movb   $0x40,0x7(%rcx)
 100191e:	89 d6                	mov    %edx,%esi
 1001920:	c1 ee 18             	shr    $0x18,%esi
 1001923:	40 88 71 08          	mov    %sil,0x8(%rcx)
 1001927:	48 89 fe             	mov    %rdi,%rsi
 100192a:	48 c1 ee 20          	shr    $0x20,%rsi
 100192e:	40 88 71 09          	mov    %sil,0x9(%rcx)
 1001932:	48 c1 ea 28          	shr    $0x28,%rdx
 1001936:	88 51 0a             	mov    %dl,0xa(%rcx)
 1001939:	88 41 0c             	mov    %al,0xc(%rcx)
 100193c:	88 61 0d             	mov    %ah,0xd(%rcx)
 100193f:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
 1001944:	f7 40 20 84 00 00 00 	testl  $0x84,0x20(%rax)
 100194b:	75 f7                	jne    1001944 <_Z9ahci_read11ahci_devicemtPv+0x95>
 100194d:	83 48 38 01          	orl    $0x1,0x38(%rax)
 1001951:	f7 40 38 01 00 00 00 	testl  $0x1,0x38(%rax)
 1001958:	74 07                	je     1001961 <_Z9ahci_read11ahci_devicemtPv+0xb2>
 100195a:	0f ba 60 10 1e       	btl    $0x1e,0x10(%rax)
 100195f:	73 f0                	jae    1001951 <_Z9ahci_read11ahci_devicemtPv+0xa2>
 1001961:	0f ba 60 10 1e       	btl    $0x1e,0x10(%rax)
 1001966:	73 21                	jae    1001989 <_Z9ahci_read11ahci_devicemtPv+0xda>
 1001968:	b0 44                	mov    $0x44,%al
 100196a:	48 c7 c3 ee ff ff ff 	mov    $0xffffffffffffffee,%rbx
 1001971:	0f be f0             	movsbl %al,%esi
 1001974:	bf 00 00 11 00       	mov    $0x110000,%edi
 1001979:	e8 d4 21 00 00       	call   1003b52 <_ZN7console7putcharEc>
 100197e:	8a 83 59 89 00 01    	mov    0x1008959(%rbx),%al
 1001984:	48 ff c3             	inc    %rbx
 1001987:	75 e8                	jne    1001971 <_Z9ahci_read11ahci_devicemtPv+0xc2>
 1001989:	5b                   	pop    %rbx
 100198a:	c3                   	ret    

000000000100198b <_Z10ahci_write11ahci_devicemtPv>:
 100198b:	55                   	push   %rbp
 100198c:	53                   	push   %rbx
 100198d:	50                   	push   %rax
 100198e:	4c 8d 4c 24 20       	lea    0x20(%rsp),%r9
 1001993:	49 8b 41 08          	mov    0x8(%r9),%rax
 1001997:	44 8b 50 34          	mov    0x34(%rax),%r10d
 100199b:	44 0b 50 38          	or     0x38(%rax),%r10d
 100199f:	89 f1                	mov    %esi,%ecx
 10019a1:	48 89 fb             	mov    %rdi,%rbx
 10019a4:	31 f6                	xor    %esi,%esi
 10019a6:	41 b8 10 00 00 00    	mov    $0x10,%r8d
 10019ac:	bf 01 00 00 00       	mov    $0x1,%edi
 10019b1:	41 0f a3 f2          	bt     %esi,%r10d
 10019b5:	73 35                	jae    10019ec <_Z10ahci_write11ahci_devicemtPv+0x61>
 10019b7:	ff c6                	inc    %esi
 10019b9:	49 83 c0 20          	add    $0x20,%r8
 10019bd:	41 81 f8 10 04 00 00 	cmp    $0x410,%r8d
 10019c4:	75 eb                	jne    10019b1 <_Z10ahci_write11ahci_devicemtPv+0x26>
 10019c6:	b0 4e                	mov    $0x4e,%al
 10019c8:	48 c7 c3 e3 ff ff ff 	mov    $0xffffffffffffffe3,%rbx
 10019cf:	0f be f0             	movsbl %al,%esi
 10019d2:	bf 00 00 11 00       	mov    $0x110000,%edi
 10019d7:	e8 76 21 00 00       	call   1003b52 <_ZN7console7putcharEc>
 10019dc:	8a 83 69 87 00 01    	mov    0x1008769(%rbx),%al
 10019e2:	48 ff c3             	inc    %rbx
 10019e5:	75 e8                	jne    10019cf <_Z10ahci_write11ahci_devicemtPv+0x44>
 10019e7:	e9 ac 00 00 00       	jmp    1001a98 <_Z10ahci_write11ahci_devicemtPv+0x10d>
 10019ec:	4d 8b 51 10          	mov    0x10(%r9),%r10
 10019f0:	47 8b 5c 02 f0       	mov    -0x10(%r10,%r8,1),%r11d
 10019f5:	41 83 e3 a0          	and    $0xffffffa0,%r11d
 10019f9:	41 83 cb 45          	or     $0x45,%r11d
 10019fd:	66 47 89 5c 02 f0    	mov    %r11w,-0x10(%r10,%r8,1)
 1001a03:	49 8b 69 20          	mov    0x20(%r9),%rbp
 1001a07:	42 89 54 c5 00       	mov    %edx,0x0(%rbp,%r8,8)
 1001a0c:	42 c7 44 c5 04 00 00 	movl   $0x0,0x4(%rbp,%r8,8)
 1001a13:	00 00 
 1001a15:	89 ca                	mov    %ecx,%edx
 1001a17:	c1 e2 09             	shl    $0x9,%edx
 1001a1a:	ff ca                	dec    %edx
 1001a1c:	81 e2 ff ff 3f 00    	and    $0x3fffff,%edx
 1001a22:	41 b9 00 00 c0 7f    	mov    $0x7fc00000,%r9d
 1001a28:	46 23 4c c5 0c       	and    0xc(%rbp,%r8,8),%r9d
 1001a2d:	44 01 ca             	add    %r9d,%edx
 1001a30:	81 c2 00 00 00 80    	add    $0x80000000,%edx
 1001a36:	42 89 54 c5 0c       	mov    %edx,0xc(%rbp,%r8,8)
 1001a3b:	c6 45 00 27          	movb   $0x27,0x0(%rbp)
 1001a3f:	80 4d 01 80          	orb    $0x80,0x1(%rbp)
 1001a43:	c4 e2 49 f7 d7       	shlx   %esi,%edi,%edx
 1001a48:	c6 45 02 35          	movb   $0x35,0x2(%rbp)
 1001a4c:	88 5d 04             	mov    %bl,0x4(%rbp)
 1001a4f:	88 7d 05             	mov    %bh,0x5(%rbp)
 1001a52:	89 de                	mov    %ebx,%esi
 1001a54:	c1 ee 10             	shr    $0x10,%esi
 1001a57:	40 88 75 06          	mov    %sil,0x6(%rbp)
 1001a5b:	c6 45 07 40          	movb   $0x40,0x7(%rbp)
 1001a5f:	89 de                	mov    %ebx,%esi
 1001a61:	c1 ee 18             	shr    $0x18,%esi
 1001a64:	40 88 75 08          	mov    %sil,0x8(%rbp)
 1001a68:	48 89 de             	mov    %rbx,%rsi
 1001a6b:	48 c1 ee 20          	shr    $0x20,%rsi
 1001a6f:	40 88 75 09          	mov    %sil,0x9(%rbp)
 1001a73:	48 c1 eb 28          	shr    $0x28,%rbx
 1001a77:	88 5d 0a             	mov    %bl,0xa(%rbp)
 1001a7a:	88 4d 0c             	mov    %cl,0xc(%rbp)
 1001a7d:	88 6d 0d             	mov    %ch,0xd(%rbp)
 1001a80:	f7 40 20 84 00 00 00 	testl  $0x84,0x20(%rax)
 1001a87:	75 f7                	jne    1001a80 <_Z10ahci_write11ahci_devicemtPv+0xf5>
 1001a89:	89 50 38             	mov    %edx,0x38(%rax)
 1001a8c:	85 50 38             	test   %edx,0x38(%rax)
 1001a8f:	74 07                	je     1001a98 <_Z10ahci_write11ahci_devicemtPv+0x10d>
 1001a91:	0f ba 60 10 1e       	btl    $0x1e,0x10(%rax)
 1001a96:	73 f4                	jae    1001a8c <_Z10ahci_write11ahci_devicemtPv+0x101>
 1001a98:	48 83 c4 08          	add    $0x8,%rsp
 1001a9c:	5b                   	pop    %rbx
 1001a9d:	5d                   	pop    %rbp
 1001a9e:	c3                   	ret    

0000000001001a9f <_Z9read_diskPvjt>:
 1001a9f:	48 83 ec 28          	sub    $0x28,%rsp
 1001aa3:	48 89 f8             	mov    %rdi,%rax
 1001aa6:	48 8b 0c 25 c8 00 11 	mov    0x1100c8,%rcx
 1001aad:	00 
 1001aae:	89 f7                	mov    %esi,%edi
 1001ab0:	48 8b 71 20          	mov    0x20(%rcx),%rsi
 1001ab4:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
 1001ab9:	c5 fc 10 01          	vmovups (%rcx),%ymm0
 1001abd:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
 1001ac2:	89 d6                	mov    %edx,%esi
 1001ac4:	48 89 c2             	mov    %rax,%rdx
 1001ac7:	c5 f8 77             	vzeroupper 
 1001aca:	e8 e0 fd ff ff       	call   10018af <_Z9ahci_read11ahci_devicemtPv>
 1001acf:	48 83 c4 28          	add    $0x28,%rsp
 1001ad3:	c3                   	ret    

0000000001001ad4 <_Z10e1000_init10pci_devicePFvPvtEPFvvE>:
 1001ad4:	41 56                	push   %r14
 1001ad6:	53                   	push   %rbx
 1001ad7:	48 83 ec 28          	sub    $0x28,%rsp
 1001adb:	4c 8d 74 24 40       	lea    0x40(%rsp),%r14
 1001ae0:	48 8b 04 25 20 00 11 	mov    0x110020,%rax
 1001ae7:	00 
 1001ae8:	48 83 c0 0f          	add    $0xf,%rax
 1001aec:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
 1001af0:	48 89 05 09 71 00 00 	mov    %rax,0x7109(%rip)        # 1008c00 <e1000_dev>
 1001af7:	48 8d 48 30          	lea    0x30(%rax),%rcx
 1001afb:	48 8d 90 b0 00 00 00 	lea    0xb0(%rax),%rdx
 1001b02:	48 89 48 10          	mov    %rcx,0x10(%rax)
 1001b06:	48 8d 88 30 01 00 00 	lea    0x130(%rax),%rcx
 1001b0d:	48 89 0c 25 20 00 11 	mov    %rcx,0x110020
 1001b14:	00 
 1001b15:	48 89 50 18          	mov    %rdx,0x18(%rax)
 1001b19:	48 89 3d e8 70 00 00 	mov    %rdi,0x70e8(%rip)        # 1008c08 <_ZL10receive_fn>
 1001b20:	48 89 35 e9 70 00 00 	mov    %rsi,0x70e9(%rip)        # 1008c10 <_ZL7link_fn>
 1001b27:	41 8b 4e 10          	mov    0x10(%r14),%ecx
 1001b2b:	83 e1 f0             	and    $0xfffffff0,%ecx
 1001b2e:	48 89 08             	mov    %rcx,(%rax)
 1001b31:	41 0f b7 4e 14       	movzwl 0x14(%r14),%ecx
 1001b36:	83 e1 fe             	and    $0xfffffffe,%ecx
 1001b39:	66 89 48 08          	mov    %cx,0x8(%rax)
 1001b3d:	41 0f b6 4e 02       	movzbl 0x2(%r14),%ecx
 1001b42:	41 0f b7 06          	movzwl (%r14),%eax
 1001b46:	89 c2                	mov    %eax,%edx
 1001b48:	c1 e2 10             	shl    $0x10,%edx
 1001b4b:	c1 e0 03             	shl    $0x3,%eax
 1001b4e:	25 00 f8 07 00       	and    $0x7f800,%eax
 1001b53:	c1 e1 08             	shl    $0x8,%ecx
 1001b56:	09 d1                	or     %edx,%ecx
 1001b58:	09 c1                	or     %eax,%ecx
 1001b5a:	81 e1 00 ff ff 00    	and    $0xffff00,%ecx
 1001b60:	81 c9 04 00 00 80    	or     $0x80000004,%ecx
 1001b66:	89 c8                	mov    %ecx,%eax
 1001b68:	66 ba f8 0c          	mov    $0xcf8,%dx
 1001b6c:	ef                   	out    %eax,(%dx)
 1001b6d:	66 ba fc 0c          	mov    $0xcfc,%dx
 1001b71:	ed                   	in     (%dx),%eax
 1001b72:	89 c6                	mov    %eax,%esi
 1001b74:	83 ce 06             	or     $0x6,%esi
 1001b77:	89 c8                	mov    %ecx,%eax
 1001b79:	66 ba f8 0c          	mov    $0xcf8,%dx
 1001b7d:	ef                   	out    %eax,(%dx)
 1001b7e:	89 f0                	mov    %esi,%eax
 1001b80:	66 ba fc 0c          	mov    $0xcfc,%dx
 1001b84:	ef                   	out    %eax,(%dx)
 1001b85:	48 8b 05 74 70 00 00 	mov    0x7074(%rip),%rax        # 1008c00 <e1000_dev>
 1001b8c:	48 8b 08             	mov    (%rax),%rcx
 1001b8f:	48 c1 e9 15          	shr    $0x15,%rcx
 1001b93:	48 83 0c cd 00 20 07 	orq    $0x8,0x72000(,%rcx,8)
 1001b9a:	00 08 
 1001b9c:	48 8b 00             	mov    (%rax),%rax
 1001b9f:	c7 80 d8 00 00 00 ff 	movl   $0xffffffff,0xd8(%rax)
 1001ba6:	ff ff ff 
 1001ba9:	81 20 ff ff ff fb    	andl   $0xfbffffff,(%rax)
 1001baf:	31 c0                	xor    %eax,%eax
 1001bb1:	e6 80                	out    %al,$0x80
 1001bb3:	48 8b 05 46 70 00 00 	mov    0x7046(%rip),%rax        # 1008c00 <e1000_dev>
 1001bba:	c6 40 24 00          	movb   $0x0,0x24(%rax)
 1001bbe:	48 8b 00             	mov    (%rax),%rax
 1001bc1:	c7 40 14 01 00 00 00 	movl   $0x1,0x14(%rax)
 1001bc8:	ba e8 03 00 00       	mov    $0x3e8,%edx
 1001bcd:	31 c0                	xor    %eax,%eax
 1001bcf:	e6 80                	out    %al,$0x80
 1001bd1:	48 8b 0d 28 70 00 00 	mov    0x7028(%rip),%rcx        # 1008c00 <e1000_dev>
 1001bd8:	48 8b 01             	mov    (%rcx),%rax
 1001bdb:	f6 40 14 10          	testb  $0x10,0x14(%rax)
 1001bdf:	75 30                	jne    1001c11 <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x13d>
 1001be1:	ff ca                	dec    %edx
 1001be3:	75 e8                	jne    1001bcd <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0xf9>
 1001be5:	80 79 24 00          	cmpb   $0x0,0x24(%rcx)
 1001be9:	75 2a                	jne    1001c15 <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x141>
 1001beb:	8b b8 00 54 00 00    	mov    0x5400(%rax),%edi
 1001bf1:	41 89 f8             	mov    %edi,%r8d
 1001bf4:	41 c1 e8 10          	shr    $0x10,%r8d
 1001bf8:	89 79 0a             	mov    %edi,0xa(%rcx)
 1001bfb:	c1 ef 18             	shr    $0x18,%edi
 1001bfe:	8b 80 04 54 00 00    	mov    0x5404(%rax),%eax
 1001c04:	41 89 c2             	mov    %eax,%r10d
 1001c07:	41 c1 ea 08          	shr    $0x8,%r10d
 1001c0b:	66 89 41 0e          	mov    %ax,0xe(%rcx)
 1001c0f:	eb 56                	jmp    1001c67 <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x193>
 1001c11:	c6 41 24 01          	movb   $0x1,0x24(%rcx)
 1001c15:	c7 40 10 0b 00 00 00 	movl   $0xb,0x10(%rax)
 1001c1c:	31 ff                	xor    %edi,%edi
 1001c1e:	e8 03 03 00 00       	call   1001f26 <_ZL17e1000_read_eepromh>
 1001c23:	48 8b 0d d6 6f 00 00 	mov    0x6fd6(%rip),%rcx        # 1008c00 <e1000_dev>
 1001c2a:	66 89 41 0a          	mov    %ax,0xa(%rcx)
 1001c2e:	bf 01 00 00 00       	mov    $0x1,%edi
 1001c33:	e8 ee 02 00 00       	call   1001f26 <_ZL17e1000_read_eepromh>
 1001c38:	48 8b 0d c1 6f 00 00 	mov    0x6fc1(%rip),%rcx        # 1008c00 <e1000_dev>
 1001c3f:	66 89 41 0c          	mov    %ax,0xc(%rcx)
 1001c43:	bf 02 00 00 00       	mov    $0x2,%edi
 1001c48:	e8 d9 02 00 00       	call   1001f26 <_ZL17e1000_read_eepromh>
 1001c4d:	48 8b 0d ac 6f 00 00 	mov    0x6fac(%rip),%rcx        # 1008c00 <e1000_dev>
 1001c54:	41 89 c2             	mov    %eax,%r10d
 1001c57:	41 c1 ea 08          	shr    $0x8,%r10d
 1001c5b:	66 89 41 0e          	mov    %ax,0xe(%rcx)
 1001c5f:	44 8a 41 0c          	mov    0xc(%rcx),%r8b
 1001c63:	40 8a 79 0d          	mov    0xd(%rcx),%dil
 1001c67:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
 1001c6c:	48 c7 06 0d 84 00 01 	movq   $0x100840d,(%rsi)
 1001c73:	c7 46 08 32 00 00 00 	movl   $0x32,0x8(%rsi)
 1001c7a:	0f b6 51 0a          	movzbl 0xa(%rcx),%edx
 1001c7e:	0f b6 49 0b          	movzbl 0xb(%rcx),%ecx
 1001c82:	45 0f b6 c0          	movzbl %r8b,%r8d
 1001c86:	44 0f b6 cf          	movzbl %dil,%r9d
 1001c8a:	44 0f b6 d8          	movzbl %al,%r11d
 1001c8e:	45 0f b6 d2          	movzbl %r10b,%r10d
 1001c92:	48 8d 5c 24 08       	lea    0x8(%rsp),%rbx
 1001c97:	48 89 df             	mov    %rbx,%rdi
 1001c9a:	31 c0                	xor    %eax,%eax
 1001c9c:	41 52                	push   %r10
 1001c9e:	41 53                	push   %r11
 1001ca0:	e8 24 f5 ff ff       	call   10011c9 <_Z6format8rostringz>
 1001ca5:	48 83 c4 10          	add    $0x10,%rsp
 1001ca9:	48 89 df             	mov    %rbx,%rdi
 1001cac:	e8 cf fb ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1001cb1:	48 89 c3             	mov    %rax,%rbx
 1001cb4:	8a 00                	mov    (%rax),%al
 1001cb6:	84 c0                	test   %al,%al
 1001cb8:	74 19                	je     1001cd3 <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x1ff>
 1001cba:	48 ff c3             	inc    %rbx
 1001cbd:	0f be f0             	movsbl %al,%esi
 1001cc0:	bf 00 00 11 00       	mov    $0x110000,%edi
 1001cc5:	e8 88 1e 00 00       	call   1003b52 <_ZN7console7putcharEc>
 1001cca:	8a 03                	mov    (%rbx),%al
 1001ccc:	48 ff c3             	inc    %rbx
 1001ccf:	84 c0                	test   %al,%al
 1001cd1:	75 ea                	jne    1001cbd <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x1e9>
 1001cd3:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1001cd8:	48 85 c0             	test   %rax,%rax
 1001cdb:	74 2e                	je     1001d0b <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x237>
 1001cdd:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1001ce1:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1001ce5:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1001cec:	00 04 
 1001cee:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1001cf3:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1001cfa:	04 
 1001cfb:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1001d02:	04 
 1001d03:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1001d0a:	00 
 1001d0b:	48 8b 0d ee 6e 00 00 	mov    0x6eee(%rip),%rcx        # 1008c00 <e1000_dev>
 1001d12:	48 8b 01             	mov    (%rcx),%rax
 1001d15:	31 d2                	xor    %edx,%edx
 1001d17:	c7 84 90 00 52 00 00 	movl   $0x0,0x5200(%rax,%rdx,4)
 1001d1e:	00 00 00 00 
 1001d22:	48 ff c2             	inc    %rdx
 1001d25:	48 81 fa 80 00 00 00 	cmp    $0x80,%rdx
 1001d2c:	75 e9                	jne    1001d17 <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x243>
 1001d2e:	48 8b 51 10          	mov    0x10(%rcx),%rdx
 1001d32:	48 8b 3c 25 20 00 11 	mov    0x110020,%rdi
 1001d39:	00 
 1001d3a:	31 f6                	xor    %esi,%esi
 1001d3c:	48 83 c7 0f          	add    $0xf,%rdi
 1001d40:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
 1001d44:	4c 8d 87 00 10 00 00 	lea    0x1000(%rdi),%r8
 1001d4b:	4c 89 04 25 20 00 11 	mov    %r8,0x110020
 1001d52:	00 
 1001d53:	48 89 3c 32          	mov    %rdi,(%rdx,%rsi,1)
 1001d57:	c6 44 32 0c 00       	movb   $0x0,0xc(%rdx,%rsi,1)
 1001d5c:	48 83 c6 10          	add    $0x10,%rsi
 1001d60:	4c 89 c7             	mov    %r8,%rdi
 1001d63:	48 81 fe 80 00 00 00 	cmp    $0x80,%rsi
 1001d6a:	75 d0                	jne    1001d3c <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x268>
 1001d6c:	89 90 00 28 00 00    	mov    %edx,0x2800(%rax)
 1001d72:	31 d2                	xor    %edx,%edx
 1001d74:	89 90 04 28 00 00    	mov    %edx,0x2804(%rax)
 1001d7a:	c7 80 08 28 00 00 80 	movl   $0x80,0x2808(%rax)
 1001d81:	00 00 00 
 1001d84:	c7 80 28 28 00 00 01 	movl   $0x1010101,0x2828(%rax)
 1001d8b:	01 01 01 
 1001d8e:	89 90 20 28 00 00    	mov    %edx,0x2820(%rax)
 1001d94:	89 90 10 28 00 00    	mov    %edx,0x2810(%rax)
 1001d9a:	c7 80 18 28 00 00 08 	movl   $0x8,0x2818(%rax)
 1001da1:	00 00 00 
 1001da4:	66 c7 41 20 00 00    	movw   $0x0,0x20(%rcx)
 1001daa:	c7 80 00 01 00 00 1e 	movl   $0x400801e,0x100(%rax)
 1001db1:	80 00 04 
 1001db4:	48 8b 71 18          	mov    0x18(%rcx),%rsi
 1001db8:	48 c7 04 16 00 00 00 	movq   $0x0,(%rsi,%rdx,1)
 1001dbf:	00 
 1001dc0:	c6 44 16 0b 00       	movb   $0x0,0xb(%rsi,%rdx,1)
 1001dc5:	c6 44 16 0c 01       	movb   $0x1,0xc(%rsi,%rdx,1)
 1001dca:	48 83 c2 10          	add    $0x10,%rdx
 1001dce:	48 81 fa 80 00 00 00 	cmp    $0x80,%rdx
 1001dd5:	75 e1                	jne    1001db8 <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x2e4>
 1001dd7:	89 b0 00 38 00 00    	mov    %esi,0x3800(%rax)
 1001ddd:	31 d2                	xor    %edx,%edx
 1001ddf:	89 90 04 38 00 00    	mov    %edx,0x3804(%rax)
 1001de5:	c7 80 08 38 00 00 80 	movl   $0x80,0x3808(%rax)
 1001dec:	00 00 00 
 1001def:	89 90 10 38 00 00    	mov    %edx,0x3810(%rax)
 1001df5:	89 90 18 38 00 00    	mov    %edx,0x3818(%rax)
 1001dfb:	66 c7 41 22 00 00    	movw   $0x0,0x22(%rcx)
 1001e01:	c7 80 00 04 00 00 fa 	movl   $0x10400fa,0x400(%rax)
 1001e08:	00 04 01 
 1001e0b:	41 0f b7 4e 06       	movzwl 0x6(%r14),%ecx
 1001e10:	81 f9 0e 10 00 00    	cmp    $0x100e,%ecx
 1001e16:	74 0a                	je     1001e22 <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x34e>
 1001e18:	c7 80 00 04 00 00 fa 	movl   $0x3003f0fa,0x400(%rax)
 1001e1f:	f0 03 30 
 1001e22:	c7 80 10 04 00 00 0a 	movl   $0x60200a,0x410(%rax)
 1001e29:	20 60 00 
 1001e2c:	41 0f b6 7e 2c       	movzbl 0x2c(%r14),%edi
 1001e31:	be f8 1f 00 01       	mov    $0x1001ff8,%esi
 1001e36:	e8 83 01 00 00       	call   1001fbe <_Z7irq_sethPFvvE>
 1001e3b:	b0 02                	mov    $0x2,%al
 1001e3d:	e6 21                	out    %al,$0x21
 1001e3f:	b0 80                	mov    $0x80,%al
 1001e41:	e6 a1                	out    %al,$0xa1
 1001e43:	b0 65                	mov    $0x65,%al
 1001e45:	48 c7 c3 dd ff ff ff 	mov    $0xffffffffffffffdd,%rbx
 1001e4c:	0f be f0             	movsbl %al,%esi
 1001e4f:	bf 00 00 11 00       	mov    $0x110000,%edi
 1001e54:	e8 f9 1c 00 00       	call   1003b52 <_ZN7console7putcharEc>
 1001e59:	8a 83 c6 88 00 01    	mov    0x10088c6(%rbx),%al
 1001e5f:	48 ff c3             	inc    %rbx
 1001e62:	75 e8                	jne    1001e4c <_Z10e1000_init10pci_devicePFvPvtEPFvvE+0x378>
 1001e64:	48 83 c4 28          	add    $0x28,%rsp
 1001e68:	5b                   	pop    %rbx
 1001e69:	41 5e                	pop    %r14
 1001e6b:	c3                   	ret    

0000000001001e6c <_Z6wallocmt>:
 1001e6c:	66 83 fe 10          	cmp    $0x10,%si
 1001e70:	b9 10 00 00 00       	mov    $0x10,%ecx
 1001e75:	0f 42 ce             	cmovb  %esi,%ecx
 1001e78:	48 8b 34 25 20 00 11 	mov    0x110020,%rsi
 1001e7f:	00 
 1001e80:	48 89 f0             	mov    %rsi,%rax
 1001e83:	31 d2                	xor    %edx,%edx
 1001e85:	48 f7 f1             	div    %rcx
 1001e88:	48 01 f1             	add    %rsi,%rcx
 1001e8b:	48 29 d1             	sub    %rdx,%rcx
 1001e8e:	48 85 d2             	test   %rdx,%rdx
 1001e91:	48 0f 44 ce          	cmove  %rsi,%rcx
 1001e95:	48 01 cf             	add    %rcx,%rdi
 1001e98:	48 89 3c 25 20 00 11 	mov    %rdi,0x110020
 1001e9f:	00 
 1001ea0:	48 89 c8             	mov    %rcx,%rax
 1001ea3:	c3                   	ret    

0000000001001ea4 <_Z8pci_read8pci_addrh>:
 1001ea4:	89 f8                	mov    %edi,%eax
 1001ea6:	8d 0c fd 00 00 00 00 	lea    0x0(,%rdi,8),%ecx
 1001ead:	89 fa                	mov    %edi,%edx
 1001eaf:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
 1001eb5:	c1 e0 10             	shl    $0x10,%eax
 1001eb8:	81 e1 00 f8 07 00    	and    $0x7f800,%ecx
 1001ebe:	09 c1                	or     %eax,%ecx
 1001ec0:	c1 ea 08             	shr    $0x8,%edx
 1001ec3:	09 ca                	or     %ecx,%edx
 1001ec5:	81 e2 00 ff ff 00    	and    $0xffff00,%edx
 1001ecb:	8d 04 b5 00 00 00 00 	lea    0x0(,%rsi,4),%eax
 1001ed2:	09 d0                	or     %edx,%eax
 1001ed4:	0d 00 00 00 80       	or     $0x80000000,%eax
 1001ed9:	66 ba f8 0c          	mov    $0xcf8,%dx
 1001edd:	ef                   	out    %eax,(%dx)
 1001ede:	66 ba fc 0c          	mov    $0xcfc,%dx
 1001ee2:	ed                   	in     (%dx),%eax
 1001ee3:	c3                   	ret    

0000000001001ee4 <_Z9pci_write8pci_addrhj>:
 1001ee4:	89 d1                	mov    %edx,%ecx
 1001ee6:	89 f8                	mov    %edi,%eax
 1001ee8:	8d 14 fd 00 00 00 00 	lea    0x0(,%rdi,8),%edx
 1001eef:	81 e7 00 00 ff 00    	and    $0xff0000,%edi
 1001ef5:	c1 e0 10             	shl    $0x10,%eax
 1001ef8:	81 e2 00 f8 07 00    	and    $0x7f800,%edx
 1001efe:	09 c2                	or     %eax,%edx
 1001f00:	c1 ef 08             	shr    $0x8,%edi
 1001f03:	09 d7                	or     %edx,%edi
 1001f05:	81 e7 00 ff ff 00    	and    $0xffff00,%edi
 1001f0b:	8d 04 b5 00 00 00 00 	lea    0x0(,%rsi,4),%eax
 1001f12:	09 f8                	or     %edi,%eax
 1001f14:	0d 00 00 00 80       	or     $0x80000000,%eax
 1001f19:	66 ba f8 0c          	mov    $0xcf8,%dx
 1001f1d:	ef                   	out    %eax,(%dx)
 1001f1e:	89 c8                	mov    %ecx,%eax
 1001f20:	66 ba fc 0c          	mov    $0xcfc,%dx
 1001f24:	ef                   	out    %eax,(%dx)
 1001f25:	c3                   	ret    

0000000001001f26 <_ZL17e1000_read_eepromh>:
 1001f26:	53                   	push   %rbx
 1001f27:	48 83 ec 20          	sub    $0x20,%rsp
 1001f2b:	c1 e7 08             	shl    $0x8,%edi
 1001f2e:	83 cf 01             	or     $0x1,%edi
 1001f31:	48 8b 05 c8 6c 00 00 	mov    0x6cc8(%rip),%rax        # 1008c00 <e1000_dev>
 1001f38:	48 8b 00             	mov    (%rax),%rax
 1001f3b:	89 78 14             	mov    %edi,0x14(%rax)
 1001f3e:	31 c0                	xor    %eax,%eax
 1001f40:	e6 80                	out    %al,$0x80
 1001f42:	48 8b 05 b7 6c 00 00 	mov    0x6cb7(%rip),%rax        # 1008c00 <e1000_dev>
 1001f49:	48 8b 00             	mov    (%rax),%rax
 1001f4c:	8b 40 14             	mov    0x14(%rax),%eax
 1001f4f:	a8 10                	test   $0x10,%al
 1001f51:	75 62                	jne    1001fb5 <_ZL17e1000_read_eepromh+0x8f>
 1001f53:	b9 e9 03 00 00       	mov    $0x3e9,%ecx
 1001f58:	31 c0                	xor    %eax,%eax
 1001f5a:	e6 80                	out    %al,$0x80
 1001f5c:	48 8b 05 9d 6c 00 00 	mov    0x6c9d(%rip),%rax        # 1008c00 <e1000_dev>
 1001f63:	48 8b 10             	mov    (%rax),%rdx
 1001f66:	8b 42 14             	mov    0x14(%rdx),%eax
 1001f69:	a8 10                	test   $0x10,%al
 1001f6b:	75 48                	jne    1001fb5 <_ZL17e1000_read_eepromh+0x8f>
 1001f6d:	ff c9                	dec    %ecx
 1001f6f:	75 e7                	jne    1001f58 <_ZL17e1000_read_eepromh+0x32>
 1001f71:	48 89 e6             	mov    %rsp,%rsi
 1001f74:	48 c7 06 1a 89 00 01 	movq   $0x100891a,(%rsi)
 1001f7b:	c7 46 08 1e 00 00 00 	movl   $0x1e,0x8(%rsi)
 1001f82:	8b 52 10             	mov    0x10(%rdx),%edx
 1001f85:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
 1001f8a:	48 89 df             	mov    %rbx,%rdi
 1001f8d:	89 c1                	mov    %eax,%ecx
 1001f8f:	31 c0                	xor    %eax,%eax
 1001f91:	e8 33 f2 ff ff       	call   10011c9 <_Z6format8rostringz>
 1001f96:	48 89 df             	mov    %rbx,%rdi
 1001f99:	e8 e2 f8 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1001f9e:	bf 00 00 11 00       	mov    $0x110000,%edi
 1001fa3:	48 89 c6             	mov    %rax,%rsi
 1001fa6:	e8 ef f1 ff ff       	call   100119a <_ZN7console6putstrEPKc>
 1001fab:	48 89 df             	mov    %rbx,%rdi
 1001fae:	e8 df 46 00 00       	call   1006692 <_ZN6vectorIcED2Ev>
 1001fb3:	eb fe                	jmp    1001fb3 <_ZL17e1000_read_eepromh+0x8d>
 1001fb5:	c1 e8 10             	shr    $0x10,%eax
 1001fb8:	48 83 c4 20          	add    $0x20,%rsp
 1001fbc:	5b                   	pop    %rbx
 1001fbd:	c3                   	ret    

0000000001001fbe <_Z7irq_sethPFvvE>:
 1001fbe:	89 f8                	mov    %edi,%eax
 1001fc0:	48 89 34 c5 40 00 11 	mov    %rsi,0x110040(,%rax,8)
 1001fc7:	00 
 1001fc8:	40 80 ff 07          	cmp    $0x7,%dil
 1001fcc:	77 13                	ja     1001fe1 <_Z7irq_sethPFvvE+0x23>
 1001fce:	e4 21                	in     $0x21,%al
 1001fd0:	b9 01 00 00 00       	mov    $0x1,%ecx
 1001fd5:	c4 e2 41 f7 c9       	shlx   %edi,%ecx,%ecx
 1001fda:	f6 d1                	not    %cl
 1001fdc:	20 c8                	and    %cl,%al
 1001fde:	e6 21                	out    %al,$0x21
 1001fe0:	c3                   	ret    
 1001fe1:	e4 a1                	in     $0xa1,%al
 1001fe3:	40 80 c7 f8          	add    $0xf8,%dil
 1001fe7:	b9 01 00 00 00       	mov    $0x1,%ecx
 1001fec:	c4 e2 41 f7 c9       	shlx   %edi,%ecx,%ecx
 1001ff1:	f6 d1                	not    %cl
 1001ff3:	20 c8                	and    %cl,%al
 1001ff5:	e6 a1                	out    %al,$0xa1
 1001ff7:	c3                   	ret    

0000000001001ff8 <_Z17e1000_int_handlerv>:
 1001ff8:	55                   	push   %rbp
 1001ff9:	53                   	push   %rbx
 1001ffa:	48 83 ec 58          	sub    $0x58,%rsp
 1001ffe:	48 8b 05 fb 6b 00 00 	mov    0x6bfb(%rip),%rax        # 1008c00 <e1000_dev>
 1002005:	48 8b 00             	mov    (%rax),%rax
 1002008:	c7 80 d0 00 00 00 01 	movl   $0x1,0xd0(%rax)
 100200f:	00 00 00 
 1002012:	8b a8 c0 00 00 00    	mov    0xc0(%rax),%ebp
 1002018:	40 f6 c5 04          	test   $0x4,%bpl
 100201c:	74 09                	je     1002027 <_Z17e1000_int_handlerv+0x2f>
 100201e:	83 08 40             	orl    $0x40,(%rax)
 1002021:	ff 15 e9 6b 00 00    	call   *0x6be9(%rip)        # 1008c10 <_ZL7link_fn>
 1002027:	40 f6 c5 40          	test   $0x40,%bpl
 100202b:	0f 84 7f 02 00 00    	je     10022b0 <_Z17e1000_int_handlerv+0x2b8>
 1002031:	b0 52                	mov    $0x52,%al
 1002033:	48 c7 c3 fb ff ff ff 	mov    $0xfffffffffffffffb,%rbx
 100203a:	0f be f0             	movsbl %al,%esi
 100203d:	bf 00 00 11 00       	mov    $0x110000,%edi
 1002042:	e8 0b 1b 00 00       	call   1003b52 <_ZN7console7putcharEc>
 1002047:	8a 83 cc 88 00 01    	mov    0x10088cc(%rbx),%al
 100204d:	48 ff c3             	inc    %rbx
 1002050:	75 e8                	jne    100203a <_Z17e1000_int_handlerv+0x42>
 1002052:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
 1002057:	48 c7 06 44 83 00 01 	movq   $0x1008344,(%rsi)
 100205e:	c7 46 08 0e 00 00 00 	movl   $0xe,0x8(%rsi)
 1002065:	48 8b 05 94 6b 00 00 	mov    0x6b94(%rip),%rax        # 1008c00 <e1000_dev>
 100206c:	48 8b 00             	mov    (%rax),%rax
 100206f:	8b 90 00 01 00 00    	mov    0x100(%rax),%edx
 1002075:	48 8d 5c 24 08       	lea    0x8(%rsp),%rbx
 100207a:	48 89 df             	mov    %rbx,%rdi
 100207d:	31 c0                	xor    %eax,%eax
 100207f:	e8 45 f1 ff ff       	call   10011c9 <_Z6format8rostringz>
 1002084:	48 89 df             	mov    %rbx,%rdi
 1002087:	e8 f4 f7 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 100208c:	48 89 c3             	mov    %rax,%rbx
 100208f:	8a 00                	mov    (%rax),%al
 1002091:	84 c0                	test   %al,%al
 1002093:	74 19                	je     10020ae <_Z17e1000_int_handlerv+0xb6>
 1002095:	48 ff c3             	inc    %rbx
 1002098:	0f be f0             	movsbl %al,%esi
 100209b:	bf 00 00 11 00       	mov    $0x110000,%edi
 10020a0:	e8 ad 1a 00 00       	call   1003b52 <_ZN7console7putcharEc>
 10020a5:	8a 03                	mov    (%rbx),%al
 10020a7:	48 ff c3             	inc    %rbx
 10020aa:	84 c0                	test   %al,%al
 10020ac:	75 ea                	jne    1002098 <_Z17e1000_int_handlerv+0xa0>
 10020ae:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10020b3:	48 85 c0             	test   %rax,%rax
 10020b6:	74 2e                	je     10020e6 <_Z17e1000_int_handlerv+0xee>
 10020b8:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10020bc:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10020c0:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10020c7:	00 04 
 10020c9:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 10020ce:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10020d5:	04 
 10020d6:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10020dd:	04 
 10020de:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10020e5:	00 
 10020e6:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
 10020eb:	48 c7 06 75 85 00 01 	movq   $0x1008575,(%rsi)
 10020f2:	c7 46 08 13 00 00 00 	movl   $0x13,0x8(%rsi)
 10020f9:	48 8b 05 00 6b 00 00 	mov    0x6b00(%rip),%rax        # 1008c00 <e1000_dev>
 1002100:	48 8b 00             	mov    (%rax),%rax
 1002103:	8b 90 10 24 00 00    	mov    0x2410(%rax),%edx
 1002109:	8b 88 18 24 00 00    	mov    0x2418(%rax),%ecx
 100210f:	48 8d 5c 24 08       	lea    0x8(%rsp),%rbx
 1002114:	48 89 df             	mov    %rbx,%rdi
 1002117:	31 c0                	xor    %eax,%eax
 1002119:	e8 ab f0 ff ff       	call   10011c9 <_Z6format8rostringz>
 100211e:	48 89 df             	mov    %rbx,%rdi
 1002121:	e8 5a f7 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1002126:	48 89 c3             	mov    %rax,%rbx
 1002129:	8a 00                	mov    (%rax),%al
 100212b:	84 c0                	test   %al,%al
 100212d:	74 19                	je     1002148 <_Z17e1000_int_handlerv+0x150>
 100212f:	48 ff c3             	inc    %rbx
 1002132:	0f be f0             	movsbl %al,%esi
 1002135:	bf 00 00 11 00       	mov    $0x110000,%edi
 100213a:	e8 13 1a 00 00       	call   1003b52 <_ZN7console7putcharEc>
 100213f:	8a 03                	mov    (%rbx),%al
 1002141:	48 ff c3             	inc    %rbx
 1002144:	84 c0                	test   %al,%al
 1002146:	75 ea                	jne    1002132 <_Z17e1000_int_handlerv+0x13a>
 1002148:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 100214d:	48 85 c0             	test   %rax,%rax
 1002150:	74 2e                	je     1002180 <_Z17e1000_int_handlerv+0x188>
 1002152:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1002156:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 100215a:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1002161:	00 04 
 1002163:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1002168:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 100216f:	04 
 1002170:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1002177:	04 
 1002178:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 100217f:	00 
 1002180:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
 1002185:	48 c7 06 c9 83 00 01 	movq   $0x10083c9,(%rsi)
 100218c:	c7 46 08 13 00 00 00 	movl   $0x13,0x8(%rsi)
 1002193:	48 8b 05 66 6a 00 00 	mov    0x6a66(%rip),%rax        # 1008c00 <e1000_dev>
 100219a:	48 8b 00             	mov    (%rax),%rax
 100219d:	8b 90 10 28 00 00    	mov    0x2810(%rax),%edx
 10021a3:	8b 88 18 28 00 00    	mov    0x2818(%rax),%ecx
 10021a9:	48 8d 5c 24 08       	lea    0x8(%rsp),%rbx
 10021ae:	48 89 df             	mov    %rbx,%rdi
 10021b1:	31 c0                	xor    %eax,%eax
 10021b3:	e8 11 f0 ff ff       	call   10011c9 <_Z6format8rostringz>
 10021b8:	48 89 df             	mov    %rbx,%rdi
 10021bb:	e8 c0 f6 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 10021c0:	48 89 c3             	mov    %rax,%rbx
 10021c3:	8a 00                	mov    (%rax),%al
 10021c5:	84 c0                	test   %al,%al
 10021c7:	74 19                	je     10021e2 <_Z17e1000_int_handlerv+0x1ea>
 10021c9:	48 ff c3             	inc    %rbx
 10021cc:	0f be f0             	movsbl %al,%esi
 10021cf:	bf 00 00 11 00       	mov    $0x110000,%edi
 10021d4:	e8 79 19 00 00       	call   1003b52 <_ZN7console7putcharEc>
 10021d9:	8a 03                	mov    (%rbx),%al
 10021db:	48 ff c3             	inc    %rbx
 10021de:	84 c0                	test   %al,%al
 10021e0:	75 ea                	jne    10021cc <_Z17e1000_int_handlerv+0x1d4>
 10021e2:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10021e7:	48 85 c0             	test   %rax,%rax
 10021ea:	74 2e                	je     100221a <_Z17e1000_int_handlerv+0x222>
 10021ec:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10021f0:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10021f4:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10021fb:	00 04 
 10021fd:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1002202:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1002209:	04 
 100220a:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1002211:	04 
 1002212:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1002219:	00 
 100221a:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
 100221f:	48 c7 06 e1 85 00 01 	movq   $0x10085e1,(%rsi)
 1002226:	c7 46 08 1d 00 00 00 	movl   $0x1d,0x8(%rsi)
 100222d:	48 8b 05 cc 69 00 00 	mov    0x69cc(%rip),%rax        # 1008c00 <e1000_dev>
 1002234:	48 8b 40 10          	mov    0x10(%rax),%rax
 1002238:	48 8b 10             	mov    (%rax),%rdx
 100223b:	0f b6 48 0c          	movzbl 0xc(%rax),%ecx
 100223f:	48 8d 5c 24 08       	lea    0x8(%rsp),%rbx
 1002244:	48 89 df             	mov    %rbx,%rdi
 1002247:	31 c0                	xor    %eax,%eax
 1002249:	e8 7b ef ff ff       	call   10011c9 <_Z6format8rostringz>
 100224e:	48 89 df             	mov    %rbx,%rdi
 1002251:	e8 2a f6 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1002256:	48 89 c3             	mov    %rax,%rbx
 1002259:	8a 00                	mov    (%rax),%al
 100225b:	84 c0                	test   %al,%al
 100225d:	74 19                	je     1002278 <_Z17e1000_int_handlerv+0x280>
 100225f:	48 ff c3             	inc    %rbx
 1002262:	0f be f0             	movsbl %al,%esi
 1002265:	bf 00 00 11 00       	mov    $0x110000,%edi
 100226a:	e8 e3 18 00 00       	call   1003b52 <_ZN7console7putcharEc>
 100226f:	8a 03                	mov    (%rbx),%al
 1002271:	48 ff c3             	inc    %rbx
 1002274:	84 c0                	test   %al,%al
 1002276:	75 ea                	jne    1002262 <_Z17e1000_int_handlerv+0x26a>
 1002278:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 100227d:	48 85 c0             	test   %rax,%rax
 1002280:	74 2e                	je     10022b0 <_Z17e1000_int_handlerv+0x2b8>
 1002282:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1002286:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 100228a:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1002291:	00 04 
 1002293:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1002298:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 100229f:	04 
 10022a0:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10022a7:	04 
 10022a8:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10022af:	00 
 10022b0:	40 84 ed             	test   %bpl,%bpl
 10022b3:	79 05                	jns    10022ba <_Z17e1000_int_handlerv+0x2c2>
 10022b5:	e8 1c 00 00 00       	call   10022d6 <_Z13e1000_receivev>
 10022ba:	48 83 c4 58          	add    $0x58,%rsp
 10022be:	5b                   	pop    %rbx
 10022bf:	5d                   	pop    %rbp
 10022c0:	c3                   	ret    

00000000010022c1 <_Z12e1000_enablev>:
 10022c1:	48 8b 05 38 69 00 00 	mov    0x6938(%rip),%rax        # 1008c00 <e1000_dev>
 10022c8:	48 8b 00             	mov    (%rax),%rax
 10022cb:	c7 80 d0 00 00 00 fb 	movl   $0xfb,0xd0(%rax)
 10022d2:	00 00 00 
 10022d5:	c3                   	ret    

00000000010022d6 <_Z13e1000_receivev>:
 10022d6:	50                   	push   %rax
 10022d7:	48 8b 0d 22 69 00 00 	mov    0x6922(%rip),%rcx        # 1008c00 <e1000_dev>
 10022de:	48 8b 41 10          	mov    0x10(%rcx),%rax
 10022e2:	0f b7 49 20          	movzwl 0x20(%rcx),%ecx
 10022e6:	48 89 ca             	mov    %rcx,%rdx
 10022e9:	48 c1 e2 04          	shl    $0x4,%rdx
 10022ed:	f6 44 10 0c 01       	testb  $0x1,0xc(%rax,%rdx,1)
 10022f2:	74 43                	je     1002337 <_Z13e1000_receivev+0x61>
 10022f4:	48 c1 e1 04          	shl    $0x4,%rcx
 10022f8:	48 8b 3c 08          	mov    (%rax,%rcx,1),%rdi
 10022fc:	0f b7 74 08 08       	movzwl 0x8(%rax,%rcx,1),%esi
 1002301:	ff 15 01 69 00 00    	call   *0x6901(%rip)        # 1008c08 <_ZL10receive_fn>
 1002307:	48 8b 15 f2 68 00 00 	mov    0x68f2(%rip),%rdx        # 1008c00 <e1000_dev>
 100230e:	48 8b 42 10          	mov    0x10(%rdx),%rax
 1002312:	0f b7 72 20          	movzwl 0x20(%rdx),%esi
 1002316:	48 89 f1             	mov    %rsi,%rcx
 1002319:	48 c1 e1 04          	shl    $0x4,%rcx
 100231d:	c6 44 08 0c 00       	movb   $0x0,0xc(%rax,%rcx,1)
 1002322:	8d 4e 01             	lea    0x1(%rsi),%ecx
 1002325:	83 e1 07             	and    $0x7,%ecx
 1002328:	66 89 4a 20          	mov    %cx,0x20(%rdx)
 100232c:	48 8b 12             	mov    (%rdx),%rdx
 100232f:	89 b2 18 28 00 00    	mov    %esi,0x2818(%rdx)
 1002335:	eb af                	jmp    10022e6 <_Z13e1000_receivev+0x10>
 1002337:	58                   	pop    %rax
 1002338:	c3                   	ret    

0000000001002339 <_Z10e1000_sendPvt>:
 1002339:	48 8b 05 c0 68 00 00 	mov    0x68c0(%rip),%rax        # 1008c00 <e1000_dev>
 1002340:	48 8b 48 18          	mov    0x18(%rax),%rcx
 1002344:	0f b7 50 22          	movzwl 0x22(%rax),%edx
 1002348:	44 8d 42 01          	lea    0x1(%rdx),%r8d
 100234c:	44 0f b6 ca          	movzbl %dl,%r9d
 1002350:	48 c1 e2 04          	shl    $0x4,%rdx
 1002354:	66 89 74 11 08       	mov    %si,0x8(%rcx,%rdx,1)
 1002359:	48 89 3c 11          	mov    %rdi,(%rcx,%rdx,1)
 100235d:	c6 44 11 0b 0b       	movb   $0xb,0xb(%rcx,%rdx,1)
 1002362:	c6 44 11 0c 00       	movb   $0x0,0xc(%rcx,%rdx,1)
 1002367:	41 83 e0 07          	and    $0x7,%r8d
 100236b:	66 44 89 40 22       	mov    %r8w,0x22(%rax)
 1002370:	48 8b 00             	mov    (%rax),%rax
 1002373:	44 89 80 18 38 00 00 	mov    %r8d,0x3818(%rax)
 100237a:	49 c1 e1 04          	shl    $0x4,%r9
 100237e:	4a 8d 04 09          	lea    (%rcx,%r9,1),%rax
 1002382:	48 83 c0 0c          	add    $0xc,%rax
 1002386:	f6 00 01             	testb  $0x1,(%rax)
 1002389:	74 fb                	je     1002386 <_Z10e1000_sendPvt+0x4d>
 100238b:	c3                   	ret    

000000000100238c <_Z12keyboard_irqv>:
 100238c:	e4 64                	in     $0x64,%al
 100238e:	a8 01                	test   $0x1,%al
 1002390:	74 18                	je     10023aa <_Z12keyboard_irqv+0x1e>
 1002392:	e4 60                	in     $0x60,%al
 1002394:	0f b6 0d 81 68 00 00 	movzbl 0x6881(%rip),%ecx        # 1008c1c <keyboardInput+0x4>
 100239b:	88 81 1e 8c 00 01    	mov    %al,0x1008c1e(%rcx)
 10023a1:	8d 41 01             	lea    0x1(%rcx),%eax
 10023a4:	88 05 72 68 00 00    	mov    %al,0x6872(%rip)        # 1008c1c <keyboardInput+0x4>
 10023aa:	c3                   	ret    

00000000010023ab <_Z16update_modifiersh>:
 10023ab:	81 ff e0 00 00 00    	cmp    $0xe0,%edi
 10023b1:	75 0a                	jne    10023bd <_Z16update_modifiersh+0x12>
 10023b3:	c6 05 61 68 00 00 01 	movb   $0x1,0x6861(%rip)        # 1008c1b <keyboardInput+0x3>
 10023ba:	b0 01                	mov    $0x1,%al
 10023bc:	c3                   	ret    
 10023bd:	80 3d 57 68 00 00 00 	cmpb   $0x0,0x6857(%rip)        # 1008c1b <keyboardInput+0x3>
 10023c4:	74 0f                	je     10023d5 <_Z16update_modifiersh+0x2a>
 10023c6:	c6 05 4e 68 00 00 00 	movb   $0x0,0x684e(%rip)        # 1008c1b <keyboardInput+0x3>
 10023cd:	b0 01                	mov    $0x1,%al
 10023cf:	40 80 ff 2a          	cmp    $0x2a,%dil
 10023d3:	74 e7                	je     10023bc <_Z16update_modifiersh+0x11>
 10023d5:	89 f8                	mov    %edi,%eax
 10023d7:	24 7f                	and    $0x7f,%al
 10023d9:	3c 1d                	cmp    $0x1d,%al
 10023db:	74 1d                	je     10023fa <_Z16update_modifiersh+0x4f>
 10023dd:	0f b6 c0             	movzbl %al,%eax
 10023e0:	83 f8 38             	cmp    $0x38,%eax
 10023e3:	74 25                	je     100240a <_Z16update_modifiersh+0x5f>
 10023e5:	83 f8 2a             	cmp    $0x2a,%eax
 10023e8:	75 30                	jne    100241a <_Z16update_modifiersh+0x6f>
 10023ea:	40 f6 d7             	not    %dil
 10023ed:	40 c0 ef 07          	shr    $0x7,%dil
 10023f1:	40 88 3d 20 68 00 00 	mov    %dil,0x6820(%rip)        # 1008c18 <keyboardInput>
 10023f8:	eb c0                	jmp    10023ba <_Z16update_modifiersh+0xf>
 10023fa:	40 f6 d7             	not    %dil
 10023fd:	40 c0 ef 07          	shr    $0x7,%dil
 1002401:	40 88 3d 11 68 00 00 	mov    %dil,0x6811(%rip)        # 1008c19 <keyboardInput+0x1>
 1002408:	eb b0                	jmp    10023ba <_Z16update_modifiersh+0xf>
 100240a:	40 f6 d7             	not    %dil
 100240d:	40 c0 ef 07          	shr    $0x7,%dil
 1002411:	40 88 3d 02 68 00 00 	mov    %dil,0x6802(%rip)        # 1008c1a <keyboardInput+0x2>
 1002418:	eb a0                	jmp    10023ba <_Z16update_modifiersh+0xf>
 100241a:	31 c0                	xor    %eax,%eax
 100241c:	c3                   	ret    

000000000100241d <_Z10pci_create8pci_addr>:
 100241d:	89 f1                	mov    %esi,%ecx
 100241f:	81 e1 00 00 ff 00    	and    $0xff0000,%ecx
 1002425:	66 89 37             	mov    %si,(%rdi)
 1002428:	89 f0                	mov    %esi,%eax
 100242a:	c1 e8 10             	shr    $0x10,%eax
 100242d:	88 47 02             	mov    %al,0x2(%rdi)
 1002430:	89 f0                	mov    %esi,%eax
 1002432:	c1 e0 10             	shl    $0x10,%eax
 1002435:	c1 e6 03             	shl    $0x3,%esi
 1002438:	81 e6 00 f8 07 00    	and    $0x7f800,%esi
 100243e:	09 c6                	or     %eax,%esi
 1002440:	c1 e9 08             	shr    $0x8,%ecx
 1002443:	09 f1                	or     %esi,%ecx
 1002445:	81 e1 00 ff ff 00    	and    $0xffff00,%ecx
 100244b:	8d 81 00 00 00 80    	lea    -0x80000000(%rcx),%eax
 1002451:	66 ba f8 0c          	mov    $0xcf8,%dx
 1002455:	ef                   	out    %eax,(%dx)
 1002456:	66 ba fc 0c          	mov    $0xcfc,%dx
 100245a:	ed                   	in     (%dx),%eax
 100245b:	89 47 04             	mov    %eax,0x4(%rdi)
 100245e:	8d 81 08 00 00 80    	lea    -0x7ffffff8(%rcx),%eax
 1002464:	66 ba f8 0c          	mov    $0xcf8,%dx
 1002468:	ef                   	out    %eax,(%dx)
 1002469:	66 ba fc 0c          	mov    $0xcfc,%dx
 100246d:	ed                   	in     (%dx),%eax
 100246e:	89 47 08             	mov    %eax,0x8(%rdi)
 1002471:	8d 81 0c 00 00 80    	lea    -0x7ffffff4(%rcx),%eax
 1002477:	66 ba f8 0c          	mov    $0xcf8,%dx
 100247b:	ef                   	out    %eax,(%dx)
 100247c:	66 ba fc 0c          	mov    $0xcfc,%dx
 1002480:	ed                   	in     (%dx),%eax
 1002481:	89 47 0c             	mov    %eax,0xc(%rdi)
 1002484:	be 10 00 00 00       	mov    $0x10,%esi
 1002489:	89 f0                	mov    %esi,%eax
 100248b:	09 c8                	or     %ecx,%eax
 100248d:	0d 00 00 00 80       	or     $0x80000000,%eax
 1002492:	66 ba f8 0c          	mov    $0xcf8,%dx
 1002496:	ef                   	out    %eax,(%dx)
 1002497:	66 ba fc 0c          	mov    $0xcfc,%dx
 100249b:	ed                   	in     (%dx),%eax
 100249c:	89 04 37             	mov    %eax,(%rdi,%rsi,1)
 100249f:	48 83 c6 04          	add    $0x4,%rsi
 10024a3:	48 83 fe 28          	cmp    $0x28,%rsi
 10024a7:	75 e0                	jne    1002489 <_Z10pci_create8pci_addr+0x6c>
 10024a9:	89 c8                	mov    %ecx,%eax
 10024ab:	0d 2c 00 00 80       	or     $0x8000002c,%eax
 10024b0:	66 ba f8 0c          	mov    $0xcf8,%dx
 10024b4:	ef                   	out    %eax,(%dx)
 10024b5:	66 ba fc 0c          	mov    $0xcfc,%dx
 10024b9:	ed                   	in     (%dx),%eax
 10024ba:	89 47 28             	mov    %eax,0x28(%rdi)
 10024bd:	81 c9 3c 00 00 80    	or     $0x8000003c,%ecx
 10024c3:	89 c8                	mov    %ecx,%eax
 10024c5:	66 ba f8 0c          	mov    $0xcf8,%dx
 10024c9:	ef                   	out    %eax,(%dx)
 10024ca:	66 ba fc 0c          	mov    $0xcfc,%dx
 10024ce:	ed                   	in     (%dx),%eax
 10024cf:	66 89 47 2c          	mov    %ax,0x2c(%rdi)
 10024d3:	48 89 f8             	mov    %rdi,%rax
 10024d6:	c3                   	ret    

00000000010024d7 <_Z8pci_initv>:
 10024d7:	55                   	push   %rbp
 10024d8:	41 57                	push   %r15
 10024da:	41 56                	push   %r14
 10024dc:	41 55                	push   %r13
 10024de:	41 54                	push   %r12
 10024e0:	53                   	push   %rbx
 10024e1:	48 83 ec 38          	sub    $0x38,%rsp
 10024e5:	48 8b 04 25 20 00 11 	mov    0x110020,%rax
 10024ec:	00 
 10024ed:	48 83 c0 0f          	add    $0xf,%rax
 10024f1:	48 83 e0 f0          	and    $0xfffffffffffffff0,%rax
 10024f5:	48 8d 88 04 18 00 00 	lea    0x1804(%rax),%rcx
 10024fc:	48 89 0c 25 20 00 11 	mov    %rcx,0x110020
 1002503:	00 
 1002504:	48 89 05 15 68 00 00 	mov    %rax,0x6815(%rip)        # 1008d20 <pci_dev>
 100250b:	31 ed                	xor    %ebp,%ebp
 100250d:	31 c9                	xor    %ecx,%ecx
 100250f:	44 0f b7 f9          	movzwl %cx,%r15d
 1002513:	c1 e1 10             	shl    $0x10,%ecx
 1002516:	45 31 e4             	xor    %r12d,%r12d
 1002519:	89 4c 24 04          	mov    %ecx,0x4(%rsp)
 100251d:	45 0f b6 f4          	movzbl %r12b,%r14d
 1002521:	45 89 f5             	mov    %r14d,%r13d
 1002524:	41 c1 e5 0b          	shl    $0xb,%r13d
 1002528:	41 09 cd             	or     %ecx,%r13d
 100252b:	44 89 e8             	mov    %r13d,%eax
 100252e:	25 ff ff ff 00       	and    $0xffffff,%eax
 1002533:	0d 00 00 00 80       	or     $0x80000000,%eax
 1002538:	66 ba f8 0c          	mov    $0xcf8,%dx
 100253c:	ef                   	out    %eax,(%dx)
 100253d:	66 ba fc 0c          	mov    $0xcfc,%dx
 1002541:	ed                   	in     (%dx),%eax
 1002542:	83 f8 ff             	cmp    $0xffffffff,%eax
 1002545:	0f 84 b7 00 00 00    	je     1002602 <_Z8pci_initv+0x12b>
 100254b:	41 c1 e6 08          	shl    $0x8,%r14d
 100254f:	44 89 f6             	mov    %r14d,%esi
 1002552:	44 09 fe             	or     %r15d,%esi
 1002555:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
 100255a:	c5 f8 77             	vzeroupper 
 100255d:	e8 bb fe ff ff       	call   100241d <_Z10pci_create8pci_addr>
 1002562:	48 8b 05 b7 67 00 00 	mov    0x67b7(%rip),%rax        # 1008d20 <pci_dev>
 1002569:	48 63 cd             	movslq %ebp,%rcx
 100256c:	ff c5                	inc    %ebp
 100256e:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 1002572:	48 c1 e1 04          	shl    $0x4,%rcx
 1002576:	c5 fc 10 44 24 08    	vmovups 0x8(%rsp),%ymm0
 100257c:	c5 fc 10 4c 24 18    	vmovups 0x18(%rsp),%ymm1
 1002582:	c5 fc 11 4c 08 10    	vmovups %ymm1,0x10(%rax,%rcx,1)
 1002588:	c5 fc 11 04 08       	vmovups %ymm0,(%rax,%rcx,1)
 100258d:	80 7c 08 0e 00       	cmpb   $0x0,0xe(%rax,%rcx,1)
 1002592:	79 6e                	jns    1002602 <_Z8pci_initv+0x12b>
 1002594:	b3 01                	mov    $0x1,%bl
 1002596:	0f b6 f3             	movzbl %bl,%esi
 1002599:	89 f0                	mov    %esi,%eax
 100259b:	c1 e0 08             	shl    $0x8,%eax
 100259e:	44 09 e8             	or     %r13d,%eax
 10025a1:	25 ff ff ff 00       	and    $0xffffff,%eax
 10025a6:	0d 00 00 00 80       	or     $0x80000000,%eax
 10025ab:	66 ba f8 0c          	mov    $0xcf8,%dx
 10025af:	ef                   	out    %eax,(%dx)
 10025b0:	66 ba fc 0c          	mov    $0xcfc,%dx
 10025b4:	ed                   	in     (%dx),%eax
 10025b5:	83 f8 ff             	cmp    $0xffffffff,%eax
 10025b8:	74 41                	je     10025fb <_Z8pci_initv+0x124>
 10025ba:	c1 e6 10             	shl    $0x10,%esi
 10025bd:	44 09 f6             	or     %r14d,%esi
 10025c0:	44 09 fe             	or     %r15d,%esi
 10025c3:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
 10025c8:	c5 f8 77             	vzeroupper 
 10025cb:	e8 4d fe ff ff       	call   100241d <_Z10pci_create8pci_addr>
 10025d0:	48 8b 05 49 67 00 00 	mov    0x6749(%rip),%rax        # 1008d20 <pci_dev>
 10025d7:	48 63 cd             	movslq %ebp,%rcx
 10025da:	ff c5                	inc    %ebp
 10025dc:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
 10025e0:	48 c1 e1 04          	shl    $0x4,%rcx
 10025e4:	c5 fc 10 44 24 08    	vmovups 0x8(%rsp),%ymm0
 10025ea:	c5 fc 10 4c 24 18    	vmovups 0x18(%rsp),%ymm1
 10025f0:	c5 fc 11 4c 08 10    	vmovups %ymm1,0x10(%rax,%rcx,1)
 10025f6:	c5 fc 11 04 08       	vmovups %ymm0,(%rax,%rcx,1)
 10025fb:	fe c3                	inc    %bl
 10025fd:	80 fb 07             	cmp    $0x7,%bl
 1002600:	75 94                	jne    1002596 <_Z8pci_initv+0xbf>
 1002602:	41 fe c4             	inc    %r12b
 1002605:	41 80 fc 20          	cmp    $0x20,%r12b
 1002609:	8b 4c 24 04          	mov    0x4(%rsp),%ecx
 100260d:	0f 85 0a ff ff ff    	jne    100251d <_Z8pci_initv+0x46>
 1002613:	41 ff c7             	inc    %r15d
 1002616:	41 0f b7 c7          	movzwl %r15w,%eax
 100261a:	44 89 f9             	mov    %r15d,%ecx
 100261d:	3d 00 01 00 00       	cmp    $0x100,%eax
 1002622:	0f 85 e7 fe ff ff    	jne    100250f <_Z8pci_initv+0x38>
 1002628:	48 8b 05 f1 66 00 00 	mov    0x66f1(%rip),%rax        # 1008d20 <pci_dev>
 100262f:	89 a8 00 18 00 00    	mov    %ebp,0x1800(%rax)
 1002635:	48 83 c4 38          	add    $0x38,%rsp
 1002639:	5b                   	pop    %rbx
 100263a:	41 5c                	pop    %r12
 100263c:	41 5d                	pop    %r13
 100263e:	41 5e                	pop    %r14
 1002640:	41 5f                	pop    %r15
 1002642:	5d                   	pop    %rbp
 1002643:	c5 f8 77             	vzeroupper 
 1002646:	c3                   	ret    

0000000001002647 <_Z9pci_printv>:
 1002647:	55                   	push   %rbp
 1002648:	41 57                	push   %r15
 100264a:	41 56                	push   %r14
 100264c:	41 55                	push   %r13
 100264e:	41 54                	push   %r12
 1002650:	53                   	push   %rbx
 1002651:	48 83 ec 28          	sub    $0x28,%rsp
 1002655:	48 8b 05 c4 66 00 00 	mov    0x66c4(%rip),%rax        # 1008d20 <pci_dev>
 100265c:	83 b8 00 18 00 00 00 	cmpl   $0x0,0x1800(%rax)
 1002663:	0f 8e f3 00 00 00    	jle    100275c <_Z9pci_printv+0x115>
 1002669:	48 8d 5c 24 18       	lea    0x18(%rsp),%rbx
 100266e:	4c 8d 74 24 08       	lea    0x8(%rsp),%r14
 1002673:	45 31 e4             	xor    %r12d,%r12d
 1002676:	48 c7 44 24 08 b9 8a 	movq   $0x1008ab9,0x8(%rsp)
 100267d:	00 01 
 100267f:	c7 44 24 10 3b 00 00 	movl   $0x3b,0x10(%rsp)
 1002686:	00 
 1002687:	4b 8d 34 64          	lea    (%r12,%r12,2),%rsi
 100268b:	48 c1 e6 04          	shl    $0x4,%rsi
 100268f:	0f b6 14 30          	movzbl (%rax,%rsi,1),%edx
 1002693:	0f b6 4c 30 01       	movzbl 0x1(%rax,%rsi,1),%ecx
 1002698:	44 0f b6 44 30 02    	movzbl 0x2(%rax,%rsi,1),%r8d
 100269e:	44 0f b7 4c 30 06    	movzwl 0x6(%rax,%rsi,1),%r9d
 10026a4:	44 0f b7 54 30 04    	movzwl 0x4(%rax,%rsi,1),%r10d
 10026aa:	44 0f b6 5c 30 0b    	movzbl 0xb(%rax,%rsi,1),%r11d
 10026b0:	44 0f b6 7c 30 0a    	movzbl 0xa(%rax,%rsi,1),%r15d
 10026b6:	44 0f b6 6c 30 09    	movzbl 0x9(%rax,%rsi,1),%r13d
 10026bc:	0f b6 6c 30 08       	movzbl 0x8(%rax,%rsi,1),%ebp
 10026c1:	48 83 ec 08          	sub    $0x8,%rsp
 10026c5:	48 89 df             	mov    %rbx,%rdi
 10026c8:	4c 89 f6             	mov    %r14,%rsi
 10026cb:	31 c0                	xor    %eax,%eax
 10026cd:	55                   	push   %rbp
 10026ce:	41 55                	push   %r13
 10026d0:	41 57                	push   %r15
 10026d2:	41 53                	push   %r11
 10026d4:	41 52                	push   %r10
 10026d6:	e8 ee ea ff ff       	call   10011c9 <_Z6format8rostringz>
 10026db:	48 83 c4 30          	add    $0x30,%rsp
 10026df:	48 89 df             	mov    %rbx,%rdi
 10026e2:	e8 99 f1 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 10026e7:	49 89 c7             	mov    %rax,%r15
 10026ea:	8a 00                	mov    (%rax),%al
 10026ec:	84 c0                	test   %al,%al
 10026ee:	74 1a                	je     100270a <_Z9pci_printv+0xc3>
 10026f0:	49 ff c7             	inc    %r15
 10026f3:	0f be f0             	movsbl %al,%esi
 10026f6:	bf 00 00 11 00       	mov    $0x110000,%edi
 10026fb:	e8 52 14 00 00       	call   1003b52 <_ZN7console7putcharEc>
 1002700:	41 8a 07             	mov    (%r15),%al
 1002703:	49 ff c7             	inc    %r15
 1002706:	84 c0                	test   %al,%al
 1002708:	75 e9                	jne    10026f3 <_Z9pci_printv+0xac>
 100270a:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
 100270f:	48 85 c0             	test   %rax,%rax
 1002712:	74 2e                	je     1002742 <_Z9pci_printv+0xfb>
 1002714:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1002718:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 100271c:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1002723:	00 04 
 1002725:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 100272a:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1002731:	04 
 1002732:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1002739:	04 
 100273a:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1002741:	00 
 1002742:	49 ff c4             	inc    %r12
 1002745:	48 8b 05 d4 65 00 00 	mov    0x65d4(%rip),%rax        # 1008d20 <pci_dev>
 100274c:	48 63 88 00 18 00 00 	movslq 0x1800(%rax),%rcx
 1002753:	49 39 cc             	cmp    %rcx,%r12
 1002756:	0f 8c 1a ff ff ff    	jl     1002676 <_Z9pci_printv+0x2f>
 100275c:	48 83 c4 28          	add    $0x28,%rsp
 1002760:	5b                   	pop    %rbx
 1002761:	41 5c                	pop    %r12
 1002763:	41 5d                	pop    %r13
 1002765:	41 5e                	pop    %r14
 1002767:	41 5f                	pop    %r15
 1002769:	5d                   	pop    %rbp
 100276a:	c3                   	ret    

000000000100276b <_Z9pci_matchhhh>:
 100276b:	48 8b 05 ae 65 00 00 	mov    0x65ae(%rip),%rax        # 1008d20 <pci_dev>
 1002772:	8b 88 00 18 00 00    	mov    0x1800(%rax),%ecx
 1002778:	85 c9                	test   %ecx,%ecx
 100277a:	7e 43                	jle    10027bf <_Z9pci_matchhhh+0x54>
 100277c:	44 8a 48 0b          	mov    0xb(%rax),%r9b
 1002780:	41 38 f9             	cmp    %dil,%r9b
 1002783:	41 0f 94 c0          	sete   %r8b
 1002787:	40 80 fe ff          	cmp    $0xff,%sil
 100278b:	74 11                	je     100279e <_Z9pci_matchhhh+0x33>
 100278d:	41 30 f9             	xor    %dil,%r9b
 1002790:	44 8a 40 0a          	mov    0xa(%rax),%r8b
 1002794:	41 30 f0             	xor    %sil,%r8b
 1002797:	45 08 c8             	or     %r9b,%r8b
 100279a:	41 0f 94 c0          	sete   %r8b
 100279e:	80 fa ff             	cmp    $0xff,%dl
 10027a1:	74 0e                	je     10027b1 <_Z9pci_matchhhh+0x46>
 10027a3:	38 50 09             	cmp    %dl,0x9(%rax)
 10027a6:	41 0f 94 c1          	sete   %r9b
 10027aa:	45 84 c8             	test   %r9b,%r8b
 10027ad:	74 07                	je     10027b6 <_Z9pci_matchhhh+0x4b>
 10027af:	eb 10                	jmp    10027c1 <_Z9pci_matchhhh+0x56>
 10027b1:	45 84 c0             	test   %r8b,%r8b
 10027b4:	75 0b                	jne    10027c1 <_Z9pci_matchhhh+0x56>
 10027b6:	48 83 c0 30          	add    $0x30,%rax
 10027ba:	48 ff c9             	dec    %rcx
 10027bd:	75 bd                	jne    100277c <_Z9pci_matchhhh+0x11>
 10027bf:	31 c0                	xor    %eax,%eax
 10027c1:	c3                   	ret    

00000000010027c2 <_Z8fat_initP15partition_entryP9fat32_bpb>:
 10027c2:	0f b6 46 0d          	movzbl 0xd(%rsi),%eax
 10027c6:	66 89 05 5b 65 00 00 	mov    %ax,0x655b(%rip)        # 1008d28 <_ZL17sectorsPerCluster>
 10027cd:	0f b7 4e 0e          	movzwl 0xe(%rsi),%ecx
 10027d1:	0f b6 56 10          	movzbl 0x10(%rsi),%edx
 10027d5:	0f af 56 24          	imul   0x24(%rsi),%edx
 10027d9:	01 ca                	add    %ecx,%edx
 10027db:	8b 7f 08             	mov    0x8(%rdi),%edi
 10027de:	01 d7                	add    %edx,%edi
 10027e0:	89 3d 46 65 00 00    	mov    %edi,0x6546(%rip)        # 1008d2c <_ZL15firstClusterLBA>
 10027e6:	0f b7 7e 0b          	movzwl 0xb(%rsi),%edi
 10027ea:	0f af c7             	imul   %edi,%eax
 10027ed:	66 89 05 3c 65 00 00 	mov    %ax,0x653c(%rip)        # 1008d30 <_ZL15bytesPerCluster>
 10027f4:	0f af d7             	imul   %edi,%edx
 10027f7:	01 f2                	add    %esi,%edx
 10027f9:	89 15 35 65 00 00    	mov    %edx,0x6535(%rip)        # 1008d34 <_ZL16firstClusterAddr>
 10027ff:	0f af f9             	imul   %ecx,%edi
 1002802:	01 f7                	add    %esi,%edi
 1002804:	48 89 3d 2d 65 00 00 	mov    %rdi,0x652d(%rip)        # 1008d38 <_ZL8fatTable>
 100280b:	c3                   	ret    

000000000100280c <_Z16get_cluster_addrj>:
 100280c:	8d 4f fe             	lea    -0x2(%rdi),%ecx
 100280f:	0f b7 05 1a 65 00 00 	movzwl 0x651a(%rip),%eax        # 1008d30 <_ZL15bytesPerCluster>
 1002816:	0f af c1             	imul   %ecx,%eax
 1002819:	03 05 15 65 00 00    	add    0x6515(%rip),%eax        # 1008d34 <_ZL16firstClusterAddr>
 100281f:	c3                   	ret    

0000000001002820 <_Z18read_cluster_chainPvjj>:
 1002820:	85 d2                	test   %edx,%edx
 1002822:	0f 84 db 00 00 00    	je     1002903 <_Z18read_cluster_chainPvjj+0xe3>
 1002828:	41 57                	push   %r15
 100282a:	41 56                	push   %r14
 100282c:	41 54                	push   %r12
 100282e:	53                   	push   %rbx
 100282f:	48 83 ec 28          	sub    $0x28,%rsp
 1002833:	41 89 f7             	mov    %esi,%r15d
 1002836:	85 f6                	test   %esi,%esi
 1002838:	0f 84 ba 00 00 00    	je     10028f8 <_Z18read_cluster_chainPvjj+0xd8>
 100283e:	44 89 f8             	mov    %r15d,%eax
 1002841:	25 ff ff ff 0f       	and    $0xfffffff,%eax
 1002846:	3d f6 ff ff 0f       	cmp    $0xffffff6,%eax
 100284b:	0f 87 a7 00 00 00    	ja     10028f8 <_Z18read_cluster_chainPvjj+0xd8>
 1002851:	89 d3                	mov    %edx,%ebx
 1002853:	49 89 fe             	mov    %rdi,%r14
 1002856:	48 8b 05 db 64 00 00 	mov    0x64db(%rip),%rax        # 1008d38 <_ZL8fatTable>
 100285d:	45 31 e4             	xor    %r12d,%r12d
 1002860:	44 89 f9             	mov    %r15d,%ecx
 1002863:	89 ca                	mov    %ecx,%edx
 1002865:	8b 14 90             	mov    (%rax,%rdx,4),%edx
 1002868:	ff c1                	inc    %ecx
 100286a:	41 ff c4             	inc    %r12d
 100286d:	39 ca                	cmp    %ecx,%edx
 100286f:	89 d1                	mov    %edx,%ecx
 1002871:	74 f0                	je     1002863 <_Z18read_cluster_chainPvjj+0x43>
 1002873:	44 39 e3             	cmp    %r12d,%ebx
 1002876:	44 0f 42 e3          	cmovb  %ebx,%r12d
 100287a:	41 8d 7f fe          	lea    -0x2(%r15),%edi
 100287e:	0f b7 05 a3 64 00 00 	movzwl 0x64a3(%rip),%eax        # 1008d28 <_ZL17sectorsPerCluster>
 1002885:	0f af f8             	imul   %eax,%edi
 1002888:	03 3d 9e 64 00 00    	add    0x649e(%rip),%edi        # 1008d2c <_ZL15firstClusterLBA>
 100288e:	41 0f af c4          	imul   %r12d,%eax
 1002892:	48 8b 0c 25 c8 00 11 	mov    0x1100c8,%rcx
 1002899:	00 
 100289a:	48 8b 51 20          	mov    0x20(%rcx),%rdx
 100289e:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
 10028a3:	c5 fc 10 01          	vmovups (%rcx),%ymm0
 10028a7:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
 10028ac:	0f b7 f0             	movzwl %ax,%esi
 10028af:	4c 89 f2             	mov    %r14,%rdx
 10028b2:	c5 f8 77             	vzeroupper 
 10028b5:	e8 f5 ef ff ff       	call   10018af <_Z9ahci_read11ahci_devicemtPv>
 10028ba:	44 29 e3             	sub    %r12d,%ebx
 10028bd:	74 39                	je     10028f8 <_Z18read_cluster_chainPvjj+0xd8>
 10028bf:	48 8b 05 72 64 00 00 	mov    0x6472(%rip),%rax        # 1008d38 <_ZL8fatTable>
 10028c6:	43 8d 0c 27          	lea    (%r15,%r12,1),%ecx
 10028ca:	ff c9                	dec    %ecx
 10028cc:	44 8b 3c 88          	mov    (%rax,%rcx,4),%r15d
 10028d0:	45 85 ff             	test   %r15d,%r15d
 10028d3:	74 23                	je     10028f8 <_Z18read_cluster_chainPvjj+0xd8>
 10028d5:	0f b7 0d 54 64 00 00 	movzwl 0x6454(%rip),%ecx        # 1008d30 <_ZL15bytesPerCluster>
 10028dc:	44 0f af e1          	imul   %ecx,%r12d
 10028e0:	4d 01 e6             	add    %r12,%r14
 10028e3:	44 89 f9             	mov    %r15d,%ecx
 10028e6:	81 e1 ff ff ff 0f    	and    $0xfffffff,%ecx
 10028ec:	81 f9 f7 ff ff 0f    	cmp    $0xffffff7,%ecx
 10028f2:	0f 82 65 ff ff ff    	jb     100285d <_Z18read_cluster_chainPvjj+0x3d>
 10028f8:	48 83 c4 28          	add    $0x28,%rsp
 10028fc:	5b                   	pop    %rbx
 10028fd:	41 5c                	pop    %r12
 10028ff:	41 5e                	pop    %r14
 1002901:	41 5f                	pop    %r15
 1002903:	c3                   	ret    

0000000001002904 <_Z11create_file8fat_filePKchm>:
 1002904:	55                   	push   %rbp
 1002905:	41 57                	push   %r15
 1002907:	41 56                	push   %r14
 1002909:	41 55                	push   %r13
 100290b:	41 54                	push   %r12
 100290d:	53                   	push   %rbx
 100290e:	48 81 ec f8 01 00 00 	sub    $0x1f8,%rsp
 1002915:	41 89 d0             	mov    %edx,%r8d
 1002918:	44 0f b7 0d 10 64 00 	movzwl 0x6410(%rip),%r9d        # 1008d30 <_ZL15bytesPerCluster>
 100291f:	00 
 1002920:	4a 8d 04 09          	lea    (%rcx,%r9,1),%rax
 1002924:	48 ff c8             	dec    %rax
 1002927:	31 d2                	xor    %edx,%edx
 1002929:	4c 89 4c 24 c0       	mov    %r9,-0x40(%rsp)
 100292e:	49 f7 f1             	div    %r9
 1002931:	48 89 c2             	mov    %rax,%rdx
 1002934:	48 89 7c 24 c8       	mov    %rdi,-0x38(%rsp)
 1002939:	45 31 c9             	xor    %r9d,%r9d
 100293c:	bf f8 ff ff 0f       	mov    $0xffffff8,%edi
 1002941:	85 d2                	test   %edx,%edx
 1002943:	74 50                	je     1002995 <_Z11create_file8fat_filePKchm+0x91>
 1002945:	41 bb 03 00 00 00    	mov    $0x3,%r11d
 100294b:	4c 8b 15 e6 63 00 00 	mov    0x63e6(%rip),%r10        # 1008d38 <_ZL8fatTable>
 1002952:	31 c0                	xor    %eax,%eax
 1002954:	89 c3                	mov    %eax,%ebx
 1002956:	44 89 d8             	mov    %r11d,%eax
 1002959:	41 89 c3             	mov    %eax,%r11d
 100295c:	ff c0                	inc    %eax
 100295e:	43 83 3c 9a 00       	cmpl   $0x0,(%r10,%r11,4)
 1002963:	75 f4                	jne    1002959 <_Z11create_file8fat_filePKchm+0x55>
 1002965:	45 85 c9             	test   %r9d,%r9d
 1002968:	44 0f 44 c8          	cmove  %eax,%r9d
 100296c:	85 db                	test   %ebx,%ebx
 100296e:	74 07                	je     1002977 <_Z11create_file8fat_filePKchm+0x73>
 1002970:	41 89 db             	mov    %ebx,%r11d
 1002973:	43 89 04 9a          	mov    %eax,(%r10,%r11,4)
 1002977:	41 89 c3             	mov    %eax,%r11d
 100297a:	ff ca                	dec    %edx
 100297c:	75 d6                	jne    1002954 <_Z11create_file8fat_filePKchm+0x50>
 100297e:	85 c0                	test   %eax,%eax
 1002980:	74 13                	je     1002995 <_Z11create_file8fat_filePKchm+0x91>
 1002982:	48 8b 15 af 63 00 00 	mov    0x63af(%rip),%rdx        # 1008d38 <_ZL8fatTable>
 1002989:	89 c0                	mov    %eax,%eax
 100298b:	c7 04 82 f8 ff ff 0f 	movl   $0xffffff8,(%rdx,%rax,4)
 1002992:	44 89 cf             	mov    %r9d,%edi
 1002995:	48 b8 20 20 20 20 20 	movabs $0x2020202020202020,%rax
 100299c:	20 20 20 
 100299f:	48 89 44 24 80       	mov    %rax,-0x80(%rsp)
 10029a4:	66 c7 44 24 88 20 20 	movw   $0x2020,-0x78(%rsp)
 10029ab:	c6 44 24 8a 20       	movb   $0x20,-0x76(%rsp)
 10029b0:	44 88 44 24 8b       	mov    %r8b,-0x75(%rsp)
 10029b5:	66 c7 44 24 8c 00 00 	movw   $0x0,-0x74(%rsp)
 10029bc:	b8 01 00 21 00       	mov    $0x210001,%eax
 10029c1:	89 44 24 8e          	mov    %eax,-0x72(%rsp)
 10029c5:	66 c7 44 24 92 21 00 	movw   $0x21,-0x6e(%rsp)
 10029cc:	89 fa                	mov    %edi,%edx
 10029ce:	c1 ea 10             	shr    $0x10,%edx
 10029d1:	66 89 54 24 94       	mov    %dx,-0x6c(%rsp)
 10029d6:	89 44 24 96          	mov    %eax,-0x6a(%rsp)
 10029da:	66 89 7c 24 9a       	mov    %di,-0x66(%rsp)
 10029df:	89 4c 24 9c          	mov    %ecx,-0x64(%rsp)
 10029e3:	40 8a 3e             	mov    (%rsi),%dil
 10029e6:	31 d2                	xor    %edx,%edx
 10029e8:	40 80 ff 2e          	cmp    $0x2e,%dil
 10029ec:	74 48                	je     1002a36 <_Z11create_file8fat_filePKchm+0x132>
 10029ee:	31 d2                	xor    %edx,%edx
 10029f0:	40 84 ff             	test   %dil,%dil
 10029f3:	74 22                	je     1002a17 <_Z11create_file8fat_filePKchm+0x113>
 10029f5:	48 83 fa 05          	cmp    $0x5,%rdx
 10029f9:	77 1c                	ja     1002a17 <_Z11create_file8fat_filePKchm+0x113>
 10029fb:	48 8d 42 01          	lea    0x1(%rdx),%rax
 10029ff:	40 88 7c 14 80       	mov    %dil,-0x80(%rsp,%rdx,1)
 1002a04:	40 8a 7c 16 01       	mov    0x1(%rsi,%rdx,1),%dil
 1002a09:	48 89 c2             	mov    %rax,%rdx
 1002a0c:	40 80 ff 2e          	cmp    $0x2e,%dil
 1002a10:	75 de                	jne    10029f0 <_Z11create_file8fat_filePKchm+0xec>
 1002a12:	40 b7 2e             	mov    $0x2e,%dil
 1002a15:	89 c2                	mov    %eax,%edx
 1002a17:	83 fa 06             	cmp    $0x6,%edx
 1002a1a:	75 1a                	jne    1002a36 <_Z11create_file8fat_filePKchm+0x132>
 1002a1c:	ba 06 00 00 00       	mov    $0x6,%edx
 1002a21:	40 84 ff             	test   %dil,%dil
 1002a24:	74 10                	je     1002a36 <_Z11create_file8fat_filePKchm+0x132>
 1002a26:	40 0f b6 c7          	movzbl %dil,%eax
 1002a2a:	83 f8 2e             	cmp    $0x2e,%eax
 1002a2d:	74 07                	je     1002a36 <_Z11create_file8fat_filePKchm+0x132>
 1002a2f:	66 c7 44 24 86 7e 31 	movw   $0x317e,-0x7a(%rsp)
 1002a36:	89 d2                	mov    %edx,%edx
 1002a38:	0f b6 3c 16          	movzbl (%rsi,%rdx,1),%edi
 1002a3c:	85 ff                	test   %edi,%edi
 1002a3e:	74 0a                	je     1002a4a <_Z11create_file8fat_filePKchm+0x146>
 1002a40:	83 ff 2e             	cmp    $0x2e,%edi
 1002a43:	74 05                	je     1002a4a <_Z11create_file8fat_filePKchm+0x146>
 1002a45:	48 ff c2             	inc    %rdx
 1002a48:	eb ee                	jmp    1002a38 <_Z11create_file8fat_filePKchm+0x134>
 1002a4a:	40 80 ff 01          	cmp    $0x1,%dil
 1002a4e:	89 d0                	mov    %edx,%eax
 1002a50:	83 d8 ff             	sbb    $0xffffffff,%eax
 1002a53:	8a 04 06             	mov    (%rsi,%rax,1),%al
 1002a56:	84 c0                	test   %al,%al
 1002a58:	74 2a                	je     1002a84 <_Z11create_file8fat_filePKchm+0x180>
 1002a5a:	40 80 ff 01          	cmp    $0x1,%dil
 1002a5e:	49 89 f1             	mov    %rsi,%r9
 1002a61:	49 83 d9 ff          	sbb    $0xffffffffffffffff,%r9
 1002a65:	31 ff                	xor    %edi,%edi
 1002a67:	88 44 3c 88          	mov    %al,-0x78(%rsp,%rdi,1)
 1002a6b:	49 8d 04 39          	lea    (%r9,%rdi,1),%rax
 1002a6f:	8a 44 02 01          	mov    0x1(%rdx,%rax,1),%al
 1002a73:	84 c0                	test   %al,%al
 1002a75:	74 0d                	je     1002a84 <_Z11create_file8fat_filePKchm+0x180>
 1002a77:	4c 8d 47 01          	lea    0x1(%rdi),%r8
 1002a7b:	48 83 ff 02          	cmp    $0x2,%rdi
 1002a7f:	4c 89 c7             	mov    %r8,%rdi
 1002a82:	72 e3                	jb     1002a67 <_Z11create_file8fat_filePKchm+0x163>
 1002a84:	48 89 4c 24 a0       	mov    %rcx,-0x60(%rsp)
 1002a89:	31 c0                	xor    %eax,%eax
 1002a8b:	80 3c 06 00          	cmpb   $0x0,(%rsi,%rax,1)
 1002a8f:	48 8d 40 01          	lea    0x1(%rax),%rax
 1002a93:	75 f6                	jne    1002a8b <_Z11create_file8fat_filePKchm+0x187>
 1002a95:	48 8d 48 ff          	lea    -0x1(%rax),%rcx
 1002a99:	48 89 4c 24 b8       	mov    %rcx,-0x48(%rsp)
 1002a9e:	83 c0 0b             	add    $0xb,%eax
 1002aa1:	48 98                	cltq   
 1002aa3:	4c 69 c0 4f ec c4 4e 	imul   $0x4ec4ec4f,%rax,%r8
 1002aaa:	4c 89 c0             	mov    %r8,%rax
 1002aad:	48 c1 e8 3f          	shr    $0x3f,%rax
 1002ab1:	49 c1 f8 22          	sar    $0x22,%r8
 1002ab5:	41 01 c0             	add    %eax,%r8d
 1002ab8:	4d 63 d0             	movslq %r8d,%r10
 1002abb:	44 89 d0             	mov    %r10d,%eax
 1002abe:	c1 f8 1f             	sar    $0x1f,%eax
 1002ac1:	c4 c2 78 f2 c2       	andn   %r10d,%eax,%eax
 1002ac6:	48 89 44 24 d0       	mov    %rax,-0x30(%rsp)
 1002acb:	4c 89 d0             	mov    %r10,%rax
 1002ace:	48 c1 e0 05          	shl    $0x5,%rax
 1002ad2:	48 8d 4c 24 f0       	lea    -0x10(%rsp),%rcx
 1002ad7:	48 8d 1c 08          	lea    (%rax,%rcx,1),%rbx
 1002adb:	48 83 c3 e1          	add    $0xffffffffffffffe1,%rbx
 1002adf:	4c 8d 34 08          	lea    (%rax,%rcx,1),%r14
 1002ae3:	49 83 c6 ee          	add    $0xffffffffffffffee,%r14
 1002ae7:	45 31 ff             	xor    %r15d,%r15d
 1002aea:	31 ff                	xor    %edi,%edi
 1002aec:	4c 3b 7c 24 d0       	cmp    -0x30(%rsp),%r15
 1002af1:	0f 84 20 01 00 00    	je     1002c17 <_Z11create_file8fat_filePKchm+0x313>
 1002af7:	4c 89 f8             	mov    %r15,%rax
 1002afa:	48 f7 d0             	not    %rax
 1002afd:	4c 01 d0             	add    %r10,%rax
 1002b00:	48 89 c2             	mov    %rax,%rdx
 1002b03:	48 c1 e2 05          	shl    $0x5,%rdx
 1002b07:	66 c7 44 14 fb 0f 00 	movw   $0xf,-0x5(%rsp,%rdx,1)
 1002b0e:	49 ff c7             	inc    %r15
 1002b11:	48 85 c0             	test   %rax,%rax
 1002b14:	0f 94 c0             	sete   %al
 1002b17:	c0 e0 06             	shl    $0x6,%al
 1002b1a:	44 89 f9             	mov    %r15d,%ecx
 1002b1d:	08 c1                	or     %al,%cl
 1002b1f:	88 4c 14 f0          	mov    %cl,-0x10(%rsp,%rdx,1)
 1002b23:	31 c0                	xor    %eax,%eax
 1002b25:	31 c9                	xor    %ecx,%ecx
 1002b27:	d0 c9                	ror    %cl
 1002b29:	02 4c 04 80          	add    -0x80(%rsp,%rax,1),%cl
 1002b2d:	48 ff c0             	inc    %rax
 1002b30:	83 f8 0b             	cmp    $0xb,%eax
 1002b33:	75 f2                	jne    1002b27 <_Z11create_file8fat_filePKchm+0x223>
 1002b35:	88 4c 14 fd          	mov    %cl,-0x3(%rsp,%rdx,1)
 1002b39:	66 c7 44 14 0a 00 00 	movw   $0x0,0xa(%rsp,%rdx,1)
 1002b40:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
 1002b47:	48 89 44 14 f1       	mov    %rax,-0xf(%rsp,%rdx,1)
 1002b4c:	66 c7 44 14 f9 ff ff 	movw   $0xffff,-0x7(%rsp,%rdx,1)
 1002b53:	48 89 44 14 fe       	mov    %rax,-0x2(%rsp,%rdx,1)
 1002b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1002b5d:	89 44 14 06          	mov    %eax,0x6(%rsp,%rdx,1)
 1002b61:	89 44 14 0c          	mov    %eax,0xc(%rsp,%rdx,1)
 1002b65:	48 63 cf             	movslq %edi,%rcx
 1002b68:	48 8d 04 0e          	lea    (%rsi,%rcx,1),%rax
 1002b6c:	44 8d 59 01          	lea    0x1(%rcx),%r11d
 1002b70:	83 c1 02             	add    $0x2,%ecx
 1002b73:	45 31 e4             	xor    %r12d,%r12d
 1002b76:	45 89 d9             	mov    %r11d,%r9d
 1002b79:	41 89 cd             	mov    %ecx,%r13d
 1002b7c:	42 0f be 2c 20       	movsbl (%rax,%r12,1),%ebp
 1002b81:	66 42 89 2c 63       	mov    %bp,(%rbx,%r12,2)
 1002b86:	49 83 fc 03          	cmp    $0x3,%r12
 1002b8a:	77 12                	ja     1002b9e <_Z11create_file8fat_filePKchm+0x29a>
 1002b8c:	ff c7                	inc    %edi
 1002b8e:	49 ff c4             	inc    %r12
 1002b91:	45 8d 59 01          	lea    0x1(%r9),%r11d
 1002b95:	41 8d 4d 01          	lea    0x1(%r13),%ecx
 1002b99:	40 84 ed             	test   %bpl,%bpl
 1002b9c:	75 d8                	jne    1002b76 <_Z11create_file8fat_filePKchm+0x272>
 1002b9e:	40 84 ed             	test   %bpl,%bpl
 1002ba1:	74 74                	je     1002c17 <_Z11create_file8fat_filePKchm+0x313>
 1002ba3:	49 63 c1             	movslq %r9d,%rax
 1002ba6:	48 01 f0             	add    %rsi,%rax
 1002ba9:	45 31 e4             	xor    %r12d,%r12d
 1002bac:	44 89 ef             	mov    %r13d,%edi
 1002baf:	42 0f be 0c 20       	movsbl (%rax,%r12,1),%ecx
 1002bb4:	66 43 89 0c 66       	mov    %cx,(%r14,%r12,2)
 1002bb9:	49 83 fc 04          	cmp    $0x4,%r12
 1002bbd:	77 0e                	ja     1002bcd <_Z11create_file8fat_filePKchm+0x2c9>
 1002bbf:	49 ff c4             	inc    %r12
 1002bc2:	41 ff c1             	inc    %r9d
 1002bc5:	44 8d 6f 01          	lea    0x1(%rdi),%r13d
 1002bc9:	84 c9                	test   %cl,%cl
 1002bcb:	75 df                	jne    1002bac <_Z11create_file8fat_filePKchm+0x2a8>
 1002bcd:	84 c9                	test   %cl,%cl
 1002bcf:	74 46                	je     1002c17 <_Z11create_file8fat_filePKchm+0x313>
 1002bd1:	48 63 c7             	movslq %edi,%rax
 1002bd4:	48 01 f0             	add    %rsi,%rax
 1002bd7:	41 b4 01             	mov    $0x1,%r12b
 1002bda:	31 c9                	xor    %ecx,%ecx
 1002bdc:	44 0f be 08          	movsbl (%rax),%r9d
 1002be0:	4c 8d 1c 14          	lea    (%rsp,%rdx,1),%r11
 1002be4:	49 83 c3 f0          	add    $0xfffffffffffffff0,%r11
 1002be8:	66 45 89 4c 4b 1c    	mov    %r9w,0x1c(%r11,%rcx,2)
 1002bee:	ff c7                	inc    %edi
 1002bf0:	41 f6 c4 01          	test   $0x1,%r12b
 1002bf4:	74 10                	je     1002c06 <_Z11create_file8fat_filePKchm+0x302>
 1002bf6:	48 ff c0             	inc    %rax
 1002bf9:	b9 01 00 00 00       	mov    $0x1,%ecx
 1002bfe:	45 31 e4             	xor    %r12d,%r12d
 1002c01:	45 84 c9             	test   %r9b,%r9b
 1002c04:	75 d6                	jne    1002bdc <_Z11create_file8fat_filePKchm+0x2d8>
 1002c06:	48 83 c3 e0          	add    $0xffffffffffffffe0,%rbx
 1002c0a:	49 83 c6 e0          	add    $0xffffffffffffffe0,%r14
 1002c0e:	45 84 c9             	test   %r9b,%r9b
 1002c11:	0f 85 d5 fe ff ff    	jne    1002aec <_Z11create_file8fat_filePKchm+0x1e8>
 1002c17:	48 8d 84 24 30 02 00 	lea    0x230(%rsp),%rax
 1002c1e:	00 
 1002c1f:	48 8b 50 48          	mov    0x48(%rax),%rdx
 1002c23:	45 31 d2             	xor    %r10d,%r10d
 1002c26:	48 8b 5c 24 b8       	mov    -0x48(%rsp),%rbx
 1002c2b:	83 fb e8             	cmp    $0xffffffe8,%ebx
 1002c2e:	4c 8b 4c 24 c8       	mov    -0x38(%rsp),%r9
 1002c33:	4c 8b 5c 24 a0       	mov    -0x60(%rsp),%r11
 1002c38:	7c 62                	jl     1002c9c <_Z11create_file8fat_filePKchm+0x398>
 1002c3a:	31 c9                	xor    %ecx,%ecx
 1002c3c:	48 89 d7             	mov    %rdx,%rdi
 1002c3f:	31 c0                	xor    %eax,%eax
 1002c41:	45 31 d2             	xor    %r10d,%r10d
 1002c44:	41 ff c2             	inc    %r10d
 1002c47:	80 3f 00             	cmpb   $0x0,(%rdi)
 1002c4a:	44 0f 45 d1          	cmovne %ecx,%r10d
 1002c4e:	ff c8                	dec    %eax
 1002c50:	48 83 c7 20          	add    $0x20,%rdi
 1002c54:	45 39 c2             	cmp    %r8d,%r10d
 1002c57:	7e eb                	jle    1002c44 <_Z11create_file8fat_filePKchm+0x340>
 1002c59:	41 01 c2             	add    %eax,%r10d
 1002c5c:	85 db                	test   %ebx,%ebx
 1002c5e:	7e 39                	jle    1002c99 <_Z11create_file8fat_filePKchm+0x395>
 1002c60:	41 83 f8 02          	cmp    $0x2,%r8d
 1002c64:	b8 01 00 00 00       	mov    $0x1,%eax
 1002c69:	41 0f 4d c0          	cmovge %r8d,%eax
 1002c6d:	44 89 d1             	mov    %r10d,%ecx
 1002c70:	f7 d9                	neg    %ecx
 1002c72:	48 63 c9             	movslq %ecx,%rcx
 1002c75:	48 c1 e1 05          	shl    $0x5,%rcx
 1002c79:	48 01 d1             	add    %rdx,%rcx
 1002c7c:	48 c1 e0 05          	shl    $0x5,%rax
 1002c80:	31 ff                	xor    %edi,%edi
 1002c82:	c5 fc 10 44 3c f0    	vmovups -0x10(%rsp,%rdi,1),%ymm0
 1002c88:	c5 fc 11 04 39       	vmovups %ymm0,(%rcx,%rdi,1)
 1002c8d:	48 83 c7 20          	add    $0x20,%rdi
 1002c91:	41 ff ca             	dec    %r10d
 1002c94:	48 39 f8             	cmp    %rdi,%rax
 1002c97:	75 e9                	jne    1002c82 <_Z11create_file8fat_filePKchm+0x37e>
 1002c99:	41 f7 da             	neg    %r10d
 1002c9c:	49 63 c2             	movslq %r10d,%rax
 1002c9f:	48 c1 e0 05          	shl    $0x5,%rax
 1002ca3:	48 8d 3c 02          	lea    (%rdx,%rax,1),%rdi
 1002ca7:	c5 fe 6f 44 24 80    	vmovdqu -0x80(%rsp),%ymm0
 1002cad:	c5 fe 7f 04 02       	vmovdqu %ymm0,(%rdx,%rax,1)
 1002cb2:	8a 0e                	mov    (%rsi),%cl
 1002cb4:	4d 89 c8             	mov    %r9,%r8
 1002cb7:	84 c9                	test   %cl,%cl
 1002cb9:	74 15                	je     1002cd0 <_Z11create_file8fat_filePKchm+0x3cc>
 1002cbb:	48 ff c6             	inc    %rsi
 1002cbe:	4d 89 c8             	mov    %r9,%r8
 1002cc1:	41 88 08             	mov    %cl,(%r8)
 1002cc4:	49 ff c0             	inc    %r8
 1002cc7:	8a 0e                	mov    (%rsi),%cl
 1002cc9:	48 ff c6             	inc    %rsi
 1002ccc:	84 c9                	test   %cl,%cl
 1002cce:	75 f1                	jne    1002cc1 <_Z11create_file8fat_filePKchm+0x3bd>
 1002cd0:	41 c6 00 00          	movb   $0x0,(%r8)
 1002cd4:	49 89 79 40          	mov    %rdi,0x40(%r9)
 1002cd8:	0f b7 4c 02 14       	movzwl 0x14(%rdx,%rax,1),%ecx
 1002cdd:	c1 e1 10             	shl    $0x10,%ecx
 1002ce0:	0f b7 44 02 1a       	movzwl 0x1a(%rdx,%rax,1),%eax
 1002ce5:	8d 14 01             	lea    (%rcx,%rax,1),%edx
 1002ce8:	83 c2 fe             	add    $0xfffffffe,%edx
 1002ceb:	0f af 54 24 c0       	imul   -0x40(%rsp),%edx
 1002cf0:	03 15 3e 60 00 00    	add    0x603e(%rip),%edx        # 1008d34 <_ZL16firstClusterAddr>
 1002cf6:	49 89 51 48          	mov    %rdx,0x48(%r9)
 1002cfa:	4d 85 db             	test   %r11,%r11
 1002cfd:	0f 84 cb 07 00 00    	je     10034ce <_Z11create_file8fat_filePKchm+0xbca>
 1002d03:	49 8d 73 1f          	lea    0x1f(%r11),%rsi
 1002d07:	48 83 e6 e0          	and    $0xffffffffffffffe0,%rsi
 1002d0b:	49 ff cb             	dec    %r11
 1002d0e:	c4 c1 f9 6e c3       	vmovq  %r11,%xmm0
 1002d13:	c4 e2 7d 59 c0       	vpbroadcastq %xmm0,%ymm0
 1002d18:	c5 fd 6f 0d e0 54 00 	vmovdqa 0x54e0(%rip),%ymm1        # 1008200 <_ZL4lfsr+0xc0>
 1002d1f:	00 
 1002d20:	c5 fd 6f 15 78 54 00 	vmovdqa 0x5478(%rip),%ymm2        # 10081a0 <_ZL4lfsr+0x60>
 1002d27:	00 
 1002d28:	c5 fd 6f 1d 50 54 00 	vmovdqa 0x5450(%rip),%ymm3        # 1008180 <_ZL4lfsr+0x40>
 1002d2f:	00 
 1002d30:	c5 fd 6f 25 28 54 00 	vmovdqa 0x5428(%rip),%ymm4        # 1008160 <_ZL4lfsr+0x20>
 1002d37:	00 
 1002d38:	c5 fd 6f 2d 80 54 00 	vmovdqa 0x5480(%rip),%ymm5        # 10081c0 <_ZL4lfsr+0x80>
 1002d3f:	00 
 1002d40:	c5 fd 6f 35 f8 54 00 	vmovdqa 0x54f8(%rip),%ymm6        # 1008240 <_ZL4lfsr+0x100>
 1002d47:	00 
 1002d48:	c5 fd 6f 3d 10 55 00 	vmovdqa 0x5510(%rip),%ymm7        # 1008260 <_ZL4lfsr+0x120>
 1002d4f:	00 
 1002d50:	c5 7d 6f 05 88 54 00 	vmovdqa 0x5488(%rip),%ymm8        # 10081e0 <_ZL4lfsr+0xa0>
 1002d57:	00 
 1002d58:	31 c9                	xor    %ecx,%ecx
 1002d5a:	c4 62 79 59 0d 3d 55 	vpbroadcastq 0x553d(%rip),%xmm9        # 10082a0 <_ZL4lfsr+0x160>
 1002d61:	00 00 
 1002d63:	c4 41 29 76 d2       	vpcmpeqd %xmm10,%xmm10,%xmm10
 1002d68:	c4 62 7d 59 1d 2f 55 	vpbroadcastq 0x552f(%rip),%ymm11        # 10082a0 <_ZL4lfsr+0x160>
 1002d6f:	00 00 
 1002d71:	c4 62 79 58 25 2e 55 	vpbroadcastd 0x552e(%rip),%xmm12        # 10082a8 <_ZL4lfsr+0x168>
 1002d78:	00 00 
 1002d7a:	c5 7e 7f 64 24 d0    	vmovdqu %ymm12,-0x30(%rsp)
 1002d80:	c4 62 7d 59 35 ff 54 	vpbroadcastq 0x54ff(%rip),%ymm14        # 1008288 <_ZL4lfsr+0x148>
 1002d87:	00 00 
 1002d89:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1002d8d:	c4 41 39 ef e9       	vpxor  %xmm9,%xmm8,%xmm13
 1002d92:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1002d97:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002d9c:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1002da1:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002da6:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1002dab:	c5 79 7e e0          	vmovd  %xmm12,%eax
 1002daf:	a8 01                	test   $0x1,%al
 1002db1:	74 04                	je     1002db7 <_Z11create_file8fat_filePKchm+0x4b3>
 1002db3:	c6 04 0a 00          	movb   $0x0,(%rdx,%rcx,1)
 1002db7:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1002dbb:	c4 41 39 ef e9       	vpxor  %xmm9,%xmm8,%xmm13
 1002dc0:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1002dc5:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002dca:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1002dcf:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002dd4:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1002dd9:	c4 63 79 14 e0 01    	vpextrb $0x1,%xmm12,%eax
 1002ddf:	a8 01                	test   $0x1,%al
 1002de1:	74 05                	je     1002de8 <_Z11create_file8fat_filePKchm+0x4e4>
 1002de3:	c6 44 0a 01 00       	movb   $0x0,0x1(%rdx,%rcx,1)
 1002de8:	c5 25 ef f8          	vpxor  %ymm0,%ymm11,%ymm15
 1002dec:	c4 41 3d ef e3       	vpxor  %ymm11,%ymm8,%ymm12
 1002df1:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 1002df6:	c4 41 7f 70 e4 e8    	vpshuflw $0xe8,%ymm12,%ymm12
 1002dfc:	c5 1d ef 25 1c 54 00 	vpxor  0x541c(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 1002e03:	00 
 1002e04:	c5 7e 6f 6c 24 d0    	vmovdqu -0x30(%rsp),%ymm13
 1002e0a:	c4 42 15 36 e4       	vpermd %ymm12,%ymm13,%ymm12
 1002e0f:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002e14:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1002e19:	c4 63 79 14 e0 02    	vpextrb $0x2,%xmm12,%eax
 1002e1f:	a8 01                	test   $0x1,%al
 1002e21:	74 05                	je     1002e28 <_Z11create_file8fat_filePKchm+0x524>
 1002e23:	c6 44 0a 02 00       	movb   $0x0,0x2(%rdx,%rcx,1)
 1002e28:	c4 c3 7d 39 c4 01    	vextracti128 $0x1,%ymm0,%xmm12
 1002e2e:	c4 41 19 ef e1       	vpxor  %xmm9,%xmm12,%xmm12
 1002e33:	c4 43 7d 39 c5 01    	vextracti128 $0x1,%ymm8,%xmm13
 1002e39:	c4 41 11 ef e9       	vpxor  %xmm9,%xmm13,%xmm13
 1002e3e:	c5 79 7f 64 24 a0    	vmovdqa %xmm12,-0x60(%rsp)
 1002e44:	c4 42 11 37 ec       	vpcmpgtq %xmm12,%xmm13,%xmm13
 1002e49:	c4 41 11 6b ed       	vpackssdw %xmm13,%xmm13,%xmm13
 1002e4e:	c4 41 11 ef ea       	vpxor  %xmm10,%xmm13,%xmm13
 1002e53:	c4 41 11 6b ed       	vpackssdw %xmm13,%xmm13,%xmm13
 1002e58:	c4 41 11 63 ed       	vpacksswb %xmm13,%xmm13,%xmm13
 1002e5d:	c4 63 79 14 e8 03    	vpextrb $0x3,%xmm13,%eax
 1002e63:	a8 01                	test   $0x1,%al
 1002e65:	74 05                	je     1002e6c <_Z11create_file8fat_filePKchm+0x568>
 1002e67:	c6 44 0a 03 00       	movb   $0x0,0x3(%rdx,%rcx,1)
 1002e6c:	c5 31 ef e8          	vpxor  %xmm0,%xmm9,%xmm13
 1002e70:	c5 31 ef e7          	vpxor  %xmm7,%xmm9,%xmm12
 1002e74:	c4 42 19 37 e5       	vpcmpgtq %xmm13,%xmm12,%xmm12
 1002e79:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002e7e:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1002e83:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1002e89:	c5 1d 6b e0          	vpackssdw %ymm0,%ymm12,%ymm12
 1002e8d:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1002e93:	c4 42 79 79 e4       	vpbroadcastw %xmm12,%xmm12
 1002e98:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1002e9d:	c4 63 79 14 e0 04    	vpextrb $0x4,%xmm12,%eax
 1002ea3:	a8 01                	test   $0x1,%al
 1002ea5:	74 05                	je     1002eac <_Z11create_file8fat_filePKchm+0x5a8>
 1002ea7:	c6 44 0a 04 00       	movb   $0x0,0x4(%rdx,%rcx,1)
 1002eac:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1002eb0:	c5 31 ef ef          	vpxor  %xmm7,%xmm9,%xmm13
 1002eb4:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1002eb9:	c4 41 7a 70 e4 84    	vpshufhw $0x84,%xmm12,%xmm12
 1002ebf:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1002ec4:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1002eca:	c5 1d 6b e0          	vpackssdw %ymm0,%ymm12,%ymm12
 1002ece:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1002ed4:	c4 42 79 58 e4       	vpbroadcastd %xmm12,%xmm12
 1002ed9:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1002ede:	c4 63 79 14 e0 05    	vpextrb $0x5,%xmm12,%eax
 1002ee4:	a8 01                	test   $0x1,%al
 1002ee6:	74 05                	je     1002eed <_Z11create_file8fat_filePKchm+0x5e9>
 1002ee8:	c6 44 0a 05 00       	movb   $0x0,0x5(%rdx,%rcx,1)
 1002eed:	c5 25 ef e7          	vpxor  %ymm7,%ymm11,%ymm12
 1002ef1:	c4 42 1d 37 ef       	vpcmpgtq %ymm15,%ymm12,%ymm13
 1002ef6:	c4 41 7d 6b e5       	vpackssdw %ymm13,%ymm0,%ymm12
 1002efb:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1002f01:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1002f06:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002f0b:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1002f10:	c4 63 79 14 e0 06    	vpextrb $0x6,%xmm12,%eax
 1002f16:	a8 01                	test   $0x1,%al
 1002f18:	74 05                	je     1002f1f <_Z11create_file8fat_filePKchm+0x61b>
 1002f1a:	c6 44 0a 06 00       	movb   $0x0,0x6(%rdx,%rcx,1)
 1002f1f:	c4 41 7e 70 e5 84    	vpshufhw $0x84,%ymm13,%ymm12
 1002f25:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1002f2b:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1002f30:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002f35:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 1002f3a:	c4 63 79 14 e0 07    	vpextrb $0x7,%xmm12,%eax
 1002f40:	a8 01                	test   $0x1,%al
 1002f42:	74 05                	je     1002f49 <_Z11create_file8fat_filePKchm+0x645>
 1002f44:	c6 44 0a 07 00       	movb   $0x0,0x7(%rdx,%rcx,1)
 1002f49:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1002f4d:	c5 31 ef ee          	vpxor  %xmm6,%xmm9,%xmm13
 1002f51:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1002f56:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002f5b:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1002f60:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002f65:	c4 42 7d 33 e4       	vpmovzxwd %xmm12,%ymm12
 1002f6a:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1002f6e:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1002f74:	c5 79 7e e0          	vmovd  %xmm12,%eax
 1002f78:	a8 01                	test   $0x1,%al
 1002f7a:	74 05                	je     1002f81 <_Z11create_file8fat_filePKchm+0x67d>
 1002f7c:	c6 44 0a 08 00       	movb   $0x0,0x8(%rdx,%rcx,1)
 1002f81:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1002f85:	c5 31 ef ee          	vpxor  %xmm6,%xmm9,%xmm13
 1002f89:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1002f8e:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002f93:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1002f98:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002f9d:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1002fa3:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1002fa7:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1002fad:	c4 63 79 14 e0 01    	vpextrb $0x1,%xmm12,%eax
 1002fb3:	a8 01                	test   $0x1,%al
 1002fb5:	74 05                	je     1002fbc <_Z11create_file8fat_filePKchm+0x6b8>
 1002fb7:	c6 44 0a 09 00       	movb   $0x0,0x9(%rdx,%rcx,1)
 1002fbc:	c5 25 ef e6          	vpxor  %ymm6,%ymm11,%ymm12
 1002fc0:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 1002fc5:	c4 41 7f 70 e4 e8    	vpshuflw $0xe8,%ymm12,%ymm12
 1002fcb:	c5 1d ef 25 4d 52 00 	vpxor  0x524d(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 1002fd2:	00 
 1002fd3:	c5 7e 6f 6c 24 d0    	vmovdqu -0x30(%rsp),%ymm13
 1002fd9:	c4 42 15 36 e4       	vpermd %ymm12,%ymm13,%ymm12
 1002fde:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1002fe3:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1002fe9:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1002fed:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1002ff3:	c4 63 79 14 e0 02    	vpextrb $0x2,%xmm12,%eax
 1002ff9:	a8 01                	test   $0x1,%al
 1002ffb:	74 05                	je     1003002 <_Z11create_file8fat_filePKchm+0x6fe>
 1002ffd:	c6 44 0a 0a 00       	movb   $0x0,0xa(%rdx,%rcx,1)
 1003002:	c4 c3 7d 39 f4 01    	vextracti128 $0x1,%ymm6,%xmm12
 1003008:	c4 41 19 ef e1       	vpxor  %xmm9,%xmm12,%xmm12
 100300d:	c4 62 19 37 64 24 a0 	vpcmpgtq -0x60(%rsp),%xmm12,%xmm12
 1003014:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1003019:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 100301e:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1003023:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1003029:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 100302d:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1003033:	c4 63 79 14 e0 03    	vpextrb $0x3,%xmm12,%eax
 1003039:	a8 01                	test   $0x1,%al
 100303b:	74 05                	je     1003042 <_Z11create_file8fat_filePKchm+0x73e>
 100303d:	c6 44 0a 0b 00       	movb   $0x0,0xb(%rdx,%rcx,1)
 1003042:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1003046:	c5 31 ef ed          	vpxor  %xmm5,%xmm9,%xmm13
 100304a:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 100304f:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1003054:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1003059:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 100305f:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1003064:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1003068:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 100306e:	c4 63 79 14 e0 04    	vpextrb $0x4,%xmm12,%eax
 1003074:	a8 01                	test   $0x1,%al
 1003076:	74 05                	je     100307d <_Z11create_file8fat_filePKchm+0x779>
 1003078:	c6 44 0a 0c 00       	movb   $0x0,0xc(%rdx,%rcx,1)
 100307d:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1003081:	c5 31 ef ed          	vpxor  %xmm5,%xmm9,%xmm13
 1003085:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 100308a:	c4 41 7a 70 e4 84    	vpshufhw $0x84,%xmm12,%xmm12
 1003090:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1003095:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 100309b:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 10030a0:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 10030a4:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 10030aa:	c4 63 79 14 e0 05    	vpextrb $0x5,%xmm12,%eax
 10030b0:	a8 01                	test   $0x1,%al
 10030b2:	74 05                	je     10030b9 <_Z11create_file8fat_filePKchm+0x7b5>
 10030b4:	c6 44 0a 0d 00       	movb   $0x0,0xd(%rdx,%rcx,1)
 10030b9:	c5 25 ef e5          	vpxor  %ymm5,%ymm11,%ymm12
 10030bd:	c4 42 1d 37 ef       	vpcmpgtq %ymm15,%ymm12,%ymm13
 10030c2:	c4 41 7d 6b e5       	vpackssdw %ymm13,%ymm0,%ymm12
 10030c7:	c5 1d ef 25 51 51 00 	vpxor  0x5151(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 10030ce:	00 
 10030cf:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 10030d4:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 10030d8:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 10030de:	c4 63 79 14 e0 06    	vpextrb $0x6,%xmm12,%eax
 10030e4:	a8 01                	test   $0x1,%al
 10030e6:	74 05                	je     10030ed <_Z11create_file8fat_filePKchm+0x7e9>
 10030e8:	c6 44 0a 0e 00       	movb   $0x0,0xe(%rdx,%rcx,1)
 10030ed:	c4 41 7e 70 e5 84    	vpshufhw $0x84,%ymm13,%ymm12
 10030f3:	c5 1d ef 25 25 51 00 	vpxor  0x5125(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 10030fa:	00 
 10030fb:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1003100:	c5 1d 63 e0          	vpacksswb %ymm0,%ymm12,%ymm12
 1003104:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 100310a:	c4 63 79 14 e0 07    	vpextrb $0x7,%xmm12,%eax
 1003110:	a8 01                	test   $0x1,%al
 1003112:	74 05                	je     1003119 <_Z11create_file8fat_filePKchm+0x815>
 1003114:	c6 44 0a 0f 00       	movb   $0x0,0xf(%rdx,%rcx,1)
 1003119:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 100311d:	c5 31 ef ec          	vpxor  %xmm4,%xmm9,%xmm13
 1003121:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1003126:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 100312b:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1003130:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1003135:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 100313a:	c4 63 79 14 e0 08    	vpextrb $0x8,%xmm12,%eax
 1003140:	a8 01                	test   $0x1,%al
 1003142:	74 05                	je     1003149 <_Z11create_file8fat_filePKchm+0x845>
 1003144:	c6 44 0a 10 00       	movb   $0x0,0x10(%rdx,%rcx,1)
 1003149:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 100314d:	c5 31 ef ec          	vpxor  %xmm4,%xmm9,%xmm13
 1003151:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1003156:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 100315b:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1003160:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1003165:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 100316a:	c4 63 79 14 e0 09    	vpextrb $0x9,%xmm12,%eax
 1003170:	a8 01                	test   $0x1,%al
 1003172:	74 05                	je     1003179 <_Z11create_file8fat_filePKchm+0x875>
 1003174:	c6 44 0a 11 00       	movb   $0x0,0x11(%rdx,%rcx,1)
 1003179:	c5 25 ef e4          	vpxor  %ymm4,%ymm11,%ymm12
 100317d:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 1003182:	c4 41 7f 70 e4 e8    	vpshuflw $0xe8,%ymm12,%ymm12
 1003188:	c5 1d ef 25 90 50 00 	vpxor  0x5090(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 100318f:	00 
 1003190:	c5 7e 6f 6c 24 d0    	vmovdqu -0x30(%rsp),%ymm13
 1003196:	c4 42 15 36 e4       	vpermd %ymm12,%ymm13,%ymm12
 100319b:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 10031a0:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 10031a5:	c4 63 79 14 e0 0a    	vpextrb $0xa,%xmm12,%eax
 10031ab:	a8 01                	test   $0x1,%al
 10031ad:	74 05                	je     10031b4 <_Z11create_file8fat_filePKchm+0x8b0>
 10031af:	c6 44 0a 12 00       	movb   $0x0,0x12(%rdx,%rcx,1)
 10031b4:	c4 c3 7d 39 e4 01    	vextracti128 $0x1,%ymm4,%xmm12
 10031ba:	c4 41 19 ef e1       	vpxor  %xmm9,%xmm12,%xmm12
 10031bf:	c4 62 19 37 64 24 a0 	vpcmpgtq -0x60(%rsp),%xmm12,%xmm12
 10031c6:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 10031cb:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 10031d0:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 10031d5:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 10031da:	c4 63 79 14 e0 0b    	vpextrb $0xb,%xmm12,%eax
 10031e0:	a8 01                	test   $0x1,%al
 10031e2:	74 05                	je     10031e9 <_Z11create_file8fat_filePKchm+0x8e5>
 10031e4:	c6 44 0a 13 00       	movb   $0x0,0x13(%rdx,%rcx,1)
 10031e9:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 10031ed:	c5 31 ef eb          	vpxor  %xmm3,%xmm9,%xmm13
 10031f1:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 10031f6:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 10031fb:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1003200:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1003206:	c5 1d 6b e0          	vpackssdw %ymm0,%ymm12,%ymm12
 100320a:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1003210:	c4 42 79 79 e4       	vpbroadcastw %xmm12,%xmm12
 1003215:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 100321a:	c4 63 79 14 e0 0c    	vpextrb $0xc,%xmm12,%eax
 1003220:	a8 01                	test   $0x1,%al
 1003222:	74 05                	je     1003229 <_Z11create_file8fat_filePKchm+0x925>
 1003224:	c6 44 0a 14 00       	movb   $0x0,0x14(%rdx,%rcx,1)
 1003229:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 100322d:	c5 31 ef eb          	vpxor  %xmm3,%xmm9,%xmm13
 1003231:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 1003236:	c4 41 7a 70 e4 84    	vpshufhw $0x84,%xmm12,%xmm12
 100323c:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1003241:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1003247:	c5 1d 6b e0          	vpackssdw %ymm0,%ymm12,%ymm12
 100324b:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1003251:	c4 42 79 58 e4       	vpbroadcastd %xmm12,%xmm12
 1003256:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 100325b:	c4 63 79 14 e0 0d    	vpextrb $0xd,%xmm12,%eax
 1003261:	a8 01                	test   $0x1,%al
 1003263:	74 05                	je     100326a <_Z11create_file8fat_filePKchm+0x966>
 1003265:	c6 44 0a 15 00       	movb   $0x0,0x15(%rdx,%rcx,1)
 100326a:	c5 25 ef e3          	vpxor  %ymm3,%ymm11,%ymm12
 100326e:	c4 42 1d 37 ef       	vpcmpgtq %ymm15,%ymm12,%ymm13
 1003273:	c4 41 7d 6b e5       	vpackssdw %ymm13,%ymm0,%ymm12
 1003278:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 100327e:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1003283:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1003288:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 100328d:	c4 63 79 14 e0 0e    	vpextrb $0xe,%xmm12,%eax
 1003293:	a8 01                	test   $0x1,%al
 1003295:	74 05                	je     100329c <_Z11create_file8fat_filePKchm+0x998>
 1003297:	c6 44 0a 16 00       	movb   $0x0,0x16(%rdx,%rcx,1)
 100329c:	c4 41 7e 70 e5 84    	vpshufhw $0x84,%ymm13,%ymm12
 10032a2:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 10032a8:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 10032ad:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 10032b2:	c4 41 19 63 e4       	vpacksswb %xmm12,%xmm12,%xmm12
 10032b7:	c4 63 79 14 e0 0f    	vpextrb $0xf,%xmm12,%eax
 10032bd:	a8 01                	test   $0x1,%al
 10032bf:	74 05                	je     10032c6 <_Z11create_file8fat_filePKchm+0x9c2>
 10032c1:	c6 44 0a 17 00       	movb   $0x0,0x17(%rdx,%rcx,1)
 10032c6:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 10032ca:	c5 31 ef ea          	vpxor  %xmm2,%xmm9,%xmm13
 10032ce:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 10032d3:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 10032d8:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 10032dd:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 10032e2:	c4 42 7d 33 e4       	vpmovzxwd %xmm12,%ymm12
 10032e7:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 10032ec:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 10032f2:	c4 63 79 14 e0 08    	vpextrb $0x8,%xmm12,%eax
 10032f8:	a8 01                	test   $0x1,%al
 10032fa:	74 05                	je     1003301 <_Z11create_file8fat_filePKchm+0x9fd>
 10032fc:	c6 44 0a 18 00       	movb   $0x0,0x18(%rdx,%rcx,1)
 1003301:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1003305:	c5 31 ef ea          	vpxor  %xmm2,%xmm9,%xmm13
 1003309:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 100330e:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1003313:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1003318:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 100331d:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 1003323:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 1003328:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 100332e:	c4 63 79 14 e0 09    	vpextrb $0x9,%xmm12,%eax
 1003334:	a8 01                	test   $0x1,%al
 1003336:	74 05                	je     100333d <_Z11create_file8fat_filePKchm+0xa39>
 1003338:	c6 44 0a 19 00       	movb   $0x0,0x19(%rdx,%rcx,1)
 100333d:	c5 25 ef e2          	vpxor  %ymm2,%ymm11,%ymm12
 1003341:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 1003346:	c4 41 7f 70 e4 e8    	vpshuflw $0xe8,%ymm12,%ymm12
 100334c:	c5 1d ef 25 cc 4e 00 	vpxor  0x4ecc(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 1003353:	00 
 1003354:	c5 7e 6f 6c 24 d0    	vmovdqu -0x30(%rsp),%ymm13
 100335a:	c4 42 15 36 e4       	vpermd %ymm12,%ymm13,%ymm12
 100335f:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 1003364:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 100336a:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 100336f:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1003375:	c4 63 79 14 e0 0a    	vpextrb $0xa,%xmm12,%eax
 100337b:	a8 01                	test   $0x1,%al
 100337d:	74 05                	je     1003384 <_Z11create_file8fat_filePKchm+0xa80>
 100337f:	c6 44 0a 1a 00       	movb   $0x0,0x1a(%rdx,%rcx,1)
 1003384:	c4 c3 7d 39 d4 01    	vextracti128 $0x1,%ymm2,%xmm12
 100338a:	c4 41 19 ef e1       	vpxor  %xmm9,%xmm12,%xmm12
 100338f:	c4 62 19 37 64 24 a0 	vpcmpgtq -0x60(%rsp),%xmm12,%xmm12
 1003396:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 100339b:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 10033a0:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 10033a5:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 10033ab:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 10033b0:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 10033b6:	c4 63 79 14 e0 0b    	vpextrb $0xb,%xmm12,%eax
 10033bc:	a8 01                	test   $0x1,%al
 10033be:	74 05                	je     10033c5 <_Z11create_file8fat_filePKchm+0xac1>
 10033c0:	c6 44 0a 1b 00       	movb   $0x0,0x1b(%rdx,%rcx,1)
 10033c5:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 10033c9:	c5 31 ef e9          	vpxor  %xmm1,%xmm9,%xmm13
 10033cd:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 10033d2:	c4 41 19 6b e4       	vpackssdw %xmm12,%xmm12,%xmm12
 10033d7:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 10033dc:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 10033e2:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 10033e7:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 10033ec:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 10033f2:	c4 63 79 14 e0 0c    	vpextrb $0xc,%xmm12,%eax
 10033f8:	a8 01                	test   $0x1,%al
 10033fa:	74 05                	je     1003401 <_Z11create_file8fat_filePKchm+0xafd>
 10033fc:	c6 44 0a 1c 00       	movb   $0x0,0x1c(%rdx,%rcx,1)
 1003401:	c5 31 ef e0          	vpxor  %xmm0,%xmm9,%xmm12
 1003405:	c5 31 ef e9          	vpxor  %xmm1,%xmm9,%xmm13
 1003409:	c4 42 11 37 e4       	vpcmpgtq %xmm12,%xmm13,%xmm12
 100340e:	c4 41 7a 70 e4 84    	vpshufhw $0x84,%xmm12,%xmm12
 1003414:	c4 41 19 ef e2       	vpxor  %xmm10,%xmm12,%xmm12
 1003419:	c4 43 fd 00 e4 55    	vpermq $0x55,%ymm12,%ymm12
 100341f:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1003424:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 1003429:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 100342f:	c4 63 79 14 e0 0d    	vpextrb $0xd,%xmm12,%eax
 1003435:	a8 01                	test   $0x1,%al
 1003437:	74 05                	je     100343e <_Z11create_file8fat_filePKchm+0xb3a>
 1003439:	c6 44 0a 1d 00       	movb   $0x0,0x1d(%rdx,%rcx,1)
 100343e:	c5 25 ef e1          	vpxor  %ymm1,%ymm11,%ymm12
 1003442:	c4 42 1d 37 e7       	vpcmpgtq %ymm15,%ymm12,%ymm12
 1003447:	c4 41 7d 6b ec       	vpackssdw %ymm12,%ymm0,%ymm13
 100344c:	c5 15 ef 2d cc 4d 00 	vpxor  0x4dcc(%rip),%ymm13,%ymm13        # 1008220 <_ZL4lfsr+0xe0>
 1003453:	00 
 1003454:	c4 41 7d 6b ed       	vpackssdw %ymm13,%ymm0,%ymm13
 1003459:	c4 41 7d 63 ed       	vpacksswb %ymm13,%ymm0,%ymm13
 100345e:	c4 43 7d 39 ed 01    	vextracti128 $0x1,%ymm13,%xmm13
 1003464:	c4 63 79 14 e8 0e    	vpextrb $0xe,%xmm13,%eax
 100346a:	a8 01                	test   $0x1,%al
 100346c:	74 05                	je     1003473 <_Z11create_file8fat_filePKchm+0xb6f>
 100346e:	c6 44 0a 1e 00       	movb   $0x0,0x1e(%rdx,%rcx,1)
 1003473:	c4 41 7e 70 e4 84    	vpshufhw $0x84,%ymm12,%ymm12
 1003479:	c5 1d ef 25 9f 4d 00 	vpxor  0x4d9f(%rip),%ymm12,%ymm12        # 1008220 <_ZL4lfsr+0xe0>
 1003480:	00 
 1003481:	c4 41 7d 6b e4       	vpackssdw %ymm12,%ymm0,%ymm12
 1003486:	c4 41 7d 63 e4       	vpacksswb %ymm12,%ymm0,%ymm12
 100348b:	c4 43 7d 39 e4 01    	vextracti128 $0x1,%ymm12,%xmm12
 1003491:	c4 63 79 14 e0 0f    	vpextrb $0xf,%xmm12,%eax
 1003497:	a8 01                	test   $0x1,%al
 1003499:	74 05                	je     10034a0 <_Z11create_file8fat_filePKchm+0xb9c>
 100349b:	c6 44 0a 1f 00       	movb   $0x0,0x1f(%rdx,%rcx,1)
 10034a0:	48 83 c1 20          	add    $0x20,%rcx
 10034a4:	c4 41 3d d4 c6       	vpaddq %ymm14,%ymm8,%ymm8
 10034a9:	c5 8d d4 ff          	vpaddq %ymm7,%ymm14,%ymm7
 10034ad:	c5 8d d4 f6          	vpaddq %ymm6,%ymm14,%ymm6
 10034b1:	c5 8d d4 ed          	vpaddq %ymm5,%ymm14,%ymm5
 10034b5:	c5 8d d4 e4          	vpaddq %ymm4,%ymm14,%ymm4
 10034b9:	c5 8d d4 db          	vpaddq %ymm3,%ymm14,%ymm3
 10034bd:	c5 8d d4 d2          	vpaddq %ymm2,%ymm14,%ymm2
 10034c1:	c5 8d d4 c9          	vpaddq %ymm1,%ymm14,%ymm1
 10034c5:	48 39 ce             	cmp    %rcx,%rsi
 10034c8:	0f 85 bb f8 ff ff    	jne    1002d89 <_Z11create_file8fat_filePKchm+0x485>
 10034ce:	4c 89 c8             	mov    %r9,%rax
 10034d1:	48 81 c4 f8 01 00 00 	add    $0x1f8,%rsp
 10034d8:	5b                   	pop    %rbx
 10034d9:	41 5c                	pop    %r12
 10034db:	41 5d                	pop    %r13
 10034dd:	41 5e                	pop    %r14
 10034df:	41 5f                	pop    %r15
 10034e1:	5d                   	pop    %rbp
 10034e2:	c5 f8 77             	vzeroupper 
 10034e5:	c3                   	ret    

00000000010034e6 <_Z6strcpyPcPKc>:
 10034e6:	8a 06                	mov    (%rsi),%al
 10034e8:	84 c0                	test   %al,%al
 10034ea:	74 11                	je     10034fd <_Z6strcpyPcPKc+0x17>
 10034ec:	48 ff c6             	inc    %rsi
 10034ef:	88 07                	mov    %al,(%rdi)
 10034f1:	48 ff c7             	inc    %rdi
 10034f4:	8a 06                	mov    (%rsi),%al
 10034f6:	48 ff c6             	inc    %rsi
 10034f9:	84 c0                	test   %al,%al
 10034fb:	75 f2                	jne    10034ef <_Z6strcpyPcPKc+0x9>
 10034fd:	c6 07 00             	movb   $0x0,(%rdi)
 1003500:	c3                   	ret    

0000000001003501 <_Z16create_directory8fat_filePKch>:
 1003501:	41 57                	push   %r15
 1003503:	41 56                	push   %r14
 1003505:	53                   	push   %rbx
 1003506:	48 81 ec a0 00 00 00 	sub    $0xa0,%rsp
 100350d:	48 89 fb             	mov    %rdi,%rbx
 1003510:	80 ca 10             	or     $0x10,%dl
 1003513:	c5 fc 10 84 24 c0 00 	vmovups 0xc0(%rsp),%ymm0
 100351a:	00 00 
 100351c:	c5 fc 10 8c 24 e0 00 	vmovups 0xe0(%rsp),%ymm1
 1003523:	00 00 
 1003525:	c5 fc 10 94 24 f0 00 	vmovups 0xf0(%rsp),%ymm2
 100352c:	00 00 
 100352e:	c5 fc 11 54 24 30    	vmovups %ymm2,0x30(%rsp)
 1003534:	c5 fc 11 4c 24 20    	vmovups %ymm1,0x20(%rsp)
 100353a:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
 100353f:	0f b6 d2             	movzbl %dl,%edx
 1003542:	b9 00 02 00 00       	mov    $0x200,%ecx
 1003547:	c5 f8 77             	vzeroupper 
 100354a:	e8 b5 f3 ff ff       	call   1002904 <_Z11create_file8fat_filePKchm>
 100354f:	4c 8b 7b 40          	mov    0x40(%rbx),%r15
 1003553:	41 0f b6 57 0b       	movzbl 0xb(%r15),%edx
 1003558:	c5 fc 10 84 24 c0 00 	vmovups 0xc0(%rsp),%ymm0
 100355f:	00 00 
 1003561:	c5 fc 10 8c 24 e0 00 	vmovups 0xe0(%rsp),%ymm1
 1003568:	00 00 
 100356a:	c5 fc 10 94 24 f0 00 	vmovups 0xf0(%rsp),%ymm2
 1003571:	00 00 
 1003573:	c5 fc 11 54 24 30    	vmovups %ymm2,0x30(%rsp)
 1003579:	c5 fc 11 4c 24 20    	vmovups %ymm1,0x20(%rsp)
 100357f:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
 1003584:	83 ca 02             	or     $0x2,%edx
 1003587:	4c 8d 74 24 50       	lea    0x50(%rsp),%r14
 100358c:	be dd 84 00 01       	mov    $0x10084dd,%esi
 1003591:	4c 89 f7             	mov    %r14,%rdi
 1003594:	31 c9                	xor    %ecx,%ecx
 1003596:	c5 f8 77             	vzeroupper 
 1003599:	e8 66 f3 ff ff       	call   1002904 <_Z11create_file8fat_filePKchm>
 100359e:	49 8b 46 40          	mov    0x40(%r14),%rax
 10035a2:	41 8b 4f 1c          	mov    0x1c(%r15),%ecx
 10035a6:	89 48 1c             	mov    %ecx,0x1c(%rax)
 10035a9:	41 0f b7 4f 14       	movzwl 0x14(%r15),%ecx
 10035ae:	66 89 48 14          	mov    %cx,0x14(%rax)
 10035b2:	41 0f b7 4f 1a       	movzwl 0x1a(%r15),%ecx
 10035b7:	66 89 48 1a          	mov    %cx,0x1a(%rax)
 10035bb:	4c 8b bc 24 00 01 00 	mov    0x100(%rsp),%r15
 10035c2:	00 
 10035c3:	41 0f b6 57 0b       	movzbl 0xb(%r15),%edx
 10035c8:	c5 fc 10 84 24 c0 00 	vmovups 0xc0(%rsp),%ymm0
 10035cf:	00 00 
 10035d1:	c5 fc 10 8c 24 e0 00 	vmovups 0xe0(%rsp),%ymm1
 10035d8:	00 00 
 10035da:	c5 fc 10 94 24 f0 00 	vmovups 0xf0(%rsp),%ymm2
 10035e1:	00 00 
 10035e3:	c5 fc 11 54 24 30    	vmovups %ymm2,0x30(%rsp)
 10035e9:	c5 fc 11 4c 24 20    	vmovups %ymm1,0x20(%rsp)
 10035ef:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
 10035f4:	83 ca 02             	or     $0x2,%edx
 10035f7:	4c 8d 74 24 50       	lea    0x50(%rsp),%r14
 10035fc:	be 69 87 00 01       	mov    $0x1008769,%esi
 1003601:	4c 89 f7             	mov    %r14,%rdi
 1003604:	31 c9                	xor    %ecx,%ecx
 1003606:	c5 f8 77             	vzeroupper 
 1003609:	e8 f6 f2 ff ff       	call   1002904 <_Z11create_file8fat_filePKchm>
 100360e:	49 8b 46 40          	mov    0x40(%r14),%rax
 1003612:	41 8b 4f 1c          	mov    0x1c(%r15),%ecx
 1003616:	89 48 1c             	mov    %ecx,0x1c(%rax)
 1003619:	41 0f b7 4f 14       	movzwl 0x14(%r15),%ecx
 100361e:	66 89 48 14          	mov    %cx,0x14(%rax)
 1003622:	41 0f b7 4f 1a       	movzwl 0x1a(%r15),%ecx
 1003627:	66 89 48 1a          	mov    %cx,0x1a(%rax)
 100362b:	48 89 d8             	mov    %rbx,%rax
 100362e:	48 81 c4 a0 00 00 00 	add    $0xa0,%rsp
 1003635:	5b                   	pop    %rbx
 1003636:	41 5e                	pop    %r14
 1003638:	41 5f                	pop    %r15
 100363a:	c3                   	ret    

000000000100363b <_Z14create_symlink8fat_filePKchS_>:
 100363b:	53                   	push   %rbx
 100363c:	48 83 ec 50          	sub    $0x50,%rsp
 1003640:	48 89 fb             	mov    %rdi,%rbx
 1003643:	c5 fc 10 44 24 60    	vmovups 0x60(%rsp),%ymm0
 1003649:	c5 fc 10 8c 24 80 00 	vmovups 0x80(%rsp),%ymm1
 1003650:	00 00 
 1003652:	c5 fc 10 94 24 90 00 	vmovups 0x90(%rsp),%ymm2
 1003659:	00 00 
 100365b:	c5 fc 11 54 24 30    	vmovups %ymm2,0x30(%rsp)
 1003661:	c5 fc 11 4c 24 20    	vmovups %ymm1,0x20(%rsp)
 1003667:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
 100366c:	31 c9                	xor    %ecx,%ecx
 100366e:	c5 f8 77             	vzeroupper 
 1003671:	e8 8e f2 ff ff       	call   1002904 <_Z11create_file8fat_filePKchm>
 1003676:	48 8b 84 24 f0 00 00 	mov    0xf0(%rsp),%rax
 100367d:	00 
 100367e:	48 8b 4b 40          	mov    0x40(%rbx),%rcx
 1003682:	48 85 c0             	test   %rax,%rax
 1003685:	75 1b                	jne    10036a2 <_Z14create_symlink8fat_filePKchS_+0x67>
 1003687:	c7 41 1c 00 02 00 00 	movl   $0x200,0x1c(%rcx)
 100368e:	8b 14 25 2c 00 20 00 	mov    0x20002c,%edx
 1003695:	89 d6                	mov    %edx,%esi
 1003697:	c1 ee 10             	shr    $0x10,%esi
 100369a:	66 89 71 14          	mov    %si,0x14(%rcx)
 100369e:	66 89 51 1a          	mov    %dx,0x1a(%rcx)
 10036a2:	8b 50 1c             	mov    0x1c(%rax),%edx
 10036a5:	89 51 1c             	mov    %edx,0x1c(%rcx)
 10036a8:	0f b7 50 14          	movzwl 0x14(%rax),%edx
 10036ac:	66 89 51 14          	mov    %dx,0x14(%rcx)
 10036b0:	0f b7 40 1a          	movzwl 0x1a(%rax),%eax
 10036b4:	66 89 41 1a          	mov    %ax,0x1a(%rcx)
 10036b8:	48 89 d8             	mov    %rbx,%rax
 10036bb:	48 83 c4 50          	add    $0x50,%rsp
 10036bf:	5b                   	pop    %rbx
 10036c0:	c3                   	ret    

00000000010036c1 <_Z11delete_file8fat_file>:
 10036c1:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
 10036c6:	0f b7 50 14          	movzwl 0x14(%rax),%edx
 10036ca:	c1 e2 10             	shl    $0x10,%edx
 10036cd:	0f b7 48 1a          	movzwl 0x1a(%rax),%ecx
 10036d1:	09 d1                	or     %edx,%ecx
 10036d3:	85 c9                	test   %ecx,%ecx
 10036d5:	74 37                	je     100370e <_Z11delete_file8fat_file+0x4d>
 10036d7:	89 ca                	mov    %ecx,%edx
 10036d9:	81 e2 ff ff ff 0f    	and    $0xfffffff,%edx
 10036df:	81 fa f6 ff ff 0f    	cmp    $0xffffff6,%edx
 10036e5:	77 27                	ja     100370e <_Z11delete_file8fat_file+0x4d>
 10036e7:	48 8b 15 4a 56 00 00 	mov    0x564a(%rip),%rdx        # 1008d38 <_ZL8fatTable>
 10036ee:	89 ce                	mov    %ecx,%esi
 10036f0:	8b 0c b2             	mov    (%rdx,%rsi,4),%ecx
 10036f3:	c7 04 b2 00 00 00 00 	movl   $0x0,(%rdx,%rsi,4)
 10036fa:	85 c9                	test   %ecx,%ecx
 10036fc:	74 10                	je     100370e <_Z11delete_file8fat_file+0x4d>
 10036fe:	89 ce                	mov    %ecx,%esi
 1003700:	81 e6 ff ff ff 0f    	and    $0xfffffff,%esi
 1003706:	81 fe f7 ff ff 0f    	cmp    $0xffffff7,%esi
 100370c:	72 e0                	jb     10036ee <_Z11delete_file8fat_file+0x2d>
 100370e:	31 c9                	xor    %ecx,%ecx
 1003710:	80 78 eb 0f          	cmpb   $0xf,-0x15(%rax)
 1003714:	75 11                	jne    1003727 <_Z11delete_file8fat_file+0x66>
 1003716:	48 8d 50 cb          	lea    -0x35(%rax),%rdx
 100371a:	31 c9                	xor    %ecx,%ecx
 100371c:	ff c1                	inc    %ecx
 100371e:	80 3a 0f             	cmpb   $0xf,(%rdx)
 1003721:	48 8d 52 e0          	lea    -0x20(%rdx),%rdx
 1003725:	74 f5                	je     100371c <_Z11delete_file8fat_file+0x5b>
 1003727:	f7 d9                	neg    %ecx
 1003729:	80 78 20 00          	cmpb   $0x0,0x20(%rax)
 100372d:	74 38                	je     1003767 <_Z11delete_file8fat_file+0xa6>
 100372f:	48 8d 70 20          	lea    0x20(%rax),%rsi
 1003733:	48 63 d1             	movslq %ecx,%rdx
 1003736:	48 c1 e2 05          	shl    $0x5,%rdx
 100373a:	48 01 c2             	add    %rax,%rdx
 100373d:	bf 02 00 00 00       	mov    $0x2,%edi
 1003742:	c5 fc 10 06          	vmovups (%rsi),%ymm0
 1003746:	c5 fc 11 02          	vmovups %ymm0,(%rdx)
 100374a:	48 63 ff             	movslq %edi,%rdi
 100374d:	49 89 f8             	mov    %rdi,%r8
 1003750:	49 c1 e0 05          	shl    $0x5,%r8
 1003754:	4a 8d 34 00          	lea    (%rax,%r8,1),%rsi
 1003758:	48 83 c2 20          	add    $0x20,%rdx
 100375c:	ff c1                	inc    %ecx
 100375e:	ff c7                	inc    %edi
 1003760:	42 80 3c 00 00       	cmpb   $0x0,(%rax,%r8,1)
 1003765:	75 db                	jne    1003742 <_Z11delete_file8fat_file+0x81>
 1003767:	48 63 c9             	movslq %ecx,%rcx
 100376a:	48 c1 e1 05          	shl    $0x5,%rcx
 100376e:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1)
 1003772:	74 19                	je     100378d <_Z11delete_file8fat_file+0xcc>
 1003774:	48 01 c8             	add    %rcx,%rax
 1003777:	48 83 c0 20          	add    $0x20,%rax
 100377b:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 100377f:	c5 fc 11 40 e0       	vmovups %ymm0,-0x20(%rax)
 1003784:	80 38 00             	cmpb   $0x0,(%rax)
 1003787:	48 8d 40 20          	lea    0x20(%rax),%rax
 100378b:	75 f2                	jne    100377f <_Z11delete_file8fat_file+0xbe>
 100378d:	c5 f8 77             	vzeroupper 
 1003790:	c3                   	ret    

0000000001003791 <_Z9read_file8fat_filePvm>:
 1003791:	0f b7 0d 98 55 00 00 	movzwl 0x5598(%rip),%ecx        # 1008d30 <_ZL15bytesPerCluster>
 1003798:	48 8d 04 0e          	lea    (%rsi,%rcx,1),%rax
 100379c:	48 ff c8             	dec    %rax
 100379f:	31 d2                	xor    %edx,%edx
 10037a1:	48 f7 f1             	div    %rcx
 10037a4:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
 10037a9:	0f b7 51 14          	movzwl 0x14(%rcx),%edx
 10037ad:	c1 e2 10             	shl    $0x10,%edx
 10037b0:	0f b7 71 1a          	movzwl 0x1a(%rcx),%esi
 10037b4:	09 d6                	or     %edx,%esi
 10037b6:	89 c2                	mov    %eax,%edx
 10037b8:	e9 63 f0 ff ff       	jmp    1002820 <_Z18read_cluster_chainPvjj>

00000000010037bd <_Z10write_file8fat_filePvm>:
 10037bd:	c3                   	ret    

00000000010037be <_Z16get_fat_metadataP14fat_disk_entry>:
 10037be:	55                   	push   %rbp
 10037bf:	41 57                	push   %r15
 10037c1:	41 56                	push   %r14
 10037c3:	53                   	push   %rbx
 10037c4:	48 81 ec 88 01 00 00 	sub    $0x188,%rsp
 10037cb:	48 89 f8             	mov    %rdi,%rax
 10037ce:	48 89 77 40          	mov    %rsi,0x40(%rdi)
 10037d2:	80 7e eb 0f          	cmpb   $0xf,-0x15(%rsi)
 10037d6:	0f 85 e8 00 00 00    	jne    10038c4 <_Z16get_fat_metadataP14fat_disk_entry+0x106>
 10037dc:	48 8d 56 e0          	lea    -0x20(%rsi),%rdx
 10037e0:	48 8d 7c 24 80       	lea    -0x80(%rsp),%rdi
 10037e5:	31 c9                	xor    %ecx,%ecx
 10037e7:	48 ff c1             	inc    %rcx
 10037ea:	c5 fc 10 02          	vmovups (%rdx),%ymm0
 10037ee:	c5 fc 11 07          	vmovups %ymm0,(%rdi)
 10037f2:	48 83 c7 20          	add    $0x20,%rdi
 10037f6:	80 7a eb 0f          	cmpb   $0xf,-0x15(%rdx)
 10037fa:	48 8d 52 e0          	lea    -0x20(%rdx),%rdx
 10037fe:	74 e7                	je     10037e7 <_Z16get_fat_metadataP14fat_disk_entry+0x29>
 1003800:	85 c9                	test   %ecx,%ecx
 1003802:	0f 84 bc 00 00 00    	je     10038c4 <_Z16get_fat_metadataP14fat_disk_entry+0x106>
 1003808:	89 c9                	mov    %ecx,%ecx
 100380a:	48 8d 54 24 81       	lea    -0x7f(%rsp),%rdx
 100380f:	48 8d 70 f3          	lea    -0xd(%rax),%rsi
 1003813:	48 8d 78 f8          	lea    -0x8(%rax),%rdi
 1003817:	4c 8d 44 24 8e       	lea    -0x72(%rsp),%r8
 100381c:	45 31 c9             	xor    %r9d,%r9d
 100381f:	4d 89 ca             	mov    %r9,%r10
 1003822:	49 c1 e2 05          	shl    $0x5,%r10
 1003826:	46 0f b6 5c 14 80    	movzbl -0x80(%rsp,%r10,1),%r11d
 100382c:	41 83 e3 1f          	and    $0x1f,%r11d
 1003830:	4b 8d 1c 5b          	lea    (%r11,%r11,2),%rbx
 1003834:	4d 8d 1c 9b          	lea    (%r11,%rbx,4),%r11
 1003838:	4a 8d 1c 1e          	lea    (%rsi,%r11,1),%rbx
 100383c:	45 31 f6             	xor    %r14d,%r14d
 100383f:	42 0f b7 2c 72       	movzwl (%rdx,%r14,2),%ebp
 1003844:	42 88 2c 33          	mov    %bpl,(%rbx,%r14,1)
 1003848:	49 83 fe 03          	cmp    $0x3,%r14
 100384c:	77 08                	ja     1003856 <_Z16get_fat_metadataP14fat_disk_entry+0x98>
 100384e:	49 ff c6             	inc    %r14
 1003851:	66 85 ed             	test   %bp,%bp
 1003854:	75 e9                	jne    100383f <_Z16get_fat_metadataP14fat_disk_entry+0x81>
 1003856:	66 85 ed             	test   %bp,%bp
 1003859:	74 53                	je     10038ae <_Z16get_fat_metadataP14fat_disk_entry+0xf0>
 100385b:	4a 8d 1c 1f          	lea    (%rdi,%r11,1),%rbx
 100385f:	45 31 f6             	xor    %r14d,%r14d
 1003862:	43 0f b7 2c 70       	movzwl (%r8,%r14,2),%ebp
 1003867:	42 88 2c 33          	mov    %bpl,(%rbx,%r14,1)
 100386b:	49 83 fe 04          	cmp    $0x4,%r14
 100386f:	77 08                	ja     1003879 <_Z16get_fat_metadataP14fat_disk_entry+0xbb>
 1003871:	49 ff c6             	inc    %r14
 1003874:	66 85 ed             	test   %bp,%bp
 1003877:	75 e9                	jne    1003862 <_Z16get_fat_metadataP14fat_disk_entry+0xa4>
 1003879:	66 85 ed             	test   %bp,%bp
 100387c:	74 30                	je     10038ae <_Z16get_fat_metadataP14fat_disk_entry+0xf0>
 100387e:	b3 01                	mov    $0x1,%bl
 1003880:	45 31 f6             	xor    %r14d,%r14d
 1003883:	4e 8d 3c 14          	lea    (%rsp,%r10,1),%r15
 1003887:	49 83 c7 80          	add    $0xffffffffffffff80,%r15
 100388b:	43 0f b7 6c 77 1c    	movzwl 0x1c(%r15,%r14,2),%ebp
 1003891:	49 83 ce fe          	or     $0xfffffffffffffffe,%r14
 1003895:	4d 01 de             	add    %r11,%r14
 1003898:	42 88 2c 30          	mov    %bpl,(%rax,%r14,1)
 100389c:	f6 c3 01             	test   $0x1,%bl
 100389f:	74 0d                	je     10038ae <_Z16get_fat_metadataP14fat_disk_entry+0xf0>
 10038a1:	41 be 01 00 00 00    	mov    $0x1,%r14d
 10038a7:	31 db                	xor    %ebx,%ebx
 10038a9:	66 85 ed             	test   %bp,%bp
 10038ac:	75 d5                	jne    1003883 <_Z16get_fat_metadataP14fat_disk_entry+0xc5>
 10038ae:	49 ff c1             	inc    %r9
 10038b1:	48 83 c2 20          	add    $0x20,%rdx
 10038b5:	49 83 c0 20          	add    $0x20,%r8
 10038b9:	49 39 c9             	cmp    %rcx,%r9
 10038bc:	0f 85 5d ff ff ff    	jne    100381f <_Z16get_fat_metadataP14fat_disk_entry+0x61>
 10038c2:	eb 5a                	jmp    100391e <_Z16get_fat_metadataP14fat_disk_entry+0x160>
 10038c4:	31 c9                	xor    %ecx,%ecx
 10038c6:	8a 14 0e             	mov    (%rsi,%rcx,1),%dl
 10038c9:	80 fa 20             	cmp    $0x20,%dl
 10038cc:	74 11                	je     10038df <_Z16get_fat_metadataP14fat_disk_entry+0x121>
 10038ce:	88 14 08             	mov    %dl,(%rax,%rcx,1)
 10038d1:	48 ff c1             	inc    %rcx
 10038d4:	48 83 f9 08          	cmp    $0x8,%rcx
 10038d8:	75 ec                	jne    10038c6 <_Z16get_fat_metadataP14fat_disk_entry+0x108>
 10038da:	b9 08 00 00 00       	mov    $0x8,%ecx
 10038df:	80 7e 08 20          	cmpb   $0x20,0x8(%rsi)
 10038e3:	74 32                	je     1003917 <_Z16get_fat_metadataP14fat_disk_entry+0x159>
 10038e5:	89 ca                	mov    %ecx,%edx
 10038e7:	4c 8d 04 10          	lea    (%rax,%rdx,1),%r8
 10038eb:	49 ff c0             	inc    %r8
 10038ee:	41 c6 40 ff 2e       	movb   $0x2e,-0x1(%r8)
 10038f3:	83 c1 04             	add    $0x4,%ecx
 10038f6:	31 ff                	xor    %edi,%edi
 10038f8:	44 8a 4c 3e 08       	mov    0x8(%rsi,%rdi,1),%r9b
 10038fd:	41 80 f9 20          	cmp    $0x20,%r9b
 1003901:	74 0f                	je     1003912 <_Z16get_fat_metadataP14fat_disk_entry+0x154>
 1003903:	45 88 0c 38          	mov    %r9b,(%r8,%rdi,1)
 1003907:	48 ff c7             	inc    %rdi
 100390a:	48 83 ff 03          	cmp    $0x3,%rdi
 100390e:	75 e8                	jne    10038f8 <_Z16get_fat_metadataP14fat_disk_entry+0x13a>
 1003910:	eb 05                	jmp    1003917 <_Z16get_fat_metadataP14fat_disk_entry+0x159>
 1003912:	8d 0c 3a             	lea    (%rdx,%rdi,1),%ecx
 1003915:	ff c1                	inc    %ecx
 1003917:	48 63 c9             	movslq %ecx,%rcx
 100391a:	c6 04 08 00          	movb   $0x0,(%rax,%rcx,1)
 100391e:	48 81 c4 88 01 00 00 	add    $0x188,%rsp
 1003925:	5b                   	pop    %rbx
 1003926:	41 5e                	pop    %r14
 1003928:	41 5f                	pop    %r15
 100392a:	5d                   	pop    %rbp
 100392b:	c5 f8 77             	vzeroupper 
 100392e:	c3                   	ret    

000000000100392f <_Z6memcpyPvPKvm>:
 100392f:	48 85 d2             	test   %rdx,%rdx
 1003932:	74 10                	je     1003944 <_Z6memcpyPvPKvm+0x15>
 1003934:	31 c0                	xor    %eax,%eax
 1003936:	8a 0c 06             	mov    (%rsi,%rax,1),%cl
 1003939:	88 0c 07             	mov    %cl,(%rdi,%rax,1)
 100393c:	48 ff c0             	inc    %rax
 100393f:	48 39 c2             	cmp    %rax,%rdx
 1003942:	75 f2                	jne    1003936 <_Z6memcpyPvPKvm+0x7>
 1003944:	c3                   	ret    

0000000001003945 <_Z8enum_dir8fat_filePS_>:
 1003945:	55                   	push   %rbp
 1003946:	41 57                	push   %r15
 1003948:	41 56                	push   %r14
 100394a:	53                   	push   %rbx
 100394b:	48 83 ec 58          	sub    $0x58,%rsp
 100394f:	4c 8b b4 24 c8 00 00 	mov    0xc8(%rsp),%r14
 1003956:	00 
 1003957:	41 80 3e 00          	cmpb   $0x0,(%r14)
 100395b:	74 5c                	je     10039b9 <_Z8enum_dir8fat_filePS_+0x74>
 100395d:	48 89 fb             	mov    %rdi,%rbx
 1003960:	31 ed                	xor    %ebp,%ebp
 1003962:	4c 8d 7c 24 08       	lea    0x8(%rsp),%r15
 1003967:	41 80 7e 0b 0f       	cmpb   $0xf,0xb(%r14)
 100396c:	74 3e                	je     10039ac <_Z8enum_dir8fat_filePS_+0x67>
 100396e:	4c 89 ff             	mov    %r15,%rdi
 1003971:	4c 89 f6             	mov    %r14,%rsi
 1003974:	c5 f8 77             	vzeroupper 
 1003977:	e8 42 fe ff ff       	call   10037be <_Z16get_fat_metadataP14fat_disk_entry>
 100397c:	48 63 c5             	movslq %ebp,%rax
 100397f:	ff c5                	inc    %ebp
 1003981:	48 8d 04 80          	lea    (%rax,%rax,4),%rax
 1003985:	48 c1 e0 04          	shl    $0x4,%rax
 1003989:	c5 fc 10 44 24 08    	vmovups 0x8(%rsp),%ymm0
 100398f:	c5 fc 10 4c 24 28    	vmovups 0x28(%rsp),%ymm1
 1003995:	c5 fc 10 54 24 38    	vmovups 0x38(%rsp),%ymm2
 100399b:	c5 fc 11 54 03 30    	vmovups %ymm2,0x30(%rbx,%rax,1)
 10039a1:	c5 fc 11 4c 03 20    	vmovups %ymm1,0x20(%rbx,%rax,1)
 10039a7:	c5 fc 11 04 03       	vmovups %ymm0,(%rbx,%rax,1)
 10039ac:	41 80 7e 20 00       	cmpb   $0x0,0x20(%r14)
 10039b1:	4d 8d 76 20          	lea    0x20(%r14),%r14
 10039b5:	75 b0                	jne    1003967 <_Z8enum_dir8fat_filePS_+0x22>
 10039b7:	eb 02                	jmp    10039bb <_Z8enum_dir8fat_filePS_+0x76>
 10039b9:	31 ed                	xor    %ebp,%ebp
 10039bb:	89 e8                	mov    %ebp,%eax
 10039bd:	48 83 c4 58          	add    $0x58,%rsp
 10039c1:	5b                   	pop    %rbx
 10039c2:	41 5e                	pop    %r14
 10039c4:	41 5f                	pop    %r15
 10039c6:	5d                   	pop    %rbp
 10039c7:	c5 f8 77             	vzeroupper 
 10039ca:	c3                   	ret    

00000000010039cb <_Z6streqlPKcS0_>:
 10039cb:	8a 0f                	mov    (%rdi),%cl
 10039cd:	31 c0                	xor    %eax,%eax
 10039cf:	84 c9                	test   %cl,%cl
 10039d1:	74 0e                	je     10039e1 <_Z6streqlPKcS0_+0x16>
 10039d3:	38 0c 06             	cmp    %cl,(%rsi,%rax,1)
 10039d6:	75 11                	jne    10039e9 <_Z6streqlPKcS0_+0x1e>
 10039d8:	8a 4c 07 01          	mov    0x1(%rdi,%rax,1),%cl
 10039dc:	48 ff c0             	inc    %rax
 10039df:	eb ee                	jmp    10039cf <_Z6streqlPKcS0_+0x4>
 10039e1:	80 3c 06 00          	cmpb   $0x0,(%rsi,%rax,1)
 10039e5:	0f 94 c0             	sete   %al
 10039e8:	c3                   	ret    
 10039e9:	31 c0                	xor    %eax,%eax
 10039eb:	c3                   	ret    

00000000010039ec <_Z5krandv>:
 10039ec:	0f b7 0d 4d 47 00 00 	movzwl 0x474d(%rip),%ecx        # 1008140 <_ZL4lfsr>
 10039f3:	89 c8                	mov    %ecx,%eax
 10039f5:	c1 e8 02             	shr    $0x2,%eax
 10039f8:	89 ca                	mov    %ecx,%edx
 10039fa:	c1 ea 03             	shr    $0x3,%edx
 10039fd:	31 c2                	xor    %eax,%edx
 10039ff:	89 c8                	mov    %ecx,%eax
 1003a01:	c1 e8 05             	shr    $0x5,%eax
 1003a04:	31 c8                	xor    %ecx,%eax
 1003a06:	31 d0                	xor    %edx,%eax
 1003a08:	66 0f a4 c8 0f       	shld   $0xf,%cx,%ax
 1003a0d:	66 89 05 2c 47 00 00 	mov    %ax,0x472c(%rip)        # 1008140 <_ZL4lfsr>
 1003a14:	c3                   	ret    
 1003a15:	cc                   	int3   

0000000001003a16 <_ZN7consoleC1Ev>:
 1003a16:	48 c7 07 00 80 0b 00 	movq   $0xb8000,(%rdi)
 1003a1d:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 1003a21:	c5 f8 11 47 08       	vmovups %xmm0,0x8(%rdi)
 1003a26:	48 b8 50 00 00 00 19 	movabs $0x1900000050,%rax
 1003a2d:	00 00 00 
 1003a30:	48 89 47 18          	mov    %rax,0x18(%rdi)
 1003a34:	31 c0                	xor    %eax,%eax
 1003a36:	c4 e2 7d 79 05 03 47 	vpbroadcastw 0x4703(%rip),%ymm0        # 1008142 <_ZL4lfsr+0x2>
 1003a3d:	00 00 
 1003a3f:	c5 fd 7f 84 00 00 80 	vmovdqa %ymm0,0xb8000(%rax,%rax,1)
 1003a46:	0b 00 
 1003a48:	48 83 c0 10          	add    $0x10,%rax
 1003a4c:	48 3d d0 07 00 00    	cmp    $0x7d0,%rax
 1003a52:	75 eb                	jne    1003a3f <_ZN7consoleC1Ev+0x29>
 1003a54:	c5 f8 77             	vzeroupper 
 1003a57:	c3                   	ret    

0000000001003a58 <_ZN7console13update_cursorEv>:
 1003a58:	8b 4f 18             	mov    0x18(%rdi),%ecx
 1003a5b:	0f af 4f 0c          	imul   0xc(%rdi),%ecx
 1003a5f:	03 4f 08             	add    0x8(%rdi),%ecx
 1003a62:	b0 0f                	mov    $0xf,%al
 1003a64:	66 ba d4 03          	mov    $0x3d4,%dx
 1003a68:	ee                   	out    %al,(%dx)
 1003a69:	89 c8                	mov    %ecx,%eax
 1003a6b:	66 ba d5 03          	mov    $0x3d5,%dx
 1003a6f:	ee                   	out    %al,(%dx)
 1003a70:	b0 0e                	mov    $0xe,%al
 1003a72:	66 ba d4 03          	mov    $0x3d4,%dx
 1003a76:	ee                   	out    %al,(%dx)
 1003a77:	c1 e9 08             	shr    $0x8,%ecx
 1003a7a:	89 c8                	mov    %ecx,%eax
 1003a7c:	66 ba d5 03          	mov    $0x3d5,%dx
 1003a80:	ee                   	out    %al,(%dx)
 1003a81:	c3                   	ret    

0000000001003a82 <_ZN7console3setEcii>:
 1003a82:	81 ce 00 0f 00 00    	or     $0xf00,%esi
 1003a88:	0f af 4f 18          	imul   0x18(%rdi),%ecx
 1003a8c:	48 8b 07             	mov    (%rdi),%rax
 1003a8f:	01 d1                	add    %edx,%ecx
 1003a91:	48 63 c9             	movslq %ecx,%rcx
 1003a94:	66 89 34 48          	mov    %si,(%rax,%rcx,2)
 1003a98:	c3                   	ret    
 1003a99:	cc                   	int3   

0000000001003a9a <_ZN7console7newlineEv>:
 1003a9a:	55                   	push   %rbp
 1003a9b:	41 56                	push   %r14
 1003a9d:	53                   	push   %rbx
 1003a9e:	8b 47 0c             	mov    0xc(%rdi),%eax
 1003aa1:	8b 77 1c             	mov    0x1c(%rdi),%esi
 1003aa4:	8d 50 01             	lea    0x1(%rax),%edx
 1003aa7:	89 57 0c             	mov    %edx,0xc(%rdi)
 1003aaa:	48 63 4f 14          	movslq 0x14(%rdi),%rcx
 1003aae:	41 89 f0             	mov    %esi,%r8d
 1003ab1:	41 29 c8             	sub    %ecx,%r8d
 1003ab4:	44 39 c2             	cmp    %r8d,%edx
 1003ab7:	75 67                	jne    1003b20 <_ZN7console7newlineEv+0x86>
 1003ab9:	44 8d 0c 0e          	lea    (%rsi,%rcx,1),%r9d
 1003abd:	41 ff c9             	dec    %r9d
 1003ac0:	44 39 c9             	cmp    %r9d,%ecx
 1003ac3:	7d 56                	jge    1003b1b <_ZN7console7newlineEv+0x81>
 1003ac5:	48 63 57 10          	movslq 0x10(%rdi),%rdx
 1003ac9:	48 63 77 18          	movslq 0x18(%rdi),%rsi
 1003acd:	4c 8d 04 16          	lea    (%rsi,%rdx,1),%r8
 1003ad1:	48 8b 1f             	mov    (%rdi),%rbx
 1003ad4:	4d 63 c9             	movslq %r9d,%r9
 1003ad7:	49 89 ca             	mov    %rcx,%r10
 1003ada:	4c 0f af d6          	imul   %rsi,%r10
 1003ade:	4e 8d 14 53          	lea    (%rbx,%r10,2),%r10
 1003ae2:	4c 8d 71 01          	lea    0x1(%rcx),%r14
 1003ae6:	4c 0f af f6          	imul   %rsi,%r14
 1003aea:	49 89 f3             	mov    %rsi,%r11
 1003aed:	49 01 f3             	add    %rsi,%r11
 1003af0:	4a 8d 1c 73          	lea    (%rbx,%r14,2),%rbx
 1003af4:	49 89 d6             	mov    %rdx,%r14
 1003af7:	85 f6                	test   %esi,%esi
 1003af9:	7e 12                	jle    1003b0d <_ZN7console7newlineEv+0x73>
 1003afb:	42 0f b7 2c 73       	movzwl (%rbx,%r14,2),%ebp
 1003b00:	66 43 89 2c 72       	mov    %bp,(%r10,%r14,2)
 1003b05:	49 ff c6             	inc    %r14
 1003b08:	4d 39 c6             	cmp    %r8,%r14
 1003b0b:	7c ee                	jl     1003afb <_ZN7console7newlineEv+0x61>
 1003b0d:	48 ff c1             	inc    %rcx
 1003b10:	4d 01 da             	add    %r11,%r10
 1003b13:	4c 01 db             	add    %r11,%rbx
 1003b16:	4c 39 c9             	cmp    %r9,%rcx
 1003b19:	75 d9                	jne    1003af4 <_ZN7console7newlineEv+0x5a>
 1003b1b:	89 47 0c             	mov    %eax,0xc(%rdi)
 1003b1e:	89 c2                	mov    %eax,%edx
 1003b20:	48 63 47 18          	movslq 0x18(%rdi),%rax
 1003b24:	48 85 c0             	test   %rax,%rax
 1003b27:	7e 23                	jle    1003b4c <_ZN7console7newlineEv+0xb2>
 1003b29:	89 c6                	mov    %eax,%esi
 1003b2b:	48 63 4f 10          	movslq 0x10(%rdi),%rcx
 1003b2f:	48 01 c8             	add    %rcx,%rax
 1003b32:	0f af d6             	imul   %esi,%edx
 1003b35:	48 63 d2             	movslq %edx,%rdx
 1003b38:	48 01 d2             	add    %rdx,%rdx
 1003b3b:	48 03 17             	add    (%rdi),%rdx
 1003b3e:	66 c7 04 4a 00 00    	movw   $0x0,(%rdx,%rcx,2)
 1003b44:	48 ff c1             	inc    %rcx
 1003b47:	48 39 c1             	cmp    %rax,%rcx
 1003b4a:	7c f2                	jl     1003b3e <_ZN7console7newlineEv+0xa4>
 1003b4c:	5b                   	pop    %rbx
 1003b4d:	41 5e                	pop    %r14
 1003b4f:	5d                   	pop    %rbp
 1003b50:	c3                   	ret    
 1003b51:	cc                   	int3   

0000000001003b52 <_ZN7console7putcharEc>:
 1003b52:	85 f6                	test   %esi,%esi
 1003b54:	74 51                	je     1003ba7 <_ZN7console7putcharEc+0x55>
 1003b56:	83 fe 0a             	cmp    $0xa,%esi
 1003b59:	0f 84 3b ff ff ff    	je     1003a9a <_ZN7console7newlineEv>
 1003b5f:	83 fe 0d             	cmp    $0xd,%esi
 1003b62:	75 08                	jne    1003b6c <_ZN7console7putcharEc+0x1a>
 1003b64:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%rdi)
 1003b6b:	c3                   	ret    
 1003b6c:	8b 4f 08             	mov    0x8(%rdi),%ecx
 1003b6f:	40 0f be c6          	movsbl %sil,%eax
 1003b73:	0d 00 0f 00 00       	or     $0xf00,%eax
 1003b78:	48 8b 17             	mov    (%rdi),%rdx
 1003b7b:	8b 77 18             	mov    0x18(%rdi),%esi
 1003b7e:	44 8b 47 0c          	mov    0xc(%rdi),%r8d
 1003b82:	44 0f af c6          	imul   %esi,%r8d
 1003b86:	41 01 c8             	add    %ecx,%r8d
 1003b89:	4d 63 c0             	movslq %r8d,%r8
 1003b8c:	66 42 89 04 42       	mov    %ax,(%rdx,%r8,2)
 1003b91:	ff c1                	inc    %ecx
 1003b93:	89 4f 08             	mov    %ecx,0x8(%rdi)
 1003b96:	8b 47 10             	mov    0x10(%rdi),%eax
 1003b99:	01 c6                	add    %eax,%esi
 1003b9b:	39 f1                	cmp    %esi,%ecx
 1003b9d:	75 08                	jne    1003ba7 <_ZN7console7putcharEc+0x55>
 1003b9f:	89 47 08             	mov    %eax,0x8(%rdi)
 1003ba2:	e9 f3 fe ff ff       	jmp    1003a9a <_ZN7console7newlineEv>
 1003ba7:	c3                   	ret    

0000000001003ba8 <_Z7memmovePvS_m>:
 1003ba8:	48 85 d2             	test   %rdx,%rdx
 1003bab:	74 10                	je     1003bbd <_Z7memmovePvS_m+0x15>
 1003bad:	31 c0                	xor    %eax,%eax
 1003baf:	8a 0c 06             	mov    (%rsi,%rax,1),%cl
 1003bb2:	88 0c 07             	mov    %cl,(%rdi,%rax,1)
 1003bb5:	48 ff c0             	inc    %rax
 1003bb8:	48 39 c2             	cmp    %rax,%rdx
 1003bbb:	75 f2                	jne    1003baf <_Z7memmovePvS_m+0x7>
 1003bbd:	c3                   	ret    

0000000001003bbe <_Z8mem_initv>:
 1003bbe:	48 c7 04 25 20 00 11 	movq   $0x200000,0x110020
 1003bc5:	00 00 00 20 00 
 1003bca:	48 c7 04 25 30 00 11 	movq   $0x3fffff0,0x110030
 1003bd1:	00 f0 ff ff 03 
 1003bd6:	48 c7 04 25 28 00 11 	movq   $0x10,0x110028
 1003bdd:	00 10 00 00 00 
 1003be2:	48 c7 04 25 00 00 00 	movq   $0x3fffff8,0x4000000
 1003be9:	04 f8 ff ff 03 
 1003bee:	48 c7 04 25 08 00 00 	movq   $0x4000010,0x4000008
 1003bf5:	04 10 00 00 04 
 1003bfa:	48 c7 04 25 10 00 00 	movq   $0x0,0x4000010
 1003c01:	04 00 00 00 00 
 1003c06:	c3                   	ret    

0000000001003c07 <_Z8__mallocm>:
 1003c07:	48 83 c7 1f          	add    $0x1f,%rdi
 1003c0b:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
 1003c0f:	b9 10 00 00 00       	mov    $0x10,%ecx
 1003c14:	48 0f 45 cf          	cmovne %rdi,%rcx
 1003c18:	48 8b 14 25 00 00 00 	mov    0x4000000,%rdx
 1003c1f:	04 
 1003c20:	be 00 00 00 04       	mov    $0x4000000,%esi
 1003c25:	48 39 ca             	cmp    %rcx,%rdx
 1003c28:	73 09                	jae    1003c33 <_Z8__mallocm+0x2c>
 1003c2a:	48 8b 76 08          	mov    0x8(%rsi),%rsi
 1003c2e:	48 8b 16             	mov    (%rsi),%rdx
 1003c31:	eb f2                	jmp    1003c25 <_Z8__mallocm+0x1e>
 1003c33:	48 8b 46 08          	mov    0x8(%rsi),%rax
 1003c37:	48 89 d7             	mov    %rdx,%rdi
 1003c3a:	48 29 cf             	sub    %rcx,%rdi
 1003c3d:	48 83 ff 0f          	cmp    $0xf,%rdi
 1003c41:	77 0a                	ja     1003c4d <_Z8__mallocm+0x46>
 1003c43:	c5 f8 10 00          	vmovups (%rax),%xmm0
 1003c47:	c5 f8 11 06          	vmovups %xmm0,(%rsi)
 1003c4b:	eb 0d                	jmp    1003c5a <_Z8__mallocm+0x53>
 1003c4d:	48 89 3e             	mov    %rdi,(%rsi)
 1003c50:	48 c1 e7 04          	shl    $0x4,%rdi
 1003c54:	48 01 f8             	add    %rdi,%rax
 1003c57:	48 89 ca             	mov    %rcx,%rdx
 1003c5a:	48 89 10             	mov    %rdx,(%rax)
 1003c5d:	48 83 c0 10          	add    $0x10,%rax
 1003c61:	48 01 14 25 28 00 11 	add    %rdx,0x110028
 1003c68:	00 
 1003c69:	c3                   	ret    

0000000001003c6a <_Z16__malloc_trackedmPKci>:
 1003c6a:	48 83 c7 1f          	add    $0x1f,%rdi
 1003c6e:	48 83 e7 f0          	and    $0xfffffffffffffff0,%rdi
 1003c72:	b9 10 00 00 00       	mov    $0x10,%ecx
 1003c77:	48 0f 45 cf          	cmovne %rdi,%rcx
 1003c7b:	48 8b 14 25 00 00 00 	mov    0x4000000,%rdx
 1003c82:	04 
 1003c83:	be 00 00 00 04       	mov    $0x4000000,%esi
 1003c88:	48 39 ca             	cmp    %rcx,%rdx
 1003c8b:	73 09                	jae    1003c96 <_Z16__malloc_trackedmPKci+0x2c>
 1003c8d:	48 8b 76 08          	mov    0x8(%rsi),%rsi
 1003c91:	48 8b 16             	mov    (%rsi),%rdx
 1003c94:	eb f2                	jmp    1003c88 <_Z16__malloc_trackedmPKci+0x1e>
 1003c96:	48 8b 46 08          	mov    0x8(%rsi),%rax
 1003c9a:	48 89 d7             	mov    %rdx,%rdi
 1003c9d:	48 29 cf             	sub    %rcx,%rdi
 1003ca0:	48 83 ff 0f          	cmp    $0xf,%rdi
 1003ca4:	77 0a                	ja     1003cb0 <_Z16__malloc_trackedmPKci+0x46>
 1003ca6:	c5 f8 10 00          	vmovups (%rax),%xmm0
 1003caa:	c5 f8 11 06          	vmovups %xmm0,(%rsi)
 1003cae:	eb 0d                	jmp    1003cbd <_Z16__malloc_trackedmPKci+0x53>
 1003cb0:	48 89 3e             	mov    %rdi,(%rsi)
 1003cb3:	48 c1 e7 04          	shl    $0x4,%rdi
 1003cb7:	48 01 f8             	add    %rdi,%rax
 1003cba:	48 89 ca             	mov    %rcx,%rdx
 1003cbd:	48 89 10             	mov    %rdx,(%rax)
 1003cc0:	48 83 c0 10          	add    $0x10,%rax
 1003cc4:	48 01 14 25 28 00 11 	add    %rdx,0x110028
 1003ccb:	00 
 1003ccc:	c3                   	ret    

0000000001003ccd <_Z4freePv>:
 1003ccd:	48 85 ff             	test   %rdi,%rdi
 1003cd0:	74 2e                	je     1003d00 <_Z4freePv+0x33>
 1003cd2:	48 8d 47 f0          	lea    -0x10(%rdi),%rax
 1003cd6:	48 8b 4f f0          	mov    -0x10(%rdi),%rcx
 1003cda:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1003ce1:	00 04 
 1003ce3:	c5 f8 11 47 f0       	vmovups %xmm0,-0x10(%rdi)
 1003ce8:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1003cef:	04 
 1003cf0:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 1003cf7:	04 
 1003cf8:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1003cff:	00 
 1003d00:	c3                   	ret    

0000000001003d01 <_Znwm>:
 1003d01:	e9 64 ff ff ff       	jmp    1003c6a <_Z16__malloc_trackedmPKci>

0000000001003d06 <_Znam>:
 1003d06:	e9 5f ff ff ff       	jmp    1003c6a <_Z16__malloc_trackedmPKci>

0000000001003d0b <_ZdlPv>:
 1003d0b:	48 85 ff             	test   %rdi,%rdi
 1003d0e:	74 2e                	je     1003d3e <_ZdlPv+0x33>
 1003d10:	48 8d 47 f0          	lea    -0x10(%rdi),%rax
 1003d14:	48 8b 4f f0          	mov    -0x10(%rdi),%rcx
 1003d18:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1003d1f:	00 04 
 1003d21:	c5 f8 11 47 f0       	vmovups %xmm0,-0x10(%rdi)
 1003d26:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1003d2d:	04 
 1003d2e:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 1003d35:	04 
 1003d36:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1003d3d:	00 
 1003d3e:	c3                   	ret    

0000000001003d3f <_ZdlPvm>:
 1003d3f:	48 85 ff             	test   %rdi,%rdi
 1003d42:	74 2e                	je     1003d72 <_ZdlPvm+0x33>
 1003d44:	48 8d 47 f0          	lea    -0x10(%rdi),%rax
 1003d48:	48 8b 4f f0          	mov    -0x10(%rdi),%rcx
 1003d4c:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1003d53:	00 04 
 1003d55:	c5 f8 11 47 f0       	vmovups %xmm0,-0x10(%rdi)
 1003d5a:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1003d61:	04 
 1003d62:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 1003d69:	04 
 1003d6a:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1003d71:	00 
 1003d72:	c3                   	ret    

0000000001003d73 <_ZdaPv>:
 1003d73:	48 85 ff             	test   %rdi,%rdi
 1003d76:	74 2e                	je     1003da6 <_ZdaPv+0x33>
 1003d78:	48 8d 47 f0          	lea    -0x10(%rdi),%rax
 1003d7c:	48 8b 4f f0          	mov    -0x10(%rdi),%rcx
 1003d80:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1003d87:	00 04 
 1003d89:	c5 f8 11 47 f0       	vmovups %xmm0,-0x10(%rdi)
 1003d8e:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1003d95:	04 
 1003d96:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 1003d9d:	04 
 1003d9e:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1003da5:	00 
 1003da6:	c3                   	ret    

0000000001003da7 <_ZdaPvm>:
 1003da7:	48 85 ff             	test   %rdi,%rdi
 1003daa:	74 2e                	je     1003dda <_ZdaPvm+0x33>
 1003dac:	48 8d 47 f0          	lea    -0x10(%rdi),%rax
 1003db0:	48 8b 4f f0          	mov    -0x10(%rdi),%rcx
 1003db4:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1003dbb:	00 04 
 1003dbd:	c5 f8 11 47 f0       	vmovups %xmm0,-0x10(%rdi)
 1003dc2:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1003dc9:	04 
 1003dca:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 1003dd1:	04 
 1003dd2:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1003dd9:	00 
 1003dda:	c3                   	ret    
 1003ddb:	cc                   	int3   

0000000001003ddc <_ZN8rostringC1EPKcii>:
 1003ddc:	48 63 c1             	movslq %ecx,%rax
 1003ddf:	48 01 f0             	add    %rsi,%rax
 1003de2:	48 89 07             	mov    %rax,(%rdi)
 1003de5:	89 57 08             	mov    %edx,0x8(%rdi)
 1003de8:	c3                   	ret    
 1003de9:	cc                   	int3   

0000000001003dea <_ZN8rostringC1EPKc>:
 1003dea:	31 c0                	xor    %eax,%eax
 1003dec:	80 3c 06 00          	cmpb   $0x0,(%rsi,%rax,1)
 1003df0:	48 8d 40 01          	lea    0x1(%rax),%rax
 1003df4:	75 f6                	jne    1003dec <_ZN8rostringC1EPKc+0x2>
 1003df6:	ff c8                	dec    %eax
 1003df8:	48 89 37             	mov    %rsi,(%rdi)
 1003dfb:	89 47 08             	mov    %eax,0x8(%rdi)
 1003dfe:	c3                   	ret    
 1003dff:	cc                   	int3   

0000000001003e00 <_ZN8rostringC1ERKS_ii>:
 1003e00:	48 63 c1             	movslq %ecx,%rax
 1003e03:	48 03 06             	add    (%rsi),%rax
 1003e06:	48 89 07             	mov    %rax,(%rdi)
 1003e09:	89 57 08             	mov    %edx,0x8(%rdi)
 1003e0c:	c3                   	ret    
 1003e0d:	cc                   	int3   

0000000001003e0e <_ZN8rostringC1ERKS_>:
 1003e0e:	8b 46 08             	mov    0x8(%rsi),%eax
 1003e11:	48 8b 0e             	mov    (%rsi),%rcx
 1003e14:	48 89 0f             	mov    %rcx,(%rdi)
 1003e17:	89 47 08             	mov    %eax,0x8(%rdi)
 1003e1a:	c3                   	ret    
 1003e1b:	cc                   	int3   

0000000001003e1c <_ZN8rostringC1ERK6stringii>:
 1003e1c:	48 63 c1             	movslq %ecx,%rax
 1003e1f:	48 03 06             	add    (%rsi),%rax
 1003e22:	48 89 07             	mov    %rax,(%rdi)
 1003e25:	89 57 08             	mov    %edx,0x8(%rdi)
 1003e28:	c3                   	ret    
 1003e29:	cc                   	int3   

0000000001003e2a <_ZN8rostringC1ERK6string>:
 1003e2a:	8b 46 08             	mov    0x8(%rsi),%eax
 1003e2d:	48 8b 0e             	mov    (%rsi),%rcx
 1003e30:	48 89 0f             	mov    %rcx,(%rdi)
 1003e33:	89 47 08             	mov    %eax,0x8(%rdi)
 1003e36:	c3                   	ret    
 1003e37:	cc                   	int3   

0000000001003e38 <_ZN8rostringC1ERK4spanIcEii>:
 1003e38:	48 63 c1             	movslq %ecx,%rax
 1003e3b:	48 03 06             	add    (%rsi),%rax
 1003e3e:	48 89 07             	mov    %rax,(%rdi)
 1003e41:	89 57 08             	mov    %edx,0x8(%rdi)
 1003e44:	c3                   	ret    
 1003e45:	cc                   	int3   

0000000001003e46 <_ZN8rostringC1ERK4spanIcE>:
 1003e46:	8b 46 08             	mov    0x8(%rsi),%eax
 1003e49:	48 8b 0e             	mov    (%rsi),%rcx
 1003e4c:	48 89 0f             	mov    %rcx,(%rdi)
 1003e4f:	89 47 08             	mov    %eax,0x8(%rdi)
 1003e52:	c3                   	ret    
 1003e53:	cc                   	int3   

0000000001003e54 <_ZN6stringC1EPKcii>:
 1003e54:	48 63 c1             	movslq %ecx,%rax
 1003e57:	48 01 f0             	add    %rsi,%rax
 1003e5a:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 1003e5f:	89 54 24 f0          	mov    %edx,-0x10(%rsp)
 1003e63:	48 8b 74 24 f8       	mov    -0x8(%rsp),%rsi
 1003e68:	8b 54 24 f0          	mov    -0x10(%rsp),%edx
 1003e6c:	31 c9                	xor    %ecx,%ecx
 1003e6e:	e9 df 3e 00 00       	jmp    1007d52 <_ZN6vectorIcEC2EPKcii>
 1003e73:	cc                   	int3   

0000000001003e74 <_ZN6stringC1EPKc>:
 1003e74:	31 c0                	xor    %eax,%eax
 1003e76:	80 3c 06 00          	cmpb   $0x0,(%rsi,%rax,1)
 1003e7a:	48 8d 40 01          	lea    0x1(%rax),%rax
 1003e7e:	75 f6                	jne    1003e76 <_ZN6stringC1EPKc+0x2>
 1003e80:	ff c8                	dec    %eax
 1003e82:	48 89 74 24 f8       	mov    %rsi,-0x8(%rsp)
 1003e87:	89 44 24 f0          	mov    %eax,-0x10(%rsp)
 1003e8b:	48 8b 74 24 f8       	mov    -0x8(%rsp),%rsi
 1003e90:	8b 54 24 f0          	mov    -0x10(%rsp),%edx
 1003e94:	31 c9                	xor    %ecx,%ecx
 1003e96:	e9 b7 3e 00 00       	jmp    1007d52 <_ZN6vectorIcEC2EPKcii>
 1003e9b:	cc                   	int3   

0000000001003e9c <_ZN6stringC1ERKS_ii>:
 1003e9c:	48 63 c1             	movslq %ecx,%rax
 1003e9f:	48 03 06             	add    (%rsi),%rax
 1003ea2:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 1003ea7:	89 54 24 f0          	mov    %edx,-0x10(%rsp)
 1003eab:	48 8b 74 24 f8       	mov    -0x8(%rsp),%rsi
 1003eb0:	8b 54 24 f0          	mov    -0x10(%rsp),%edx
 1003eb4:	31 c9                	xor    %ecx,%ecx
 1003eb6:	e9 97 3e 00 00       	jmp    1007d52 <_ZN6vectorIcEC2EPKcii>
 1003ebb:	cc                   	int3   

0000000001003ebc <_ZN6stringC1ERKS_>:
 1003ebc:	8b 46 08             	mov    0x8(%rsi),%eax
 1003ebf:	48 8b 0e             	mov    (%rsi),%rcx
 1003ec2:	48 89 4c 24 f8       	mov    %rcx,-0x8(%rsp)
 1003ec7:	89 44 24 f0          	mov    %eax,-0x10(%rsp)
 1003ecb:	48 8b 74 24 f8       	mov    -0x8(%rsp),%rsi
 1003ed0:	8b 54 24 f0          	mov    -0x10(%rsp),%edx
 1003ed4:	31 c9                	xor    %ecx,%ecx
 1003ed6:	e9 77 3e 00 00       	jmp    1007d52 <_ZN6vectorIcEC2EPKcii>
 1003edb:	cc                   	int3   

0000000001003edc <_ZN6stringC1ERK4spanIcEii>:
 1003edc:	48 63 c1             	movslq %ecx,%rax
 1003edf:	48 03 06             	add    (%rsi),%rax
 1003ee2:	48 89 44 24 f8       	mov    %rax,-0x8(%rsp)
 1003ee7:	89 54 24 f0          	mov    %edx,-0x10(%rsp)
 1003eeb:	48 8b 74 24 f8       	mov    -0x8(%rsp),%rsi
 1003ef0:	8b 54 24 f0          	mov    -0x10(%rsp),%edx
 1003ef4:	31 c9                	xor    %ecx,%ecx
 1003ef6:	e9 57 3e 00 00       	jmp    1007d52 <_ZN6vectorIcEC2EPKcii>
 1003efb:	cc                   	int3   

0000000001003efc <_ZN6stringC1ERK4spanIcE>:
 1003efc:	8b 46 08             	mov    0x8(%rsi),%eax
 1003eff:	48 8b 0e             	mov    (%rsi),%rcx
 1003f02:	48 89 4c 24 f8       	mov    %rcx,-0x8(%rsp)
 1003f07:	89 44 24 f0          	mov    %eax,-0x10(%rsp)
 1003f0b:	48 8b 74 24 f8       	mov    -0x8(%rsp),%rsi
 1003f10:	8b 54 24 f0          	mov    -0x10(%rsp),%edx
 1003f14:	31 c9                	xor    %ecx,%ecx
 1003f16:	e9 37 3e 00 00       	jmp    1007d52 <_ZN6vectorIcEC2EPKcii>
 1003f1b:	cc                   	int3   

0000000001003f1c <_ZN6string9c_str_newEv>:
 1003f1c:	e9 01 00 00 00       	jmp    1003f22 <_ZNK6vectorIcE5c_arrEv>
 1003f21:	cc                   	int3   

0000000001003f22 <_ZNK6vectorIcE5c_arrEv>:
 1003f22:	53                   	push   %rbx
 1003f23:	48 89 fb             	mov    %rdi,%rbx
 1003f26:	48 63 7f 08          	movslq 0x8(%rdi),%rdi
 1003f2a:	e8 3b fd ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1003f2f:	83 7b 08 00          	cmpl   $0x0,0x8(%rbx)
 1003f33:	7e 19                	jle    1003f4e <_ZNK6vectorIcE5c_arrEv+0x2c>
 1003f35:	48 8b 0b             	mov    (%rbx),%rcx
 1003f38:	31 d2                	xor    %edx,%edx
 1003f3a:	40 8a 34 11          	mov    (%rcx,%rdx,1),%sil
 1003f3e:	40 88 34 10          	mov    %sil,(%rax,%rdx,1)
 1003f42:	48 ff c2             	inc    %rdx
 1003f45:	48 63 73 08          	movslq 0x8(%rbx),%rsi
 1003f49:	48 39 f2             	cmp    %rsi,%rdx
 1003f4c:	7c ec                	jl     1003f3a <_ZNK6vectorIcE5c_arrEv+0x18>
 1003f4e:	5b                   	pop    %rbx
 1003f4f:	c3                   	ret    

0000000001003f50 <_ZN13ostringstream8write_bzEPKvi>:
 1003f50:	85 d2                	test   %edx,%edx
 1003f52:	7e 37                	jle    1003f8b <_ZN13ostringstream8write_bzEPKvi+0x3b>
 1003f54:	55                   	push   %rbp
 1003f55:	41 57                	push   %r15
 1003f57:	41 56                	push   %r14
 1003f59:	41 54                	push   %r12
 1003f5b:	53                   	push   %rbx
 1003f5c:	48 89 f3             	mov    %rsi,%rbx
 1003f5f:	49 89 fe             	mov    %rdi,%r14
 1003f62:	41 89 d7             	mov    %edx,%r15d
 1003f65:	45 31 e4             	xor    %r12d,%r12d
 1003f68:	42 8a 2c 23          	mov    (%rbx,%r12,1),%bpl
 1003f6c:	41 8b 76 08          	mov    0x8(%r14),%esi
 1003f70:	4c 89 f7             	mov    %r14,%rdi
 1003f73:	e8 28 3e 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 1003f78:	40 88 28             	mov    %bpl,(%rax)
 1003f7b:	49 ff c4             	inc    %r12
 1003f7e:	4d 39 e7             	cmp    %r12,%r15
 1003f81:	75 e5                	jne    1003f68 <_ZN13ostringstream8write_bzEPKvi+0x18>
 1003f83:	5b                   	pop    %rbx
 1003f84:	41 5c                	pop    %r12
 1003f86:	41 5e                	pop    %r14
 1003f88:	41 5f                	pop    %r15
 1003f8a:	5d                   	pop    %rbp
 1003f8b:	c3                   	ret    

0000000001003f8c <_ZN13ostringstream5writeIcEEvT_>:
 1003f8c:	53                   	push   %rbx
 1003f8d:	89 f3                	mov    %esi,%ebx
 1003f8f:	8b 77 08             	mov    0x8(%rdi),%esi
 1003f92:	e8 09 3e 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 1003f97:	88 18                	mov    %bl,(%rax)
 1003f99:	5b                   	pop    %rbx
 1003f9a:	c3                   	ret    
 1003f9b:	cc                   	int3   

0000000001003f9c <_ZN13ostringstream5writeIPKcEEvT_>:
 1003f9c:	55                   	push   %rbp
 1003f9d:	41 57                	push   %r15
 1003f9f:	41 56                	push   %r14
 1003fa1:	41 54                	push   %r12
 1003fa3:	53                   	push   %rbx
 1003fa4:	48 89 f3             	mov    %rsi,%rbx
 1003fa7:	49 89 fe             	mov    %rdi,%r14
 1003faa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1003faf:	48 89 f1             	mov    %rsi,%rcx
 1003fb2:	ff c0                	inc    %eax
 1003fb4:	80 39 00             	cmpb   $0x0,(%rcx)
 1003fb7:	48 8d 49 01          	lea    0x1(%rcx),%rcx
 1003fbb:	75 f5                	jne    1003fb2 <_ZN13ostringstream5writeIPKcEEvT_+0x16>
 1003fbd:	85 c0                	test   %eax,%eax
 1003fbf:	7e 21                	jle    1003fe2 <_ZN13ostringstream5writeIPKcEEvT_+0x46>
 1003fc1:	41 89 c7             	mov    %eax,%r15d
 1003fc4:	45 31 e4             	xor    %r12d,%r12d
 1003fc7:	42 8a 2c 23          	mov    (%rbx,%r12,1),%bpl
 1003fcb:	41 8b 76 08          	mov    0x8(%r14),%esi
 1003fcf:	4c 89 f7             	mov    %r14,%rdi
 1003fd2:	e8 c9 3d 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 1003fd7:	40 88 28             	mov    %bpl,(%rax)
 1003fda:	49 ff c4             	inc    %r12
 1003fdd:	4d 39 e7             	cmp    %r12,%r15
 1003fe0:	75 e5                	jne    1003fc7 <_ZN13ostringstream5writeIPKcEEvT_+0x2b>
 1003fe2:	5b                   	pop    %rbx
 1003fe3:	41 5c                	pop    %r12
 1003fe5:	41 5e                	pop    %r14
 1003fe7:	41 5f                	pop    %r15
 1003fe9:	5d                   	pop    %rbp
 1003fea:	c3                   	ret    
 1003feb:	cc                   	int3   

0000000001003fec <_ZN13ostringstream5writeI8rostringEEvT_>:
 1003fec:	55                   	push   %rbp
 1003fed:	41 57                	push   %r15
 1003fef:	41 56                	push   %r14
 1003ff1:	41 54                	push   %r12
 1003ff3:	53                   	push   %rbx
 1003ff4:	4c 8b 36             	mov    (%rsi),%r14
 1003ff7:	44 8b 7e 08          	mov    0x8(%rsi),%r15d
 1003ffb:	45 85 ff             	test   %r15d,%r15d
 1003ffe:	7e 20                	jle    1004020 <_ZN13ostringstream5writeI8rostringEEvT_+0x34>
 1004000:	48 89 fb             	mov    %rdi,%rbx
 1004003:	45 31 e4             	xor    %r12d,%r12d
 1004006:	43 8a 2c 26          	mov    (%r14,%r12,1),%bpl
 100400a:	8b 73 08             	mov    0x8(%rbx),%esi
 100400d:	48 89 df             	mov    %rbx,%rdi
 1004010:	e8 8b 3d 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 1004015:	40 88 28             	mov    %bpl,(%rax)
 1004018:	49 ff c4             	inc    %r12
 100401b:	4d 39 e7             	cmp    %r12,%r15
 100401e:	75 e6                	jne    1004006 <_ZN13ostringstream5writeI8rostringEEvT_+0x1a>
 1004020:	5b                   	pop    %rbx
 1004021:	41 5c                	pop    %r12
 1004023:	41 5e                	pop    %r14
 1004025:	41 5f                	pop    %r15
 1004027:	5d                   	pop    %rbp
 1004028:	c3                   	ret    
 1004029:	cc                   	int3   

000000000100402a <_ZN13ostringstream5writeI6stringEEvT_>:
 100402a:	48 83 ec 18          	sub    $0x18,%rsp
 100402e:	8b 46 08             	mov    0x8(%rsi),%eax
 1004031:	48 8b 0e             	mov    (%rsi),%rcx
 1004034:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 1004039:	48 89 0e             	mov    %rcx,(%rsi)
 100403c:	89 46 08             	mov    %eax,0x8(%rsi)
 100403f:	e8 a8 ff ff ff       	call   1003fec <_ZN13ostringstream5writeI8rostringEEvT_>
 1004044:	48 83 c4 18          	add    $0x18,%rsp
 1004048:	c3                   	ret    
 1004049:	cc                   	int3   

000000000100404a <_ZN13ostringstream5writeIlEEvT_>:
 100404a:	41 b9 40 84 00 01    	mov    $0x1008440,%r9d
 1004050:	31 d2                	xor    %edx,%edx
 1004052:	b9 0a 00 00 00       	mov    $0xa,%ecx
 1004057:	41 b8 20 00 00 00    	mov    $0x20,%r8d
 100405d:	e9 00 00 00 00       	jmp    1004062 <_ZN13ostringstream7write_iEliicPKc>

0000000001004062 <_ZN13ostringstream7write_iEliicPKc>:
 1004062:	55                   	push   %rbp
 1004063:	41 57                	push   %r15
 1004065:	41 56                	push   %r14
 1004067:	41 55                	push   %r13
 1004069:	41 54                	push   %r12
 100406b:	53                   	push   %rbx
 100406c:	50                   	push   %rax
 100406d:	4c 89 cb             	mov    %r9,%rbx
 1004070:	45 89 c7             	mov    %r8d,%r15d
 1004073:	89 cd                	mov    %ecx,%ebp
 1004075:	41 89 d6             	mov    %edx,%r14d
 1004078:	49 89 f4             	mov    %rsi,%r12
 100407b:	49 89 fd             	mov    %rdi,%r13
 100407e:	48 85 f6             	test   %rsi,%rsi
 1004081:	79 12                	jns    1004095 <_ZN13ostringstream7write_iEliicPKc+0x33>
 1004083:	49 f7 dc             	neg    %r12
 1004086:	41 8b 75 08          	mov    0x8(%r13),%esi
 100408a:	4c 89 ef             	mov    %r13,%rdi
 100408d:	e8 0e 3d 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 1004092:	c6 00 2d             	movb   $0x2d,(%rax)
 1004095:	45 0f be c7          	movsbl %r15b,%r8d
 1004099:	4c 89 ef             	mov    %r13,%rdi
 100409c:	4c 89 e6             	mov    %r12,%rsi
 100409f:	44 89 f2             	mov    %r14d,%edx
 10040a2:	89 e9                	mov    %ebp,%ecx
 10040a4:	49 89 d9             	mov    %rbx,%r9
 10040a7:	48 83 c4 08          	add    $0x8,%rsp
 10040ab:	5b                   	pop    %rbx
 10040ac:	41 5c                	pop    %r12
 10040ae:	41 5d                	pop    %r13
 10040b0:	41 5e                	pop    %r14
 10040b2:	41 5f                	pop    %r15
 10040b4:	5d                   	pop    %rbp
 10040b5:	e9 52 03 00 00       	jmp    100440c <_ZN13ostringstream7write_uEmiicPKc>

00000000010040ba <_ZN13ostringstream5writeIdEEvT_>:
 10040ba:	31 f6                	xor    %esi,%esi
 10040bc:	ba 03 00 00 00       	mov    $0x3,%edx
 10040c1:	b9 20 00 00 00       	mov    $0x20,%ecx
 10040c6:	e9 01 00 00 00       	jmp    10040cc <_ZN13ostringstream7write_dEdiic>
 10040cb:	cc                   	int3   

00000000010040cc <_ZN13ostringstream7write_dEdiic>:
 10040cc:	55                   	push   %rbp
 10040cd:	41 57                	push   %r15
 10040cf:	41 56                	push   %r14
 10040d1:	41 54                	push   %r12
 10040d3:	53                   	push   %rbx
 10040d4:	48 83 ec 50          	sub    $0x50,%rsp
 10040d8:	41 89 ce             	mov    %ecx,%r14d
 10040db:	48 89 fb             	mov    %rdi,%rbx
 10040de:	c4 e1 f9 7e c0       	vmovq  %xmm0,%rax
 10040e3:	48 b9 00 00 00 00 00 	movabs $0x7ff0000000000000,%rcx
 10040ea:	00 f0 7f 
 10040ed:	c4 e2 f8 f2 c1       	andn   %rcx,%rax,%rax
 10040f2:	75 19                	jne    100410d <_ZN13ostringstream7write_dEdiic+0x41>
 10040f4:	be f0 87 00 01       	mov    $0x10087f0,%esi
 10040f9:	48 89 df             	mov    %rbx,%rdi
 10040fc:	48 83 c4 50          	add    $0x50,%rsp
 1004100:	5b                   	pop    %rbx
 1004101:	41 5c                	pop    %r12
 1004103:	41 5e                	pop    %r14
 1004105:	41 5f                	pop    %r15
 1004107:	5d                   	pop    %rbp
 1004108:	e9 8f fe ff ff       	jmp    1003f9c <_ZN13ostringstream5writeIPKcEEvT_>
 100410d:	89 d5                	mov    %edx,%ebp
 100410f:	41 89 f7             	mov    %esi,%r15d
 1004112:	c5 f1 57 c9          	vxorpd %xmm1,%xmm1,%xmm1
 1004116:	c5 f9 2e c8          	vucomisd %xmm0,%xmm1
 100411a:	76 2a                	jbe    1004146 <_ZN13ostringstream7write_dEdiic+0x7a>
 100411c:	c5 fb 12 0d 7c 41 00 	vmovddup 0x417c(%rip),%xmm1        # 10082a0 <_ZL4lfsr+0x160>
 1004123:	00 
 1004124:	c5 f9 57 c1          	vxorpd %xmm1,%xmm0,%xmm0
 1004128:	c5 f9 29 44 24 40    	vmovapd %xmm0,0x40(%rsp)
 100412e:	8b 73 08             	mov    0x8(%rbx),%esi
 1004131:	48 89 df             	mov    %rbx,%rdi
 1004134:	e8 67 3c 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 1004139:	c5 f1 57 c9          	vxorpd %xmm1,%xmm1,%xmm1
 100413d:	c5 f9 28 44 24 40    	vmovapd 0x40(%rsp),%xmm0
 1004143:	c6 00 2d             	movb   $0x2d,(%rax)
 1004146:	31 c0                	xor    %eax,%eax
 1004148:	c5 f9 29 44 24 40    	vmovapd %xmm0,0x40(%rsp)
 100414e:	c5 fb 5e 05 3a 41 00 	vdivsd 0x413a(%rip),%xmm0,%xmm0        # 1008290 <_ZL4lfsr+0x150>
 1004155:	00 
 1004156:	ff c0                	inc    %eax
 1004158:	c5 f9 2e c1          	vucomisd %xmm1,%xmm0
 100415c:	77 f0                	ja     100414e <_ZN13ostringstream7write_dEdiic+0x82>
 100415e:	41 29 c7             	sub    %eax,%r15d
 1004161:	7e 1f                	jle    1004182 <_ZN13ostringstream7write_dEdiic+0xb6>
 1004163:	41 ff c7             	inc    %r15d
 1004166:	41 bc 01 00 00 00    	mov    $0x1,%r12d
 100416c:	8b 73 08             	mov    0x8(%rbx),%esi
 100416f:	48 89 df             	mov    %rbx,%rdi
 1004172:	e8 29 3c 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 1004177:	44 88 30             	mov    %r14b,(%rax)
 100417a:	41 ff c4             	inc    %r12d
 100417d:	45 39 e7             	cmp    %r12d,%r15d
 1004180:	75 ea                	jne    100416c <_ZN13ostringstream7write_dEdiic+0xa0>
 1004182:	c5 f9 57 c0          	vxorpd %xmm0,%xmm0,%xmm0
 1004186:	4c 8d 74 24 20       	lea    0x20(%rsp),%r14
 100418b:	c4 c1 79 11 06       	vmovupd %xmm0,(%r14)
 1004190:	c5 f9 28 4c 24 40    	vmovapd 0x40(%rsp),%xmm1
 1004196:	c5 fb 11 4c 24 18    	vmovsd %xmm1,0x18(%rsp)
 100419c:	c5 fb 2c c1          	vcvttsd2si %xmm1,%eax
 10041a0:	48 98                	cltq   
 10041a2:	48 69 c8 67 66 66 66 	imul   $0x66666667,%rax,%rcx
 10041a9:	48 89 ca             	mov    %rcx,%rdx
 10041ac:	48 c1 ea 3f          	shr    $0x3f,%rdx
 10041b0:	48 c1 f9 22          	sar    $0x22,%rcx
 10041b4:	01 d1                	add    %edx,%ecx
 10041b6:	01 c9                	add    %ecx,%ecx
 10041b8:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
 10041bb:	29 c8                	sub    %ecx,%eax
 10041bd:	04 30                	add    $0x30,%al
 10041bf:	0f be f0             	movsbl %al,%esi
 10041c2:	4c 89 f7             	mov    %r14,%rdi
 10041c5:	31 d2                	xor    %edx,%edx
 10041c7:	e8 38 04 00 00       	call   1004604 <_ZN6vectorIcE6insertEci>
 10041cc:	c5 fb 10 4c 24 18    	vmovsd 0x18(%rsp),%xmm1
 10041d2:	c5 f3 5e 0d b6 40 00 	vdivsd 0x40b6(%rip),%xmm1,%xmm1        # 1008290 <_ZL4lfsr+0x150>
 10041d9:	00 
 10041da:	c5 fb 2c c1          	vcvttsd2si %xmm1,%eax
 10041de:	85 c0                	test   %eax,%eax
 10041e0:	7f b4                	jg     1004196 <_ZN13ostringstream7write_dEdiic+0xca>
 10041e2:	8b 44 24 28          	mov    0x28(%rsp),%eax
 10041e6:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 10041eb:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
 10041f0:	89 04 24             	mov    %eax,(%rsp)
 10041f3:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
 10041f8:	4c 63 3c 24          	movslq (%rsp),%r15
 10041fc:	44 89 7c 24 10       	mov    %r15d,0x10(%rsp)
 1004201:	4c 89 ff             	mov    %r15,%rdi
 1004204:	e8 61 fa ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1004209:	49 89 c6             	mov    %rax,%r14
 100420c:	4d 85 ff             	test   %r15,%r15
 100420f:	7e 12                	jle    1004223 <_ZN13ostringstream7write_dEdiic+0x157>
 1004211:	31 c0                	xor    %eax,%eax
 1004213:	41 8a 0c 04          	mov    (%r12,%rax,1),%cl
 1004217:	41 88 0c 06          	mov    %cl,(%r14,%rax,1)
 100421b:	48 ff c0             	inc    %rax
 100421e:	49 39 c7             	cmp    %rax,%r15
 1004221:	75 f0                	jne    1004213 <_ZN13ostringstream7write_dEdiic+0x147>
 1004223:	8b 44 24 10          	mov    0x10(%rsp),%eax
 1004227:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
 100422c:	4c 89 36             	mov    %r14,(%rsi)
 100422f:	89 46 08             	mov    %eax,0x8(%rsi)
 1004232:	48 89 df             	mov    %rbx,%rdi
 1004235:	e8 b2 fd ff ff       	call   1003fec <_ZN13ostringstream5writeI8rostringEEvT_>
 100423a:	4d 85 f6             	test   %r14,%r14
 100423d:	74 32                	je     1004271 <_ZN13ostringstream7write_dEdiic+0x1a5>
 100423f:	4c 89 f0             	mov    %r14,%rax
 1004242:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
 1004246:	49 8b 4e f0          	mov    -0x10(%r14),%rcx
 100424a:	c5 f9 10 04 25 00 00 	vmovupd 0x4000000,%xmm0
 1004251:	00 04 
 1004253:	c4 c1 79 11 46 f0    	vmovupd %xmm0,-0x10(%r14)
 1004259:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1004260:	04 
 1004261:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 1004268:	04 
 1004269:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1004270:	00 
 1004271:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
 1004278:	00 
 1004279:	85 ed                	test   %ebp,%ebp
 100427b:	0f 8e 45 01 00 00    	jle    10043c6 <_ZN13ostringstream7write_dEdiic+0x2fa>
 1004281:	8b 73 08             	mov    0x8(%rbx),%esi
 1004284:	48 89 df             	mov    %rbx,%rdi
 1004287:	e8 14 3b 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 100428c:	c6 00 2e             	movb   $0x2e,(%rax)
 100428f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 1004294:	48 85 c0             	test   %rax,%rax
 1004297:	74 2e                	je     10042c7 <_ZN13ostringstream7write_dEdiic+0x1fb>
 1004299:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 100429d:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10042a1:	c5 f9 10 04 25 00 00 	vmovupd 0x4000000,%xmm0
 10042a8:	00 04 
 10042aa:	c5 f9 11 40 f0       	vmovupd %xmm0,-0x10(%rax)
 10042af:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10042b6:	04 
 10042b7:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10042be:	04 
 10042bf:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10042c6:	00 
 10042c7:	c5 f9 57 c0          	vxorpd %xmm0,%xmm0,%xmm0
 10042cb:	4c 8d 74 24 20       	lea    0x20(%rsp),%r14
 10042d0:	c4 c1 79 11 06       	vmovupd %xmm0,(%r14)
 10042d5:	c5 f9 28 4c 24 40    	vmovapd 0x40(%rsp),%xmm1
 10042db:	c5 f9 e6 c1          	vcvttpd2dq %xmm1,%xmm0
 10042df:	c5 fa e6 c0          	vcvtdq2pd %xmm0,%xmm0
 10042e3:	c5 f3 5c c8          	vsubsd %xmm0,%xmm1,%xmm1
 10042e7:	c5 f3 59 0d a1 3f 00 	vmulsd 0x3fa1(%rip),%xmm1,%xmm1        # 1008290 <_ZL4lfsr+0x150>
 10042ee:	00 
 10042ef:	c5 fb 11 4c 24 18    	vmovsd %xmm1,0x18(%rsp)
 10042f5:	c5 fb 2c c1          	vcvttsd2si %xmm1,%eax
 10042f9:	48 98                	cltq   
 10042fb:	48 69 c8 67 66 66 66 	imul   $0x66666667,%rax,%rcx
 1004302:	48 89 ca             	mov    %rcx,%rdx
 1004305:	48 c1 ea 3f          	shr    $0x3f,%rdx
 1004309:	48 c1 f9 22          	sar    $0x22,%rcx
 100430d:	01 d1                	add    %edx,%ecx
 100430f:	01 c9                	add    %ecx,%ecx
 1004311:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
 1004314:	29 c8                	sub    %ecx,%eax
 1004316:	04 30                	add    $0x30,%al
 1004318:	0f be f0             	movsbl %al,%esi
 100431b:	4c 89 f7             	mov    %r14,%rdi
 100431e:	31 d2                	xor    %edx,%edx
 1004320:	e8 df 02 00 00       	call   1004604 <_ZN6vectorIcE6insertEci>
 1004325:	c5 fb 10 4c 24 18    	vmovsd 0x18(%rsp),%xmm1
 100432b:	ff cd                	dec    %ebp
 100432d:	75 b8                	jne    10042e7 <_ZN13ostringstream7write_dEdiic+0x21b>
 100432f:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 1004334:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
 1004338:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 100433d:	89 0c 24             	mov    %ecx,(%rsp)
 1004340:	4c 8b 64 24 30       	mov    0x30(%rsp),%r12
 1004345:	4c 63 3c 24          	movslq (%rsp),%r15
 1004349:	44 89 7c 24 08       	mov    %r15d,0x8(%rsp)
 100434e:	4c 89 ff             	mov    %r15,%rdi
 1004351:	e8 14 f9 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1004356:	49 89 c6             	mov    %rax,%r14
 1004359:	4d 85 ff             	test   %r15,%r15
 100435c:	7e 12                	jle    1004370 <_ZN13ostringstream7write_dEdiic+0x2a4>
 100435e:	31 c0                	xor    %eax,%eax
 1004360:	41 8a 0c 04          	mov    (%r12,%rax,1),%cl
 1004364:	41 88 0c 06          	mov    %cl,(%r14,%rax,1)
 1004368:	48 ff c0             	inc    %rax
 100436b:	49 39 c7             	cmp    %rax,%r15
 100436e:	75 f0                	jne    1004360 <_ZN13ostringstream7write_dEdiic+0x294>
 1004370:	8b 44 24 08          	mov    0x8(%rsp),%eax
 1004374:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
 1004379:	4c 89 36             	mov    %r14,(%rsi)
 100437c:	89 46 08             	mov    %eax,0x8(%rsi)
 100437f:	48 89 df             	mov    %rbx,%rdi
 1004382:	e8 65 fc ff ff       	call   1003fec <_ZN13ostringstream5writeI8rostringEEvT_>
 1004387:	4d 85 f6             	test   %r14,%r14
 100438a:	74 32                	je     10043be <_ZN13ostringstream7write_dEdiic+0x2f2>
 100438c:	4c 89 f0             	mov    %r14,%rax
 100438f:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
 1004393:	49 8b 4e f0          	mov    -0x10(%r14),%rcx
 1004397:	c5 f9 10 04 25 00 00 	vmovupd 0x4000000,%xmm0
 100439e:	00 04 
 10043a0:	c4 c1 79 11 46 f0    	vmovupd %xmm0,-0x10(%r14)
 10043a6:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 10043ad:	04 
 10043ae:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 10043b5:	04 
 10043b6:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 10043bd:	00 
 10043be:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
 10043c5:	00 
 10043c6:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 10043cb:	48 85 c0             	test   %rax,%rax
 10043ce:	74 2e                	je     10043fe <_ZN13ostringstream7write_dEdiic+0x332>
 10043d0:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10043d4:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10043d8:	c5 f9 10 04 25 00 00 	vmovupd 0x4000000,%xmm0
 10043df:	00 04 
 10043e1:	c5 f9 11 40 f0       	vmovupd %xmm0,-0x10(%rax)
 10043e6:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10043ed:	04 
 10043ee:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10043f5:	04 
 10043f6:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10043fd:	00 
 10043fe:	48 83 c4 50          	add    $0x50,%rsp
 1004402:	5b                   	pop    %rbx
 1004403:	41 5c                	pop    %r12
 1004405:	41 5e                	pop    %r14
 1004407:	41 5f                	pop    %r15
 1004409:	5d                   	pop    %rbp
 100440a:	c3                   	ret    
 100440b:	cc                   	int3   

000000000100440c <_ZN13ostringstream7write_uEmiicPKc>:
 100440c:	55                   	push   %rbp
 100440d:	41 57                	push   %r15
 100440f:	41 56                	push   %r14
 1004411:	41 55                	push   %r13
 1004413:	41 54                	push   %r12
 1004415:	53                   	push   %rbx
 1004416:	48 83 ec 38          	sub    $0x38,%rsp
 100441a:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
 100441f:	45 89 c5             	mov    %r8d,%r13d
 1004422:	41 89 d1             	mov    %edx,%r9d
 1004425:	49 89 f7             	mov    %rsi,%r15
 1004428:	49 89 fe             	mov    %rdi,%r14
 100442b:	48 63 e9             	movslq %ecx,%rbp
 100442e:	45 31 e4             	xor    %r12d,%r12d
 1004431:	48 89 f0             	mov    %rsi,%rax
 1004434:	31 d2                	xor    %edx,%edx
 1004436:	48 f7 f5             	div    %rbp
 1004439:	41 ff c4             	inc    %r12d
 100443c:	48 39 ee             	cmp    %rbp,%rsi
 100443f:	48 89 c6             	mov    %rax,%rsi
 1004442:	73 ed                	jae    1004431 <_ZN13ostringstream7write_uEmiicPKc+0x25>
 1004444:	45 29 e1             	sub    %r12d,%r9d
 1004447:	7e 24                	jle    100446d <_ZN13ostringstream7write_uEmiicPKc+0x61>
 1004449:	41 8d 41 01          	lea    0x1(%r9),%eax
 100444d:	89 44 24 0c          	mov    %eax,0xc(%rsp)
 1004451:	bb 01 00 00 00       	mov    $0x1,%ebx
 1004456:	41 8b 76 08          	mov    0x8(%r14),%esi
 100445a:	4c 89 f7             	mov    %r14,%rdi
 100445d:	e8 3e 39 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 1004462:	44 88 28             	mov    %r13b,(%rax)
 1004465:	ff c3                	inc    %ebx
 1004467:	39 5c 24 0c          	cmp    %ebx,0xc(%rsp)
 100446b:	75 e9                	jne    1004456 <_ZN13ostringstream7write_uEmiicPKc+0x4a>
 100446d:	4c 89 f3             	mov    %r14,%rbx
 1004470:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 1004474:	4c 8d 6c 24 18       	lea    0x18(%rsp),%r13
 1004479:	c4 c1 78 11 45 00    	vmovups %xmm0,0x0(%r13)
 100447f:	4c 89 ef             	mov    %r13,%rdi
 1004482:	44 89 e6             	mov    %r12d,%esi
 1004485:	e8 04 01 00 00       	call   100458e <_ZN6vectorIcE7reserveEi>
 100448a:	4c 8b 74 24 10       	mov    0x10(%rsp),%r14
 100448f:	4c 89 f8             	mov    %r15,%rax
 1004492:	31 d2                	xor    %edx,%edx
 1004494:	48 f7 f5             	div    %rbp
 1004497:	49 89 c4             	mov    %rax,%r12
 100449a:	41 0f be 34 16       	movsbl (%r14,%rdx,1),%esi
 100449f:	4c 89 ef             	mov    %r13,%rdi
 10044a2:	31 d2                	xor    %edx,%edx
 10044a4:	e8 5b 01 00 00       	call   1004604 <_ZN6vectorIcE6insertEci>
 10044a9:	49 39 ef             	cmp    %rbp,%r15
 10044ac:	4d 89 e7             	mov    %r12,%r15
 10044af:	73 de                	jae    100448f <_ZN13ostringstream7write_uEmiicPKc+0x83>
 10044b1:	8b 44 24 20          	mov    0x20(%rsp),%eax
 10044b5:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 10044ba:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
 10044bf:	89 44 24 08          	mov    %eax,0x8(%rsp)
 10044c3:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
 10044c8:	4c 63 7c 24 08       	movslq 0x8(%rsp),%r15
 10044cd:	44 89 3c 24          	mov    %r15d,(%rsp)
 10044d1:	4c 89 ff             	mov    %r15,%rdi
 10044d4:	e8 91 f7 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 10044d9:	49 89 c6             	mov    %rax,%r14
 10044dc:	4d 85 ff             	test   %r15,%r15
 10044df:	7e 12                	jle    10044f3 <_ZN13ostringstream7write_uEmiicPKc+0xe7>
 10044e1:	31 c0                	xor    %eax,%eax
 10044e3:	41 8a 0c 04          	mov    (%r12,%rax,1),%cl
 10044e7:	41 88 0c 06          	mov    %cl,(%r14,%rax,1)
 10044eb:	48 ff c0             	inc    %rax
 10044ee:	49 39 c7             	cmp    %rax,%r15
 10044f1:	75 f0                	jne    10044e3 <_ZN13ostringstream7write_uEmiicPKc+0xd7>
 10044f3:	8b 04 24             	mov    (%rsp),%eax
 10044f6:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
 10044fb:	4c 89 36             	mov    %r14,(%rsi)
 10044fe:	89 46 08             	mov    %eax,0x8(%rsi)
 1004501:	48 89 df             	mov    %rbx,%rdi
 1004504:	e8 e3 fa ff ff       	call   1003fec <_ZN13ostringstream5writeI8rostringEEvT_>
 1004509:	4d 85 f6             	test   %r14,%r14
 100450c:	74 32                	je     1004540 <_ZN13ostringstream7write_uEmiicPKc+0x134>
 100450e:	4c 89 f0             	mov    %r14,%rax
 1004511:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
 1004515:	49 8b 4e f0          	mov    -0x10(%r14),%rcx
 1004519:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1004520:	00 04 
 1004522:	c4 c1 78 11 46 f0    	vmovups %xmm0,-0x10(%r14)
 1004528:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 100452f:	04 
 1004530:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 1004537:	04 
 1004538:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 100453f:	00 
 1004540:	c7 04 24 00 00 00 00 	movl   $0x0,(%rsp)
 1004547:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
 100454c:	48 85 c0             	test   %rax,%rax
 100454f:	74 2e                	je     100457f <_ZN13ostringstream7write_uEmiicPKc+0x173>
 1004551:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1004555:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1004559:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1004560:	00 04 
 1004562:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1004567:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 100456e:	04 
 100456f:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1004576:	04 
 1004577:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 100457e:	00 
 100457f:	48 83 c4 38          	add    $0x38,%rsp
 1004583:	5b                   	pop    %rbx
 1004584:	41 5c                	pop    %r12
 1004586:	41 5d                	pop    %r13
 1004588:	41 5e                	pop    %r14
 100458a:	41 5f                	pop    %r15
 100458c:	5d                   	pop    %rbp
 100458d:	c3                   	ret    

000000000100458e <_ZN6vectorIcE7reserveEi>:
 100458e:	39 77 0c             	cmp    %esi,0xc(%rdi)
 1004591:	7d 6f                	jge    1004602 <_ZN6vectorIcE7reserveEi+0x74>
 1004593:	41 56                	push   %r14
 1004595:	53                   	push   %rbx
 1004596:	50                   	push   %rax
 1004597:	89 f3                	mov    %esi,%ebx
 1004599:	49 89 fe             	mov    %rdi,%r14
 100459c:	48 63 fe             	movslq %esi,%rdi
 100459f:	e8 c6 f6 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 10045a4:	49 8b 0e             	mov    (%r14),%rcx
 10045a7:	48 85 c9             	test   %rcx,%rcx
 10045aa:	74 48                	je     10045f4 <_ZN6vectorIcE7reserveEi+0x66>
 10045ac:	41 8b 56 08          	mov    0x8(%r14),%edx
 10045b0:	85 d2                	test   %edx,%edx
 10045b2:	7e 12                	jle    10045c6 <_ZN6vectorIcE7reserveEi+0x38>
 10045b4:	31 f6                	xor    %esi,%esi
 10045b6:	40 8a 3c 31          	mov    (%rcx,%rsi,1),%dil
 10045ba:	40 88 3c 30          	mov    %dil,(%rax,%rsi,1)
 10045be:	48 ff c6             	inc    %rsi
 10045c1:	48 39 f2             	cmp    %rsi,%rdx
 10045c4:	75 f0                	jne    10045b6 <_ZN6vectorIcE7reserveEi+0x28>
 10045c6:	48 8d 51 f0          	lea    -0x10(%rcx),%rdx
 10045ca:	48 8b 71 f0          	mov    -0x10(%rcx),%rsi
 10045ce:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10045d5:	00 04 
 10045d7:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
 10045dc:	48 89 34 25 00 00 00 	mov    %rsi,0x4000000
 10045e3:	04 
 10045e4:	48 89 14 25 08 00 00 	mov    %rdx,0x4000008
 10045eb:	04 
 10045ec:	48 29 34 25 28 00 11 	sub    %rsi,0x110028
 10045f3:	00 
 10045f4:	49 89 06             	mov    %rax,(%r14)
 10045f7:	41 89 5e 0c          	mov    %ebx,0xc(%r14)
 10045fb:	48 83 c4 08          	add    $0x8,%rsp
 10045ff:	5b                   	pop    %rbx
 1004600:	41 5e                	pop    %r14
 1004602:	c3                   	ret    
 1004603:	cc                   	int3   

0000000001004604 <_ZN6vectorIcE6insertEci>:
 1004604:	55                   	push   %rbp
 1004605:	41 57                	push   %r15
 1004607:	41 56                	push   %r14
 1004609:	41 55                	push   %r13
 100460b:	41 54                	push   %r12
 100460d:	53                   	push   %rbx
 100460e:	50                   	push   %rax
 100460f:	89 d5                	mov    %edx,%ebp
 1004611:	89 f3                	mov    %esi,%ebx
 1004613:	49 89 fe             	mov    %rdi,%r14
 1004616:	8b 47 08             	mov    0x8(%rdi),%eax
 1004619:	39 d0                	cmp    %edx,%eax
 100461b:	7e 67                	jle    1004684 <_ZN6vectorIcE6insertEci+0x80>
 100461d:	41 8b 46 08          	mov    0x8(%r14),%eax
 1004621:	4c 63 e0             	movslq %eax,%r12
 1004624:	49 8b 06             	mov    (%r14),%rax
 1004627:	4d 8d 7c 24 ff       	lea    -0x1(%r12),%r15
 100462c:	46 8a 6c 20 ff       	mov    -0x1(%rax,%r12,1),%r13b
 1004631:	4c 89 f7             	mov    %r14,%rdi
 1004634:	44 89 e6             	mov    %r12d,%esi
 1004637:	e8 64 37 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 100463c:	44 88 28             	mov    %r13b,(%rax)
 100463f:	41 39 ef             	cmp    %ebp,%r15d
 1004642:	7e 3b                	jle    100467f <_ZN6vectorIcE6insertEci+0x7b>
 1004644:	48 b8 00 00 00 00 ff 	movabs $0xffffffff00000000,%rax
 100464b:	ff ff ff 
 100464e:	48 63 cd             	movslq %ebp,%rcx
 1004651:	41 8d 54 24 fe       	lea    -0x2(%r12),%edx
 1004656:	49 c1 e4 20          	shl    $0x20,%r12
 100465a:	49 01 c4             	add    %rax,%r12
 100465d:	49 8b 36             	mov    (%r14),%rsi
 1004660:	48 63 d2             	movslq %edx,%rdx
 1004663:	40 8a 3c 16          	mov    (%rsi,%rdx,1),%dil
 1004667:	42 88 3c 3e          	mov    %dil,(%rsi,%r15,1)
 100466b:	49 ff cf             	dec    %r15
 100466e:	ff ca                	dec    %edx
 1004670:	49 01 c4             	add    %rax,%r12
 1004673:	49 39 cf             	cmp    %rcx,%r15
 1004676:	7f e5                	jg     100465d <_ZN6vectorIcE6insertEci+0x59>
 1004678:	49 c1 fc 20          	sar    $0x20,%r12
 100467c:	4d 89 e7             	mov    %r12,%r15
 100467f:	4d 03 3e             	add    (%r14),%r15
 1004682:	eb 0d                	jmp    1004691 <_ZN6vectorIcE6insertEci+0x8d>
 1004684:	4c 89 f7             	mov    %r14,%rdi
 1004687:	89 ee                	mov    %ebp,%esi
 1004689:	e8 12 37 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 100468e:	49 89 c7             	mov    %rax,%r15
 1004691:	41 88 1f             	mov    %bl,(%r15)
 1004694:	48 83 c4 08          	add    $0x8,%rsp
 1004698:	5b                   	pop    %rbx
 1004699:	41 5c                	pop    %r12
 100469b:	41 5d                	pop    %r13
 100469d:	41 5e                	pop    %r14
 100469f:	41 5f                	pop    %r15
 10046a1:	5d                   	pop    %rbp
 10046a2:	c3                   	ret    
 10046a3:	cc                   	int3   

00000000010046a4 <_ZN13istringstreamC1E8rostring>:
 10046a4:	8b 46 08             	mov    0x8(%rsi),%eax
 10046a7:	48 8b 0e             	mov    (%rsi),%rcx
 10046aa:	48 89 0f             	mov    %rcx,(%rdi)
 10046ad:	89 47 08             	mov    %eax,0x8(%rdi)
 10046b0:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%rdi)
 10046b7:	c3                   	ret    

00000000010046b8 <_ZN13istringstreamC1E6string>:
 10046b8:	8b 46 08             	mov    0x8(%rsi),%eax
 10046bb:	48 8b 0e             	mov    (%rsi),%rcx
 10046be:	89 44 24 f8          	mov    %eax,-0x8(%rsp)
 10046c2:	8b 44 24 f8          	mov    -0x8(%rsp),%eax
 10046c6:	48 89 0f             	mov    %rcx,(%rdi)
 10046c9:	89 47 08             	mov    %eax,0x8(%rdi)
 10046cc:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%rdi)
 10046d3:	c3                   	ret    

00000000010046d4 <_ZN13istringstreamC1E4spanIcE>:
 10046d4:	8b 46 08             	mov    0x8(%rsi),%eax
 10046d7:	48 8b 0e             	mov    (%rsi),%rcx
 10046da:	89 44 24 f8          	mov    %eax,-0x8(%rsp)
 10046de:	8b 44 24 f8          	mov    -0x8(%rsp),%eax
 10046e2:	48 89 0f             	mov    %rcx,(%rdi)
 10046e5:	89 47 08             	mov    %eax,0x8(%rdi)
 10046e8:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%rdi)
 10046ef:	c3                   	ret    

00000000010046f0 <_ZN13istringstream7read_bzEPvi>:
 10046f0:	85 d2                	test   %edx,%edx
 10046f2:	7e 40                	jle    1004734 <_ZN13istringstream7read_bzEPvi+0x44>
 10046f4:	41 57                	push   %r15
 10046f6:	41 56                	push   %r14
 10046f8:	41 54                	push   %r12
 10046fa:	53                   	push   %rbx
 10046fb:	50                   	push   %rax
 10046fc:	48 89 f3             	mov    %rsi,%rbx
 10046ff:	49 89 fe             	mov    %rdi,%r14
 1004702:	41 89 d7             	mov    %edx,%r15d
 1004705:	45 31 e4             	xor    %r12d,%r12d
 1004708:	41 8b 76 10          	mov    0x10(%r14),%esi
 100470c:	8d 46 01             	lea    0x1(%rsi),%eax
 100470f:	41 89 46 10          	mov    %eax,0x10(%r14)
 1004713:	4c 89 f7             	mov    %r14,%rdi
 1004716:	e8 1b 00 00 00       	call   1004736 <_ZN4spanIcE2atEi>
 100471b:	8a 00                	mov    (%rax),%al
 100471d:	42 88 04 23          	mov    %al,(%rbx,%r12,1)
 1004721:	49 ff c4             	inc    %r12
 1004724:	4d 39 e7             	cmp    %r12,%r15
 1004727:	75 df                	jne    1004708 <_ZN13istringstream7read_bzEPvi+0x18>
 1004729:	48 83 c4 08          	add    $0x8,%rsp
 100472d:	5b                   	pop    %rbx
 100472e:	41 5c                	pop    %r12
 1004730:	41 5e                	pop    %r14
 1004732:	41 5f                	pop    %r15
 1004734:	c3                   	ret    
 1004735:	cc                   	int3   

0000000001004736 <_ZN4spanIcE2atEi>:
 1004736:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
 100473a:	74 07                	je     1004743 <_ZN4spanIcE2atEi+0xd>
 100473c:	48 63 c6             	movslq %esi,%rax
 100473f:	48 03 07             	add    (%rdi),%rax
 1004742:	c3                   	ret    
 1004743:	53                   	push   %rbx
 1004744:	b0 4f                	mov    $0x4f,%al
 1004746:	48 c7 c3 eb ff ff ff 	mov    $0xffffffffffffffeb,%rbx
 100474d:	0f be f0             	movsbl %al,%esi
 1004750:	bf 00 00 11 00       	mov    $0x110000,%edi
 1004755:	e8 f8 f3 ff ff       	call   1003b52 <_ZN7console7putcharEc>
 100475a:	8a 83 c6 87 00 01    	mov    0x10087c6(%rbx),%al
 1004760:	48 ff c3             	inc    %rbx
 1004763:	75 e8                	jne    100474d <_ZN4spanIcE2atEi+0x17>
 1004765:	bf 01 00 00 00       	mov    $0x1,%edi
 100476a:	e8 fb f4 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 100476f:	c6 00 00             	movb   $0x0,(%rax)
 1004772:	5b                   	pop    %rbx
 1004773:	c3                   	ret    

0000000001004774 <_ZN13istringstream4readIcEET_v>:
 1004774:	50                   	push   %rax
 1004775:	8b 77 10             	mov    0x10(%rdi),%esi
 1004778:	8d 46 01             	lea    0x1(%rsi),%eax
 100477b:	89 47 10             	mov    %eax,0x10(%rdi)
 100477e:	e8 b3 ff ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 1004783:	8a 00                	mov    (%rax),%al
 1004785:	59                   	pop    %rcx
 1004786:	c3                   	ret    
 1004787:	cc                   	int3   

0000000001004788 <_ZN13istringstream4readIdEET_v>:
 1004788:	55                   	push   %rbp
 1004789:	41 57                	push   %r15
 100478b:	41 56                	push   %r14
 100478d:	41 54                	push   %r12
 100478f:	53                   	push   %rbx
 1004790:	48 83 ec 20          	sub    $0x20,%rsp
 1004794:	48 89 fb             	mov    %rdi,%rbx
 1004797:	44 8b 77 10          	mov    0x10(%rdi),%r14d
 100479b:	45 8d 7e 01          	lea    0x1(%r14),%r15d
 100479f:	44 89 7f 10          	mov    %r15d,0x10(%rdi)
 10047a3:	44 89 f6             	mov    %r14d,%esi
 10047a6:	e8 8b ff ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10047ab:	40 8a 28             	mov    (%rax),%bpl
 10047ae:	40 80 fd 2d          	cmp    $0x2d,%bpl
 10047b2:	75 17                	jne    10047cb <_ZN13istringstream4readIdEET_v+0x43>
 10047b4:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 10047b8:	48 89 df             	mov    %rbx,%rdi
 10047bb:	44 89 f6             	mov    %r14d,%esi
 10047be:	e8 73 ff ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10047c3:	44 8b 73 10          	mov    0x10(%rbx),%r14d
 10047c7:	45 8d 7e 01          	lea    0x1(%r14),%r15d
 10047cb:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 10047cf:	48 89 df             	mov    %rbx,%rdi
 10047d2:	44 89 f6             	mov    %r14d,%esi
 10047d5:	e8 5c ff ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10047da:	80 38 30             	cmpb   $0x30,(%rax)
 10047dd:	7c 75                	jl     1004854 <_ZN13istringstream4readIdEET_v+0xcc>
 10047df:	c5 f9 57 c0          	vxorpd %xmm0,%xmm0,%xmm0
 10047e3:	c5 f9 29 04 24       	vmovapd %xmm0,(%rsp)
 10047e8:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 10047ec:	48 89 df             	mov    %rbx,%rdi
 10047ef:	44 89 f6             	mov    %r14d,%esi
 10047f2:	e8 3f ff ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10047f7:	80 38 3a             	cmpb   $0x3a,(%rax)
 10047fa:	7d 63                	jge    100485f <_ZN13istringstream4readIdEET_v+0xd7>
 10047fc:	c5 fb 10 05 8c 3a 00 	vmovsd 0x3a8c(%rip),%xmm0        # 1008290 <_ZL4lfsr+0x150>
 1004803:	00 
 1004804:	c5 fb 59 04 24       	vmulsd (%rsp),%xmm0,%xmm0
 1004809:	c5 fb 11 04 24       	vmovsd %xmm0,(%rsp)
 100480e:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 1004812:	48 89 df             	mov    %rbx,%rdi
 1004815:	44 89 f6             	mov    %r14d,%esi
 1004818:	e8 19 ff ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 100481d:	0f be 00             	movsbl (%rax),%eax
 1004820:	83 c0 d0             	add    $0xffffffd0,%eax
 1004823:	c5 f3 2a c0          	vcvtsi2sd %eax,%xmm1,%xmm0
 1004827:	c5 fb 58 04 24       	vaddsd (%rsp),%xmm0,%xmm0
 100482c:	c5 f9 29 04 24       	vmovapd %xmm0,(%rsp)
 1004831:	44 8b 73 10          	mov    0x10(%rbx),%r14d
 1004835:	45 8d 7e 01          	lea    0x1(%r14),%r15d
 1004839:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 100483d:	48 89 df             	mov    %rbx,%rdi
 1004840:	44 89 f6             	mov    %r14d,%esi
 1004843:	e8 ee fe ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 1004848:	8a 00                	mov    (%rax),%al
 100484a:	44 89 73 10          	mov    %r14d,0x10(%rbx)
 100484e:	3c 2f                	cmp    $0x2f,%al
 1004850:	7f 96                	jg     10047e8 <_ZN13istringstream4readIdEET_v+0x60>
 1004852:	eb 0f                	jmp    1004863 <_ZN13istringstream4readIdEET_v+0xdb>
 1004854:	c5 f9 57 c0          	vxorpd %xmm0,%xmm0,%xmm0
 1004858:	c5 f9 29 04 24       	vmovapd %xmm0,(%rsp)
 100485d:	eb 04                	jmp    1004863 <_ZN13istringstream4readIdEET_v+0xdb>
 100485f:	45 8d 7e 01          	lea    0x1(%r14),%r15d
 1004863:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 1004867:	48 89 df             	mov    %rbx,%rdi
 100486a:	44 89 f6             	mov    %r14d,%esi
 100486d:	e8 c4 fe ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 1004872:	8a 00                	mov    (%rax),%al
 1004874:	44 89 73 10          	mov    %r14d,0x10(%rbx)
 1004878:	3c 2e                	cmp    $0x2e,%al
 100487a:	0f 85 c4 00 00 00    	jne    1004944 <_ZN13istringstream4readIdEET_v+0x1bc>
 1004880:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 1004884:	48 89 df             	mov    %rbx,%rdi
 1004887:	44 89 f6             	mov    %r14d,%esi
 100488a:	e8 a7 fe ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 100488f:	44 8b 73 10          	mov    0x10(%rbx),%r14d
 1004893:	45 8d 66 01          	lea    0x1(%r14),%r12d
 1004897:	44 89 63 10          	mov    %r12d,0x10(%rbx)
 100489b:	48 89 df             	mov    %rbx,%rdi
 100489e:	44 89 f6             	mov    %r14d,%esi
 10048a1:	e8 90 fe ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10048a6:	8a 00                	mov    (%rax),%al
 10048a8:	44 89 73 10          	mov    %r14d,0x10(%rbx)
 10048ac:	3c 30                	cmp    $0x30,%al
 10048ae:	0f 8c 90 00 00 00    	jl     1004944 <_ZN13istringstream4readIdEET_v+0x1bc>
 10048b4:	45 31 ff             	xor    %r15d,%r15d
 10048b7:	c5 fb 10 05 d9 39 00 	vmovsd 0x39d9(%rip),%xmm0        # 1008298 <_ZL4lfsr+0x158>
 10048be:	00 
 10048bf:	c5 fb 11 44 24 18    	vmovsd %xmm0,0x18(%rsp)
 10048c5:	44 89 63 10          	mov    %r12d,0x10(%rbx)
 10048c9:	48 89 df             	mov    %rbx,%rdi
 10048cc:	44 89 f6             	mov    %r14d,%esi
 10048cf:	e8 62 fe ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10048d4:	8a 00                	mov    (%rax),%al
 10048d6:	44 89 73 10          	mov    %r14d,0x10(%rbx)
 10048da:	3c 39                	cmp    $0x39,%al
 10048dc:	7f 66                	jg     1004944 <_ZN13istringstream4readIdEET_v+0x1bc>
 10048de:	41 83 ff 09          	cmp    $0x9,%r15d
 10048e2:	77 60                	ja     1004944 <_ZN13istringstream4readIdEET_v+0x1bc>
 10048e4:	41 ff c7             	inc    %r15d
 10048e7:	44 89 63 10          	mov    %r12d,0x10(%rbx)
 10048eb:	48 89 df             	mov    %rbx,%rdi
 10048ee:	44 89 f6             	mov    %r14d,%esi
 10048f1:	e8 40 fe ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10048f6:	0f be 00             	movsbl (%rax),%eax
 10048f9:	83 c0 d0             	add    $0xffffffd0,%eax
 10048fc:	c5 e3 2a c0          	vcvtsi2sd %eax,%xmm3,%xmm0
 1004900:	c5 f9 28 0c 24       	vmovapd (%rsp),%xmm1
 1004905:	c5 fb 10 54 24 18    	vmovsd 0x18(%rsp),%xmm2
 100490b:	c4 e2 e9 b9 c8       	vfmadd231sd %xmm0,%xmm2,%xmm1
 1004910:	c5 f9 29 0c 24       	vmovapd %xmm1,(%rsp)
 1004915:	c5 eb 59 15 7b 39 00 	vmulsd 0x397b(%rip),%xmm2,%xmm2        # 1008298 <_ZL4lfsr+0x158>
 100491c:	00 
 100491d:	c5 fb 11 54 24 18    	vmovsd %xmm2,0x18(%rsp)
 1004923:	44 8b 73 10          	mov    0x10(%rbx),%r14d
 1004927:	45 8d 66 01          	lea    0x1(%r14),%r12d
 100492b:	44 89 63 10          	mov    %r12d,0x10(%rbx)
 100492f:	48 89 df             	mov    %rbx,%rdi
 1004932:	44 89 f6             	mov    %r14d,%esi
 1004935:	e8 fc fd ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 100493a:	8a 00                	mov    (%rax),%al
 100493c:	44 89 73 10          	mov    %r14d,0x10(%rbx)
 1004940:	3c 2f                	cmp    $0x2f,%al
 1004942:	7f 81                	jg     10048c5 <_ZN13istringstream4readIdEET_v+0x13d>
 1004944:	40 80 fd 2d          	cmp    $0x2d,%bpl
 1004948:	74 07                	je     1004951 <_ZN13istringstream4readIdEET_v+0x1c9>
 100494a:	c5 f9 28 04 24       	vmovapd (%rsp),%xmm0
 100494f:	eb 11                	jmp    1004962 <_ZN13istringstream4readIdEET_v+0x1da>
 1004951:	c5 fb 12 05 47 39 00 	vmovddup 0x3947(%rip),%xmm0        # 10082a0 <_ZL4lfsr+0x160>
 1004958:	00 
 1004959:	c5 f9 28 0c 24       	vmovapd (%rsp),%xmm1
 100495e:	c5 f1 57 c0          	vxorpd %xmm0,%xmm1,%xmm0
 1004962:	48 83 c4 20          	add    $0x20,%rsp
 1004966:	5b                   	pop    %rbx
 1004967:	41 5c                	pop    %r12
 1004969:	41 5e                	pop    %r14
 100496b:	41 5f                	pop    %r15
 100496d:	5d                   	pop    %rbp
 100496e:	c3                   	ret    
 100496f:	cc                   	int3   

0000000001004970 <_ZN13istringstream4readIlEET_v>:
 1004970:	55                   	push   %rbp
 1004971:	41 57                	push   %r15
 1004973:	41 56                	push   %r14
 1004975:	41 54                	push   %r12
 1004977:	53                   	push   %rbx
 1004978:	48 89 fb             	mov    %rdi,%rbx
 100497b:	44 8b 77 10          	mov    0x10(%rdi),%r14d
 100497f:	45 8d 7e 01          	lea    0x1(%r14),%r15d
 1004983:	44 89 7f 10          	mov    %r15d,0x10(%rdi)
 1004987:	44 89 f6             	mov    %r14d,%esi
 100498a:	e8 a7 fd ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 100498f:	40 8a 28             	mov    (%rax),%bpl
 1004992:	40 80 fd 2d          	cmp    $0x2d,%bpl
 1004996:	75 17                	jne    10049af <_ZN13istringstream4readIlEET_v+0x3f>
 1004998:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 100499c:	48 89 df             	mov    %rbx,%rdi
 100499f:	44 89 f6             	mov    %r14d,%esi
 10049a2:	e8 8f fd ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10049a7:	44 8b 73 10          	mov    0x10(%rbx),%r14d
 10049ab:	45 8d 7e 01          	lea    0x1(%r14),%r15d
 10049af:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 10049b3:	48 89 df             	mov    %rbx,%rdi
 10049b6:	44 89 f6             	mov    %r14d,%esi
 10049b9:	e8 78 fd ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10049be:	8a 00                	mov    (%rax),%al
 10049c0:	44 89 73 10          	mov    %r14d,0x10(%rbx)
 10049c4:	45 31 e4             	xor    %r12d,%r12d
 10049c7:	3c 30                	cmp    $0x30,%al
 10049c9:	7c 59                	jl     1004a24 <_ZN13istringstream4readIlEET_v+0xb4>
 10049cb:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 10049cf:	48 89 df             	mov    %rbx,%rdi
 10049d2:	44 89 f6             	mov    %r14d,%esi
 10049d5:	e8 5c fd ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10049da:	8a 00                	mov    (%rax),%al
 10049dc:	44 89 73 10          	mov    %r14d,0x10(%rbx)
 10049e0:	3c 39                	cmp    $0x39,%al
 10049e2:	7f 40                	jg     1004a24 <_ZN13istringstream4readIlEET_v+0xb4>
 10049e4:	4f 8d 24 a4          	lea    (%r12,%r12,4),%r12
 10049e8:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 10049ec:	48 89 df             	mov    %rbx,%rdi
 10049ef:	44 89 f6             	mov    %r14d,%esi
 10049f2:	e8 3f fd ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10049f7:	48 0f be 00          	movsbq (%rax),%rax
 10049fb:	4e 8d 24 60          	lea    (%rax,%r12,2),%r12
 10049ff:	49 83 c4 d0          	add    $0xffffffffffffffd0,%r12
 1004a03:	44 8b 73 10          	mov    0x10(%rbx),%r14d
 1004a07:	45 8d 7e 01          	lea    0x1(%r14),%r15d
 1004a0b:	44 89 7b 10          	mov    %r15d,0x10(%rbx)
 1004a0f:	48 89 df             	mov    %rbx,%rdi
 1004a12:	44 89 f6             	mov    %r14d,%esi
 1004a15:	e8 1c fd ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 1004a1a:	8a 00                	mov    (%rax),%al
 1004a1c:	44 89 73 10          	mov    %r14d,0x10(%rbx)
 1004a20:	3c 2f                	cmp    $0x2f,%al
 1004a22:	7f a7                	jg     10049cb <_ZN13istringstream4readIlEET_v+0x5b>
 1004a24:	4c 89 e0             	mov    %r12,%rax
 1004a27:	48 f7 d8             	neg    %rax
 1004a2a:	40 80 fd 2d          	cmp    $0x2d,%bpl
 1004a2e:	49 0f 45 c4          	cmovne %r12,%rax
 1004a32:	5b                   	pop    %rbx
 1004a33:	41 5c                	pop    %r12
 1004a35:	41 5e                	pop    %r14
 1004a37:	41 5f                	pop    %r15
 1004a39:	5d                   	pop    %rbp
 1004a3a:	c3                   	ret    
 1004a3b:	cc                   	int3   

0000000001004a3c <_ZN13istringstream14read_until_incE8rostring>:
 1004a3c:	55                   	push   %rbp
 1004a3d:	41 57                	push   %r15
 1004a3f:	41 56                	push   %r14
 1004a41:	53                   	push   %rbx
 1004a42:	50                   	push   %rax
 1004a43:	49 89 d7             	mov    %rdx,%r15
 1004a46:	49 89 f6             	mov    %rsi,%r14
 1004a49:	48 89 fb             	mov    %rdi,%rbx
 1004a4c:	8b 6e 10             	mov    0x10(%rsi),%ebp
 1004a4f:	48 89 f7             	mov    %rsi,%rdi
 1004a52:	89 ee                	mov    %ebp,%esi
 1004a54:	e8 dd fc ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 1004a59:	4c 89 ff             	mov    %r15,%rdi
 1004a5c:	48 89 c6             	mov    %rax,%rsi
 1004a5f:	e8 8a 30 00 00       	call   1007aee <_ZNK4spanIcE4findERKc>
 1004a64:	85 c0                	test   %eax,%eax
 1004a66:	79 15                	jns    1004a7d <_ZN13istringstream14read_until_incE8rostring+0x41>
 1004a68:	41 8b 76 10          	mov    0x10(%r14),%esi
 1004a6c:	41 3b 76 08          	cmp    0x8(%r14),%esi
 1004a70:	7d 0b                	jge    1004a7d <_ZN13istringstream14read_until_incE8rostring+0x41>
 1004a72:	ff c6                	inc    %esi
 1004a74:	41 89 76 10          	mov    %esi,0x10(%r14)
 1004a78:	4c 89 f7             	mov    %r14,%rdi
 1004a7b:	eb d7                	jmp    1004a54 <_ZN13istringstream14read_until_incE8rostring+0x18>
 1004a7d:	48 63 c5             	movslq %ebp,%rax
 1004a80:	41 8b 4e 10          	mov    0x10(%r14),%ecx
 1004a84:	41 3b 4e 08          	cmp    0x8(%r14),%ecx
 1004a88:	7d 06                	jge    1004a90 <_ZN13istringstream14read_until_incE8rostring+0x54>
 1004a8a:	ff c1                	inc    %ecx
 1004a8c:	41 89 4e 10          	mov    %ecx,0x10(%r14)
 1004a90:	29 e9                	sub    %ebp,%ecx
 1004a92:	49 03 06             	add    (%r14),%rax
 1004a95:	48 89 03             	mov    %rax,(%rbx)
 1004a98:	89 4b 08             	mov    %ecx,0x8(%rbx)
 1004a9b:	48 89 d8             	mov    %rbx,%rax
 1004a9e:	48 83 c4 08          	add    $0x8,%rsp
 1004aa2:	5b                   	pop    %rbx
 1004aa3:	41 5e                	pop    %r14
 1004aa5:	41 5f                	pop    %r15
 1004aa7:	5d                   	pop    %rbp
 1004aa8:	c3                   	ret    
 1004aa9:	cc                   	int3   

0000000001004aaa <_ZN13istringstream14read_until_incEc>:
 1004aaa:	53                   	push   %rbx
 1004aab:	48 83 ec 20          	sub    $0x20,%rsp
 1004aaf:	48 89 fb             	mov    %rdi,%rbx
 1004ab2:	48 8d 44 24 07       	lea    0x7(%rsp),%rax
 1004ab7:	88 10                	mov    %dl,(%rax)
 1004ab9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%rsp)
 1004ac0:	00 
 1004ac1:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
 1004ac5:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
 1004aca:	48 89 02             	mov    %rax,(%rdx)
 1004acd:	89 4a 08             	mov    %ecx,0x8(%rdx)
 1004ad0:	e8 67 ff ff ff       	call   1004a3c <_ZN13istringstream14read_until_incE8rostring>
 1004ad5:	48 89 d8             	mov    %rbx,%rax
 1004ad8:	48 83 c4 20          	add    $0x20,%rsp
 1004adc:	5b                   	pop    %rbx
 1004add:	c3                   	ret    

0000000001004ade <_ZN13istringstream10read_untilE8rostring>:
 1004ade:	41 56                	push   %r14
 1004ae0:	53                   	push   %rbx
 1004ae1:	48 83 ec 28          	sub    $0x28,%rsp
 1004ae5:	48 89 fb             	mov    %rdi,%rbx
 1004ae8:	8b 42 08             	mov    0x8(%rdx),%eax
 1004aeb:	48 8b 0a             	mov    (%rdx),%rcx
 1004aee:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
 1004af3:	48 89 0a             	mov    %rcx,(%rdx)
 1004af6:	89 42 08             	mov    %eax,0x8(%rdx)
 1004af9:	4c 8d 74 24 18       	lea    0x18(%rsp),%r14
 1004afe:	4c 89 f7             	mov    %r14,%rdi
 1004b01:	e8 36 ff ff ff       	call   1004a3c <_ZN13istringstream14read_until_incE8rostring>
 1004b06:	41 8b 46 08          	mov    0x8(%r14),%eax
 1004b0a:	ff c8                	dec    %eax
 1004b0c:	49 8b 0e             	mov    (%r14),%rcx
 1004b0f:	48 89 0b             	mov    %rcx,(%rbx)
 1004b12:	89 43 08             	mov    %eax,0x8(%rbx)
 1004b15:	48 89 d8             	mov    %rbx,%rax
 1004b18:	48 83 c4 28          	add    $0x28,%rsp
 1004b1c:	5b                   	pop    %rbx
 1004b1d:	41 5e                	pop    %r14
 1004b1f:	c3                   	ret    

0000000001004b20 <_ZN13istringstream10read_untilEc>:
 1004b20:	41 56                	push   %r14
 1004b22:	53                   	push   %rbx
 1004b23:	48 83 ec 38          	sub    $0x38,%rsp
 1004b27:	48 89 fb             	mov    %rdi,%rbx
 1004b2a:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
 1004b2f:	88 10                	mov    %dl,(%rax)
 1004b31:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%rsp)
 1004b38:	00 
 1004b39:	8b 4c 24 10          	mov    0x10(%rsp),%ecx
 1004b3d:	48 8d 54 24 28       	lea    0x28(%rsp),%rdx
 1004b42:	48 89 02             	mov    %rax,(%rdx)
 1004b45:	89 4a 08             	mov    %ecx,0x8(%rdx)
 1004b48:	4c 8d 74 24 18       	lea    0x18(%rsp),%r14
 1004b4d:	4c 89 f7             	mov    %r14,%rdi
 1004b50:	e8 e7 fe ff ff       	call   1004a3c <_ZN13istringstream14read_until_incE8rostring>
 1004b55:	41 8b 46 08          	mov    0x8(%r14),%eax
 1004b59:	ff c8                	dec    %eax
 1004b5b:	49 8b 0e             	mov    (%r14),%rcx
 1004b5e:	48 89 0b             	mov    %rcx,(%rbx)
 1004b61:	89 43 08             	mov    %eax,0x8(%rbx)
 1004b64:	48 89 d8             	mov    %rbx,%rax
 1004b67:	48 83 c4 38          	add    $0x38,%rsp
 1004b6b:	5b                   	pop    %rbx
 1004b6c:	41 5e                	pop    %r14
 1004b6e:	c3                   	ret    
 1004b6f:	cc                   	int3   

0000000001004b70 <_ZNK8rostring5splitES_>:
 1004b70:	55                   	push   %rbp
 1004b71:	41 57                	push   %r15
 1004b73:	41 56                	push   %r14
 1004b75:	41 55                	push   %r13
 1004b77:	41 54                	push   %r12
 1004b79:	53                   	push   %rbx
 1004b7a:	48 83 ec 48          	sub    $0x48,%rsp
 1004b7e:	49 89 fe             	mov    %rdi,%r14
 1004b81:	8b 46 08             	mov    0x8(%rsi),%eax
 1004b84:	48 8b 0e             	mov    (%rsi),%rcx
 1004b87:	89 44 24 08          	mov    %eax,0x8(%rsp)
 1004b8b:	8b 44 24 08          	mov    0x8(%rsp),%eax
 1004b8f:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
 1004b94:	89 44 24 18          	mov    %eax,0x18(%rsp)
 1004b98:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%rsp)
 1004b9f:	00 
 1004ba0:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 1004ba4:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
 1004ba8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%rsp)
 1004bad:	7e 59                	jle    1004c08 <_ZNK8rostring5splitES_+0x98>
 1004baf:	48 89 d3             	mov    %rdx,%rbx
 1004bb2:	4c 8d 64 24 10       	lea    0x10(%rsp),%r12
 1004bb7:	4c 8d 6c 24 28       	lea    0x28(%rsp),%r13
 1004bbc:	8b 43 08             	mov    0x8(%rbx),%eax
 1004bbf:	48 8b 0b             	mov    (%rbx),%rcx
 1004bc2:	89 04 24             	mov    %eax,(%rsp)
 1004bc5:	8b 04 24             	mov    (%rsp),%eax
 1004bc8:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
 1004bcd:	89 44 24 30          	mov    %eax,0x30(%rsp)
 1004bd1:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
 1004bd6:	4c 89 e6             	mov    %r12,%rsi
 1004bd9:	4c 89 ea             	mov    %r13,%rdx
 1004bdc:	e8 5b fe ff ff       	call   1004a3c <_ZN13istringstream14read_until_incE8rostring>
 1004be1:	8b 6c 24 40          	mov    0x40(%rsp),%ebp
 1004be5:	ff cd                	dec    %ebp
 1004be7:	4c 8b 7c 24 38       	mov    0x38(%rsp),%r15
 1004bec:	41 8b 76 08          	mov    0x8(%r14),%esi
 1004bf0:	4c 89 f7             	mov    %r14,%rdi
 1004bf3:	e8 fc 31 00 00       	call   1007df4 <_ZN6vectorI8rostringE2atEi>
 1004bf8:	4c 89 38             	mov    %r15,(%rax)
 1004bfb:	89 68 08             	mov    %ebp,0x8(%rax)
 1004bfe:	8b 44 24 20          	mov    0x20(%rsp),%eax
 1004c02:	3b 44 24 18          	cmp    0x18(%rsp),%eax
 1004c06:	7c b4                	jl     1004bbc <_ZNK8rostring5splitES_+0x4c>
 1004c08:	4c 89 f0             	mov    %r14,%rax
 1004c0b:	48 83 c4 48          	add    $0x48,%rsp
 1004c0f:	5b                   	pop    %rbx
 1004c10:	41 5c                	pop    %r12
 1004c12:	41 5d                	pop    %r13
 1004c14:	41 5e                	pop    %r14
 1004c16:	41 5f                	pop    %r15
 1004c18:	5d                   	pop    %rbp
 1004c19:	c3                   	ret    

0000000001004c1a <_ZNK8rostring5splitEc>:
 1004c1a:	53                   	push   %rbx
 1004c1b:	48 83 ec 20          	sub    $0x20,%rsp
 1004c1f:	48 89 fb             	mov    %rdi,%rbx
 1004c22:	48 8d 44 24 0f       	lea    0xf(%rsp),%rax
 1004c27:	88 10                	mov    %dl,(%rax)
 1004c29:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
 1004c2e:	48 89 02             	mov    %rax,(%rdx)
 1004c31:	c7 42 08 01 00 00 00 	movl   $0x1,0x8(%rdx)
 1004c38:	e8 33 ff ff ff       	call   1004b70 <_ZNK8rostring5splitES_>
 1004c3d:	48 89 d8             	mov    %rbx,%rax
 1004c40:	48 83 c4 20          	add    $0x20,%rsp
 1004c44:	5b                   	pop    %rbx
 1004c45:	c3                   	ret    
 1004c46:	cc                   	int3   
 1004c47:	cc                   	int3   
 1004c48:	cc                   	int3   
 1004c49:	cc                   	int3   
 1004c4a:	cc                   	int3   
 1004c4b:	cc                   	int3   
 1004c4c:	cc                   	int3   
 1004c4d:	cc                   	int3   
 1004c4e:	cc                   	int3   
 1004c4f:	cc                   	int3   

0000000001004c50 <__cxa_atexit>:
 1004c50:	31 c0                	xor    %eax,%eax
 1004c52:	c3                   	ret    

0000000001004c53 <_Z10arp_updatemj>:
 1004c53:	55                   	push   %rbp
 1004c54:	41 56                	push   %r14
 1004c56:	53                   	push   %rbx
 1004c57:	89 f5                	mov    %esi,%ebp
 1004c59:	48 89 fb             	mov    %rdi,%rbx
 1004c5c:	83 3d e5 40 00 00 00 	cmpl   $0x0,0x40e5(%rip)        # 1008d48 <arp_table+0x8>
 1004c63:	7e 21                	jle    1004c86 <_Z10arp_updatemj+0x33>
 1004c65:	45 31 f6             	xor    %r14d,%r14d
 1004c68:	bf 40 8d 00 01       	mov    $0x1008d40,%edi
 1004c6d:	44 89 f6             	mov    %r14d,%esi
 1004c70:	e8 fb 2e 00 00       	call   1007b70 <_ZN4spanI9arp_entryE2atEi>
 1004c75:	39 68 08             	cmp    %ebp,0x8(%rax)
 1004c78:	74 24                	je     1004c9e <_Z10arp_updatemj+0x4b>
 1004c7a:	41 ff c6             	inc    %r14d
 1004c7d:	44 3b 35 c4 40 00 00 	cmp    0x40c4(%rip),%r14d        # 1008d48 <arp_table+0x8>
 1004c84:	7c e2                	jl     1004c68 <_Z10arp_updatemj+0x15>
 1004c86:	8b 35 bc 40 00 00    	mov    0x40bc(%rip),%esi        # 1008d48 <arp_table+0x8>
 1004c8c:	bf 40 8d 00 01       	mov    $0x1008d40,%edi
 1004c91:	e8 7e 32 00 00       	call   1007f14 <_ZN6vectorI9arp_entryE2atEi>
 1004c96:	48 89 18             	mov    %rbx,(%rax)
 1004c99:	89 68 08             	mov    %ebp,0x8(%rax)
 1004c9c:	eb 10                	jmp    1004cae <_Z10arp_updatemj+0x5b>
 1004c9e:	bf 40 8d 00 01       	mov    $0x1008d40,%edi
 1004ca3:	44 89 f6             	mov    %r14d,%esi
 1004ca6:	e8 c5 2e 00 00       	call   1007b70 <_ZN4spanI9arp_entryE2atEi>
 1004cab:	48 89 18             	mov    %rbx,(%rax)
 1004cae:	5b                   	pop    %rbx
 1004caf:	41 5e                	pop    %r14
 1004cb1:	5d                   	pop    %rbp
 1004cb2:	c3                   	ret    

0000000001004cb3 <_Z17arp_translate_macm>:
 1004cb3:	83 3d 8e 40 00 00 00 	cmpl   $0x0,0x408e(%rip)        # 1008d48 <arp_table+0x8>
 1004cba:	7e 28                	jle    1004ce4 <_Z17arp_translate_macm+0x31>
 1004cbc:	41 56                	push   %r14
 1004cbe:	53                   	push   %rbx
 1004cbf:	50                   	push   %rax
 1004cc0:	49 89 fe             	mov    %rdi,%r14
 1004cc3:	31 db                	xor    %ebx,%ebx
 1004cc5:	bf 40 8d 00 01       	mov    $0x1008d40,%edi
 1004cca:	89 de                	mov    %ebx,%esi
 1004ccc:	e8 9f 2e 00 00       	call   1007b70 <_ZN4spanI9arp_entryE2atEi>
 1004cd1:	4c 39 30             	cmp    %r14,(%rax)
 1004cd4:	74 11                	je     1004ce7 <_Z17arp_translate_macm+0x34>
 1004cd6:	ff c3                	inc    %ebx
 1004cd8:	3b 1d 6a 40 00 00    	cmp    0x406a(%rip),%ebx        # 1008d48 <arp_table+0x8>
 1004cde:	7c e5                	jl     1004cc5 <_Z17arp_translate_macm+0x12>
 1004ce0:	31 c0                	xor    %eax,%eax
 1004ce2:	eb 12                	jmp    1004cf6 <_Z17arp_translate_macm+0x43>
 1004ce4:	31 c0                	xor    %eax,%eax
 1004ce6:	c3                   	ret    
 1004ce7:	bf 40 8d 00 01       	mov    $0x1008d40,%edi
 1004cec:	89 de                	mov    %ebx,%esi
 1004cee:	e8 7d 2e 00 00       	call   1007b70 <_ZN4spanI9arp_entryE2atEi>
 1004cf3:	8b 40 08             	mov    0x8(%rax),%eax
 1004cf6:	48 83 c4 08          	add    $0x8,%rsp
 1004cfa:	5b                   	pop    %rbx
 1004cfb:	41 5e                	pop    %r14
 1004cfd:	c3                   	ret    

0000000001004cfe <_Z16arp_translate_ipj>:
 1004cfe:	55                   	push   %rbp
 1004cff:	41 56                	push   %r14
 1004d01:	53                   	push   %rbx
 1004d02:	31 db                	xor    %ebx,%ebx
 1004d04:	83 3d 3d 40 00 00 00 	cmpl   $0x0,0x403d(%rip)        # 1008d48 <arp_table+0x8>
 1004d0b:	7e 35                	jle    1004d42 <_Z16arp_translate_ipj+0x44>
 1004d0d:	89 fd                	mov    %edi,%ebp
 1004d0f:	45 31 f6             	xor    %r14d,%r14d
 1004d12:	bf 40 8d 00 01       	mov    $0x1008d40,%edi
 1004d17:	44 89 f6             	mov    %r14d,%esi
 1004d1a:	e8 51 2e 00 00       	call   1007b70 <_ZN4spanI9arp_entryE2atEi>
 1004d1f:	39 68 08             	cmp    %ebp,0x8(%rax)
 1004d22:	74 0e                	je     1004d32 <_Z16arp_translate_ipj+0x34>
 1004d24:	41 ff c6             	inc    %r14d
 1004d27:	44 3b 35 1a 40 00 00 	cmp    0x401a(%rip),%r14d        # 1008d48 <arp_table+0x8>
 1004d2e:	7c e2                	jl     1004d12 <_Z16arp_translate_ipj+0x14>
 1004d30:	eb 10                	jmp    1004d42 <_Z16arp_translate_ipj+0x44>
 1004d32:	bf 40 8d 00 01       	mov    $0x1008d40,%edi
 1004d37:	44 89 f6             	mov    %r14d,%esi
 1004d3a:	e8 31 2e 00 00       	call   1007b70 <_ZN4spanI9arp_entryE2atEi>
 1004d3f:	48 8b 18             	mov    (%rax),%rbx
 1004d42:	48 89 d8             	mov    %rbx,%rax
 1004d45:	5b                   	pop    %rbx
 1004d46:	41 5e                	pop    %r14
 1004d48:	5d                   	pop    %rbp
 1004d49:	c3                   	ret    

0000000001004d4a <_Z11arp_process15ethernet_packet>:
 1004d4a:	55                   	push   %rbp
 1004d4b:	41 57                	push   %r15
 1004d4d:	41 56                	push   %r14
 1004d4f:	41 55                	push   %r13
 1004d51:	41 54                	push   %r12
 1004d53:	53                   	push   %rbx
 1004d54:	48 81 ec a8 00 00 00 	sub    $0xa8,%rsp
 1004d5b:	4c 8b 6f 28          	mov    0x28(%rdi),%r13
 1004d5f:	31 c0                	xor    %eax,%eax
 1004d61:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
 1004d66:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
 1004d6b:	45 8b 4d 0e          	mov    0xe(%r13),%r9d
 1004d6f:	41 8b 6d 18          	mov    0x18(%r13),%ebp
 1004d73:	4d 8d 7d 08          	lea    0x8(%r13),%r15
 1004d77:	41 8a 0c 07          	mov    (%r15,%rax,1),%cl
 1004d7b:	88 4c 04 30          	mov    %cl,0x30(%rsp,%rax,1)
 1004d7f:	48 ff c0             	inc    %rax
 1004d82:	48 83 f8 06          	cmp    $0x6,%rax
 1004d86:	75 ef                	jne    1004d77 <_Z11arp_process15ethernet_packet+0x2d>
 1004d88:	4d 8d 65 12          	lea    0x12(%r13),%r12
 1004d8c:	31 c0                	xor    %eax,%eax
 1004d8e:	41 8a 0c 04          	mov    (%r12,%rax,1),%cl
 1004d92:	88 4c 04 28          	mov    %cl,0x28(%rsp,%rax,1)
 1004d96:	48 ff c0             	inc    %rax
 1004d99:	48 83 f8 06          	cmp    $0x6,%rax
 1004d9d:	75 ef                	jne    1004d8e <_Z11arp_process15ethernet_packet+0x44>
 1004d9f:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
 1004da4:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
 1004da9:	4d 85 f6             	test   %r14,%r14
 1004dac:	74 24                	je     1004dd2 <_Z11arp_process15ethernet_packet+0x88>
 1004dae:	45 85 c9             	test   %r9d,%r9d
 1004db1:	74 1f                	je     1004dd2 <_Z11arp_process15ethernet_packet+0x88>
 1004db3:	4c 89 f7             	mov    %r14,%rdi
 1004db6:	44 89 ce             	mov    %r9d,%esi
 1004db9:	89 6c 24 24          	mov    %ebp,0x24(%rsp)
 1004dbd:	4c 89 f5             	mov    %r14,%rbp
 1004dc0:	45 89 ce             	mov    %r9d,%r14d
 1004dc3:	e8 8b fe ff ff       	call   1004c53 <_Z10arp_updatemj>
 1004dc8:	45 89 f1             	mov    %r14d,%r9d
 1004dcb:	49 89 ee             	mov    %rbp,%r14
 1004dce:	8b 6c 24 24          	mov    0x24(%rsp),%ebp
 1004dd2:	31 c0                	xor    %eax,%eax
 1004dd4:	85 ed                	test   %ebp,%ebp
 1004dd6:	0f 95 c0             	setne  %al
 1004dd9:	31 c9                	xor    %ecx,%ecx
 1004ddb:	48 85 db             	test   %rbx,%rbx
 1004dde:	0f 95 c1             	setne  %cl
 1004de1:	31 d2                	xor    %edx,%edx
 1004de3:	45 85 c9             	test   %r9d,%r9d
 1004de6:	0f 95 c2             	setne  %dl
 1004de9:	31 f6                	xor    %esi,%esi
 1004deb:	4d 85 f6             	test   %r14,%r14
 1004dee:	40 0f 95 c6          	setne  %sil
 1004df2:	8d 14 56             	lea    (%rsi,%rdx,2),%edx
 1004df5:	8d 0c 8a             	lea    (%rdx,%rcx,4),%ecx
 1004df8:	8d 14 c1             	lea    (%rcx,%rax,8),%edx
 1004dfb:	41 0f b7 45 06       	movzwl 0x6(%r13),%eax
 1004e00:	89 c1                	mov    %eax,%ecx
 1004e02:	66 c1 c1 08          	rol    $0x8,%cx
 1004e06:	0f b7 c9             	movzwl %cx,%ecx
 1004e09:	c1 e1 04             	shl    $0x4,%ecx
 1004e0c:	09 d1                	or     %edx,%ecx
 1004e0e:	83 f9 1f             	cmp    $0x1f,%ecx
 1004e11:	0f 84 5c 01 00 00    	je     1004f73 <_Z11arp_process15ethernet_packet+0x229>
 1004e17:	83 f9 1b             	cmp    $0x1b,%ecx
 1004e1a:	0f 84 c4 01 00 00    	je     1004fe4 <_Z11arp_process15ethernet_packet+0x29a>
 1004e20:	83 f9 19             	cmp    $0x19,%ecx
 1004e23:	0f 85 1c 02 00 00    	jne    1005045 <_Z11arp_process15ethernet_packet+0x2fb>
 1004e29:	44 89 cb             	mov    %r9d,%ebx
 1004e2c:	48 8d b4 24 98 00 00 	lea    0x98(%rsp),%rsi
 1004e33:	00 
 1004e34:	48 c7 06 92 89 00 01 	movq   $0x1008992,(%rsi)
 1004e3b:	c7 46 08 2a 00 00 00 	movl   $0x2a,0x8(%rsi)
 1004e42:	4c 8d 7c 24 10       	lea    0x10(%rsp),%r15
 1004e47:	4c 89 ff             	mov    %r15,%rdi
 1004e4a:	4c 89 f2             	mov    %r14,%rdx
 1004e4d:	89 e9                	mov    %ebp,%ecx
 1004e4f:	31 c0                	xor    %eax,%eax
 1004e51:	e8 73 c3 ff ff       	call   10011c9 <_Z6format8rostringz>
 1004e56:	4c 89 ff             	mov    %r15,%rdi
 1004e59:	e8 22 ca ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1004e5e:	49 89 c7             	mov    %rax,%r15
 1004e61:	8a 00                	mov    (%rax),%al
 1004e63:	84 c0                	test   %al,%al
 1004e65:	74 1a                	je     1004e81 <_Z11arp_process15ethernet_packet+0x137>
 1004e67:	49 ff c7             	inc    %r15
 1004e6a:	0f be f0             	movsbl %al,%esi
 1004e6d:	bf 00 00 11 00       	mov    $0x110000,%edi
 1004e72:	e8 db ec ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1004e77:	41 8a 07             	mov    (%r15),%al
 1004e7a:	49 ff c7             	inc    %r15
 1004e7d:	84 c0                	test   %al,%al
 1004e7f:	75 e9                	jne    1004e6a <_Z11arp_process15ethernet_packet+0x120>
 1004e81:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 1004e86:	48 85 c0             	test   %rax,%rax
 1004e89:	74 2e                	je     1004eb9 <_Z11arp_process15ethernet_packet+0x16f>
 1004e8b:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1004e8f:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1004e93:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1004e9a:	00 04 
 1004e9c:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1004ea1:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1004ea8:	04 
 1004ea9:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1004eb0:	04 
 1004eb1:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1004eb8:	00 
 1004eb9:	3b 2d 91 3e 00 00    	cmp    0x3e91(%rip),%ebp        # 1008d50 <global_ip>
 1004ebf:	0f 85 8e 03 00 00    	jne    1005253 <_Z11arp_process15ethernet_packet+0x509>
 1004ec5:	48 8d b4 24 88 00 00 	lea    0x88(%rsp),%rsi
 1004ecc:	00 
 1004ecd:	48 c7 06 53 83 00 01 	movq   $0x1008353,(%rsi)
 1004ed4:	c7 46 08 1d 00 00 00 	movl   $0x1d,0x8(%rsi)
 1004edb:	48 8b 0d 76 3e 00 00 	mov    0x3e76(%rip),%rcx        # 1008d58 <global_mac>
 1004ee2:	4c 8d 7c 24 10       	lea    0x10(%rsp),%r15
 1004ee7:	4c 89 ff             	mov    %r15,%rdi
 1004eea:	89 ea                	mov    %ebp,%edx
 1004eec:	31 c0                	xor    %eax,%eax
 1004eee:	e8 d6 c2 ff ff       	call   10011c9 <_Z6format8rostringz>
 1004ef3:	4c 89 ff             	mov    %r15,%rdi
 1004ef6:	e8 85 c9 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1004efb:	49 89 c7             	mov    %rax,%r15
 1004efe:	8a 00                	mov    (%rax),%al
 1004f00:	84 c0                	test   %al,%al
 1004f02:	74 1a                	je     1004f1e <_Z11arp_process15ethernet_packet+0x1d4>
 1004f04:	49 ff c7             	inc    %r15
 1004f07:	0f be f0             	movsbl %al,%esi
 1004f0a:	bf 00 00 11 00       	mov    $0x110000,%edi
 1004f0f:	e8 3e ec ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1004f14:	41 8a 07             	mov    (%r15),%al
 1004f17:	49 ff c7             	inc    %r15
 1004f1a:	84 c0                	test   %al,%al
 1004f1c:	75 e9                	jne    1004f07 <_Z11arp_process15ethernet_packet+0x1bd>
 1004f1e:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 1004f23:	48 85 c0             	test   %rax,%rax
 1004f26:	41 89 d8             	mov    %ebx,%r8d
 1004f29:	74 2e                	je     1004f59 <_Z11arp_process15ethernet_packet+0x20f>
 1004f2b:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1004f2f:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1004f33:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1004f3a:	00 04 
 1004f3c:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1004f41:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1004f48:	04 
 1004f49:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1004f50:	04 
 1004f51:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1004f58:	00 
 1004f59:	48 8b 35 f8 3d 00 00 	mov    0x3df8(%rip),%rsi        # 1008d58 <global_mac>
 1004f60:	8b 15 ea 3d 00 00    	mov    0x3dea(%rip),%edx        # 1008d50 <global_ip>
 1004f66:	bf 02 00 00 00       	mov    $0x2,%edi
 1004f6b:	4c 89 f1             	mov    %r14,%rcx
 1004f6e:	e9 db 02 00 00       	jmp    100524e <_Z11arp_process15ethernet_packet+0x504>
 1004f73:	3b 2d d7 3d 00 00    	cmp    0x3dd7(%rip),%ebp        # 1008d50 <global_ip>
 1004f79:	0f 85 d4 02 00 00    	jne    1005253 <_Z11arp_process15ethernet_packet+0x509>
 1004f7f:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
 1004f84:	48 c7 06 e5 88 00 01 	movq   $0x10088e5,(%rsi)
 1004f8b:	c7 46 08 23 00 00 00 	movl   $0x23,0x8(%rsi)
 1004f92:	4c 8b 05 bf 3d 00 00 	mov    0x3dbf(%rip),%r8        # 1008d58 <global_mac>
 1004f99:	4c 8d 7c 24 10       	lea    0x10(%rsp),%r15
 1004f9e:	4c 89 ff             	mov    %r15,%rdi
 1004fa1:	44 89 cb             	mov    %r9d,%ebx
 1004fa4:	44 89 ca             	mov    %r9d,%edx
 1004fa7:	89 e9                	mov    %ebp,%ecx
 1004fa9:	31 c0                	xor    %eax,%eax
 1004fab:	e8 19 c2 ff ff       	call   10011c9 <_Z6format8rostringz>
 1004fb0:	4c 89 ff             	mov    %r15,%rdi
 1004fb3:	e8 c8 c8 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1004fb8:	49 89 c7             	mov    %rax,%r15
 1004fbb:	8a 00                	mov    (%rax),%al
 1004fbd:	84 c0                	test   %al,%al
 1004fbf:	0f 84 39 02 00 00    	je     10051fe <_Z11arp_process15ethernet_packet+0x4b4>
 1004fc5:	49 ff c7             	inc    %r15
 1004fc8:	0f be f0             	movsbl %al,%esi
 1004fcb:	bf 00 00 11 00       	mov    $0x110000,%edi
 1004fd0:	e8 7d eb ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1004fd5:	41 8a 07             	mov    (%r15),%al
 1004fd8:	49 ff c7             	inc    %r15
 1004fdb:	84 c0                	test   %al,%al
 1004fdd:	75 e9                	jne    1004fc8 <_Z11arp_process15ethernet_packet+0x27e>
 1004fdf:	e9 1a 02 00 00       	jmp    10051fe <_Z11arp_process15ethernet_packet+0x4b4>
 1004fe4:	41 39 e9             	cmp    %ebp,%r9d
 1004fe7:	0f 85 0c 01 00 00    	jne    10050f9 <_Z11arp_process15ethernet_packet+0x3af>
 1004fed:	48 8d 74 24 58       	lea    0x58(%rsp),%rsi
 1004ff2:	48 c7 06 6a 89 00 01 	movq   $0x100896a,(%rsi)
 1004ff9:	c7 46 08 27 00 00 00 	movl   $0x27,0x8(%rsi)
 1005000:	4c 8d 7c 24 10       	lea    0x10(%rsp),%r15
 1005005:	4c 89 ff             	mov    %r15,%rdi
 1005008:	44 89 ca             	mov    %r9d,%edx
 100500b:	4c 89 f1             	mov    %r14,%rcx
 100500e:	31 c0                	xor    %eax,%eax
 1005010:	e8 b4 c1 ff ff       	call   10011c9 <_Z6format8rostringz>
 1005015:	4c 89 ff             	mov    %r15,%rdi
 1005018:	e8 63 c8 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 100501d:	48 89 c3             	mov    %rax,%rbx
 1005020:	8a 00                	mov    (%rax),%al
 1005022:	84 c0                	test   %al,%al
 1005024:	0f 84 8e 00 00 00    	je     10050b8 <_Z11arp_process15ethernet_packet+0x36e>
 100502a:	48 ff c3             	inc    %rbx
 100502d:	0f be f0             	movsbl %al,%esi
 1005030:	bf 00 00 11 00       	mov    $0x110000,%edi
 1005035:	e8 18 eb ff ff       	call   1003b52 <_ZN7console7putcharEc>
 100503a:	8a 03                	mov    (%rbx),%al
 100503c:	48 ff c3             	inc    %rbx
 100503f:	84 c0                	test   %al,%al
 1005041:	75 ea                	jne    100502d <_Z11arp_process15ethernet_packet+0x2e3>
 1005043:	eb 73                	jmp    10050b8 <_Z11arp_process15ethernet_packet+0x36e>
 1005045:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
 100504a:	48 c7 06 35 88 00 01 	movq   $0x1008835,(%rsi)
 1005051:	c7 46 08 34 00 00 00 	movl   $0x34,0x8(%rsi)
 1005058:	0f b7 c0             	movzwl %ax,%eax
 100505b:	3d 00 02 00 00       	cmp    $0x200,%eax
 1005060:	b8 96 84 00 01       	mov    $0x1008496,%eax
 1005065:	ba 89 85 00 01       	mov    $0x1008589,%edx
 100506a:	48 0f 44 d0          	cmove  %rax,%rdx
 100506e:	45 8b 45 0e          	mov    0xe(%r13),%r8d
 1005072:	41 8b 45 18          	mov    0x18(%r13),%eax
 1005076:	89 04 24             	mov    %eax,(%rsp)
 1005079:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
 100507e:	48 89 df             	mov    %rbx,%rdi
 1005081:	4c 89 f9             	mov    %r15,%rcx
 1005084:	4d 89 e1             	mov    %r12,%r9
 1005087:	31 c0                	xor    %eax,%eax
 1005089:	e8 3b c1 ff ff       	call   10011c9 <_Z6format8rostringz>
 100508e:	48 89 df             	mov    %rbx,%rdi
 1005091:	e8 ea c7 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1005096:	48 89 c3             	mov    %rax,%rbx
 1005099:	8a 00                	mov    (%rax),%al
 100509b:	84 c0                	test   %al,%al
 100509d:	74 19                	je     10050b8 <_Z11arp_process15ethernet_packet+0x36e>
 100509f:	48 ff c3             	inc    %rbx
 10050a2:	0f be f0             	movsbl %al,%esi
 10050a5:	bf 00 00 11 00       	mov    $0x110000,%edi
 10050aa:	e8 a3 ea ff ff       	call   1003b52 <_ZN7console7putcharEc>
 10050af:	8a 03                	mov    (%rbx),%al
 10050b1:	48 ff c3             	inc    %rbx
 10050b4:	84 c0                	test   %al,%al
 10050b6:	75 ea                	jne    10050a2 <_Z11arp_process15ethernet_packet+0x358>
 10050b8:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 10050bd:	48 85 c0             	test   %rax,%rax
 10050c0:	0f 84 8d 01 00 00    	je     1005253 <_Z11arp_process15ethernet_packet+0x509>
 10050c6:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10050ca:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10050ce:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10050d5:	00 04 
 10050d7:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 10050dc:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10050e3:	04 
 10050e4:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10050eb:	04 
 10050ec:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10050f3:	00 
 10050f4:	e9 5a 01 00 00       	jmp    1005253 <_Z11arp_process15ethernet_packet+0x509>
 10050f9:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
 10050fe:	48 c7 06 03 88 00 01 	movq   $0x1008803,(%rsi)
 1005105:	c7 46 08 24 00 00 00 	movl   $0x24,0x8(%rsi)
 100510c:	4c 8d 7c 24 10       	lea    0x10(%rsp),%r15
 1005111:	4c 89 ff             	mov    %r15,%rdi
 1005114:	44 89 cb             	mov    %r9d,%ebx
 1005117:	44 89 ca             	mov    %r9d,%edx
 100511a:	89 e9                	mov    %ebp,%ecx
 100511c:	31 c0                	xor    %eax,%eax
 100511e:	e8 a6 c0 ff ff       	call   10011c9 <_Z6format8rostringz>
 1005123:	4c 89 ff             	mov    %r15,%rdi
 1005126:	e8 55 c7 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 100512b:	49 89 c7             	mov    %rax,%r15
 100512e:	8a 00                	mov    (%rax),%al
 1005130:	84 c0                	test   %al,%al
 1005132:	74 1a                	je     100514e <_Z11arp_process15ethernet_packet+0x404>
 1005134:	49 ff c7             	inc    %r15
 1005137:	0f be f0             	movsbl %al,%esi
 100513a:	bf 00 00 11 00       	mov    $0x110000,%edi
 100513f:	e8 0e ea ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1005144:	41 8a 07             	mov    (%r15),%al
 1005147:	49 ff c7             	inc    %r15
 100514a:	84 c0                	test   %al,%al
 100514c:	75 e9                	jne    1005137 <_Z11arp_process15ethernet_packet+0x3ed>
 100514e:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 1005153:	48 85 c0             	test   %rax,%rax
 1005156:	74 2e                	je     1005186 <_Z11arp_process15ethernet_packet+0x43c>
 1005158:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 100515c:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1005160:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1005167:	00 04 
 1005169:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 100516e:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1005175:	04 
 1005176:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 100517d:	04 
 100517e:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1005185:	00 
 1005186:	81 fd 0a 00 02 0f    	cmp    $0xf02000a,%ebp
 100518c:	89 da                	mov    %ebx,%edx
 100518e:	75 0c                	jne    100519c <_Z11arp_process15ethernet_packet+0x452>
 1005190:	c7 05 b6 3b 00 00 0a 	movl   $0xf02000a,0x3bb6(%rip)        # 1008d50 <global_ip>
 1005197:	00 02 0f 
 100519a:	eb 0c                	jmp    10051a8 <_Z11arp_process15ethernet_packet+0x45e>
 100519c:	3b 2d ae 3b 00 00    	cmp    0x3bae(%rip),%ebp        # 1008d50 <global_ip>
 10051a2:	0f 85 ab 00 00 00    	jne    1005253 <_Z11arp_process15ethernet_packet+0x509>
 10051a8:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
 10051ad:	48 c7 06 e5 88 00 01 	movq   $0x10088e5,(%rsi)
 10051b4:	c7 46 08 23 00 00 00 	movl   $0x23,0x8(%rsi)
 10051bb:	4c 8b 05 96 3b 00 00 	mov    0x3b96(%rip),%r8        # 1008d58 <global_mac>
 10051c2:	4c 8d 7c 24 10       	lea    0x10(%rsp),%r15
 10051c7:	4c 89 ff             	mov    %r15,%rdi
 10051ca:	89 e9                	mov    %ebp,%ecx
 10051cc:	31 c0                	xor    %eax,%eax
 10051ce:	e8 f6 bf ff ff       	call   10011c9 <_Z6format8rostringz>
 10051d3:	4c 89 ff             	mov    %r15,%rdi
 10051d6:	e8 a5 c6 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 10051db:	49 89 c7             	mov    %rax,%r15
 10051de:	8a 00                	mov    (%rax),%al
 10051e0:	84 c0                	test   %al,%al
 10051e2:	74 1a                	je     10051fe <_Z11arp_process15ethernet_packet+0x4b4>
 10051e4:	49 ff c7             	inc    %r15
 10051e7:	0f be f0             	movsbl %al,%esi
 10051ea:	bf 00 00 11 00       	mov    $0x110000,%edi
 10051ef:	e8 5e e9 ff ff       	call   1003b52 <_ZN7console7putcharEc>
 10051f4:	41 8a 07             	mov    (%r15),%al
 10051f7:	49 ff c7             	inc    %r15
 10051fa:	84 c0                	test   %al,%al
 10051fc:	75 e9                	jne    10051e7 <_Z11arp_process15ethernet_packet+0x49d>
 10051fe:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 1005203:	48 85 c0             	test   %rax,%rax
 1005206:	74 2e                	je     1005236 <_Z11arp_process15ethernet_packet+0x4ec>
 1005208:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 100520c:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1005210:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1005217:	00 04 
 1005219:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 100521e:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1005225:	04 
 1005226:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 100522d:	04 
 100522e:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1005235:	00 
 1005236:	48 8b 35 1b 3b 00 00 	mov    0x3b1b(%rip),%rsi        # 1008d58 <global_mac>
 100523d:	8b 15 0d 3b 00 00    	mov    0x3b0d(%rip),%edx        # 1008d50 <global_ip>
 1005243:	bf 02 00 00 00       	mov    $0x2,%edi
 1005248:	4c 89 f1             	mov    %r14,%rcx
 100524b:	41 89 d8             	mov    %ebx,%r8d
 100524e:	e8 12 00 00 00       	call   1005265 <_Z8arp_sendt9arp_entryS_>
 1005253:	48 81 c4 a8 00 00 00 	add    $0xa8,%rsp
 100525a:	5b                   	pop    %rbx
 100525b:	41 5c                	pop    %r12
 100525d:	41 5d                	pop    %r13
 100525f:	41 5e                	pop    %r14
 1005261:	41 5f                	pop    %r15
 1005263:	5d                   	pop    %rbp
 1005264:	c3                   	ret    

0000000001005265 <_Z8arp_sendt9arp_entryS_>:
 1005265:	55                   	push   %rbp
 1005266:	41 57                	push   %r15
 1005268:	41 56                	push   %r14
 100526a:	41 54                	push   %r12
 100526c:	53                   	push   %rbx
 100526d:	48 81 ec 90 00 00 00 	sub    $0x90,%rsp
 1005274:	44 89 c5             	mov    %r8d,%ebp
 1005277:	49 89 f6             	mov    %rsi,%r14
 100527a:	41 89 ff             	mov    %edi,%r15d
 100527d:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
 1005282:	89 54 24 18          	mov    %edx,0x18(%rsp)
 1005286:	48 85 c9             	test   %rcx,%rcx
 1005289:	49 bc ff ff ff ff ff 	movabs $0xffffffffffff,%r12
 1005290:	ff 00 00 
 1005293:	4c 0f 45 e1          	cmovne %rcx,%r12
 1005297:	4c 89 64 24 08       	mov    %r12,0x8(%rsp)
 100529c:	bf 1c 00 00 00       	mov    $0x1c,%edi
 10052a1:	e8 c4 e9 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 10052a6:	48 89 c3             	mov    %rax,%rbx
 10052a9:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 10052ad:	c5 f8 29 00          	vmovaps %xmm0,(%rax)
 10052b1:	c5 f8 11 40 0c       	vmovups %xmm0,0xc(%rax)
 10052b6:	c7 00 00 01 08 00    	movl   $0x80100,(%rax)
 10052bc:	66 c7 40 04 06 04    	movw   $0x406,0x4(%rax)
 10052c2:	66 44 0f 38 f1 78 06 	movbe  %r15w,0x6(%rax)
 10052c9:	8b 44 24 18          	mov    0x18(%rsp),%eax
 10052cd:	89 43 0e             	mov    %eax,0xe(%rbx)
 10052d0:	89 6b 18             	mov    %ebp,0x18(%rbx)
 10052d3:	b8 08 00 00 00       	mov    $0x8,%eax
 10052d8:	8a 4c 04 08          	mov    0x8(%rsp,%rax,1),%cl
 10052dc:	88 0c 03             	mov    %cl,(%rbx,%rax,1)
 10052df:	48 ff c0             	inc    %rax
 10052e2:	48 83 f8 0e          	cmp    $0xe,%rax
 10052e6:	75 f0                	jne    10052d8 <_Z8arp_sendt9arp_entryS_+0x73>
 10052e8:	48 c7 c0 fa ff ff ff 	mov    $0xfffffffffffffffa,%rax
 10052ef:	8a 4c 04 0e          	mov    0xe(%rsp,%rax,1),%cl
 10052f3:	88 4c 03 18          	mov    %cl,0x18(%rbx,%rax,1)
 10052f7:	48 ff c0             	inc    %rax
 10052fa:	75 f3                	jne    10052ef <_Z8arp_sendt9arp_entryS_+0x8a>
 10052fc:	4c 8d 7c 24 58       	lea    0x58(%rsp),%r15
 1005301:	4c 89 ff             	mov    %r15,%rdi
 1005304:	e8 e7 20 00 00       	call   10073f0 <_ZN9timepointC1Ev>
 1005309:	4d 89 67 18          	mov    %r12,0x18(%r15)
 100530d:	4d 89 77 10          	mov    %r14,0x10(%r15)
 1005311:	66 b8 06 08          	mov    $0x806,%ax
 1005315:	66 41 89 47 20       	mov    %ax,0x20(%r15)
 100531a:	49 89 5f 28          	mov    %rbx,0x28(%r15)
 100531e:	41 c7 47 30 1c 00 00 	movl   $0x1c,0x30(%r15)
 1005325:	00 
 1005326:	48 8d 7c 24 20       	lea    0x20(%rsp),%rdi
 100532b:	c4 c1 78 10 07       	vmovups (%r15),%xmm0
 1005330:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
 1005334:	66 89 47 20          	mov    %ax,0x20(%rdi)
 1005338:	49 8b 47 10          	mov    0x10(%r15),%rax
 100533c:	48 89 47 10          	mov    %rax,0x10(%rdi)
 1005340:	49 8b 47 18          	mov    0x18(%r15),%rax
 1005344:	48 89 47 18          	mov    %rax,0x18(%rdi)
 1005348:	41 8b 47 30          	mov    0x30(%r15),%eax
 100534c:	48 89 5f 28          	mov    %rbx,0x28(%rdi)
 1005350:	89 47 30             	mov    %eax,0x30(%rdi)
 1005353:	e8 41 00 00 00       	call   1005399 <_Z13ethernet_send15ethernet_packet>
 1005358:	48 89 d8             	mov    %rbx,%rax
 100535b:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
 100535f:	48 8b 4b f0          	mov    -0x10(%rbx),%rcx
 1005363:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 100536a:	00 04 
 100536c:	c5 f8 11 43 f0       	vmovups %xmm0,-0x10(%rbx)
 1005371:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1005378:	04 
 1005379:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 1005380:	04 
 1005381:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1005388:	00 
 1005389:	48 81 c4 90 00 00 00 	add    $0x90,%rsp
 1005390:	5b                   	pop    %rbx
 1005391:	41 5c                	pop    %r12
 1005393:	41 5e                	pop    %r14
 1005395:	41 5f                	pop    %r15
 1005397:	5d                   	pop    %rbp
 1005398:	c3                   	ret    

0000000001005399 <_Z13ethernet_send15ethernet_packet>:
 1005399:	41 56                	push   %r14
 100539b:	53                   	push   %rbx
 100539c:	50                   	push   %rax
 100539d:	49 89 fe             	mov    %rdi,%r14
 10053a0:	48 63 7f 30          	movslq 0x30(%rdi),%rdi
 10053a4:	48 83 c7 0e          	add    $0xe,%rdi
 10053a8:	e8 bd e8 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 10053ad:	48 89 c3             	mov    %rax,%rbx
 10053b0:	31 c0                	xor    %eax,%eax
 10053b2:	41 8a 4c 06 18       	mov    0x18(%r14,%rax,1),%cl
 10053b7:	88 0c 03             	mov    %cl,(%rbx,%rax,1)
 10053ba:	48 ff c0             	inc    %rax
 10053bd:	48 83 f8 06          	cmp    $0x6,%rax
 10053c1:	75 ef                	jne    10053b2 <_Z13ethernet_send15ethernet_packet+0x19>
 10053c3:	31 c0                	xor    %eax,%eax
 10053c5:	41 8a 4c 06 10       	mov    0x10(%r14,%rax,1),%cl
 10053ca:	88 4c 03 06          	mov    %cl,0x6(%rbx,%rax,1)
 10053ce:	48 ff c0             	inc    %rax
 10053d1:	48 83 f8 06          	cmp    $0x6,%rax
 10053d5:	75 ee                	jne    10053c5 <_Z13ethernet_send15ethernet_packet+0x2c>
 10053d7:	41 0f b7 46 20       	movzwl 0x20(%r14),%eax
 10053dc:	66 0f 38 f1 43 0c    	movbe  %ax,0xc(%rbx)
 10053e2:	49 8b 46 28          	mov    0x28(%r14),%rax
 10053e6:	49 63 4e 30          	movslq 0x30(%r14),%rcx
 10053ea:	48 85 c9             	test   %rcx,%rcx
 10053ed:	74 13                	je     1005402 <_Z13ethernet_send15ethernet_packet+0x69>
 10053ef:	31 d2                	xor    %edx,%edx
 10053f1:	40 8a 34 10          	mov    (%rax,%rdx,1),%sil
 10053f5:	40 88 74 13 0e       	mov    %sil,0xe(%rbx,%rdx,1)
 10053fa:	48 ff c2             	inc    %rdx
 10053fd:	48 39 d1             	cmp    %rdx,%rcx
 1005400:	75 ef                	jne    10053f1 <_Z13ethernet_send15ethernet_packet+0x58>
 1005402:	41 8b 46 30          	mov    0x30(%r14),%eax
 1005406:	83 c0 0e             	add    $0xe,%eax
 1005409:	0f b7 f0             	movzwl %ax,%esi
 100540c:	48 89 df             	mov    %rbx,%rdi
 100540f:	e8 25 cf ff ff       	call   1002339 <_Z10e1000_sendPvt>
 1005414:	48 85 db             	test   %rbx,%rbx
 1005417:	74 31                	je     100544a <_Z13ethernet_send15ethernet_packet+0xb1>
 1005419:	48 89 d8             	mov    %rbx,%rax
 100541c:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
 1005420:	48 8b 4b f0          	mov    -0x10(%rbx),%rcx
 1005424:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 100542b:	00 04 
 100542d:	c5 f8 11 43 f0       	vmovups %xmm0,-0x10(%rbx)
 1005432:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1005439:	04 
 100543a:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 1005441:	04 
 1005442:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1005449:	00 
 100544a:	48 83 c4 08          	add    $0x8,%rsp
 100544e:	5b                   	pop    %rbx
 100544f:	41 5e                	pop    %r14
 1005451:	c3                   	ret    

0000000001005452 <_Z12arp_announcej>:
 1005452:	53                   	push   %rbx
 1005453:	48 83 ec 20          	sub    $0x20,%rsp
 1005457:	89 fa                	mov    %edi,%edx
 1005459:	89 3d f1 38 00 00    	mov    %edi,0x38f1(%rip)        # 1008d50 <global_ip>
 100545f:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
 1005464:	48 c7 06 6a 89 00 01 	movq   $0x100896a,(%rsi)
 100546b:	c7 46 08 27 00 00 00 	movl   $0x27,0x8(%rsi)
 1005472:	48 8b 0d df 38 00 00 	mov    0x38df(%rip),%rcx        # 1008d58 <global_mac>
 1005479:	48 89 e3             	mov    %rsp,%rbx
 100547c:	48 89 df             	mov    %rbx,%rdi
 100547f:	31 c0                	xor    %eax,%eax
 1005481:	e8 43 bd ff ff       	call   10011c9 <_Z6format8rostringz>
 1005486:	48 89 df             	mov    %rbx,%rdi
 1005489:	e8 f2 c3 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 100548e:	48 89 c3             	mov    %rax,%rbx
 1005491:	8a 00                	mov    (%rax),%al
 1005493:	84 c0                	test   %al,%al
 1005495:	74 19                	je     10054b0 <_Z12arp_announcej+0x5e>
 1005497:	48 ff c3             	inc    %rbx
 100549a:	0f be f0             	movsbl %al,%esi
 100549d:	bf 00 00 11 00       	mov    $0x110000,%edi
 10054a2:	e8 ab e6 ff ff       	call   1003b52 <_ZN7console7putcharEc>
 10054a7:	8a 03                	mov    (%rbx),%al
 10054a9:	48 ff c3             	inc    %rbx
 10054ac:	84 c0                	test   %al,%al
 10054ae:	75 ea                	jne    100549a <_Z12arp_announcej+0x48>
 10054b0:	48 8b 04 24          	mov    (%rsp),%rax
 10054b4:	48 85 c0             	test   %rax,%rax
 10054b7:	74 2e                	je     10054e7 <_Z12arp_announcej+0x95>
 10054b9:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10054bd:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10054c1:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10054c8:	00 04 
 10054ca:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 10054cf:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10054d6:	04 
 10054d7:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10054de:	04 
 10054df:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10054e6:	00 
 10054e7:	48 8b 35 6a 38 00 00 	mov    0x386a(%rip),%rsi        # 1008d58 <global_mac>
 10054ee:	8b 15 5c 38 00 00    	mov    0x385c(%rip),%edx        # 1008d50 <global_ip>
 10054f4:	bf 01 00 00 00       	mov    $0x1,%edi
 10054f9:	31 c9                	xor    %ecx,%ecx
 10054fb:	41 89 d0             	mov    %edx,%r8d
 10054fe:	e8 62 fd ff ff       	call   1005265 <_Z8arp_sendt9arp_entryS_>
 1005503:	48 83 c4 20          	add    $0x20,%rsp
 1005507:	5b                   	pop    %rbx
 1005508:	c3                   	ret    

0000000001005509 <_Z12ipv4_process15ethernet_packet>:
 1005509:	55                   	push   %rbp
 100550a:	41 57                	push   %r15
 100550c:	41 56                	push   %r14
 100550e:	53                   	push   %rbx
 100550f:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
 1005516:	4c 8b 7f 28          	mov    0x28(%rdi),%r15
 100551a:	4c 8b 77 28          	mov    0x28(%rdi),%r14
 100551e:	66 41 0f 38 f0 6f 02 	movbe  0x2(%r15),%bp
 1005525:	83 c5 ec             	add    $0xffffffec,%ebp
 1005528:	41 b8 ec ff 00 00    	mov    $0xffec,%r8d
 100552e:	44 03 47 30          	add    0x30(%rdi),%r8d
 1005532:	b8 ff ff 00 00       	mov    $0xffff,%eax
 1005537:	21 c5                	and    %eax,%ebp
 1005539:	41 21 c0             	and    %eax,%r8d
 100553c:	41 39 e8             	cmp    %ebp,%r8d
 100553f:	0f 83 90 00 00 00    	jae    10055d5 <_Z12ipv4_process15ethernet_packet+0xcc>
 1005545:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
 100554a:	48 c7 06 71 83 00 01 	movq   $0x1008371,(%rsi)
 1005551:	c7 46 08 4e 00 00 00 	movl   $0x4e,0x8(%rsi)
 1005558:	41 8b 57 0c          	mov    0xc(%r15),%edx
 100555c:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
 1005561:	48 89 df             	mov    %rbx,%rdi
 1005564:	89 e9                	mov    %ebp,%ecx
 1005566:	31 c0                	xor    %eax,%eax
 1005568:	e8 5c bc ff ff       	call   10011c9 <_Z6format8rostringz>
 100556d:	48 89 df             	mov    %rbx,%rdi
 1005570:	e8 0b c3 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1005575:	48 89 c3             	mov    %rax,%rbx
 1005578:	8a 00                	mov    (%rax),%al
 100557a:	84 c0                	test   %al,%al
 100557c:	74 19                	je     1005597 <_Z12ipv4_process15ethernet_packet+0x8e>
 100557e:	48 ff c3             	inc    %rbx
 1005581:	0f be f0             	movsbl %al,%esi
 1005584:	bf 00 00 11 00       	mov    $0x110000,%edi
 1005589:	e8 c4 e5 ff ff       	call   1003b52 <_ZN7console7putcharEc>
 100558e:	8a 03                	mov    (%rbx),%al
 1005590:	48 ff c3             	inc    %rbx
 1005593:	84 c0                	test   %al,%al
 1005595:	75 ea                	jne    1005581 <_Z12ipv4_process15ethernet_packet+0x78>
 1005597:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 100559c:	48 85 c0             	test   %rax,%rax
 100559f:	0f 84 9e 00 00 00    	je     1005643 <_Z12ipv4_process15ethernet_packet+0x13a>
 10055a5:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10055a9:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10055ad:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10055b4:	00 04 
 10055b6:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 10055bb:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10055c2:	04 
 10055c3:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10055ca:	04 
 10055cb:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10055d2:	00 
 10055d3:	eb 6e                	jmp    1005643 <_Z12ipv4_process15ethernet_packet+0x13a>
 10055d5:	48 89 fb             	mov    %rdi,%rbx
 10055d8:	48 8b 7f 10          	mov    0x10(%rdi),%rdi
 10055dc:	41 8b 77 0c          	mov    0xc(%r15),%esi
 10055e0:	e8 6e f6 ff ff       	call   1004c53 <_Z10arp_updatemj>
 10055e5:	8b 4b 30             	mov    0x30(%rbx),%ecx
 10055e8:	48 8b 43 28          	mov    0x28(%rbx),%rax
 10055ec:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
 10055f0:	41 8a 4f 09          	mov    0x9(%r15),%cl
 10055f4:	c4 c1 7b 10 47 0c    	vmovsd 0xc(%r15),%xmm0
 10055fa:	89 6c 24 08          	mov    %ebp,0x8(%rsp)
 10055fe:	80 f9 06             	cmp    $0x6,%cl
 1005601:	75 40                	jne    1005643 <_Z12ipv4_process15ethernet_packet+0x13a>
 1005603:	0f b7 4b 20          	movzwl 0x20(%rbx),%ecx
 1005607:	48 8d 7c 24 30       	lea    0x30(%rsp),%rdi
 100560c:	66 89 4f 20          	mov    %cx,0x20(%rdi)
 1005610:	c5 fc 10 0b          	vmovups (%rbx),%ymm1
 1005614:	c5 fc 11 0f          	vmovups %ymm1,(%rdi)
 1005618:	8b 4c 24 10          	mov    0x10(%rsp),%ecx
 100561c:	48 89 47 28          	mov    %rax,0x28(%rdi)
 1005620:	89 4f 30             	mov    %ecx,0x30(%rdi)
 1005623:	c6 47 38 06          	movb   $0x6,0x38(%rdi)
 1005627:	c5 f8 13 47 3c       	vmovlps %xmm0,0x3c(%rdi)
 100562c:	49 83 c6 14          	add    $0x14,%r14
 1005630:	8b 44 24 08          	mov    0x8(%rsp),%eax
 1005634:	4c 89 77 48          	mov    %r14,0x48(%rdi)
 1005638:	89 47 50             	mov    %eax,0x50(%rdi)
 100563b:	c5 f8 77             	vzeroupper 
 100563e:	e8 0e 00 00 00       	call   1005651 <_Z11tcp_process9ip_packet>
 1005643:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
 100564a:	5b                   	pop    %rbx
 100564b:	41 5e                	pop    %r14
 100564d:	41 5f                	pop    %r15
 100564f:	5d                   	pop    %rbp
 1005650:	c3                   	ret    

0000000001005651 <_Z11tcp_process9ip_packet>:
 1005651:	55                   	push   %rbp
 1005652:	41 57                	push   %r15
 1005654:	41 56                	push   %r14
 1005656:	41 55                	push   %r13
 1005658:	41 54                	push   %r12
 100565a:	53                   	push   %rbx
 100565b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
 1005662:	49 89 fe             	mov    %rdi,%r14
 1005665:	4c 8b 67 48          	mov    0x48(%rdi),%r12
 1005669:	41 0f b7 44 24 0c    	movzwl 0xc(%r12),%eax
 100566f:	41 89 c7             	mov    %eax,%r15d
 1005672:	41 c1 ef 02          	shr    $0x2,%r15d
 1005676:	41 83 e7 3c          	and    $0x3c,%r15d
 100567a:	8b 4f 50             	mov    0x50(%rdi),%ecx
 100567d:	48 8b 57 48          	mov    0x48(%rdi),%rdx
 1005681:	4c 01 fa             	add    %r15,%rdx
 1005684:	83 3d dd 36 00 00 00 	cmpl   $0x0,0x36dd(%rip)        # 1008d68 <open_connections+0x8>
 100568b:	0f 8e cf 03 00 00    	jle    1005a60 <_Z11tcp_process9ip_packet+0x40f>
 1005691:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
 1005696:	41 0f b7 c7          	movzwl %r15w,%eax
 100569a:	89 4c 24 2c          	mov    %ecx,0x2c(%rsp)
 100569e:	29 c1                	sub    %eax,%ecx
 10056a0:	0f b7 c1             	movzwl %cx,%eax
 10056a3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
 10056a8:	45 31 ed             	xor    %r13d,%r13d
 10056ab:	bf 60 8d 00 01       	mov    $0x1008d60,%edi
 10056b0:	44 89 ee             	mov    %r13d,%esi
 10056b3:	e8 12 0c 00 00       	call   10062ca <_ZN6vectorIP14tcp_connectionE2atEi>
 10056b8:	48 8b 18             	mov    (%rax),%rbx
 10056bb:	8b 53 1c             	mov    0x1c(%rbx),%edx
 10056be:	0f b7 4b 08          	movzwl 0x8(%rbx),%ecx
 10056c2:	83 fa 01             	cmp    $0x1,%edx
 10056c5:	75 2f                	jne    10056f6 <_Z11tcp_process9ip_packet+0xa5>
 10056c7:	41 0f b7 74 24 02    	movzwl 0x2(%r12),%esi
 10056cd:	89 f0                	mov    %esi,%eax
 10056cf:	66 c1 c0 08          	rol    $0x8,%ax
 10056d3:	66 85 c9             	test   %cx,%cx
 10056d6:	74 05                	je     10056dd <_Z11tcp_process9ip_packet+0x8c>
 10056d8:	66 39 c1             	cmp    %ax,%cx
 10056db:	75 1f                	jne    10056fc <_Z11tcp_process9ip_packet+0xab>
 10056dd:	41 0f b7 7c 24 0c    	movzwl 0xc(%r12),%edi
 10056e3:	81 e7 00 12 00 00    	and    $0x1200,%edi
 10056e9:	81 ff 00 02 00 00    	cmp    $0x200,%edi
 10056ef:	75 0b                	jne    10056fc <_Z11tcp_process9ip_packet+0xab>
 10056f1:	e9 81 04 00 00       	jmp    1005b77 <_Z11tcp_process9ip_packet+0x526>
 10056f6:	41 0f b7 74 24 02    	movzwl 0x2(%r12),%esi
 10056fc:	66 c1 c6 08          	rol    $0x8,%si
 1005700:	66 39 f1             	cmp    %si,%cx
 1005703:	0f 85 41 03 00 00    	jne    1005a4a <_Z11tcp_process9ip_packet+0x3f9>
 1005709:	85 d2                	test   %edx,%edx
 100570b:	0f 84 39 03 00 00    	je     1005a4a <_Z11tcp_process9ip_packet+0x3f9>
 1005711:	83 fa 02             	cmp    $0x2,%edx
 1005714:	0f 84 21 04 00 00    	je     1005b3b <_Z11tcp_process9ip_packet+0x4ea>
 100571a:	44 8b 43 04          	mov    0x4(%rbx),%r8d
 100571e:	45 3b 46 3c          	cmp    0x3c(%r14),%r8d
 1005722:	0f 85 22 03 00 00    	jne    1005a4a <_Z11tcp_process9ip_packet+0x3f9>
 1005728:	44 0f b7 4b 0a       	movzwl 0xa(%rbx),%r9d
 100572d:	66 41 0f 38 f0 04 24 	movbe  (%r12),%ax
 1005734:	66 41 39 c1          	cmp    %ax,%r9w
 1005738:	0f 85 0c 03 00 00    	jne    1005a4a <_Z11tcp_process9ip_packet+0x3f9>
 100573e:	41 0f b7 44 24 0c    	movzwl 0xc(%r12),%eax
 1005744:	0f ba e0 0a          	bt     $0xa,%eax
 1005748:	0f 82 2e 05 00 00    	jb     1005c7c <_Z11tcp_process9ip_packet+0x62b>
 100574e:	8d 4a fd             	lea    -0x3(%rdx),%ecx
 1005751:	83 f9 05             	cmp    $0x5,%ecx
 1005754:	77 11                	ja     1005767 <_Z11tcp_process9ip_packet+0x116>
 1005756:	ff 24 cd 10 83 00 01 	jmp    *0x1008310(,%rcx,8)
 100575d:	0f ba e0 08          	bt     $0x8,%eax
 1005761:	0f 82 aa 05 00 00    	jb     1005d11 <_Z11tcp_process9ip_packet+0x6c0>
 1005767:	0f ba e0 0b          	bt     $0xb,%eax
 100576b:	72 07                	jb     1005774 <_Z11tcp_process9ip_packet+0x123>
 100576d:	31 c0                	xor    %eax,%eax
 100576f:	e9 97 02 00 00       	jmp    1005a0b <_Z11tcp_process9ip_packet+0x3ba>
 1005774:	8d 42 fb             	lea    -0x5(%rdx),%eax
 1005777:	83 f8 02             	cmp    $0x2,%eax
 100577a:	0f 83 c3 05 00 00    	jae    1005d43 <_Z11tcp_process9ip_packet+0x6f2>
 1005780:	48 c7 44 24 48 23 8b 	movq   $0x1008b23,0x48(%rsp)
 1005787:	00 01 
 1005789:	c7 44 24 50 2f 00 00 	movl   $0x2f,0x50(%rsp)
 1005790:	00 
 1005791:	41 8b 4e 30          	mov    0x30(%r14),%ecx
 1005795:	48 8d 6c 24 08       	lea    0x8(%rsp),%rbp
 100579a:	48 89 ef             	mov    %rbp,%rdi
 100579d:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
 10057a2:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
 10057a7:	31 c0                	xor    %eax,%eax
 10057a9:	e8 1b ba ff ff       	call   10011c9 <_Z6format8rostringz>
 10057ae:	48 89 ef             	mov    %rbp,%rdi
 10057b1:	e8 ca c0 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 10057b6:	48 89 c5             	mov    %rax,%rbp
 10057b9:	8a 00                	mov    (%rax),%al
 10057bb:	84 c0                	test   %al,%al
 10057bd:	74 1a                	je     10057d9 <_Z11tcp_process9ip_packet+0x188>
 10057bf:	48 ff c5             	inc    %rbp
 10057c2:	0f be f0             	movsbl %al,%esi
 10057c5:	bf 00 00 11 00       	mov    $0x110000,%edi
 10057ca:	e8 83 e3 ff ff       	call   1003b52 <_ZN7console7putcharEc>
 10057cf:	8a 45 00             	mov    0x0(%rbp),%al
 10057d2:	48 ff c5             	inc    %rbp
 10057d5:	84 c0                	test   %al,%al
 10057d7:	75 e9                	jne    10057c2 <_Z11tcp_process9ip_packet+0x171>
 10057d9:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10057de:	48 85 c0             	test   %rax,%rax
 10057e1:	74 2e                	je     1005811 <_Z11tcp_process9ip_packet+0x1c0>
 10057e3:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10057e7:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10057eb:	c5 fa 6f 04 25 00 00 	vmovdqu 0x4000000,%xmm0
 10057f2:	00 04 
 10057f4:	c5 fa 7f 40 f0       	vmovdqu %xmm0,-0x10(%rax)
 10057f9:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1005800:	04 
 1005801:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1005808:	04 
 1005809:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1005810:	00 
 1005811:	8b 6b 18             	mov    0x18(%rbx),%ebp
 1005814:	41 0f 38 f0 44 24 04 	movbe  0x4(%r12),%eax
 100581b:	03 44 24 18          	add    0x18(%rsp),%eax
 100581f:	89 43 18             	mov    %eax,0x18(%rbx)
 1005822:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
 1005829:	00 00 
 100582b:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
 1005832:	00 
 1005833:	48 89 df             	mov    %rbx,%rdi
 1005836:	48 8d 74 24 38       	lea    0x38(%rsp),%rsi
 100583b:	ba 50 10 00 00       	mov    $0x1050,%edx
 1005840:	e8 dd 0a 00 00       	call   1006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>
 1005845:	41 0f 38 f0 54 24 04 	movbe  0x4(%r12),%edx
 100584c:	8b 43 20             	mov    0x20(%rbx),%eax
 100584f:	39 ea                	cmp    %ebp,%edx
 1005851:	75 16                	jne    1005869 <_Z11tcp_process9ip_packet+0x218>
 1005853:	85 c0                	test   %eax,%eax
 1005855:	0f 84 66 01 00 00    	je     10059c1 <_Z11tcp_process9ip_packet+0x370>
 100585b:	48 8d 4b 20          	lea    0x20(%rbx),%rcx
 100585f:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 1005864:	e9 93 00 00 00       	jmp    10058fc <_Z11tcp_process9ip_packet+0x2ab>
 1005869:	48 8d 4b 20          	lea    0x20(%rbx),%rcx
 100586d:	85 c0                	test   %eax,%eax
 100586f:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
 1005874:	0f 85 82 00 00 00    	jne    10058fc <_Z11tcp_process9ip_packet+0x2ab>
 100587a:	89 6b 20             	mov    %ebp,0x20(%rbx)
 100587d:	03 54 24 18          	add    0x18(%rsp),%edx
 1005881:	89 53 24             	mov    %edx,0x24(%rbx)
 1005884:	29 ea                	sub    %ebp,%edx
 1005886:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
 100588d:	00 00 
 100588f:	89 54 24 14          	mov    %edx,0x14(%rsp)
 1005893:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%rsp)
 100589a:	00 
 100589b:	48 63 fa             	movslq %edx,%rdi
 100589e:	e8 c7 e3 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 10058a3:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
 10058a8:	48 8d 7b 28          	lea    0x28(%rbx),%rdi
 10058ac:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 10058b1:	e8 88 0d 00 00       	call   100663e <_ZN6vectorIcEaSEOS0_>
 10058b6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10058bb:	48 85 c0             	test   %rax,%rax
 10058be:	74 2e                	je     10058ee <_Z11tcp_process9ip_packet+0x29d>
 10058c0:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10058c4:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10058c8:	c5 fa 6f 04 25 00 00 	vmovdqu 0x4000000,%xmm0
 10058cf:	00 04 
 10058d1:	c5 fa 7f 40 f0       	vmovdqu %xmm0,-0x10(%rax)
 10058d6:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10058dd:	04 
 10058de:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10058e5:	04 
 10058e6:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10058ed:	00 
 10058ee:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 10058f3:	8b 00                	mov    (%rax),%eax
 10058f5:	41 0f 38 f0 54 24 04 	movbe  0x4(%r12),%edx
 10058fc:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 1005901:	29 c2                	sub    %eax,%edx
 1005903:	48 8d 6b 28          	lea    0x28(%rbx),%rbp
 1005907:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 100590c:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
 1005911:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
 1005915:	48 89 ef             	mov    %rbp,%rdi
 1005918:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 100591d:	e8 b0 0d 00 00       	call   10066d2 <_ZN6vectorIcE4blitERK4spanIcEi>
 1005922:	41 0f 38 f0 44 24 04 	movbe  0x4(%r12),%eax
 1005929:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 100592e:	8d 14 08             	lea    (%rax,%rcx,1),%edx
 1005931:	8b 4b 24             	mov    0x24(%rbx),%ecx
 1005934:	39 ca                	cmp    %ecx,%edx
 1005936:	75 05                	jne    100593d <_Z11tcp_process9ip_packet+0x2ec>
 1005938:	89 43 24             	mov    %eax,0x24(%rbx)
 100593b:	89 c1                	mov    %eax,%ecx
 100593d:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
 1005942:	8b 16                	mov    (%rsi),%edx
 1005944:	39 d0                	cmp    %edx,%eax
 1005946:	75 04                	jne    100594c <_Z11tcp_process9ip_packet+0x2fb>
 1005948:	89 06                	mov    %eax,(%rsi)
 100594a:	89 c2                	mov    %eax,%edx
 100594c:	b0 01                	mov    $0x1,%al
 100594e:	39 ca                	cmp    %ecx,%edx
 1005950:	0f 85 b5 00 00 00    	jne    1005a0b <_Z11tcp_process9ip_packet+0x3ba>
 1005956:	48 89 ef             	mov    %rbp,%rdi
 1005959:	e8 c4 e5 ff ff       	call   1003f22 <_ZNK6vectorIcE5c_arrEv>
 100595e:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
 1005963:	48 8b 45 00          	mov    0x0(%rbp),%rax
 1005967:	48 85 c0             	test   %rax,%rax
 100596a:	74 2e                	je     100599a <_Z11tcp_process9ip_packet+0x349>
 100596c:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1005970:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1005974:	c5 fa 6f 04 25 00 00 	vmovdqu 0x4000000,%xmm0
 100597b:	00 04 
 100597d:	c5 fa 7f 40 f0       	vmovdqu %xmm0,-0x10(%rax)
 1005982:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1005989:	04 
 100598a:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1005991:	04 
 1005992:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1005999:	00 
 100599a:	48 c7 43 30 00 00 00 	movq   $0x0,0x30(%rbx)
 10059a1:	00 
 10059a2:	c5 f9 ef c0          	vpxor  %xmm0,%xmm0,%xmm0
 10059a6:	c5 fa 7f 43 20       	vmovdqu %xmm0,0x20(%rbx)
 10059ab:	48 8d 7b 38          	lea    0x38(%rbx),%rdi
 10059af:	8b 73 40             	mov    0x40(%rbx),%esi
 10059b2:	e8 4b 26 00 00       	call   1008002 <_ZN6vectorI10tcp_packetE2atEi>
 10059b7:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
 10059bc:	48 89 08             	mov    %rcx,(%rax)
 10059bf:	eb 40                	jmp    1005a01 <_Z11tcp_process9ip_packet+0x3b0>
 10059c1:	48 8b 6c 24 18       	mov    0x18(%rsp),%rbp
 10059c6:	48 89 ef             	mov    %rbp,%rdi
 10059c9:	e8 9c e2 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 10059ce:	48 89 ee             	mov    %rbp,%rsi
 10059d1:	48 89 c5             	mov    %rax,%rbp
 10059d4:	66 44 39 7c 24 2c    	cmp    %r15w,0x2c(%rsp)
 10059da:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
 10059df:	74 11                	je     10059f2 <_Z11tcp_process9ip_packet+0x3a1>
 10059e1:	31 c0                	xor    %eax,%eax
 10059e3:	8a 0c 02             	mov    (%rdx,%rax,1),%cl
 10059e6:	88 4c 05 00          	mov    %cl,0x0(%rbp,%rax,1)
 10059ea:	48 ff c0             	inc    %rax
 10059ed:	48 39 c6             	cmp    %rax,%rsi
 10059f0:	75 f1                	jne    10059e3 <_Z11tcp_process9ip_packet+0x392>
 10059f2:	48 8d 7b 38          	lea    0x38(%rbx),%rdi
 10059f6:	8b 73 40             	mov    0x40(%rbx),%esi
 10059f9:	e8 04 26 00 00       	call   1008002 <_ZN6vectorI10tcp_packetE2atEi>
 10059fe:	48 89 28             	mov    %rbp,(%rax)
 1005a01:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
 1005a06:	89 48 08             	mov    %ecx,0x8(%rax)
 1005a09:	b0 01                	mov    $0x1,%al
 1005a0b:	41 f6 44 24 0d 10    	testb  $0x10,0xd(%r12)
 1005a11:	74 23                	je     1005a36 <_Z11tcp_process9ip_packet+0x3e5>
 1005a13:	83 7b 1c 06          	cmpl   $0x6,0x1c(%rbx)
 1005a17:	75 09                	jne    1005a22 <_Z11tcp_process9ip_packet+0x3d1>
 1005a19:	c7 43 1c 05 00 00 00 	movl   $0x5,0x1c(%rbx)
 1005a20:	b0 01                	mov    $0x1,%al
 1005a22:	41 0f 38 f0 4c 24 04 	movbe  0x4(%r12),%ecx
 1005a29:	8b 53 18             	mov    0x18(%rbx),%edx
 1005a2c:	ff ca                	dec    %edx
 1005a2e:	39 d1                	cmp    %edx,%ecx
 1005a30:	0f 84 65 03 00 00    	je     1005d9b <_Z11tcp_process9ip_packet+0x74a>
 1005a36:	41 f6 44 24 0d 01    	testb  $0x1,0xd(%r12)
 1005a3c:	0f 85 90 03 00 00    	jne    1005dd2 <_Z11tcp_process9ip_packet+0x781>
 1005a42:	84 c0                	test   %al,%al
 1005a44:	0f 85 3e 04 00 00    	jne    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005a4a:	41 ff c5             	inc    %r13d
 1005a4d:	44 3b 2d 14 33 00 00 	cmp    0x3314(%rip),%r13d        # 1008d68 <open_connections+0x8>
 1005a54:	0f 8c 51 fc ff ff    	jl     10056ab <_Z11tcp_process9ip_packet+0x5a>
 1005a5a:	41 0f b7 44 24 0c    	movzwl 0xc(%r12),%eax
 1005a60:	0f ba e0 09          	bt     $0x9,%eax
 1005a64:	0f 82 93 00 00 00    	jb     1005afd <_Z11tcp_process9ip_packet+0x4ac>
 1005a6a:	48 8d 74 24 58       	lea    0x58(%rsp),%rsi
 1005a6f:	48 c7 06 2a 85 00 01 	movq   $0x100852a,(%rsi)
 1005a76:	c7 46 08 22 00 00 00 	movl   $0x22,0x8(%rsi)
 1005a7d:	0f b7 d0             	movzwl %ax,%edx
 1005a80:	c1 ea 08             	shr    $0x8,%edx
 1005a83:	48 8d 5c 24 08       	lea    0x8(%rsp),%rbx
 1005a88:	48 89 df             	mov    %rbx,%rdi
 1005a8b:	31 c0                	xor    %eax,%eax
 1005a8d:	e8 37 b7 ff ff       	call   10011c9 <_Z6format8rostringz>
 1005a92:	48 89 df             	mov    %rbx,%rdi
 1005a95:	e8 e6 bd ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1005a9a:	48 89 c3             	mov    %rax,%rbx
 1005a9d:	8a 00                	mov    (%rax),%al
 1005a9f:	84 c0                	test   %al,%al
 1005aa1:	74 19                	je     1005abc <_Z11tcp_process9ip_packet+0x46b>
 1005aa3:	48 ff c3             	inc    %rbx
 1005aa6:	0f be f0             	movsbl %al,%esi
 1005aa9:	bf 00 00 11 00       	mov    $0x110000,%edi
 1005aae:	e8 9f e0 ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1005ab3:	8a 03                	mov    (%rbx),%al
 1005ab5:	48 ff c3             	inc    %rbx
 1005ab8:	84 c0                	test   %al,%al
 1005aba:	75 ea                	jne    1005aa6 <_Z11tcp_process9ip_packet+0x455>
 1005abc:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1005ac1:	48 85 c0             	test   %rax,%rax
 1005ac4:	0f 84 be 03 00 00    	je     1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005aca:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1005ace:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1005ad2:	c5 fa 6f 04 25 00 00 	vmovdqu 0x4000000,%xmm0
 1005ad9:	00 04 
 1005adb:	c5 fa 7f 40 f0       	vmovdqu %xmm0,-0x10(%rax)
 1005ae0:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1005ae7:	04 
 1005ae8:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1005aef:	04 
 1005af0:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1005af7:	00 
 1005af8:	e9 8b 03 00 00       	jmp    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005afd:	e8 18 0c 00 00       	call   100671a <_Z10tcp_createv>
 1005b02:	c4 c1 7b 10 46 3c    	vmovsd 0x3c(%r14),%xmm0
 1005b08:	c5 f8 c6 c0 e1       	vshufps $0xe1,%xmm0,%xmm0,%xmm0
 1005b0d:	c5 f8 13 00          	vmovlps %xmm0,(%rax)
 1005b11:	c4 c1 79 6e 04 24    	vmovd  (%r12),%xmm0
 1005b17:	c4 e2 79 00 05 d0 27 	vpshufb 0x27d0(%rip),%xmm0,%xmm0        # 10082f0 <_ZL4lfsr+0x1b0>
 1005b1e:	00 00 
 1005b20:	c5 f9 7e 40 08       	vmovd  %xmm0,0x8(%rax)
 1005b25:	41 8b 4c 24 04       	mov    0x4(%r12),%ecx
 1005b2a:	0f 38 f1 48 10       	movbe  %ecx,0x10(%rax)
 1005b2f:	c7 40 1c 02 00 00 00 	movl   $0x2,0x1c(%rax)
 1005b36:	e9 4d 03 00 00       	jmp    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005b3b:	41 f6 44 24 0d 04    	testb  $0x4,0xd(%r12)
 1005b41:	0f 84 41 03 00 00    	je     1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005b47:	48 8d b4 24 c8 00 00 	lea    0xc8(%rsp),%rsi
 1005b4e:	00 
 1005b4f:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
 1005b56:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%rsi)
 1005b5d:	48 89 df             	mov    %rbx,%rdi
 1005b60:	ba 60 14 00 00       	mov    $0x1460,%edx
 1005b65:	e8 b8 07 00 00       	call   1006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>
 1005b6a:	48 89 df             	mov    %rbx,%rdi
 1005b6d:	e8 83 09 00 00       	call   10064f5 <_Z11tcp_destroyPV14tcp_connection>
 1005b72:	e9 11 03 00 00       	jmp    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005b77:	41 8b 4e 3c          	mov    0x3c(%r14),%ecx
 1005b7b:	89 4b 04             	mov    %ecx,0x4(%rbx)
 1005b7e:	41 8b 56 40          	mov    0x40(%r14),%edx
 1005b82:	89 13                	mov    %edx,(%rbx)
 1005b84:	41 0f b7 3c 24       	movzwl (%r12),%edi
 1005b89:	66 0f 38 f1 7b 0a    	movbe  %di,0xa(%rbx)
 1005b8f:	66 0f 38 f1 73 08    	movbe  %si,0x8(%rbx)
 1005b95:	8b 15 cd 31 00 00    	mov    0x31cd(%rip),%edx        # 1008d68 <open_connections+0x8>
 1005b9b:	0f 38 f1 53 0c       	movbe  %edx,0xc(%rbx)
 1005ba0:	41 8b 74 24 04       	mov    0x4(%r12),%esi
 1005ba5:	0f 38 f1 73 10       	movbe  %esi,0x10(%rbx)
 1005baa:	0f ce                	bswap  %esi
 1005bac:	ff c6                	inc    %esi
 1005bae:	89 73 18             	mov    %esi,0x18(%rbx)
 1005bb1:	0f 38 f1 53 14       	movbe  %edx,0x14(%rbx)
 1005bb6:	66 c1 c7 08          	rol    $0x8,%di
 1005bba:	c7 43 1c 04 00 00 00 	movl   $0x4,0x1c(%rbx)
 1005bc1:	48 8d b4 24 e8 00 00 	lea    0xe8(%rsp),%rsi
 1005bc8:	00 
 1005bc9:	48 c7 06 3c 86 00 01 	movq   $0x100863c,(%rsi)
 1005bd0:	c7 46 08 31 00 00 00 	movl   $0x31,0x8(%rsi)
 1005bd7:	0f b7 d0             	movzwl %ax,%edx
 1005bda:	44 0f b7 c7          	movzwl %di,%r8d
 1005bde:	4c 8d 74 24 08       	lea    0x8(%rsp),%r14
 1005be3:	4c 89 f7             	mov    %r14,%rdi
 1005be6:	31 c0                	xor    %eax,%eax
 1005be8:	e8 dc b5 ff ff       	call   10011c9 <_Z6format8rostringz>
 1005bed:	4c 89 f7             	mov    %r14,%rdi
 1005bf0:	e8 8b bc ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1005bf5:	49 89 c7             	mov    %rax,%r15
 1005bf8:	8a 00                	mov    (%rax),%al
 1005bfa:	84 c0                	test   %al,%al
 1005bfc:	74 1a                	je     1005c18 <_Z11tcp_process9ip_packet+0x5c7>
 1005bfe:	49 ff c7             	inc    %r15
 1005c01:	0f be f0             	movsbl %al,%esi
 1005c04:	bf 00 00 11 00       	mov    $0x110000,%edi
 1005c09:	e8 44 df ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1005c0e:	41 8a 07             	mov    (%r15),%al
 1005c11:	49 ff c7             	inc    %r15
 1005c14:	84 c0                	test   %al,%al
 1005c16:	75 e9                	jne    1005c01 <_Z11tcp_process9ip_packet+0x5b0>
 1005c18:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1005c1d:	48 85 c0             	test   %rax,%rax
 1005c20:	74 2e                	je     1005c50 <_Z11tcp_process9ip_packet+0x5ff>
 1005c22:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1005c26:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1005c2a:	c5 fa 6f 04 25 00 00 	vmovdqu 0x4000000,%xmm0
 1005c31:	00 04 
 1005c33:	c5 fa 7f 40 f0       	vmovdqu %xmm0,-0x10(%rax)
 1005c38:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1005c3f:	04 
 1005c40:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1005c47:	04 
 1005c48:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1005c4f:	00 
 1005c50:	c7 44 24 08 02 04 05 	movl   $0xb4050402,0x8(%rsp)
 1005c57:	b4 
 1005c58:	48 8d b4 24 d8 00 00 	lea    0xd8(%rsp),%rsi
 1005c5f:	00 
 1005c60:	4c 89 36             	mov    %r14,(%rsi)
 1005c63:	c7 46 08 04 00 00 00 	movl   $0x4,0x8(%rsi)
 1005c6a:	48 89 df             	mov    %rbx,%rdi
 1005c6d:	ba 60 12 00 00       	mov    $0x1260,%edx
 1005c72:	e8 ab 06 00 00       	call   1006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>
 1005c77:	e9 0c 02 00 00       	jmp    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005c7c:	b0 5b                	mov    $0x5b,%al
 1005c7e:	48 c7 c3 de ff ff ff 	mov    $0xffffffffffffffde,%rbx
 1005c85:	0f be f0             	movsbl %al,%esi
 1005c88:	bf 00 00 11 00       	mov    $0x110000,%edi
 1005c8d:	e8 c0 de ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1005c92:	8a 83 ac 87 00 01    	mov    0x10087ac(%rbx),%al
 1005c98:	48 ff c3             	inc    %rbx
 1005c9b:	75 e8                	jne    1005c85 <_Z11tcp_process9ip_packet+0x634>
 1005c9d:	e9 e6 01 00 00       	jmp    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005ca2:	25 00 1a 00 00       	and    $0x1a00,%eax
 1005ca7:	3d 00 10 00 00       	cmp    $0x1000,%eax
 1005cac:	0f 85 e8 01 00 00    	jne    1005e9a <_Z11tcp_process9ip_packet+0x849>
 1005cb2:	ff 43 14             	incl   0x14(%rbx)
 1005cb5:	c7 43 1c 05 00 00 00 	movl   $0x5,0x1c(%rbx)
 1005cbc:	e9 c7 01 00 00       	jmp    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005cc1:	0f ba e0 0c          	bt     $0xc,%eax
 1005cc5:	0f 83 bd 01 00 00    	jae    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005ccb:	eb 6a                	jmp    1005d37 <_Z11tcp_process9ip_packet+0x6e6>
 1005ccd:	f7 d0                	not    %eax
 1005ccf:	a9 00 12 00 00       	test   $0x1200,%eax
 1005cd4:	0f 85 e3 01 00 00    	jne    1005ebd <_Z11tcp_process9ip_packet+0x86c>
 1005cda:	41 0f 38 f0 44 24 04 	movbe  0x4(%r12),%eax
 1005ce1:	ff c0                	inc    %eax
 1005ce3:	89 43 18             	mov    %eax,0x18(%rbx)
 1005ce6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
 1005ced:	00 
 1005cee:	8b 44 24 08          	mov    0x8(%rsp),%eax
 1005cf2:	48 8d b4 24 b8 00 00 	lea    0xb8(%rsp),%rsi
 1005cf9:	00 
 1005cfa:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
 1005d01:	89 46 08             	mov    %eax,0x8(%rsi)
 1005d04:	48 89 df             	mov    %rbx,%rdi
 1005d07:	ba 50 10 00 00       	mov    $0x1050,%edx
 1005d0c:	e9 61 ff ff ff       	jmp    1005c72 <_Z11tcp_process9ip_packet+0x621>
 1005d11:	ff 43 18             	incl   0x18(%rbx)
 1005d14:	48 8d b4 24 a8 00 00 	lea    0xa8(%rsp),%rsi
 1005d1b:	00 
 1005d1c:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
 1005d23:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%rsi)
 1005d2a:	48 89 df             	mov    %rbx,%rdi
 1005d2d:	ba 50 10 00 00       	mov    $0x1050,%edx
 1005d32:	e8 eb 05 00 00       	call   1006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>
 1005d37:	c7 43 1c 09 00 00 00 	movl   $0x9,0x1c(%rbx)
 1005d3e:	e9 45 01 00 00       	jmp    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005d43:	48 8d b4 24 98 00 00 	lea    0x98(%rsp),%rsi
 1005d4a:	00 
 1005d4b:	48 c7 06 f5 8a 00 01 	movq   $0x1008af5,(%rsi)
 1005d52:	c7 46 08 2d 00 00 00 	movl   $0x2d,0x8(%rsi)
 1005d59:	48 8d 5c 24 08       	lea    0x8(%rsp),%rbx
 1005d5e:	48 89 df             	mov    %rbx,%rdi
 1005d61:	31 c0                	xor    %eax,%eax
 1005d63:	e8 61 b4 ff ff       	call   10011c9 <_Z6format8rostringz>
 1005d68:	48 89 df             	mov    %rbx,%rdi
 1005d6b:	e8 10 bb ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1005d70:	48 89 c3             	mov    %rax,%rbx
 1005d73:	8a 00                	mov    (%rax),%al
 1005d75:	84 c0                	test   %al,%al
 1005d77:	0f 84 3f fd ff ff    	je     1005abc <_Z11tcp_process9ip_packet+0x46b>
 1005d7d:	48 ff c3             	inc    %rbx
 1005d80:	0f be f0             	movsbl %al,%esi
 1005d83:	bf 00 00 11 00       	mov    $0x110000,%edi
 1005d88:	e8 c5 dd ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1005d8d:	8a 03                	mov    (%rbx),%al
 1005d8f:	48 ff c3             	inc    %rbx
 1005d92:	84 c0                	test   %al,%al
 1005d94:	75 ea                	jne    1005d80 <_Z11tcp_process9ip_packet+0x72f>
 1005d96:	e9 21 fd ff ff       	jmp    1005abc <_Z11tcp_process9ip_packet+0x46b>
 1005d9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%rsp)
 1005da2:	00 
 1005da3:	8b 44 24 08          	mov    0x8(%rsp),%eax
 1005da7:	48 8d b4 24 88 00 00 	lea    0x88(%rsp),%rsi
 1005dae:	00 
 1005daf:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
 1005db6:	89 46 08             	mov    %eax,0x8(%rsi)
 1005db9:	48 89 df             	mov    %rbx,%rdi
 1005dbc:	ba 50 10 00 00       	mov    $0x1050,%edx
 1005dc1:	e8 5c 05 00 00       	call   1006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>
 1005dc6:	41 f6 44 24 0d 01    	testb  $0x1,0xd(%r12)
 1005dcc:	0f 84 b6 00 00 00    	je     1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005dd2:	ff 43 18             	incl   0x18(%rbx)
 1005dd5:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
 1005dda:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
 1005de1:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%rsi)
 1005de8:	48 89 df             	mov    %rbx,%rdi
 1005deb:	ba 50 11 00 00       	mov    $0x1150,%edx
 1005df0:	e8 2d 05 00 00       	call   1006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>
 1005df5:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
 1005dfa:	48 c7 06 bd 89 00 01 	movq   $0x10089bd,(%rsi)
 1005e01:	c7 46 08 26 00 00 00 	movl   $0x26,0x8(%rsi)
 1005e08:	8b 53 04             	mov    0x4(%rbx),%edx
 1005e0b:	0f b7 4b 0a          	movzwl 0xa(%rbx),%ecx
 1005e0f:	4c 8d 74 24 08       	lea    0x8(%rsp),%r14
 1005e14:	4c 89 f7             	mov    %r14,%rdi
 1005e17:	31 c0                	xor    %eax,%eax
 1005e19:	e8 ab b3 ff ff       	call   10011c9 <_Z6format8rostringz>
 1005e1e:	4c 89 f7             	mov    %r14,%rdi
 1005e21:	e8 5a ba ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1005e26:	49 89 c6             	mov    %rax,%r14
 1005e29:	8a 00                	mov    (%rax),%al
 1005e2b:	84 c0                	test   %al,%al
 1005e2d:	74 1a                	je     1005e49 <_Z11tcp_process9ip_packet+0x7f8>
 1005e2f:	49 ff c6             	inc    %r14
 1005e32:	0f be f0             	movsbl %al,%esi
 1005e35:	bf 00 00 11 00       	mov    $0x110000,%edi
 1005e3a:	e8 13 dd ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1005e3f:	41 8a 06             	mov    (%r14),%al
 1005e42:	49 ff c6             	inc    %r14
 1005e45:	84 c0                	test   %al,%al
 1005e47:	75 e9                	jne    1005e32 <_Z11tcp_process9ip_packet+0x7e1>
 1005e49:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 1005e4e:	48 85 c0             	test   %rax,%rax
 1005e51:	74 2e                	je     1005e81 <_Z11tcp_process9ip_packet+0x830>
 1005e53:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1005e57:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1005e5b:	c5 fa 6f 04 25 00 00 	vmovdqu 0x4000000,%xmm0
 1005e62:	00 04 
 1005e64:	c5 fa 7f 40 f0       	vmovdqu %xmm0,-0x10(%rax)
 1005e69:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1005e70:	04 
 1005e71:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1005e78:	04 
 1005e79:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1005e80:	00 
 1005e81:	c7 43 1c 08 00 00 00 	movl   $0x8,0x1c(%rbx)
 1005e88:	48 81 c4 f8 00 00 00 	add    $0xf8,%rsp
 1005e8f:	5b                   	pop    %rbx
 1005e90:	41 5c                	pop    %r12
 1005e92:	41 5d                	pop    %r13
 1005e94:	41 5e                	pop    %r14
 1005e96:	41 5f                	pop    %r15
 1005e98:	5d                   	pop    %rbp
 1005e99:	c3                   	ret    
 1005e9a:	b0 5b                	mov    $0x5b,%al
 1005e9c:	48 c7 c3 c1 ff ff ff 	mov    $0xffffffffffffffc1,%rbx
 1005ea3:	0f be f0             	movsbl %al,%esi
 1005ea6:	bf 00 00 11 00       	mov    $0x110000,%edi
 1005eab:	e8 a2 dc ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1005eb0:	8a 83 2a 85 00 01    	mov    0x100852a(%rbx),%al
 1005eb6:	48 ff c3             	inc    %rbx
 1005eb9:	75 e8                	jne    1005ea3 <_Z11tcp_process9ip_packet+0x852>
 1005ebb:	eb cb                	jmp    1005e88 <_Z11tcp_process9ip_packet+0x837>
 1005ebd:	b0 5b                	mov    $0x5b,%al
 1005ebf:	48 c7 c3 bd ff ff ff 	mov    $0xffffffffffffffbd,%rbx
 1005ec6:	0f be f0             	movsbl %al,%esi
 1005ec9:	bf 00 00 11 00       	mov    $0x110000,%edi
 1005ece:	e8 7f dc ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1005ed3:	8a 83 1e 87 00 01    	mov    0x100871e(%rbx),%al
 1005ed9:	48 ff c3             	inc    %rbx
 1005edc:	75 e8                	jne    1005ec6 <_Z11tcp_process9ip_packet+0x875>
 1005ede:	eb a8                	jmp    1005e88 <_Z11tcp_process9ip_packet+0x837>

0000000001005ee0 <_Z9ipv4_send9ip_packet>:
 1005ee0:	41 57                	push   %r15
 1005ee2:	41 56                	push   %r14
 1005ee4:	53                   	push   %rbx
 1005ee5:	48 83 ec 70          	sub    $0x70,%rsp
 1005ee9:	49 89 fe             	mov    %rdi,%r14
 1005eec:	48 63 7f 50          	movslq 0x50(%rdi),%rdi
 1005ef0:	48 83 c7 14          	add    $0x14,%rdi
 1005ef4:	e8 71 dd ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1005ef9:	48 89 c3             	mov    %rax,%rbx
 1005efc:	66 c7 00 45 00       	movw   $0x45,(%rax)
 1005f01:	41 8b 46 50          	mov    0x50(%r14),%eax
 1005f05:	83 c0 14             	add    $0x14,%eax
 1005f08:	66 0f 38 f1 43 02    	movbe  %ax,0x2(%rbx)
 1005f0e:	c7 43 04 00 01 00 00 	movl   $0x100,0x4(%rbx)
 1005f15:	c6 43 08 40          	movb   $0x40,0x8(%rbx)
 1005f19:	41 8a 46 38          	mov    0x38(%r14),%al
 1005f1d:	88 43 09             	mov    %al,0x9(%rbx)
 1005f20:	49 8b 46 3c          	mov    0x3c(%r14),%rax
 1005f24:	48 89 43 0c          	mov    %rax,0xc(%rbx)
 1005f28:	66 c7 43 0a 00 00    	movw   $0x0,0xa(%rbx)
 1005f2e:	b9 14 00 00 00       	mov    $0x14,%ecx
 1005f33:	31 c0                	xor    %eax,%eax
 1005f35:	48 89 da             	mov    %rbx,%rdx
 1005f38:	0f b7 32             	movzwl (%rdx),%esi
 1005f3b:	48 83 c2 02          	add    $0x2,%rdx
 1005f3f:	48 01 f0             	add    %rsi,%rax
 1005f42:	81 c1 fe ff 00 00    	add    $0xfffe,%ecx
 1005f48:	0f b7 c9             	movzwl %cx,%ecx
 1005f4b:	83 f9 01             	cmp    $0x1,%ecx
 1005f4e:	77 e8                	ja     1005f38 <_Z9ipv4_send9ip_packet+0x58>
 1005f50:	48 3d 00 00 01 00    	cmp    $0x10000,%rax
 1005f56:	72 17                	jb     1005f6f <_Z9ipv4_send9ip_packet+0x8f>
 1005f58:	b9 ff ff 00 00       	mov    $0xffff,%ecx
 1005f5d:	48 89 c2             	mov    %rax,%rdx
 1005f60:	48 c1 ea 10          	shr    $0x10,%rdx
 1005f64:	48 21 c8             	and    %rcx,%rax
 1005f67:	48 01 d0             	add    %rdx,%rax
 1005f6a:	48 39 c8             	cmp    %rcx,%rax
 1005f6d:	77 ee                	ja     1005f5d <_Z9ipv4_send9ip_packet+0x7d>
 1005f6f:	f7 d0                	not    %eax
 1005f71:	66 89 43 0a          	mov    %ax,0xa(%rbx)
 1005f75:	49 8b 46 48          	mov    0x48(%r14),%rax
 1005f79:	49 63 4e 50          	movslq 0x50(%r14),%rcx
 1005f7d:	48 85 c9             	test   %rcx,%rcx
 1005f80:	74 13                	je     1005f95 <_Z9ipv4_send9ip_packet+0xb5>
 1005f82:	31 d2                	xor    %edx,%edx
 1005f84:	40 8a 34 10          	mov    (%rax,%rdx,1),%sil
 1005f88:	40 88 74 13 14       	mov    %sil,0x14(%rbx,%rdx,1)
 1005f8d:	48 ff c2             	inc    %rdx
 1005f90:	48 39 d1             	cmp    %rdx,%rcx
 1005f93:	75 ef                	jne    1005f84 <_Z9ipv4_send9ip_packet+0xa4>
 1005f95:	4c 8d 7c 24 38       	lea    0x38(%rsp),%r15
 1005f9a:	4c 89 ff             	mov    %r15,%rdi
 1005f9d:	e8 4e 14 00 00       	call   10073f0 <_ZN9timepointC1Ev>
 1005fa2:	66 41 c7 47 20 00 08 	movw   $0x800,0x20(%r15)
 1005fa9:	48 8b 05 a8 2d 00 00 	mov    0x2da8(%rip),%rax        # 1008d58 <global_mac>
 1005fb0:	49 89 47 10          	mov    %rax,0x10(%r15)
 1005fb4:	41 8b 7e 40          	mov    0x40(%r14),%edi
 1005fb8:	e8 41 ed ff ff       	call   1004cfe <_Z16arp_translate_ipj>
 1005fbd:	49 89 47 18          	mov    %rax,0x18(%r15)
 1005fc1:	41 8b 46 50          	mov    0x50(%r14),%eax
 1005fc5:	83 c0 14             	add    $0x14,%eax
 1005fc8:	49 89 5f 28          	mov    %rbx,0x28(%r15)
 1005fcc:	41 89 47 30          	mov    %eax,0x30(%r15)
 1005fd0:	41 0f b7 47 20       	movzwl 0x20(%r15),%eax
 1005fd5:	48 89 e7             	mov    %rsp,%rdi
 1005fd8:	c4 c1 78 10 07       	vmovups (%r15),%xmm0
 1005fdd:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
 1005fe1:	66 89 47 20          	mov    %ax,0x20(%rdi)
 1005fe5:	49 8b 47 10          	mov    0x10(%r15),%rax
 1005fe9:	48 89 47 10          	mov    %rax,0x10(%rdi)
 1005fed:	49 8b 47 18          	mov    0x18(%r15),%rax
 1005ff1:	48 89 47 18          	mov    %rax,0x18(%rdi)
 1005ff5:	41 8b 47 30          	mov    0x30(%r15),%eax
 1005ff9:	48 89 5f 28          	mov    %rbx,0x28(%rdi)
 1005ffd:	89 47 30             	mov    %eax,0x30(%rdi)
 1006000:	e8 94 f3 ff ff       	call   1005399 <_Z13ethernet_send15ethernet_packet>
 1006005:	48 89 d8             	mov    %rbx,%rax
 1006008:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
 100600c:	48 8b 4b f0          	mov    -0x10(%rbx),%rcx
 1006010:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006017:	00 04 
 1006019:	c5 f8 11 43 f0       	vmovups %xmm0,-0x10(%rbx)
 100601e:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1006025:	04 
 1006026:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 100602d:	04 
 100602e:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1006035:	00 
 1006036:	48 83 c4 70          	add    $0x70,%rsp
 100603a:	5b                   	pop    %rbx
 100603b:	41 5e                	pop    %r14
 100603d:	41 5f                	pop    %r15
 100603f:	c3                   	ret    

0000000001006040 <_Z8net_initv>:
 1006040:	41 57                	push   %r15
 1006042:	41 56                	push   %r14
 1006044:	53                   	push   %rbx
 1006045:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
 100604c:	4c 8b 35 cd 2c 00 00 	mov    0x2ccd(%rip),%r14        # 1008d20 <pci_dev>
 1006053:	41 8b 86 00 18 00 00 	mov    0x1800(%r14),%eax
 100605a:	85 c0                	test   %eax,%eax
 100605c:	7e 24                	jle    1006082 <_Z8net_initv+0x42>
 100605e:	48 c1 e0 04          	shl    $0x4,%rax
 1006062:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
 1006066:	45 31 ff             	xor    %r15d,%r15d
 1006069:	43 80 7c 3e 0b 02    	cmpb   $0x2,0xb(%r14,%r15,1)
 100606f:	75 08                	jne    1006079 <_Z8net_initv+0x39>
 1006071:	43 80 7c 3e 0a 00    	cmpb   $0x0,0xa(%r14,%r15,1)
 1006077:	74 1f                	je     1006098 <_Z8net_initv+0x58>
 1006079:	49 83 c7 30          	add    $0x30,%r15
 100607d:	4c 39 f8             	cmp    %r15,%rax
 1006080:	75 e7                	jne    1006069 <_Z8net_initv+0x29>
 1006082:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006087:	be ff 85 00 01       	mov    $0x10085ff,%esi
 100608c:	e8 09 b1 ff ff       	call   100119a <_ZN7console6putstrEPKc>
 1006091:	e8 b1 c5 ff ff       	call   1002647 <_Z9pci_printv>
 1006096:	eb fe                	jmp    1006096 <_Z8net_initv+0x56>
 1006098:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
 100609d:	48 c7 06 51 84 00 01 	movq   $0x1008451,(%rsi)
 10060a4:	c7 46 08 25 00 00 00 	movl   $0x25,0x8(%rsi)
 10060ab:	43 0f b7 54 3e 04    	movzwl 0x4(%r14,%r15,1),%edx
 10060b1:	43 0f b7 4c 3e 06    	movzwl 0x6(%r14,%r15,1),%ecx
 10060b7:	48 8d 5c 24 30       	lea    0x30(%rsp),%rbx
 10060bc:	48 89 df             	mov    %rbx,%rdi
 10060bf:	31 c0                	xor    %eax,%eax
 10060c1:	e8 03 b1 ff ff       	call   10011c9 <_Z6format8rostringz>
 10060c6:	48 89 df             	mov    %rbx,%rdi
 10060c9:	e8 b2 b7 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 10060ce:	48 89 c3             	mov    %rax,%rbx
 10060d1:	8a 00                	mov    (%rax),%al
 10060d3:	84 c0                	test   %al,%al
 10060d5:	74 19                	je     10060f0 <_Z8net_initv+0xb0>
 10060d7:	48 ff c3             	inc    %rbx
 10060da:	0f be f0             	movsbl %al,%esi
 10060dd:	bf 00 00 11 00       	mov    $0x110000,%edi
 10060e2:	e8 6b da ff ff       	call   1003b52 <_ZN7console7putcharEc>
 10060e7:	8a 03                	mov    (%rbx),%al
 10060e9:	48 ff c3             	inc    %rbx
 10060ec:	84 c0                	test   %al,%al
 10060ee:	75 ea                	jne    10060da <_Z8net_initv+0x9a>
 10060f0:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
 10060f5:	48 85 c0             	test   %rax,%rax
 10060f8:	74 2e                	je     1006128 <_Z8net_initv+0xe8>
 10060fa:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10060fe:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1006102:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006109:	00 04 
 100610b:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006110:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006117:	04 
 1006118:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 100611f:	04 
 1006120:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006127:	00 
 1006128:	c4 81 7c 10 04 3e    	vmovups (%r14,%r15,1),%ymm0
 100612e:	c4 81 7c 10 4c 3e 10 	vmovups 0x10(%r14,%r15,1),%ymm1
 1006135:	c5 fc 11 44 24 40    	vmovups %ymm0,0x40(%rsp)
 100613b:	c5 fc 11 4c 24 50    	vmovups %ymm1,0x50(%rsp)
 1006141:	c5 fc 10 44 24 40    	vmovups 0x40(%rsp),%ymm0
 1006147:	c5 fc 10 4c 24 50    	vmovups 0x50(%rsp),%ymm1
 100614d:	c5 fc 11 4c 24 10    	vmovups %ymm1,0x10(%rsp)
 1006153:	c5 fc 11 04 24       	vmovups %ymm0,(%rsp)
 1006158:	bf bf 61 00 01       	mov    $0x10061bf,%edi
 100615d:	be b4 62 00 01       	mov    $0x10062b4,%esi
 1006162:	c5 f8 77             	vzeroupper 
 1006165:	e8 6a b9 ff ff       	call   1001ad4 <_Z10e1000_init10pci_devicePFvPvtEPFvvE>
 100616a:	48 8b 05 8f 2a 00 00 	mov    0x2a8f(%rip),%rax        # 1008c00 <e1000_dev>
 1006171:	8b 48 0a             	mov    0xa(%rax),%ecx
 1006174:	0f b6 50 0e          	movzbl 0xe(%rax),%edx
 1006178:	48 c1 e2 20          	shl    $0x20,%rdx
 100617c:	48 09 ca             	or     %rcx,%rdx
 100617f:	0f b6 48 0f          	movzbl 0xf(%rax),%ecx
 1006183:	48 c1 e1 28          	shl    $0x28,%rcx
 1006187:	48 09 d1             	or     %rdx,%rcx
 100618a:	48 89 0d c7 2b 00 00 	mov    %rcx,0x2bc7(%rip)        # 1008d58 <global_mac>
 1006191:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 1006195:	c5 f8 29 05 a3 2b 00 	vmovaps %xmm0,0x2ba3(%rip)        # 1008d40 <arp_table>
 100619c:	00 
 100619d:	c5 f8 29 05 bb 2b 00 	vmovaps %xmm0,0x2bbb(%rip)        # 1008d60 <open_connections>
 10061a4:	00 
 10061a5:	48 8b 00             	mov    (%rax),%rax
 10061a8:	c7 80 d0 00 00 00 fb 	movl   $0xfb,0xd0(%rax)
 10061af:	00 00 00 
 10061b2:	48 81 c4 80 00 00 00 	add    $0x80,%rsp
 10061b9:	5b                   	pop    %rbx
 10061ba:	41 5e                	pop    %r14
 10061bc:	41 5f                	pop    %r15
 10061be:	c3                   	ret    

00000000010061bf <_Z16ethernet_recievePvt>:
 10061bf:	55                   	push   %rbp
 10061c0:	41 57                	push   %r15
 10061c2:	41 56                	push   %r14
 10061c4:	53                   	push   %rbx
 10061c5:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
 10061cc:	89 f5                	mov    %esi,%ebp
 10061ce:	48 89 fb             	mov    %rdi,%rbx
 10061d1:	83 c5 f2             	add    $0xfffffff2,%ebp
 10061d4:	4c 8d 7f 0e          	lea    0xe(%rdi),%r15
 10061d8:	4c 8d 74 24 08       	lea    0x8(%rsp),%r14
 10061dd:	4c 89 f7             	mov    %r14,%rdi
 10061e0:	e8 0b 12 00 00       	call   10073f0 <_ZN9timepointC1Ev>
 10061e5:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 10061e9:	c4 c1 78 11 46 10    	vmovups %xmm0,0x10(%r14)
 10061ef:	0f b7 43 0c          	movzwl 0xc(%rbx),%eax
 10061f3:	66 41 0f 38 f1 46 20 	movbe  %ax,0x20(%r14)
 10061fa:	0f b7 c5             	movzwl %bp,%eax
 10061fd:	4d 89 7e 28          	mov    %r15,0x28(%r14)
 1006201:	41 89 46 30          	mov    %eax,0x30(%r14)
 1006205:	b8 06 00 00 00       	mov    $0x6,%eax
 100620a:	8a 0c 03             	mov    (%rbx,%rax,1),%cl
 100620d:	88 4c 04 12          	mov    %cl,0x12(%rsp,%rax,1)
 1006211:	48 ff c0             	inc    %rax
 1006214:	48 83 f8 0c          	cmp    $0xc,%rax
 1006218:	75 f0                	jne    100620a <_Z16ethernet_recievePvt+0x4b>
 100621a:	48 c7 c0 fa ff ff ff 	mov    $0xfffffffffffffffa,%rax
 1006221:	8a 4c 03 06          	mov    0x6(%rbx,%rax,1),%cl
 1006225:	88 4c 04 26          	mov    %cl,0x26(%rsp,%rax,1)
 1006229:	48 ff c0             	inc    %rax
 100622c:	75 f3                	jne    1006221 <_Z16ethernet_recievePvt+0x62>
 100622e:	0f b7 44 24 28       	movzwl 0x28(%rsp),%eax
 1006233:	3d 00 08 00 00       	cmp    $0x800,%eax
 1006238:	74 3c                	je     1006276 <_Z16ethernet_recievePvt+0xb7>
 100623a:	3d 06 08 00 00       	cmp    $0x806,%eax
 100623f:	75 65                	jne    10062a6 <_Z16ethernet_recievePvt+0xe7>
 1006241:	0f b7 44 24 28       	movzwl 0x28(%rsp),%eax
 1006246:	48 8d bc 24 80 00 00 	lea    0x80(%rsp),%rdi
 100624d:	00 
 100624e:	66 89 47 20          	mov    %ax,0x20(%rdi)
 1006252:	c5 fc 10 44 24 08    	vmovups 0x8(%rsp),%ymm0
 1006258:	c5 fc 11 07          	vmovups %ymm0,(%rdi)
 100625c:	8b 44 24 38          	mov    0x38(%rsp),%eax
 1006260:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 1006265:	48 89 4f 28          	mov    %rcx,0x28(%rdi)
 1006269:	89 47 30             	mov    %eax,0x30(%rdi)
 100626c:	c5 f8 77             	vzeroupper 
 100626f:	e8 d6 ea ff ff       	call   1004d4a <_Z11arp_process15ethernet_packet>
 1006274:	eb 30                	jmp    10062a6 <_Z16ethernet_recievePvt+0xe7>
 1006276:	0f b7 44 24 28       	movzwl 0x28(%rsp),%eax
 100627b:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
 1006280:	66 89 47 20          	mov    %ax,0x20(%rdi)
 1006284:	c5 fc 10 44 24 08    	vmovups 0x8(%rsp),%ymm0
 100628a:	c5 fc 11 07          	vmovups %ymm0,(%rdi)
 100628e:	8b 44 24 38          	mov    0x38(%rsp),%eax
 1006292:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
 1006297:	48 89 4f 28          	mov    %rcx,0x28(%rdi)
 100629b:	89 47 30             	mov    %eax,0x30(%rdi)
 100629e:	c5 f8 77             	vzeroupper 
 10062a1:	e8 63 f2 ff ff       	call   1005509 <_Z12ipv4_process15ethernet_packet>
 10062a6:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
 10062ad:	5b                   	pop    %rbx
 10062ae:	41 5e                	pop    %r14
 10062b0:	41 5f                	pop    %r15
 10062b2:	5d                   	pop    %rbp
 10062b3:	c3                   	ret    

00000000010062b4 <_Z13ethernet_linkv>:
 10062b4:	50                   	push   %rax
 10062b5:	bf c0 a8 01 45       	mov    $0x4501a8c0,%edi
 10062ba:	e8 93 f1 ff ff       	call   1005452 <_Z12arp_announcej>
 10062bf:	bf a9 fe 01 45       	mov    $0x4501fea9,%edi
 10062c4:	58                   	pop    %rax
 10062c5:	e9 88 f1 ff ff       	jmp    1005452 <_Z12arp_announcej>

00000000010062ca <_ZN6vectorIP14tcp_connectionE2atEi>:
 10062ca:	41 56                	push   %r14
 10062cc:	53                   	push   %rbx
 10062cd:	50                   	push   %rax
 10062ce:	41 89 f6             	mov    %esi,%r14d
 10062d1:	48 89 fb             	mov    %rdi,%rbx
 10062d4:	8b 47 0c             	mov    0xc(%rdi),%eax
 10062d7:	39 f0                	cmp    %esi,%eax
 10062d9:	7f 26                	jg     1006301 <_ZN6vectorIP14tcp_connectionE2atEi+0x37>
 10062db:	83 f8 02             	cmp    $0x2,%eax
 10062de:	be 01 00 00 00       	mov    $0x1,%esi
 10062e3:	0f 4d f0             	cmovge %eax,%esi
 10062e6:	44 39 f6             	cmp    %r14d,%esi
 10062e9:	7f 0e                	jg     10062f9 <_ZN6vectorIP14tcp_connectionE2atEi+0x2f>
 10062eb:	c5 f2 2a c6          	vcvtsi2ss %esi,%xmm1,%xmm0
 10062ef:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
 10062f3:	c5 fa 2c f0          	vcvttss2si %xmm0,%esi
 10062f7:	eb ed                	jmp    10062e6 <_ZN6vectorIP14tcp_connectionE2atEi+0x1c>
 10062f9:	48 89 df             	mov    %rbx,%rdi
 10062fc:	e8 b7 18 00 00       	call   1007bb8 <_ZN6vectorIP14tcp_connectionE7reserveEi>
 1006301:	8b 43 08             	mov    0x8(%rbx),%eax
 1006304:	41 8d 4e 01          	lea    0x1(%r14),%ecx
 1006308:	39 c8                	cmp    %ecx,%eax
 100630a:	0f 4f c8             	cmovg  %eax,%ecx
 100630d:	89 4b 08             	mov    %ecx,0x8(%rbx)
 1006310:	49 63 c6             	movslq %r14d,%rax
 1006313:	48 c1 e0 03          	shl    $0x3,%rax
 1006317:	48 03 03             	add    (%rbx),%rax
 100631a:	48 83 c4 08          	add    $0x8,%rsp
 100631e:	5b                   	pop    %rbx
 100631f:	41 5e                	pop    %r14
 1006321:	c3                   	ret    

0000000001006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>:
 1006322:	55                   	push   %rbp
 1006323:	41 57                	push   %r15
 1006325:	41 56                	push   %r14
 1006327:	41 55                	push   %r13
 1006329:	41 54                	push   %r12
 100632b:	53                   	push   %rbx
 100632c:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
 1006333:	89 d5                	mov    %edx,%ebp
 1006335:	49 89 f6             	mov    %rsi,%r14
 1006338:	49 89 ff             	mov    %rdi,%r15
 100633b:	48 63 7e 08          	movslq 0x8(%rsi),%rdi
 100633f:	48 83 c7 14          	add    $0x14,%rdi
 1006343:	e8 22 d9 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1006348:	48 89 c3             	mov    %rax,%rbx
 100634b:	c4 c1 7a 7e 47 08    	vmovq  0x8(%r15),%xmm0
 1006351:	c4 e2 79 00 05 66 1f 	vpshufb 0x1f66(%rip),%xmm0,%xmm0        # 10082c0 <_ZL4lfsr+0x180>
 1006358:	00 00 
 100635a:	c5 f9 7e 00          	vmovd  %xmm0,(%rax)
 100635e:	c4 c1 7a 7e 47 14    	vmovq  0x14(%r15),%xmm0
 1006364:	c4 e2 79 00 05 73 1f 	vpshufb 0x1f73(%rip),%xmm0,%xmm0        # 10082e0 <_ZL4lfsr+0x1a0>
 100636b:	00 00 
 100636d:	c5 f9 d6 40 04       	vmovq  %xmm0,0x4(%rax)
 1006372:	66 89 68 0c          	mov    %bp,0xc(%rax)
 1006376:	c7 40 0e ff ff 00 00 	movl   $0xffff,0xe(%rax)
 100637d:	66 c7 40 12 00 00    	movw   $0x0,0x12(%rax)
 1006383:	41 8b 46 08          	mov    0x8(%r14),%eax
 1006387:	45 8b 27             	mov    (%r15),%r12d
 100638a:	45 8b 6f 04          	mov    0x4(%r15),%r13d
 100638e:	49 8b 0e             	mov    (%r14),%rcx
 1006391:	49 63 56 08          	movslq 0x8(%r14),%rdx
 1006395:	48 85 d2             	test   %rdx,%rdx
 1006398:	74 13                	je     10063ad <_ZL12tcp_transmitP14tcp_connection10tcp_packett+0x8b>
 100639a:	31 f6                	xor    %esi,%esi
 100639c:	40 8a 3c 31          	mov    (%rcx,%rsi,1),%dil
 10063a0:	40 88 7c 33 14       	mov    %dil,0x14(%rbx,%rsi,1)
 10063a5:	48 ff c6             	inc    %rsi
 10063a8:	48 39 f2             	cmp    %rsi,%rdx
 10063ab:	75 ef                	jne    100639c <_ZL12tcp_transmitP14tcp_connection10tcp_packett+0x7a>
 10063ad:	83 c0 14             	add    $0x14,%eax
 10063b0:	44 89 e1             	mov    %r12d,%ecx
 10063b3:	c1 e9 10             	shr    $0x10,%ecx
 10063b6:	ba ff ff 00 00       	mov    $0xffff,%edx
 10063bb:	4c 89 e6             	mov    %r12,%rsi
 10063be:	48 21 d6             	and    %rdx,%rsi
 10063c1:	48 01 ce             	add    %rcx,%rsi
 10063c4:	44 89 e9             	mov    %r13d,%ecx
 10063c7:	c1 e9 10             	shr    $0x10,%ecx
 10063ca:	4c 21 ea             	and    %r13,%rdx
 10063cd:	48 01 ca             	add    %rcx,%rdx
 10063d0:	48 01 f2             	add    %rsi,%rdx
 10063d3:	89 c1                	mov    %eax,%ecx
 10063d5:	66 c1 c1 08          	rol    $0x8,%cx
 10063d9:	0f b7 c9             	movzwl %cx,%ecx
 10063dc:	48 01 d1             	add    %rdx,%rcx
 10063df:	48 81 c1 00 06 00 00 	add    $0x600,%rcx
 10063e6:	66 c7 43 10 00 00    	movw   $0x0,0x10(%rbx)
 10063ec:	48 89 da             	mov    %rbx,%rdx
 10063ef:	66 83 f8 02          	cmp    $0x2,%ax
 10063f3:	72 13                	jb     1006408 <_ZL12tcp_transmitP14tcp_connection10tcp_packett+0xe6>
 10063f5:	0f b7 32             	movzwl (%rdx),%esi
 10063f8:	48 83 c2 02          	add    $0x2,%rdx
 10063fc:	48 01 f1             	add    %rsi,%rcx
 10063ff:	83 c0 fe             	add    $0xfffffffe,%eax
 1006402:	66 83 f8 01          	cmp    $0x1,%ax
 1006406:	77 ed                	ja     10063f5 <_ZL12tcp_transmitP14tcp_connection10tcp_packett+0xd3>
 1006408:	66 85 c0             	test   %ax,%ax
 100640b:	74 06                	je     1006413 <_ZL12tcp_transmitP14tcp_connection10tcp_packett+0xf1>
 100640d:	0f b6 02             	movzbl (%rdx),%eax
 1006410:	48 01 c1             	add    %rax,%rcx
 1006413:	48 81 f9 00 00 01 00 	cmp    $0x10000,%rcx
 100641a:	72 17                	jb     1006433 <_ZL12tcp_transmitP14tcp_connection10tcp_packett+0x111>
 100641c:	b8 ff ff 00 00       	mov    $0xffff,%eax
 1006421:	48 89 ca             	mov    %rcx,%rdx
 1006424:	48 c1 ea 10          	shr    $0x10,%rdx
 1006428:	48 21 c1             	and    %rax,%rcx
 100642b:	48 01 d1             	add    %rdx,%rcx
 100642e:	48 39 c1             	cmp    %rax,%rcx
 1006431:	77 ee                	ja     1006421 <_ZL12tcp_transmitP14tcp_connection10tcp_packett+0xff>
 1006433:	f7 d1                	not    %ecx
 1006435:	66 89 4b 10          	mov    %cx,0x10(%rbx)
 1006439:	4c 8d 7c 24 60       	lea    0x60(%rsp),%r15
 100643e:	4c 89 ff             	mov    %r15,%rdi
 1006441:	e8 aa 0f 00 00       	call   10073f0 <_ZN9timepointC1Ev>
 1006446:	31 c0                	xor    %eax,%eax
 1006448:	49 89 47 28          	mov    %rax,0x28(%r15)
 100644c:	41 c7 47 30 00 00 00 	movl   $0x0,0x30(%r15)
 1006453:	00 
 1006454:	45 89 67 3c          	mov    %r12d,0x3c(%r15)
 1006458:	45 89 6f 40          	mov    %r13d,0x40(%r15)
 100645c:	41 c6 47 38 06       	movb   $0x6,0x38(%r15)
 1006461:	41 8b 4e 08          	mov    0x8(%r14),%ecx
 1006465:	83 c1 14             	add    $0x14,%ecx
 1006468:	49 89 5f 48          	mov    %rbx,0x48(%r15)
 100646c:	41 89 4f 50          	mov    %ecx,0x50(%r15)
 1006470:	c4 c1 7c 10 07       	vmovups (%r15),%ymm0
 1006475:	48 89 e7             	mov    %rsp,%rdi
 1006478:	c5 fc 11 07          	vmovups %ymm0,(%rdi)
 100647c:	41 0f b7 4f 20       	movzwl 0x20(%r15),%ecx
 1006481:	66 89 4f 20          	mov    %cx,0x20(%rdi)
 1006485:	41 8b 4f 30          	mov    0x30(%r15),%ecx
 1006489:	48 89 47 28          	mov    %rax,0x28(%rdi)
 100648d:	89 4f 30             	mov    %ecx,0x30(%rdi)
 1006490:	49 8b 47 38          	mov    0x38(%r15),%rax
 1006494:	48 89 47 38          	mov    %rax,0x38(%rdi)
 1006498:	41 8b 47 40          	mov    0x40(%r15),%eax
 100649c:	89 47 40             	mov    %eax,0x40(%rdi)
 100649f:	41 8b 47 50          	mov    0x50(%r15),%eax
 10064a3:	48 89 5f 48          	mov    %rbx,0x48(%rdi)
 10064a7:	89 47 50             	mov    %eax,0x50(%rdi)
 10064aa:	c5 f8 77             	vzeroupper 
 10064ad:	e8 2e fa ff ff       	call   1005ee0 <_Z9ipv4_send9ip_packet>
 10064b2:	48 89 d8             	mov    %rbx,%rax
 10064b5:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
 10064b9:	48 8b 4b f0          	mov    -0x10(%rbx),%rcx
 10064bd:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10064c4:	00 04 
 10064c6:	c5 f8 11 43 f0       	vmovups %xmm0,-0x10(%rbx)
 10064cb:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 10064d2:	04 
 10064d3:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 10064da:	04 
 10064db:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 10064e2:	00 
 10064e3:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
 10064ea:	5b                   	pop    %rbx
 10064eb:	41 5c                	pop    %r12
 10064ed:	41 5d                	pop    %r13
 10064ef:	41 5e                	pop    %r14
 10064f1:	41 5f                	pop    %r15
 10064f3:	5d                   	pop    %rbp
 10064f4:	c3                   	ret    

00000000010064f5 <_Z11tcp_destroyPV14tcp_connection>:
 10064f5:	55                   	push   %rbp
 10064f6:	53                   	push   %rbx
 10064f7:	50                   	push   %rax
 10064f8:	48 89 fb             	mov    %rdi,%rbx
 10064fb:	83 7f 40 00          	cmpl   $0x0,0x40(%rdi)
 10064ff:	7e 4f                	jle    1006550 <_Z11tcp_destroyPV14tcp_connection+0x5b>
 1006501:	31 c0                	xor    %eax,%eax
 1006503:	31 c9                	xor    %ecx,%ecx
 1006505:	48 8b 53 38          	mov    0x38(%rbx),%rdx
 1006509:	48 8b 14 02          	mov    (%rdx,%rax,1),%rdx
 100650d:	48 85 d2             	test   %rdx,%rdx
 1006510:	74 2e                	je     1006540 <_Z11tcp_destroyPV14tcp_connection+0x4b>
 1006512:	48 8d 72 f0          	lea    -0x10(%rdx),%rsi
 1006516:	48 8b 7a f0          	mov    -0x10(%rdx),%rdi
 100651a:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006521:	00 04 
 1006523:	c5 f8 11 42 f0       	vmovups %xmm0,-0x10(%rdx)
 1006528:	48 89 3c 25 00 00 00 	mov    %rdi,0x4000000
 100652f:	04 
 1006530:	48 89 34 25 08 00 00 	mov    %rsi,0x4000008
 1006537:	04 
 1006538:	48 29 3c 25 28 00 11 	sub    %rdi,0x110028
 100653f:	00 
 1006540:	48 ff c1             	inc    %rcx
 1006543:	48 63 53 40          	movslq 0x40(%rbx),%rdx
 1006547:	48 83 c0 10          	add    $0x10,%rax
 100654b:	48 39 d1             	cmp    %rdx,%rcx
 100654e:	7c b5                	jl     1006505 <_Z11tcp_destroyPV14tcp_connection+0x10>
 1006550:	83 3d 11 28 00 00 00 	cmpl   $0x0,0x2811(%rip)        # 1008d68 <open_connections+0x8>
 1006557:	7e 34                	jle    100658d <_Z11tcp_destroyPV14tcp_connection+0x98>
 1006559:	31 ed                	xor    %ebp,%ebp
 100655b:	bf 60 8d 00 01       	mov    $0x1008d60,%edi
 1006560:	89 ee                	mov    %ebp,%esi
 1006562:	e8 d7 16 00 00       	call   1007c3e <_ZN4spanIP14tcp_connectionE2atEi>
 1006567:	48 39 18             	cmp    %rbx,(%rax)
 100656a:	74 0c                	je     1006578 <_Z11tcp_destroyPV14tcp_connection+0x83>
 100656c:	ff c5                	inc    %ebp
 100656e:	3b 2d f4 27 00 00    	cmp    0x27f4(%rip),%ebp        # 1008d68 <open_connections+0x8>
 1006574:	7c e5                	jl     100655b <_Z11tcp_destroyPV14tcp_connection+0x66>
 1006576:	eb 0c                	jmp    1006584 <_Z11tcp_destroyPV14tcp_connection+0x8f>
 1006578:	bf 60 8d 00 01       	mov    $0x1008d60,%edi
 100657d:	89 ee                	mov    %ebp,%esi
 100657f:	e8 e2 04 00 00       	call   1006a66 <_ZN6vectorIP14tcp_connectionE5eraseEi>
 1006584:	48 85 db             	test   %rbx,%rbx
 1006587:	0f 84 aa 00 00 00    	je     1006637 <_Z11tcp_destroyPV14tcp_connection+0x142>
 100658d:	48 8b 43 38          	mov    0x38(%rbx),%rax
 1006591:	48 85 c0             	test   %rax,%rax
 1006594:	74 2e                	je     10065c4 <_Z11tcp_destroyPV14tcp_connection+0xcf>
 1006596:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 100659a:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 100659e:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10065a5:	00 04 
 10065a7:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 10065ac:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10065b3:	04 
 10065b4:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10065bb:	04 
 10065bc:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10065c3:	00 
 10065c4:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 10065c8:	c5 f8 11 43 38       	vmovups %xmm0,0x38(%rbx)
 10065cd:	48 8b 43 28          	mov    0x28(%rbx),%rax
 10065d1:	48 85 c0             	test   %rax,%rax
 10065d4:	74 2e                	je     1006604 <_Z11tcp_destroyPV14tcp_connection+0x10f>
 10065d6:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10065da:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10065de:	c5 f8 10 0c 25 00 00 	vmovups 0x4000000,%xmm1
 10065e5:	00 04 
 10065e7:	c5 f8 11 48 f0       	vmovups %xmm1,-0x10(%rax)
 10065ec:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10065f3:	04 
 10065f4:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10065fb:	04 
 10065fc:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006603:	00 
 1006604:	c5 f8 11 43 28       	vmovups %xmm0,0x28(%rbx)
 1006609:	48 8d 43 f0          	lea    -0x10(%rbx),%rax
 100660d:	48 8b 4b f0          	mov    -0x10(%rbx),%rcx
 1006611:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006618:	00 04 
 100661a:	c5 f8 11 43 f0       	vmovups %xmm0,-0x10(%rbx)
 100661f:	48 89 0c 25 00 00 00 	mov    %rcx,0x4000000
 1006626:	04 
 1006627:	48 89 04 25 08 00 00 	mov    %rax,0x4000008
 100662e:	04 
 100662f:	48 29 0c 25 28 00 11 	sub    %rcx,0x110028
 1006636:	00 
 1006637:	48 83 c4 08          	add    $0x8,%rsp
 100663b:	5b                   	pop    %rbx
 100663c:	5d                   	pop    %rbp
 100663d:	c3                   	ret    

000000000100663e <_ZN6vectorIcEaSEOS0_>:
 100663e:	48 89 f8             	mov    %rdi,%rax
 1006641:	48 8b 0f             	mov    (%rdi),%rcx
 1006644:	48 85 c9             	test   %rcx,%rcx
 1006647:	74 2e                	je     1006677 <_ZN6vectorIcEaSEOS0_+0x39>
 1006649:	48 8d 51 f0          	lea    -0x10(%rcx),%rdx
 100664d:	48 8b 79 f0          	mov    -0x10(%rcx),%rdi
 1006651:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006658:	00 04 
 100665a:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
 100665f:	48 89 3c 25 00 00 00 	mov    %rdi,0x4000000
 1006666:	04 
 1006667:	48 89 14 25 08 00 00 	mov    %rdx,0x4000008
 100666e:	04 
 100666f:	48 29 3c 25 28 00 11 	sub    %rdi,0x110028
 1006676:	00 
 1006677:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 100667b:	c5 f8 11 00          	vmovups %xmm0,(%rax)
 100667f:	48 8b 0e             	mov    (%rsi),%rcx
 1006682:	48 89 08             	mov    %rcx,(%rax)
 1006685:	48 8b 4e 08          	mov    0x8(%rsi),%rcx
 1006689:	48 89 48 08          	mov    %rcx,0x8(%rax)
 100668d:	c5 f8 11 06          	vmovups %xmm0,(%rsi)
 1006691:	c3                   	ret    

0000000001006692 <_ZN6vectorIcED2Ev>:
 1006692:	48 8b 07             	mov    (%rdi),%rax
 1006695:	48 85 c0             	test   %rax,%rax
 1006698:	74 2e                	je     10066c8 <_ZN6vectorIcED2Ev+0x36>
 100669a:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 100669e:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10066a2:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10066a9:	00 04 
 10066ab:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 10066b0:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10066b7:	04 
 10066b8:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10066bf:	04 
 10066c0:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10066c7:	00 
 10066c8:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 10066cc:	c5 f8 11 07          	vmovups %xmm0,(%rdi)
 10066d0:	c3                   	ret    
 10066d1:	cc                   	int3   

00000000010066d2 <_ZN6vectorIcE4blitERK4spanIcEi>:
 10066d2:	83 7e 08 00          	cmpl   $0x0,0x8(%rsi)
 10066d6:	7e 41                	jle    1006719 <_ZN6vectorIcE4blitERK4spanIcEi+0x47>
 10066d8:	55                   	push   %rbp
 10066d9:	41 57                	push   %r15
 10066db:	41 56                	push   %r14
 10066dd:	41 54                	push   %r12
 10066df:	53                   	push   %rbx
 10066e0:	89 d3                	mov    %edx,%ebx
 10066e2:	49 89 f6             	mov    %rsi,%r14
 10066e5:	49 89 ff             	mov    %rdi,%r15
 10066e8:	45 31 e4             	xor    %r12d,%r12d
 10066eb:	4c 89 f7             	mov    %r14,%rdi
 10066ee:	44 89 e6             	mov    %r12d,%esi
 10066f1:	e8 3c 14 00 00       	call   1007b32 <_ZNK4spanIcE2atEi>
 10066f6:	40 8a 28             	mov    (%rax),%bpl
 10066f9:	42 8d 34 23          	lea    (%rbx,%r12,1),%esi
 10066fd:	4c 89 ff             	mov    %r15,%rdi
 1006700:	e8 9b 16 00 00       	call   1007da0 <_ZN6vectorIcE2atEi>
 1006705:	40 88 28             	mov    %bpl,(%rax)
 1006708:	41 ff c4             	inc    %r12d
 100670b:	45 3b 66 08          	cmp    0x8(%r14),%r12d
 100670f:	7c da                	jl     10066eb <_ZN6vectorIcE4blitERK4spanIcEi+0x19>
 1006711:	5b                   	pop    %rbx
 1006712:	41 5c                	pop    %r12
 1006714:	41 5e                	pop    %r14
 1006716:	41 5f                	pop    %r15
 1006718:	5d                   	pop    %rbp
 1006719:	c3                   	ret    

000000000100671a <_Z10tcp_createv>:
 100671a:	53                   	push   %rbx
 100671b:	bf 48 00 00 00       	mov    $0x48,%edi
 1006720:	e8 45 d5 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1006725:	48 89 c3             	mov    %rax,%rbx
 1006728:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 100672c:	c5 fc 11 00          	vmovups %ymm0,(%rax)
 1006730:	c5 fc 11 40 20       	vmovups %ymm0,0x20(%rax)
 1006735:	48 c7 40 40 00 00 00 	movq   $0x0,0x40(%rax)
 100673c:	00 
 100673d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%rax)
 1006744:	8b 35 1e 26 00 00    	mov    0x261e(%rip),%esi        # 1008d68 <open_connections+0x8>
 100674a:	bf 60 8d 00 01       	mov    $0x1008d60,%edi
 100674f:	c5 f8 77             	vzeroupper 
 1006752:	e8 73 fb ff ff       	call   10062ca <_ZN6vectorIP14tcp_connectionE2atEi>
 1006757:	48 89 18             	mov    %rbx,(%rax)
 100675a:	48 89 d8             	mov    %rbx,%rax
 100675d:	5b                   	pop    %rbx
 100675e:	c3                   	ret    

000000000100675f <_Z10tcp_acceptt>:
 100675f:	55                   	push   %rbp
 1006760:	41 57                	push   %r15
 1006762:	41 56                	push   %r14
 1006764:	53                   	push   %rbx
 1006765:	48 83 ec 38          	sub    $0x38,%rsp
 1006769:	83 3d f8 25 00 00 00 	cmpl   $0x0,0x25f8(%rip)        # 1008d68 <open_connections+0x8>
 1006770:	7e 37                	jle    10067a9 <_Z10tcp_acceptt+0x4a>
 1006772:	89 fd                	mov    %edi,%ebp
 1006774:	45 31 f6             	xor    %r14d,%r14d
 1006777:	bf 60 8d 00 01       	mov    $0x1008d60,%edi
 100677c:	44 89 f6             	mov    %r14d,%esi
 100677f:	e8 46 fb ff ff       	call   10062ca <_ZN6vectorIP14tcp_connectionE2atEi>
 1006784:	48 8b 18             	mov    (%rax),%rbx
 1006787:	8b 43 1c             	mov    0x1c(%rbx),%eax
 100678a:	83 f8 02             	cmp    $0x2,%eax
 100678d:	75 0e                	jne    100679d <_Z10tcp_acceptt+0x3e>
 100678f:	66 85 ed             	test   %bp,%bp
 1006792:	74 1c                	je     10067b0 <_Z10tcp_acceptt+0x51>
 1006794:	0f b7 43 08          	movzwl 0x8(%rbx),%eax
 1006798:	66 39 e8             	cmp    %bp,%ax
 100679b:	74 13                	je     10067b0 <_Z10tcp_acceptt+0x51>
 100679d:	41 ff c6             	inc    %r14d
 10067a0:	44 3b 35 c1 25 00 00 	cmp    0x25c1(%rip),%r14d        # 1008d68 <open_connections+0x8>
 10067a7:	7c ce                	jl     1006777 <_Z10tcp_acceptt+0x18>
 10067a9:	31 db                	xor    %ebx,%ebx
 10067ab:	e9 dd 00 00 00       	jmp    100688d <_Z10tcp_acceptt+0x12e>
 10067b0:	8b 05 b2 25 00 00    	mov    0x25b2(%rip),%eax        # 1008d68 <open_connections+0x8>
 10067b6:	0f 38 f1 43 0c       	movbe  %eax,0xc(%rbx)
 10067bb:	8b 43 10             	mov    0x10(%rbx),%eax
 10067be:	ff c0                	inc    %eax
 10067c0:	89 43 18             	mov    %eax,0x18(%rbx)
 10067c3:	8b 43 0c             	mov    0xc(%rbx),%eax
 10067c6:	89 43 14             	mov    %eax,0x14(%rbx)
 10067c9:	c7 43 1c 04 00 00 00 	movl   $0x4,0x1c(%rbx)
 10067d0:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
 10067d5:	48 c7 06 3c 86 00 01 	movq   $0x100863c,(%rsi)
 10067dc:	c7 46 08 31 00 00 00 	movl   $0x31,0x8(%rsi)
 10067e3:	0f b7 53 08          	movzwl 0x8(%rbx),%edx
 10067e7:	8b 4b 04             	mov    0x4(%rbx),%ecx
 10067ea:	44 0f b7 43 0a       	movzwl 0xa(%rbx),%r8d
 10067ef:	4c 8d 74 24 08       	lea    0x8(%rsp),%r14
 10067f4:	4c 89 f7             	mov    %r14,%rdi
 10067f7:	31 c0                	xor    %eax,%eax
 10067f9:	e8 cb a9 ff ff       	call   10011c9 <_Z6format8rostringz>
 10067fe:	4c 89 f7             	mov    %r14,%rdi
 1006801:	e8 7a b0 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1006806:	49 89 c7             	mov    %rax,%r15
 1006809:	8a 00                	mov    (%rax),%al
 100680b:	84 c0                	test   %al,%al
 100680d:	74 1a                	je     1006829 <_Z10tcp_acceptt+0xca>
 100680f:	49 ff c7             	inc    %r15
 1006812:	0f be f0             	movsbl %al,%esi
 1006815:	bf 00 00 11 00       	mov    $0x110000,%edi
 100681a:	e8 33 d3 ff ff       	call   1003b52 <_ZN7console7putcharEc>
 100681f:	41 8a 07             	mov    (%r15),%al
 1006822:	49 ff c7             	inc    %r15
 1006825:	84 c0                	test   %al,%al
 1006827:	75 e9                	jne    1006812 <_Z10tcp_acceptt+0xb3>
 1006829:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 100682e:	48 85 c0             	test   %rax,%rax
 1006831:	74 2e                	je     1006861 <_Z10tcp_acceptt+0x102>
 1006833:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1006837:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 100683b:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006842:	00 04 
 1006844:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006849:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006850:	04 
 1006851:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1006858:	04 
 1006859:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006860:	00 
 1006861:	c7 44 24 08 02 04 05 	movl   $0xb4050402,0x8(%rsp)
 1006868:	b4 
 1006869:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
 100686e:	4c 89 36             	mov    %r14,(%rsi)
 1006871:	c7 46 08 04 00 00 00 	movl   $0x4,0x8(%rsi)
 1006878:	48 89 df             	mov    %rbx,%rdi
 100687b:	ba 60 12 00 00       	mov    $0x1260,%edx
 1006880:	e8 9d fa ff ff       	call   1006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>
 1006885:	8b 43 1c             	mov    0x1c(%rbx),%eax
 1006888:	83 f8 05             	cmp    $0x5,%eax
 100688b:	75 f8                	jne    1006885 <_Z10tcp_acceptt+0x126>
 100688d:	48 89 d8             	mov    %rbx,%rax
 1006890:	48 83 c4 38          	add    $0x38,%rsp
 1006894:	5b                   	pop    %rbx
 1006895:	41 5e                	pop    %r14
 1006897:	41 5f                	pop    %r15
 1006899:	5d                   	pop    %rbp
 100689a:	c3                   	ret    
 100689b:	cc                   	int3   

000000000100689c <_ZNV14tcp_connection6listenEt>:
 100689c:	66 89 77 08          	mov    %si,0x8(%rdi)
 10068a0:	c7 47 1c 01 00 00 00 	movl   $0x1,0x1c(%rdi)
 10068a7:	8b 47 1c             	mov    0x1c(%rdi),%eax
 10068aa:	83 f8 05             	cmp    $0x5,%eax
 10068ad:	75 f8                	jne    10068a7 <_ZNV14tcp_connection6listenEt+0xb>
 10068af:	c3                   	ret    

00000000010068b0 <_ZNV14tcp_connection4sendE10tcp_packet>:
 10068b0:	41 56                	push   %r14
 10068b2:	53                   	push   %rbx
 10068b3:	48 83 ec 18          	sub    $0x18,%rsp
 10068b7:	49 89 f6             	mov    %rsi,%r14
 10068ba:	48 89 fb             	mov    %rdi,%rbx
 10068bd:	8b 46 08             	mov    0x8(%rsi),%eax
 10068c0:	48 8b 0e             	mov    (%rsi),%rcx
 10068c3:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 10068c8:	48 89 0e             	mov    %rcx,(%rsi)
 10068cb:	89 46 08             	mov    %eax,0x8(%rsi)
 10068ce:	ba 50 18 00 00       	mov    $0x1850,%edx
 10068d3:	e8 4a fa ff ff       	call   1006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>
 10068d8:	41 8b 46 08          	mov    0x8(%r14),%eax
 10068dc:	01 43 14             	add    %eax,0x14(%rbx)
 10068df:	c7 43 1c 06 00 00 00 	movl   $0x6,0x1c(%rbx)
 10068e6:	8b 43 1c             	mov    0x1c(%rbx),%eax
 10068e9:	83 f8 06             	cmp    $0x6,%eax
 10068ec:	74 f8                	je     10068e6 <_ZNV14tcp_connection4sendE10tcp_packet+0x36>
 10068ee:	48 83 c4 18          	add    $0x18,%rsp
 10068f2:	5b                   	pop    %rbx
 10068f3:	41 5e                	pop    %r14
 10068f5:	c3                   	ret    

00000000010068f6 <_ZNV14tcp_connection4recvEv>:
 10068f6:	53                   	push   %rbx
 10068f7:	48 89 fb             	mov    %rdi,%rbx
 10068fa:	83 7e 40 00          	cmpl   $0x0,0x40(%rsi)
 10068fe:	75 18                	jne    1006918 <_ZNV14tcp_connection4recvEv+0x22>
 1006900:	8b 46 1c             	mov    0x1c(%rsi),%eax
 1006903:	83 f8 09             	cmp    $0x9,%eax
 1006906:	75 f2                	jne    10068fa <_ZNV14tcp_connection4recvEv+0x4>
 1006908:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
 100690f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%rbx)
 1006916:	eb 1e                	jmp    1006936 <_ZNV14tcp_connection4recvEv+0x40>
 1006918:	48 8b 46 38          	mov    0x38(%rsi),%rax
 100691c:	48 83 c6 38          	add    $0x38,%rsi
 1006920:	8b 48 08             	mov    0x8(%rax),%ecx
 1006923:	48 8b 00             	mov    (%rax),%rax
 1006926:	48 89 03             	mov    %rax,(%rbx)
 1006929:	89 4b 08             	mov    %ecx,0x8(%rbx)
 100692c:	48 89 f7             	mov    %rsi,%rdi
 100692f:	31 f6                	xor    %esi,%esi
 1006931:	e8 06 00 00 00       	call   100693c <_ZN6vectorI10tcp_packetE5eraseEi>
 1006936:	48 89 d8             	mov    %rbx,%rax
 1006939:	5b                   	pop    %rbx
 100693a:	c3                   	ret    
 100693b:	cc                   	int3   

000000000100693c <_ZN6vectorI10tcp_packetE5eraseEi>:
 100693c:	8b 47 08             	mov    0x8(%rdi),%eax
 100693f:	39 f0                	cmp    %esi,%eax
 1006941:	7e 54                	jle    1006997 <_ZN6vectorI10tcp_packetE5eraseEi+0x5b>
 1006943:	8d 46 01             	lea    0x1(%rsi),%eax
 1006946:	44 8b 47 08          	mov    0x8(%rdi),%r8d
 100694a:	44 39 c0             	cmp    %r8d,%eax
 100694d:	7d 41                	jge    1006990 <_ZN6vectorI10tcp_packetE5eraseEi+0x54>
 100694f:	48 8b 07             	mov    (%rdi),%rax
 1006952:	48 63 d6             	movslq %esi,%rdx
 1006955:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
 1006959:	48 c1 e2 04          	shl    $0x4,%rdx
 100695d:	48 01 c2             	add    %rax,%rdx
 1006960:	48 83 c2 18          	add    $0x18,%rdx
 1006964:	48 63 f6             	movslq %esi,%rsi
 1006967:	49 89 f0             	mov    %rsi,%r8
 100696a:	49 c1 e0 04          	shl    $0x4,%r8
 100696e:	4c 8b 4a f8          	mov    -0x8(%rdx),%r9
 1006972:	4e 89 0c 00          	mov    %r9,(%rax,%r8,1)
 1006976:	44 8b 0a             	mov    (%rdx),%r9d
 1006979:	46 89 4c 00 08       	mov    %r9d,0x8(%rax,%r8,1)
 100697e:	48 ff c1             	inc    %rcx
 1006981:	4c 63 47 08          	movslq 0x8(%rdi),%r8
 1006985:	ff c6                	inc    %esi
 1006987:	48 83 c2 10          	add    $0x10,%rdx
 100698b:	4c 39 c1             	cmp    %r8,%rcx
 100698e:	7c d4                	jl     1006964 <_ZN6vectorI10tcp_packetE5eraseEi+0x28>
 1006990:	41 ff c8             	dec    %r8d
 1006993:	44 89 47 08          	mov    %r8d,0x8(%rdi)
 1006997:	c3                   	ret    

0000000001006998 <_ZNV14tcp_connection5closeEv>:
 1006998:	41 56                	push   %r14
 100699a:	53                   	push   %rbx
 100699b:	48 83 ec 38          	sub    $0x38,%rsp
 100699f:	48 89 fb             	mov    %rdi,%rbx
 10069a2:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
 10069a7:	48 c7 06 bd 89 00 01 	movq   $0x10089bd,(%rsi)
 10069ae:	c7 46 08 26 00 00 00 	movl   $0x26,0x8(%rsi)
 10069b5:	8b 57 04             	mov    0x4(%rdi),%edx
 10069b8:	0f b7 4f 0a          	movzwl 0xa(%rdi),%ecx
 10069bc:	4c 8d 74 24 08       	lea    0x8(%rsp),%r14
 10069c1:	4c 89 f7             	mov    %r14,%rdi
 10069c4:	31 c0                	xor    %eax,%eax
 10069c6:	e8 fe a7 ff ff       	call   10011c9 <_Z6format8rostringz>
 10069cb:	4c 89 f7             	mov    %r14,%rdi
 10069ce:	e8 ad ae ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 10069d3:	49 89 c6             	mov    %rax,%r14
 10069d6:	8a 00                	mov    (%rax),%al
 10069d8:	84 c0                	test   %al,%al
 10069da:	74 1a                	je     10069f6 <_ZNV14tcp_connection5closeEv+0x5e>
 10069dc:	49 ff c6             	inc    %r14
 10069df:	0f be f0             	movsbl %al,%esi
 10069e2:	bf 00 00 11 00       	mov    $0x110000,%edi
 10069e7:	e8 66 d1 ff ff       	call   1003b52 <_ZN7console7putcharEc>
 10069ec:	41 8a 06             	mov    (%r14),%al
 10069ef:	49 ff c6             	inc    %r14
 10069f2:	84 c0                	test   %al,%al
 10069f4:	75 e9                	jne    10069df <_ZNV14tcp_connection5closeEv+0x47>
 10069f6:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10069fb:	48 85 c0             	test   %rax,%rax
 10069fe:	74 2e                	je     1006a2e <_ZNV14tcp_connection5closeEv+0x96>
 1006a00:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1006a04:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1006a08:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006a0f:	00 04 
 1006a11:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006a16:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006a1d:	04 
 1006a1e:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1006a25:	04 
 1006a26:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006a2d:	00 
 1006a2e:	48 8d 74 24 18       	lea    0x18(%rsp),%rsi
 1006a33:	48 c7 06 00 00 00 00 	movq   $0x0,(%rsi)
 1006a3a:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%rsi)
 1006a41:	48 89 df             	mov    %rbx,%rdi
 1006a44:	ba 50 11 00 00       	mov    $0x1150,%edx
 1006a49:	e8 d4 f8 ff ff       	call   1006322 <_ZL12tcp_transmitP14tcp_connection10tcp_packett>
 1006a4e:	c7 43 1c 07 00 00 00 	movl   $0x7,0x1c(%rbx)
 1006a55:	8b 43 1c             	mov    0x1c(%rbx),%eax
 1006a58:	83 f8 09             	cmp    $0x9,%eax
 1006a5b:	75 f8                	jne    1006a55 <_ZNV14tcp_connection5closeEv+0xbd>
 1006a5d:	48 83 c4 38          	add    $0x38,%rsp
 1006a61:	5b                   	pop    %rbx
 1006a62:	41 5e                	pop    %r14
 1006a64:	c3                   	ret    
 1006a65:	cc                   	int3   

0000000001006a66 <_ZN6vectorIP14tcp_connectionE5eraseEi>:
 1006a66:	8b 47 08             	mov    0x8(%rdi),%eax
 1006a69:	39 f0                	cmp    %esi,%eax
 1006a6b:	7e 31                	jle    1006a9e <_ZN6vectorIP14tcp_connectionE5eraseEi+0x38>
 1006a6d:	8d 46 01             	lea    0x1(%rsi),%eax
 1006a70:	8b 4f 08             	mov    0x8(%rdi),%ecx
 1006a73:	39 c8                	cmp    %ecx,%eax
 1006a75:	7d 22                	jge    1006a99 <_ZN6vectorIP14tcp_connectionE5eraseEi+0x33>
 1006a77:	48 63 c6             	movslq %esi,%rax
 1006a7a:	48 ff c0             	inc    %rax
 1006a7d:	48 8b 0f             	mov    (%rdi),%rcx
 1006a80:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
 1006a84:	48 63 f6             	movslq %esi,%rsi
 1006a87:	48 89 14 f1          	mov    %rdx,(%rcx,%rsi,8)
 1006a8b:	48 ff c0             	inc    %rax
 1006a8e:	48 63 4f 08          	movslq 0x8(%rdi),%rcx
 1006a92:	ff c6                	inc    %esi
 1006a94:	48 39 c8             	cmp    %rcx,%rax
 1006a97:	7c e4                	jl     1006a7d <_ZN6vectorIP14tcp_connectionE5eraseEi+0x17>
 1006a99:	ff c9                	dec    %ecx
 1006a9b:	89 4f 08             	mov    %ecx,0x8(%rdi)
 1006a9e:	c3                   	ret    

0000000001006a9f <_Z7idt_sethmh>:
 1006a9f:	48 89 f0             	mov    %rsi,%rax
 1006aa2:	89 f9                	mov    %edi,%ecx
 1006aa4:	48 c1 e1 04          	shl    $0x4,%rcx
 1006aa8:	66 89 b1 00 80 01 00 	mov    %si,0x18000(%rcx)
 1006aaf:	c1 ee 10             	shr    $0x10,%esi
 1006ab2:	48 c1 e8 20          	shr    $0x20,%rax
 1006ab6:	66 c7 81 02 80 01 00 	movw   $0x18,0x18002(%rcx)
 1006abd:	18 00 
 1006abf:	c6 81 04 80 01 00 00 	movb   $0x0,0x18004(%rcx)
 1006ac6:	88 91 05 80 01 00    	mov    %dl,0x18005(%rcx)
 1006acc:	66 89 b1 06 80 01 00 	mov    %si,0x18006(%rcx)
 1006ad3:	89 81 08 80 01 00    	mov    %eax,0x18008(%rcx)
 1006ad9:	c7 81 0c 80 01 00 00 	movl   $0x0,0x1800c(%rcx)
 1006ae0:	00 00 00 
 1006ae3:	c3                   	ret    

0000000001006ae4 <_Z16handle_exceptionimmP13register_file>:
 1006ae4:	41 57                	push   %r15
 1006ae6:	41 56                	push   %r14
 1006ae8:	53                   	push   %rbx
 1006ae9:	48 81 ec 80 00 00 00 	sub    $0x80,%rsp
 1006af0:	49 89 ce             	mov    %rcx,%r14
 1006af3:	48 89 d1             	mov    %rdx,%rcx
 1006af6:	48 89 f2             	mov    %rsi,%rdx
 1006af9:	89 fb                	mov    %edi,%ebx
 1006afb:	48 c7 44 24 10 77 84 	movq   $0x1008477,0x10(%rsp)
 1006b02:	00 01 
 1006b04:	c7 44 24 18 1e 00 00 	movl   $0x1e,0x18(%rsp)
 1006b0b:	00 
 1006b0c:	41 b8 ac 87 00 01    	mov    $0x10087ac,%r8d
 1006b12:	48 83 fe 1f          	cmp    $0x1f,%rsi
 1006b16:	77 08                	ja     1006b20 <_Z16handle_exceptionimmP13register_file+0x3c>
 1006b18:	4c 8b 04 d5 60 8b 00 	mov    0x1008b60(,%rdx,8),%r8
 1006b1f:	01 
 1006b20:	49 89 e7             	mov    %rsp,%r15
 1006b23:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
 1006b28:	4c 89 ff             	mov    %r15,%rdi
 1006b2b:	31 c0                	xor    %eax,%eax
 1006b2d:	e8 97 a6 ff ff       	call   10011c9 <_Z6format8rostringz>
 1006b32:	4c 89 ff             	mov    %r15,%rdi
 1006b35:	e8 46 ad ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1006b3a:	49 89 c7             	mov    %rax,%r15
 1006b3d:	8a 00                	mov    (%rax),%al
 1006b3f:	84 c0                	test   %al,%al
 1006b41:	74 1a                	je     1006b5d <_Z16handle_exceptionimmP13register_file+0x79>
 1006b43:	49 ff c7             	inc    %r15
 1006b46:	0f be f0             	movsbl %al,%esi
 1006b49:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006b4e:	e8 ff cf ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1006b53:	41 8a 07             	mov    (%r15),%al
 1006b56:	49 ff c7             	inc    %r15
 1006b59:	84 c0                	test   %al,%al
 1006b5b:	75 e9                	jne    1006b46 <_Z16handle_exceptionimmP13register_file+0x62>
 1006b5d:	48 8b 04 24          	mov    (%rsp),%rax
 1006b61:	48 85 c0             	test   %rax,%rax
 1006b64:	74 2e                	je     1006b94 <_Z16handle_exceptionimmP13register_file+0xb0>
 1006b66:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1006b6a:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1006b6e:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006b75:	00 04 
 1006b77:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006b7c:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006b83:	04 
 1006b84:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1006b8b:	04 
 1006b8c:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006b93:	00 
 1006b94:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
 1006b99:	48 c7 06 09 89 00 01 	movq   $0x1008909,(%rsi)
 1006ba0:	c7 46 08 10 00 00 00 	movl   $0x10,0x8(%rsi)
 1006ba7:	49 8b 8e 80 00 00 00 	mov    0x80(%r14),%rcx
 1006bae:	49 8b 96 90 00 00 00 	mov    0x90(%r14),%rdx
 1006bb5:	49 89 e7             	mov    %rsp,%r15
 1006bb8:	4c 89 ff             	mov    %r15,%rdi
 1006bbb:	31 c0                	xor    %eax,%eax
 1006bbd:	e8 07 a6 ff ff       	call   10011c9 <_Z6format8rostringz>
 1006bc2:	4c 89 ff             	mov    %r15,%rdi
 1006bc5:	e8 b6 ac ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1006bca:	49 89 c7             	mov    %rax,%r15
 1006bcd:	8a 00                	mov    (%rax),%al
 1006bcf:	84 c0                	test   %al,%al
 1006bd1:	74 1a                	je     1006bed <_Z16handle_exceptionimmP13register_file+0x109>
 1006bd3:	49 ff c7             	inc    %r15
 1006bd6:	0f be f0             	movsbl %al,%esi
 1006bd9:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006bde:	e8 6f cf ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1006be3:	41 8a 07             	mov    (%r15),%al
 1006be6:	49 ff c7             	inc    %r15
 1006be9:	84 c0                	test   %al,%al
 1006beb:	75 e9                	jne    1006bd6 <_Z16handle_exceptionimmP13register_file+0xf2>
 1006bed:	48 8b 04 24          	mov    (%rsp),%rax
 1006bf1:	48 85 c0             	test   %rax,%rax
 1006bf4:	74 2e                	je     1006c24 <_Z16handle_exceptionimmP13register_file+0x140>
 1006bf6:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1006bfa:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1006bfe:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006c05:	00 04 
 1006c07:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006c0c:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006c13:	04 
 1006c14:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1006c1b:	04 
 1006c1c:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006c23:	00 
 1006c24:	b0 52                	mov    $0x52,%al
 1006c26:	49 c7 c7 f0 ff ff ff 	mov    $0xfffffffffffffff0,%r15
 1006c2d:	0f be f0             	movsbl %al,%esi
 1006c30:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006c35:	e8 18 cf ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1006c3a:	41 8a 87 38 86 00 01 	mov    0x1008638(%r15),%al
 1006c41:	49 ff c7             	inc    %r15
 1006c44:	75 e7                	jne    1006c2d <_Z16handle_exceptionimmP13register_file+0x149>
 1006c46:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
 1006c4b:	48 c7 06 6a 88 00 01 	movq   $0x100886a,(%rsi)
 1006c52:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
 1006c59:	49 8b 16             	mov    (%r14),%rdx
 1006c5c:	49 8b 4e 08          	mov    0x8(%r14),%rcx
 1006c60:	4d 8b 46 10          	mov    0x10(%r14),%r8
 1006c64:	4d 8b 4e 18          	mov    0x18(%r14),%r9
 1006c68:	49 89 e7             	mov    %rsp,%r15
 1006c6b:	4c 89 ff             	mov    %r15,%rdi
 1006c6e:	31 c0                	xor    %eax,%eax
 1006c70:	e8 54 a5 ff ff       	call   10011c9 <_Z6format8rostringz>
 1006c75:	4c 89 ff             	mov    %r15,%rdi
 1006c78:	e8 03 ac ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1006c7d:	49 89 c7             	mov    %rax,%r15
 1006c80:	8a 00                	mov    (%rax),%al
 1006c82:	84 c0                	test   %al,%al
 1006c84:	74 1a                	je     1006ca0 <_Z16handle_exceptionimmP13register_file+0x1bc>
 1006c86:	49 ff c7             	inc    %r15
 1006c89:	0f be f0             	movsbl %al,%esi
 1006c8c:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006c91:	e8 bc ce ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1006c96:	41 8a 07             	mov    (%r15),%al
 1006c99:	49 ff c7             	inc    %r15
 1006c9c:	84 c0                	test   %al,%al
 1006c9e:	75 e9                	jne    1006c89 <_Z16handle_exceptionimmP13register_file+0x1a5>
 1006ca0:	48 8b 04 24          	mov    (%rsp),%rax
 1006ca4:	48 85 c0             	test   %rax,%rax
 1006ca7:	74 2e                	je     1006cd7 <_Z16handle_exceptionimmP13register_file+0x1f3>
 1006ca9:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1006cad:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1006cb1:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006cb8:	00 04 
 1006cba:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006cbf:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006cc6:	04 
 1006cc7:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1006cce:	04 
 1006ccf:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006cd6:	00 
 1006cd7:	48 8d 74 24 50       	lea    0x50(%rsp),%rsi
 1006cdc:	48 c7 06 6a 88 00 01 	movq   $0x100886a,(%rsi)
 1006ce3:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
 1006cea:	49 8b 56 20          	mov    0x20(%r14),%rdx
 1006cee:	49 8b 4e 28          	mov    0x28(%r14),%rcx
 1006cf2:	4d 8b 46 30          	mov    0x30(%r14),%r8
 1006cf6:	4d 8b 4e 38          	mov    0x38(%r14),%r9
 1006cfa:	49 89 e7             	mov    %rsp,%r15
 1006cfd:	4c 89 ff             	mov    %r15,%rdi
 1006d00:	31 c0                	xor    %eax,%eax
 1006d02:	e8 c2 a4 ff ff       	call   10011c9 <_Z6format8rostringz>
 1006d07:	4c 89 ff             	mov    %r15,%rdi
 1006d0a:	e8 71 ab ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1006d0f:	49 89 c7             	mov    %rax,%r15
 1006d12:	8a 00                	mov    (%rax),%al
 1006d14:	84 c0                	test   %al,%al
 1006d16:	74 1a                	je     1006d32 <_Z16handle_exceptionimmP13register_file+0x24e>
 1006d18:	49 ff c7             	inc    %r15
 1006d1b:	0f be f0             	movsbl %al,%esi
 1006d1e:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006d23:	e8 2a ce ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1006d28:	41 8a 07             	mov    (%r15),%al
 1006d2b:	49 ff c7             	inc    %r15
 1006d2e:	84 c0                	test   %al,%al
 1006d30:	75 e9                	jne    1006d1b <_Z16handle_exceptionimmP13register_file+0x237>
 1006d32:	48 8b 04 24          	mov    (%rsp),%rax
 1006d36:	48 85 c0             	test   %rax,%rax
 1006d39:	74 2e                	je     1006d69 <_Z16handle_exceptionimmP13register_file+0x285>
 1006d3b:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1006d3f:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1006d43:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006d4a:	00 04 
 1006d4c:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006d51:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006d58:	04 
 1006d59:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1006d60:	04 
 1006d61:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006d68:	00 
 1006d69:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
 1006d6e:	48 c7 06 6a 88 00 01 	movq   $0x100886a,(%rsi)
 1006d75:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
 1006d7c:	49 8b 56 40          	mov    0x40(%r14),%rdx
 1006d80:	49 8b 4e 48          	mov    0x48(%r14),%rcx
 1006d84:	4d 8b 46 50          	mov    0x50(%r14),%r8
 1006d88:	4d 8b 4e 58          	mov    0x58(%r14),%r9
 1006d8c:	49 89 e7             	mov    %rsp,%r15
 1006d8f:	4c 89 ff             	mov    %r15,%rdi
 1006d92:	31 c0                	xor    %eax,%eax
 1006d94:	e8 30 a4 ff ff       	call   10011c9 <_Z6format8rostringz>
 1006d99:	4c 89 ff             	mov    %r15,%rdi
 1006d9c:	e8 df aa ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1006da1:	49 89 c7             	mov    %rax,%r15
 1006da4:	8a 00                	mov    (%rax),%al
 1006da6:	84 c0                	test   %al,%al
 1006da8:	74 1a                	je     1006dc4 <_Z16handle_exceptionimmP13register_file+0x2e0>
 1006daa:	49 ff c7             	inc    %r15
 1006dad:	0f be f0             	movsbl %al,%esi
 1006db0:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006db5:	e8 98 cd ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1006dba:	41 8a 07             	mov    (%r15),%al
 1006dbd:	49 ff c7             	inc    %r15
 1006dc0:	84 c0                	test   %al,%al
 1006dc2:	75 e9                	jne    1006dad <_Z16handle_exceptionimmP13register_file+0x2c9>
 1006dc4:	48 8b 04 24          	mov    (%rsp),%rax
 1006dc8:	48 85 c0             	test   %rax,%rax
 1006dcb:	74 2e                	je     1006dfb <_Z16handle_exceptionimmP13register_file+0x317>
 1006dcd:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1006dd1:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1006dd5:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006ddc:	00 04 
 1006dde:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006de3:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006dea:	04 
 1006deb:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1006df2:	04 
 1006df3:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006dfa:	00 
 1006dfb:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
 1006e00:	48 c7 06 6a 88 00 01 	movq   $0x100886a,(%rsi)
 1006e07:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
 1006e0e:	49 8b 56 60          	mov    0x60(%r14),%rdx
 1006e12:	49 8b 4e 68          	mov    0x68(%r14),%rcx
 1006e16:	4d 8b 46 70          	mov    0x70(%r14),%r8
 1006e1a:	4d 8b 4e 78          	mov    0x78(%r14),%r9
 1006e1e:	49 89 e6             	mov    %rsp,%r14
 1006e21:	4c 89 f7             	mov    %r14,%rdi
 1006e24:	31 c0                	xor    %eax,%eax
 1006e26:	e8 9e a3 ff ff       	call   10011c9 <_Z6format8rostringz>
 1006e2b:	4c 89 f7             	mov    %r14,%rdi
 1006e2e:	e8 4d aa ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1006e33:	49 89 c6             	mov    %rax,%r14
 1006e36:	8a 00                	mov    (%rax),%al
 1006e38:	84 c0                	test   %al,%al
 1006e3a:	74 1a                	je     1006e56 <_Z16handle_exceptionimmP13register_file+0x372>
 1006e3c:	49 ff c6             	inc    %r14
 1006e3f:	0f be f0             	movsbl %al,%esi
 1006e42:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006e47:	e8 06 cd ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1006e4c:	41 8a 06             	mov    (%r14),%al
 1006e4f:	49 ff c6             	inc    %r14
 1006e52:	84 c0                	test   %al,%al
 1006e54:	75 e9                	jne    1006e3f <_Z16handle_exceptionimmP13register_file+0x35b>
 1006e56:	48 8b 04 24          	mov    (%rsp),%rax
 1006e5a:	48 85 c0             	test   %rax,%rax
 1006e5d:	74 2e                	je     1006e8d <_Z16handle_exceptionimmP13register_file+0x3a9>
 1006e5f:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1006e63:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1006e67:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006e6e:	00 04 
 1006e70:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006e75:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006e7c:	04 
 1006e7d:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1006e84:	04 
 1006e85:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006e8c:	00 
 1006e8d:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
 1006e92:	48 c7 06 6a 88 00 01 	movq   $0x100886a,(%rsi)
 1006e99:	c7 46 08 19 00 00 00 	movl   $0x19,0x8(%rsi)
 1006ea0:	0f 20 c2             	mov    %cr0,%rdx
 1006ea3:	0f 20 d1             	mov    %cr2,%rcx
 1006ea6:	41 0f 20 d8          	mov    %cr3,%r8
 1006eaa:	41 0f 20 e1          	mov    %cr4,%r9
 1006eae:	49 89 e6             	mov    %rsp,%r14
 1006eb1:	4c 89 f7             	mov    %r14,%rdi
 1006eb4:	31 c0                	xor    %eax,%eax
 1006eb6:	e8 0e a3 ff ff       	call   10011c9 <_Z6format8rostringz>
 1006ebb:	4c 89 f7             	mov    %r14,%rdi
 1006ebe:	e8 bd a9 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1006ec3:	49 89 c6             	mov    %rax,%r14
 1006ec6:	8a 00                	mov    (%rax),%al
 1006ec8:	84 c0                	test   %al,%al
 1006eca:	74 1a                	je     1006ee6 <_Z16handle_exceptionimmP13register_file+0x402>
 1006ecc:	49 ff c6             	inc    %r14
 1006ecf:	0f be f0             	movsbl %al,%esi
 1006ed2:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006ed7:	e8 76 cc ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1006edc:	41 8a 06             	mov    (%r14),%al
 1006edf:	49 ff c6             	inc    %r14
 1006ee2:	84 c0                	test   %al,%al
 1006ee4:	75 e9                	jne    1006ecf <_Z16handle_exceptionimmP13register_file+0x3eb>
 1006ee6:	48 8b 04 24          	mov    (%rsp),%rax
 1006eea:	48 85 c0             	test   %rax,%rax
 1006eed:	74 2e                	je     1006f1d <_Z16handle_exceptionimmP13register_file+0x439>
 1006eef:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1006ef3:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1006ef7:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1006efe:	00 04 
 1006f00:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1006f05:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1006f0c:	04 
 1006f0d:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1006f14:	04 
 1006f15:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1006f1c:	00 
 1006f1d:	85 db                	test   %ebx,%ebx
 1006f1f:	74 11                	je     1006f32 <_Z16handle_exceptionimmP13register_file+0x44e>
 1006f21:	bf 00 00 11 00       	mov    $0x110000,%edi
 1006f26:	be 1e 87 00 01       	mov    $0x100871e,%esi
 1006f2b:	e8 6a a2 ff ff       	call   100119a <_ZN7console6putstrEPKc>
 1006f30:	eb fe                	jmp    1006f30 <_Z16handle_exceptionimmP13register_file+0x44c>
 1006f32:	48 81 c4 80 00 00 00 	add    $0x80,%rsp
 1006f39:	5b                   	pop    %rbx
 1006f3a:	41 5e                	pop    %r14
 1006f3c:	41 5f                	pop    %r15
 1006f3e:	c3                   	ret    

0000000001006f3f <isr_err>:
 1006f3f:	55                   	push   %rbp
 1006f40:	48 89 e5             	mov    %rsp,%rbp
 1006f43:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
 1006f47:	48 89 f1             	mov    %rsi,%rcx
 1006f4a:	48 89 fe             	mov    %rdi,%rsi
 1006f4d:	bf 01 00 00 00       	mov    $0x1,%edi
 1006f52:	e8 8d fb ff ff       	call   1006ae4 <_Z16handle_exceptionimmP13register_file>
 1006f57:	48 89 ec             	mov    %rbp,%rsp
 1006f5a:	5d                   	pop    %rbp
 1006f5b:	c3                   	ret    

0000000001006f5c <isr_no_err>:
 1006f5c:	55                   	push   %rbp
 1006f5d:	48 89 e5             	mov    %rsp,%rbp
 1006f60:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
 1006f64:	48 89 f1             	mov    %rsi,%rcx
 1006f67:	48 89 fe             	mov    %rdi,%rsi
 1006f6a:	31 ff                	xor    %edi,%edi
 1006f6c:	31 d2                	xor    %edx,%edx
 1006f6e:	e8 71 fb ff ff       	call   1006ae4 <_Z16handle_exceptionimmP13register_file>
 1006f73:	48 89 ec             	mov    %rbp,%rsp
 1006f76:	5d                   	pop    %rbp
 1006f77:	c3                   	ret    

0000000001006f78 <irq_isr>:
 1006f78:	55                   	push   %rbp
 1006f79:	48 89 e5             	mov    %rsp,%rbp
 1006f7c:	53                   	push   %rbx
 1006f7d:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
 1006f81:	48 83 ec 10          	sub    $0x10,%rsp
 1006f85:	48 8d 5f e0          	lea    -0x20(%rdi),%rbx
 1006f89:	48 8b 04 fd 40 ff 10 	mov    0x10ff40(,%rdi,8),%rax
 1006f90:	00 
 1006f91:	48 85 c0             	test   %rax,%rax
 1006f94:	74 04                	je     1006f9a <irq_isr+0x22>
 1006f96:	ff d0                	call   *%rax
 1006f98:	eb 0f                	jmp    1006fa9 <irq_isr+0x31>
 1006f9a:	48 89 f1             	mov    %rsi,%rcx
 1006f9d:	48 89 fe             	mov    %rdi,%rsi
 1006fa0:	31 ff                	xor    %edi,%edi
 1006fa2:	31 d2                	xor    %edx,%edx
 1006fa4:	e8 3b fb ff ff       	call   1006ae4 <_Z16handle_exceptionimmP13register_file>
 1006fa9:	f6 c3 f8             	test   $0xf8,%bl
 1006fac:	74 04                	je     1006fb2 <irq_isr+0x3a>
 1006fae:	b0 20                	mov    $0x20,%al
 1006fb0:	e6 a0                	out    %al,$0xa0
 1006fb2:	b0 20                	mov    $0x20,%al
 1006fb4:	e6 20                	out    %al,$0x20
 1006fb6:	48 8d 65 f8          	lea    -0x8(%rbp),%rsp
 1006fba:	5b                   	pop    %rbx
 1006fbb:	5d                   	pop    %rbp
 1006fbc:	c3                   	ret    

0000000001006fbd <_Z7pic_eoih>:
 1006fbd:	40 80 ff 08          	cmp    $0x8,%dil
 1006fc1:	72 04                	jb     1006fc7 <_Z7pic_eoih+0xa>
 1006fc3:	b0 20                	mov    $0x20,%al
 1006fc5:	e6 a0                	out    %al,$0xa0
 1006fc7:	b0 20                	mov    $0x20,%al
 1006fc9:	e6 20                	out    %al,$0x20
 1006fcb:	c3                   	ret    

0000000001006fcc <_Z8idt_initv>:
 1006fcc:	b8 00 80 01 00       	mov    $0x18000,%eax
 1006fd1:	66 c7 04 25 00 90 01 	movw   $0xfff,0x19000
 1006fd8:	00 ff 0f 
 1006fdb:	c7 04 25 02 90 01 00 	movl   $0x18000,0x19002
 1006fe2:	00 80 01 00 
 1006fe6:	31 c9                	xor    %ecx,%ecx
 1006fe8:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 1006fec:	c5 fc 29 04 08       	vmovaps %ymm0,(%rax,%rcx,1)
 1006ff1:	48 83 c1 20          	add    $0x20,%rcx
 1006ff5:	48 81 f9 00 10 00 00 	cmp    $0x1000,%rcx
 1006ffc:	75 ee                	jne    1006fec <_Z8idt_initv+0x20>
 1006ffe:	31 c9                	xor    %ecx,%ecx
 1007000:	8b 91 28 07 00 01    	mov    0x1000728(%rcx),%edx
 1007006:	66 89 14 88          	mov    %dx,(%rax,%rcx,4)
 100700a:	c1 ea 10             	shr    $0x10,%edx
 100700d:	c7 44 88 02 18 00 00 	movl   $0x8e000018,0x2(%rax,%rcx,4)
 1007014:	8e 
 1007015:	66 89 54 88 06       	mov    %dx,0x6(%rax,%rcx,4)
 100701a:	48 c7 44 88 08 00 00 	movq   $0x0,0x8(%rax,%rcx,4)
 1007021:	00 00 
 1007023:	48 83 c1 04          	add    $0x4,%rcx
 1007027:	48 81 f9 80 00 00 00 	cmp    $0x80,%rcx
 100702e:	75 d0                	jne    1007000 <_Z8idt_initv+0x34>
 1007030:	31 c9                	xor    %ecx,%ecx
 1007032:	8b 91 a8 07 00 01    	mov    0x10007a8(%rcx),%edx
 1007038:	66 89 94 88 00 02 00 	mov    %dx,0x200(%rax,%rcx,4)
 100703f:	00 
 1007040:	c1 ea 10             	shr    $0x10,%edx
 1007043:	c7 84 88 02 02 00 00 	movl   $0x8e000018,0x202(%rax,%rcx,4)
 100704a:	18 00 00 8e 
 100704e:	66 89 94 88 06 02 00 	mov    %dx,0x206(%rax,%rcx,4)
 1007055:	00 
 1007056:	48 c7 84 88 08 02 00 	movq   $0x0,0x208(%rax,%rcx,4)
 100705d:	00 00 00 00 00 
 1007062:	48 83 c1 04          	add    $0x4,%rcx
 1007066:	48 83 f9 40          	cmp    $0x40,%rcx
 100706a:	75 c6                	jne    1007032 <_Z8idt_initv+0x66>
 100706c:	31 c9                	xor    %ecx,%ecx
 100706e:	8b 15 b4 96 ff ff    	mov    -0x694c(%rip),%edx        # 1000728 <isr_stub_table>
 1007074:	66 89 94 08 00 03 00 	mov    %dx,0x300(%rax,%rcx,1)
 100707b:	00 
 100707c:	c1 ea 10             	shr    $0x10,%edx
 100707f:	c7 84 08 02 03 00 00 	movl   $0x8e000018,0x302(%rax,%rcx,1)
 1007086:	18 00 00 8e 
 100708a:	66 89 94 08 06 03 00 	mov    %dx,0x306(%rax,%rcx,1)
 1007091:	00 
 1007092:	48 c7 84 08 08 03 00 	movq   $0x0,0x308(%rax,%rcx,1)
 1007099:	00 00 00 00 00 
 100709e:	48 83 c1 10          	add    $0x10,%rcx
 10070a2:	48 81 f9 00 0d 00 00 	cmp    $0xd00,%rcx
 10070a9:	75 c3                	jne    100706e <_Z8idt_initv+0xa2>
 10070ab:	31 c9                	xor    %ecx,%ecx
 10070ad:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 10070b1:	c5 fc 29 84 c8 40 80 	vmovaps %ymm0,0xf8040(%rax,%rcx,8)
 10070b8:	0f 00 
 10070ba:	48 83 c1 04          	add    $0x4,%rcx
 10070be:	48 83 f9 10          	cmp    $0x10,%rcx
 10070c2:	75 ed                	jne    10070b1 <_Z8idt_initv+0xe5>
 10070c4:	48 c7 05 a1 1c 00 00 	movq   $0x19000,0x1ca1(%rip)        # 1008d70 <idtptr>
 10070cb:	00 90 01 00 
 10070cf:	bf 00 90 01 00       	mov    $0x19000,%edi
 10070d4:	c5 f8 77             	vzeroupper 
 10070d7:	e9 0c 97 ff ff       	jmp    10007e8 <load_idt>

00000000010070dc <_Z7inc_pitv>:
 10070dc:	41 57                	push   %r15
 10070de:	41 56                	push   %r14
 10070e0:	53                   	push   %rbx
 10070e1:	48 83 ec 40          	sub    $0x40,%rsp
 10070e5:	48 ff 04 25 c0 00 11 	incq   0x1100c0
 10070ec:	00 
 10070ed:	8b 14 25 28 00 11 00 	mov    0x110028,%edx
 10070f4:	48 8d 74 24 30       	lea    0x30(%rsp),%rsi
 10070f9:	48 c7 06 45 87 00 01 	movq   $0x1008745,(%rsi)
 1007100:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%rsi)
 1007107:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
 100710c:	48 89 df             	mov    %rbx,%rdi
 100710f:	31 c0                	xor    %eax,%eax
 1007111:	e8 b3 a0 ff ff       	call   10011c9 <_Z6format8rostringz>
 1007116:	44 8b 73 08          	mov    0x8(%rbx),%r14d
 100711a:	45 85 f6             	test   %r14d,%r14d
 100711d:	7e 3c                	jle    100715b <_Z7inc_pitv+0x7f>
 100711f:	41 ff c6             	inc    %r14d
 1007122:	41 bf 9e 00 00 00    	mov    $0x9e,%r15d
 1007128:	48 8d 5c 24 10       	lea    0x10(%rsp),%rbx
 100712d:	41 8d 76 fe          	lea    -0x2(%r14),%esi
 1007131:	48 89 df             	mov    %rbx,%rdi
 1007134:	e8 fd d5 ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 1007139:	0f be 00             	movsbl (%rax),%eax
 100713c:	0d 00 0f 00 00       	or     $0xf00,%eax
 1007141:	48 8b 0c 25 00 00 11 	mov    0x110000,%rcx
 1007148:	00 
 1007149:	66 42 89 04 39       	mov    %ax,(%rcx,%r15,1)
 100714e:	49 83 c7 fe          	add    $0xfffffffffffffffe,%r15
 1007152:	41 ff ce             	dec    %r14d
 1007155:	41 83 fe 01          	cmp    $0x1,%r14d
 1007159:	77 d2                	ja     100712d <_Z7inc_pitv+0x51>
 100715b:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
 1007160:	48 c7 06 45 87 00 01 	movq   $0x1008745,(%rsi)
 1007167:	c7 46 08 05 00 00 00 	movl   $0x5,0x8(%rsi)
 100716e:	48 c7 c2 00 00 e0 ff 	mov    $0xffffffffffe00000,%rdx
 1007175:	48 03 14 25 20 00 11 	add    0x110020,%rdx
 100717c:	00 
 100717d:	48 89 e3             	mov    %rsp,%rbx
 1007180:	48 89 df             	mov    %rbx,%rdi
 1007183:	31 c0                	xor    %eax,%eax
 1007185:	e8 3f a0 ff ff       	call   10011c9 <_Z6format8rostringz>
 100718a:	44 8b 73 08          	mov    0x8(%rbx),%r14d
 100718e:	45 85 f6             	test   %r14d,%r14d
 1007191:	7e 43                	jle    10071d6 <_Z7inc_pitv+0xfa>
 1007193:	41 ff c6             	inc    %r14d
 1007196:	41 bf 4f 00 00 00    	mov    $0x4f,%r15d
 100719c:	48 89 e3             	mov    %rsp,%rbx
 100719f:	41 8d 76 fe          	lea    -0x2(%r14),%esi
 10071a3:	48 89 df             	mov    %rbx,%rdi
 10071a6:	e8 8b d5 ff ff       	call   1004736 <_ZN4spanIcE2atEi>
 10071ab:	0f be 00             	movsbl (%rax),%eax
 10071ae:	0d 00 0f 00 00       	or     $0xf00,%eax
 10071b3:	48 8b 0c 25 00 00 11 	mov    0x110000,%rcx
 10071ba:	00 
 10071bb:	48 63 14 25 18 00 11 	movslq 0x110018,%rdx
 10071c2:	00 
 10071c3:	4c 01 fa             	add    %r15,%rdx
 10071c6:	66 89 04 51          	mov    %ax,(%rcx,%rdx,2)
 10071ca:	41 ff ce             	dec    %r14d
 10071cd:	49 ff cf             	dec    %r15
 10071d0:	41 83 fe 01          	cmp    $0x1,%r14d
 10071d4:	77 c9                	ja     100719f <_Z7inc_pitv+0xc3>
 10071d6:	48 8b 04 24          	mov    (%rsp),%rax
 10071da:	48 85 c0             	test   %rax,%rax
 10071dd:	74 2e                	je     100720d <_Z7inc_pitv+0x131>
 10071df:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10071e3:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10071e7:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10071ee:	00 04 
 10071f0:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 10071f5:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10071fc:	04 
 10071fd:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1007204:	04 
 1007205:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 100720c:	00 
 100720d:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
 1007212:	48 85 c0             	test   %rax,%rax
 1007215:	74 2e                	je     1007245 <_Z7inc_pitv+0x169>
 1007217:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 100721b:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 100721f:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1007226:	00 04 
 1007228:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 100722d:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1007234:	04 
 1007235:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 100723c:	04 
 100723d:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 1007244:	00 
 1007245:	48 83 c4 40          	add    $0x40,%rsp
 1007249:	5b                   	pop    %rbx
 100724a:	41 5e                	pop    %r14
 100724c:	41 5f                	pop    %r15
 100724e:	c3                   	ret    

000000000100724f <_Z9time_initv>:
 100724f:	53                   	push   %rbx
 1007250:	48 83 ec 10          	sub    $0x10,%rsp
 1007254:	48 8d 5c 24 04       	lea    0x4(%rsp),%rbx
 1007259:	48 89 df             	mov    %rbx,%rdi
 100725c:	31 f6                	xor    %esi,%esi
 100725e:	e8 25 00 00 00       	call   1007288 <_ZN9timepointC1Em>
 1007263:	8b 43 08             	mov    0x8(%rbx),%eax
 1007266:	89 05 14 1b 00 00    	mov    %eax,0x1b14(%rip)        # 1008d80 <_ZL19reference_timepoint+0x8>
 100726c:	48 8b 03             	mov    (%rbx),%rax
 100726f:	48 89 05 02 1b 00 00 	mov    %rax,0x1b02(%rip)        # 1008d78 <_ZL19reference_timepoint>
 1007276:	48 c7 04 25 c0 00 11 	movq   $0x0,0x1100c0
 100727d:	00 00 00 00 00 
 1007282:	48 83 c4 10          	add    $0x10,%rsp
 1007286:	5b                   	pop    %rbx
 1007287:	c3                   	ret    

0000000001007288 <_ZN9timepointC1Em>:
 1007288:	48 89 f2             	mov    %rsi,%rdx
 100728b:	b0 0a                	mov    $0xa,%al
 100728d:	e6 70                	out    %al,$0x70
 100728f:	e4 71                	in     $0x71,%al
 1007291:	84 c0                	test   %al,%al
 1007293:	78 f6                	js     100728b <_ZN9timepointC1Em+0x3>
 1007295:	b0 09                	mov    $0x9,%al
 1007297:	e6 70                	out    %al,$0x70
 1007299:	e4 71                	in     $0x71,%al
 100729b:	88 07                	mov    %al,(%rdi)
 100729d:	b0 08                	mov    $0x8,%al
 100729f:	e6 70                	out    %al,$0x70
 10072a1:	e4 71                	in     $0x71,%al
 10072a3:	88 47 01             	mov    %al,0x1(%rdi)
 10072a6:	b0 07                	mov    $0x7,%al
 10072a8:	e6 70                	out    %al,$0x70
 10072aa:	e4 71                	in     $0x71,%al
 10072ac:	88 47 02             	mov    %al,0x2(%rdi)
 10072af:	b0 04                	mov    $0x4,%al
 10072b1:	e6 70                	out    %al,$0x70
 10072b3:	e4 71                	in     $0x71,%al
 10072b5:	88 47 03             	mov    %al,0x3(%rdi)
 10072b8:	b0 02                	mov    $0x2,%al
 10072ba:	e6 70                	out    %al,$0x70
 10072bc:	e4 71                	in     $0x71,%al
 10072be:	88 47 04             	mov    %al,0x4(%rdi)
 10072c1:	31 c0                	xor    %eax,%eax
 10072c3:	e6 70                	out    %al,$0x70
 10072c5:	e4 71                	in     $0x71,%al
 10072c7:	89 c1                	mov    %eax,%ecx
 10072c9:	80 e1 0f             	and    $0xf,%cl
 10072cc:	c0 e8 04             	shr    $0x4,%al
 10072cf:	0f b6 c0             	movzbl %al,%eax
 10072d2:	01 c0                	add    %eax,%eax
 10072d4:	8d 34 80             	lea    (%rax,%rax,4),%esi
 10072d7:	40 00 ce             	add    %cl,%sil
 10072da:	0f b6 47 04          	movzbl 0x4(%rdi),%eax
 10072de:	89 c1                	mov    %eax,%ecx
 10072e0:	83 e1 0f             	and    $0xf,%ecx
 10072e3:	c1 e8 04             	shr    $0x4,%eax
 10072e6:	8d 04 80             	lea    (%rax,%rax,4),%eax
 10072e9:	8d 04 41             	lea    (%rcx,%rax,2),%eax
 10072ec:	44 8a 47 03          	mov    0x3(%rdi),%r8b
 10072f0:	44 89 c1             	mov    %r8d,%ecx
 10072f3:	80 e1 0f             	and    $0xf,%cl
 10072f6:	45 89 c1             	mov    %r8d,%r9d
 10072f9:	41 c0 e9 04          	shr    $0x4,%r9b
 10072fd:	41 80 e1 07          	and    $0x7,%r9b
 1007301:	45 0f b6 c9          	movzbl %r9b,%r9d
 1007305:	45 01 c9             	add    %r9d,%r9d
 1007308:	47 8d 0c 89          	lea    (%r9,%r9,4),%r9d
 100730c:	41 00 c9             	add    %cl,%r9b
 100730f:	41 80 e0 80          	and    $0x80,%r8b
 1007313:	45 08 c8             	or     %r9b,%r8b
 1007316:	8a 4f 02             	mov    0x2(%rdi),%cl
 1007319:	41 89 c9             	mov    %ecx,%r9d
 100731c:	41 80 e1 0f          	and    $0xf,%r9b
 1007320:	c0 e9 04             	shr    $0x4,%cl
 1007323:	0f b6 c9             	movzbl %cl,%ecx
 1007326:	01 c9                	add    %ecx,%ecx
 1007328:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
 100732b:	44 00 c9             	add    %r9b,%cl
 100732e:	44 8a 0f             	mov    (%rdi),%r9b
 1007331:	44 8a 57 01          	mov    0x1(%rdi),%r10b
 1007335:	45 89 d3             	mov    %r10d,%r11d
 1007338:	41 80 e3 0f          	and    $0xf,%r11b
 100733c:	41 c0 ea 04          	shr    $0x4,%r10b
 1007340:	45 0f b6 d2          	movzbl %r10b,%r10d
 1007344:	45 01 d2             	add    %r10d,%r10d
 1007347:	47 8d 14 92          	lea    (%r10,%r10,4),%r10d
 100734b:	45 00 da             	add    %r11b,%r10b
 100734e:	44 88 57 01          	mov    %r10b,0x1(%rdi)
 1007352:	45 89 ca             	mov    %r9d,%r10d
 1007355:	41 80 e2 0f          	and    $0xf,%r10b
 1007359:	41 c0 e9 04          	shr    $0x4,%r9b
 100735d:	45 0f b6 c9          	movzbl %r9b,%r9d
 1007361:	45 01 c9             	add    %r9d,%r9d
 1007364:	47 8d 0c 89          	lea    (%r9,%r9,4),%r9d
 1007368:	45 00 d1             	add    %r10b,%r9b
 100736b:	44 88 0f             	mov    %r9b,(%rdi)
 100736e:	49 b9 db 34 b6 d7 82 	movabs $0x431bde82d7b634db,%r9
 1007375:	de 1b 43 
 1007378:	c4 42 b3 f6 c9       	mulx   %r9,%r9,%r9
 100737d:	49 c1 e9 12          	shr    $0x12,%r9
 1007381:	45 69 d1 40 42 0f 00 	imul   $0xf4240,%r9d,%r10d
 1007388:	44 29 d2             	sub    %r10d,%edx
 100738b:	89 57 08             	mov    %edx,0x8(%rdi)
 100738e:	40 0f b6 d6          	movzbl %sil,%edx
 1007392:	4c 01 ca             	add    %r9,%rdx
 1007395:	48 be 45 44 44 44 44 	movabs $0x444444444444445,%rsi
 100739c:	44 44 04 
 100739f:	c4 62 b3 f6 ce       	mulx   %rsi,%r9,%r9
 10073a4:	44 01 c8             	add    %r9d,%eax
 10073a7:	41 0f b6 f0          	movzbl %r8b,%esi
 10073ab:	41 b8 89 88 88 88    	mov    $0x88888889,%r8d
 10073b1:	4c 0f af c0          	imul   %rax,%r8
 10073b5:	49 c1 e8 25          	shr    $0x25,%r8
 10073b9:	44 01 c6             	add    %r8d,%esi
 10073bc:	45 6b c9 3c          	imul   $0x3c,%r9d,%r9d
 10073c0:	44 29 ca             	sub    %r9d,%edx
 10073c3:	88 57 05             	mov    %dl,0x5(%rdi)
 10073c6:	41 6b d0 3c          	imul   $0x3c,%r8d,%edx
 10073ca:	29 d0                	sub    %edx,%eax
 10073cc:	88 47 04             	mov    %al,0x4(%rdi)
 10073cf:	48 69 c6 ab aa aa 0a 	imul   $0xaaaaaab,%rsi,%rax
 10073d6:	48 c1 e8 20          	shr    $0x20,%rax
 10073da:	8d 14 c5 00 00 00 00 	lea    0x0(,%rax,8),%edx
 10073e1:	8d 14 52             	lea    (%rdx,%rdx,2),%edx
 10073e4:	29 d6                	sub    %edx,%esi
 10073e6:	40 88 77 03          	mov    %sil,0x3(%rdi)
 10073ea:	00 c8                	add    %cl,%al
 10073ec:	88 47 02             	mov    %al,0x2(%rdi)
 10073ef:	c3                   	ret    

00000000010073f0 <_ZN9timepointC1Ev>:
 10073f0:	41 56                	push   %r14
 10073f2:	53                   	push   %rbx
 10073f3:	48 83 ec 18          	sub    $0x18,%rsp
 10073f7:	48 89 fb             	mov    %rdi,%rbx
 10073fa:	e4 40                	in     $0x40,%al
 10073fc:	0f b6 c8             	movzbl %al,%ecx
 10073ff:	e4 40                	in     $0x40,%al
 1007401:	0f b6 c0             	movzbl %al,%eax
 1007404:	48 c1 e0 08          	shl    $0x8,%rax
 1007408:	48 09 c8             	or     %rcx,%rax
 100740b:	48 8b 0c 25 c0 00 11 	mov    0x1100c0,%rcx
 1007412:	00 
 1007413:	48 c1 e1 10          	shl    $0x10,%rcx
 1007417:	48 29 c1             	sub    %rax,%rcx
 100741a:	48 69 c1 40 42 0f 00 	imul   $0xf4240,%rcx,%rax
 1007421:	48 ba 00 00 40 42 0f 	movabs $0xf42400000,%rdx
 1007428:	00 00 00 
 100742b:	48 01 c2             	add    %rax,%rdx
 100742e:	48 b8 45 db 4c d5 1a 	movabs $0xe0f9751ad54cdb45,%rax
 1007435:	75 f9 e0 
 1007438:	c4 e2 cb f6 f0       	mulx   %rax,%rsi,%rsi
 100743d:	48 c1 ee 14          	shr    $0x14,%rsi
 1007441:	4c 8d 74 24 0c       	lea    0xc(%rsp),%r14
 1007446:	4c 89 f7             	mov    %r14,%rdi
 1007449:	e8 3a fe ff ff       	call   1007288 <_ZN9timepointC1Em>
 100744e:	41 8b 46 08          	mov    0x8(%r14),%eax
 1007452:	89 43 08             	mov    %eax,0x8(%rbx)
 1007455:	49 8b 06             	mov    (%r14),%rax
 1007458:	48 89 03             	mov    %rax,(%rbx)
 100745b:	48 83 c4 18          	add    $0x18,%rsp
 100745f:	5b                   	pop    %rbx
 1007460:	41 5e                	pop    %r14
 1007462:	c3                   	ret    
 1007463:	cc                   	int3   

0000000001007464 <_ZN9timepoint12unix_secondsEv>:
 1007464:	e4 40                	in     $0x40,%al
 1007466:	0f b6 c8             	movzbl %al,%ecx
 1007469:	e4 40                	in     $0x40,%al
 100746b:	0f b6 c0             	movzbl %al,%eax
 100746e:	48 c1 e0 08          	shl    $0x8,%rax
 1007472:	48 09 c8             	or     %rcx,%rax
 1007475:	48 8b 0c 25 c0 00 11 	mov    0x1100c0,%rcx
 100747c:	00 
 100747d:	48 c1 e1 10          	shl    $0x10,%rcx
 1007481:	48 29 c1             	sub    %rax,%rcx
 1007484:	48 81 c1 00 00 01 00 	add    $0x10000,%rcx
 100748b:	c4 e1 f9 6e c1       	vmovq  %rcx,%xmm0
 1007490:	c5 f9 62 05 38 0e 00 	vpunpckldq 0xe38(%rip),%xmm0,%xmm0        # 10082d0 <_ZL4lfsr+0x190>
 1007497:	00 
 1007498:	c5 f9 5c 05 10 0e 00 	vsubpd 0xe10(%rip),%xmm0,%xmm0        # 10082b0 <_ZL4lfsr+0x170>
 100749f:	00 
 10074a0:	c5 f9 7c c0          	vhaddpd %xmm0,%xmm0,%xmm0
 10074a4:	c5 fb 5e 05 d4 0d 00 	vdivsd 0xdd4(%rip),%xmm0,%xmm0        # 1008280 <_ZL4lfsr+0x140>
 10074ab:	00 
 10074ac:	c3                   	ret    

00000000010074ad <_Z9tsc_delaym>:
 10074ad:	0f 31                	rdtsc  
 10074af:	89 d1                	mov    %edx,%ecx
 10074b1:	f7 d9                	neg    %ecx
 10074b3:	48 c1 e1 20          	shl    $0x20,%rcx
 10074b7:	89 c0                	mov    %eax,%eax
 10074b9:	48 29 c1             	sub    %rax,%rcx
 10074bc:	0f 31                	rdtsc  
 10074be:	48 c1 e2 20          	shl    $0x20,%rdx
 10074c2:	89 c0                	mov    %eax,%eax
 10074c4:	48 01 c8             	add    %rcx,%rax
 10074c7:	48 01 d0             	add    %rdx,%rax
 10074ca:	48 39 f8             	cmp    %rdi,%rax
 10074cd:	72 ed                	jb     10074bc <_Z9tsc_delaym+0xf>
 10074cf:	c3                   	ret    

00000000010074d0 <_Z16unset_page_flagsPvh>:
 10074d0:	89 f0                	mov    %esi,%eax
 10074d2:	48 f7 d0             	not    %rax
 10074d5:	48 c1 ef 15          	shr    $0x15,%rdi
 10074d9:	48 21 04 fd 00 20 07 	and    %rax,0x72000(,%rdi,8)
 10074e0:	00 
 10074e1:	c3                   	ret    

00000000010074e2 <_Z8pic_initv>:
 10074e2:	e4 21                	in     $0x21,%al
 10074e4:	89 c1                	mov    %eax,%ecx
 10074e6:	e4 a1                	in     $0xa1,%al
 10074e8:	89 c2                	mov    %eax,%edx
 10074ea:	b0 11                	mov    $0x11,%al
 10074ec:	e6 20                	out    %al,$0x20
 10074ee:	31 c0                	xor    %eax,%eax
 10074f0:	e6 80                	out    %al,$0x80
 10074f2:	b0 11                	mov    $0x11,%al
 10074f4:	e6 a0                	out    %al,$0xa0
 10074f6:	31 c0                	xor    %eax,%eax
 10074f8:	e6 80                	out    %al,$0x80
 10074fa:	b0 20                	mov    $0x20,%al
 10074fc:	e6 21                	out    %al,$0x21
 10074fe:	31 c0                	xor    %eax,%eax
 1007500:	e6 80                	out    %al,$0x80
 1007502:	b0 28                	mov    $0x28,%al
 1007504:	e6 a1                	out    %al,$0xa1
 1007506:	31 c0                	xor    %eax,%eax
 1007508:	e6 80                	out    %al,$0x80
 100750a:	b0 04                	mov    $0x4,%al
 100750c:	e6 21                	out    %al,$0x21
 100750e:	31 c0                	xor    %eax,%eax
 1007510:	e6 80                	out    %al,$0x80
 1007512:	b0 02                	mov    $0x2,%al
 1007514:	e6 a1                	out    %al,$0xa1
 1007516:	31 c0                	xor    %eax,%eax
 1007518:	e6 80                	out    %al,$0x80
 100751a:	b0 01                	mov    $0x1,%al
 100751c:	e6 21                	out    %al,$0x21
 100751e:	31 c0                	xor    %eax,%eax
 1007520:	e6 80                	out    %al,$0x80
 1007522:	b0 01                	mov    $0x1,%al
 1007524:	e6 a1                	out    %al,$0xa1
 1007526:	31 c0                	xor    %eax,%eax
 1007528:	e6 80                	out    %al,$0x80
 100752a:	89 c8                	mov    %ecx,%eax
 100752c:	e6 21                	out    %al,$0x21
 100752e:	89 d0                	mov    %edx,%eax
 1007530:	e6 a1                	out    %al,$0xa1
 1007532:	c3                   	ret    

0000000001007533 <_Z11pic_get_irrv>:
 1007533:	b0 0a                	mov    $0xa,%al
 1007535:	e6 20                	out    %al,$0x20
 1007537:	e6 a0                	out    %al,$0xa0
 1007539:	e4 a0                	in     $0xa0,%al
 100753b:	0f b6 c8             	movzbl %al,%ecx
 100753e:	c1 e1 08             	shl    $0x8,%ecx
 1007541:	e4 20                	in     $0x20,%al
 1007543:	0f b6 c0             	movzbl %al,%eax
 1007546:	09 c8                	or     %ecx,%eax
 1007548:	c3                   	ret    

0000000001007549 <_Z11pic_get_isrv>:
 1007549:	b0 0b                	mov    $0xb,%al
 100754b:	e6 20                	out    %al,$0x20
 100754d:	e6 a0                	out    %al,$0xa0
 100754f:	e4 a0                	in     $0xa0,%al
 1007551:	0f b6 c8             	movzbl %al,%ecx
 1007554:	c1 e1 08             	shl    $0x8,%ecx
 1007557:	e4 20                	in     $0x20,%al
 1007559:	0f b6 c0             	movzbl %al,%eax
 100755c:	09 c8                	or     %ecx,%eax
 100755e:	c3                   	ret    

000000000100755f <kernel_main>:
 100755f:	55                   	push   %rbp
 1007560:	48 89 e5             	mov    %rsp,%rbp
 1007563:	41 57                	push   %r15
 1007565:	41 56                	push   %r14
 1007567:	41 55                	push   %r13
 1007569:	41 54                	push   %r12
 100756b:	53                   	push   %rbx
 100756c:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
 1007570:	48 81 ec d0 00 00 00 	sub    $0xd0,%rsp
 1007577:	48 c7 04 25 40 00 11 	movq   $0x10070dc,0x110040
 100757e:	00 dc 70 00 01 
 1007583:	e4 21                	in     $0x21,%al
 1007585:	24 fe                	and    $0xfe,%al
 1007587:	e6 21                	out    %al,$0x21
 1007589:	48 c7 04 25 48 00 11 	movq   $0x100238c,0x110048
 1007590:	00 8c 23 00 01 
 1007595:	e4 21                	in     $0x21,%al
 1007597:	24 fd                	and    $0xfd,%al
 1007599:	e6 21                	out    %al,$0x21
 100759b:	48 8d 5c 24 28       	lea    0x28(%rsp),%rbx
 10075a0:	48 89 df             	mov    %rbx,%rdi
 10075a3:	31 f6                	xor    %esi,%esi
 10075a5:	e8 de fc ff ff       	call   1007288 <_ZN9timepointC1Em>
 10075aa:	8b 43 08             	mov    0x8(%rbx),%eax
 10075ad:	89 05 cd 17 00 00    	mov    %eax,0x17cd(%rip)        # 1008d80 <_ZL19reference_timepoint+0x8>
 10075b3:	48 8b 03             	mov    (%rbx),%rax
 10075b6:	48 89 05 bb 17 00 00 	mov    %rax,0x17bb(%rip)        # 1008d78 <_ZL19reference_timepoint>
 10075bd:	48 c7 04 25 c0 00 11 	movq   $0x0,0x1100c0
 10075c4:	00 00 00 00 00 
 10075c9:	e8 09 af ff ff       	call   10024d7 <_Z8pci_initv>
 10075ce:	e8 6d ea ff ff       	call   1006040 <_Z8net_initv>
 10075d3:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 10075d7:	c5 f8 11 03          	vmovups %xmm0,(%rbx)
 10075db:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%rsp)
 10075e2:	00 
 10075e3:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%rsp)
 10075e8:	0f 84 ff 03 00 00    	je     10079ed <kernel_main+0x48e>
 10075ee:	4c 8d 74 24 28       	lea    0x28(%rsp),%r14
 10075f3:	4c 8d 6c 24 38       	lea    0x38(%rsp),%r13
 10075f8:	bf 50 00 00 00       	mov    $0x50,%edi
 10075fd:	e8 5d f1 ff ff       	call   100675f <_Z10tcp_acceptt>
 1007602:	48 89 c3             	mov    %rax,%rbx
 1007605:	48 85 c0             	test   %rax,%rax
 1007608:	75 12                	jne    100761c <kernel_main+0xbd>
 100760a:	bf 90 1f 00 00       	mov    $0x1f90,%edi
 100760f:	e8 4b f1 ff ff       	call   100675f <_Z10tcp_acceptt>
 1007614:	48 89 c3             	mov    %rax,%rbx
 1007617:	48 85 c0             	test   %rax,%rax
 100761a:	74 0f                	je     100762b <kernel_main+0xcc>
 100761c:	8b 74 24 30          	mov    0x30(%rsp),%esi
 1007620:	4c 89 f7             	mov    %r14,%rdi
 1007623:	e8 c8 03 00 00       	call   10079f0 <_ZN6vectorIPV14tcp_connectionE2atEi>
 1007628:	48 89 18             	mov    %rbx,(%rax)
 100762b:	83 7c 24 30 00       	cmpl   $0x0,0x30(%rsp)
 1007630:	0f 8e ac 03 00 00    	jle    10079e2 <kernel_main+0x483>
 1007636:	45 31 e4             	xor    %r12d,%r12d
 1007639:	4c 89 f7             	mov    %r14,%rdi
 100763c:	44 89 e6             	mov    %r12d,%esi
 100763f:	e8 ac 03 00 00       	call   10079f0 <_ZN6vectorIPV14tcp_connectionE2atEi>
 1007644:	48 8b 18             	mov    (%rax),%rbx
 1007647:	8b 43 1c             	mov    0x1c(%rbx),%eax
 100764a:	83 f8 09             	cmp    $0x9,%eax
 100764d:	75 1b                	jne    100766a <kernel_main+0x10b>
 100764f:	48 89 df             	mov    %rbx,%rdi
 1007652:	e8 9e ee ff ff       	call   10064f5 <_Z11tcp_destroyPV14tcp_connection>
 1007657:	4c 89 f7             	mov    %r14,%rdi
 100765a:	44 89 e6             	mov    %r12d,%esi
 100765d:	e8 e6 03 00 00       	call   1007a48 <_ZN6vectorIPV14tcp_connectionE5eraseEi>
 1007662:	41 ff cc             	dec    %r12d
 1007665:	e9 6a 03 00 00       	jmp    10079d4 <kernel_main+0x475>
 100766a:	83 7b 40 00          	cmpl   $0x0,0x40(%rbx)
 100766e:	0f 84 60 03 00 00    	je     10079d4 <kernel_main+0x475>
 1007674:	48 8d 7b 38          	lea    0x38(%rbx),%rdi
 1007678:	83 7b 40 00          	cmpl   $0x0,0x40(%rbx)
 100767c:	75 1d                	jne    100769b <kernel_main+0x13c>
 100767e:	8b 43 1c             	mov    0x1c(%rbx),%eax
 1007681:	83 f8 09             	cmp    $0x9,%eax
 1007684:	75 f2                	jne    1007678 <kernel_main+0x119>
 1007686:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
 100768d:	00 00 
 100768f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
 1007696:	00 
 1007697:	31 c0                	xor    %eax,%eax
 1007699:	eb 1e                	jmp    10076b9 <kernel_main+0x15a>
 100769b:	48 8b 07             	mov    (%rdi),%rax
 100769e:	8b 48 08             	mov    0x8(%rax),%ecx
 10076a1:	48 8b 00             	mov    (%rax),%rax
 10076a4:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
 10076a9:	89 4c 24 18          	mov    %ecx,0x18(%rsp)
 10076ad:	31 f6                	xor    %esi,%esi
 10076af:	e8 88 f2 ff ff       	call   100693c <_ZN6vectorI10tcp_packetE5eraseEi>
 10076b4:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 10076b9:	8b 4c 24 18          	mov    0x18(%rsp),%ecx
 10076bd:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
 10076c2:	89 4c 24 10          	mov    %ecx,0x10(%rsp)
 10076c6:	48 c7 84 24 b8 00 00 	movq   $0x1008828,0xb8(%rsp)
 10076cd:	00 28 88 00 01 
 10076d2:	c7 84 24 c0 00 00 00 	movl   $0x1,0xc0(%rsp)
 10076d9:	01 00 00 00 
 10076dd:	4d 89 ef             	mov    %r13,%r15
 10076e0:	4c 89 ef             	mov    %r13,%rdi
 10076e3:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
 10076e8:	48 8d 94 24 b8 00 00 	lea    0xb8(%rsp),%rdx
 10076ef:	00 
 10076f0:	e8 7b d4 ff ff       	call   1004b70 <_ZNK8rostring5splitES_>
 10076f5:	83 7c 24 40 00       	cmpl   $0x0,0x40(%rsp)
 10076fa:	0f 8e b8 00 00 00    	jle    10077b8 <kernel_main+0x259>
 1007700:	45 31 ed             	xor    %r13d,%r13d
 1007703:	48 c7 84 24 a8 00 00 	movq   $0x10087c6,0xa8(%rsp)
 100770a:	00 c6 87 00 01 
 100770f:	c7 84 24 b0 00 00 00 	movl   $0x4,0xb0(%rsp)
 1007716:	04 00 00 00 
 100771a:	4c 89 ff             	mov    %r15,%rdi
 100771d:	44 89 ee             	mov    %r13d,%esi
 1007720:	e8 e5 05 00 00       	call   1007d0a <_ZN4spanI8rostringE2atEi>
 1007725:	4c 8d 74 24 08       	lea    0x8(%rsp),%r14
 100772a:	4c 89 f7             	mov    %r14,%rdi
 100772d:	48 8d b4 24 a8 00 00 	lea    0xa8(%rsp),%rsi
 1007734:	00 
 1007735:	48 89 c2             	mov    %rax,%rdx
 1007738:	31 c0                	xor    %eax,%eax
 100773a:	e8 8a 9a ff ff       	call   10011c9 <_Z6format8rostringz>
 100773f:	4c 89 f7             	mov    %r14,%rdi
 1007742:	e8 39 a1 ff ff       	call   1001880 <_ZN6string10c_str_thisEv>
 1007747:	49 89 c6             	mov    %rax,%r14
 100774a:	8a 00                	mov    (%rax),%al
 100774c:	84 c0                	test   %al,%al
 100774e:	74 1a                	je     100776a <kernel_main+0x20b>
 1007750:	49 ff c6             	inc    %r14
 1007753:	0f be f0             	movsbl %al,%esi
 1007756:	bf 00 00 11 00       	mov    $0x110000,%edi
 100775b:	e8 f2 c3 ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1007760:	41 8a 06             	mov    (%r14),%al
 1007763:	49 ff c6             	inc    %r14
 1007766:	84 c0                	test   %al,%al
 1007768:	75 e9                	jne    1007753 <kernel_main+0x1f4>
 100776a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 100776f:	48 85 c0             	test   %rax,%rax
 1007772:	74 2e                	je     10077a2 <kernel_main+0x243>
 1007774:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1007778:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 100777c:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1007783:	00 04 
 1007785:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 100778a:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 1007791:	04 
 1007792:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1007799:	04 
 100779a:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10077a1:	00 
 10077a2:	8b 44 24 40          	mov    0x40(%rsp),%eax
 10077a6:	41 83 fd 01          	cmp    $0x1,%r13d
 10077aa:	77 0c                	ja     10077b8 <kernel_main+0x259>
 10077ac:	41 ff c5             	inc    %r13d
 10077af:	41 39 c5             	cmp    %eax,%r13d
 10077b2:	0f 8c 4b ff ff ff    	jl     1007703 <kernel_main+0x1a4>
 10077b8:	4d 89 fd             	mov    %r15,%r13
 10077bb:	4c 89 ff             	mov    %r15,%rdi
 10077be:	31 f6                	xor    %esi,%esi
 10077c0:	e8 45 05 00 00       	call   1007d0a <_ZN4spanI8rostringE2atEi>
 10077c5:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%rsp)
 10077cc:	00 
 10077cd:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
 10077d1:	48 c7 84 24 98 00 00 	movq   $0x10088cc,0x98(%rsp)
 10077d8:	00 cc 88 00 01 
 10077dd:	89 8c 24 a0 00 00 00 	mov    %ecx,0xa0(%rsp)
 10077e4:	48 89 c7             	mov    %rax,%rdi
 10077e7:	48 8d b4 24 98 00 00 	lea    0x98(%rsp),%rsi
 10077ee:	00 
 10077ef:	e8 8e 02 00 00       	call   1007a82 <_ZNK4spanIcE11starts_withES0_>
 10077f4:	84 c0                	test   %al,%al
 10077f6:	75 3f                	jne    1007837 <kernel_main+0x2d8>
 10077f8:	4c 89 ef             	mov    %r13,%rdi
 10077fb:	31 f6                	xor    %esi,%esi
 10077fd:	e8 08 05 00 00       	call   1007d0a <_ZN4spanI8rostringE2atEi>
 1007802:	c7 04 24 0e 00 00 00 	movl   $0xe,(%rsp)
 1007809:	8b 0c 24             	mov    (%rsp),%ecx
 100780c:	48 c7 84 24 88 00 00 	movq   $0x10084ab,0x88(%rsp)
 1007813:	00 ab 84 00 01 
 1007818:	89 8c 24 90 00 00 00 	mov    %ecx,0x90(%rsp)
 100781f:	48 89 c7             	mov    %rax,%rdi
 1007822:	48 8d b4 24 88 00 00 	lea    0x88(%rsp),%rsi
 1007829:	00 
 100782a:	e8 53 02 00 00       	call   1007a82 <_ZNK4spanIcE11starts_withES0_>
 100782f:	84 c0                	test   %al,%al
 1007831:	0f 84 b0 00 00 00    	je     10078e7 <kernel_main+0x388>
 1007837:	31 c0                	xor    %eax,%eax
 1007839:	4c 8d 74 24 28       	lea    0x28(%rsp),%r14
 100783e:	80 b8 6e 86 00 01 00 	cmpb   $0x0,0x100866e(%rax)
 1007845:	48 8d 40 01          	lea    0x1(%rax),%rax
 1007849:	75 f3                	jne    100783e <kernel_main+0x2df>
 100784b:	ff c8                	dec    %eax
 100784d:	89 04 24             	mov    %eax,(%rsp)
 1007850:	8b 04 24             	mov    (%rsp),%eax
 1007853:	48 c7 44 24 78 6e 86 	movq   $0x100866e,0x78(%rsp)
 100785a:	00 01 
 100785c:	89 84 24 80 00 00 00 	mov    %eax,0x80(%rsp)
 1007863:	31 d2                	xor    %edx,%edx
 1007865:	80 ba e4 89 00 01 00 	cmpb   $0x0,0x10089e4(%rdx)
 100786c:	48 8d 52 01          	lea    0x1(%rdx),%rdx
 1007870:	75 f3                	jne    1007865 <kernel_main+0x306>
 1007872:	ff ca                	dec    %edx
 1007874:	b9 e4 89 00 01       	mov    $0x10089e4,%ecx
 1007879:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
 100787e:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
 1007883:	31 c0                	xor    %eax,%eax
 1007885:	e8 3f 99 ff ff       	call   10011c9 <_Z6format8rostringz>
 100788a:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 100788f:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
 1007894:	8b 44 24 10          	mov    0x10(%rsp),%eax
 1007898:	89 44 24 70          	mov    %eax,0x70(%rsp)
 100789c:	48 89 df             	mov    %rbx,%rdi
 100789f:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
 10078a4:	e8 07 f0 ff ff       	call   10068b0 <_ZNV14tcp_connection4sendE10tcp_packet>
 10078a9:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
 10078ae:	48 85 c0             	test   %rax,%rax
 10078b1:	0f 84 ad 00 00 00    	je     1007964 <kernel_main+0x405>
 10078b7:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10078bb:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10078bf:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10078c6:	00 04 
 10078c8:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 10078cd:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10078d4:	04 
 10078d5:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10078dc:	04 
 10078dd:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10078e4:	00 
 10078e5:	eb 7d                	jmp    1007964 <kernel_main+0x405>
 10078e7:	4c 89 ef             	mov    %r13,%rdi
 10078ea:	31 f6                	xor    %esi,%esi
 10078ec:	e8 19 04 00 00       	call   1007d0a <_ZN4spanI8rostringE2atEi>
 10078f1:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%rsp)
 10078f8:	00 
 10078f9:	8b 4c 24 08          	mov    0x8(%rsp),%ecx
 10078fd:	48 c7 44 24 58 af 8a 	movq   $0x1008aaf,0x58(%rsp)
 1007904:	00 01 
 1007906:	89 4c 24 60          	mov    %ecx,0x60(%rsp)
 100790a:	48 89 c7             	mov    %rax,%rdi
 100790d:	48 8d 74 24 58       	lea    0x58(%rsp),%rsi
 1007912:	e8 6b 01 00 00       	call   1007a82 <_ZNK4spanIcE11starts_withES0_>
 1007917:	84 c0                	test   %al,%al
 1007919:	4c 8d 74 24 28       	lea    0x28(%rsp),%r14
 100791e:	74 44                	je     1007964 <kernel_main+0x405>
 1007920:	c7 44 24 08 4f 00 00 	movl   $0x4f,0x8(%rsp)
 1007927:	00 
 1007928:	8b 44 24 08          	mov    0x8(%rsp),%eax
 100792c:	48 c7 44 24 48 91 85 	movq   $0x1008591,0x48(%rsp)
 1007933:	00 01 
 1007935:	89 44 24 50          	mov    %eax,0x50(%rsp)
 1007939:	48 89 df             	mov    %rbx,%rdi
 100793c:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
 1007941:	e8 6a ef ff ff       	call   10068b0 <_ZNV14tcp_connection4sendE10tcp_packet>
 1007946:	48 89 df             	mov    %rbx,%rdi
 1007949:	e8 4a f0 ff ff       	call   1006998 <_ZNV14tcp_connection5closeEv>
 100794e:	48 89 df             	mov    %rbx,%rdi
 1007951:	e8 9f eb ff ff       	call   10064f5 <_Z11tcp_destroyPV14tcp_connection>
 1007956:	4c 89 f7             	mov    %r14,%rdi
 1007959:	44 89 e6             	mov    %r12d,%esi
 100795c:	e8 e7 00 00 00       	call   1007a48 <_ZN6vectorIPV14tcp_connectionE5eraseEi>
 1007961:	41 ff cc             	dec    %r12d
 1007964:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
 1007969:	48 85 c0             	test   %rax,%rax
 100796c:	74 2e                	je     100799c <kernel_main+0x43d>
 100796e:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 1007972:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 1007976:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 100797d:	00 04 
 100797f:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 1007984:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 100798b:	04 
 100798c:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 1007993:	04 
 1007994:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 100799b:	00 
 100799c:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
 10079a1:	48 85 c0             	test   %rax,%rax
 10079a4:	74 2e                	je     10079d4 <kernel_main+0x475>
 10079a6:	48 8d 48 f0          	lea    -0x10(%rax),%rcx
 10079aa:	48 8b 50 f0          	mov    -0x10(%rax),%rdx
 10079ae:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10079b5:	00 04 
 10079b7:	c5 f8 11 40 f0       	vmovups %xmm0,-0x10(%rax)
 10079bc:	48 89 14 25 00 00 00 	mov    %rdx,0x4000000
 10079c3:	04 
 10079c4:	48 89 0c 25 08 00 00 	mov    %rcx,0x4000008
 10079cb:	04 
 10079cc:	48 29 14 25 28 00 11 	sub    %rdx,0x110028
 10079d3:	00 
 10079d4:	41 ff c4             	inc    %r12d
 10079d7:	44 3b 64 24 30       	cmp    0x30(%rsp),%r12d
 10079dc:	0f 8c 57 fc ff ff    	jl     1007639 <kernel_main+0xda>
 10079e2:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%rsp)
 10079e7:	0f 85 0b fc ff ff    	jne    10075f8 <kernel_main+0x99>
 10079ed:	eb fe                	jmp    10079ed <kernel_main+0x48e>
 10079ef:	cc                   	int3   

00000000010079f0 <_ZN6vectorIPV14tcp_connectionE2atEi>:
 10079f0:	41 56                	push   %r14
 10079f2:	53                   	push   %rbx
 10079f3:	50                   	push   %rax
 10079f4:	41 89 f6             	mov    %esi,%r14d
 10079f7:	48 89 fb             	mov    %rdi,%rbx
 10079fa:	8b 47 0c             	mov    0xc(%rdi),%eax
 10079fd:	39 f0                	cmp    %esi,%eax
 10079ff:	7f 26                	jg     1007a27 <_ZN6vectorIPV14tcp_connectionE2atEi+0x37>
 1007a01:	83 f8 02             	cmp    $0x2,%eax
 1007a04:	be 01 00 00 00       	mov    $0x1,%esi
 1007a09:	0f 4d f0             	cmovge %eax,%esi
 1007a0c:	44 39 f6             	cmp    %r14d,%esi
 1007a0f:	7f 0e                	jg     1007a1f <_ZN6vectorIPV14tcp_connectionE2atEi+0x2f>
 1007a11:	c5 f2 2a c6          	vcvtsi2ss %esi,%xmm1,%xmm0
 1007a15:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
 1007a19:	c5 fa 2c f0          	vcvttss2si %xmm0,%esi
 1007a1d:	eb ed                	jmp    1007a0c <_ZN6vectorIPV14tcp_connectionE2atEi+0x1c>
 1007a1f:	48 89 df             	mov    %rbx,%rdi
 1007a22:	e8 5d 02 00 00       	call   1007c84 <_ZN6vectorIPV14tcp_connectionE7reserveEi>
 1007a27:	8b 43 08             	mov    0x8(%rbx),%eax
 1007a2a:	41 8d 4e 01          	lea    0x1(%r14),%ecx
 1007a2e:	39 c8                	cmp    %ecx,%eax
 1007a30:	0f 4f c8             	cmovg  %eax,%ecx
 1007a33:	89 4b 08             	mov    %ecx,0x8(%rbx)
 1007a36:	49 63 c6             	movslq %r14d,%rax
 1007a39:	48 c1 e0 03          	shl    $0x3,%rax
 1007a3d:	48 03 03             	add    (%rbx),%rax
 1007a40:	48 83 c4 08          	add    $0x8,%rsp
 1007a44:	5b                   	pop    %rbx
 1007a45:	41 5e                	pop    %r14
 1007a47:	c3                   	ret    

0000000001007a48 <_ZN6vectorIPV14tcp_connectionE5eraseEi>:
 1007a48:	8b 47 08             	mov    0x8(%rdi),%eax
 1007a4b:	39 f0                	cmp    %esi,%eax
 1007a4d:	7e 31                	jle    1007a80 <_ZN6vectorIPV14tcp_connectionE5eraseEi+0x38>
 1007a4f:	8d 46 01             	lea    0x1(%rsi),%eax
 1007a52:	8b 4f 08             	mov    0x8(%rdi),%ecx
 1007a55:	39 c8                	cmp    %ecx,%eax
 1007a57:	7d 22                	jge    1007a7b <_ZN6vectorIPV14tcp_connectionE5eraseEi+0x33>
 1007a59:	48 63 c6             	movslq %esi,%rax
 1007a5c:	48 ff c0             	inc    %rax
 1007a5f:	48 8b 0f             	mov    (%rdi),%rcx
 1007a62:	48 8b 14 c1          	mov    (%rcx,%rax,8),%rdx
 1007a66:	48 63 f6             	movslq %esi,%rsi
 1007a69:	48 89 14 f1          	mov    %rdx,(%rcx,%rsi,8)
 1007a6d:	48 ff c0             	inc    %rax
 1007a70:	48 63 4f 08          	movslq 0x8(%rdi),%rcx
 1007a74:	ff c6                	inc    %esi
 1007a76:	48 39 c8             	cmp    %rcx,%rax
 1007a79:	7c e4                	jl     1007a5f <_ZN6vectorIPV14tcp_connectionE5eraseEi+0x17>
 1007a7b:	ff c9                	dec    %ecx
 1007a7d:	89 4f 08             	mov    %ecx,0x8(%rdi)
 1007a80:	c3                   	ret    
 1007a81:	cc                   	int3   

0000000001007a82 <_ZNK4spanIcE11starts_withES0_>:
 1007a82:	55                   	push   %rbp
 1007a83:	41 57                	push   %r15
 1007a85:	41 56                	push   %r14
 1007a87:	41 55                	push   %r13
 1007a89:	41 54                	push   %r12
 1007a8b:	53                   	push   %rbx
 1007a8c:	50                   	push   %rax
 1007a8d:	8b 47 08             	mov    0x8(%rdi),%eax
 1007a90:	3b 46 08             	cmp    0x8(%rsi),%eax
 1007a93:	7d 04                	jge    1007a99 <_ZNK4spanIcE11starts_withES0_+0x17>
 1007a95:	31 db                	xor    %ebx,%ebx
 1007a97:	eb 43                	jmp    1007adc <_ZNK4spanIcE11starts_withES0_+0x5a>
 1007a99:	49 89 f6             	mov    %rsi,%r14
 1007a9c:	83 7e 08 00          	cmpl   $0x0,0x8(%rsi)
 1007aa0:	7e 38                	jle    1007ada <_ZNK4spanIcE11starts_withES0_+0x58>
 1007aa2:	49 89 ff             	mov    %rdi,%r15
 1007aa5:	b3 01                	mov    $0x1,%bl
 1007aa7:	45 31 e4             	xor    %r12d,%r12d
 1007aaa:	31 ed                	xor    %ebp,%ebp
 1007aac:	4c 89 ff             	mov    %r15,%rdi
 1007aaf:	89 ee                	mov    %ebp,%esi
 1007ab1:	e8 7c 00 00 00       	call   1007b32 <_ZNK4spanIcE2atEi>
 1007ab6:	44 8a 28             	mov    (%rax),%r13b
 1007ab9:	4c 89 f7             	mov    %r14,%rdi
 1007abc:	89 ee                	mov    %ebp,%esi
 1007abe:	e8 6f 00 00 00       	call   1007b32 <_ZNK4spanIcE2atEi>
 1007ac3:	44 3a 28             	cmp    (%rax),%r13b
 1007ac6:	0f b6 db             	movzbl %bl,%ebx
 1007ac9:	41 0f 45 dc          	cmovne %r12d,%ebx
 1007acd:	ff c5                	inc    %ebp
 1007acf:	41 3b 6e 08          	cmp    0x8(%r14),%ebp
 1007ad3:	7c d7                	jl     1007aac <_ZNK4spanIcE11starts_withES0_+0x2a>
 1007ad5:	80 e3 01             	and    $0x1,%bl
 1007ad8:	eb 02                	jmp    1007adc <_ZNK4spanIcE11starts_withES0_+0x5a>
 1007ada:	b3 01                	mov    $0x1,%bl
 1007adc:	89 d8                	mov    %ebx,%eax
 1007ade:	48 83 c4 08          	add    $0x8,%rsp
 1007ae2:	5b                   	pop    %rbx
 1007ae3:	41 5c                	pop    %r12
 1007ae5:	41 5d                	pop    %r13
 1007ae7:	41 5e                	pop    %r14
 1007ae9:	41 5f                	pop    %r15
 1007aeb:	5d                   	pop    %rbp
 1007aec:	c3                   	ret    
 1007aed:	cc                   	int3   

0000000001007aee <_ZNK4spanIcE4findERKc>:
 1007aee:	55                   	push   %rbp
 1007aef:	41 57                	push   %r15
 1007af1:	41 56                	push   %r14
 1007af3:	53                   	push   %rbx
 1007af4:	50                   	push   %rax
 1007af5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 1007afa:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
 1007afe:	7e 25                	jle    1007b25 <_ZNK4spanIcE4findERKc+0x37>
 1007b00:	49 89 f6             	mov    %rsi,%r14
 1007b03:	49 89 ff             	mov    %rdi,%r15
 1007b06:	31 ed                	xor    %ebp,%ebp
 1007b08:	4c 89 ff             	mov    %r15,%rdi
 1007b0b:	89 ee                	mov    %ebp,%esi
 1007b0d:	e8 20 00 00 00       	call   1007b32 <_ZNK4spanIcE2atEi>
 1007b12:	8a 00                	mov    (%rax),%al
 1007b14:	41 3a 06             	cmp    (%r14),%al
 1007b17:	74 0a                	je     1007b23 <_ZNK4spanIcE4findERKc+0x35>
 1007b19:	ff c5                	inc    %ebp
 1007b1b:	41 3b 6f 08          	cmp    0x8(%r15),%ebp
 1007b1f:	7c e7                	jl     1007b08 <_ZNK4spanIcE4findERKc+0x1a>
 1007b21:	eb 02                	jmp    1007b25 <_ZNK4spanIcE4findERKc+0x37>
 1007b23:	89 eb                	mov    %ebp,%ebx
 1007b25:	89 d8                	mov    %ebx,%eax
 1007b27:	48 83 c4 08          	add    $0x8,%rsp
 1007b2b:	5b                   	pop    %rbx
 1007b2c:	41 5e                	pop    %r14
 1007b2e:	41 5f                	pop    %r15
 1007b30:	5d                   	pop    %rbp
 1007b31:	c3                   	ret    

0000000001007b32 <_ZNK4spanIcE2atEi>:
 1007b32:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
 1007b36:	74 07                	je     1007b3f <_ZNK4spanIcE2atEi+0xd>
 1007b38:	48 63 c6             	movslq %esi,%rax
 1007b3b:	48 03 07             	add    (%rdi),%rax
 1007b3e:	c3                   	ret    
 1007b3f:	53                   	push   %rbx
 1007b40:	b0 4f                	mov    $0x4f,%al
 1007b42:	48 c7 c3 eb ff ff ff 	mov    $0xffffffffffffffeb,%rbx
 1007b49:	0f be f0             	movsbl %al,%esi
 1007b4c:	bf 00 00 11 00       	mov    $0x110000,%edi
 1007b51:	e8 fc bf ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1007b56:	8a 83 c6 87 00 01    	mov    0x10087c6(%rbx),%al
 1007b5c:	48 ff c3             	inc    %rbx
 1007b5f:	75 e8                	jne    1007b49 <_ZNK4spanIcE2atEi+0x17>
 1007b61:	bf 01 00 00 00       	mov    $0x1,%edi
 1007b66:	e8 ff c0 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1007b6b:	c6 00 00             	movb   $0x0,(%rax)
 1007b6e:	5b                   	pop    %rbx
 1007b6f:	c3                   	ret    

0000000001007b70 <_ZN4spanI9arp_entryE2atEi>:
 1007b70:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
 1007b74:	74 0b                	je     1007b81 <_ZN4spanI9arp_entryE2atEi+0x11>
 1007b76:	48 63 c6             	movslq %esi,%rax
 1007b79:	48 c1 e0 04          	shl    $0x4,%rax
 1007b7d:	48 03 07             	add    (%rdi),%rax
 1007b80:	c3                   	ret    
 1007b81:	53                   	push   %rbx
 1007b82:	b0 4f                	mov    $0x4f,%al
 1007b84:	48 c7 c3 eb ff ff ff 	mov    $0xffffffffffffffeb,%rbx
 1007b8b:	0f be f0             	movsbl %al,%esi
 1007b8e:	bf 00 00 11 00       	mov    $0x110000,%edi
 1007b93:	e8 ba bf ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1007b98:	8a 83 c6 87 00 01    	mov    0x10087c6(%rbx),%al
 1007b9e:	48 ff c3             	inc    %rbx
 1007ba1:	75 e8                	jne    1007b8b <_ZN4spanI9arp_entryE2atEi+0x1b>
 1007ba3:	bf 10 00 00 00       	mov    $0x10,%edi
 1007ba8:	e8 bd c0 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1007bad:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 1007bb1:	c5 f8 29 00          	vmovaps %xmm0,(%rax)
 1007bb5:	5b                   	pop    %rbx
 1007bb6:	c3                   	ret    
 1007bb7:	cc                   	int3   

0000000001007bb8 <_ZN6vectorIP14tcp_connectionE7reserveEi>:
 1007bb8:	39 77 0c             	cmp    %esi,0xc(%rdi)
 1007bbb:	7d 7f                	jge    1007c3c <_ZN6vectorIP14tcp_connectionE7reserveEi+0x84>
 1007bbd:	41 56                	push   %r14
 1007bbf:	53                   	push   %rbx
 1007bc0:	50                   	push   %rax
 1007bc1:	89 f3                	mov    %esi,%ebx
 1007bc3:	49 89 fe             	mov    %rdi,%r14
 1007bc6:	89 f0                	mov    %esi,%eax
 1007bc8:	48 c1 e0 03          	shl    $0x3,%rax
 1007bcc:	85 f6                	test   %esi,%esi
 1007bce:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
 1007bd5:	48 0f 49 f8          	cmovns %rax,%rdi
 1007bd9:	e8 8c c0 ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1007bde:	49 8b 0e             	mov    (%r14),%rcx
 1007be1:	48 85 c9             	test   %rcx,%rcx
 1007be4:	74 48                	je     1007c2e <_ZN6vectorIP14tcp_connectionE7reserveEi+0x76>
 1007be6:	41 8b 56 08          	mov    0x8(%r14),%edx
 1007bea:	85 d2                	test   %edx,%edx
 1007bec:	7e 12                	jle    1007c00 <_ZN6vectorIP14tcp_connectionE7reserveEi+0x48>
 1007bee:	31 f6                	xor    %esi,%esi
 1007bf0:	48 8b 3c f1          	mov    (%rcx,%rsi,8),%rdi
 1007bf4:	48 89 3c f0          	mov    %rdi,(%rax,%rsi,8)
 1007bf8:	48 ff c6             	inc    %rsi
 1007bfb:	48 39 f2             	cmp    %rsi,%rdx
 1007bfe:	75 f0                	jne    1007bf0 <_ZN6vectorIP14tcp_connectionE7reserveEi+0x38>
 1007c00:	48 8d 51 f0          	lea    -0x10(%rcx),%rdx
 1007c04:	48 8b 71 f0          	mov    -0x10(%rcx),%rsi
 1007c08:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1007c0f:	00 04 
 1007c11:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
 1007c16:	48 89 34 25 00 00 00 	mov    %rsi,0x4000000
 1007c1d:	04 
 1007c1e:	48 89 14 25 08 00 00 	mov    %rdx,0x4000008
 1007c25:	04 
 1007c26:	48 29 34 25 28 00 11 	sub    %rsi,0x110028
 1007c2d:	00 
 1007c2e:	49 89 06             	mov    %rax,(%r14)
 1007c31:	41 89 5e 0c          	mov    %ebx,0xc(%r14)
 1007c35:	48 83 c4 08          	add    $0x8,%rsp
 1007c39:	5b                   	pop    %rbx
 1007c3a:	41 5e                	pop    %r14
 1007c3c:	c3                   	ret    
 1007c3d:	cc                   	int3   

0000000001007c3e <_ZN4spanIP14tcp_connectionE2atEi>:
 1007c3e:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
 1007c42:	74 0b                	je     1007c4f <_ZN4spanIP14tcp_connectionE2atEi+0x11>
 1007c44:	48 63 c6             	movslq %esi,%rax
 1007c47:	48 c1 e0 03          	shl    $0x3,%rax
 1007c4b:	48 03 07             	add    (%rdi),%rax
 1007c4e:	c3                   	ret    
 1007c4f:	53                   	push   %rbx
 1007c50:	b0 4f                	mov    $0x4f,%al
 1007c52:	48 c7 c3 eb ff ff ff 	mov    $0xffffffffffffffeb,%rbx
 1007c59:	0f be f0             	movsbl %al,%esi
 1007c5c:	bf 00 00 11 00       	mov    $0x110000,%edi
 1007c61:	e8 ec be ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1007c66:	8a 83 c6 87 00 01    	mov    0x10087c6(%rbx),%al
 1007c6c:	48 ff c3             	inc    %rbx
 1007c6f:	75 e8                	jne    1007c59 <_ZN4spanIP14tcp_connectionE2atEi+0x1b>
 1007c71:	bf 08 00 00 00       	mov    $0x8,%edi
 1007c76:	e8 ef bf ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1007c7b:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
 1007c82:	5b                   	pop    %rbx
 1007c83:	c3                   	ret    

0000000001007c84 <_ZN6vectorIPV14tcp_connectionE7reserveEi>:
 1007c84:	39 77 0c             	cmp    %esi,0xc(%rdi)
 1007c87:	7d 7f                	jge    1007d08 <_ZN6vectorIPV14tcp_connectionE7reserveEi+0x84>
 1007c89:	41 56                	push   %r14
 1007c8b:	53                   	push   %rbx
 1007c8c:	50                   	push   %rax
 1007c8d:	89 f3                	mov    %esi,%ebx
 1007c8f:	49 89 fe             	mov    %rdi,%r14
 1007c92:	89 f0                	mov    %esi,%eax
 1007c94:	48 c1 e0 03          	shl    $0x3,%rax
 1007c98:	85 f6                	test   %esi,%esi
 1007c9a:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
 1007ca1:	48 0f 49 f8          	cmovns %rax,%rdi
 1007ca5:	e8 c0 bf ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1007caa:	49 8b 0e             	mov    (%r14),%rcx
 1007cad:	48 85 c9             	test   %rcx,%rcx
 1007cb0:	74 48                	je     1007cfa <_ZN6vectorIPV14tcp_connectionE7reserveEi+0x76>
 1007cb2:	41 8b 56 08          	mov    0x8(%r14),%edx
 1007cb6:	85 d2                	test   %edx,%edx
 1007cb8:	7e 12                	jle    1007ccc <_ZN6vectorIPV14tcp_connectionE7reserveEi+0x48>
 1007cba:	31 f6                	xor    %esi,%esi
 1007cbc:	48 8b 3c f1          	mov    (%rcx,%rsi,8),%rdi
 1007cc0:	48 89 3c f0          	mov    %rdi,(%rax,%rsi,8)
 1007cc4:	48 ff c6             	inc    %rsi
 1007cc7:	48 39 f2             	cmp    %rsi,%rdx
 1007cca:	75 f0                	jne    1007cbc <_ZN6vectorIPV14tcp_connectionE7reserveEi+0x38>
 1007ccc:	48 8d 51 f0          	lea    -0x10(%rcx),%rdx
 1007cd0:	48 8b 71 f0          	mov    -0x10(%rcx),%rsi
 1007cd4:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1007cdb:	00 04 
 1007cdd:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
 1007ce2:	48 89 34 25 00 00 00 	mov    %rsi,0x4000000
 1007ce9:	04 
 1007cea:	48 89 14 25 08 00 00 	mov    %rdx,0x4000008
 1007cf1:	04 
 1007cf2:	48 29 34 25 28 00 11 	sub    %rsi,0x110028
 1007cf9:	00 
 1007cfa:	49 89 06             	mov    %rax,(%r14)
 1007cfd:	41 89 5e 0c          	mov    %ebx,0xc(%r14)
 1007d01:	48 83 c4 08          	add    $0x8,%rsp
 1007d05:	5b                   	pop    %rbx
 1007d06:	41 5e                	pop    %r14
 1007d08:	c3                   	ret    
 1007d09:	cc                   	int3   

0000000001007d0a <_ZN4spanI8rostringE2atEi>:
 1007d0a:	83 7f 08 00          	cmpl   $0x0,0x8(%rdi)
 1007d0e:	74 0b                	je     1007d1b <_ZN4spanI8rostringE2atEi+0x11>
 1007d10:	48 63 c6             	movslq %esi,%rax
 1007d13:	48 c1 e0 04          	shl    $0x4,%rax
 1007d17:	48 03 07             	add    (%rdi),%rax
 1007d1a:	c3                   	ret    
 1007d1b:	53                   	push   %rbx
 1007d1c:	b0 4f                	mov    $0x4f,%al
 1007d1e:	48 c7 c3 eb ff ff ff 	mov    $0xffffffffffffffeb,%rbx
 1007d25:	0f be f0             	movsbl %al,%esi
 1007d28:	bf 00 00 11 00       	mov    $0x110000,%edi
 1007d2d:	e8 20 be ff ff       	call   1003b52 <_ZN7console7putcharEc>
 1007d32:	8a 83 c6 87 00 01    	mov    0x10087c6(%rbx),%al
 1007d38:	48 ff c3             	inc    %rbx
 1007d3b:	75 e8                	jne    1007d25 <_ZN4spanI8rostringE2atEi+0x1b>
 1007d3d:	bf 10 00 00 00       	mov    $0x10,%edi
 1007d42:	e8 23 bf ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1007d47:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
 1007d4b:	c5 f8 11 00          	vmovups %xmm0,(%rax)
 1007d4f:	5b                   	pop    %rbx
 1007d50:	c3                   	ret    
 1007d51:	cc                   	int3   

0000000001007d52 <_ZN6vectorIcEC2EPKcii>:
 1007d52:	55                   	push   %rbp
 1007d53:	41 56                	push   %r14
 1007d55:	53                   	push   %rbx
 1007d56:	89 cd                	mov    %ecx,%ebp
 1007d58:	48 89 f3             	mov    %rsi,%rbx
 1007d5b:	49 89 fe             	mov    %rdi,%r14
 1007d5e:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
 1007d65:	89 57 0c             	mov    %edx,0xc(%rdi)
 1007d68:	89 57 08             	mov    %edx,0x8(%rdi)
 1007d6b:	48 63 fa             	movslq %edx,%rdi
 1007d6e:	e8 f7 be ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1007d73:	49 89 06             	mov    %rax,(%r14)
 1007d76:	41 83 7e 08 00       	cmpl   $0x0,0x8(%r14)
 1007d7b:	7e 1d                	jle    1007d9a <_ZN6vectorIcEC2EPKcii+0x48>
 1007d7d:	48 63 c5             	movslq %ebp,%rax
 1007d80:	48 01 c3             	add    %rax,%rbx
 1007d83:	31 c0                	xor    %eax,%eax
 1007d85:	8a 0c 03             	mov    (%rbx,%rax,1),%cl
 1007d88:	49 8b 16             	mov    (%r14),%rdx
 1007d8b:	88 0c 02             	mov    %cl,(%rdx,%rax,1)
 1007d8e:	48 ff c0             	inc    %rax
 1007d91:	49 63 4e 08          	movslq 0x8(%r14),%rcx
 1007d95:	48 39 c8             	cmp    %rcx,%rax
 1007d98:	7c eb                	jl     1007d85 <_ZN6vectorIcEC2EPKcii+0x33>
 1007d9a:	5b                   	pop    %rbx
 1007d9b:	41 5e                	pop    %r14
 1007d9d:	5d                   	pop    %rbp
 1007d9e:	c3                   	ret    
 1007d9f:	cc                   	int3   

0000000001007da0 <_ZN6vectorIcE2atEi>:
 1007da0:	41 56                	push   %r14
 1007da2:	53                   	push   %rbx
 1007da3:	50                   	push   %rax
 1007da4:	41 89 f6             	mov    %esi,%r14d
 1007da7:	48 89 fb             	mov    %rdi,%rbx
 1007daa:	8b 47 0c             	mov    0xc(%rdi),%eax
 1007dad:	39 f0                	cmp    %esi,%eax
 1007daf:	7f 26                	jg     1007dd7 <_ZN6vectorIcE2atEi+0x37>
 1007db1:	83 f8 02             	cmp    $0x2,%eax
 1007db4:	be 01 00 00 00       	mov    $0x1,%esi
 1007db9:	0f 4d f0             	cmovge %eax,%esi
 1007dbc:	44 39 f6             	cmp    %r14d,%esi
 1007dbf:	7f 0e                	jg     1007dcf <_ZN6vectorIcE2atEi+0x2f>
 1007dc1:	c5 f2 2a c6          	vcvtsi2ss %esi,%xmm1,%xmm0
 1007dc5:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
 1007dc9:	c5 fa 2c f0          	vcvttss2si %xmm0,%esi
 1007dcd:	eb ed                	jmp    1007dbc <_ZN6vectorIcE2atEi+0x1c>
 1007dcf:	48 89 df             	mov    %rbx,%rdi
 1007dd2:	e8 b7 c7 ff ff       	call   100458e <_ZN6vectorIcE7reserveEi>
 1007dd7:	8b 43 08             	mov    0x8(%rbx),%eax
 1007dda:	41 8d 4e 01          	lea    0x1(%r14),%ecx
 1007dde:	39 c8                	cmp    %ecx,%eax
 1007de0:	0f 4f c8             	cmovg  %eax,%ecx
 1007de3:	89 4b 08             	mov    %ecx,0x8(%rbx)
 1007de6:	49 63 c6             	movslq %r14d,%rax
 1007de9:	48 03 03             	add    (%rbx),%rax
 1007dec:	48 83 c4 08          	add    $0x8,%rsp
 1007df0:	5b                   	pop    %rbx
 1007df1:	41 5e                	pop    %r14
 1007df3:	c3                   	ret    

0000000001007df4 <_ZN6vectorI8rostringE2atEi>:
 1007df4:	41 56                	push   %r14
 1007df6:	53                   	push   %rbx
 1007df7:	50                   	push   %rax
 1007df8:	41 89 f6             	mov    %esi,%r14d
 1007dfb:	48 89 fb             	mov    %rdi,%rbx
 1007dfe:	8b 47 0c             	mov    0xc(%rdi),%eax
 1007e01:	39 f0                	cmp    %esi,%eax
 1007e03:	7f 26                	jg     1007e2b <_ZN6vectorI8rostringE2atEi+0x37>
 1007e05:	83 f8 02             	cmp    $0x2,%eax
 1007e08:	be 01 00 00 00       	mov    $0x1,%esi
 1007e0d:	0f 4d f0             	cmovge %eax,%esi
 1007e10:	44 39 f6             	cmp    %r14d,%esi
 1007e13:	7f 0e                	jg     1007e23 <_ZN6vectorI8rostringE2atEi+0x2f>
 1007e15:	c5 f2 2a c6          	vcvtsi2ss %esi,%xmm1,%xmm0
 1007e19:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
 1007e1d:	c5 fa 2c f0          	vcvttss2si %xmm0,%esi
 1007e21:	eb ed                	jmp    1007e10 <_ZN6vectorI8rostringE2atEi+0x1c>
 1007e23:	48 89 df             	mov    %rbx,%rdi
 1007e26:	e8 21 00 00 00       	call   1007e4c <_ZN6vectorI8rostringE7reserveEi>
 1007e2b:	8b 43 08             	mov    0x8(%rbx),%eax
 1007e2e:	41 8d 4e 01          	lea    0x1(%r14),%ecx
 1007e32:	39 c8                	cmp    %ecx,%eax
 1007e34:	0f 4f c8             	cmovg  %eax,%ecx
 1007e37:	89 4b 08             	mov    %ecx,0x8(%rbx)
 1007e3a:	49 63 c6             	movslq %r14d,%rax
 1007e3d:	48 c1 e0 04          	shl    $0x4,%rax
 1007e41:	48 03 03             	add    (%rbx),%rax
 1007e44:	48 83 c4 08          	add    $0x8,%rsp
 1007e48:	5b                   	pop    %rbx
 1007e49:	41 5e                	pop    %r14
 1007e4b:	c3                   	ret    

0000000001007e4c <_ZN6vectorI8rostringE7reserveEi>:
 1007e4c:	39 77 0c             	cmp    %esi,0xc(%rdi)
 1007e4f:	0f 8d be 00 00 00    	jge    1007f13 <_ZN6vectorI8rostringE7reserveEi+0xc7>
 1007e55:	41 57                	push   %r15
 1007e57:	41 56                	push   %r14
 1007e59:	41 54                	push   %r12
 1007e5b:	53                   	push   %rbx
 1007e5c:	50                   	push   %rax
 1007e5d:	89 f3                	mov    %esi,%ebx
 1007e5f:	49 89 fe             	mov    %rdi,%r14
 1007e62:	4c 63 e6             	movslq %esi,%r12
 1007e65:	4d 89 e7             	mov    %r12,%r15
 1007e68:	49 c1 e7 04          	shl    $0x4,%r15
 1007e6c:	45 85 e4             	test   %r12d,%r12d
 1007e6f:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
 1007e76:	49 0f 49 ff          	cmovns %r15,%rdi
 1007e7a:	e8 eb bd ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1007e7f:	45 85 e4             	test   %r12d,%r12d
 1007e82:	74 20                	je     1007ea4 <_ZN6vectorI8rostringE7reserveEi+0x58>
 1007e84:	48 89 c1             	mov    %rax,%rcx
 1007e87:	4c 01 f9             	add    %r15,%rcx
 1007e8a:	48 89 c2             	mov    %rax,%rdx
 1007e8d:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)
 1007e94:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
 1007e9b:	48 83 c2 10          	add    $0x10,%rdx
 1007e9f:	48 39 ca             	cmp    %rcx,%rdx
 1007ea2:	75 e9                	jne    1007e8d <_ZN6vectorI8rostringE7reserveEi+0x41>
 1007ea4:	49 8b 0e             	mov    (%r14),%rcx
 1007ea7:	48 85 c9             	test   %rcx,%rcx
 1007eaa:	74 55                	je     1007f01 <_ZN6vectorI8rostringE7reserveEi+0xb5>
 1007eac:	41 8b 56 08          	mov    0x8(%r14),%edx
 1007eb0:	85 d2                	test   %edx,%edx
 1007eb2:	7e 1f                	jle    1007ed3 <_ZN6vectorI8rostringE7reserveEi+0x87>
 1007eb4:	48 c1 e2 04          	shl    $0x4,%rdx
 1007eb8:	31 f6                	xor    %esi,%esi
 1007eba:	48 8b 3c 31          	mov    (%rcx,%rsi,1),%rdi
 1007ebe:	48 89 3c 30          	mov    %rdi,(%rax,%rsi,1)
 1007ec2:	8b 7c 31 08          	mov    0x8(%rcx,%rsi,1),%edi
 1007ec6:	89 7c 30 08          	mov    %edi,0x8(%rax,%rsi,1)
 1007eca:	48 83 c6 10          	add    $0x10,%rsi
 1007ece:	48 39 f2             	cmp    %rsi,%rdx
 1007ed1:	75 e7                	jne    1007eba <_ZN6vectorI8rostringE7reserveEi+0x6e>
 1007ed3:	48 8d 51 f0          	lea    -0x10(%rcx),%rdx
 1007ed7:	48 8b 71 f0          	mov    -0x10(%rcx),%rsi
 1007edb:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1007ee2:	00 04 
 1007ee4:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
 1007ee9:	48 89 34 25 00 00 00 	mov    %rsi,0x4000000
 1007ef0:	04 
 1007ef1:	48 89 14 25 08 00 00 	mov    %rdx,0x4000008
 1007ef8:	04 
 1007ef9:	48 29 34 25 28 00 11 	sub    %rsi,0x110028
 1007f00:	00 
 1007f01:	49 89 06             	mov    %rax,(%r14)
 1007f04:	41 89 5e 0c          	mov    %ebx,0xc(%r14)
 1007f08:	48 83 c4 08          	add    $0x8,%rsp
 1007f0c:	5b                   	pop    %rbx
 1007f0d:	41 5c                	pop    %r12
 1007f0f:	41 5e                	pop    %r14
 1007f11:	41 5f                	pop    %r15
 1007f13:	c3                   	ret    

0000000001007f14 <_ZN6vectorI9arp_entryE2atEi>:
 1007f14:	41 56                	push   %r14
 1007f16:	53                   	push   %rbx
 1007f17:	50                   	push   %rax
 1007f18:	41 89 f6             	mov    %esi,%r14d
 1007f1b:	48 89 fb             	mov    %rdi,%rbx
 1007f1e:	8b 47 0c             	mov    0xc(%rdi),%eax
 1007f21:	39 f0                	cmp    %esi,%eax
 1007f23:	7f 26                	jg     1007f4b <_ZN6vectorI9arp_entryE2atEi+0x37>
 1007f25:	83 f8 02             	cmp    $0x2,%eax
 1007f28:	be 01 00 00 00       	mov    $0x1,%esi
 1007f2d:	0f 4d f0             	cmovge %eax,%esi
 1007f30:	44 39 f6             	cmp    %r14d,%esi
 1007f33:	7f 0e                	jg     1007f43 <_ZN6vectorI9arp_entryE2atEi+0x2f>
 1007f35:	c5 f2 2a c6          	vcvtsi2ss %esi,%xmm1,%xmm0
 1007f39:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
 1007f3d:	c5 fa 2c f0          	vcvttss2si %xmm0,%esi
 1007f41:	eb ed                	jmp    1007f30 <_ZN6vectorI9arp_entryE2atEi+0x1c>
 1007f43:	48 89 df             	mov    %rbx,%rdi
 1007f46:	e8 21 00 00 00       	call   1007f6c <_ZN6vectorI9arp_entryE7reserveEi>
 1007f4b:	8b 43 08             	mov    0x8(%rbx),%eax
 1007f4e:	41 8d 4e 01          	lea    0x1(%r14),%ecx
 1007f52:	39 c8                	cmp    %ecx,%eax
 1007f54:	0f 4f c8             	cmovg  %eax,%ecx
 1007f57:	89 4b 08             	mov    %ecx,0x8(%rbx)
 1007f5a:	49 63 c6             	movslq %r14d,%rax
 1007f5d:	48 c1 e0 04          	shl    $0x4,%rax
 1007f61:	48 03 03             	add    (%rbx),%rax
 1007f64:	48 83 c4 08          	add    $0x8,%rsp
 1007f68:	5b                   	pop    %rbx
 1007f69:	41 5e                	pop    %r14
 1007f6b:	c3                   	ret    

0000000001007f6c <_ZN6vectorI9arp_entryE7reserveEi>:
 1007f6c:	39 77 0c             	cmp    %esi,0xc(%rdi)
 1007f6f:	0f 8d 8c 00 00 00    	jge    1008001 <_ZN6vectorI9arp_entryE7reserveEi+0x95>
 1007f75:	41 56                	push   %r14
 1007f77:	53                   	push   %rbx
 1007f78:	50                   	push   %rax
 1007f79:	89 f3                	mov    %esi,%ebx
 1007f7b:	49 89 fe             	mov    %rdi,%r14
 1007f7e:	89 f0                	mov    %esi,%eax
 1007f80:	48 c1 e0 04          	shl    $0x4,%rax
 1007f84:	85 f6                	test   %esi,%esi
 1007f86:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
 1007f8d:	48 0f 49 f8          	cmovns %rax,%rdi
 1007f91:	e8 d4 bc ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 1007f96:	49 8b 0e             	mov    (%r14),%rcx
 1007f99:	48 85 c9             	test   %rcx,%rcx
 1007f9c:	74 55                	je     1007ff3 <_ZN6vectorI9arp_entryE7reserveEi+0x87>
 1007f9e:	41 8b 56 08          	mov    0x8(%r14),%edx
 1007fa2:	85 d2                	test   %edx,%edx
 1007fa4:	7e 1f                	jle    1007fc5 <_ZN6vectorI9arp_entryE7reserveEi+0x59>
 1007fa6:	48 c1 e2 04          	shl    $0x4,%rdx
 1007faa:	31 f6                	xor    %esi,%esi
 1007fac:	8b 7c 31 08          	mov    0x8(%rcx,%rsi,1),%edi
 1007fb0:	89 7c 30 08          	mov    %edi,0x8(%rax,%rsi,1)
 1007fb4:	48 8b 3c 31          	mov    (%rcx,%rsi,1),%rdi
 1007fb8:	48 89 3c 30          	mov    %rdi,(%rax,%rsi,1)
 1007fbc:	48 83 c6 10          	add    $0x10,%rsi
 1007fc0:	48 39 f2             	cmp    %rsi,%rdx
 1007fc3:	75 e7                	jne    1007fac <_ZN6vectorI9arp_entryE7reserveEi+0x40>
 1007fc5:	48 8d 51 f0          	lea    -0x10(%rcx),%rdx
 1007fc9:	48 8b 71 f0          	mov    -0x10(%rcx),%rsi
 1007fcd:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 1007fd4:	00 04 
 1007fd6:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
 1007fdb:	48 89 34 25 00 00 00 	mov    %rsi,0x4000000
 1007fe2:	04 
 1007fe3:	48 89 14 25 08 00 00 	mov    %rdx,0x4000008
 1007fea:	04 
 1007feb:	48 29 34 25 28 00 11 	sub    %rsi,0x110028
 1007ff2:	00 
 1007ff3:	49 89 06             	mov    %rax,(%r14)
 1007ff6:	41 89 5e 0c          	mov    %ebx,0xc(%r14)
 1007ffa:	48 83 c4 08          	add    $0x8,%rsp
 1007ffe:	5b                   	pop    %rbx
 1007fff:	41 5e                	pop    %r14
 1008001:	c3                   	ret    

0000000001008002 <_ZN6vectorI10tcp_packetE2atEi>:
 1008002:	41 56                	push   %r14
 1008004:	53                   	push   %rbx
 1008005:	50                   	push   %rax
 1008006:	41 89 f6             	mov    %esi,%r14d
 1008009:	48 89 fb             	mov    %rdi,%rbx
 100800c:	8b 47 0c             	mov    0xc(%rdi),%eax
 100800f:	39 f0                	cmp    %esi,%eax
 1008011:	7f 26                	jg     1008039 <_ZN6vectorI10tcp_packetE2atEi+0x37>
 1008013:	83 f8 02             	cmp    $0x2,%eax
 1008016:	be 01 00 00 00       	mov    $0x1,%esi
 100801b:	0f 4d f0             	cmovge %eax,%esi
 100801e:	44 39 f6             	cmp    %r14d,%esi
 1008021:	7f 0e                	jg     1008031 <_ZN6vectorI10tcp_packetE2atEi+0x2f>
 1008023:	c5 f2 2a c6          	vcvtsi2ss %esi,%xmm1,%xmm0
 1008027:	c5 fa 58 c0          	vaddss %xmm0,%xmm0,%xmm0
 100802b:	c5 fa 2c f0          	vcvttss2si %xmm0,%esi
 100802f:	eb ed                	jmp    100801e <_ZN6vectorI10tcp_packetE2atEi+0x1c>
 1008031:	48 89 df             	mov    %rbx,%rdi
 1008034:	e8 21 00 00 00       	call   100805a <_ZN6vectorI10tcp_packetE7reserveEi>
 1008039:	8b 43 08             	mov    0x8(%rbx),%eax
 100803c:	41 8d 4e 01          	lea    0x1(%r14),%ecx
 1008040:	39 c8                	cmp    %ecx,%eax
 1008042:	0f 4f c8             	cmovg  %eax,%ecx
 1008045:	89 4b 08             	mov    %ecx,0x8(%rbx)
 1008048:	49 63 c6             	movslq %r14d,%rax
 100804b:	48 c1 e0 04          	shl    $0x4,%rax
 100804f:	48 03 03             	add    (%rbx),%rax
 1008052:	48 83 c4 08          	add    $0x8,%rsp
 1008056:	5b                   	pop    %rbx
 1008057:	41 5e                	pop    %r14
 1008059:	c3                   	ret    

000000000100805a <_ZN6vectorI10tcp_packetE7reserveEi>:
 100805a:	39 77 0c             	cmp    %esi,0xc(%rdi)
 100805d:	0f 8d be 00 00 00    	jge    1008121 <_ZN6vectorI10tcp_packetE7reserveEi+0xc7>
 1008063:	41 57                	push   %r15
 1008065:	41 56                	push   %r14
 1008067:	41 54                	push   %r12
 1008069:	53                   	push   %rbx
 100806a:	50                   	push   %rax
 100806b:	89 f3                	mov    %esi,%ebx
 100806d:	49 89 fe             	mov    %rdi,%r14
 1008070:	4c 63 e6             	movslq %esi,%r12
 1008073:	4d 89 e7             	mov    %r12,%r15
 1008076:	49 c1 e7 04          	shl    $0x4,%r15
 100807a:	45 85 e4             	test   %r12d,%r12d
 100807d:	48 c7 c7 ff ff ff ff 	mov    $0xffffffffffffffff,%rdi
 1008084:	49 0f 49 ff          	cmovns %r15,%rdi
 1008088:	e8 dd bb ff ff       	call   1003c6a <_Z16__malloc_trackedmPKci>
 100808d:	45 85 e4             	test   %r12d,%r12d
 1008090:	74 20                	je     10080b2 <_ZN6vectorI10tcp_packetE7reserveEi+0x58>
 1008092:	48 89 c1             	mov    %rax,%rcx
 1008095:	4c 01 f9             	add    %r15,%rcx
 1008098:	48 89 c2             	mov    %rax,%rdx
 100809b:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)
 10080a2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%rdx)
 10080a9:	48 83 c2 10          	add    $0x10,%rdx
 10080ad:	48 39 ca             	cmp    %rcx,%rdx
 10080b0:	75 e9                	jne    100809b <_ZN6vectorI10tcp_packetE7reserveEi+0x41>
 10080b2:	49 8b 0e             	mov    (%r14),%rcx
 10080b5:	48 85 c9             	test   %rcx,%rcx
 10080b8:	74 55                	je     100810f <_ZN6vectorI10tcp_packetE7reserveEi+0xb5>
 10080ba:	41 8b 56 08          	mov    0x8(%r14),%edx
 10080be:	85 d2                	test   %edx,%edx
 10080c0:	7e 1f                	jle    10080e1 <_ZN6vectorI10tcp_packetE7reserveEi+0x87>
 10080c2:	48 c1 e2 04          	shl    $0x4,%rdx
 10080c6:	31 f6                	xor    %esi,%esi
 10080c8:	48 8b 3c 31          	mov    (%rcx,%rsi,1),%rdi
 10080cc:	48 89 3c 30          	mov    %rdi,(%rax,%rsi,1)
 10080d0:	8b 7c 31 08          	mov    0x8(%rcx,%rsi,1),%edi
 10080d4:	89 7c 30 08          	mov    %edi,0x8(%rax,%rsi,1)
 10080d8:	48 83 c6 10          	add    $0x10,%rsi
 10080dc:	48 39 f2             	cmp    %rsi,%rdx
 10080df:	75 e7                	jne    10080c8 <_ZN6vectorI10tcp_packetE7reserveEi+0x6e>
 10080e1:	48 8d 51 f0          	lea    -0x10(%rcx),%rdx
 10080e5:	48 8b 71 f0          	mov    -0x10(%rcx),%rsi
 10080e9:	c5 f8 10 04 25 00 00 	vmovups 0x4000000,%xmm0
 10080f0:	00 04 
 10080f2:	c5 f8 11 41 f0       	vmovups %xmm0,-0x10(%rcx)
 10080f7:	48 89 34 25 00 00 00 	mov    %rsi,0x4000000
 10080fe:	04 
 10080ff:	48 89 14 25 08 00 00 	mov    %rdx,0x4000008
 1008106:	04 
 1008107:	48 29 34 25 28 00 11 	sub    %rsi,0x110028
 100810e:	00 
 100810f:	49 89 06             	mov    %rax,(%r14)
 1008112:	41 89 5e 0c          	mov    %ebx,0xc(%r14)
 1008116:	48 83 c4 08          	add    $0x8,%rsp
 100811a:	5b                   	pop    %rbx
 100811b:	41 5c                	pop    %r12
 100811d:	41 5e                	pop    %r14
 100811f:	41 5f                	pop    %r15
 1008121:	c3                   	ret    

0000000001008122 <_GLOBAL__sub_I_all.cpp>:
 1008122:	bf 78 8d 00 01       	mov    $0x1008d78,%edi
 1008127:	e9 c4 f2 ff ff       	jmp    10073f0 <_ZN9timepointC1Ev>
