OS_Start:

org 0x8100;加载到0x8100执行
;org 0x7c00
;style BEGIN================

	call init;操作系统初始化
	call initvar;变量初始化

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

	cmp word [a],0 ;第一个程序
	jne exea
	jmp RUN_OVER	;没有则结束
	exea:
	mov ax,[a]
	sub ax,46D	;扇区偏移，前两个扇区中分别放着引导和操作系统   [a]-48  +2 =  [a]-46  [a] is char not int
	mov [now_shanqu],ax	;ax is temp
	call run
	
	cmp word [b],0 ;第二个程序
	jne exeb
	jmp RUN_OVER
	exeb:
	mov ax,[b]
	sub ax,46D	;扇区偏移，前两个扇区中分别放着引导和操作系统
	mov [now_shanqu],ax	;ax is temp
	call run

	cmp word [c],0 ;第三个程序
	jne exec
	jmp RUN_OVER
	exec:
	mov ax,[c]
	sub ax,46D	;扇区偏移，前两个扇区中分别放着引导和操作系统
	mov word [now_shanqu],ax
	call run
	
RUN_OVER:

	jmp	OS_Start;所有程序执行完毕返回操作系统
	

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

var:		;程序所用到的一些临时变量
	count dd 0
	a dd 0
	b dd 0
	c dd 0
	now_shanqu dd 0

;===========================functions============

print_init:		;打印初始化

	mov ax,cs
	mov ds,ax
	mov es,ax	;base address
	ret

print_style:	;打印样式设置
mov ax,1301h;setting char style
mov bx,71D;setting font color
ret

print_style_header:		;标题样式设置
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


display:			;显示输入的sequence
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
	cmp word [count],4 ;超过四个字符 不显示 也不保存，继续监听直到回车
	jge LISTEN



run:						;执行某个用户的程序,具体扇区在[now_shanqu] 中
	call init	;清屏仅仅清屏而已
;----------------加载---------
	mov ax,0
	mov es,ax
	mov bx,0xa700;加载到内存e000
	mov ax,0201H;
	mov dx,0
	mov ch,0
	mov cl,[now_shanqu];要被加载的扇区号
	int 13h;加载
;---------------执行-----------
	call word 0xa700		;not dword
	ret


times 512-($-$$) db 0	;扇区剩余位置填充0




