mov ax, 0x07C0  ; set up segments
mov ds, ax
mov es, ax

mov si, welcome
call print_string

welcome db 'Welcome to My!'
buffer times 64 db 0

print_string:
lodsb        ; grab a byte from SI

or al, al  ; logical or AL by itself
jz .done   ; if the result is zero, get out

mov ah, 0x0E
int 0x10      ; otherwise, print out the character!

jmp print_string

.done:
ret

;dw 0AA55h ; some BIOSes require this signature

