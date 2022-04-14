/******************************************************************************
* file: arm_program_5_part2.s
* author: Disha Das
******************************************************************************/

	@ BSS section
	.bss
	
	@Input STRING is given as a series of 0x30s and 0x31s of length AT LEAST 8 or more. (we ignore bits after the eigth bit even if given as input)
	@The string MUST contain at least 8 bits as input
	@The OUTPUTS are NUMBER (holds the bit stream) and ERROR (holds 0xFF if input other than 0x30 or 0x31 is given, otherwise holds 0x00)
    @NUMBER as bit stream of 0s and 1s will be held in the Hexadecimal format in R3 register.
	@ i.e., when R3 will hold something like: 11010010 in hex, we wont really consider it in hex but, we look at it as a binary number: 11010010
	
	@ DATA SECTION
	.data
	Input:	
		STRING: .word 0x31 ,0x31, 0x30, 0x31, 0x30, 0x30, 0x31, 0x30 @('1''1''0''1''0''0''1''0')
	Output:	
		NUMBER: .word 0x00000000    @deafult set as 0x0
		ERROR:  .word 0x00          @deafult holds 0x0
	
	@ TEXT section
	  .text

.globl _main

_main:
	LDR R0, =STRING
	LDR R1, [R0]                  @Load in R1 the STRING               
	LDR R2, =NUMBER
	LDR R3, [R2]                  @R3-NUMBER: We will finally load R3 contents to NUMBER addr and load NUMBER to R3 as output.
	LDR R2, =ERROR
	LDR R4, [R2]                  @R4-ERROR: We will finally load R4 contents to ERROR addr and load ERROR to R2 as output.
    MOV R6, #8                    @default loop count, set to 8, i.e., our input string MUST have 8 bits
	
	loop:
	CMP R6, #0                    @check if loop has run 8 times (R6 counter becomes 0)
	BEQ loop_ends                 @if yes, branch to loop_ends
	LDR R5, [R0], #4              @Load the next input bit in R5
	CMP R5, #0x31                 @check if the R5 bit is 1
	BEQ left_shift_and_add        @if yes, branch to left_shift_and_add
	CMP R5, #0x30                 @check if the R5 bit is 0
	BEQ left_shift                @if yes, branch to left_shift
 	B error_bit                   @if we come here, then the bit is neither 0 or 1, branch to error_bit
	
	left_shift_and_add:           @when we see a 1, we come here
  	MOV R3, R3, LSL #4            @We left shift the contents of R3 by 4 (since we output the string in the Hexadecimal view, we LSL by 4 and not 1)
	ADD R3, #0x1                  @then add 1 to R3
	SUB R6, R6, #1                @decrement loop counter
	B loop                        @branch back to loop for next iteration

    left_shift:                   @when we see a 0, we come here
    MOV R3, R3, LSL #4            @we left shift the contents of R3 by 4 (since we output the string in the Hexadecimal view, we LSL by 4 and not 1)
	SUB R6, R6, #1                @decrement loop counter
	B loop                        @branch back to loop for next iteration
	
	error_bit:                    @bit other than 0 or 1 encountered
	MOV R3, #0x00                 @R3, output number register set to 0
    MOV R4, #0xff                 @R4, output error register set to 0xff

	loop_ends:
    LDR R0, = NUMBER
	STR R3, [R0]                  @R3 output number stored in NUMBER addr
	LDR R3, [R0]
	LDR R0, = ERROR               
	STR R4, [R0]                  @R4 output error stored in ERROR addr
	LDR R4, [R0]
	swi 0x11
