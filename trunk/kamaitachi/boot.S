@ This code contains the Linux bootloader. It is called by the loader stub in
@ load.S, which is injected into the Darwin kernel. This code is divided into
@ two parts: the first part (stage 2) lives in the Darwin kernel, while the
@ second part (stage 3) is on its own, without the VM subsystem or any other
@ part of Darwin. The (rather delicate) transition occurs when the MMU is
@ switched off.

#define ATAG_NONE       0x00000000
#define ATAG_CORE       0x54410001
#define ATAG_MEM        0x54410002
#define ATAG_VIDEOLFB   0x54410008

    .macro ret
        ldmia sp!,{r4-lr}
        bx lr
    .endmacro

    @ Start of the bootloader function. This must be called with r0 pointing to
    @ a fully filled struct bootloader_data in kernel space, with all fields
    @ initialized to point to kernel space locations.
    .text
boot:

    @ Calculate physical addresses.
    str r0,bootloader_data_vaddr    @ r0 = virt addr of start of bootldr data
    ldr r1,[r0,#0]              @ r1 = physical addr of this code
    ldr lr,stage3_dist          @ lr = distance from this code to stage3
    add lr,lr,r1                @ lr = physical addr of this code
    str lr,bootloader_code_paddr
    ldr r2,[r0,#8]              @ r2 = size of this code
    add r2,r1,r2                @ r2 = physical addr of boot image
    str r2,bootloader_img_paddr
    ldr r2,linux_tags_dist
    add r2,r2,r1                @ r2 = physical addr of linux tags
    str r2,linux_tags_paddr
    ldr r2,[r0,#8]              @ r2 = size of this code
    ldr r3,[r0,#16]             @ r3 = size of the boot image
    add r2,r2,r3                @ r2 = dist from top of code to kernel
    add r2,r1,r2                @ r2 = physical addr of kernel
    str r2,kernel_paddr

    @ Save some values we'll need.
    ldr r2,[r0,#24]             @ r2 = kernel size
    str r2,kernel_size

    @ Disable address translation and interrupts. This part of code is from
    @ Linux: arch/arm/kernel/relocate_kernel.S.
    mov r5,#0x00d3
    msr cpsr_c,r5               @ SEI
    mrc p15,0,r5,cr1,cr0,0  
    bic r5,r5,#0x0086
    bic r5,r5,#0x1900
    mcr p15,0,r5,cr1,cr0,0
    mcr p15,0,r5,cr7,cr7,0
    bic r5,r5,#0x0001
    mcr p15,0,r5,cr1,cr0,0  @ turn off the MMU

    @ CAUTION: MMU is off! We depend on the next two instructions being in the
    @ pipeline to survive.
    mcr p15,0,r5,cr8,cr7,0
    mov pc,lr

    @ At this point Darwin is gone and the MMU is switched off. All addresses
    @ must be physical from here on out.
stage3: 
    nop
    nop
    nop

    @ Put a pretty 32x32 24-bit TGA format image on the framebuffer.
    mov r1,#0                           @ r1 = row
    mov r2,#(32*32*3)                   @ r2 = size of image in bytes
    ldr r3,framebuffer_addr_imgstart    @ r3 = framebuffer addr
    ldr r4,bootloader_img_paddr         @ r4 = image addr
    add r4,r4,#18                       @ skip the TGA header
    add r4,r4,#(32*3*31)                @ go to the last row of the image
    
framebuffer_copy_loop:
    mov r5,#0                           @ r5 = col
framebuffer_row_copy_loop:
    ldrb r6,[r4,#0]                     @ B color
    strb r6,[r3,#0]
    ldrb r6,[r4,#1]                     @ G
    strb r6,[r3,#1]
    ldrb r6,[r4,#2]                     @ R
    strb r6,[r3,#2]
    mov r6,#0xff                        @ Alpha
    strb r6,[r3,#3]
    add r3,r3,#4
    
#if 0
    and r0,r6,#0xf8                     @ r0 = top 5 bits of r6 
    ldrb r6,[r4,#1]                     @ G color
    orr r0,r0,r6,lsr #5                 @ put top 3 bits of G in r0
    mov r7,#0xff
    and r7,r7,r6,lsl #5                 @ put bits [3,6] of G in r7
    orr r0,r0,r7,lsl #8                 @ put that in r0
    ldrb r6,[r4,#2]                     @ B color
    mov r6,r6,lsr #3                    @ get top 5 bits of B
    orr r0,r0,r5,lsl #8                 @ put it in r0
    strh r0,[r3,#0]                     @ store in framebuffer
    add r3,r3,#2                        @ inc framebuffer ptr
#endif

    add r4,r4,#3                        @ inc file ptr
    add r5,r5,#1
    cmp r5,#32
    blt framebuffer_row_copy_loop
    add r3,r3,#(0x500 - (32 * 4))       @ move framebuffer ptr to next row
    sub r4,r4,#(32 * 3 * 2)             @ go back 2 rows in the image
    add r1,r1,#1
    cmp r1,#32
    blt framebuffer_copy_loop

    @ Copy the Linux tags into the start of physical RAM + 0x100, as per the
    @ standard convention.
    ldr r0,phys_mem_start
    add r0,r0,#0x100                    @ r0 = dest ptr
    ldr r1,linux_tags_paddr             @ r1 = src ptr
    ldr r2,linux_tags_len               @ r2 = len
linux_tags_copy_loop:
    ldr r3,[r1,#0]
    str r3,[r0,#0]
    add r0,r0,#4
    add r1,r1,#4
    sub r2,r2,#4
    cmp r2,#0
    bne linux_tags_copy_loop

    @ Copy the kernel into the start of physical RAM + 0x8000, again per the
    @ standard convention.
    ldr r0,phys_mem_start
    add r0,r0,#0x8000                   @ r0 = dest ptr
    ldr r1,kernel_paddr                 @ r1 = src ptr
    ldr r2,kernel_size                  @ r2 = len
linux_kernel_copy_loop:
    ldrb r3,[r1,#0]
    strb r3,[r0,#0]
    add r0,r0,#1
    add r1,r1,#1
    sub r2,r2,#1
    cmp r2,#0
    bne linux_kernel_copy_loop

    @ Start the Linux kernel.
start_linux:
    ldr lr,phys_mem_start
    add lr,lr,#0x8000
    mov r0,#0                           @ arg 0 must be 0
    ldr r1,iphone_machine_type          @ arg 1 must be the machine type
                                        @ (the iPhone is 1506)
    ldr r2,phys_mem_start
    add r2,r2,#0x100                    @ arg 2 must be the phys addr of tags

    bx lr                               @ Hand off control to Linux.

@ -----------------------------------------------------------------------------

    @ Halt. (Shouldn't get here ordinarily.)
spinlock:
    nop
    b spinlock

fbaddr:
    .long 0x0fe00000
    @ .long 0x00000000
fbaddr_stop:
    .long 0x0fe02000
    @ .long 0xf0000000

 

@ -----------------------------------------------------------------------------
@   General data
@ -----------------------------------------------------------------------------

bootloader_data_vaddr:
    .long 0
bootloader_code_paddr:
    .long 0
stage3_dist:
    .long (stage3 - boot)
framebuffer_addr:
    .long 0x0fe00000
framebuffer_addr_imgstart:
    .long (0x0fe00000 + (0x500 * (240 - 16)) + (4 * (160 - 16)))
bootloader_img_paddr:
    .long 0
linux_tags_dist:
    .long (linux_tags - boot)
linux_tags_paddr:
    .long 0
phys_mem_start:
    .long 0x08000000
linux_tags_len:
    .long (linux_tags_end - linux_tags)
kernel_paddr:
    .long 0
kernel_size:
    .long 0
iphone_machine_type:
    .long 1506

@ -----------------------------------------------------------------------------
@   Linux kernel info tags
@ -----------------------------------------------------------------------------

linux_tags:
    .long ATAG_CORE     @ header
    .long 5             @ size
    .long 0             @ flags
    .long 4096          @ pagesize
    .long 0             @ root default (overridden)

    .long ATAG_MEM      @ header
    .long 4             @ size
    .long 0x07400000    @ size (in atag_mem)
    .long 0x08000000    @ start

    .long ATAG_VIDEOLFB
    .long 8
    .short 320          @ width
    .short 240          @ height
    .short 32           @ depth
    .short 0x500        @ linelength
    .long 0x0fe00000    @ lfb_base
    .long 0x0fe64000    @ lfb_size
    .byte 8             @ red_size
    .byte 16            @ red_pos
    .byte 8             @ green_size
    .byte 8             @ green_pos
    .byte 8             @ blue_size
    .byte 0             @ blue_pos
    .byte 8             @ rsvd_size
    .byte 24            @ rsvd_pos

    .long ATAG_NONE     @ header
    .long 2             @ size
linux_tags_end:
    nop

boot_end:
    nop

@ -----------------------------------------------------------------------------

    .globl _boot_data
    .data
_boot_data:
    .long boot

    .globl _boot_len
    .data
_boot_len:
    .long (boot_end - boot) 

    .subsections_via_symbols

