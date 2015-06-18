org 0x1800

sti

loop_k:
mov ah,0
int 16h

mov ah,27D
cmp al,ah
je m_n_l
jmp loop_k
m_n_l:
setdi:
mov di,0x1234
jmp setdi

jmp loop_k


times 510-($-$$) db 0
db 0x55,0xaa



