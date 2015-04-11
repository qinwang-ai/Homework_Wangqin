org 0x1000		;加载到 e0000内存中执行
;org 0x100		;加载到 e0000内存中执行

int 33h
int 34h
int 35h
int 36h


;LISTEN_EXIT----
mov ah,0x00
int 0x16

ret

times 512-($-$$) db 0	;填充剩余扇区0


