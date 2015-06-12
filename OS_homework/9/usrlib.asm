[bits 16]
extern main		;forbid run this file any time
jmp main



global stosi
stosi:
	mov bp,sp
	mov si,[ bp+4]
ret

global rdtsc_ax
rdtsc_ax:
	rdtsc
ret


