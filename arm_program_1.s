@/******************************************************************************
@* file: arm_program_1.s
@* author: Disha Das
@******************************************************************************/

      .bss
sum: .word

      .data
number: .word 51234

      .text

.globl _main

_main:



@To check sanity and validate result, add breakpoints where specified by the comments



@ ***************Problem1 (XNOR r1, r2, r3)***************
MOV R2, #1   @ R2 content is 0x00000001
MOV R3, #1   @ R3 content is 0x00000001
EOR R2, R3
MVN R1, #0
EOR R1, R2   
@ Add breakpoint in next line to check 0x00000001 XNOR 0x00000001 is 0xffffffff in R1 hexadecimal
@ (Ans for Problem1)





@ ***************Problem2 (ANDN r1, r2, r3: We could use single instruction with BIC operand as well)***************
MOV R2, #1   @ R2 content is 0x00000001
MOV R3, #1   @ R3 content is 0x00000001
MVN R3, R3
AND R1, R2, R3   
@ Add breakpoint in next line to check 0x00000001 ANDN 0x00000001 is 0x00000000 in R1 hexadecimal
@ (Ans for Problem2)





@ ***************Problem3 (MULF r1, r2, 45 : Multiply register contents with 45)***************
MOV R2, #3              @ R2 content is 3 (Multiply 3 with 45)
MOV R1, #0
MOV R3, R2, LSL #0
ADD R1, R3
MOV R3, R2, LSL #2
ADD R1, R3
MOV R3, R2, LSL #3
ADD R1, R3
MOV R3, R2, LSL #5
ADD R1, R3
@ Add breakpoint in next line to check 3*45 = 135 in R1 unsinged decimal 
@ (Ans for Problem3)






@ ***************Problem4 (DIV r1, r2, 45: Divide register contes with 45)***************
MOV R2, #140   @ R2 content is 135 (Divide 135 with 45) 
MOV R1, #0

loop:
	 SUB R2, R2, #45
	 ADD R1, #1
	
check:
	CMP R2, #45
	BGE loop
@ Add breakpoint in next line to check quotient of 140/45 = 3 in R1 unsigned decimal 
@ (Ans for Problem4)



	

	
@ ***************Problem5 (ABS r1, r2: Absolute value)***************
MOV R2, #-6      @  R2 content is decimal -6
MVN R2, R2       @ 1s complement taken
ADD R1, R2, #1   @ 2s complement gives absolute value
@ absolute value in R1 signed decimal
@ (Ans for Problem5)

.end


