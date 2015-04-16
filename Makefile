NAME=virtual_piano
ASM=nasm
ASMFLAGS=-o $(NAME).com

all:
	$(ASM) $(NAME).asm $(ASMFLAGS)

clean:
	rm *.com
