/******************************************************************************
* file: arm_problem_5_part3.s
* author: Disha Das
******************************************************************************/

	@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	Input:	
		BCDNUM: .word 92529679   @(BCD rep: 1001 0010 0101 0010 1001 0110 0111 1001)
	Output:	
		NUMBER: .word 0x00000000 @default set to zero, for example it should be ‭0x583E40F‬ 
	
	@ TEXT section
	  .text	

.globl _main

_main:
	LDR R0, =BCDNUM
	LDR R1, [R0]
	@at this point ‭the BCD input as a decimal number is trivially converted by ARM into HEX
	@thus, for any BCD number input in the decimal format, ARM auto converts it to HEX
	
	LDR R0, = NUMBER               
	STR R1, [R0]                  @R1 output NUMBER stored in NUMBER address
	LDR R3, [R0]                  @Load from NUMBER into R3 to display output
	swi 0x11
	
