org 0x1000	
sti

[section .data]
	tmpdi db 130D
	tmpsi db 130D
	tmpb1 db 130D
	tmpl1 db 130D
	tmp_ax db 162D
	zero db 0D
	msg:	db "GAME OVER "
	msg2:	db "name:wangqin"  ;length =28
	grades db 48
	speedi db 1000D
	speedj db 6000D

[section .text]
mov ax, 0xB800
mov es,ax
call init_display
call display_grades

mov byte [es:00],'A'
mov bx,00			;init 

mov si,162D 
bottom:
	mov ax,si
	mov [tmpsi],bx
	add bx,ax
	call delay		;delay time

	mov ax,si
	sub bx,ax
	mov byte [es:bx],' '
	add bx,ax

	mov cl,'='
	mov ch,[es:bx]
	cmp cl,ch
	je n1
	mov byte [es:bx],'*'
	n1:

	mov ax,bx	;bx is dividend
	mov cl,160D
	div byte cl
	mov al,0D
	cmp ah,al	;reminder == 0  ah is reminder
	je changeaxl 
	jmp next3

	changeaxl:		;change ax for toping 
		mov si,162D

	next3:
	inc bx
	inc bx
	mov ax,bx	;bx is dividend
	dec bx
	dec bx
	mov cl,160D
	div byte cl
	mov al,0D
	cmp ah,al	;reminder == 0
	je changax5 
	jmp next5

	changax5:		;change ax for toping 
		mov si,158D

	next5:

	cmp bx,3839D   ;24*160-1 3839			CHANGE
	jge game_over
	mov ah, '='
	mov byte al,[es:bx]
	cmp al,ah
	jne bottom
	mov ax,cs
	mov ds,ax
	mov ah,[ grades]
	inc ah
	mov byte [ grades],ah	;change grades
	mov ax,[ speedi]		;change speed
	sub ax,100D
	mov [speedi],ax
	call display_grades



; juage which direction to top
mov ax,bx			;bx is dividend
inc ax		; add 0's offset		
mov cl,160D ;	cx is divisor
div byte cl
mov dh,ah  ; dh is reminder1

mov ax,[tmpsi]			;si is dividend
inc ax
div byte cl
mov ch,ah
mov si,158D	;next ax
cmp dh,ch	;right or left
jge top			;>=
mov si,162D
jmp top


top:
	mov ax,si
	mov [tmpdi],bx
	sub bx,ax
	call delay
	mov al,'='
	mov ah,[es:bx]
	cmp al,ah		; don't overirrde my name and number
	je n2
	mov ax,si
	add bx,ax
	push cx
	mov byte ch,[es:bx]	
	mov byte cl,'='
	cmp ch,cl
	je sub_not_blank
	mov byte [es:bx],' '
	sub_not_blank:
	pop cx
	sub bx,ax
	mov byte [es:bx],'*'
	n2:
	inc bx		;plus the 0 and css offset so add two times
	inc bx
	mov ax,bx	;bx is dividend
	dec bx
	dec bx
	mov cl,160D
	div byte cl
	mov al,0D
	cmp ah,al	;reminder == 0
	je change_ax_t 
	
	jmp next

	change_ax_t:		;change ax for toping 
		mov si,162D		;dx is temp

	next:

	mov ax,bx	;bx is dividend
	mov cl,160D
	div byte cl
	mov al,0D
	cmp ah,al	;reminder == 0
	je changear 
	jmp next4

	changear:		;change ax for toping 
		mov si,158D

	next4:



	cmp bx,160D
	jge top		;>=

mov ax,bx	;bx is dividend
inc ax
mov cl,160D
div byte cl
mov ch,ah

mov ax,[tmpdi]	;di is dividend
inc ax
mov cl,160D
div byte cl
mov cl,ah

cmp ch,cl	;ch is bx
jl change_ax_l
	mov si,162D
	jmp next2
change_ax_l:
	mov si,158D	
next2:	


jmp bottom 

exit:			;function exit
jmp $

init_display:
	push bx
	mov ax,0xb800
	mov es,ax
	mov bx,138D
	mov byte [es:bx],'G'
	add bx,2
	mov byte [es:bx],'r'
	add bx,2
	mov byte [es:bx],'a'
	add bx,2
	mov byte [es:bx],'d'
	add bx,2
	mov byte [es:bx],'e'
	add bx,2
	mov byte [es:bx],':'

	pop bx
ret

display_grades:
	push bx
	mov ax,0xb800
	mov es,ax
	mov bx,150D
	mov ch,[grades]
	mov [es:bx],ch
	pop bx
ret

game_over:
	mov ax,0xb800
	mov es,ax
	mov si,msg
	mov di,12*80*2+60

	g:
	mov ax,cs
	mov ds,ax

	mov al,[si]
	mov [es:di],al
	inc di
	mov byte [es:di],36D
	inc di
	inc si
	mov cx,2000D
	cmp di,cx
	jge nex22
	loop g
	nex22:

	
jmp $



delay:					;delay time function 
	mov dx,00
	timer2:	
		mov cx,00
		timer:
			inc cx
			cmp cx,[ speedj]
		jne timer
		inc dx
		cmp dx,[ speedi]
	jne timer2
	ret

init:				;make all screen write 
	mov ax,00
	mov cx,3999
	mov bx,00

	loop:
		mov byte [es:bx],' '
		inc bx
		mov byte [es:bx],126D
		inc bx
		cmp bx,cx
		jle loop

	mov ax, 0xB800
	mov es,ax

	ret

jmp $



