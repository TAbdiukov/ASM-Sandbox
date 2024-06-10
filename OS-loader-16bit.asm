;!YASM
; Compat: pre-MMX onwards (e.g. 8086)

section .text ; KISS
use16
org 0x7c00 ; OEP is at 0x7c00

start: 
	mov ax, cs ; set Code Segment
	mov ds, ax ; the same as Data Segment (break DEP)

	mov si, msg ; message to be shown
	cld ; ia-32 clear Direction flag (Delphi guidelines for assembler code)


; jmp puts_loop

pre_puts: ; prepare before puts()
	mov ah, 0x0e ; AH=0Eh -> Teletype output
	xor bh, bh ; mov bh, 0; Page number = 0 


puts_loop: 
	lodsb ; Like C + Python: `for c in *si: yield c` (into al)
	test al, al ; is al Truthy, i.e. like in Python/Java `if(al): {}`
	jz interactive_fgets ; if not Truthy, exit loop to the next thing
	int 10h ; interrupt vector 10h, AH=0Eh -> Teletype output
	jmp puts_loop

; jmp interactive_fgets

interactive_fgets: ; loops forever
	xor ah, ah ; mov ah, 0
	int 16h ; interrupt vector 16h, ah=0 -> Read key press. Return: AH[1] = Scan code of the key pressed down	AL = ASCII character of the button pressed
	cmp ah, 0x0e ; http://www.quadibloc.com/comp/scan.htm - is Backspace pressed?
	jz interactive_fgets_backspace ; then go to a corresponding logic
interactive_fgets_backspace_after:
	mov ah, 0x0e ; sanity check, this temporary information should change during a next key press
	xor bh, bh ; mov bh, 0; Page number = 0
	int 10h ; interrupt vector 10h, AH=0Eh -> Teletype output

interactive_fgets_backspace: 
mov al, 8 ; ASCII character of "Backspace" - remove character (supported by x86 BIOS)
jmp interactive_fgets_backspace_after

section .data
msg db 'OS Startup message... ', 0

; Usage
; 1. Compile in YASM into a .bin file
; 2. In UltraISO, utilize .bin file as startup boot, same as .iso file
; 3. Use VirtualBox/VMWare in some basic Windows mode
; 4. Attach .iso file to the VM Instance
