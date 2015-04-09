global start
extern _exit
extern _print
start:
; Store 'argc' into EAX
pop     eax
; Store 'argv' into EBX
pop     ebx
; Align stack on a 16 bytes boundary,
	; as we'll use C library functions
	; Call 'printf': printf( hello, ebx, eax );
call   _print
; Call 'exit': exit( 0 );
call   _exit

