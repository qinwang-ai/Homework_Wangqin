org 0x2000		;加载到 e0000内存中执行
;org 0x7c00		;加载到 e0000内存中执行

	sti
	mov ax,0xb800
	mov es,ax
mov al,'*';
again:

	;h dirctation
	mov cx,2077D	;stop           /2 ==0 is char or is style
	mov bx,278D  ;stat


	loop_int34_h:
	mov byte [es:bx],al
	inc bx
	mov byte [es:bx],78D;font color
	add bx, 159D
	call delay
	cmp bx,cx
	jle loop_int34_h

	;w dirctation
	mov bx,2036D;start           /2 ==0 is char or is style   stop /2 !=0
	mov cx,1999D ;stop                          start/2==0

	loop_int34:
	mov byte [es:bx],al
	dec bx
	mov byte [es:bx],78D;font color
	dec bx
	call delay
	cmp cx,bx
	jle loop_int34

	mov byte [es:730],'S'
	call delay
	call delay

	mov byte [es:732],'E'
	call delay
	call delay

	mov byte [es:734],'C'	
	call delay
	call delay

	mov byte [es:736],'O'	
	call delay
	call delay

	mov byte [es:738],'N'	
	call delay
	call delay

	mov byte [es:740],'D'

	inc al
	cmp al,'~'
	jle again
	mov al,'!'
jmp again

jmp $


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



