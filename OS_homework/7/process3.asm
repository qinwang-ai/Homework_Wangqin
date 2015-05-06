;org 0x1000		;加载到 e0000内存中执行

org 0x3000		;加载到 e0000内存中执行
sti
mov ax,0xb800
mov es,ax
mov al,'*';
again:


	;h dirctation
	mov bx,3720D	;start           /2 ==0 is char or is style
	mov cx,1961D  ;stop

	loop_int35_h:
	mov byte [es:bx],al
	dec bx
	mov byte [es:bx],78D;font color
	sub bx, 159D
	call delay
	cmp cx,bx
	jle loop_int35_h

	mov cx,1999D;stop           /2 ==0 is char or is style   stop /2 !=0
	mov bx,1960D ;stat                          start/2==0

	loop_int35:
	mov byte [es:bx],al
	inc bx
	mov byte [es:bx],78D;font color
	inc bx
	call delay
	cmp bx,cx
	jle loop_int35

mov byte [es:2450],'W'
call delay
call delay

mov byte [es:2452],'O'
call delay
call delay

mov byte [es:2454],'R'
call delay
call delay

mov byte [es:2456],'L'
call delay
call delay

mov byte [es:2458],'D'
call delay
call delay


	inc al
	cmp al,'~'
	jle again
	mov al,'!'
jmp again




;-----------------------FUNTION---------------

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



