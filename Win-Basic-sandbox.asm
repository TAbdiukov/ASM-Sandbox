;!FASM

format mz

start: 
	mov ax, cs ; set Code Segment
	mov ds, ax ; the same as Data Segment (break DEP)

custom_code_here:
