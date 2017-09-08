[bits 16]

_init:
	mov ax, 0x07c0
	mov ds, ax
	mov ax, 0x07e0
	mov ss, ax
	mov sp, 0xffff
	jmp 0x07c0:_start 
_start:
	mov si, initmsg
	call _print
	mov si, success
	call _print
	mov si, loadmsg
	call _print

	mov ax,0x1000
	mov es,ax
	mov ah, 2
	mov dl, 0
	mov dh, 0
	mov ch, 0
	mov cl, 2
	mov al, 2
	mov bx, 0
	int 0x13

	cmp ah, 0
	jne _load_failure
	je _load_success	

_turn_off_cursor:
	push ax
	push cx
	mov ah, 0x01
	mov cx, 0x2607
	int 0x10
	pop cx
	pop ax
	ret

_load_success:
	mov si, success
	call _print
	mov si, presmsg
	call _print
	call _wait
	
	call _turn_off_cursor
	
	mov ax, 0x1000
	mov ds, ax
	mov es, ax
	mov ax, 0x2000
	mov ss, ax
	mov sp, 0xffff
	jmp 0x1000:0x0
	
_load_failure:
	mov si, error
	call _print
	mov si, errcmsg
	call _print
	add ah, "0"
	mov [errorcd], ah
	mov si, errorcd
	call _print
	jmp _idle

_idle:
	jmp _idle

;Waits for key press
;Input  :
;Output :
_wait:
	push ax

	mov ah, 0x00
	int 0x16

	pop ax
	ret
	

;Prints null-terminated string
;Input  : SI - pointer to string
;Output :
_print:
	push ax
	push bx
	mov ah, 0xe
	mov bh, 0
	mov bl, 0x7
.loop:
	lodsb
	cmp al, 0
	je .exit
	int 0x10
	jmp .loop	
.exit:
	pop bx
	pop ax
	ret

initmsg db "Bootloader init...            ",0
loadmsg db "Loading program from floppy...",0
errcmsg db "Error code is:                ",0
presmsg db "Press any key to continue...  ",0

success db "SUCCESS!",13,10,0
error db "ERROR!",13,10,0

errorcd db 0,13,10,0

times 510-($-$$) db 0
db 0x55
db 0xAA
