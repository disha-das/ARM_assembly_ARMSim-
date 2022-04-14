/******************************************************************************
* file: arm_program_6_part1.s
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
		NumofElems: .word 0                 @At addr NumofElems, user input for "number of elements" is stored
		A: .skip 80                         @At addr A, user input array elements are stored
	SEARCH_ELEM:
		N: .word 0                          @At addr N, user input for "element to be searched" is stored
	OUTPUT: .word -1                        @Final output indicating position of N if present or -1 if absent is stored in addr OUTPUT
	
	
	OutputMessage: .asciz "Element Position(output) is: "
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
ldr r1, =A                                         @array integer elements are input from user
loop_for_array_input:                              @and stored iteratively at array start addr A
ldr r0, =IntRead
ldr r0, [r0]
swi 0x6c
str r0, [r1], #4
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
ldr r1, =A
mov r4, r2                                         @a copy of NumofElems in r4 from r2
bl SEARCH                                          @invoke subroutine SEARCH
ldr r5, =OUTPUT                                    @Subroutine returns back here
mov r9, r0                                         @result returned by subroutine in r0 saved in r9
str r9, [r5]                                       @final OUTPUT visible in r9; also stored to =OUTPUT addr

mov r0, #1
ldr r1, =OutputMessage                             @an output console message which also prints the output
swi 0x69
mov r0,#1
mov r1, r9                                         @r9 holds final OUTPUT
swi 0x6b

swi 0x11


@@@**************************************************************************************************************************
.text	
SEARCH:
	stmfd sp!,{r1,r2,r3,r4,lr}                     @array and search elements passed to subroutine through a mem block                   

	loop: 
	ldr r6, [r1], #4                               @r6 loads array elements in a loop from r1; passed array mem =A in r1
	cmp r6, r3                                     @current array A element compared with r3 (element to be searched); passed as mem to subroutine
	beq OUTPUT_INDEX                               @if r6 is same as r3, branch to OUTPUT_INDEX
	subs r4, r4, #1                                @else, subtract 1 from r4 (r4 holds current search idx in A)
	bgt loop                                       @if r4 is greater than 0, array elements are left to be compared; branch back to loop
    b NOT_FOUND                                    @if r4 is 0 or less, array is parsed entirely; elem is not fount; branch to NOT_FOUND

    OUTPUT_INDEX:                                  @updates return value of subroutine in r0 as follows:   
	mov r0, r2                                     @r2 holds num of elements in A and is copied to r0
	sub r0, r4                                     @we effectively compute r2 - r4 (r4 is the position of the element of interest from the end)
	                                               @eg: if the elem is last in A of size 3; then r0 now holds 3 - 1 = 2
	add r0, #1                                     @hence, r0 is added with 1
	ldmfd sp!,{r1,r2,r3,r4,pc}                     @stack is popped and r0 is returned; program resumes with pc = lr

	NOT_FOUND:                                     @if element is not found:
	mov r0, #-1                                    @return value in r0 set to -1
	ldmfd sp!,{r1,r2,r3,r4,pc}                     @stack is popped and r0 is returned; program resumes with pc = lr

IntRead: .word 0
