model small; 58 STROKAAAAAAAAAAAAAAAAAA
.stack 100h
.data
numm db 26
bigs db 0; big symbol
smalls db 0; small symbol
digit db 0; digit symbol
tocompare db 0
i dw 0
j  dw 0
escaped dw 1
.code

chng proc
cmp escaped, 1
je turntozero
mov escaped, 1
jmp chng_ret
turntozero :
mov escaped, 0
chng_ret :
    ret
    chng endp

    checkal proc
    mov numm, 26
    mov smalls, 0
    mov bigs, 0
    mov digit, 0
    cmp al, 'a'; if lower than a, maybe it's a digit or a big letter
    jl big
    cmp al, 'z'; there's no changeable symbols after z
    jg do_not_encrypt
    mov smalls, 1; symbol is small
    jmp fine
    big :
cmp al, 'A'; if lower maybe it is a digit
jl num
cmp al, 'Z'
jg do_not_encrypt
mov bigs, 1
jmp fine
num :
mov numm, 10
cmp al, '0'
jl do_not_encrypt
cmp al, '9'
jg do_not_encrypt
mov digit, 1; symbol is digit
jmp fine
fine : ; there is no need to do anything but showing our symbol
    ret
    checkal endp

    start :
mov ax, @data
mov escaped, 0
mov j, 0; amount of moves
input1 :
mov ah, 10h; we press the button with our shalovlivymi fingers
int 16h; and pressed symbol goes to the program in register 'al'
mov dl, al; our input symbol is now ready to be shown
cmp al, 10; unix enter check(potomu chto mogu)
je ex1; enter is key to exit the program
cmp al, 13; windows enter check
je ex1
cmp al, 27; 1Bh or 27 is escape
jne do_not_change_mode; if we dont press escape, mode doesn't change
call chng; else we start / stor encryption
jmp input1
do_not_change_mode : ; Nice.
    cmp escaped, 1; check if encryption mode is OFF
    je do_not_encrypt
    jmp nospace
    do_not_encrypt : ; just send to symbol output
    jmp output; send to output
    nospace :
call checkal; finding out whether symbol is big or small, or is it a digit
mov bx, j; fixed value, our move along alphabet
mov i, bx; i is counter, there is a cycle
cmp i, 0; if you want to encrypt message by 0, you're sick asshole
je output1; but i can do it for you;)
sdvig:
inc dl; increase our symbol
cmp smalls, 1
je dosmall; finding out which alphabet to compare
jmp bigg
dosmall : ; alphabet of small letters
    mov tocompare, 'z'
    jmp nokostyl
    output1 :
jmp output
ex1 : ; jmp out of range protection
    jmp exit
    input :
mov cx, 2
jmp input1
nokostyl :
bigg:
cmp bigs, 1
je dobig
jmp diggit
dobig : ; alphabet of big digits
    mov numm, 26
    mov tocompare, 'Z'
    diggit:
cmp digit, 1
je dodigit
jmp compared
dodigit : ; digits from 0 to 9
    mov numm, 10
    mov tocompare, '9'

    compared:
cmp dl, tocompare; compare symbol with border of alphabet('z', 'Z', '9')
jg decr
jmp sdvig1
decr : ; decrease symbol by 26 or 10 (26 or 10 has been chosen
    sub dl, numm; a few strings higher
    dec i; decrease counter
    cmp i, 0; if i(counter, i hope you remember) comes to 0,
    jg sdvig; we go to output, else we


    output :
mov ah, 02h;   it's 3 a.m. and i zaebalsa
int 21h

loop input
exit :
mov ax, 4c00h
int 21h

outofrange :
ret; i hope you understand what happens around
jmp decr

sdvig1 :
sub i, 1
cmp i, 0
jg sdvig
jmp output

checkdl proc; descriprion on line 25 and next

mov numm, 26
cmp dl, 'a'
jl big1
cmp dl, 'z'
jg outofrange
jmp fine1
big1 :
cmp dl, 'A'
jl num1
cmp dl, 'Z'
jg outofrange
jmp fine1
num1 :
mov numm, 10
cmp dl, '0'
jl outofrange
cmp dl, '9'
jg outofrange
jmp fine1
fine1 :
ret
checkdl endp

end start