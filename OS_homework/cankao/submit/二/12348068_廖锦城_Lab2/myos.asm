;
;   本文件为引导后启动的操作系统的源码文件。
;
    org 9000h 		; 告诉编译器程序加载到7C00H处
	mov ax,cs 		; 初始化数据段与附加段寄存器与代码段的相同
	mov ds,ax
	mov es,ax
	call ReadPro1 	; 读入程序 1 到内存
	call ReadPro2   ; 读入程序 2 到内存
	call ReadPro3   ; 读入程序 3 到内存
	call Main       ; 读取主函数

Main: ; 可视为主函数
    call Clear      ; 清屏
	call ReInit     ; 将变量重新初始化
	call DispStr 	; 调用显示字符串
	jmp Keyin       ; 等待用户进行输入选择

DispStr: ; 显示字符串
; 显示字符串1 "Chen-OS 1.0"（开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ah 	    ; 亮绿
	mov bh,0 		; 第0页
	mov dh,05h 	    ; 第5行
	mov dl,20h 	    ; 第32列
	mov bp,str1 	; BP=串地址
	mov cx,Length1 	; 串长为 Length1
	int 10h 		; 调用10H号中断
; 显示字符串1（结束）
; 显示字符串2 "(C) 2014  liaojch3"（开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0dh 	    ; 黑底品红字
	mov bh,0 		; 第0页
	mov dh,07h 	    ; 第7行
	mov dl,1eh 	    ; 第 30 列
	mov bp,str2 	; BP=串地址
	mov cx,Length2 	; 串长为 Length2
	int 10h 		; 调用10H号中断
; 显示字符串2（结束）
; 显示字符串3 "We have total 3 program: Program 1  program 2 Program 3"
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ch 	    ; 黑底红字
	mov bh,0 		; 第0页
	mov dh,0ah 	    ; 第10行
	mov dl,10 		; 第 10 列
	mov bp,str3 	; BP=串地址
	mov cx,Length3 	; 串长为 Length3
	int 10h 		; 调用10H号中断
; 显示字符串3（结束）
; 显示字符串4 (开始）
	mov ah,13h  	; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ch 	    ; 黑底红字
	mov bh,0 		; 第0页
	mov dh,0ch 	    ; 第12行
	mov dl,8 		; 第 8 列
	mov bp,str4 	; BP=串地址
	mov cx,Length4 	; 串长为 Length4
	int 10h 		; 调用10H号中断
; 显示字符串4（结束）
; 显示字符串5 (开始)
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ch 	    ; 黑底红字
	mov bh,0 		; 第0页
	mov dh,0dh 	    ; 第13行
	mov dl,25 		; 第 37 列
	mov bp,str5	    ; BP=串地址
	mov cx,Length5 	; 串长为 Length5
	int 10h 		; 调用10H号中断
; 显示字符串5（结束）
; 显示字符串6(开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ch 	    ; 黑底红字
	mov bh,0 		; 第0页
	mov dh,0fh 	    ; 第14行
	mov dl,10 		; 第 10 列
	mov bp,str6	    ; BP=串地址
	mov cx,Length6 	; 串长为 Length6
	int 10h 		; 调用10H号中断
; 显示字符串6（结束）
; 显示字符串7(开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ch 	    ; 黑底红字
	mov bh,0 		; 第0页
	mov dh,10h 	    ; 第16行
	mov dl,25 		; 第37列
	mov bp,str7	    ; BP=串地址
	mov cx,Length7 	; 串长为 Length7
	int 10h 		; 调用10H号中断
; 显示字符串7（结束）
; 显示字符串8(开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ch 	    ; 黑底红字
	mov bh,0 		; 第0页
	mov dh,13h 	    ; 第19行
	mov dl,25 		; 第37列
	mov bp,str8	    ; BP=串地址
	mov cx,Length8 	; 串长为 Length8
	int 10h 		; 调用10H号中断
; 显示字符串8（结束）
	ret 			; 返回调用处

ReadPro1: ; 读入程序1（软盘第4个扇区）到内存7E00H处）
	xor ax,ax 		; 相当于mov ax,0
	mov es,ax 		; ES=0
	mov bx,7e00H    ; ES:BX=读入数据到内存中的存储地址
	mov ah,2 		; 功能号
	mov al,1 		; 要读入的扇区数 1
	mov dl,0 		; 软盘驱动器号（对硬盘和U盘，此处的值应改为80H）
	mov dh,0 		; 磁头号
	mov ch,0 		; 柱面号
	mov cl,4 		; 起始扇区号（编号从1开始）
	int 13H 		; 调用13H号中断
	ret 			; 返回

ReadPro2: ; 读入程序2（软盘第5个扇区）到内存8000H处
	xor ax,ax 		; 相当于mov ax,0
	mov es,ax 		; ES=0
	mov bx,8000H    ; ES:BX=读入数据到内存中的存储地址
	mov ah,2 		; 功能号
	mov al,1 		; 要读入的扇区数
	mov dl,0 		; 软盘驱动器号（对硬盘和U盘，此处的值应改为80H）
	mov dh,0 		; 磁头号
	mov ch,0 		; 柱面号
	mov cl,5 		; 起始扇区号（编号从1开始）
	int 13H 		; 调用13H号中断
	ret 			; 从例程返回

ReadPro3: ; 读入程序 3（软盘第6个扇区）到内存8200H处
	xor ax,ax 		; 相当于mov ax,0
	mov es,ax 		; ES=0
	mov bx,8200H    ; ES:BX=读入数据到内存中的存储地址
	mov ah,2 		; 功能号
	mov al,1 		; 要读入的扇区数
	mov dl,0 		; 软盘驱动器号（对硬盘和U盘，此处的值应改为80H）
	mov dh,0 		; 磁头号
	mov ch,0 		; 柱面号
	mov cl,6 		; 起始扇区号（编号从1开始）
	int 13H 		; 调用13H号中断
	ret 			; 返回

Keyin:
    mov ah,0 	    ; 功能号
	int 16h 	    ; 调用16H号中断
	cmp al,0dh      ; 判断是否是回车，回车的 Ascii 码为 0dh(13)
	je Excute       ; 开始执行用户选择的程序顺序
	jmp showch      ; 没有回车，则显示用户键入的字符
	
showch: ; 显示键入字符
	mov ah,0eh 	    ; 功能号
	mov bl,0 		; 对文本方式置0
	int 10h 		; 调用10H号中断
	jmp Continue

Continue:  ; 继续执行
	inc word[i]     ; i++
	mov ah,0        ; ah 置零
	cmp word[i],4   ; 判断用户是否键入超过 3 个字符
	je Main         ; 超过 3 个则进行刷新显示
	cmp word[i],2   ; 是否是输入的第二个字符(i = 2)
	je I2           ; 跳转到 I2，存储第二个字符到 y
	cmp word[i],3   ; 是否是输入的第三个字符
	je I3           ; 跳转到 I3，存储第三个字符到 z
	mov word[x],ax  ; 以上不成立，则是第一个字符，存入 x 
	jmp Keyin       ; 跳转到准备接受下一个输入处
I2: mov word[y],ax  ; 存储第二个字符到 y
    jmp Keyin       ; 跳转到准备接受下一个输入处
I3: mov word[z],ax  ; 存储第三个字符到 z
    jmp Keyin       ; 跳转到准备接受下一个输入处

Excute:  ; 开始执行用户选择的程序
    mov ax,0        ; ax 置零
CMP1:    ;判断用户选择的第一个程序是否执行
	cmp word[x],ax  ; 判断 x 是否为 0，0 代表执行过
	je CMP2         ; x 为 0 则开始判断 y
	jmp Ex1         ; x 不为 0 开始执行用户选择的第一个程序
Ex1:  ;执行用户选择的第一个程序
    mov ax,word[x]  ; 把 x 放到 ax
    mov word[cur],ax; 把 ax 放到 cur 变量
	mov ax,0        ; ax 置零
	mov word[x],ax  ; ax 放到 x, 将 x 清零
	call Run        ; 开始执行
	jmp Excute      ; 执行完继续跳转到 Excute
CMP2:  ;判断用户选择的第二个程序是否执行
    cmp word[y],ax  ; 判断 y 是否为 0,0 代表执行过
	je CMP3         ; y 为 0 开始判断 z
	jmp Ex2         ; y 不为 0 开始执行用户选择的第二个程序
Ex2:  ;执行用户选择的第二个程序
    mov ax,word[y]  ; 把 y 放到 ax
	mov word[cur],ax; ax 放到 cur
	mov ax,0        ; ax 置零
	mov word[y],ax  ; ax 放到 y ,将 y 置零
	call Run        ; 开始调用
	jmp Excute      ; 执行完继续跳转到 Excute
CMP3: ;判断用户选择的第三个程序是否执行
    cmp word[z],ax  ; z 是否为 0
	je END          ; 若 z 也为 0，则没有程序等待执行，结束本次调用
	jmp Ex3         ; 执行用户选择的第三个程序
Ex3:  ;执行用户选择的第三个程序
    mov ax,word[z]  ; z 放到 ax
	mov word[cur],ax; ax 放到 cur
	mov ax,0        ; ax 置零
	mov word[z],ax  ; z 置零，标记为执行过
	call Run        ; 开始执行
	jmp Excute      ; 执行完继续跳转到 Excute
END:  ;本次用户选择的程序已调用完
	call Clear      ; 清屏
	jmp Main        ; 回到主函数，相当于把控制权交给操作系统

Run:  ; 执行当前用户程序
    mov ax,word[cur]; 把 cur 装载到 ax  
    cmp ax,49       ; 判断当前是否应该执行程序 1，49 为 1 的 ascii 码
	je R1           ; 是则开始执行程序 1
	cmp ax,50       ; 判断当前是否应该执行程序 2，50 为 2 的 ascii 码
	je R2           ; 是则开始执行程序 2
	cmp ax,51       ; 判断当前是否应该执行程序 3，51 为 3 的 ascii 码
	je R3           ; 是则开始执行程序 3
	ret             ; 执行完成，返回
R1:  ; 执行程序 1
    call dword 7e00h; 从内存中 7e00h 调用程序 1 
	ret             ; 返回
R2:  ; 执行程序 2
    call dword 8000H; 从内存中 8000h 调用程序 2
	ret             ; 返回
R3:  ; 执行程序 3
	call dword 8200H; 从内存中 8200H 调用程序 3
	ret             ; 返回

Clear:  ; 清屏
    mov ax,0003H    ; 设置清屏属性
    int 10H         ; 功能号
	ret             ; 返回

ReInit:  ;对变量进行重新初始化
    mov ax,0        ; ax 置零
	mov word[x],ax  ; x 置零
	mov word[y],ax  ; y 置零
	mov word[z],ax  ; z 置零
	mov word[i],ax  ; i 置零
	mov word[cur],ax; cur 置零
	ret             ; 返回

Data:  ; 数据定义
    x dw 0          ; 声明 x ，x 代表用户输入第一个字符
	y dw 0          ; 声明 y , y 代表用户输入的第二个字符
	z dw 0          ; 声明 z , z 代表用户输入的第三个字符
	i dw 0          ; 声明 i , i 为用户已经输入的字符数
	cur dw 0        ; 声明 cur ，cur 为当前应该调用的程序

str1: ; 字符串1
	db "Chen-OS 1.0"
Length1: equ ($-str1)  ; 字符串 1 的长度
str2: ; 字符串2
	db "(C) 2014 liaojch3"
Length2: equ ($-str2)  ; 字符串 2 的长度
str3: ; 字符串3
	db "We have total 3 program: Program 1  program 2 Program 3"
Length3: equ ($-str3)  ; 字符串 3 的长度
str4: ; 字符串4
	db "Please choose one, two or three program with the order you want"
Length4: equ ($-str4)  ; 字符串 4 的长度
str5: ; 字符串5
	db "Then press the Enter"
Length5: equ ($-str5)  ; 字符串 5 的长度
str6: ; 字符串6
	db "Notice that input with no space,like key in 12 or 231."
Length6: equ ($-str6)  ; 字符串 6 的长度
str7: ; 字符串7
	db "Then the os will excute it."
Length7: equ ($-str7)  ; 字符串 7 的长度
str8: ; 字符串8
	db "Please Key in here:"
Length8: equ ($-str8)  ; 字符串 8 的长度
	times 1024-($-$$) db 0 ; 用0填充剩余部分
					; （$=当前地址、$$=当前节地址）
	;db 55h,0aah 	; 启动扇区的结束标志

