charstack:       
jmp short charstart
table dw charpush,charpop,charshow

top dw 0             ;栈顶
charstart:    push bx
push dx
push di
push es

cmp ah,2
ja sret
mov bl,ah
mov bh,0
add bx,bx
jmp word ptr table[bx]

charpush:    mov bx,top
mov [si][bx],al
inc top
jmp sret


charpop:     cmp top,0
je sret
dec top
mov bx,top
mov al,[si][bx]
jmp sret
charshow:   mov bx,0b800b
mov es,bx
mov al,160
mov ah,0
mul dh
mov di,ax
add dl,dl
add di,dx
mov bx,0
charshows: cmp bx,top
jne noempty
mov byte ptr es:[dl],' '
jmp sret
noempty:     mov al,[si][bx]
mov es:[di],al
mov byte ptr es:[di+2], ' '
inc bx
add di,2
jmp charshows
sret:        pop es
pop di
pop dx
pop bx
ret


