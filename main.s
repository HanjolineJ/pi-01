.section .init
.globl _start
_start:

    /* Set GPIO16 as output:
       - The GPIO registers for the Pi 1 start at 0x20200000.
       - GPIO 16 is controlled by GPFSEL1 (which covers GPIO10–GPIO19).
       - Bits for GPIO16 are bits 18-20: clear them then set to 001 (output). */
    LDR   r0, =0x20200004       @ Address of GPFSEL1
    LDR   r1, [r0]              @ Load current value
    BIC   r1, r1, #(7 << 18)    @ Clear bits 18-20 (for GPIO16)
    ORR   r1, r1, #(1 << 18)    @ Set bit 18 to 1 (001 = output)
    STR   r1, [r0]              @ Store back to GPFSEL1

    /* Turn on GPIO16:
       - GPSET0 (at 0x2020001C) sets the corresponding GPIO pin.
       - Writing a 1 in bit 16 turns the LED (green ACT LED) on. */
    LDR   r0, =0x2020001C       @ Address of GPSET0
    MOV   r1, #(1 << 16)        @ Create a mask for GPIO16
    STR   r1, [r0]              @ Set GPIO16 high (turns the LED on)


    @ GPIO base address for Pi 1 (BCM2835)
    ldr r0, =0x20200000

    @ Configure GPIO16 as an output
    mov r1, #1          @ r1 = 1
    lsl r1, #18         @ shift left by 18 => bit position for GPIO16 in GPFSEL1
    str r1, [r0, #4]    @ write to GPFSEL1 (offset 4 bytes)

    @ Clear (pull low) GPIO16 to turn the ACT LED ON (it is active-low)
    mov r1, #1
    lsl r1, #16         @ shift left by 16 => bit for GPIO16
    str r1, [r0, #40]   @ write to GPCLR0 (offset 0x28 = 40 decimal)

    @ Infinite loop so the CPU doesn't crash or run past our code
loop$:
    b loop$

