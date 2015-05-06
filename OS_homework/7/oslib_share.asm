[bits 16]
extern main		;forbid run this file any time
jmp main


global screen_init,input_char,printToscn
global get_pointer_pos,screen_init2

input_char:
	mov ah,0x00; listen keyboard  return value is save in ax	
	int 16h	
ret

screen_init:               ;make all screen write
	push ax
	push bx
	push cx
	mov ax,0xb800
	mov es,ax
	mov ax,00
	mov cx,3999
	mov bx,00

	loop:
	mov byte [es:bx],' '
	inc bx
	mov byte [es:bx],78D;font color
	inc bx
	cmp bx,cx
	jle loop	;<=

	pop cx
	pop bx
	pop ax
ret

printToscn:			;显示输入的sequence
	mov ax,ds
	mov es,ax

	mov ah,0x0e
	mov bl,0x0e
	mov cx,bp	;cx is temp  bp don't change
	mov bp,sp		; this step is very important
	mov al,[bp+4]
	mov bp,cx	;cx is temp
	mov cx,1
	int 10h
ret 

get_pointer_pos:
	
	mov ah,0x03 ;功能号
	mov bh,0x00
	int 10h
	mov ax,dx ;return row:col
ret 

