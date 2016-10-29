TITLE Composite Numbers (template.asm)

; Author: Holly Buteau
; Course / Project ID     CS 271/Project 05a          Date: August 5, 2016
; Description: This program will prompt users for unsigned decimal integers and it will calculate the sum and average of all user numbers 
; 1) Designing, implementing, and calling low-level I/O procedures
; 2) Implementing and using a macro

INCLUDE Irvine32.inc

; (insert constant definitions here)


;------------------------------------------
; Macro : getString
; Description : moves user onput into memory
; Params : address, length
;-----------------------------------------

getString		MACRO address, length
push	edx
push	ecx
mov		edx, address
mov		ecx, length
call	ReadString
pop		ecx
pop		edx
ENDM


;------------------------------------------
; Macro : displayString
; Description : displays string from memory
; Params : userString
;-----------------------------------------

displayString	MACRO userString
push	edx
mov		edx, OFFSET userString
call	WriteString
pop		edx
ENDM

ARRAY_SIZE = 10;			;constant for input limit

.data

; (insert variable definitions here)
stringBuffer	BYTE	255 DUP(0)
temp		BYTE	32 DUP(?)
intro_1		BYTE	"Name : Holly Buteau", 0
intro_2		BYTE	"Program Title : Assignment 5a : Designing low-level I/O procedures" , 0
prompt_1	BYTE	"Please provide 10 unsigned decimal integers.", 0
prompt_2	BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
prompt_3	BYTE	"After you have finished inputting the raw numbers I will display a list", 0
prompt_4	BYTE	"of the integers, their sum, and their average value.", 0
prompt_5	BYTE	"Please enter an unsigned number:", 0
error		BYTE	"ERROR: You did not enter an unsigned number or your number was too big. ", 0
reprompt	BYTE	"Please try again: ", 0
displayNum	BYTE	"You entered the following numbers: ", 0
avg			BYTE	"The average is: ", 0
writeSum	BYTE	"The sum of these numbers is: ", 0
goodBye		BYTE	"Thanks for playing!", 0
array		DWORD	ARRAY_SIZE	DUP(0)
average		DWORD	?			
sum			DWORD	?



.code
main PROC

;call to introduce
call	introduction

mov		ecx, ARRAY_SIZE
mov		edi, OFFSET array

prompt:
call	CrLf
displayString	prompt_5
call	CrLf

push	OFFSET stringBuffer				;pushes params, calls readVal
push	SIZEOF	stringBuffer
call	readVal

mov		eax, DWORD PTR stringBuffer		;moving through the array
mov		[edi], eax
add		edi, 4

loop	prompt							;continue looping if there aren't 10 values

mov		ecx, ARRAY_SIZE					;this is all to display the user ints
mov		esi, OFFSET array
mov		ebx, 0

call	CrLf						
displayString	displayNum
push		edx
mov			edx, OFFSET displayNum
call		WriteString
pop			edx
call		CrLf
call		CrLf


sumCalc:								;this is to calculate the sum
mov		eax, [esi]
add		ebx, eax

push	eax								;pushes params and calls writeVal
push	OFFSET temp
call	writeVal
add		esi, 4
loop	sumCalc

mov		eax, ebx
mov		sum, eax
call	CrLf
displayString	writeSum				;diplaying sum message

push	sum
push	OFFSET temp						;pushes params and calls writeVal macro
call	writeVal
call	CrLf

mov		ebx, ARRAY_SIZE
mov		edx, 0

div		ebx

mov		ecx, eax						;this will detrmine if the average needs rounding
mov		eax, edx
mov		edx, 2
mul		edx
cmp		eax, ebx
mov		eax, ecx
mov		average, eax					
jb		okNum
inc		eax
mov		average, eax

okNum:									;displays the message for the average
displayString	avg


push	average							;calls writeVal after pushing params 
push	OFFSET temp
call	writeVal
call	CrLf

displayString	goodBye					;goodbye message
call	CrLf
call	WaitMsg							
exit
main ENDP

;-------------------------------------------------------------------------------------------------
; Procedure: introduction
; Displays the program name, author, and description of the program.
; receives: none
; returns: prints program title, author name, and description of the program. 
;-------------------------------------------------------------------------------------------------------

introduction PROC

displayString	intro_1									;introduction for user. Basic display of the purpose of the program
call	CrLf
displayString	intro_2
call	CrLf
displayString	prompt_1
call	CrLf
displayString	prompt_2
call	CrLf
displayString	prompt_3
call	CrLf
displayString	prompt_4
call	CrLf
call	CrLf

introduction ENDP

;-------------------------------------------------------------------------------------------------
; Procedure: readVal
; Description : Gets the user string of digits and converts string to numbers. Validates input
; receives: stringBuffer offset and size
;-------------------------------------------------------------------------------------------------------

readVal PROC
push	ebp
mov		ebp, esp
pushad

Loop1:
mov		edx, [ebp+12]								;moves the address of stringBuffer
mov		ecx, [ebp+8]								;moves size of stringBuffer to ecx for count

getString	edx, ecx								;this all reads in the input
push		edx
push		ecx
mov			ecx, edx
call		ReadString
pop			ecx
pop			edx

mov		esi, edx									;this sets the registers
mov		eax, 0
mov		ecx, 0
mov		ebx, 10

Loop2:												;this will load the string in
lodsb												;loading from esi
cmp		ax, 0										;checks to see if we are at the end of the string
je		exitLoop

cmp		ax, 48										;this is to compare to 0 using ASCII code
jb		errorMsg
cmp		ax, 57										;this is to compare to 9 using ASCII code
ja		errorMsg									;this all checks to make sure the int is in range

sub		ax, 48
xchg	eax, ecx
mul		ebx											;multiplication for digit place
jc		errorMsg
jnc		pass

errorMsg:											;if user input is incorrect
call	CrLf
displayString	error
call	CrLf

displayString	reprompt

jmp		Loop1

pass:
add		eax, ecx									;if no error, exhange for next loop
xchg	eax, ecx
jmp		Loop2

exitLoop:
xchg	ecx, eax
mov		DWORD PTR	stringBuffer, eax
popad
pop		ebp
ret		8
readVal	ENDP

;-------------------------------------------------------------------------------------------------
; Procedure: writeVal
; Displays converts value to string and invokes display string to output
; receives: int and string
;-------------------------------------------------------------------------------------------------------

writeVal	PROC
push	ebp								;set up stack frame
mov		ebp, esp
pushad

mov		eax, [ebp+12]					;this will move the int for conversion to string
mov		edi, [ebp+8]					;edi will store the string
mov		ebx, 10							;all this prepares for looping through ints
push	0

Loop3:
mov		edx, 0
div		ebx
add		edx, 48
push	edx								;next int gets pushed on the stack

cmp		eax, 0					
jne		Loop3

PopNums:								;pops the numbers off the stack
pop		[edi]
mov		eax, [edi]
inc		edi
cmp		eax, 0							;determines if it's the end
jne		PopNums

mov		edx, [ebp+8]					;uses macro to diaplay numbers
displayString	OFFSET temp
call	CrLf

popad									;restoring registers
pop		ebp
ret		8
writeVal	ENDP


END main
