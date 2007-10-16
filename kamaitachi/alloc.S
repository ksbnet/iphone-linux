#define ALLOCATOR_DATA_PHYS 8

    .text
allocator:
    .long 0x00004778    @ (Thumb) bx pc: switches to ARM mode

    stmfd sp!,{r4-lr}

    @ Compute the start of the allocator bss, store in r4.
    ldr r4,allocator_bss_dist
allocator_bss_pcrel:
    add r4,r4,pc
        
    ldr r0,total_size
    mov r1,#4                       @ alignment
    add r2,r4,#ALLOCATOR_DATA_PHYS  @ pointer to physical mem addr
    ldr r3,L_IOMallocContiguous
    blx r3
    str r0,allocated_data

    ldmia sp!,{r4-lr}
    bx lr

    @ Darwin kernel functions
L_IOMallocContiguous:
    .long 0xc012d9e5

    @ Constant data
allocator_bss_dist:
    .long (allocator_bss - allocator_bss_pcrel - 8)

    @ Modifiable data
allocator_bss:
allocator_code_end:
total_size:
    .long 0             
allocated_data:
    .long 0
allocated_data_phys:
    .long 0

allocator_end:
    nop

@ -----------------------------------------------------------------------------

    .globl _allocator_data
    .data
_allocator_data:
    .long allocator

    .globl _allocator_code_len
    .data
_allocator_code_len:
    .long (allocator_code_end - allocator)

    .globl _allocator_len
    .data
_allocator_len:
    .long (allocator_end - allocator)

    .subsections_via_symbols

