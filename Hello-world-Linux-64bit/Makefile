all: Hello-world-Linux-64bit.s
	gcc -c Hello-world-Linux-64bit.s # Compiler
	ld Hello-world-Linux-64bit.o # Linker

# Based on: https://github.com/t-crest/patmos/blob/master/wcet/Makefile
clean:
	- rm *.out
	- rm *~
	- rm *.o
