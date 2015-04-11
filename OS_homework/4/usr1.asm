org 0x1000		;加载到 e0000内存中执行
;org 0x100		;加载到 e0000内存中执行

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


;call delay

mov bp,msg3	
mov cx,msg3_l
mov ax,1301h	;01 只有字符串
mov bx,78D		;Bh is font color
mov dx,1013h	;position
int 10h


mov ax,0x09
mov [ interrupt_num], ax
mov ax,ouch_detect
mov [ interrupt_vector_offset], ax
call insert_interrupt_vector


ouch_detect:

iret

;LISTEN_EXIT----
mov ah,0x00
int 0x16

;--------------------
pop bp

ret				;手动添加ret 结束后返回操作系统


;-------------------------DATA-----------------

msg:
	db 'I am User1,My program is running now!'
msg_l equ $-msg

msg2:
	db `User1's program is running,Please Waiting...`
msg2_l equ $-msg2

msg3:
	db `Program Complete!\nPress Enter to exit...(Other key will display OUCH! TAT)`
msg3_l equ $-msg3

;-----------------------FUNTION---------------

delay:
	mov dx,00
	timer2:	
		mov cx,00
		timer:
			inc cx
			cmp cx,600D
		jne timer
		inc dx
		cmp dx,6000D
	jne timer2
	ret

insert_interrupt_vector:
	mov ax,0
	mov es,ax
	mov bx,[ interrupt_num]
	shl bx,2 ;interrupt num * 4 = entry

	mov eax,[es:bx]			;backup
	mov [ interrupt_vector_offset_bak], eax

	mov ax,cs
	shl eax,8  ;shl 8 bit   *16
	mov ax,[ interrupt_vector_offset]
	mov [es:bx], eax
ret

	interrupt_num dw 0x09				;init
	interrupt_vector_offset dw 0x7c00	;init
	interrupt_vector_offset_bak dw 0x7c00	;init







times 512-($-$$) db 0	;填充剩余扇区0



