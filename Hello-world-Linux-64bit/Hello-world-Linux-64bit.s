#! gcc GAS Assembler

# Syntax: gcc + AT&T
# 	- instruction inputs are reversed
#	- '.' dot defines EIP at compile time

# Idea (in GCC C preudocode):
# #include <stdio.h>
# int main()
# {
# 	printf("Hello World");
#		-> fprintf(stdio, "Hello World")
#			-> write(     1      , HelloPtr,              12               )
#			   //    ------------            ------------------------------
#			   //    CONST stdout             len(s) is 11, + len(\n') => 12
#
#				-> #DEFINE HelloPtr = %"Hello World"
#
#	...
# 	return 0;
# }
#

# Set segment
.text # KISS - one segment for everything
_start # _start - reserved name for OEP in gcc

.global _start # _start is a global label - needed for OEP

# Linux Write() arguments,
# Application Binary Interface in Linux - defines registers for syscall(),
mov $1, %rax # "write" syscall identifier. [CONST write = 1]
mov $1, %edi # output device/descriptor. [CONST stdout = 1]
mov $msg, %rsi # Pointer to text message
mov $len, %rdx # Calculated at compile time message length (0x0C)

syscall # akin to INT(0x80)

call exit

# Data
msg:
	.ascii "Hello World\n"
len = . - msg # Calculated at compile time message length (0x0C)

# syscall exit
exit: mov $60, %rdx # syscall 0x60 => exit()
mov $0, %rdi # return code 0
syscall

# not necessary, but this is a good practice for callable functions
ret
