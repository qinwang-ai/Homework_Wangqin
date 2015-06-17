org 0x0800

sti
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
jmp loop_k
m_n_r:
call moveright
jmp loop_k


moveleft:
	mov ax,cs
	mov ds,ax
	mov si,[ now_index]
	dec si
	dec si
	mov [ now_index],si
	mov ax,0xb800
	mov es,ax
	mov bx,[now_index]
	mov byte [es:bx],'='
	mov cx,strl
	add bx,cx
	add bx,cx
	mov byte [es:bx],' '
ret
	

moveright:
	mov ax,cs
	mov ds,ax
	mov si,[ now_index]
	inc si
	inc si
	mov [ now_index],si
	mov ax,0xb800
	mov es,ax
	mov bx,[now_index]
	mov byte [es:bx],'='
	mov cx,strl
	sub bx,cx
	sub bx,cx
	mov byte [es:bx],' '
ret


now_index dd 3746D 

str:
	db `=================`
strl equ $-str


times 510-($-$$) db 0
db 0x55,0xaa



