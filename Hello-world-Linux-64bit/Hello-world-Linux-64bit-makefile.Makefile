all: Hello-world-Linux-64bit.s
	gcc -c Hello-world-Linux-64bit.s # Compiler
	ld Hello-world-Linux-64bit.o # Linker
