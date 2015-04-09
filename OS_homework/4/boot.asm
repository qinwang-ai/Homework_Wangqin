org 7c00h
mov ax,cs
mov ds,ax
mov es,ax

;load os to mem
xor ax,ax
mov es,ax ;made es zero,ex:bx is addr of mem 
mov bx,7e00h ;add to 7e00 mem
mov ax,0214h	;count 
mov dx,0
mov cx,0002h;扇区号为2
int 13h

jmp 7e00h

times 510-($-$$) db 0
db 0x55,0xaa


