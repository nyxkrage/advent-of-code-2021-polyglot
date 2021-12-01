all: hello

clean:
	rm hello

hello: hello.asm
	yasm -f elf64 -g dwarf2 hello.asm
	ld -m elf_x86_64 -o hello hello.o