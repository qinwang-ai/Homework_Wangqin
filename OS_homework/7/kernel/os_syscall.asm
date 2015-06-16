[bits 16]
extern main		;forbid run this file any time
jmp main

global syscall_init,run_syscall
extern syscall_num
extern do_fork, do_wait, do_exit


;---PARAM: ah is syscall num   ebx is address of syscall  bx:temp cx:function ax:sysnum
setting_up_syscall:
	mov bx,0
	mov es,bx
	mov al,ah
	mov ah,0
	shl al,2
	mov bx,0xfe00
	add bx,ax
	mov [es:bx],ecx
ret

syscall_init:

;----#0 syscall
	mov ah,0
	mov ecx,0
	mov cx,display_center_ouch
	call setting_up_syscall

;----#1 syscall
	mov ah,1
	mov ecx,0
	mov cx,letter_upper
	call setting_up_syscall
	
;----#2 syscall
	mov ah,2
	mov ecx,0
	mov cx,letter_lower
	call setting_up_syscall

;----#5 syscall
	mov ah,5
	mov ecx,0
	mov cx,display_str
	call setting_up_syscall

;----#6 syscall
	mov ah,6
	mov ecx,0
	mov cx,do_fork
	call setting_up_syscall

;----#7 syscall
	mov ah,7
	mov ecx,0
	mov cx,do_wait
	call setting_up_syscall

;----#8 syscall
	mov ah,8
	mov ecx,0
	mov cx,do_exit
	call setting_up_syscall

ret

display_center_ouch:
	push ax
	mov ax,0xb800
	mov es,ax 
	mov word [ es:1994],'O'
	mov word [ es:1995],78D
	mov byte [ es:1996],'U'
	mov word [ es:1997],78D
	mov byte [ es:1998],'C'
	mov word [ es:1999],78D
	mov byte [ es:2000],'H'
	mov word [ es:2001],78D
	pop ax
ret

letter_upper:
	mov ax,bp	;backup
	mov bp,sp
	mov bx,[ bp+6]
	mov es,bx
	mov bx,dx	;os.asm.process_int80.push
	mov bp,ax
	mov ax,es
	mov al,[ es:bx] 
	sub al,32D
	mov [ es:bx],al
ret

letter_lower:
	mov ax,bp	;backup
	mov bp,sp
	mov bx,[ bp+6]
	mov es,bx
	mov bx,dx	;os.asm.process_int80.push
	mov bp,ax
	mov ax,es
	mov al,[ es:bx] 
	add al,32D
	mov [ es:bx],al
ret

display_str:
	sti

	mov ax,1301h	;01 只有字符串
	mov bx,78D		;Bh is font color
;	mov dx,1305h	;position
	push bp
	mov bp, dx
	mov dx, cx	;position
	mov cx, 12D

	int 10h
	pop bp

	cli
ret


run_syscall:
	cli
	mov ax,0
	mov es,ax
	mov al,[ syscall_num]
	shl ax,2
	mov bx,0xfe00
	add bx,ax
	call [ es:bx]
	sti
ret

;--data


msg3:
	db 'root@wangqin:~# '
msg3_l equ $-msg3

