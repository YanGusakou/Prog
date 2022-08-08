.model small
.stack 256
.data
	a dw 1
	b dw 2
	c dw 3
	d dw 4
	er db 'Bad input$'
	er_count dw 0
	er_check dw 5
.code
write proc
        push ax
        push bx
        push cx
        push dx
        xor cx, cx
        xor dx, dx

        label_div:
        mov bx, 10
        div bx
        add dx, 30h		
        inc cx

        push dx
        xor dx, dx

        cmp ax, 0
        jnz label_div

        write_stack:
                pop dx
                mov ah, 02h
                int 21h
        loop write_stack

        pop dx
        pop cx
        pop bx
        pop ax
        ret
write endp

read proc
        push bx
        push cx
        push dx

        another_symbol:
        mov ah, 01h
        int 21h

        cmp al, 13d
        jz label_ret
		
		cmp al, 10d
		jz label_ret

        cmp al, 8d
        jz label_backspace

        cmp al, 30h		
        jc overflow

        cmp al, 3Ah		
        jnc overflow

        sub al, 30h
        xor ah, ah

        push ax
        mov cx, 10
        xor dx, dx
        mov ax, bx
        mul cx
        pop dx
        jc overflow
        add ax, dx
        jc overflow
        mov bx, ax

        jmp another_symbol

        overflow:
		inc er_count
		mov bx, er_check
		cmp er_count, bx
	jc checked
		lea dx, er 
		mov ah, 09h
		int 21h
		jmp exit
	checked:
		jmp another_symbol

        label_backspace:
        mov ax, bx
        xor dx, dx
        mov cx, 10
        div cx
        mov bx, ax

        mov ah, 02h
        mov dl, 32d
        int 21h
        mov dl, 8d   
        int 21h
        jmp another_symbol

        label_ret:
        mov ax, bx
		dec er_check
		mov bx, er_check
		cmp er_count, bx
	jc checked2
	
		lea dx, er 
		mov ah, 09h
		int 21h
		jmp exit
	checked2:
        pop dx
        pop cx
        pop bx
       ret
read endp

main:
mov ax, @data
mov ds, ax

call read
mov a, ax
call read
mov b, ax
call read
mov c, ax
call read
mov d, ax

mov ax, a
or ax, c
mov bx, b
xor bx, d
cmp ax, bx
je if_1
	
	mov ax, a
	add ax, b
	mov bx, c
	xor bx, d
	cmp ax, bx
	je if_2
		
		mov ax, a
		mov bx, b
		add bx, c
		xor ax, bx
		or ax, d
 		jmp print
	if_2:
	mov ax, a
	and ax, d
	mov bx, b
	add bx, c
	or ax, bx
	jmp print
if_1:
mov ax, a
xor ax, b
xor ax, c
add ax, d

print:
	call write
exit:
mov ax, 4c00h
int 21h
end main

 
		