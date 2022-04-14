/******************************************************************************
* file: arm_problem_4_part1.s
* author: Disha Das
******************************************************************************/


@R6 hold final result loaded from addr GREATER

	@ BSS section
	.bss

	@ DATA SECTION
	.data
	Input:	
		LENGTH:	.word 3
		START1: String1: .word 0x43 ,0x41, 0x54   @('C''A''T')
		START2: String2: .word 0x43 ,0x55, 0x54   @('C''U''T')
	Output:	
		GREATER: .word 0x00000000
	@ TEXT section
	.text

.globl _main

_main:
	LDR R0, = LENGTH
	LDR R1, [R0]           @R1 holds the length of the strings
	LDR R0, = START1       @R0 is the start address of string1
	LDR R3, = START2       @R3 is the start address of string2
loop:
	CMP R1, #0             @check if all chars are compared, (R1 is length which we decrement on each comare)
	BEQ complete           @update GREATER and exit if all chars are compared
	LDR R2, [R0], #4       @load next char of string1 in R2
	LDR R4, [R3], #4       @load next char of string2 in R4
	SUB R1, #1             @update R1 (number of chars left to be compared)
	CMP R2, R4             @compare R2 and R4
	BLT update_output      @if R2 - R4 is less than 0, i.e., R2 < R4 (string1 < string2), update GREATER with 0xffffffff
	CMP R2, R4
	BGT exit_without_update @else exit without updating GREATER
	B loop                  @loop to check next char ascii value
	
update_output:
	MOV R6, #0xffffffff    @R6 stores value 0xffffffff
	LDR R5, = GREATER      @R5 holds address = GREATER
	STR R6, [R5]           @at addr = GREATER, we store R6

complete:
	LDR R6, [R5]           @Load value at R5 = GREATER to R6   (R6 holds the result! if string1 is less than string2, R6 is 0xffffffff else, it is 0x0)
	swi 0x11
		
exit_without_update:
	MOV R6, #0x0           @R6 stores value 0x0
	LDR R5, = GREATER      @R5 holds address = GREATER
	STR R6, [R5]           @at addr = GREATER, we store R6
	B complete             @exit after update with 0x0
