
org 0x2000		;加载到 e0000内存中执行
sti
mov ax,0xb800
mov es,ax

mov al,'*';
again:

	mov bx,3798D;start           /2 ==0 is char or is style   stop /2 !=0
	mov cx,3759D ;stop                          start/2==0

	loop_int36:
	mov byte [es:bx],al
	dec bx
	mov byte [es:bx],78D;font color
	dec bx
	call delay
	cmp cx,bx
	jle loop_int36

	;h dirctation
	mov bx,3758D	;start           /2 ==0 is char or is style
	mov cx,1997D  ;stop

	loop_int36_h:
	mov byte [es:bx],al
	dec bx
	mov byte [es:bx],78D;font color
	sub bx, 159D
	call delay
	cmp cx,bx
	jle loop_int36_h

mov byte [es:2490],'W'
call delay
call delay
mov byte [es:2492],'A'
call delay
call delay
mov byte [es:2494],'R'
call delay
call delay
call delay
call delay
call delay
call delay

; display_stu num
;mov byte [es:2810],'1'
;call delay
;call delay
;mov byte [es:2812],'3'
;call delay
;call delay
;mov byte [es:2814],'3'
;call delay
;call delay
;mov byte [es:2816],'4'
;call delay
;call delay
;mov byte [es:2818],'9'
;call delay
;call delay
;mov byte [es:2820],'1'
;call delay
;call delay
;mov byte [es:2822],'1'
;call delay
;call delay
;mov byte [es:2824],'2'

	inc al
	cmp al,'~'
	jle again
	mov al,'!'
jmp again

jmp $



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



