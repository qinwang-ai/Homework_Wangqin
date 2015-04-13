org 0x7c00		;

	mov ax,0x1c
	mov [ interrupt_num], ax
	mov ax, print_corner
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

	
	mov ecx,[ es:36]			;backup
	mov [ duan_1],ecx
	mov ecx,[ es:38]			;backup
	mov [ offset_1],ecx

	mov ax,0x09
	mov [ interrupt_num], ax
	mov ax, key_detect
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

	
;LISTEN_EXIT----
listen:
	push ax
	mov al,[ flag]
	mov ah,0
	cmp al,ah
	pop ax
je listen

		mov ax,0xb800
		mov es,ax
		mov byte [es:16],'@'

	mov ax,0
	mov es,ax
	mov ecx,[ duan_1]
	mov [es:36],ecx

	mov ecx,[ offset_1]
	mov [es:38],ecx


int16listen:
	mov ax,0xb800
	mov es,ax
	mov ah,0
	int 16h
	mov [es:16],al

jmp int16listen


jmp $

print_corner:
					; \ / [
		mov ax,cs
		mov ds,ax
		mov ax,0xb800
		mov es,ax

		mov dl,30
		mov al,[ pointer]		; alert:  must be al  dont ax
		cmp al,dl
		jne next_print_c
		mov byte [ pointer], 0
		jmp cotinue_corner

		next_print_c:
		mov eax, cornerstring
		mov ebx,0
		mov bl,[ pointer]			;ebx is added sum
		add eax,ebx
		mov al,[ eax]

		inc ebx
		mov [ pointer],bl

		mov bx,3998D
		mov [ es:bx],al

		cotinue_corner:
iret

delay:
	mov dx,00
	timer2:	
		mov cx,00
		timer:
			inc cx
			cmp cx,60000D
		jne timer
		inc dx
		cmp dx,10000D
	jne timer2
ret

key_detect:
	push ax
	push bx
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
		mov byte [ flag],1
		
	niret:

	pop bx
	pop ax
	
iret


insert_interrupt_vector:
	mov ax,0
	mov es,ax
	mov bx,[ interrupt_num]
	shl bx,2 ;interrupt num * 4 = entry
	mov ax,cs
	shl eax,8  ;shl 8 bit   *16
	mov ax,[ interrupt_vector_offset]
	mov [es:bx], eax
ret

i db 0
j db 0
flag db 0
duan_1 dw 0
offset_1 dw 0

var:
	flag_position dd 0x1000
	interrupt_num dw 0x1c				;init
	interrupt_vector_offset dw 0x7c00	;init
	pointer db 0
	cornerstring db '\\\\\\\\\\||||||||||//////////'


times 510-($-$$) db 0
dw 0x55aa



