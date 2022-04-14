/******************************************************************************
* file: arm_problem_6_part3.s
* author: Disha Das
******************************************************************************/

	@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	Message1: .asciz "Enter N to obtain Nth fibonacci number\n"

	Input:
		N: .word 0
	OUTPUT: .word 0
	
	OutputMessage: .asciz "Nth Fibonnaci number is: "
	@ TEXT section
	.text
.globl _main

_main:


@@@**************************************************************************************************************************
mov r0, #1                                   @prompt user to enter N to compute Nth fibonacci
ldr r1, =Message1
swi 0x69

ldr r0, =IntRead                             @code block: Interrupt to get input from keyboard:
ldr r0, [r0]                                 @integer input "N" from user taken as input
swi 0x6c
mov r1, r0                                   @r1 holds N
ldr r0, =N
str r1, [r0]

mov r2, #1                                   @init r2, r3 register with 1
mov r3, #1


bl FIBO                                      @invoke subroutine FIBO
ldr r5, =OUTPUT                              @Subroutine returns back here
mov r9, r0                                   @result returned by subroutine in r0 saved in r9
str r9, [r5]                                 @final OUTPUT visible in r9; also stored to =OUTPUT addr

mov r0, #1
ldr r1, =OutputMessage                       @an output console message which also prints Nth Fibonacci number
swi 0x69
mov r0,#1
mov r1, r9                                   @r9 holds final OUTPUT
swi 0x6b
swi 0x11


FIBO:                                        
	stmfd sp!,{r1,lr}                        @N passed passed to subroutine through a mem block 
	mov r4, #1                               @init r4 as 1
	
Build_Recursive_Stack:
    cmp r4, r1                               @cmp r1(N) with r4(ith recursive call) 
	beq compute_fibnum_recursive             @if equal, pop stack to obtain output by branching to compute_fibnum_recursive
	cmp r4, #1                               @check if the recursive call is the first one
	beq init_first                           @if yes, branch to init_first
	cmp r4, #2                               @check if the recursive call is the second one
	beq init_second                          @if yes, branch to init_second
	pop {r5}                                 @if it is some ith recursive call, we pop top 2 elems
	pop {r6}
	add r7, r5, r6                           @then, we add these two popped values
@	@push {r6}                               @if we uncomment this, the stack memory section after execution lists all N fibonacci numbers
                                             @but, we need to maintain only the last 2 for recursive calls, hence, this is not pushed
											 
	push {r5}                                @push the first popped and the added value back onto stack
	push {r7}                                @this way our stack is recursively updated
	add r4, #1                               @update r4 for the next recursive call
	b Build_Recursive_Stack                  @next recursive call is made

	init_first:                              @inits the stack with first fib number
	PUSH {r2}
	add r4, #1
	b Build_Recursive_Stack
	init_second:                             @inits the stack with second fib number
	PUSH {r3}
	add r4, #1
	b Build_Recursive_Stack

	
	compute_fibnum_recursive:                @recursively computes Nth fibonacci number
	mov r0, #1
	cmp r1, #1
	beq return_back                          @if N is 1, we simply return 1 by branching to return_back
	cmp r1, #2
	beq pop_return_back                      @if N is 2, we simply return 1 after one pop by branching to pop_return_back
	
	
	@if N is > 2, we make the recursive calls:
	pop {r5}                                 @fibonacci(n-2)
	pop {r6}                                 @fibonacci(n-1)
	add r7, r5, r6                           @fibonacci(n-1) + fibonacci(n-2)
@	@push {r6}
	push {r5}                                @restore the stack
	push {r7}
	mov r0, r7                               @RETURN VALUE UPDATED IN R0
	pop {r7}                                 @pop out values to link back from subroutine
	pop {r5}
	
	return_back:
	ldmfd sp!,{r1,pc}

	pop_return_back:
	pop {r5}
	ldmfd sp!,{r1,pc}
		
IntRead: .word 0
