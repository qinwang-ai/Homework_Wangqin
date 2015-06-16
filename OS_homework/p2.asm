org 0x7c00
print_str:
	push bp
	mov bp,str
	mov cx,strl
	mov ax,1301h
	mov bx,78D
	mov dx,1220h
	int 10h
	pop bp

loop_k:
mov ah,0
int 16h
mov ah,97D
cmp al,ah
je m_n_l
mov ah,100D
cmp al,ah
je m_n_r

jmp loop_k
m_n_l:
call moveleft
m_n_r:
call moveright
jmp loop_k


moveleft:
	mov ax,cs
	mov ds,ax
	mov di,[ now_index]
	dec di
	dec di
	mov [ now_index],di
	mov ax,0xb800
	mov es,ax
	mov bx,now_index
	mov byte [es:bx],'='
	mov cx,strl
	add bx,cx
	mov byte [es:bx],' '
ret
	

moveright:



now_index dd 2442D 

str:
	db '================='
strl equ $-str




