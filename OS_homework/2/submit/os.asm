OS_Start:

org 0x8100;���ص�0x8100ִ��
;org 0x7c00
;style BEGIN================

	call init;����ϵͳ��ʼ��
	call initvar;������ʼ��

	call print_init
	mov bp,menu_msg	;str's offset
	call print_style_header
	mov dx,0517H; setting char position
	mov cx,menu_msg_l;setting string'slength
	int 10h	;display 

	mov bp,menu_msg2	;str's offset
	call print_style
	mov dx,0805H
	mov cx,menu_msg_l2
	int 10h

	mov bp,msg3	;str's offset
	mov dx,0905H
	mov cx,msg_l3
	int 10h

	mov bp,msg5	;str's offset
	mov dx,1005H
	mov cx,msg_l5
	int 10h

;style END==================
LISTEN:
	mov ah,0x00; listen keyboard	
	int 0x16	
	cmp al,0x0d

   
	jne display
	
	jmp RUN_USER

RUN_USER:

	cmp word [a],0 ;��һ������
	jne exea
	jmp RUN_OVER	;û�������
	exea:
	mov ax,[a]
	sub ax,46D	;����ƫ�ƣ�ǰ���������зֱ���������Ͳ���ϵͳ   [a]-48  +2 =  [a]-46  [a] is char not int
	mov [now_shanqu],ax	;ax is temp
	call run
	
	cmp word [b],0 ;�ڶ�������
	jne exeb
	jmp RUN_OVER
	exeb:
	mov ax,[b]
	sub ax,46D	;����ƫ�ƣ�ǰ���������зֱ���������Ͳ���ϵͳ
	mov [now_shanqu],ax	;ax is temp
	call run

	cmp word [c],0 ;����������
	jne exec
	jmp RUN_OVER
	exec:
	mov ax,[c]
	sub ax,46D	;����ƫ�ƣ�ǰ���������зֱ���������Ͳ���ϵͳ
	mov word [now_shanqu],ax
	call run
	
RUN_OVER:

	jmp	OS_Start;���г���ִ����Ϸ��ز���ϵͳ
	

jmp $		;LAST instruction to execute 

;===========================data============================================
menu_msg:
	db `Hello,Welcome To Wangqin's OS v1.0`
menu_msg_l equ ($-menu_msg) 

menu_msg2:
	db `There are three user's programs,You can put the numbers sequence to run`
menu_msg_l2 equ ($-menu_msg2) 

msg3:
	db 'Example:1 2 3,1 3 2, 1 3,1 .....'
msg_l3 equ ($-msg3) 

msg5:
	db `Input end with Enter\n  Num Sequence:`
msg_l5 equ ($-msg5) 

var:		;�������õ���һЩ��ʱ����
	count dd 0
	a dd 0
	b dd 0
	c dd 0
	now_shanqu dd 0

;===========================functions============

print_init:		;��ӡ��ʼ��

	mov ax,cs
	mov ds,ax
	mov es,ax	;base address
	ret

print_style:	;��ӡ��ʽ����
mov ax,1301h;setting char style
mov bx,71D;setting font color
ret

print_style_header:		;������ʽ����
mov ax,1301h;setting char style
mov bx,78D;setting font color
ret


init:               ;make all screen write
	mov ax,0xb800
	mov es,ax
	mov ax,00
	mov cx,3999
	mov bx,00

	loop:
	mov byte [es:bx],' '
	inc bx
	mov byte [es:bx],78D;font color
	inc bx
	cmp bx,cx
	jle loop

ret

initvar:
;---------------------make all vars is zero
	mov ax,0
	mov [count],ax
	mov [a],ax
	mov [b],ax
	mov [c],ax
	mov [now_shanqu],ax

ret


display:			;��ʾ�����sequence
	mov ah,0x0e
	mov bl,0x00

	inc word [count]	;count of input sequence
	cmp word [count],1
	je savea
	jmp compB
	savea:
	mov [a],al		;save
	int 10h
	je LISTEN

	compB:
	cmp word [count],2	
	je saveb
	jmp compC
	saveb:

	mov [b],al
	int 10h
	je LISTEN

	compC:
	cmp word [count],3
	je savec
	jmp compD
	savec:
	mov [c],al		;save  char not int 
	int 10h			;display
	je LISTEN
	
	compD:
	cmp word [count],4 ;�����ĸ��ַ� ����ʾ Ҳ�����棬��������ֱ���س�
	jge LISTEN



run:						;ִ��ĳ���û��ĳ���,����������[now_shanqu] ��
	call init	;����������������
;----------------����---------
	mov ax,0
	mov es,ax
	mov bx,0xa700;���ص��ڴ�e000
	mov ax,0201H;
	mov dx,0
	mov ch,0
	mov cl,[now_shanqu];Ҫ�����ص�������
	int 13h;����
;---------------ִ��-----------
	call word 0xa700		;not dword
	ret


times 512-($-$$) db 0	;����ʣ��λ�����0




