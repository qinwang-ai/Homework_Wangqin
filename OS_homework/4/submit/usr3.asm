org 0xa700		;���ص� e0000�ڴ���ִ��
;org 0x7c00		;���ص� e0000�ڴ���ִ��

mov ax,cs
mov es,ax
mov ds,ax		;es ,ds   = cs

mov bp,msg		
mov cx,msg_l
mov ax,1301h	;01 ֻ���ַ���
mov bx,71D		;Bh is font color
mov dx,0613h	;position
int 10h
					;delay time function 
mov bp,msg2		
mov cx,msg2_l
mov ax,1301h	;01 ֻ���ַ���
mov bx,78D		;Bh is font color
mov dx,0813h	;position
int 10h


call delay

mov bp,msg3	
mov cx,msg3_l
mov ax,1301h	;01 ֻ���ַ���
mov bx,78D		;Bh is font color
mov dx,1013h	;position
int 10h

;LISTEN_EXIT----
mov ah,0x00
int 0x16

;--------------------

ret				;�ֶ����ret �����󷵻ز���ϵͳ


;-------------------------DATA-----------------

msg:
	db 'I am User3,My program is running now!'
msg_l equ $-msg

msg2:
	db `User3's program is running,Please Waiting...`
msg2_l equ $-msg2

msg3:
	db `Program Complete!\nPress any key to exit...`
msg3_l equ $-msg3

;-----------------------FUNTION---------------

delay:
	mov dx,00
	timer2:	
		mov cx,00
		timer:
			inc cx
			cmp cx,60000D
		jne timer
		inc dx
		cmp dx,60000D
	jne timer2
	ret



times 512-($-$$) db 0	;���ʣ������0



