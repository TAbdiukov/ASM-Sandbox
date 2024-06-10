;!FASM

; format binary
format mz

msg: db "Hello world$"

jmp start

start: 
	mov ax, cs ; set Code Segment
	mov ds, ax ; the same as Data Segment (break DEP)

pre_echo: 
	mov ax, 4c00h
	mov dx, msg
	
do_echo: int 21h

do_exit: int 20h

