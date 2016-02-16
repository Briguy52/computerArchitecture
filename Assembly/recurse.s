.data
ask: .asciiz "Type in a value for n?"
nln: .asciiz "\n"

.text
	.globl main

main:
	la $a0, ask
	li $v0, 4
	syscall
	li $v0, 5  # 1) load in word/argument            
	syscall  
	move $a0, $v0 # 'N' - input value
	jal foo
	move $a0, $v0
	li $v0,1
	syscall
	j end 

foo: 
	addi $sp, $sp, -12 # grow the stack DOWN by 8 bytes!
	sw $ra, 0($sp) # store return address in the stack
	sw $s0, 4($sp) # store a copy of $s0 - callee saved (from byte 4-8)
	sw $s1, 8($sp) 
	
	move $s0, $a0 # $s0 = n
	beqz $s0, baseCase
	
	addi $a0, $s0, -1 # foo(n-1)
	jal foo
	
	addi $v0, $v0, -1 # $v0 = foo(n-1) - 1 
	addi $s1, $s0, 1 # $s1 = (n+1)
	li $t3, 3
	mult $s1, $t3 
	mflo $s1 # $s1 = 3 * (n+1)
	add $v0, $v0, $s1
	raiseStack: 
		lw $s1, 8($sp)
		lw $s0, 4($sp) # restore $s0 from the stack
		lw $ra, 0($sp) # restore return address 
		addi $sp, $sp, 12
		jr $ra	

baseCase:
	li $v0,1
	j raiseStack	
	 
end:
	li $v0, 10 # service for leaving
	syscall