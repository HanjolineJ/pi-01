    /* 
     * main.s - Bare-metal LED blink for Raspberry Pi 
     *
     * Adjust the GPIO_BASE constant below as follows:
     *   Raspberry Pi 1:  GPIO_BASE = 0x20200000
     *   Raspberry Pi 3:  GPIO_BASE = 0x3F200000
     *   Raspberry Pi 4:  GPIO_BASE = 0xFE200000
     */
    .equ GPIO_BASE, 0xFE200000  @ Change this value if using a different Pi model

    .section .init
    .globl _start
_start:
    // --- Configure GPIO16 as an output ---
    // GPIO16 is controlled via GPFSEL1. Each pin gets 3 bits.
    // For GPIO16, the field starts at bit 18.
    ldr r0, =GPIO_BASE        @ r0 = GPIO base address

    // Read current GPFSEL1 (offset 4 bytes)
    ldr r2, [r0, #4]         @ r2 = GPFSEL1

    // Clear bits 18-20 for GPIO16.
    mov r3, #7              @ r3 = 0b111
    lsl r3, r3, #18         @ r3 = mask for GPIO16 bits (0b111 << 18)
    mvn r3, r3              @ invert mask: ones everywhere except bits 18-20
    and r2, r2, r3          @ clear GPIO16 bits in r2

    // Set GPIO16 to output mode by writing 001 to bits 18-20.
    mov r3, #1
    lsl r3, r3, #18         @ r3 = 1 << 18
    orr r2, r2, r3          @ set output mode for GPIO16
    str r2, [r0, #4]        @ write back to GPFSEL1

blink:
    // --- Turn LED ON (active-low) ---
    // For the original Pi, the ACT LED is wired to GPIO16 and is active low.
    mov r1, #1
    lsl r1, r1, #16         @ Bit position for GPIO16
    str r1, [r0, #40]       @ Write to GPCLR0 (offset 40 decimal) to clear the pin (LED on)

    bl delay                @ Wait

    // --- Turn LED OFF ---
    mov r1, #1
    lsl r1, r1, #16         @ Bit for GPIO16
    str r1, [r0, #28]       @ Write to GPSET0 (offset 28 decimal) to set the pin (LED off)

    bl delay                @ Wait

    b blink                 @ Loop forever

delay:
    // A busy-wait loop for delay – adjust the count for longer/shorter blink rate.
    mov r2, #0x00FFFFFF
delay_loop:
    subs r2, r2, #1
    bne delay_loop
    bx lr
