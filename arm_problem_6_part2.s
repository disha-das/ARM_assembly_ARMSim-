/******************************************************************************
* file: arm_problem_6_part2.s
* author: Disha Das
******************************************************************************/

	@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	Message1: .asciz "Enter number of array elements to be input\n"
	Message2: .asciz "Enter array elements\n"
	Message3: .asciz "Enter Element to be Searched\n"

	Input:
		NumofElems: .word 0
		A: .skip 80
	SEARCH_ELEM:
		N: .word 0
	OUTPUT: .word -1
	
	
	OutputMessage: .asciz "Element Position(output) is: "
	InputErrorMessage: .asciz "Array input not sorted"
	@ TEXT section
	  .text	

.globl _main
.text
_main:


@@@**************************************************************************************************************************
mov r0, #1                                         @prompt user to input NumofElems
ldr r1, =Message1
swi 0x69

ldr r0, =IntRead                                   @code block: Interrupt to get input from keyboard:
ldr r0, [r0]                                       @integer input "NumofElems" from user taken as input
swi 0x6c
mov r2, r0                                         @r2 holds the number of elements in A
ldr r0, =NumofElems
str r2, [r0]


@@@**************************************************************************************************************************
mov r0, #1                                         @prompt user to input Arrayelements
ldr r1, =Message2
swi 0x69

mov r4, r2                                         @code block: Interrupt to get input from keyboard:
mov r7, #0                                         @array integer elements are input from user
ldr r1, =A                                         @and stored iteratively at array start addr A
loop_for_array_input:
ldr r0, =IntRead
ldr r0, [r0]
swi 0x6c
cmp r7, r0                                         @check to see if array is valid (increasing order)
BGT ERROR_SEEN                                     @branch to ERROR_SEEN and end if array is invalid
str r0, [r1], #4
mov r7, r0
subs r4, r4, #1
bgt loop_for_array_input



@@@**************************************************************************************************************************
mov r0, #1                                         @prompt user to input Element to be searched in array
ldr r1, =Message3
swi 0x69

ldr r0, =IntRead                                   @code block: Interrupt to get input from keyboard:
ldr r0, [r0]                                       @integer input "NumofElems" from user taken as input
swi 0x6c
mov r3, r0                                         @r3 holds the element to be searched
ldr r0, =N
str r3, [r0]



@@@**************************************************************************************************************************
mov r5, #4                                         @r5 used for load index calculation in subroutine
bl BINARY_SEARCH_ELEM_SUBROUTINE                   @invoke subroutine BINARY_SEARCH_ELEM_SUBROUTINE
ldr r5, =OUTPUT                                    @Subroutine returns back here
mov r9, r0                                        @result returned by subroutine in r0 saved in r9
str r9, [r5]                                       @final OUTPUT visible in r9; also stored to =OUTPUT addr

mov r0, #1
ldr r1, =OutputMessage                             @an output console message which also prints the output idx
swi 0x69
mov r0,#1
mov r1, r9                                         @r9 holds final OUTPUT
swi 0x6b
swi 0x11




@@@**************************************************************************************************************************
.text
BINARY_SEARCH_ELEM_SUBROUTINE:
	stmfd sp!,{r1,r2,r3,r4,lr}                           @array and search elements passed to subroutine through a mem block

	mov r7, #1                                           @min idx for binary search init with 1
	mov r8, r2                                           @max idx for binary search init with NumofElems

	loop:
	mov r4, r7                                           @register r4 holds the middle idx for min and max idx
	add r4, r8
	asr r4, #1                                           @sum of min and max, divided by 2 and stored in r4
	
	
	                                                     @here, we update next element in array to be checked:
	ldr r1, =A                                           @r1 currently holds addr =A
	mul r5, r4                                           @r5 as specified before holds value 4; r4 is middle element for min max
	                                                     @hence, now r5 holds offset location for middle element + 1
	add r1, r5                                           @r5 added to 1 to get middle element addr + 1
	sub r1, #4                                           @sub by 4 to get middle element addr
	ldr r6, [r1]                                         @load middle element in r6
	
	cmp r6, r3                                           @current array A element compared with r3 (element to be searched); passed as mem to subroutine
	beq OUTPUT_INDEX                                     @if r6 is same as r3, branch to OUTPUT_INDEX
	bgt update_array_max                                 @else if array middle element is greater than element to be searched,
	                                                     @branch to update max with current middle index
	b update_array_min                                   @else if array middle element is less than element to be searched,
	                                                     @branch to update min with current middle index - 1
    b NOT_FOUND                                          

    OUTPUT_INDEX:                                        @updates return value of subroutine in r0 as follows: 
    mov r0, r2                                           @r2 holds num of elements in A and is copied to r0
    sub r0, r4                                           @we effectively, compute r2 - r4 (r4 is the position of the element of interest from the end)
    sub r0, r2, r0                                       @return val in r0 updated appropriately (r2 holds number of elements)	
    ldmfd sp!,{r1,r2,r3,r4,pc}                           @stack is popped and r0 is returned; program resumes with pc = lr

    update_array_min:          @update the mix index appropriately
	add r4, #1
	mov r7, r4
	mov r5, #4
	cmp r7, r8                 @if min greater than max, branch to NOT_FOUND
	bgt NOT_FOUND
    b loop                     @branch back to loop
	
    update_array_max:          @update the mix index appropriately
	mov r8, r4
	mov r5, #4
	cmp r7, r8                 @if min greater than max, branch to NOT_FOUND
	bgt NOT_FOUND
	b loop                     @branch back to loop

	NOT_FOUND:                                     @if element is not found:
	mov r0, #-1                                    @return value in r0 set to -1
	ldmfd sp!,{r1,r2,r3,r4,pc}                     @stack is popped and r0 is returned; program resumes with pc = lr
	
	
IntRead: .word 0

ERROR_SEEN:                                        @handles array input if not sorted
mov r0, #1
ldr r1, =InputErrorMessage                         @throws error on console
swi 0x69

swi 0x11
