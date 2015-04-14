org 0x1000		;加载到 e0000内存中执行
;org 0x100		;加载到 e0000内存中执行

push ax
push cx
push dx

mov ax,cs
mov es,ax
mov ds,ax		;es ,ds   = cs

push bp

mov bp,msg		
mov cx,msg_l
mov ax,1301h	;01 只有字符串
mov bx,71D		;Bh is font color
mov dx,0613h	;position
int 10h
					;delay time function 
mov bp,msg2		
mov cx,msg2_l
mov ax,1301h	;01 只有字符串
mov bx,78D		;Bh is font color
mov dx,0813h	;position
int 10h


mov bp,msg3	
mov cx,msg3_l
mov ax,1301h	;01 只有字符串
mov bx,78D		;Bh is font color
mov dx,1013h	;position
int 10h


pop bp
pop dx
pop cx
pop ax

;LISTEN_EXIT----
listen:
	mov ch,'A'
	cmp ch,cl
jne listen 

;--------------------

ret				;手动添加ret 结束后返回操作系统


;-------------------------DATA-----------------

msg:
	db 'I am User1,My program is running now!'
msg_l equ $-msg

msg2:
	db `User1's program is running,Please Waiting...`
msg2_l equ $-msg2

msg3:
	db `Program Complete!\r\n\r\n                   Press 4 times keyboard for display OUCH and exit...`
msg3_l equ $-msg3

;-----------------------FUNTION---------------



times 512-($-$$) db 0	;填充剩余扇区0



