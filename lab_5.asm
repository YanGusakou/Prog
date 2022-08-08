.model small
.stack 100h
.data
array db ?
array_one db 10 dup(10 dup(?))
array_two db 10 dup(10 dup(?))
result_array dw 10 dup(10 dup(0))
n db 10
ten dw 10
two dw 2
stackreturn dw 0
string db "error$"
.code


WriteLet proc

mov dx,0
nextletter:
    
mov ah,01h
int 21h
CMP al,0Ah
jz strend
cmp al, 0Dh
je strend
CMP al,20h
jz space
  
sub al,30h
push ax
mov ax,dx
mul ten
mov dx,ax
        
pop ax
add dl,al
            
jmp nextletter
space:
strend:
ret
    
WriteLet endp



Enterarray_one proc

mov dl,n
mov cx,dx
mov bx,0
mov si,0

ExtLoop1:
    
push cx
mov cl,n
InLoop1:
call WriteLet

mov array_one[si],dl
        inc si
    
loop InLoop1
pop cx
inc bx
loop ExtLoop1
ret
    
Enterarray_one endp


Enterarray_two proc

mov dl,n
mov cx,dx
mov bx,0
mov si,0
    
ExtLoop21:
    
push cx
mov cl,n
InLoop21:
call WriteLet
mov array_two[si],dl
inc si
loop InLoop21
pop cx
inc bx
loop ExtLoop21
ret
Enterarray_two endp    



WriteArrayProc proc

mov cx,0
mov cl,n
mov bx,0
mov si,0
    
ExtLoop2:
    
push cx
mov cl,n
        
InLoop2:
        
mov ax,0
mov ax,result_array[si]
inc si
inc si
call WriteWordProc
mov ah,02h
mov dl,020h          
int 21h
            
loop InLoop2
mov ah,02h
mov dl,0AH
int 21h

inc bx
pop cx
        
loop ExtLoop2
ret
    
WriteArrayProc endp



WriteWordProc proc

push cx
mov cx,0
Digit:
    
mov dx,0
div ten
inc cx
add dx,30h
push dx
cmp ax,0
jz PopFromStack1
jmp Digit
    
PopFromStack1:
    
pop dx
mov ah,02h
int 21h
loop PopFromStack1
pop cx
ret
    
WriteWordProc endp



start:

mov ax,@data
mov ds,ax

call WriteLet
mov n,dl
call Enterarray_one
call Enterarray_two
mov bx,0
mov ax,0
mov al,n
mul ax
mov cx,ax
mov di,0
mov dl,n
mov si,0
mov si,0
  
MulInLoop:
        
push cx
mov cx,0
mov cl,n
            
MulInLoop2:
            
mov al,array_one[bx]
push bx
mov bx,0
mov bl,array_two[di]
mul bx
push ax
mov ax,si
mul two
mov bx,ax
pop ax
add result_array[bx],ax
mov bh,0
mov bl,n
add di,bx
pop bx
inc bx
                
loop MulInLoop2
inc si
mov dx,0
mov ax,si
mov cl,n
div cx
mov di,dx
mul cx
mov bx,ax
pop cx
            
loop MulInLoop
        
call WriteArrayProc 
       
mov ah,04ch
int 21h
end start