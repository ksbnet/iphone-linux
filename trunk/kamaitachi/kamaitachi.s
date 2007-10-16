

	.text
	.globl	_main
	.align	2
_main:
	sub sp, sp, #20
	str lr, [sp, #+16]
	str r7, [sp, #+12]
	str r6, [sp, #+8]
	str r5, [sp, #+4]
	str r4, [sp]
	add r7, sp, #12
	sub sp, sp, #204
	ldr r3, LCPI1_0
LPC6:
	ldr r3, [pc, +r3]
	ldr r3, [r3]
	ldr r2, LCPI1_1
	str r3, [r7, #-120]
LPC5:
	ldr r3, [pc, +r2]
	ldr r3, [r3]
	str r3, [r7, #-116]
	mov r4, #0
	str r4, [r7, #-100]
	ldr r3, LCPI1_2
	str r4, [r7, #-92]
LPC3:
	ldr r3, [pc, +r3]
	ldr r0, LCPI1_3
	str r4, [r7, #-84]
	add r3, r3, #176
	mov r2, #28
	mov r1, #1
LPC4:
	add r0, pc, r0
	ldr r5, LCPI1_4
	bl L_fwrite$stub
LPC1:
	add r0, pc, r5
	mov r1, r4
	mov r2, r4
	bl L_open$stub
	str r0, [r7, #-64]
	cmp r0, #0
	bge LBB1_2	@ cond_false
LBB1_1:	@ cond_true
	ldr r3, LCPI1_5
	ldr r1, LCPI1_6
	ldr r0, LCPI1_7
LPC8:
	add r3, pc, r3
	mov r2, #50
LPC9:
	add r1, pc, r1
LPC10:
	add r0, pc, r0
	bl L___eprintf$stub
LBB1_2:	@ cond_false
	mov r3, #0
	str r3, [r7, #-20]
LBB1_3:	@ cond_next
	ldr r0, [r7, #-64]
	sub r1, r7, #216
	bl L_fstat$stub
	ldr r0, [r7, #-168]
	str r0, [r7, #-108]
	bl L_malloc$stub
	mov r1, r0
	str r1, [r7, #-112]
	ldr r0, [r7, #-64]
	ldr r2, [r7, #-108]
	bl L_read$stub
	ldr r3, [r7, #-108]
	cmp r0, r3
	beq LBB1_5	@ cond_false49
LBB1_4:	@ cond_true45
	ldr r3, LCPI1_8
	ldr r1, LCPI1_9
	ldr r0, LCPI1_10
LPC15:
	add r3, pc, r3
	mov r2, #53
LPC16:
	add r1, pc, r1
LPC17:
	add r0, pc, r0
	bl L___eprintf$stub
LBB1_5:	@ cond_false49
	mov r3, #0
	str r3, [r7, #-24]
LBB1_6:	@ cond_next50
	ldr r0, [r7, #-64]
	bl L_close$stub
	ldr r3, LCPI1_11
	ldr r2, [r7, #-168]
	ldr r1, LCPI1_12
LPC24:
	ldr r3, [pc, +r3]
LPC23:
	add r1, pc, r1
	add r4, r3, #176
	ldr r5, LCPI1_13
	mov r0, r4
	bl L_fprintf$stub
	mov r2, #50
	mov r1, #1
LPC21:
	add r0, pc, r5
	ldr r5, LCPI1_14
	mov r3, r4
	bl L_fwrite$stub
	mov r2, #0
	mov r1, #2
LPC19:
	add r0, pc, r5
	bl L_open$stub
	str r0, [r7, #-64]
	cmp r0, #0
	bge LBB1_8	@ cond_false75
LBB1_7:	@ cond_true71
	ldr r3, LCPI1_15
	ldr r1, LCPI1_16
	ldr r0, LCPI1_17
LPC27:
	add r3, pc, r3
	mov r2, #58
LPC28:
	add r1, pc, r1
LPC29:
	add r0, pc, r0
	bl L___eprintf$stub
LBB1_8:	@ cond_false75
	mov r3, #0
	str r3, [r7, #-28]
LBB1_9:	@ cond_next76
	ldr r0, [r7, #-64]
	mov r2, #0
	ldr r4, LCPI1_18
	mov r1, r4
	mov r3, r2
	bl L_lseek$stub
	eor r3, r0, r4
	orr r3, r3, r1
	cmp r3, #0
	beq LBB1_11	@ cond_false88
LBB1_10:	@ cond_true84
	ldr r3, LCPI1_19
	ldr r1, LCPI1_20
	ldr r0, LCPI1_21
LPC32:
	add r3, pc, r3
	mov r2, #59
LPC33:
	add r1, pc, r1
LPC34:
	add r0, pc, r0
	bl L___eprintf$stub
LBB1_11:	@ cond_false88
	mov r3, #0
	str r3, [r7, #-32]
LBB1_12:	@ cond_next89
	ldr r3, LCPI1_22
	ldr r2, LCPI1_23
LPC36:
	ldr r4, [pc, +r3]
LPC37:
	ldr r3, [pc, +r2]
	ldr r0, [r7, #-64]
	ldr r2, [r4]
	ldr r1, [r3]
	bl L_write$stub
	ldr r3, [r4]
	cmp r0, r3
	beq LBB1_14	@ cond_false104
LBB1_13:	@ cond_true100
	ldr r3, LCPI1_24
	ldr r1, LCPI1_25
	ldr r0, LCPI1_26
LPC39:
	add r3, pc, r3
	mov r2, #60
LPC40:
	add r1, pc, r1
LPC41:
	add r0, pc, r0
	bl L___eprintf$stub
LBB1_14:	@ cond_false104
	mov r3, #0
	str r3, [r7, #-36]
LBB1_15:	@ cond_next105
	ldr r3, LCPI1_27
	ldr r2, LCPI1_28
LPC50:
	ldr r3, [pc, +r3]
	ldr r1, LCPI1_29
LPC49:
	ldr r0, [pc, +r2]
	ldr r2, [r3]
LPC48:
	add r1, pc, r1
	add r4, r0, #176
	ldr r5, LCPI1_30
	mov r0, r4
	bl L_fprintf$stub
	mov r2, #21
	mov r1, #1
LPC46:
	add r0, pc, r5
	mov r3, r4
	bl L_fwrite$stub
	ldr r3, [r7, #-108]
	ldr r2, [r7, #-116]
	ldr r1, [r7, #-100]
	add r3, r2, r3
	ldr r2, [r7, #-92]
	add r3, r3, r1
	ldr r1, [r7, #-84]
	add r3, r3, r2
	add r2, r3, r1
	str r2, [r7, #-68]
	mov r4, #0
	mov r0, #10
	ldr r5, LCPI1_31
	mov r1, r4
	mov r3, r4
	bl L_ptrace$stub
LPC43:
	ldr r5, [pc, +r5]
	ldr r0, [r7, #-64]
	ldr r3, [r5]
	ldr r6, LCPI1_18
	add r1, r3, r6
	mov r2, r4
	mov r3, r4
	bl L_lseek$stub
	ldr r3, [r5]
	add r3, r3, r6
	eor r3, r0, r3
	orr r3, r3, r1
	cmp r3, #0
	beq LBB1_17	@ cond_false148
LBB1_16:	@ cond_true144
	ldr r3, LCPI1_32
	ldr r1, LCPI1_33
	ldr r0, LCPI1_34
LPC52:
	add r3, pc, r3
	mov r2, #68
LPC53:
	add r1, pc, r1
LPC54:
	add r0, pc, r0
	bl L___eprintf$stub
LBB1_17:	@ cond_false148
	mov r3, #0
	str r3, [r7, #-40]
LBB1_18:	@ cond_next149
	ldr r0, [r7, #-64]
	mov r2, #12
	sub r1, r7, #80
	bl L_read$stub
	cmp r0, #12
	beq LBB1_20	@ cond_false162
LBB1_19:	@ cond_true158
	ldr r3, LCPI1_35
	ldr r1, LCPI1_36
	ldr r0, LCPI1_37
LPC57:
	add r3, pc, r3
	mov r2, #70
LPC58:
	add r1, pc, r1
LPC59:
	add r0, pc, r0
	bl L___eprintf$stub
LBB1_20:	@ cond_false162
	mov r3, #0
	str r3, [r7, #-44]
LBB1_21:	@ cond_next163
	ldr r3, LCPI1_38
	ldr r1, LCPI1_39
LPC62:
	ldr r3, [pc, +r3]
	ldr r2, [r7, #-80]
LPC61:
	add r1, pc, r1
	add r0, r3, #176
	bl L_fprintf$stub
	mov r3, #0
	str r3, [r7, #-48]
	str r3, [r7, #-16]
LBB1_22:	@ return
	ldr r0, [r7, #-16]
	sub sp, r7, #12
	ldr r4, [sp]
	ldr r5, [sp, #+4]
	ldr r6, [sp, #+8]
	ldr r7, [sp, #+12]
	ldr lr, [sp, #+16]
	add sp, sp, #20
	bx lr
LBB1_23:
LCPI1_0:
 	.long	L_boot_data$non_lazy_ptr-(LPC6+8)

LCPI1_1:
 	.long	L_boot_len$non_lazy_ptr-(LPC5+8)

LCPI1_2:
 	.long	L___sF$non_lazy_ptr-(LPC3+8)

LCPI1_3:
 	.long	_.str-(LPC4+8)

LCPI1_4:
 	.long	_.str1-(LPC1+8)

LCPI1_5:
 	.long	_.str4-(LPC8+8)

LCPI1_6:
 	.long	_.str3-(LPC9+8)

LCPI1_7:
 	.long	_.str2-(LPC10+8)

LCPI1_8:
 	.long	_.str5-(LPC15+8)

LCPI1_9:
 	.long	_.str3-(LPC16+8)

LCPI1_10:
 	.long	_.str2-(LPC17+8)

LCPI1_11:
 	.long	L___sF$non_lazy_ptr-(LPC24+8)

LCPI1_12:
 	.long	_.str6-(LPC23+8)

LCPI1_13:
 	.long	_.str7-(LPC21+8)

LCPI1_14:
 	.long	_.str8-(LPC19+8)

LCPI1_15:
 	.long	_.str9-(LPC27+8)

LCPI1_16:
 	.long	_.str3-(LPC28+8)

LCPI1_17:
 	.long	_.str2-(LPC29+8)

LCPI1_18:
 	.long	3222288268

LCPI1_19:
 	.long	_.str10-(LPC32+8)

LCPI1_20:
 	.long	_.str3-(LPC33+8)

LCPI1_21:
 	.long	_.str2-(LPC34+8)

LCPI1_22:
 	.long	L_allocator_len$non_lazy_ptr-(LPC36+8)

LCPI1_23:
 	.long	L_allocator_data$non_lazy_ptr-(LPC37+8)

LCPI1_24:
 	.long	_.str11-(LPC39+8)

LCPI1_25:
 	.long	_.str3-(LPC40+8)

LCPI1_26:
 	.long	_.str2-(LPC41+8)

LCPI1_27:
 	.long	L_allocator_len$non_lazy_ptr-(LPC50+8)

LCPI1_28:
 	.long	L___sF$non_lazy_ptr-(LPC49+8)

LCPI1_29:
 	.long	_.str12-(LPC48+8)

LCPI1_30:
 	.long	_.str13-(LPC46+8)

LCPI1_31:
 	.long	L_allocator_code_len$non_lazy_ptr-(LPC43+8)

LCPI1_32:
 	.long	_.str14-(LPC52+8)

LCPI1_33:
 	.long	_.str3-(LPC53+8)

LCPI1_34:
 	.long	_.str2-(LPC54+8)

LCPI1_35:
 	.long	_.str15-(LPC57+8)

LCPI1_36:
 	.long	_.str3-(LPC58+8)

LCPI1_37:
 	.long	_.str2-(LPC59+8)

LCPI1_38:
 	.long	L___sF$non_lazy_ptr-(LPC62+8)

LCPI1_39:
 	.long	_.str16-(LPC61+8)

	.cstring
_.str:				@ .str
	.asciz	"Loading bootloader image... "

_.str1:				@ .str1
	.asciz	"foo/bootloader-image.tga"

_.str2:				@ .str2
	.asciz	"%s:%u: failed assertion `%s'\n"

_.str3:				@ .str3
	.asciz	"kamaitachi.c"

_.str4:				@ .str4
	.asciz	"(fd = open(PKGDATADIR \"/bootloader-image.tga\", O_RDONLY, 0)) >= 0"

_.str5:				@ .str5
	.asciz	"read(fd, data.img, data.img_size) == data.img_size"

_.str6:				@ .str6
	.asciz	"%d bytes loaded.\n"

_.str7:				@ .str7
	.asciz	"Injecting allocator (stage 1) stub into kernel... "

_.str8:				@ .str8
	.asciz	"/dev/kmem"

_.str9:				@ .str9
	.asciz	"(fd = open(\"/dev/kmem\", O_RDWR, 0)) >= 0"

_.str10:				@ .str10
	.asciz	"lseek(fd, KERNEL_OFFSET, SEEK_SET) == KERNEL_OFFSET"

_.str11:				@ .str11
	.asciz	"write(fd, allocator_data, allocator_len) == allocator_len"

_.str12:				@ .str12
	.asciz	"%d bytes written ok.\n"

_.str13:				@ .str13
	.asciz	"Running allocator... "

_.str14:				@ .str14
	.asciz	"lseek(fd, KERNEL_OFFSET + allocator_code_len, SEEK_SET) == KERNEL_OFFSET + allocator_code_len"

_.str15:				@ .str15
	.asciz	"read(fd, &adata, sizeof(struct allocator_data)) == sizeof(struct allocator_data)"

_.str16:				@ .str16
	.asciz	"%d bytes allocated in kernel space ok.\n"

_.str17:				@ .str17
	.asciz	"Injecting loader (stage 2) stub into kernel... "

_.str18:				@ .str18
	.asciz	"(fd = open(\"/dev/kmem\", O_WRONLY, 0)) >= 0"

_.str19:				@ .str19
	.asciz	"write(fd, loader_data, loader_len) == loader_len"

_.str20:				@ .str20
	.asciz	"Starting bootloader...\n"

.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L___eprintf$stub:
	.indirect_symbol ___eprintf
	ldr ip, L___eprintf$slp
L___eprintf$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L___eprintf$slp:
	.long	L___eprintf$lazy_ptr-(L___eprintf$scv+8)
.lazy_symbol_pointer
L___eprintf$lazy_ptr:
	.indirect_symbol ___eprintf
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_close$stub:
	.indirect_symbol _close
	ldr ip, L_close$slp
L_close$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_close$slp:
	.long	L_close$lazy_ptr-(L_close$scv+8)
.lazy_symbol_pointer
L_close$lazy_ptr:
	.indirect_symbol _close
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_fprintf$stub:
	.indirect_symbol _fprintf
	ldr ip, L_fprintf$slp
L_fprintf$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_fprintf$slp:
	.long	L_fprintf$lazy_ptr-(L_fprintf$scv+8)
.lazy_symbol_pointer
L_fprintf$lazy_ptr:
	.indirect_symbol _fprintf
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_fstat$stub:
	.indirect_symbol _fstat
	ldr ip, L_fstat$slp
L_fstat$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_fstat$slp:
	.long	L_fstat$lazy_ptr-(L_fstat$scv+8)
.lazy_symbol_pointer
L_fstat$lazy_ptr:
	.indirect_symbol _fstat
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_fwrite$stub:
	.indirect_symbol _fwrite
	ldr ip, L_fwrite$slp
L_fwrite$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_fwrite$slp:
	.long	L_fwrite$lazy_ptr-(L_fwrite$scv+8)
.lazy_symbol_pointer
L_fwrite$lazy_ptr:
	.indirect_symbol _fwrite
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_lseek$stub:
	.indirect_symbol _lseek
	ldr ip, L_lseek$slp
L_lseek$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_lseek$slp:
	.long	L_lseek$lazy_ptr-(L_lseek$scv+8)
.lazy_symbol_pointer
L_lseek$lazy_ptr:
	.indirect_symbol _lseek
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_malloc$stub:
	.indirect_symbol _malloc
	ldr ip, L_malloc$slp
L_malloc$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_malloc$slp:
	.long	L_malloc$lazy_ptr-(L_malloc$scv+8)
.lazy_symbol_pointer
L_malloc$lazy_ptr:
	.indirect_symbol _malloc
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_open$stub:
	.indirect_symbol _open
	ldr ip, L_open$slp
L_open$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_open$slp:
	.long	L_open$lazy_ptr-(L_open$scv+8)
.lazy_symbol_pointer
L_open$lazy_ptr:
	.indirect_symbol _open
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_ptrace$stub:
	.indirect_symbol _ptrace
	ldr ip, L_ptrace$slp
L_ptrace$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_ptrace$slp:
	.long	L_ptrace$lazy_ptr-(L_ptrace$scv+8)
.lazy_symbol_pointer
L_ptrace$lazy_ptr:
	.indirect_symbol _ptrace
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_read$stub:
	.indirect_symbol _read
	ldr ip, L_read$slp
L_read$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_read$slp:
	.long	L_read$lazy_ptr-(L_read$scv+8)
.lazy_symbol_pointer
L_read$lazy_ptr:
	.indirect_symbol _read
	.long	dyld_stub_binding_helper
.section __TEXT,__picsymbolstub4,symbol_stubs,none,16
	.align	2
	.code	32
L_write$stub:
	.indirect_symbol _write
	ldr ip, L_write$slp
L_write$scv:
	add ip, pc, ip
	ldr pc, [ip, #0]
L_write$slp:
	.long	L_write$lazy_ptr-(L_write$scv+8)
.lazy_symbol_pointer
L_write$lazy_ptr:
	.indirect_symbol _write
	.long	dyld_stub_binding_helper

.non_lazy_symbol_pointer
L___sF$non_lazy_ptr:
	.indirect_symbol ___sF
	.long	0
L_allocator_code_len$non_lazy_ptr:
	.indirect_symbol _allocator_code_len
	.long	0
L_allocator_data$non_lazy_ptr:
	.indirect_symbol _allocator_data
	.long	0
L_allocator_len$non_lazy_ptr:
	.indirect_symbol _allocator_len
	.long	0
L_boot_data$non_lazy_ptr:
	.indirect_symbol _boot_data
	.long	0
L_boot_len$non_lazy_ptr:
	.indirect_symbol _boot_len
	.long	0
	.subsections_via_symbols

