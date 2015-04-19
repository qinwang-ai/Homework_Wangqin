[bits 16]
extern main		;forbid run this file any time
jmp main

global clear,get_time,get_second
global get_date,get_year
global flag_position:data,flag_scroll_up,init_ss
global print_message 
global print_welcome_msg 
global init_flag_position,print_corner
global set_pointer_pos,flag_scroll,print_flag
global scroll_screen


;extern insert_interrupt_vector
;extern interrupt_num,interrupt_vector_offset

extern screen_init

clear:			;clear the screen

	push ax
	mov ax,0x0000
	mov [ flag_position], ax
	pop ax
	call screen_init
ret 

init_ss:
	mov ax,0
	mov ss,ax
ret

init_flag_position:
	mov ax,0x1000
	mov [ flag_position],ax 
ret


get_time:
	mov ah,0x02
	int 0x1a
	mov ax,cx
ret

get_second:
	mov ah,0x02
	int 0x1a
	mov ax,dx
ret

get_year:
	mov ah,0x04
	int 0x1a
	mov ax,cx
ret

get_date:
	mov ah,0x04
	int 0x1a
	mov ax,dx
ret

print_welcome_msg:		;param ( string, len, position) 
	mov ax,cs
	mov es,ax
	mov ds,ax

	push bp	
	mov bp, msg;[bp+4]
	mov cx,msg_l;[bp+6]

	mov ax,1301h	;01 只有字符串
	mov bx,78D		;Bh is font color
	mov dx,0317h	;position
	int 10h
	pop bp
ret 

print_message:		;  descripatoin
	mov ax,cs
	mov es,ax
	mov ds,ax
	push bp
	mov bp, msg2;[bp+4]
	mov cx,msg2_l;[bp+6]

	mov ax,1301h	;01 只有字符串
	mov bx,71D		;Bh is font color
	mov dx,0605h	;position
	int 10h
	pop bp
ret 

screen_init_last_line:               ;make last line white
	mov ax,0xb800
	mov es,ax
	mov ax,00
	mov cx,3999
	mov bx,3872

	loop_2:
	mov byte [es:bx],' '
	inc bx
	mov byte [es:bx],78D;font color
	inc bx
	cmp bx,cx
	jle loop_2

ret

print_flag:		;root@wangqin#

	mov ax,cs
	mov ds,ax
	mov es,ax

	mov ax,1301h	;01 只有字符串
	mov bx,71D		;Bh is font color
;	mov dx,1305h	;position
	mov dx, [flag_position]	;position
	push bp
	mov bp, msg3
	mov cx,msg3_l

	int 10h
	pop bp
	call screen_init_last_line   ;for some compatible questions when scrolling
ret


flag_scroll:		;flag move next line
	push ax
	mov ax,[flag_position]		;flag move down
	add ax,0x100				;next line
	mov [flag_position],ax
	pop ax
ret

flag_scroll_up:		;flag move next line
	push ax
	mov ax,[flag_position]		;flag move down
	sub ax,0x100				;next line
	mov [flag_position],ax
	pop ax
ret



set_pointer_pos:
	mov ax,ds
	mov es,ax
	
	mov cx,bp		;cx is temp
	mov bp,sp

	mov ah,0x02 ;功能号
	mov bh,0x00		;页号
;	mov dx,[bp+4]	;行列
	mov dx,[flag_position]	;行列
	int 10h
	mov bp,cx
ret 

scroll_screen:
	
	mov ah,0x06 ;功能号
	mov al,0x01		;how many line 
	mov cx,0x0000
	mov dx,0x2580
	mov bh,78D
	int 10h
ret 


compatible_vmware:
	;----------------------for some comptable question
	mov ax,cs
	mov ds,ax
	mov es,ax

	mov ax,1301h	;01 只有字符串
	mov bx,78D		;Bh is font color
	mov dx, 0x2428	;position
	push bp
	mov bp, format_line
	mov cx,format_line_l
	int 10h
	pop bp
ret

;------------------DATA-------------------
var:

msg:
	db `Welcome to Wangqin\'s OS v1.5`		;style 78D
msg_l equ $-msg

msg2:					;style 71D
	db `System programs -- date,time,asc,clear,help,python  \r\n         Man it to see detail.Ex: man date.\r\n\r\n     User programs   -- Type 'man run' to see more.... \r\n\r\n     Interrupts      -- int 33h,int 34h,int 35h,int 36h. Ex:int 33h.\r\n         In last user program all 4 interrupts will execute.\r\n     Syscall         -- Type run 2. Please read my report to see more...`
msg2_l equ $-msg2

msg3:
	db 'root@wangqin:~# '
msg3_l equ $-msg3

flag_position dd 0x1000
	
format_line:
	db '                                                            '
format_line_l equ $-format_line








