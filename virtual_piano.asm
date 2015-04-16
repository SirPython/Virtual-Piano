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

%define MIDI_CONTROL_PORT 0331h
%define MIDI_DATA_PORT 0330h
%define MIDI_UART_MODE 3Fh
%define MIDI_PIANO_INSTRUMENT 93h

start:
	call setup_midi

.loop:
	call read_character
	call process_input

	cmp bh, 0
	je .loop

	call get_pitch
	call play_note
	
	jmp .loop
;--------------------------------------------------
; Plays a note
;
; IN: AL = pitch
; OUT: NONE
; ERR: NONE
; REG: AL

play_note:
	out dx, al;				DX will already contain MIDI_DATA_PORT from the setup_midi function

	mov al, 7Fh;			note duration
	out dx, al

	ret

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

.a: mov al, 60
	jmp .end
.s: mov al, 62
	jmp .end
.d: mov al, 64
	jmp .end
.f: mov al, 65
	jmp .end
.j: mov al, 67
	jmp .end
.k: mov al, 69
	jmp .end
.l: mov al, 71
	jmp .end
.sc: mov al, 72
	jmp .end

.end:
	ret

;--------------------------------------------------
; Set's up the MIDI ports for use
;
; IN: NONE
; OUT: NONE
; ERR: NONE
; REG: DX

setup_midi:
	push al

	mov dx, MIDI_CONTROL_PORT
	mov al, MIDI_UART_MODE;	play notes as soon as they are recieved
	out dx, al

	mov dx, MIDI_DATA_PORT
	mov al, MIDI_PIANO_INSTRUMENT
	out dx, al

	pop al
	ret

;--------------------------------------------------
; Checks to make sure that input was on the homerow
;
; IN: AH, AL = scan code, key code
; OUT: BH = 1 (on the homerow) or 0 (not on the homerow)
; ERR: NONE
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
