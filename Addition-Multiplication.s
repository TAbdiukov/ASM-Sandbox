#! gcc GAS Assembler

# Platform: amd64
# Syntax: gcc + AT&T
# 	- instruction inputs are reversed
#	- '.' dot defines EIP at compile time

# INPUTS:
# rax, rbx
# (Recommended) rax > rbx
# (Required) rax >= 0, rbx >= 0
# USES:
# rcx - eax before multiplication
# OUTPUTS:
# rax = rax * rbx

# IMPLEMENTATION:
# Like the following Python code,
# ```
# for i in range(rbx):
# 	rcx += rax
# return rax
# ```

# Solution

push %rcx # Backup register rcx

xor %rcx, %rcx # mov $0, rcx

loop: test %rbx, %rbx # while(rbx)
jz ret

math: add %rax, %rcx # add rax once
dec %rbx # decrement from %rbx
jmp loop

ret: mov %rcx, %rax # overwrite rax
pop %rcx # restore rcx
ret

