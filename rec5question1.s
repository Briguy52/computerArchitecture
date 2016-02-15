.data

.text
	.globl main

main:
	# li $t0, 10 # t0 is a constant 10
	# li $t1, 0 # t1 is our counter (i)
	li $s0, 5
	li $a0, 4
	li $a1, 5
	jal foo
	move $a0, $v0
	li $v0, 1
	syscall
	j end
	
foo: 
	addi $sp, $sp, -8 # grow the stack DOWN by 8 bytes!
	sw $ra, 0($sp) # store return address in the stack
	sw $s0, 4($sp) # store a copy of $s0 - callee saved (from byte 4-8)
	
	add $s0, $a0, $a1 # add two arguments and store
	move $v0, $s0
	
	lw $s0, 4($sp) # restore $s0 from the stack
	lw $ra, 0($sp) # restore return address 
	addi $sp, $sp, 8
	jr $ra
	 
end:
	li $v0, 10 # service for leaving
	syscall