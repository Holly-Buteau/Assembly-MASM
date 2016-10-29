TITLE Composite Numbers (template.asm)

; Author: Holly Buteau
; Course / Project ID     CS 271/Project 03          Date: July 21, 2016
; Description: This program will calculate the composite numbers in a range with provided user input. 
;1) Designing and implementing procedures
;2) Designing and implementing loops
;3) Writing nested loops
;4) Understanding data validation

INCLUDE Irvine32.inc

; (insert constant definitions here)

LOWERLIMIT = 1
UPPERLIMIT = 400

.data

; (insert variable definitions here)
userName	BYTE	33	DUP(0)
current		DWORD	?
intro_1		BYTE	"Name : Holly Buteau", 0
intro_2		BYTE	"Program Title : Assignment 3 : Composite Numbers" , 0
prompt_1	BYTE	"What's your name? ", 0
intro_3		BYTE	"Nice to meet you,  ", 0
prompt_2	BYTE	"Please enter a number and I will tell you all the composite numbers up to your number.", 0
prompt_3	BYTE	"The value should be in the range [1 .. 400]. ", 0
prompt_4	BYTE	"You must pick a number in the range [1 .. 400]!  Please try again!", 0
compNum		DWORD	?
value		DWORD	?
counter		DWORD		0
extraCred	BYTE	"** EC: DESCRIPTION :  I chose to align the output columns for extra credit", 0
goodBye		BYTE	"Good-bye, ", 0

.code
main PROC

; Only using main to call 4 PROCS
	;first proc : introduce program
	call	introduction

	;second proc : get data to work with
	call	getUserData

	;third proc : display data
	call	showComposites

	;fourth proc : calculate composites
	call	determineComposites

	;fifth proc : say goodbye
	call	farewell

main ENDP

;Procedure : Introduction
; Displaying program name, author, and description. Also gets user name and greets them
; stores the user name
; receives : nothing
; returns : prints program name, author, description and user name

introduction PROC

;Introduce programmer, assignment, and user
	mov		edx, OFFSET intro_1				;introduction of program and author
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCred
	call	WriteString
	call	CrLf
	call	CrLf
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
	ret
introduction ENDP


;Procedure : getUserData
; Describes what the the program will do and gets user info
; validation is required
; receives : nothing
; returns : stores the user input in compNum
getUserData	PROC

;GetUserData
	mov		edx, OFFSET prompt_2			;displays purpose of program
	call	WriteString
	call	CrLf
	mov		edx, OFFSET prompt_3			; prompts user for number
	call	WriteString
	call	ReadInt
	mov		compNum, eax
	call	CrLf

	checkLoop:								; this begins the check loop
	cmp		eax, LOWERLIMIT					; compares the user input to the lower limit and upper limit
	jb		error							; if the user unput is valid, exit and keep going
	cmp		eax, UPPERLIMIT
	jg		error							; call error if invalid
	jmp		endLoop

	error:									; error loop dsiplays error message when user input is out of range
		mov		edx, OFFSET prompt_4
		call	WriteString
		call	CrLf
		call	ReadInt						;receieves user input
		mov		compNum, eax				
		jmp checkLoop						;jumps back to recheck the input
	endLoop:
	ret
getUserData ENDP

;Procedure : showComposites
; Uses a loop to display the composite number. Also aligns the numbers for extra credit
; receives : compNum which is the user input
; returns : prints the composite number "value"  which is 
; sent to determineComposite  and printed on return if it is a composite
showComposites PROC

	;setting the counter and value
	mov		ecx, compNum					;loop counter is the user input
	mov		value, 1						; 1 is the first non-negative number
	
	newLoop:								; this loop calls determine composite
		call	determineComposites			; to calculate whether the number is composite
		mov		eax, value					
		call	WriteDec					;display number
		mov		al, TAB						;formatting for aligned columns
		call	WriteChar
		inc		counter						 
		mov		eax, value
		add		eax, 1						;increases value by one for testing
		mov		value, eax					; stores value for testing

		cmp		counter, 10					;ten numbers per line
		jne		exitPrint					
		call	CrLf
		mov		counter, 0					;formatting for columns
		jmp		exitPrint
	


		exitPrint:

		loop	newLoop						;process starts again
	


		
	ret

showComposites ENDP


;Procedure : determineComposites
; Divides value received by 2,3,5,7,9. If there is no remainder, value is composite
; and returned to showComposite. Otherwise, the value is increased and tested again
; receieves : value
; returns : composites
determineComposites PROC

;calculating and showing the composite numbers
		;fringe cases
		mov		edx, 0
		mov		ebx, 0
		mov		eax, value
		cmp		eax, 3						;numbers 1-3 are not composite
		jle		notGood						;if it's prime, it's not composite
	
		;tests for remainder dividing by 2
		mov		ebx, 2
		div		ebx
		cmp		edx, 0
		je		goodNum						;if no remainder, then it's composite
		mov		edx, 0

		;tests for remainder dividing by 3
		mov		eax, value					;puts value back into eax
		mov		ebx, 3						;stored for division
		div		ebx							;divide by eax
		cmp		edx, 0			
		je		goodNum						;if there's no remainder, then it's composite
		mov		edx, 0

		;tests for remainder dividing by 5
		mov		eax, value
		mov		ebx, 5
		div		ebx
		cmp		edx, 0
		je		goodNum						;if there's no remainder, then it's composite
		mov		edx, 0

		;tests for remainder dividing by 7
		mov		eax, value
		mov		ebx, 7
		div		ebx
		cmp		edx, 0
		je		goodNum						;if there's no remainder, then it's composite
		mov		edx, 0

		;tests for remainder dividing by 9
		mov		eax, value
		mov		ebx, 9
		div		ebx
		cmp		edx, 0
		je		goodNum						;if there's no remainder, then it's composite
		mov		edx, 0
	

		notGood:
			mov		eax, value
			add		eax, 1					;moves on to next value for testing
			mov		value, eax
			call	determineComposites		;starts process over

		goodNum:
			mov		eax, value
			cmp		eax, 5					;catched 5 and 7 as neither are composite
			je		notGood
			cmp		eax, 7
			je		notGood
			ret
	

	
determineComposites ENDP

; Procedure : farewell
; Says goodbye to suer by name
; recieves : user name
; returns : prints goodbye to user
farewell PROC
;Say "Good-bye"								; parting message
	call	CrLf
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf
	call	CrLf
	call	WaitMsg
	exit	; exit to operating system

farewell ENDP

; (insert additional procedures here)

END main
