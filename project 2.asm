TITLE Math Program  (template.asm)

; Author: Holly Buteau
; Course / Project ID     CS 271/Project 02          Date: July 4, 2016
; Description: This program will calculate the Fibonacci numbers with provided user input. 
; Step 1 : Get user input and validate data using a post-test loop
; Step 2 : Use a counted loop to calculate the fibonaaci sequence
; Step 3 : Keep track of previous numbers to be able to calculate the next number in sequence

INCLUDE Irvine32.inc

; (insert constant definitions here)

upperLimit = 46

.data

; (insert variable definitions here)
userName	BYTE	33	DUP(0)
current		DWORD	?
intro_1		BYTE	"Name : Holly Buteau", 0
intro_2		BYTE	"Program Title : Assignment 2 : Fibonacci Numbers" , 0
prompt_1	BYTE	"What's your name? ", 0
intro_3		BYTE	"Nice to meet you,  ", 0
prompt_2	BYTE	"Please enter the number of Fibonacci terms to be displayed.", 0
prompt_3	BYTE	"The value should be in the range [1 .. 46]. ", 0
prompt_4	BYTE	"You must pick a number in the range [1 .. 46]!  Please try again!", 0
fibNum		DWORD	?
spacing		BYTE	"     " , 0
numCols		DWORD	?
previous	DWORD	?
goodBye		BYTE	"Good-bye, ", 0

.code
main PROC

; (insert executable instructions here)

;Introduce programmer, assignment, and user
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf


;UserInstructions
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, 32							; setting the max length of the user name 
	call	ReadString						; read in the input
	call	CrLf
	mov		edx, OFFSET	intro_3				; greeting the user by name 
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf
	

;GetUserData
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	ReadInt
	mov		fibNum, eax
	call	CrLf

	WL:										; this begins the while loop : WL = " While Loop" 
	cmp		eax, upperLimit					; compares the user input to the upper limit
	jle		endLoop							; if the user unput is valid, exit and keep going
	mov		edx, OFFSET prompt_4			; if user input is invalid, reprompt and loop again
	call	WriteString
	call	CrLf
	call	ReadInt
	mov		fibNum, eax
	jmp		WL								; this starts the loop again if input is invalid
	call	CrLf
	endLoop:

;DisplayFibs
	mov		ebx, 0							; this accounts for seeding the first fibonaaci numbers
	mov		previous, 1						; the first two numbers in the sequence do not follow the formula and it is needed to seed them 			
	mov		ecx, fibNum						; this is the loop counter
	mov		numCols, 1						; we can only have 5 numbers in a column, so this keeps count

	FL:										; the counted loop. FL = "Fibonacci Loop"
	mov		eax, ebx						; this loop carries out the formula which is as follows:
	add		eax, previous					; f(n) = f(n - 1) + f(n - 2)
	call	WriteDec						; the way we implpement is : new number (eax) = current (ebx) + previous 
	mov		edx, OFFSET spacing
	call	WriteString
	mov		previous, ebx
	mov		ebx, eax
	cmp		numCols, 5
	jge		row
	inc		numCols
	jmp		next
	
	row:									; this creates a new row when the current row reaches 5 numbers
	call	CrLf
	mov		numCols, 1						; resets the count
	
	next:									; starts the loop again
	loop	FL

	call	CrLf
	call	CrLf

;Say "Good-bye"								; parting message
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	WaitMsg
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
