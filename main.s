.section .init
.globl _start
_start:

    ldr r0, =0x20200000          @ Put GPIO base address in r0

    mov r1, #1                   @ r1 = 1
    lsl r1, #18                  @ shift left by 18 -> sets GPIO pin 16 to output
    str r1, [r0, #4]             @ write to GPFSEL1

loop$:
    @ Turn LED ON (actually pulling GPIO pin 16 low)
    mov r1, #1
    lsl r1, #16                  @ shift left 16 means bit 16 is '1'
    str r1, [r0, #40]            @ GPCLR0 -> turn LED ON

    @ Delay loop
    bl delay

    @ Turn LED OFF (driving GPIO pin 16 high)
    mov r1, #1
    lsl r1, #16
    str r1, [r0, #28]            @ GPSET0 -> turn LED OFF

    @ Delay loop
    bl delay

    b loop$                      @ repeat forever


@-------------------------------------------------------------------------
@ delay subroutine: just busy-waits a certain amount so we can see the blink
@-------------------------------------------------------------------------
delay:
    mov r2, #0x400000     @ arbitrary large number to create visible delay
delay_loop$:
    subs r2, r2, #1       @ subtract 1 from r2, update flags
    bne delay_loop$       @ branch if not zero
    bx lr                 @ return from subroutine
