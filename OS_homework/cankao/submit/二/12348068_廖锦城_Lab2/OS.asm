;
;   本文件为 COM 文件的源码文件
;
    org 100h 		; 告诉编译器程序加载到100H处
	mov ax,cs 		; 初始化数据段与附加段寄存器与代码段的相同
	mov ds,ax
	mov es,ax
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

	ret 			; 返回调用处

Keyin:  ;读取用户输入的选择
    mov ah,0 	    ; 功能号
	int 16h 	    ; 调用16H号中断
	cmp al,0dh      ; 判断是否是回车，回车的 Ascii 码为 0dh(13)
	je Excute       ; 开始执行用户选择的程序顺序
	cmp al,1bh
	je Quit
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
	jmp Main        ; 回到主函数

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
    call Program1   ; 调用程序 1 
	ret             ; 返回
R2:  ; 执行程序 2
    call Program2   ; 调用程序 2
	ret             ; 返回
R3:  ; 执行程序 3
	call Program3   ; 调用程序 3
	ret             ; 返回

Clear:  ; 清屏
    mov ax,0003H    ; 设置清屏属性
    int 10H         ; 功能号
	ret             ; 返回

Quit: ;退出系统，回到 cmd
    ret

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

str1: ; 字符串定义
	db "Chen-OS 1.0"
	db 0ah,0dh
	db "                             (C) 2014 liaojch3"
	db 0ah,0dh
	db 0ah,0dh
	db "             We have total 3 program: Program 1  program 2 Program 3"
	db 0ah,0dh
	db 0ah,0dh
	db "            Please choose one, two or three program with the order you want"
	db 0ah,0dh
	db "                         Then press the Enter"
	db 0ah,0dh
	db 0ah,0dh
	db "            Notice that input with no space,like key in 12 or 231."
	db 0ah,0dh
	db "                       Then the os will excute it."
	db 0ah,0dh
	db 0ah,0dh
	db "                          Press the Esc twice to quit."
	db 0ah,0dh
	db 0ah,0dh
	db "                           Please Key in here:"
Length1: equ ($-str1)  ; 字符串的长度


Program1:  ;用户程序 1 
START1:
	call Clear      ; 清屏
	call DispStr1	; 显示字符串
	call Key        ; 接受用户任意输入
	ret 			; 返回

DispStr1: ; 显示字符串
; 显示字符串 "Hello, Here is Program 1 ~"（开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ch 	    ; 黑底红字
	mov bh,0 		; 第0页
	mov dh,05h 	    ; 第5行
	mov dl,1ch 	    ; 第28列
	mov bp,BootMsg1 ; BP=串地址
	mov cx,Length11	; 串长为Length11
	int 10h 		; 调用10H号中断
; 显示字符串（结束）
; 显示字符串2 "Please Key in Esc to quit:"（开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0dh 	    ; 黑底品红字
	mov bh,0 		; 第0页
	mov dh,07h 	    ; 第7行
	mov dl,1ch 	    ; 第28列
	mov bp,Tips1 	; BP=串地址
	mov cx,Length12 ; 串长
	int 10h 		; 调用10H号中断
; 显示字符串2（结束）
	ret

Key: ; 读按键
	mov ah,0 		; 功能号
	int 16h 		; 调用16H号中断
    ret             ; 退出

BootMsg1: ; 欢迎字符串
	db "Hello. Here is Program 1 ~ "
Length11: equ ($-BootMsg1) ; 欢迎字符串的长度
Tips1: ; 退出提示
	db "Press Key to quit..."
Length12: equ ($-Tips1)    ; 提示的长度



Program2:  ;用户程序2
START2:
	call Clear
	call DispStr2	; 显示字符串
	call Key        ; 接受用户输入
	ret 			; 无限循环

DispStr2: ; 显示字符串
; 显示字符串 "Haha. This is Program 2 ~ "（开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ch 	    ; 黑底红字
	mov bh,0 		; 第0页
	mov dh,05h 	    ; 第5行
	mov dl,1ch 	    ; 第28列
	mov bp,BootMsg2 ; BP=串地址
	mov cx,Length21	; 串长为Length21
	int 10h 		; 调用10H号中断
; 显示字符串（结束）
; 显示字符串2 "Please Key in Esc to quit:"（开始）
	mov ah,13h 	    ; 功能号
	mov al,1 	    ; 光标放到串尾
	mov bl,0dh 	    ; 黑底品红字
	mov bh,0 	    ; 第0页
	mov dh,07h 	    ; 第7行
	mov dl,1ch 	    ; 第28列
	mov bp,Tips2    ; BP=串地址
	mov cx,Length22 ; 串长
	int 10h     	; 调用10H号中断
; 显示字符串2（结束）
	ret

BootMsg2: ; 欢迎字符串
	db "Haha. This is Program 2 ~ "
Length21: equ ($-BootMsg2)
Tips2: ; 退出提示
	db "Press key to quit..."
Length22: equ ($-Tips2)

Program3:  ;用户程序 3
START3:
	call Clear
	call DispStr3	; 显示字符串
	call Key        ; 接受用户输入
	ret 			; 退出

DispStr3: ; 显示字符串
; 显示字符串 "Hello, Here is Program 1 ~"（开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0ch 	    ; 黑底红字
	mov bh,0 		; 第0页
	mov dh,05h    	; 第5行
	mov dl,1ch    	; 第28列
	mov bp,BootMsg3 ; BP=串地址
	mov cx,Length31	; 串长为Length31
	int 10h 		; 调用10H号中断
; 显示字符串（结束）
; 显示字符串2 "Please Key in Esc to quit:"（开始）
	mov ah,13h 	    ; 功能号
	mov al,1 		; 光标放到串尾
	mov bl,0dh 	    ; 黑底品红字
	mov bh,0 		; 第0页
	mov dh,07h 	    ; 第7行
	mov dl,1ch 	    ; 第28列
	mov bp,Tips3 	; BP=串地址
	mov cx,Length32 ; 串长
	int 10h 		; 调用10H号中断
; 显示字符串2（结束）
	ret

BootMsg3: ; 欢迎字符串
	db "Hi, I'm Program 3 ~ "
Length31: equ ($-BootMsg3)
Tips3: ; 退出提示
	db "Press Key to quit..."
Length32: equ ($-Tips3)

    times 2048-($-$$) db 0 ; 用0填充扇区的剩余部分

