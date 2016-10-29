TITLE Math Program  (template.asm)

; Author: Holly Buteau
; Course / Project ID     CS 271/Project 01           Date: June 24, 2016
; Description: This program will calculate the sum, difference, product, quotient, and remainder of two numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)



.data

; (insert variable definitions here)
userName	BYTE	33	DUP(0)
userNum1	DWORD	?
userNum2	DWORD	?
intro_1		BYTE	"Name : Holly Buteau", 0
intro_2		BYTE	"Program Title : Assignment 1" , 0
prompt_1	BYTE	"You will enter 2 numbers and I will perform some calculations with them ", 0
prompt_2	BYTE	"Please enter the first number ", 0
prompt_3	BYTE	"Please enter the second number ", 0
sumNum		DWORD	?
diffNum		DWORD	?
productNum	DWORD	?
quotientNum	DWORD	?
remainder	DWORD	?
result_1	BYTE	"The sum of the two numbers is: ", 0
result_2	BYTE	"The difference of the two numbers is: ", 0
result_3	BYTE	"The product of the two numbers is: ", 0
result_4	BYTE	"The quotient of the two numbers is: ", 0
result_5	BYTE	"The remainder of the two numbers is: ", 0
goodBye		BYTE	"Good-bye!", 0

.code
main PROC

; (insert executable instructions here)

;Introduce programmer and assignment
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf


;Give instructions
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	CrLf

;Get userNum1
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		userNum1, eax

;Get userNum2
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	ReadInt
	mov		userNum2, eax

; Calculate sum
	mov		eax, userNum1
	add		eax, userNum2
	mov		sumNum, eax

;Calculate difference
	mov		eax, userNum1
	sub		eax, userNum2
	mov		diffNum, eax

;Calculate product 
	mov		eax, userNum1
	mov		ebx, userNum2
	mul		ebx
	mov		productNum, eax

;Calculate quotient and remainder
	mov		eax, userNum1
	cdq
	mov		ebx, userNum2
	div		ebx
	mov		quotientNum, eax
	mov		remainder, edx

;Report Sum Result
	mov		edx, OFFSET result_1
	call	WriteString
	mov		eax, sumNum
	call	WriteDec
	call	CrLf

;Report Difference Result
	mov		edx, OFFSET result_2
	call	WriteString
	mov		eax, diffNum
	call	WriteDec
	call	CrLf

;Report Product Result
	mov		edx, OFFSET result_3
	call	WriteString
	mov		eax, productNum
	call	WriteDec
	call	CrLf

	
;Report Quotient and Remainder Result
	mov		edx, OFFSET result_4
	call	WriteString
	mov		eax, quotientNum
	call	WriteDec
	call	CrLf
	mov		edx, OFFSET result_5
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf

;Say "Good-bye"
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf
	call	WaitMsg
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
