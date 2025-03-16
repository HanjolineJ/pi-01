ENTRY(_start)

SECTIONS
{
    . = 0x8000;

    .init : { *(.init) }         /* The .init section from main.s */
    .text : { *(.text*) }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : { *(.bss*) }

    /DISCARD/ : { *(.comment*) }
}
