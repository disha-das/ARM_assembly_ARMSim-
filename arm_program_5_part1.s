/******************************************************************************
* file: arm_program_5_part1.s
* author: Disha Das
******************************************************************************/


	@ BSS section
	.bss
	
	@ASCII printable characters have a range of 32 to 126 , i.e., (0x20 to 0x7E)
	@Out of these, the Hexadecimal digits are 0,1,2 ...9, A,B,C,D,E,F (we also consider lower case a,b,c,d,e,f)
	@Hence, for the hexadecimal digits, the ascii values range from 48(0x30) to 57(0x39) (for 0 to 9) and 65(0x41) to 70(0x46) for (A to F) and 97(0x61) to 102(0x66) for (a to f)
	@These three ranges we consider as our input.
	@For these we load the Hexadecimal digit as output in R2 register (=H_DIGIT) memory address
	@Hence, we assume that A_DIGIT will have an ASCII representation of a hexadecimal digit, i.e., it falls in the correct ranges.

	@ DATA SECTION
	.data
	Input:	
		A_DIGIT: .word 0x43
	Output:
		H_DIGIT: .word 0xFF

	@ TEXT section
	.text

.globl _main

_main:
	LDR R0, =A_DIGIT
	LDR R1, [R0]                              @R1 holds the ascci representation of a HEX digit in hexadecimal format
	LDR R0, =H_DIGIT
	LDR R2, [R0]                              @R2 (OUTPUT Register) with a default value of 0xFF is loaded from H_DIGIT memory addr
	CMP R1, #0x30                             @R1 input checked if greater than or equal to 0x30 (or 48)
	BGE lower_bound_check_pass                @if lower, branch to lower_bound_check_pass
	B false_input                             @else, R1 is not falling in either of three ranges, branch to false_input
		
	lower_bound_check_pass:
	CMP R1, #0x39                             @Here, we check if R1 is Less than or equal to 0x39 (or 57)	
	BLE first_range                           @if yes, R1 falls in the first range, branch to first_range
	CMP R1, #0x41                             @if no, compare if R1 is greater than or equal to 0x41 (or 65)
	BGE second_range_lower_bound_check_pass   @if yes, R1 might lie in the second range, branch to second_range_lower_bound_check_pass
	B false_input                             @if no, R1 lies in a false range between range 1 and range 2 (0x40), branch to false_input
	
	second_range_lower_bound_check_pass:
	CMP R1, #0x46                             @Here, we check if R1 is Less than or equal to 0x46 (or 70)
	BLE second_range                          @if yes, R1 falls in the second range, branch to second_range
	CMP R1, #0x61                             @if no, compare if R1 is greater than or equal to 0x61 (or 97)
	BGE third_range_lower_bound_check_pass    @if yes, R1 might lie in the third range, branch to third_range_lower_bound_check_pass
	B false_input                             @if no, R1 lies in a false range between range 2 and range 3 (0x47 to 0x60), branch to false_input
	
	third_range_lower_bound_check_pass:
	CMP R1, #0x66                             @Here, we check if R1 is Less than or equal to 0x66 (or 102)
	BLE third_range                           @if yes, R1 falls in the third range, branch to third_range
	B false_input                             @else, R1 is not falling in either of three ranges, branch to false_input
	
	first_range:                              @R1 belongs to the first range, i.e, output ranges from 0 to 9
	SUB R2, R1, #0x30                         @Subtract from R1, #30 to get output and store in R2
	LDR R0, = H_DIGIT                         @R2 output stored in H_DIGIT
	STR R2, [R0]
	LDR R3, [R0]                              @Load H_DIGIT content in R3 to check output
	swi 0x11
	
	second_range:                             @R1 belongs to the second range, i.e, output ranges from A to F
	SUB R2, R1, #0x37                         @Subtract from R1, #37 to get output and store in R2
    LDR R0, = H_DIGIT                         @R2 output stored in H_DIGIT
	STR R2, [R0]
	LDR R3, [R0]                              @Load H_DIGIT content in R3 to check output
	swi 0x11

    third_range:                              @R1 belongs to the third range, i.e, output ranges from A to F                        
	SUB R2, R1, #0x57                         @Subtract from R1, #57 to get output and store in R2
	LDR R0, = H_DIGIT                         
	STR R2, [R0]                              @R2 output stored in H_DIGIT addr
	LDR R3, [R0]                              @Load H_DIGIT content in R3 to check output
	swi 0x11
	
	false_input:                              @exit with false value 0xff in R2 and H_DIGIT
	swi 0x11
