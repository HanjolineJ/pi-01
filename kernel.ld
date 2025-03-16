ENTRY(_start)

SECTIONS
{
    . = 0x8000;            /* Kernel loads at 0x8000 in older Pi boards */

    .init : { *(.init) }
    .text : { *(.text*) }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : { *(.bss*) }
}
