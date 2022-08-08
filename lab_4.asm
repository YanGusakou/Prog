.model small

.stack 100h

.data

inputStr db 100, 100 dup ('$')
inputStr_Length dw 0

s db 100, 100 dup ('$')
s_Length dw 0

t db 100, 100 dup ('$')
t_Length dw 0

pi db 100 dup (0)

yes db "yes", 10, '$'
no db "no", 10, '$'

.code

start:

	MOV AX, @data
	MOV DS, AX


	MOV ES, AX
	MOV DS, AX
	XOR SI, SI
	LEA SI, inputStr

	lCycle1:

		MOV AH, 01h
		INT 21h

		CMP AL, 13 
		JE lNext1

		CMP AL, 10 
		JE lNext1

		CMP AL, 8 
		JE lBackspace

		MOV inputStr[SI], AL
		INC SI
		INC inputStr_Length

		JMP lCycle1

	lBackspace:

	CMP inputStr_Length, 0
	JZ lCycle1
	MOV AH, 02h
	MOV DL, 32 
	INT 21h
	MOV DL, 8 ; Backspace
	INT 21h
	MOV inputStr[SI], '$'
	DEC inputStr_Length
	DEC SI

	JMP lCycle1


	lNext1:


	XOR SI, SI
	XOR DI, DI
	LEA SI, s
	LEA DI, inputStr

	lCycle2:

		CMP inputStr[DI], 32 
		JE lNext2

		MOV AL, [DI]
		MOV [SI], AL
		INC DI
		INC SI
		INC s_Length

		JMP lCycle2

	lNext2:

 	XOR SI, SI
	LEA SI, t

	lCycle3:

		INC DI

		CMP DI, inputStr_Length
		JE lNext3

		MOV BL, [DI]
		MOV [SI], BL
		INC SI
		INC t_Length

		JMP lCycle3
lNext3:

 MOV SI, 1 ; SI = i, j = AL
cycle4:
 CMP SI, s_Length
 JE lNext4
 DEC SI
 MOV AL, pi[SI]
 INC SI
cycle5:
 CMP AL, 0
 JZ lNext5
 XOR AH, AH
 MOV DI, AX
 MOV BL, s[SI]
 CMP s[DI], BL
 JE lNext5
 PUSH AX
 DEC AL
 XOR AH, AH
 MOV DI, AX
 POP AX
 MOV AL, pi[DI]
 JMP cycle5
lNext5:
 XOR AH, AH
 MOV DI, AX
 MOV BL, s[DI]
 CMP BL, s[SI]
 JNE skip
 INC AL
skip:
 MOV pi[SI], AL
 INC SI
 JMP cycle4

lNext4:
 XOR BX, BX
 XOR SI, SI
 XOR AX, AX
cycle6:
 CMP SI, t_Length
 JE lNext6
 CMP AX, s_Length
 JE lNext6
 MOV DI, AX
 MOV BL, s[DI]
 CMP t[SI], BL
 JNE lElse1
 INC SI
 INC AL
 JMP cycle6
lElse1:
 CMP AL, 0
 JZ lElse2
 PUSH AX
 DEC AL
 XOR AH, AH
 MOV DI, AX
 POP AX
 MOV AL, pi[DI]
 JMP cycle6
lElse2:
 INC SI
 JMP cycle6
lNext6:
 CMP AX, s_Length
 JNE lno
 LEA DX, yes
 JMP exit_from_prog
lno:
 LEA DX, no

exit_from_prog: 
 MOV AH, 09h
 INT 21h
	MOV AX, 4C00h
	INT 21h
 
end start