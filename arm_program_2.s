/******************************************************************************
* file: arm_program_2.s
* author: Disha Das
******************************************************************************/


@  R1  -  R1 holds MINIMUM VALUE
@  R2  -  R2 holds MAXIMUM VALUE
@  R3  -  R3 holds NUMBER of INTEGERS apart from 0


  @ BSS section
      .bss

  @ DATA SECTION
      .data
data_items: .word 10, 4, 28, 100, 8, 0             @ These values can be changed for a different input set.
                                                   

  @ TEXT section
      .text

.globl _main

_main:
    LDR R0, = data_items
    LDR R1, [r0], #4                 @ R1 will store the min integer value
                                     @ (R1 initialized as the first integer)
	MOV R2, R1                       @ R2 will store the max interger value
	                                 @ (R2 initialized as the first integer)
	MOV R3, #1                       @ R3 will hold the no. of integers in array apart from the terminating 0

check:
	LDR R4, [R0], #4                 @ scans through data_items only once
	CMP R4, #0
	BEQ complete
	ADD R3, #1
	CMP R4, R2
	BGT update_max
	CMP R4, R1
	BLT update_min
	B check
    

update_min:
	MOV R1, R4
	B check

update_max:
    MOV R2, R4
	B check
	
complete:
	swi 0x11
	
        @ you can write your own code here
