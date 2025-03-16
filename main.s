.section .init
.globl _start
_start:

    ldr r0, =0x20200000          @ Put GPIO base address in r0

    mov r1, #1                   @ r1 = 1
    lsl r1, #18                  @ shift left 18 -> sets GPIO pin 16 to output
    str r1, [r0, #4]             @ write to GPFSEL1

    mov r1, #1
    lsl r1, #16                  @ 1 << 16
    str r1, [r0, #40]            @ GPCLR0 -> actually turns the LED ON

loop$:
    b loop$
