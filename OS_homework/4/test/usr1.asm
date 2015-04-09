org 0x7c00
mov ax,cs
mov es,ax
mov ds,ax		;es ,ds   = cs

mov bp,msg		
mov cx,msg_l
mov ax,1301h	;01 只有字符串
mov bx,0007D		;Bh is font color
mov dx,0614h	;position
int 10h
					;delay time function 

;-------------------------DATA-----------------

msg:
	db 'I am User1,My program is running now!'
msg_l equ $-msg

;-----------------------FUNTION---------------

times 512-($-$$) db 0	;填充剩余扇区0



