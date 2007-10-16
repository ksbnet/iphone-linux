@ This code is what gets injected directly into the kernel. It is deliberately
@ kept as small as possible to avoid trashing kernel memory: since this gets
@ copied over ptrace(), we don't want it to overflow the space that ptrace()
@ occupies.

    .macro ret
        ldmia sp!,{r4-lr}
        bx lr
    .endmacro

@ -----------------------------------------------------------------------------

    @ Start of function that will overwrite ptrace() in the kernel. r2 contains
    @ the bootloader_data structure.
    .text
loader:
    .long 0x00004778    @ (Thumb) bx pc: switches to ARM mode
  
    stmfd sp!,{r4-lr}
    add r0,pc,#4        @ grab the address of the bootloader data
    ldr r1,[r0,#4]      @ code addr
    bx r1               @ call the bootloader with bootloader data addr in r0

    @ Bootloader data, matches struct bootloader_data
loader_code_end:
    .long 0             @ physical addr of the code
    .long 0             @ code
    .long 0             @ code len
    .long 0             @ img
    .long 0             @ img len
    .long 0             @ kernel
    .long 0             @ kernel len
    .long 0             @ ramdisk
    .long 0             @ ramdisk len
    .long 0             @ boot args
    .long 0             @ boot args len

loader_end:
    nop 

@ -----------------------------------------------------------------------------

    .globl _loader_data
    .data
_loader_data:
    .long loader

    .globl _loader_code_len
    .data
_loader_code_len:
    .long (loader_code_end - loader)

    .globl _loader_len
    .data
_loader_len:
    .long (loader_end - loader)

    .subsections_via_symbols

