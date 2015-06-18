org 0x2800	
sti

jmp $
[section .data]
	tmpdi db 130D
	tmpsi db 130D
	tmpb1 db 130D
	tmpl1 db 130D
	tmp_ax db 162D
	zero db 0D
	msg:	db "Student ID:13349112 "
	msg2:	db "name:wangqin"  ;length =28

[section .text]
mov ax, 0xB800
mov es,ax
call init

mov byte [es:00],'A'
mov bx,00			;init 

mov si,162D 
bottom:
	mov ax,si
	mov [tmpsi],bx
	add bx,ax
	call delay		;delay time
	mov al,' '
	mov ah,[es:bx]
	cmp al,ah
	jne n1
	mov byte [es:bx],'A'
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

	cmp bx,3839D   ;24*160-1 3839
	jl bottom



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
	mov al,' '
	mov ah,[es:bx]
	cmp al,ah		; don't overirrde my name and number
	jne n2
	mov byte [es:bx],'A'
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



delay:					;delay time function 
	mov dx,00
	timer2:	
		mov cx,00
		timer:
			inc cx
			cmp cx,60000D
		jne timer
		inc dx
		cmp dx,6000D
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

	mov si,msg
	mov di,12*80*2+40

	g:
	mov ax,0x7c0
	mov ds,ax

	mov al,[si]
	mov [es:di],al
	inc di
	mov byte [es:di],36D
	inc di
	inc si
	mov cx,2024D
	cmp di,cx
	jge nex22
	loop g
	nex22:

	mov ax, 0xB800
	mov es,ax

	ret

jmp $



