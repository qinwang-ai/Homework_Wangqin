org 0x800
sti
mov ax,0xb800
mov es,ax



mov al,'*';
again:

mov cx,239	;stop           /2 ==0 is char or is style
mov bx,200  ;stat

loop_int33:
	mov byte [es:bx],al
	inc bx
	mov byte [es:bx],78D;font color
	inc bx
	call delay
	cmp bx,cx
	jle loop_int33

	;h dirctation
	mov cx,1959D;stop           /2 ==0 is char or is style
	mov bx,238D  ;stat

loop_int33_h:
	mov byte [es:bx],al
	inc bx
	mov byte [es:bx],78D;font color
	add bx, 159D 
	call delay
	cmp bx,cx
	jle loop_int33_h



mov byte [es:690],'T'
call delay
call delay
mov byte [es:692],'H'
call delay
call delay
mov byte [es:694],'E'
call delay
call delay
call delay
call delay
call delay
call delay

	inc al
	cmp al,'~'
	jle again
	mov al,'!'
jmp again


jmp $



;---------;-----------------------FUNTION---------------

delay:
	push dx
	push cx
	mov si,2000D
	mov dx,00
	timer2:	
		mov cx,00
		timer:
			inc cx
			cmp cx,si
		jne timer
		inc dx
		cmp dx,si
	jne timer2
	pop cx
	pop dx
ret


times 512-($-$$) db 0	;填充剩余扇区0



