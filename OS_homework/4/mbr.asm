org 7c00h
mov ax,cs
mov ds,ax
mov es,ax

;load os to mem
xor ax,ax
mov es,ax ;made es zero,ex:bx is addr of mem 
mov bx,8100h
mov ax,0201h
mov dx,0
mov cx,0002h;扇区号为2
int 13h

jmp 8100h

times 510-($-$$) db 0
db 0x55,0xaa


