[bits 16]
extern main		;forbid run this file any time
jmp main

global clear,get_time,get_second
global get_date,get_year,load_user,run_user

extern flag_position 
extern screen_init, insert_interrupt_vector
extern interrupt_num,interrupt_vector_offset

clear:			;clear the screen

	push ax
	mov ax,0x0000
	mov [ flag_position], ax
	pop ax
	call screen_init
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

; load_user( shanqu_num);
load_user:
	;load os to mem
	mov ax,cs
	mov es,ax

	mov dx,bp
	mov bp,sp

	;if int_user_num is 0  then cx = bp+4 else cx = int_user_num
	;mov al,[ int_user_num]
	;mov ah,0
	;cmp al,ah
	;je bp_param
	;mov cl,al
	;jmp next_lu
	;bp_param:

	mov cx,[bp+4];扇区号参数

	;next_lu:

	mov bp,dx

	xor ax,ax
	mov es,ax ;made es zero,ex:bx is addr of mem 
	mov bx,0x1000 ;add to 0x100 mem
	mov ax,0201h	;count 
	mov dx,0
	int 13h
ret


run_user:
	push ecx
	push ax
	call screen_init

	;---------------------update 09 vector
	cli
	mov ax,0
	mov es,ax
	mov ecx,[ es:36]			;backup
	mov [ duan_1],ecx

	mov ax,0x09
	mov [ interrupt_num], ax
	mov ax, key_detect
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector
	mov ax,0
	mov [i],ax
	sti
;--------------------run
	call 0x1000

;--------------------reset 09 vector
	mov ax,0
	mov es,ax
	mov ecx,[ duan_1]
	mov [ es:36],ecx

	pop ax
	pop ecx
ret

key_detect:
	cli
	push ax
	push bx
	mov ax,0xb800
	mov es,ax

	in al,60h
	in al,61h
	or al,80h
	out 61h,al
	mov al,61h
	out 20h,al

	mov bl,0
	mov bh,[j]
	cmp bl,bh
	je change1
	
	mov bh,0
	mov [j],bh
	mov byte [es:00],'O'
	mov byte [es:02],'U'
	mov byte [es:04],'C'
	mov byte [es:06],'H'

	jmp next_de

	change1:
	mov bh,1
	mov [j],bh

	mov byte [es:00],' '
	mov byte [es:02],' '
	mov byte [es:04],' '
	mov byte [es:06],' '

	next_de:
	
	mov bl,[i]
	inc bl
	mov [i],bl
	mov bh,8		;press key 8 times
	cmp bh,bl
	jle closesti
	jmp niret
	closesti:
		mov cl,'A'
		
	niret:

	pop bx
	pop ax
	sti	
iret
	
var:
i db 0		;counter
j db 0		;reverse every time  0101
flag db 0
duan_1 dw 0
offset_1 dw 0


