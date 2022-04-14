/******************************************************************************
* file: arm_problem_4_part2.s
* author: Disha Das
******************************************************************************/


@R8 loads data at address = PRESENT as output.
@For the specified test case below, the PRESENT index is 6
@Hence, R8 holds 6 as output
@if SUBSTR is not present in STRING R8 holds 0x0

	@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	Input:	
		STRING: String1: .word 0x43 ,0x53, 0x36, 0x36, 0x32, 0x36, 0x32, 0x30 , 0x53  @('C''S''6''6''2''6''2''0''C')
		SUBSTR: String2: .word 0x36 @,0x32 , 0x30   @('6''2''0')
	Output:	
		PRESENT: .word 0x00000000
	
	Length_str1: .word(String2 - String1) /4    @compute length of STRING
	Length_str2: .word(Output - String2) / 4    @compute length of SUBSTR
	@ TEXT section
	  .text

.globl _main

_main:
	LDR R0, =Length_str1
	LDR R1, [R0]               @R1 holds length of STRING
	LDR R0, =Length_str2
	LDR R2, [R0]               @R2 holds length of SUBSTR
	LDR R3, = STRING           @R3 is the start address of string1 (STRING)
	LDR R4, = SUBSTR           @R4 is the start address of string2 (SUBSTR)
	MOV R7, #0                 @R7 is used as the output index value tracker
	CMP R2, R1                 @if substr length is greater than string,
	BGT not_present_complete   @exit

loop:
	CMP R2, #0                 @check if all chars of SUBSTR are compared, (R2 is length of SUBSTR which we decrement on each comare with STRING)
	BEQ present                @at this point all chars of SUBSTR are checked and match with STRING, hence update present index and exit
	CMP R1, #0                 @here, we check if R2 is not 0 but, R1 is
	BEQ not_present_complete   @Thus, if all chars of STRING are checked but, our SUBSTR remains, then SUBSTR is not present in STRING, exit
	MOV R10, R3                @R10 holds addr of current 'present' index in STRING
	LDR R5, [R3], #4           @Load in R5 next char in STRING
	LDR R6, [R4], #4           @Load in R6 next char in SUBSTR
	SUB R1, #1                 @Decrease number of chars left to check in STRING
	SUB R2, #1                 @Decrease number of chars left to check in SUBSTR
	CMP R5, R6                 @compare current chars
	BEQ inner_loop_check       @if match, run a loop with the remaining SUBSTR chars in inner_loop_check
	BNE update_not_present_idx @if no match, update the current index at R7 in update_not_present_idx label and reset SUBSTR and STRING values.
	
inner_loop_check:
	CMP R2, #0                 @check if all chars of SUBSTR are compared, (R2 is length of SUBSTR which we decrement on each comare with STRING)
	BEQ present                @at this point all chars of SUBSTR are checked and match with STRING, hence update present index and exit
	CMP R1, #0                 @here, we check if R2 is not 0 but, R1 is
	BEQ not_present_complete   @Thus, if all chars of STRING are checked but, our SUBSTR remains, then SUBSTR is not present in STRING, exit
	SUB R2, #1                 @Decrease number of chars left to check in SUBSTR
	LDR R5, [R3], #4           @Load in R5 next char in STRING
	LDR R6, [R4], #4           @Load in R6 next char in SUBSTR
	CMP R5, R6                 @compare current chars
	BEQ inner_loop_check       @if match, run a loop with the remaining SUBSTR chars in inner_loop_check
							   @if no match, update the current index at R7 in update_not_present_idx label and reset SUBSTR and STRING values.


update_not_present_idx:
	@compute (current index - 1) and store in R7:
	LDR R0, =Length_str1
	LDR R7, [R0]
	SUB R7, R7, R1             @R7 at this point holds the index which was just checked and does not hold SUBSTR
    @restore SUBSTR:
	LDR R4, = SUBSTR           @next load from [R4] will restart chars of SUBSTR
	LDR R0, = Length_str2
	LDR R2, [R0]               @R2 is reset and holds length of SUBSTR
	ADD R10, #4                @Add 4 to R10. Thus R10 which was the current STRING 'present' index is reset to next char of STRING in the outer loop i.e., loop
	MOV R3, R10                @R3 holds R10 addr so that load at loop label is from the correct 'next char of STRING' in the outer loop.
	B loop                     @branch to loop and start check for next index in STRING.
	
present:
	MOV R8, R7                 @R7 stores 'present index - 1' value. Copy this to R8
	ADD R8, #1                 @add 1 to R8 to get correct present index when SUBSTR is present
	LDR R9, = PRESENT          @R9 holds address = PRESENT
	STR R8, [R9]               @at addr = PRESENT, we store R8 value, i.e., output index when SUBSTR is present in STRING
	B complete
	
not_present_complete:
	MOV R8, #0x                @Copy 0x0 to R8 when SUBSTR is not a substring of STRING
	LDR R9, = PRESENT          @R9 holds address = PRESENT
	STR R8, [R9]               @at addr = PRESENT, we store R8 value, i.e., we store 0
	
complete:
	LDR R8, [R9]               @Load value at R9 = PRESENT to R8   (R8 holds the result! if string2 is a substring of string1, R8 is index of STRING where SUBSTR is present in STRING else, it is 0x0)
	swi 0x11
