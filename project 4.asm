TITLE Composite Numbers (template.asm)

; Author: Holly Buteau
; Course / Project ID     CS 271/Project 04          Date: July 27, 2016
; Description: This program will fill an array with random numbers in a range specified by the user. 
;1. using indirect addressing
;2. passing parameters
;3. generating “random” numbers
;4. working with arrays

INCLUDE Irvine32.inc

; (insert constant definitions here)
	
MIN = 10						;min user input
MAX = 200						;max user input
LO  = 100						;min number generated
HI = 999						;max number generated

.data

; (insert variable definitions here)
userName	BYTE	33	DUP(0)
current		DWORD	?
intro_1		BYTE	"Name : Holly Buteau", 0
intro_2		BYTE	"Program Title : Assignment 4 : Random Numbers" , 0
prompt_1	BYTE	"This program generates random numbers in the range [100 .. 999], ", 0
prompt_2	BYTE	"displays the original list, sorts the list, and calculates the median value.", 0
prompt_3	BYTE	"Finally, it displays the list sorted in descending order..", 0
prompt_4	BYTE	"How many numbers should be generated? Please pick in the range of [10 .. 200]", 0
prompt_5	BYTE	"You must pick a number in the range [10 .. 200]!  Please try again!", 0
unsortedArray	BYTE	"The unsorted random numbers: ", 0
median		BYTE	"The median is: ", 0
sortedArray	BYTE	"The sorted list: ", 0
range		DWORD		?
array		DWORD	MAX		DUP(?)
count		DWORD	0
colCount	DWORD	0
spacing		BYTE	"   ", 0


.code
main PROC

;Seeds random number
call	Randomize

;display intro
call	introduction

;user validation
push	OFFSET	range
call	getUserData

;fill array
push	OFFSET	array
push	range
call	fillArray

;display unsorted array
push	OFFSET	array
push	range
push	OFFSET	unsortedArray
call	showArray

;sorts the array
push	OFFSET	array
push	range
call	sort

;gets the median
push	OFFSET	array
push	range
call	showMedian

;display sorted array
push	OFFSET	array
push	range
push	OFFSET	sortedArray
call	showArray

;delayed message to keep information on screen
call	CrLf
call	CrLf
call	WaitMsg


invoke	ExitProcess, 0

main ENDP

;--------------------------------------------------------
;Procedure : Introduction
; Displaying program name, author, and description. 
; stores nothing
; receives : nothing
; returns : prints program name, author, and description 
;-------------------------------------------------------

introduction PROC

;Introduce programmer, assignment, and user
	mov		edx, OFFSET intro_1						;program title
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET prompt_1					;explanation of program purpose
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET prompt_3
	call	WriteString
	call	CrLf
	call	CrLf
	ret
introduction ENDP

;----------------------------------------------------------
;Procedure : getUserData
; Describes what the the program will do and gets user info
; validation is required
; receives : nothing
; returns : stores the user input in compNum
;----------------------------------------------------------

getUserData	PROC

;GetUserData
	push	ebp								;setting up stack frame
	mov		ebp, esp
	mov		ebx, [esp+8]					;ebp+8 is the location of the request address in the stack
											;ebx now points to the location of the request
	
	inputLoop:
	mov		edx, OFFSET prompt_4			;prompts user for input
	call	WriteString
	call	CrLf
	call	CrLf
	call	ReadInt							;reads in the input
	call	CrLf
	call	CrLf


	cmp		eax, MAX						;makes sure user number doesn't exceed upper limit
	jg		error							;jumps to error if it does

	cmp		eax, MIN						;makes sure user number isn't below lower limit
	jl		error							;jumps to error loop if it is 

	jmp		endLoop							;if the number is acceptable, leave getUserData

	error:
	mov		edx, OFFSET prompt_5			;error message
	call	WriteString
	call	CrLf
	call	CrLf
	jmp		inputLoop						;loop back to prompt again

	endLoop:
	mov		[ebx], eax						;stores valid number
	pop		ebp								;restores stack
	ret		4								;returns bytes pushed before call


getUserData ENDP

;-----------------------------------------------
;Procedure : fillArray
; Fills the array with random numbers
; receives : range which is the user input
; returns : array filled with random values
; sent to showArray and printed
;-----------------------------------------------

fillArray PROC
push	ebp									;set up the stack frame
mov		ebp, esp					
mov		edi, [ebp+12]						;move the address of beginning of array to edi
mov		ecx, [ebp+8]						;counting loop

randomLoop:
mov		eax, HI								;global high 
sub		eax, LO								;global low
add		eax, 1								;getting the full range by adding one
call	RandomRange							;RandomRange was recommended by professor
add		eax, LO				
mov		[edi], eax
add		edi, 4								;increases address locationto next element in array
loop		randomLoop						;continues looping to fill array
	
pop		ebp									;pop out
ret		8									;return bytes pushed

fillArray	ENDP

;------------------------------------------------
;Procedure : showArray
; displays array to user
; receieves : array from stack, range, counter
; returns : nothing
;------------------------------------------------

showArray PROC
push	ebp									;set up stack frame
mov		ebp, esp							;points to array
mov		esi, [ebp+16]						;address of array
mov		ecx, [ebp+12]						;loop counter
mov		ebx, 1								;counter for determining number of values in a row

call	CrLf
mov		edx, [ebp+8]						;location of string on the stack
call	WriteString							;print value
call	CrLf

showLoop:
cmp		ebx, MIN							;compares to min number
jg		new									;jumps to create a new row
mov		eax, [esi]							;otherwise, get element
call	WriteDec							;print element
mov		edx, OFFSET spacing					;formatting
call	WriteString
add		esi, 4								;go to next element in array
add		ebx, 1								;increase row count
loop	showLoop							;loop again
jmp		exitLoop

new:
call	CrLf								;creates new row 
mov		ebx, 1								;resets the row count
jmp		showLoop							;jump back to loop

exitLoop:
pop		ebp									;pop what was pushed
ret		12									;return bytes

showArray	ENDP

;------------------------------------------------------
;Procedure : sort
; sorts the values in the array from greatest to least
; receieves : address of array and user value
; returns : array is ordered
; registers changed : ecx, eax
; Citation: Assembly Language Book page 375 BubbleSort
;------------------------------------------------------

sort PROC
push	ebp									;set up the stack
mov		ebp, esp					
mov		ecx, [ebp+8]						;loop counter
dec		ecx

OuterLoop:
push	ecx									;save outer loop
mov		esi, [ebp+12]						;address of array

InnerLoop:
mov		eax, [esi]							;current element of array's content
cmp		[esi+4], eax						;compare values
jl		nextLoop							
xchg	eax, [esi+4]						;swap the two values if greater
mov		[esi], eax							

nextLoop:
add		esi, 4								;next element in array
sub		ecx, 1								;decrement the counter
cmp		ecx, 0								;compare to 0
jg		InnerLoop							;jump to innerLoop
pop		ecx			
sub		ecx, 1
cmp		ecx, 0
jg		OuterLoop
pop		ebp									;pop what was pushed
	
ret		8									;return bytes pushed

sort ENDP

;-----------------------------------------------
;Procedure : median
; determines the median of the array
; receieves : address of array and user value
; returns : none
; registers used : ecx, eax. ebx, edx
;-----------------------------------------------

showMedian PROC
push	ebp									;set up stack frame
mov		ebp, esp							
call	CrLf
call	CrLf
mov		edx, OFFSET median					;display message for median
call	WriteString							
mov		edx, 0
mov		eax, [ebp+8]
mov		ebx, 2
div		ebx									;division to determine if there are an odd or even number of elements in array
cmp		edx, 0
jne		odd

evenNumber:									;if the number is even
dec		eax
mov		ebx, 4
mul		ebx									;multiplied to get the offset from the start of the array
mov		esi, [ebp+12]
add		esi, eax
mov		ebx, [esi]
sub		esp, 20
mov		DWORD PTR [ebp-4], ebx
add		esi, 4
mov		ebx, [esi]
mov		DWORD PTR[ebp-8], ebx
mov		edx, 0
mov		eax, [ebp-4]
add		eax, [ebp-8]
mov		ebx, 2
div		ebx
call	WriteDec
call	CrLf
jmp		endLoop

odd:										;if the number is odd
mov		ebx, 4							
mul		ebx
mov		esi, [ebp+12]						;finding the start of the array
add		esi, eax							;adds eax to middle of array
mov		eax, [esi]							;moves the esi value to eax
call	WriteDec							;prints the value
call	CrLf

endLoop:
mov		esp, ebp
pop		ebp									;pop what weas pushed

ret 8										;return bytes pushed

showMedian	ENDP



END main
