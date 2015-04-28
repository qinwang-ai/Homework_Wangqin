[bits 16]
global interrupt_init,insert_interrupt_vector,load_user,run_user
global interrupt_num:data,interrupt_vector_offset:data
global syscall_num:data
global schedule_end


extern main		;forbid run this file any time
extern run_syscall,screen_init
extern isProcessRun
extern schedule 

jmp main

interrupt_init:
	mov ax,0		;init ss regsiter
	mov ss,ax

	mov ax,cs
	mov ds,ax

	;#1  setting up time interrupt 
	mov ax,0x1c
	mov [ interrupt_num], ax
	mov ax, timer_interrupt_process
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector



	;#2 int 33
	mov ax,0x33
	mov [ interrupt_num], ax
	mov ax, process_int33
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector
	
	;#3 int 34
	mov ax,0x34
	mov [ interrupt_num], ax
	mov ax, process_int34
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

	;#4 int 35
	mov ax,0x35
	mov [ interrupt_num], ax
	mov ax, process_int35
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

	;#5 int 36
	mov ax,0x36
	mov [ interrupt_num], ax
	mov ax, process_int36
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

	;#5 int 36
	mov ax,0x80
	mov [ interrupt_num], ax
	mov ax, process_int80
	mov [ interrupt_vector_offset],ax
	call insert_interrupt_vector

ret

timer_interrupt_process:
	push ax
	mov ax,0
	mov ds,ax
	mov byte al,[ isProcessRun]
	mov ah,0
	cmp al,ah
	je print_corner
	pop ax
	jmp schedule
		
schedule_end:
	push ax
	mov al, 20h
	out 20h,al
	out 0A0h,al
	pop ax
	sti
iret

print_corner:
		pop ax
					; \ / [
		push ax
		push dx
		push bx
		mov ax,cs
		mov ds,ax

		mov ax,0xb800
		mov es,ax

		mov dl,30
		mov al,[ pointer]		; alert:  must be al  dont ax
		cmp al,dl
		jle next_print_c
		mov byte [ pointer], 0
		jmp cotinue_corner

		next_print_c:
		mov eax, 0
		mov eax, cornerstring
		mov ebx,0
		mov bl,[ pointer]			;ebx is added sum
		add eax,ebx
		mov al,[ eax]

		inc bl 
		mov [ pointer],bl

		mov bx,3998D
		mov [ es:bx],al

		cotinue_corner:
		pop bx
		pop dx
		pop ax

jmp schedule_end	

process_int33:
	push ax
	push bx
	push cx
	mov ax,0xb800
	mov es,ax

	mov cx,239	;stop           /2 ==0 is char or is style
	mov bx,200  ;stat

	loop_int33:
	mov byte [es:bx],'#'
	inc bx
	mov byte [es:bx],78D;font color
	inc bx
	cmp bx,cx
	jle loop_int33

	;h dirctation
	mov cx,1959D;stop           /2 ==0 is char or is style
	mov bx,238D  ;stat

	loop_int33_h:
	mov byte [es:bx],'#'
	inc bx
	mov byte [es:bx],78D;font color
	add bx, 159D
	cmp bx,cx
	jle loop_int33_h
	pop cx
	pop bx
	pop ax

iret

process_int34:
	push ax
	push bx
	push cx

	mov ax,0xb800
	mov es,ax

	mov cx,2037D;stop           /2 ==0 is char or is style   stop /2 !=0
	mov bx,1998D ;stat                          start/2==0

	loop_int34:
	mov byte [es:bx],'#'
	inc bx
	mov byte [es:bx],78D;font color
	inc bx
	cmp bx,cx
	jle loop_int34

	;h dirctation
	mov cx,2077D	;stop           /2 ==0 is char or is style
	mov bx,278D  ;stat

	loop_int34_h:
	mov byte [es:bx],'#'
	inc bx
	mov byte [es:bx],78D;font color
	add bx, 159D
	cmp bx,cx
	jle loop_int34_h
	pop cx
	pop bx
	pop ax

iret

process_int35:
	push ax
	push bx
	push cx


	mov ax,0xb800
	mov es,ax

	mov cx,1999D;stop           /2 ==0 is char or is style   stop /2 !=0
	mov bx,1960D ;stat                          start/2==0

	loop_int35:
	mov byte [es:bx],'#'
	inc bx
	mov byte [es:bx],78D;font color
	inc bx
	cmp bx,cx
	jle loop_int35

	;h dirctation
	mov cx,3809D	;stop           /2 ==0 is char or is style
	mov bx,1960D  ;stat

	loop_int35_h:
	mov byte [es:bx],'#'
	inc bx
	mov byte [es:bx],78D;font color
	add bx, 159D
	cmp bx,cx
	jle loop_int35_h
	pop cx
	pop bx
	pop ax

iret

process_int36:
	push ax
	push bx
	push cx


	mov ax,0xb800
	mov es,ax

	mov cx,3799D;stop           /2 ==0 is char or is style   stop /2 !=0
	mov bx,3760D ;stat                          start/2==0

	loop_int36:
	mov byte [es:bx],'#'
	inc bx
	mov byte [es:bx],78D;font color
	inc bx
	cmp bx,cx
	jle loop_int36

	;h dirctation
	mov cx,3917D	;stop           /2 ==0 is char or is style
	mov bx,1998D  ;stat

	loop_int36_h:
	mov byte [es:bx],'#'
	inc bx
	mov byte [es:bx],78D;font color
	add bx, 159D
	cmp bx,cx
	jle loop_int36_h
	pop cx
	pop bx
	pop ax

iret

process_int80:
	push bx
	push es
	push cx

	mov [ syscall_num],ah	
	call run_syscall
	pop cx
	pop es
	pop bx
iret

; load_user( shanqu_num);
load_user:
	;load os to mem

	mov ax,cs
	mov es,ax
	;if int_user_num is 0  then cx = bp+4 else cx = int_user_num
	;mov al,[ int_user_num]
	;mov ah,0
	;cmp al,ah
	;je bp_param
	;mov cl,al
	;jmp next_lu
	;bp_param:

	mov cx,1;扇区号参数

	;next_lu:


	mov dx,bp	;backup
	mov bp,sp
	mov ch,[ bp+4]		; 柱面/磁道  every zhumian  has one user program 37~72  73~108 109~144
	mov bx,[ bp+8] ;add to 0x100 mem
	mov bp,dx

	mov dl,0		; 软盘
	mov dh,0		; 磁头:正面

	xor ax,ax
	mov es,ax ;made es zero,ex:bx is addr of mem 
	mov ax,0215h	;count 
	int 13h
ret


run_user:
	
	push ecx
	push ax
	mov [ sp_temp],sp
	mov sp ,0x1000-4 
	call screen_init

	;---------------------update 09 vector
	;cli
	;mov ax,0
	;mov es,ax
	;mov ecx,[ es:36]			;backup
	;mov [ duan_1],ecx

;	mov ax,0x09
;	mov [ interrupt_num], ax
;	mov ax, key_detect
;	mov [ interrupt_vector_offset],ax
;	call insert_interrupt_vector
;	mov ax,0
;	mov [i],ax
;	sti
;--------------------run

	call 0x1000

;--------------------reset 09 vector
;	mov ax,0
;	mov es,ax
;	mov ecx,[ duan_1]
;	mov [ es:36],ecx

	mov sp,[ sp_temp]
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

var:
	interrupt_num dw 0x1c				;init
	interrupt_vector_offset dw 0x7c00	;init
	pointer db 0
	cornerstring db '\\\\\\\\\\||||||||||//////////'
	syscall_num db 0
	sp_temp db 0x1000
	;int_user_num db 0


i db 0		;counter
j db 0		;reverse every time  0101
flag db 0
duan_1 dw 0
offset_1 dw 0

