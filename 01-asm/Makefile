all: part1 part2

clean:
	rm part1 part2

part1: part1.asm
	yasm -f elf64 -g dwarf2 part1.asm
	ld -m elf_x86_64 -o part1 part1.o

part2: part2.asm
	yasm -f elf64 -g dwarf2 part2.asm
	ld -m elf_x86_64 -o part2 part2.o

hello: hello.asm
	yasm -f elf64 -g dwarf2 hello.asm
	ld -m elf_x86_64 -o hello hello.o