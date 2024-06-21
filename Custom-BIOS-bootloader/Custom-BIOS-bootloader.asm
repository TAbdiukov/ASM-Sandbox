;!FASM
; Compat: pre-MMX onwards (e.g. 8086)

section .text ; KISS
use16
bits 16
org 0x7C00 ; EP is at 0x7C00

jmp start

amsg db 'My custom BIOS bootloader...!', 13, 10, 0 ; 'TEXT\r\n\'

start: 
	mov ax, cs ; set Code Segment
	mov ds, ax ; the same as Data Segment (break DEP)

pre_puts: ; prepare before puts()
	mov si,	amsg ; message to be shown
	sub si, 0x7C00 ; Do not use EP offset.
	cld ; ia-32 clear Direction flag (Delphi guidelines for assembler code)
	mov ah, 0x0e ; AH=0Eh -> Teletype output
	xor bh, bh ; mov bh, 0; Page number = 0 

puts_loop: 
	lodsb ; Like C + Python: `for c in *si: yield c` (into al)
	test al,al ; is al Truthy, i.e. like in Python/Java `if(al): {}`; TEST is shorter than CMP.
	jz puts_loop_out ; if not Truthy, exit loop to the next thing
	int 10h ; interrupt vector 10h, AH=0Eh -> Teletype output
	jmp puts_loop

puts_loop_out: jmp interactive_fgets

interactive_fgets: ; loops forever
	xor ah, ah ; mov ah, 0
	int 16h ; interrupt vector 16h, ah=0 -> Read key press. Return: AH[1] = Scan code of the key pressed down	AL = ASCII character of the button pressed
	cmp ah, 0x0e ; http://www.quadibloc.com/comp/scan.htm - is Backspace pressed?
	jz interactive_fgets_backspace ; then go to a corresponding logic
interactive_fgets_backspace_after:
	mov ah, 0x0e ; sanity check, this temporary information should change during a next key press
	xor bh, bh ; mov bh, 0; Page number = 0
	int 10h ; interrupt vector 10h, AH=0Eh -> Teletype output
	jmp interactive_fgets ; jump back

interactive_fgets_backspace: 
mov al, 8 ; ASCII character of "Backspace" - remove character (supported by x86 BIOS)
jmp interactive_fgets_backspace_after

; Usage
; 1. Compile in YASM into a .bin/.ldr file (add extension if needed)
; 2. In UltraISO, select .bin/ldr file and "Set Boot File", then save as .iso file
; 3. Use VirtualBox/VMWare in some basic Windows mode
; 4. Attach .iso file to the VM Instance
