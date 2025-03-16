CROSS_COMPILER = arm-none-eabi
CC = $(CROSS_COMPILER)-gcc
LD = $(CROSS_COMPILER)-ld
OBJCOPY = $(CROSS_COMPILER)-objcopy

CFLAGS = -nostdlib -nostartfiles -ffreestanding -O2 -Wall
LDFLAGS = -T kernel.ld

all: kernel.img

kernel.img: main.o
	$(LD) $(LDFLAGS) main.o -o kernel.elf
	$(OBJCOPY) kernel.elf -O binary kernel.img

main.o: main.s
	$(CC) $(CFLAGS) -c main.s -o main.o

clean:
	rm -f *.o *.elf *.img
