NAME=virtual_piano
ASM=nasm
ASMFLAGS=-o $(NAME).com

DIR=$(shell pwd)

DB=dosbox
DBFLAGS=-c "mount c $(DIR)" -c "C:" -c "VIRTUA~2.COM"

all:
	$(ASM) $(NAME).asm $(ASMFLAGS)

run:
	$(DB) $(DBFLAGS)

clean:
	rm *.com
