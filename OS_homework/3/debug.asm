org 0x7c00
mov ah,13h      ; 功能号
mov al,1        ; 光标放到串尾
mov bl,0ah      ; 亮绿
mov bh,0        ; 第0页
mov dh,05h      ; 第5行
mov dl,20h      ; 第32列
mov bp,msg3     ; BP=串地址
mov cx,msg_l3  ; 串长为 Length1
int 10h         ; 调用10H号中断

jmp $

msg3:
	db 'Example:1 2 3,1 3 2, 1 3,1 .....'
msg_l3 equ ($-msg3) 

