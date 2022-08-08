model small
.stack 100h

.data
a dw ?
b dw ?
c dw ?
d dw ?

.code

start:
mov ax, @data
mov ds, ax

;<readABCD>
mov ax, a
or ax, b
mov bx, c
sub bx, d
cmp ax, bx
je first_way

mov ax, a
add ax, b
mov bx, c
sub bx, d
cmp ax, bx
je second_way

mov ax, a
or ax, b
mov bx, c
or bx, d
xor ax, bx
jmp out_prog

first_way:
mov ax, c
or ax, d
mov bx, b
and bx, d
add ax, bx
jmp out_prog

second_way:
mov ax, a
xor ax, b
mov bx, c
xor bx, d
or ax, bx

out_prog:
;<print>
mov ah, 4ch
int 21h
end start