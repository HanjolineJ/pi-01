.section .init
.globl _start
_start:
    // 1) Load GPIO base address into r0
    ldr r0, =0x3F200000   @ <-- Use 0x3F200000 for Pi 3, or 0x20200000 for Pi 1

    // 2) Set GPIO16 to be an output
    mov r1, #1            @ r1 = 1
    lsl r1, #18           @ shift left by 18 to target pin 16
    str r1, [r0, #4]      @ store into GPFSEL1 (offset 0x4)

    // 3) Turn pin 16 "LOW", which lights up the LED
    //    (on most Pi boards, the ACT LED is active-low)
    mov r1, #1
    lsl r1, #16           @ 1 << 16 -> target pin 16
    str r1, [r0, #40]     @ store into GPCLR0 (offset 0x28 in hex is 40 decimal)

    // 4) Infinite loop
loop$:
    b loop$
ldr r0, =0x20200000

ldr r0, =0x3F200000
