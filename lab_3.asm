.model small
.stack 256
.data
a dw 1
b dw 2
c dw 3
d dw 4
er db 'Bad input$'
zero_msg db 'Zero division$'
er_count dw 0
er_check dw 5
ms_check dw 0
.code
write proc
push ax
push bx
push cx
push dx
xor cx, cx
xor dx, dx

cmp ax,0
jnz minus_output_check
mov ah, 02h
mov dx, 30h
int 21h
jmp exit

minus_output_check:
cmp ax,0
jg label_div
push ax
mov ah, 02h
mov dx, 45d
int 21h
pop ax
neg ax

xor dx,dx

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

first_symbol:
mov ah, 01h
int 21h

cmp al, 45d
jz minus

jmp checks

another_symbol:
mov ah, 01h
int 21h

checks:
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

minus:
mov ms_check, 1
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
cmp ms_check,1
jz negative
cont:
cmp er_count, bx
jc checked2

lea dx, er
mov ah, 09h
int 21h
jmp exit

negative:
neg ax
jmp cont

checked2:
mov ms_check,0
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

start:
;if
mov ax,a
mov bx,b
cmp ax,bx
jg equal

;if2
mov bx,a
sub bx,b
mov ax,c
xor dx,dx

mov cx,d
cmp cx,0
jz zero_div

cwd
idiv d
cmp bx,ax
jl equal2

mov ax,c
sub ax,a
add ax,d
jmp print

equal2:
mov bx,b
mov ax,c
xor dx,dx

mov cx,a
cmp cx,0
jz zero_div

cwd
idiv cx
add dx,cx
mov ax,dx
cwd
idiv cx
sub bx,dx
mov ax,bx
jmp print

equal:
mov ax,c
sub ax,d
add ax,a

print:
call write
jmp exit

zero_div:
lea dx, zero_msg
mov ah, 09h
int 21h

exit:
mov ax, 4c00h
int 21h
end main