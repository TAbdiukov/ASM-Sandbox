all: hello-world.s
	gcc -c hello-world.s # Compiler
	ld hello-world.o # Linker
