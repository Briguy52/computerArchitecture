.data
ask: .asciiz "How many palindromes would you like?"
nln: .asciiz "\n"

.text
	.globl main

main:
	la $a0, ask
	li $v0, 4
	syscall
	li $v0, 5  # 1) load in word/argument            
	syscall  
	move $s0, $v0 # 'N' - number of palindromes desired
	li $s1, 0 # 2) 'M' - number of palindromes we hae so far
	li $t0, 10 # 3) 'i' - iterator variable, start at 10
	j loop
	
loop: 
	beq $s0, $s1, end # 4) exit if found desired num palindromes
	addi $t0, $t0, 1 # increment iterator by one
	move $t1, $t0
	li $t2, 0 
	j while 
	while:
		beq $0, $t1, checkPal
		li $t3, 10 # t3 = 10 
		
		mult $t2, $t3 # t2 = t2 * 10
		mflo $t2 
		
		div $t1, $t3 # t2 = t2 + t1 % 10
		mfhi $t4
		add $t2, $t2, $t4
		
		div $t1, $t3 # t1 = t1 / 10
		mflo $t1

		j while
	checkPal:
		beq $t0, $t2, print
		j loop
		
print:
	addi $s1, $s1, 1
	la $a0, nln
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
	j loop
	 
end:
	li $v0, 10 # service for leaving
	syscall