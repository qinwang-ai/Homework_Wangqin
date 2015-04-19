org 0x1000		;加载到 e0000内存中执行
;org 0x100		;加载到 e0000内存中执行



;#0
mov ah,0
int 80h

;LISTEN_EXIT----
listen0:
	mov ah,0
	int 16h


;#2
mov ax,0xb800
mov es,ax
mov dx,1994D
mov ah,2
int 80h

;LISTEN_EXIT----
	mov ah,0
	int 16h

;#1
mov ax,0xb800
mov es,ax
mov dx,1994D
mov ah,1
int 80h

;LISTEN_EXIT----
	mov ah,0
	int 16h



;#5
mov ax,cs
mov ds,ax
mov es,ax

mov cx,0317h  ;position
mov ah,5
mov dx,msg
int 80h


;LISTEN_EXIT----
listen:
	mov ah,0
	int 16h

ret



msg:
	db "hello world!"

times 512-($-$$) db 0	;填充剩余扇区0


