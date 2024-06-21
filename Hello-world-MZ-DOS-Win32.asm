;!FASM

; format binary
format mz

jmp start

msg: db "Hello world!$"

start:
        mov ax, cs ; set Code Segment
        mov ds, ax ; the same as Data Segment (break DEP)

echo:
        mov ah, 09h
        mov dx, msg
        int 21h

exit:
        mov ax, 4c00h
        int 21h
