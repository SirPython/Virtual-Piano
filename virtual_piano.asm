; Concerns:
; - those crazy 'switch' statements
; - register use
;===============================================================================
; Virtual Piano -- a virtual and playable piano
; By SirPython of Code Review and GitHub
;
; virtual_piano.asm
;===============================================================================
jmp start

%define PAGEUP 49h
%define PAGEDOWN 51h
%define ESC 1Bh

start:
	jmp start

;--------------------------------------------------
; Based on input, returns a pitch to be played
;
; IN: AH, AL = scan code, key code
; OUT: AL = pitch
; ERR: NONE
; REG: preserved

get_pitch:
	cmp al, 'a'
	je .a
	cmp al, 's'
	je .s
	cmp al, 'd'
	je .d
	cmp al, 'f'
	je .f
	cmp al, 'j'
	je .j
	cmp al, 'k'
	je .k
	cmp al, 'l'
	je .l
	cmp al, ';'
	je .sc

.a: sub al, 37
	jmp .end
.s:
	jmp .end
.d:
	jmp .end
.f:
	jmp .end
.j:
.k:
.l:
.sc:

;--------------------------------------------------
; Checks to make sure that input was on the homerow
;
; IN: AH, AL = scan code, key code
; OUT: BH = 1
; ERR: Invalid input (was not on homerow): BH = 0
; REG: preserved

process_input:

.check_key_code:
	cmp al, 'a'
	je .safe
	cmp al, 's'
	je .safe
	cmp al, 'd'
	je .safe
	cmp al, 'f'
	je .safe
	cmp al, 'j'
	je .safe
	cmp al, 'k'
	je .safe
	cmp al, 'l'
	je .safe
	cmp al, ';'
	je .safe

.check_scan_code:
	cmp ah, PAGEUP
	je .safe
	cmp ah, PAGEDOWN
	je .safe

.is_exit:
	cmp al, ESC
	call exit

.err:
	xor al, al
	ret

.safe:
	mov al, 0

;--------------------------------------------------
; Stops execution of the program
;
; IN: NONE
; OUT: NONE
; ERR: NONE
; REG: NONE

exit:
	hlt
	ret

;--------------------------------------------------
; Reads a single character from the user
;
; IN: NONE
; OUT: AH, AL = scan code, key code
; ERR: NONE
; REG: preserved

read_character:
	xor ah, ah
	int 16h;				BIOS 16h 00h
	ret
