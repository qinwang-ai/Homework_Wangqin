[bits 16]
global print_welcome_msg 
global screen_init, print_message 
global input_char,printToscn,get_pointer_pos
global set_pointer_pos,print_flag,scroll_screen,flag_scroll
global flag_position:data,flag_scroll_up,init_ss
global init_flag_position,print_corner
global interrupt_init
;global int_user_num:data


extern main		;forbid run this file any time
extern load_user,run_user

jmp main

init_ss:
	mov ax,0
	mov ss,ax
ret

init_flag_position:
	mov ax,0x1000
	mov [ flag_position],ax 
ret

screen_init:               ;make all screen write
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
	jle loop	;<=

ret

interrupt_init:
	mov ax,cs
	mov ds,ax

	;#1  setting up time interrupt 
	mov ax,0x1c
	mov [ interrupt_num], ax
	mov ax, print_corner
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector


	;#2 int 33
	mov ax,0x33
	mov [ interrupt_num], ax
	mov ax, process_int33
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

ret


print_corner:
					; \ / [
		mov ax,cs
		mov ds,ax
		mov ax,0xb800
		mov es,ax

		mov dl,30
		mov al,[ pointer]		; alert:  must be al  dont ax
		cmp al,dl
		jne next_print_c
		mov byte [ pointer], 0
		jmp cotinue_corner

		next_print_c:
		mov eax, cornerstring
		mov bl,[ pointer]			;ebx is added sum
		add eax,ebx
		mov al,[ eax]

		inc ebx
		mov [ pointer],bl

		mov bx,3998D
		mov [ es:bx],al

		cotinue_corner:
iret

process_int33:
	mov al,19D
	mov [ int_user_num],al
	call load_user
	call run_user
	mov al,0
	mov [ int_user_num],al
iret

process_int34:
iret

process_int35:
iret

process_int36:
iret

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


print_welcome_msg:		;param ( string, len, position) 
	mov ax,cs
	mov es,ax
	mov ds,ax

	push bp	
	mov bp, msg;[bp+4]
	mov cx,msg_l;[bp+6]

	mov ax,1301h	;01 只有字符串
	mov bx,78D		;Bh is font color
	mov dx,0517h	;position
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
	mov dx,0805h	;position
	int 10h
	pop bp
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

input_char:
	mov ah,0x00; listen keyboard  return value is save in ax	
	int 16h	
ret

printToscn:			;显示输入的sequence
	mov ax,ds
	mov es,ax

	mov ah,0x0e
	mov bl,0x0e
	mov cx,bp	;cx is temp  bp don't change
	mov bp,sp
	mov al,[bp+4]
	mov bp,cx	;cx is temp
	mov cx,1
	int 10h
ret 

get_pointer_pos:
	
	mov ah,0x03 ;功能号
	mov bh,0x00
	int 10h
	mov ax,dx ;return row:col
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

;insert a interrupt vector 
insert_interrupt_vector:
	mov ax,0
	mov es,ax
	mov bx,[ interrupt_num]
	shl bx,2 ;interrupt num * 4 = entry
	mov ax,cs
	shl eax,8  ;shl 8 bit   *16
	mov ax,[ interrupt_vector_offset]
	mov [es:bx], eax
ret














;------------------DATA-------------------
msg:
	db `Welcome to Wangqin\'s OS v1.4`		;style 78D
msg_l equ $-msg

msg2:					;style 71D
	db `There are some system programs: -- date ,time ,asc ,clear  \r\n     You can man it to see detail.Ex: man date \r\n     You can enter the funtion name to run.\r\n\r\n     There also have three user's programs \r\n     Please type 'man run' to see more.....)`
msg2_l equ $-msg2

msg3:
	db 'root@wangqin:~# '
msg3_l equ $-msg3

format_line:
	db '                                                            '
format_line_l equ $-format_line


var:
	flag_position dd 0x1000
	interrupt_num dw 0x1c				;init
	interrupt_vector_offset dw 0x7c00	;init
	pointer db 0
	cornerstring db '\\\\\\\\\\||||||||||//////////'
	;int_user_num db 0



