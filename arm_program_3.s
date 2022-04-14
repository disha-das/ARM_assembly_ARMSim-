/******************************************************************************
* file: arm_program_3.s
* author: Disha Das
******************************************************************************/

@NUM loaded into R5 as OUTPUT
@WEIGHT loaded into R6 as OUTPUT 


  @ BSS section
      .bss

  @ DATA SECTION
    .data
data_start: .word 0x205A15E3 ;  #(0010 0000 0101 1010 0001 0101 1101 0011 – 13)
            .word 0x256C8700; #0x295468F2 ;  #(0010 1001 0101 0100 0110 1000 1111 0010 – 14)  
data_end:   .word 0x295468F2 ;   #0x256C8700 ;  #(0010 0101 0110 1100 1000 0111 0000 0000 – 11)     more numbers can be added and swapped in order  

Output: NUM: .word 0x0;
        WEIGHT: .word 0x0;
		
  @ TEXT section
      .text

.globl _main


_main:
    LDR R0, = data_start    @R0 holds start load address
	MOV R5, #0              @R5 holds num with max weight     (FINALLY will LOAD output from NUM)
	MOV R6, #0              @R6 holds max weight              (FINALLY will LOAD output from WEIGHT)
	LDR R7, = data_end      @R7 holds end load address
	LDR R8, [R7]            @R8 holds last input value
	
	check_terminate:        @checks for terminate case after updating max weight:
	CMP R2, R6              @weight of current number compared with current max weight
	BGT update_max_weight
	CMP R4, R8              @terminate case check
	BEQ complete
	
	load:
	LDR R1, [r0], #4        @load number
	MOV R4, R1              @copy of current number
	MOV R2, #0              @R2 holds current weight value init to 0
	
	count_weight:
	AND R3, R1, #1          @the LSB bit of current number is stored in R3
	ADD R2, R3              @LSB bit added to sum of bits of current number
	LSR R1, R1, #1          @current number is logically shifted right
	CMP R1, #0              @if curent number becomes 0, check (update max weight) and terminate
	BEQ check_terminate
	B count_weight          @else continue counting
	
	update_max_weight:      @update max weight
	MOV R6, R2              @new max weight in R2 copied into max weight register R6
	MOV R5, R4              @new number with max weight updated in R5
	CMP R4, R8              @check terminate
	BEQ complete
	B load                  @load next number
	
	complete:
	LDR R9, = WEIGHT        @R9 holds WEIGHT addr  (OUTPUT MAX WEIGHT)
	STR R6, [R9]            @copy at WEIGHT from R6 which has max weight
    LDR R10, = NUM          @R10 holds NUM addr   (OUTPUT NUM)
	STR R5, [R10]           @copy at WEIGHT from R6 (maximum weight)
	LDR R6, [R9]            @LOAD R6 AND CHECK FINAL VALUE AT WEIGHT
	LDR R5, [R10]           @LOAD R5 AND CHECK FINAL VALUE AT NUM
	swi 0x11
