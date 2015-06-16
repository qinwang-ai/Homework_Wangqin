org 0x1000		;加载到 e0000内存中执行
;org 0x100		;加载到 e0000内存中执行

int 33h
int 34h
int 35h
int 36h


;LISTEN_EXIT----
listen:
	mov ah,0
	int 16h

ret

times 512-($-$$) db 0	;填充剩余扇区0


