;org 0x7c00		;
org 0x1000		;加

mov ax,key_detect
mov [ addr_de],ax
;call setting_09_vector


;LISTEN_EXIT----
;sti
listen:
mov ah,0
int 16h
	mov bl,0
	mov bh,[j]
	cmp bl,bh
	je change11
	
	mov bh,0
	mov [j],bh
	mov byte [es:00],'O'
	mov byte [es:02],'U'
	mov byte [es:04],'C'
	mov byte [es:06],'H'

	jmp next_de1

	change11:
	mov bh,1
	mov [j],bh

	mov byte [es:00],' '
	mov byte [es:02],' '
	mov byte [es:04],' '
	mov byte [es:06],' '

	next_de1:
mov ah,13D
cmp al,ah


jne listen


ret

over:
	cli
	mov ax,0
	mov es,ax
	mov ax, cs
	mov ds, ax
	mov ecx,[ duan_1]
	mov [ es:36],ecx

	sti

	mov ax,0xb800
	mov es,ax
	mov byte [ es:08],'x'

ret


key_detect:
	mov ax,0xb800
	mov es,ax

	in al,60h
	in al,61h
	or al,80h
	out 61h,al
	mov al,61h
	out 20h,al

	mov bl,0
	mov bh,[j]
	cmp bl,bh
	je change1
	
	mov bh,0
	mov [j],bh
	mov byte [es:00],'O'
	mov byte [es:02],'U'
	mov byte [es:04],'C'
	mov byte [es:06],'H'

	jmp next_de

	change1:
	mov bh,1
	mov [j],bh

	mov byte [es:00],' '
	mov byte [es:02],' '
	mov byte [es:04],' '
	mov byte [es:06],' '


	next_de:

	mov bl,[i]
	inc bl
	mov [i],bl
	mov bh,5
	cmp bh,bl
	je closesti
	jmp niret
	closesti:
		cli
		call over
	niret:

iret



setting_09_vector:
	mov ax,0
	mov es,ax
	mov bx,9
	shl bx,2 ;interrupt num * 4 = entry
	mov ax,cs
	mov ds,ax
	shl eax,8  ;shl 8 bit   *16
	mov ax,[ addr_de]

	mov ecx,[ es:36]			;backup
	mov [ duan_1],ecx


	mov [ es:bx], eax		;work!
	

	;mov ecx,[ duan_1]
	;mov [ es:36],ecx
ret

delay:
	mov dx,00
	timer2:	
		mov cx,00
		timer:
			inc cx
			cmp cx,1000D
		jne timer
		inc dx
		cmp dx,10000D
	jne timer2

ret

screen_init:               ;make all screen write
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

ret


i db 0
j db 0
addr_de dw 0
duan_1 dw 0


times 512-($-$$) db 0



